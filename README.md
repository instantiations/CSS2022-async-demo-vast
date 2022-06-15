
<p align="center">
<!---<img src="assets/logos/128x128.png">-->
 <h1 align="center">Camp Smalltalk Supreme 2022 Async Demos</h1>
  <p align="center">
    Camp Smalltalk Supreme 2022 Async Demos
    <!---
    <br>
    <a href="docs/"><strong>Explore the docs »</strong></a>
    <br>
    -->
    <br>
    <a href="https://github.com/instantiations/CSS2022-async-demo-vast/issues/new?labels=Type%3A+Defect">Report a defect</a>
    |
    <a href="https://github.com/instantiations/CSS2022-async-demo-vast/issues/new?labels=Type%3A+Feature">Request feature</a>
  </p>
</p>

Material used for the [Intro to Asynchronous Programming with VAST](https://campsmalltalksupreme.wordpress.com/2020/06/28/daily-events/) presentation at the [Camp Smalltalk Supreme 2022](https://campsmalltalksupreme.wordpress.com/) conference.

## License
- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).


## Installation

1. Install [VA Smalltalk 11.0.0 or newer](https://www.instantiations.com/products/vasmalltalk/download.html).
2. Install Tonel support in your development image following [this guide](https://github.com/vasmalltalk/tonel-vast#installation).
3. Clone this repository.
4. The easiest and recommended approach is to install it via a script:

```smalltalk
| loader path |
path := (CfsPath named: '<insert path to root CSS2022-async-demo-vast local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended; "do not prompt and use all defaults"
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
```

Or you can load the Configuration Map `CSS 2022 - Async Demos` from the context menu of the Configuration Maps Browser: `"Import"` -> `"Load Configuration Maps from Tonel repository..."` -> select path to root `CSS2022-async-demo-vast` local repo. This will open a dialog and will use convenient defaults for the load. Refer to [its documentation](https://github.com/instantiations/tonel-vast#using-gui-menus) for more details.



## Demos

All presented demos are in written as methods of the class `CampSmalltalkSupreme2022Examples`. We recoomend to first do Futures, then Promises, then Zones and finally Streams.
