Class {
	#name : 'CampSmalltalkSupreme2022Examples',
	#superclass : 'Object',
	#category : 'CampSmalltalkSupreme2022ExamplesApp'
}

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> asyncZone1Example [
	"IMPORTANT: This example must be run from a workspace and without any other workspace opened"

	"A zone represents an environment that remains stable across asynchronous calls."

	"Associate 6 asynchronous tasks with a Zone. The zone will: 
1) Share data between the tasks with a 'Zone Local Value' ('greetings').
2) Intercept asynchronous task scheduling and redirect it to run on the UI event loop.
3) Intercept task execution and print to Transcript when it happens.
4) Handle uncaught error by dumping the stacktrace onto a file."

	[
		1 to: 6 do: [:i |
			EsFuture on: [| thisEditor value |
				EsTimedWait forMilliseconds: i * 200.
				thisEditor := StsWorkspace allInstances first textWidget.
				value := (EsAsyncZone current at: 'greetings') removeFirst.
				thisEditor
					addText: (value isGrapheme ifTrue: [value utf8 asByteArray] ifFalse: [value])]]]
						asyncZoned: (
							EsAsyncZoneSpec new
								onScheduleTask: [:selfZone :parent :zone :function |
									CwAppContext default asyncExecInUI: [function value]];
								onRun: [:selfZone :parent :zone :function :args |
									Transcript
										show: 'Running an async task!';
										cr.
									parent run: function withArguments: args zone: zone];
								onHandleUncaughtError: [:selfZone :parent :zone :error :stackTrace | |
									  stream |
									stream := CfsReadWriteFileStream openEmpty: 'asyncError.txt'.
									stream nextPutAll: stackTrace asString.
									stream close.
									error exitWith: nil])
						values: (
							Dictionary
								with: 'greetings' -> 'CSS22' utf8AsUnicodeString asOrderedCollection)
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> futures1Basic [

	"A future is an object representing the result of a delayed asynchronous computation."

	| future |

	Transcript
		cr;
		cr;
		show: '================= Futures - 1 - Basic =================';
		cr.
	future :=
		EsFuture on: [
			EsTimedWait forSeconds: 5.
			Transcript asyncShowCr: 'Calculating 5 factorial'.
			5 factorial].
	Transcript
		show: 'Future fired!';
		cr.
	future then: [Transcript asyncShowCr: 'Finished: ' , future value printString]
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> futures2AsyncWorkflow [

	| computeFactorialFuture computeFactorialPlus3Future computeFactorialPlus5Future |

	Transcript
		cr;
		cr;
		show: '================= Futures - 2 - API =================';
		cr.
	computeFactorialFuture :=
		EsFuture on: [
			Transcript asyncShowCr: 'Calculating 5 factorial: '.
			5 factorial].
	computeFactorialPlus3Future :=
		computeFactorialFuture then: [:factorial |
			Transcript asyncShowCr: '5 Factorial + 3: ' , (factorial + 3) printString].
	computeFactorialPlus5Future :=
		computeFactorialFuture then: [:factorial |
			Transcript asyncShowCr: '5 Factorial + 5: ' , (factorial + 5) printString].
	(EsFuture all: { computeFactorialPlus3Future. computeFactorialPlus5Future })
		then: [Transcript asyncShowCr: 'I am done!']
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> futures3Exceptions [

	Transcript
		cr;
		cr;
		show: '================= Futures - 3 - Exceptions =================';
		cr.
	((EsFuture on: [
		"throw error somewhere in the async code"
		Exception signal: 'Oh no'])
		catch: [:exception :stacktrace |
			Transcript asyncShowCr: 'Caught error: ' , exception description])
				ensure: [Transcript asyncShowCr: 'Ensured!']
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> promises1Basic [
	"A promise is a way to produce future objects and to complete them later with a value or error."

	| promise future |

	Transcript
		cr;
		cr;
		show: '================= Promises - 1 - Basic =================';
		cr.
	promise := EsPromise new.
	future := promise future.
	future then: [:number | Transcript asyncShowCr: number printString].
	Transcript
		show: 'About to complete the future';
		cr.

	promise complete: 42
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> promises2OsProcess [

	Transcript
		cr;
		cr;
		show: '================= Promises - 2 - OsProcess =================';
		cr.
	(OsProcessStarter start: #('ping' '127.0.0.1' '-n' '6') "sleep 5 seconds") onCompletion
		then: [:process | Transcript asyncShowCr: 'Process completed: ' , process printString]
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams1Listen [

	"An async stream is a stream of asynchronous events that can also be treated like asynchronous collections"

	| stream |

	Transcript
		cr;
		cr;
		show: '================= Streams - 1 - Listen =================';
		cr.
	stream := EsStream fromCollection: #(1 2 3 4 5).
	Transcript
		show: 'Stream starting';
		cr.
	stream listen: [:event | Transcript asyncShowCr: 'Processing: ' , event printString]
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams2EsStreamController [

	| controller stream |

	"A controller allows sending data, error and done events on its `#stream.` 
It can be used to create a simple stream that others can listen on, and to push events to that stream."

	Transcript
		cr;
		cr;
		show: '================= Streams - 2 - EsStreamController =================';
		cr.
	controller := EsStreamController new.
	stream := controller stream.
	stream do: [:i | Transcript asyncShowCr: 'Processing event: ' , i printString].


	"wait"
	controller add: 1.

	"wait"
	controller add: 5.

	"wait"
	controller add: 10.

	"wait"
	controller close
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams3ErrorHandling [

	| controller stream |

	Transcript
		cr;
		cr;
		show: '================= Streams - 3 - Error Handling =================';
		cr.
	controller := EsStreamController new.
	stream := controller stream.
	stream
		listen: [:event | Transcript asyncShowCr: 'Processing event: ' , event printString]
		onError: [:error :stackTrace | Transcript asyncShowCr: 'Error event: ' , error printString]
		onDone: [Transcript asyncShowCr: 'Stream finished']
		cancelOnError: false.

	"wait"
	controller add: 1.

	"wait"
	controller addError: 'Oops...'.

	"wait"
	controller add: 10.

	"wait"
	controller close
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams4ApiCombinations [

	| controller stream |

	Transcript
		cr;
		cr;
		show: '================= Streams - 4 - API Combination =================';
		cr.
	controller := EsStreamController new.
	stream := controller stream select: [:i | i even].
	stream := stream collect: [:e | e asFloat].
	stream listen: [:i | Transcript asyncShowCr: i printString].
	1 to: 10 do: [:i | controller add: i].
	controller close
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams5ApiAnsweringFutures [

	| controller stream |

	Transcript
		cr;
		cr;
		show: '================= Streams - 5 - API Answering Futures =================';
		cr.
	controller := EsStreamController new.
	stream := controller stream.
	(stream includes: 5) then: [:bool | Transcript asyncShowCr: 'Included: ' , bool printString].

	"wait"
	controller add: 1.

	"wait"
	controller add: 5.

	"wait"
	controller add: 10.

	"wait"
	controller close
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams6PauseSubscription [

	| controller stream subscription |

	"`<EsStreamSubscription>`  is the active object providing the events, 
 and which can be used to stop listening again, or to temporarily pause events from the subscription."

	Transcript
		cr;
		cr;
		show: '================= Streams - 6 - Pause Subscription =================';
		cr.
	controller := EsStreamController new.
	stream := controller stream.
	subscription := stream
		listen: [:i | Transcript asyncShowCr: 'Processing event: ' , i printString].

	"wait"
	controller add: 1.
	EsTimedWait forSeconds: 1.

	subscription pause.

	"wait"
	controller add: 5.

	"wait"
	controller add: 10.

	EsTimedWait forSeconds: 1.
	subscription resume.

	"wait"
	controller close
]

{ #category : 'Examples' }
CampSmalltalkSupreme2022Examples >> streams7Broadcast [

	| controller stream |

	Transcript
		cr;
		cr;
		show: '================= Streams - 7 - Broadcast =================';
		cr.
	controller := EsStreamController new.
	stream := controller stream asBroadcastStream.
	stream do: [:i | Transcript asyncShowCr: 'Listener 1: Processing event: ' , i printString].

	"wait"
	controller add: 1.
	
	EsTimedWait forSeconds: 1.
	
	stream do: [:i | Transcript asyncShowCr: 'Listener 2: Processing event: ' , i printString].

	"wait"
	controller add: 5.

	"wait"
	controller add: 10.

	"wait"
	controller close
]
