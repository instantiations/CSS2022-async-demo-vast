| loader path |
path := (CfsPath named: '<insert path to root CSS2022-async-demo-vast local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended;
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
