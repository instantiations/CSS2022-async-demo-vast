Extension {
	#name : 'EtTranscript'
}

{ #category : '*CampSmalltalkSupreme2022ExamplesApp',
 #vaCategories : ['ET-Internal'] }
EtTranscript >> asyncShowCr: aString [

	CwAppContext default asyncExecInUI: [
		self
			show: aString;
			cr]
]
