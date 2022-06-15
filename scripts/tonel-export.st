| writer path |
path := (CfsPath named: '<insert path to root CSS2022-async-demo-vast local repo here>').
writer := TonelWriter new.
writer
	addLatestConfigurationMapNamed: 'CSS 2022 - Async Demos';
	addApplicationsFromConfigurationMaps.
writer writeProjectInto: path.
