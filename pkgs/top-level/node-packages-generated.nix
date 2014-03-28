{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."Base64"."~0.2.0" =
    self.by-version."Base64"."0.2.0";
  by-version."Base64"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-Base64-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/Base64/-/Base64-0.2.0.tgz";
        name = "Base64-0.2.0.tgz";
        sha1 = "448879efb6803979daaf7f36e7807e8a1d291205";
      })
    ];
    buildInputs =
      (self.nativeDeps."Base64" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "Base64" ];
  };
  by-spec."CSSselect"."0.x" =
    self.by-version."CSSselect"."0.7.0";
  by-version."CSSselect"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-CSSselect-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.7.0.tgz";
        name = "CSSselect-0.7.0.tgz";
        sha1 = "e4054c67b467465f3c9500c0da0aa7878c4babd2";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSselect" or []);
    deps = [
      self.by-version."CSSwhat"."0.4.5"
      self.by-version."domutils"."1.4.1"
      self.by-version."boolbase"."1.0.0"
      self.by-version."nth-check"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSselect" ];
  };
  by-spec."CSSselect"."~0.4.0" =
    self.by-version."CSSselect"."0.4.1";
  by-version."CSSselect"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-CSSselect-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.4.1.tgz";
        name = "CSSselect-0.4.1.tgz";
        sha1 = "f8ab7e1f8418ce63cda6eb7bd778a85d7ec492b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSselect" or []);
    deps = [
      self.by-version."CSSwhat"."0.4.5"
      self.by-version."domutils"."1.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSselect" ];
  };
  by-spec."CSSwhat"."0.4" =
    self.by-version."CSSwhat"."0.4.5";
  by-version."CSSwhat"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-CSSwhat-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.5.tgz";
        name = "CSSwhat-0.4.5.tgz";
        sha1 = "85d7b2799ff3d98055353c802949e39913e16a62";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSwhat" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSwhat" ];
  };
  by-spec."JSONStream"."~0.6.4" =
    self.by-version."JSONStream"."0.6.4";
  by-version."JSONStream"."0.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-JSONStream-0.6.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/JSONStream/-/JSONStream-0.6.4.tgz";
        name = "JSONStream-0.6.4.tgz";
        sha1 = "4b2c8063f8f512787b2375f7ee9db69208fa2dcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."JSONStream" or []);
    deps = [
      self.by-version."jsonparse"."0.0.5"
      self.by-version."through"."2.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "JSONStream" ];
  };
  by-spec."JSONStream"."~0.7.1" =
    self.by-version."JSONStream"."0.7.1";
  by-version."JSONStream"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-JSONStream-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/JSONStream/-/JSONStream-0.7.1.tgz";
        name = "JSONStream-0.7.1.tgz";
        sha1 = "0a6bf7f85459beb1319486927d293c7cef8a0260";
      })
    ];
    buildInputs =
      (self.nativeDeps."JSONStream" or []);
    deps = [
      self.by-version."jsonparse"."0.0.5"
      self.by-version."through"."2.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "JSONStream" ];
  };
  by-spec."StringScanner"."~0.0.3" =
    self.by-version."StringScanner"."0.0.3";
  by-version."StringScanner"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-StringScanner-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/StringScanner/-/StringScanner-0.0.3.tgz";
        name = "StringScanner-0.0.3.tgz";
        sha1 = "bf06ecfdc90046711f4e6175549243b78ceb38aa";
      })
    ];
    buildInputs =
      (self.nativeDeps."StringScanner" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "StringScanner" ];
  };
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.0.4";
  by-version."abbrev"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-abbrev-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.4.tgz";
        name = "abbrev-1.0.4.tgz";
        sha1 = "bd55ae5e413ba1722ee4caba1f6ea10414a59ecd";
      })
    ];
    buildInputs =
      (self.nativeDeps."abbrev" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "abbrev" ];
  };
  by-spec."abbrev"."1.0.x" =
    self.by-version."abbrev"."1.0.4";
  by-spec."abbrev"."~1.0.4" =
    self.by-version."abbrev"."1.0.4";
  by-spec."accepts"."1.0.0" =
    self.by-version."accepts"."1.0.0";
  by-version."accepts"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-accepts-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.0.0.tgz";
        name = "accepts-1.0.0.tgz";
        sha1 = "3604c765586c3b9cf7877b6937cdbd4587f947dc";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = [
      self.by-version."mime"."1.2.11"
      self.by-version."negotiator"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
  by-spec."active-x-obfuscator"."0.0.1" =
    self.by-version."active-x-obfuscator"."0.0.1";
  by-version."active-x-obfuscator"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-active-x-obfuscator-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/active-x-obfuscator/-/active-x-obfuscator-0.0.1.tgz";
        name = "active-x-obfuscator-0.0.1.tgz";
        sha1 = "089b89b37145ff1d9ec74af6530be5526cae1f1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."active-x-obfuscator" or []);
    deps = [
      self.by-version."zeparser"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "active-x-obfuscator" ];
  };
  by-spec."addressparser"."~0.2.0" =
    self.by-version."addressparser"."0.2.1";
  by-version."addressparser"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-addressparser-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/addressparser/-/addressparser-0.2.1.tgz";
        name = "addressparser-0.2.1.tgz";
        sha1 = "d11a5b2eeda04cfefebdf3196c10ae13db6cd607";
      })
    ];
    buildInputs =
      (self.nativeDeps."addressparser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "addressparser" ];
  };
  by-spec."adm-zip"."0.2.1" =
    self.by-version."adm-zip"."0.2.1";
  by-version."adm-zip"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-adm-zip-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.2.1.tgz";
        name = "adm-zip-0.2.1.tgz";
        sha1 = "e801cedeb5bd9a4e98d699c5c0f4239e2731dcbf";
      })
    ];
    buildInputs =
      (self.nativeDeps."adm-zip" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "adm-zip" ];
  };
  by-spec."adm-zip"."~0.4.3" =
    self.by-version."adm-zip"."0.4.4";
  by-version."adm-zip"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-adm-zip-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.4.4.tgz";
        name = "adm-zip-0.4.4.tgz";
        sha1 = "a61ed5ae6905c3aea58b3a657d25033091052736";
      })
    ];
    buildInputs =
      (self.nativeDeps."adm-zip" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "adm-zip" ];
  };
  by-spec."almond"."*" =
    self.by-version."almond"."0.2.9";
  by-version."almond"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-almond-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/almond/-/almond-0.2.9.tgz";
        name = "almond-0.2.9.tgz";
        sha1 = "ee4543d653a2306d682091c11050d441034f5ed8";
      })
    ];
    buildInputs =
      (self.nativeDeps."almond" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "almond" ];
  };
  "almond" = self.by-version."almond"."0.2.9";
  by-spec."amdefine"."*" =
    self.by-version."amdefine"."0.1.0";
  by-version."amdefine"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-amdefine-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-0.1.0.tgz";
        name = "amdefine-0.1.0.tgz";
        sha1 = "3ca9735cf1dde0edf7a4bf6641709c8024f9b227";
      })
    ];
    buildInputs =
      (self.nativeDeps."amdefine" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "amdefine" ];
  };
  "amdefine" = self.by-version."amdefine"."0.1.0";
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."0.1.0";
  by-spec."ansi"."~0.2.1" =
    self.by-version."ansi"."0.2.1";
  by-version."ansi"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.2.1.tgz";
        name = "ansi-0.2.1.tgz";
        sha1 = "3ab568ec18cd0ab7753c83117d57dad684a1c017";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi" ];
  };
  by-spec."ansi-remover"."*" =
    self.by-version."ansi-remover"."0.0.2";
  by-version."ansi-remover"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansi-remover-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-remover/-/ansi-remover-0.0.2.tgz";
        name = "ansi-remover-0.0.2.tgz";
        sha1 = "7020086289f10e195d85d828de065ccdd50e6e66";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-remover" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-remover" ];
  };
  "ansi-remover" = self.by-version."ansi-remover"."0.0.2";
  by-spec."ansi-styles"."~0.1.0" =
    self.by-version."ansi-styles"."0.1.2";
  by-version."ansi-styles"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansi-styles-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-0.1.2.tgz";
        name = "ansi-styles-0.1.2.tgz";
        sha1 = "5bab27c2e0bbe944ee42057cf23adee970abc7c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  by-spec."ansi-styles"."~0.2.0" =
    self.by-version."ansi-styles"."0.2.0";
  by-version."ansi-styles"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansi-styles-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-0.2.0.tgz";
        name = "ansi-styles-0.2.0.tgz";
        sha1 = "359ab4b15dcd64ba6d74734b72c36360a9af2c19";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  by-spec."ansi-styles"."~1.0.0" =
    self.by-version."ansi-styles"."1.0.0";
  by-version."ansi-styles"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansi-styles-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-1.0.0.tgz";
        name = "ansi-styles-1.0.0.tgz";
        sha1 = "cb102df1c56f5123eab8b67cd7b98027a0279178";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  by-spec."ansicolors"."~0.2.1" =
    self.by-version."ansicolors"."0.2.1";
  by-version."ansicolors"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansicolors-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansicolors/-/ansicolors-0.2.1.tgz";
        name = "ansicolors-0.2.1.tgz";
        sha1 = "be089599097b74a5c9c4a84a0cdbcdb62bd87aef";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansicolors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansicolors" ];
  };
  by-spec."ansicolors"."~0.3.2" =
    self.by-version."ansicolors"."0.3.2";
  by-version."ansicolors"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansicolors-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansicolors/-/ansicolors-0.3.2.tgz";
        name = "ansicolors-0.3.2.tgz";
        sha1 = "665597de86a9ffe3aa9bfbe6cae5c6ea426b4979";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansicolors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansicolors" ];
  };
  by-spec."ansistyles"."~0.1.3" =
    self.by-version."ansistyles"."0.1.3";
  by-version."ansistyles"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-ansistyles-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansistyles/-/ansistyles-0.1.3.tgz";
        name = "ansistyles-0.1.3.tgz";
        sha1 = "5de60415bda071bb37127854c864f41b23254539";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansistyles" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansistyles" ];
  };
  by-spec."apparatus".">= 0.0.6" =
    self.by-version."apparatus"."0.0.8";
  by-version."apparatus"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-apparatus-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/apparatus/-/apparatus-0.0.8.tgz";
        name = "apparatus-0.0.8.tgz";
        sha1 = "14e8aeb84189208b7f8d77f09d9f0307778b079a";
      })
    ];
    buildInputs =
      (self.nativeDeps."apparatus" or []);
    deps = [
      self.by-version."sylvester"."0.0.21"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "apparatus" ];
  };
  by-spec."archiver"."~0.5.2" =
    self.by-version."archiver"."0.5.2";
  by-version."archiver"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-archiver-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archiver/-/archiver-0.5.2.tgz";
        name = "archiver-0.5.2.tgz";
        sha1 = "4e021b1fea5d902201f4886fca6a19fcc760083b";
      })
    ];
    buildInputs =
      (self.nativeDeps."archiver" or []);
    deps = [
      self.by-version."readable-stream"."1.0.26"
      self.by-version."zip-stream"."0.1.4"
      self.by-version."lazystream"."0.1.0"
      self.by-version."file-utils"."0.1.5"
      self.by-version."lodash"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "archiver" ];
  };
  by-spec."archy"."0" =
    self.by-version."archy"."0.0.2";
  by-version."archy"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-archy-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archy/-/archy-0.0.2.tgz";
        name = "archy-0.0.2.tgz";
        sha1 = "910f43bf66141fc335564597abc189df44b3d35e";
      })
    ];
    buildInputs =
      (self.nativeDeps."archy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "archy" ];
  };
  by-spec."archy"."0.0.2" =
    self.by-version."archy"."0.0.2";
  by-spec."argparse"."0.1.15" =
    self.by-version."argparse"."0.1.15";
  by-version."argparse"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-argparse-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/argparse/-/argparse-0.1.15.tgz";
        name = "argparse-0.1.15.tgz";
        sha1 = "28a1f72c43113e763220e5708414301c8840f0a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."argparse" or []);
    deps = [
      self.by-version."underscore"."1.4.4"
      self.by-version."underscore.string"."2.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "argparse" ];
  };
  by-spec."argparse"."~ 0.1.11" =
    self.by-version."argparse"."0.1.15";
  by-spec."array-filter"."~0.0.0" =
    self.by-version."array-filter"."0.0.1";
  by-version."array-filter"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-array-filter-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-filter/-/array-filter-0.0.1.tgz";
        name = "array-filter-0.0.1.tgz";
        sha1 = "7da8cf2e26628ed732803581fd21f67cacd2eeec";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-filter" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "array-filter" ];
  };
  by-spec."array-map"."~0.0.0" =
    self.by-version."array-map"."0.0.0";
  by-version."array-map"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-array-map-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-map/-/array-map-0.0.0.tgz";
        name = "array-map-0.0.0.tgz";
        sha1 = "88a2bab73d1cf7bcd5c1b118a003f66f665fa662";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-map" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "array-map" ];
  };
  by-spec."array-reduce"."~0.0.0" =
    self.by-version."array-reduce"."0.0.0";
  by-version."array-reduce"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-array-reduce-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-reduce/-/array-reduce-0.0.0.tgz";
        name = "array-reduce-0.0.0.tgz";
        sha1 = "173899d3ffd1c7d9383e4479525dbe278cab5f2b";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-reduce" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "array-reduce" ];
  };
  by-spec."asap"."^1.0.0" =
    self.by-version."asap"."1.0.0";
  by-version."asap"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-asap-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asap/-/asap-1.0.0.tgz";
        name = "asap-1.0.0.tgz";
        sha1 = "b2a45da5fdfa20b0496fc3768cc27c12fa916a7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."asap" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "asap" ];
  };
  by-spec."ascii-json"."~0.2" =
    self.by-version."ascii-json"."0.2.0";
  by-version."ascii-json"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ascii-json-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ascii-json/-/ascii-json-0.2.0.tgz";
        name = "ascii-json-0.2.0.tgz";
        sha1 = "10ddb361fd48f72595309fd10a6ea2e7bf2c9218";
      })
    ];
    buildInputs =
      (self.nativeDeps."ascii-json" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ascii-json" ];
  };
  by-spec."ascli"."*" =
    self.by-version."ascli"."0.3.0";
  by-version."ascli"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ascli-0.3.0";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/ascli/-/ascli-0.3.0.tgz";
        name = "ascli-0.3.0.tgz";
        sha1 = "5e66230e5219fe3e8952a4efb4f20fae596a813a";
      })
    ];
    buildInputs =
      (self.nativeDeps."ascli" or []);
    deps = [
      self.by-version."colour"."0.7.1"
      self.by-version."optjs"."3.2.1-boom"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ascli" ];
  };
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-asn1-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        name = "asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "asn1" ];
  };
  by-spec."assert"."*" =
    self.by-version."assert"."1.1.1";
  by-version."assert"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-assert-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert/-/assert-1.1.1.tgz";
        name = "assert-1.1.1.tgz";
        sha1 = "766549ef4a6014b1e19c7c53f9816eabda440760";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert" or []);
    deps = [
      self.by-version."util"."0.10.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assert" ];
  };
  "assert" = self.by-version."assert"."1.1.1";
  by-spec."assert"."~1.1.0" =
    self.by-version."assert"."1.1.1";
  by-spec."assert-plus"."0.1.2" =
    self.by-version."assert-plus"."0.1.2";
  by-version."assert-plus"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-assert-plus-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.2.tgz";
        name = "assert-plus-0.1.2.tgz";
        sha1 = "d93ffdbb67ac5507779be316a7d65146417beef8";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert-plus" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assert-plus" ];
  };
  by-spec."assertion-error"."1.0.0" =
    self.by-version."assertion-error"."1.0.0";
  by-version."assertion-error"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-assertion-error-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assertion-error/-/assertion-error-1.0.0.tgz";
        name = "assertion-error-1.0.0.tgz";
        sha1 = "c7f85438fdd466bc7ca16ab90c81513797a5d23b";
      })
    ];
    buildInputs =
      (self.nativeDeps."assertion-error" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assertion-error" ];
  };
  by-spec."astw"."~0.1.0" =
    self.by-version."astw"."0.1.0";
  by-version."astw"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-astw-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/astw/-/astw-0.1.0.tgz";
        name = "astw-0.1.0.tgz";
        sha1 = "098be2758a6e9e9e15465d4fc4ba36265de11085";
      })
    ];
    buildInputs =
      (self.nativeDeps."astw" or []);
    deps = [
      self.by-version."esprima-six"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "astw" ];
  };
  by-spec."async"."*" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-async-0.2.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
        name = "async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  "async" = self.by-version."async"."0.2.10";
  by-spec."async"."0.1.15" =
    self.by-version."async"."0.1.15";
  by-version."async"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-async-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.15.tgz";
        name = "async-0.1.15.tgz";
        sha1 = "2180eaca2cf2a6ca5280d41c0585bec9b3e49bd3";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."0.1.22" =
    self.by-version."async"."0.1.22";
  by-version."async"."0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "node-async-0.1.22";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
        name = "async-0.1.22.tgz";
        sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."0.1.x" =
    self.by-version."async"."0.1.22";
  by-spec."async"."0.2.9" =
    self.by-version."async"."0.2.9";
  by-version."async"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        name = "async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.10";
  by-spec."async"."^0.2.10" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.1.22" =
    self.by-version."async"."0.1.22";
  by-spec."async"."~0.2.10" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.6" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.7" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.8" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.9" =
    self.by-version."async"."0.2.10";
  by-spec."aws-sdk"."*" =
    self.by-version."aws-sdk"."2.0.0-rc9";
  by-version."aws-sdk"."2.0.0-rc9" = lib.makeOverridable self.buildNodePackage {
    name = "node-aws-sdk-2.0.0-rc9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-2.0.0-rc9.tgz";
        name = "aws-sdk-2.0.0-rc9.tgz";
        sha1 = "caa7653837f7886e7f9e4da5df3b3c8324d7d0ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sdk" or []);
    deps = [
      self.by-version."xml2js"."0.2.4"
      self.by-version."xmlbuilder"."0.4.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sdk" ];
  };
  "aws-sdk" = self.by-version."aws-sdk"."2.0.0-rc9";
  by-spec."aws-sdk".">=1.2.0 <2" =
    self.by-version."aws-sdk"."1.18.0";
  by-version."aws-sdk"."1.18.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-aws-sdk-1.18.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-1.18.0.tgz";
        name = "aws-sdk-1.18.0.tgz";
        sha1 = "00f35b2d27ac91b1f0d3ef2084c98cf1d1f0adc3";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sdk" or []);
    deps = [
      self.by-version."xml2js"."0.2.4"
      self.by-version."xmlbuilder"."0.4.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sdk" ];
  };
  by-spec."aws-sign"."~0.2.0" =
    self.by-version."aws-sign"."0.2.0";
  by-version."aws-sign"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-aws-sign-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.2.0.tgz";
        name = "aws-sign-0.2.0.tgz";
        sha1 = "c55013856c8194ec854a0cbec90aab5a04ce3ac5";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
  by-spec."aws-sign"."~0.3.0" =
    self.by-version."aws-sign"."0.3.0";
  by-version."aws-sign"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-aws-sign-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.3.0.tgz";
        name = "aws-sign-0.3.0.tgz";
        sha1 = "3d81ca69b474b1e16518728b51c24ff0bbedc6e9";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-aws-sign2-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
        name = "aws-sign2-0.5.0.tgz";
        sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign2" ];
  };
  by-spec."backbone"."*" =
    self.by-version."backbone"."1.1.2";
  by-version."backbone"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-backbone-1.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backbone/-/backbone-1.1.2.tgz";
        name = "backbone-1.1.2.tgz";
        sha1 = "c2c04c66bf87268fb82c177acebeff7d37ba6f2d";
      })
    ];
    buildInputs =
      (self.nativeDeps."backbone" or []);
    deps = [
      self.by-version."underscore"."1.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "backbone" ];
  };
  "backbone" = self.by-version."backbone"."1.1.2";
  by-spec."backoff"."2.1.0" =
    self.by-version."backoff"."2.1.0";
  by-version."backoff"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-backoff-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backoff/-/backoff-2.1.0.tgz";
        name = "backoff-2.1.0.tgz";
        sha1 = "19b4e9f9fb75c122ad7bb1c6c376d6085d43ea09";
      })
    ];
    buildInputs =
      (self.nativeDeps."backoff" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "backoff" ];
  };
  by-spec."base64-js"."~0.0.4" =
    self.by-version."base64-js"."0.0.6";
  by-version."base64-js"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-base64-js-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64-js/-/base64-js-0.0.6.tgz";
        name = "base64-js-0.0.6.tgz";
        sha1 = "7b859f79f0bbbd55867ba67a7fab397e24a20947";
      })
    ];
    buildInputs =
      (self.nativeDeps."base64-js" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "base64-js" ];
  };
  by-spec."base64id"."0.1.0" =
    self.by-version."base64id"."0.1.0";
  by-version."base64id"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-base64id-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64id/-/base64id-0.1.0.tgz";
        name = "base64id-0.1.0.tgz";
        sha1 = "02ce0fdeee0cef4f40080e1e73e834f0b1bfce3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."base64id" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "base64id" ];
  };
  by-spec."basic-auth-connect"."1.0.0" =
    self.by-version."basic-auth-connect"."1.0.0";
  by-version."basic-auth-connect"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-basic-auth-connect-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/basic-auth-connect/-/basic-auth-connect-1.0.0.tgz";
        name = "basic-auth-connect-1.0.0.tgz";
        sha1 = "fdb0b43962ca7b40456a7c2bb48fe173da2d2122";
      })
    ];
    buildInputs =
      (self.nativeDeps."basic-auth-connect" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "basic-auth-connect" ];
  };
  by-spec."batch"."0.5.0" =
    self.by-version."batch"."0.5.0";
  by-version."batch"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-batch-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/batch/-/batch-0.5.0.tgz";
        name = "batch-0.5.0.tgz";
        sha1 = "fd2e05a7a5d696b4db9314013e285d8ff3557ec3";
      })
    ];
    buildInputs =
      (self.nativeDeps."batch" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "batch" ];
  };
  by-spec."bcrypt"."*" =
    self.by-version."bcrypt"."0.7.7";
  by-version."bcrypt"."0.7.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-bcrypt-0.7.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bcrypt/-/bcrypt-0.7.7.tgz";
        name = "bcrypt-0.7.7.tgz";
        sha1 = "966a2e709b8cf62c2e05408baf7c5ed663b3c868";
      })
    ];
    buildInputs =
      (self.nativeDeps."bcrypt" or []);
    deps = [
      self.by-version."bindings"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bcrypt" ];
  };
  "bcrypt" = self.by-version."bcrypt"."0.7.7";
  by-spec."binary"."~0.3.0" =
    self.by-version."binary"."0.3.0";
  by-version."binary"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-binary-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/binary/-/binary-0.3.0.tgz";
        name = "binary-0.3.0.tgz";
        sha1 = "9f60553bc5ce8c3386f3b553cff47462adecaa79";
      })
    ];
    buildInputs =
      (self.nativeDeps."binary" or []);
    deps = [
      self.by-version."chainsaw"."0.1.0"
      self.by-version."buffers"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "binary" ];
  };
  by-spec."bindings"."*" =
    self.by-version."bindings"."1.1.1";
  by-version."bindings"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-bindings-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.1.1.tgz";
        name = "bindings-1.1.1.tgz";
        sha1 = "951f7ae010302ffc50b265b124032017ed2bf6f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  by-spec."bindings"."1.0.0" =
    self.by-version."bindings"."1.0.0";
  by-version."bindings"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-bindings-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.0.0.tgz";
        name = "bindings-1.0.0.tgz";
        sha1 = "c3ccde60e9de6807c6f1aa4ef4843af29191c828";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  by-spec."block-stream"."*" =
    self.by-version."block-stream"."0.0.7";
  by-version."block-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-block-stream-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        name = "block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
      })
    ];
    buildInputs =
      (self.nativeDeps."block-stream" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "block-stream" ];
  };
  by-spec."block-stream"."0.0.7" =
    self.by-version."block-stream"."0.0.7";
  by-spec."blueimp-md5"."~1.1.0" =
    self.by-version."blueimp-md5"."1.1.0";
  by-version."blueimp-md5"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-blueimp-md5-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/blueimp-md5/-/blueimp-md5-1.1.0.tgz";
        name = "blueimp-md5-1.1.0.tgz";
        sha1 = "041ed794862f3c5f2847282a7481329f1d2352cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."blueimp-md5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "blueimp-md5" ];
  };
  by-spec."boolbase"."~1.0.0" =
    self.by-version."boolbase"."1.0.0";
  by-version."boolbase"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-boolbase-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz";
        name = "boolbase-1.0.0.tgz";
        sha1 = "68dff5fbe60c51eb37725ea9e3ed310dcc1e776e";
      })
    ];
    buildInputs =
      (self.nativeDeps."boolbase" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "boolbase" ];
  };
  by-spec."boom"."0.3.x" =
    self.by-version."boom"."0.3.8";
  by-version."boom"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-boom-0.3.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.3.8.tgz";
        name = "boom-0.3.8.tgz";
        sha1 = "c8cdb041435912741628c044ecc732d1d17c09ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = [
      self.by-version."hoek"."0.7.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-boom-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
        name = "boom-0.4.2.tgz";
        sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = [
      self.by-version."hoek"."0.9.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."bower"."*" =
    self.by-version."bower"."1.3.1";
  by-version."bower"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower/-/bower-1.3.1.tgz";
        name = "bower-1.3.1.tgz";
        sha1 = "60d564e774be4e60631a159566830fce260e469a";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
      self.by-version."archy"."0.0.2"
      self.by-version."bower-config"."0.5.0"
      self.by-version."bower-endpoint-parser"."0.2.1"
      self.by-version."bower-json"."0.4.0"
      self.by-version."bower-logger"."0.2.2"
      self.by-version."bower-registry-client"."0.1.6"
      self.by-version."cardinal"."0.4.4"
      self.by-version."chalk"."0.4.0"
      self.by-version."chmodr"."0.1.0"
      self.by-version."decompress-zip"."0.0.5"
      self.by-version."fstream"."0.1.25"
      self.by-version."fstream-ignore"."0.0.7"
      self.by-version."glob"."3.2.9"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."handlebars"."1.3.0"
      self.by-version."inquirer"."0.4.1"
      self.by-version."junk"."0.2.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."mout"."0.9.0"
      self.by-version."nopt"."2.1.2"
      self.by-version."lru-cache"."2.5.0"
      self.by-version."open"."0.0.4"
      self.by-version."osenv"."0.0.3"
      self.by-version."promptly"."0.2.0"
      self.by-version."q"."1.0.1"
      self.by-version."request"."2.33.0"
      self.by-version."request-progress"."0.3.1"
      self.by-version."retry"."0.6.0"
      self.by-version."rimraf"."2.2.6"
      self.by-version."semver"."2.2.1"
      self.by-version."stringify-object"."0.2.0"
      self.by-version."tar"."0.1.19"
      self.by-version."tmp"."0.0.23"
      self.by-version."update-notifier"."0.1.8"
      self.by-version."which"."1.0.5"
      self.by-version."p-throttler"."0.0.1"
      self.by-version."insight"."0.3.1"
      self.by-version."is-root"."0.1.0"
      self.by-version."shell-quote"."1.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower" ];
  };
  "bower" = self.by-version."bower"."1.3.1";
  by-spec."bower".">=0.9.0" =
    self.by-version."bower"."1.3.1";
  by-spec."bower".">=1.2.8 <2" =
    self.by-version."bower"."1.3.1";
  by-spec."bower"."~1.2.0" =
    self.by-version."bower"."1.2.8";
  by-version."bower"."1.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "bower-1.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower/-/bower-1.2.8.tgz";
        name = "bower-1.2.8.tgz";
        sha1 = "f63c0804a267d5ffaf2fd3fd488367e73dce202f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
      self.by-version."archy"."0.0.2"
      self.by-version."bower-config"."0.5.0"
      self.by-version."bower-endpoint-parser"."0.2.1"
      self.by-version."bower-json"."0.4.0"
      self.by-version."bower-logger"."0.2.2"
      self.by-version."bower-registry-client"."0.1.6"
      self.by-version."cardinal"."0.4.4"
      self.by-version."chalk"."0.2.1"
      self.by-version."chmodr"."0.1.0"
      self.by-version."decompress-zip"."0.0.5"
      self.by-version."fstream"."0.1.25"
      self.by-version."fstream-ignore"."0.0.7"
      self.by-version."glob"."3.2.9"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."handlebars"."1.0.12"
      self.by-version."inquirer"."0.3.5"
      self.by-version."junk"."0.2.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."mout"."0.7.1"
      self.by-version."nopt"."2.1.2"
      self.by-version."lru-cache"."2.3.1"
      self.by-version."open"."0.0.4"
      self.by-version."osenv"."0.0.3"
      self.by-version."promptly"."0.2.0"
      self.by-version."q"."0.9.7"
      self.by-version."request"."2.27.0"
      self.by-version."request-progress"."0.3.1"
      self.by-version."retry"."0.6.0"
      self.by-version."rimraf"."2.2.6"
      self.by-version."semver"."2.1.0"
      self.by-version."stringify-object"."0.1.8"
      self.by-version."sudo-block"."0.2.1"
      self.by-version."tar"."0.1.19"
      self.by-version."tmp"."0.0.23"
      self.by-version."update-notifier"."0.1.8"
      self.by-version."which"."1.0.5"
      self.by-version."p-throttler"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower" ];
  };
  by-spec."bower-config"."~0.4.3" =
    self.by-version."bower-config"."0.4.5";
  by-version."bower-config"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-config-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-config/-/bower-config-0.4.5.tgz";
        name = "bower-config-0.4.5.tgz";
        sha1 = "baa7cee382f53b13bb62a4afaee7c05f20143c13";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-config" or []);
    deps = [
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."mout"."0.6.0"
      self.by-version."optimist"."0.6.1"
      self.by-version."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  by-spec."bower-config"."~0.5.0" =
    self.by-version."bower-config"."0.5.0";
  by-version."bower-config"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-config-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-config/-/bower-config-0.5.0.tgz";
        name = "bower-config-0.5.0.tgz";
        sha1 = "d081d43008816b1beb876dee272219851dd4c89c";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-config" or []);
    deps = [
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."mout"."0.6.0"
      self.by-version."optimist"."0.6.1"
      self.by-version."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  by-spec."bower-endpoint-parser"."0.2.1" =
    self.by-version."bower-endpoint-parser"."0.2.1";
  by-version."bower-endpoint-parser"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-endpoint-parser-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-endpoint-parser/-/bower-endpoint-parser-0.2.1.tgz";
        name = "bower-endpoint-parser-0.2.1.tgz";
        sha1 = "8c4010a2900cdab07ea5d38f0bd03e9bbccef90f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-endpoint-parser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-endpoint-parser" ];
  };
  by-spec."bower-endpoint-parser"."~0.2.0" =
    self.by-version."bower-endpoint-parser"."0.2.1";
  by-spec."bower-json"."0.4.0" =
    self.by-version."bower-json"."0.4.0";
  by-version."bower-json"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-json-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-json/-/bower-json-0.4.0.tgz";
        name = "bower-json-0.4.0.tgz";
        sha1 = "a99c3ccf416ef0590ed0ded252c760f1c6d93766";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-json" or []);
    deps = [
      self.by-version."deep-extend"."0.2.8"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."intersect"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-json" ];
  };
  by-spec."bower-json"."~0.4.0" =
    self.by-version."bower-json"."0.4.0";
  by-spec."bower-logger"."0.2.1" =
    self.by-version."bower-logger"."0.2.1";
  by-version."bower-logger"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-logger-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.1.tgz";
        name = "bower-logger-0.2.1.tgz";
        sha1 = "0c1817c48063a88d96cc3d516c55e57fff5d9ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-logger" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-logger" ];
  };
  by-spec."bower-logger"."~0.2.1" =
    self.by-version."bower-logger"."0.2.2";
  by-version."bower-logger"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-logger-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.2.tgz";
        name = "bower-logger-0.2.2.tgz";
        sha1 = "39be07e979b2fc8e03a94634205ed9422373d381";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-logger" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-logger" ];
  };
  by-spec."bower-logger"."~0.2.2" =
    self.by-version."bower-logger"."0.2.2";
  by-spec."bower-registry-client"."~0.1.4" =
    self.by-version."bower-registry-client"."0.1.6";
  by-version."bower-registry-client"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-bower-registry-client-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-registry-client/-/bower-registry-client-0.1.6.tgz";
        name = "bower-registry-client-0.1.6.tgz";
        sha1 = "c3ae74a98f24f50a373bbcb0ef443558be01d4b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-registry-client" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."bower-config"."0.4.5"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."lru-cache"."2.3.1"
      self.by-version."request"."2.27.0"
      self.by-version."request-replay"."0.2.0"
      self.by-version."rimraf"."2.2.6"
      self.by-version."mkdirp"."0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-registry-client" ];
  };
  by-spec."bower2nix"."*" =
    self.by-version."bower2nix"."2.1.0";
  by-version."bower2nix"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower2nix-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower2nix/-/bower2nix-2.1.0.tgz";
        name = "bower2nix-2.1.0.tgz";
        sha1 = "213f507a729b20a1c3cb48f995a034f9c05f53e6";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower2nix" or []);
    deps = [
      self.by-version."temp"."0.6.0"
      self.by-version."fs.extra"."1.2.1"
      self.by-version."bower-json"."0.4.0"
      self.by-version."bower-endpoint-parser"."0.2.1"
      self.by-version."bower-logger"."0.2.1"
      self.by-version."bower"."1.3.1"
      self.by-version."argparse"."0.1.15"
      self.by-version."clone"."0.1.11"
      self.by-version."semver"."2.2.1"
      self.by-version."fetch-bower"."2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower2nix" ];
  };
  "bower2nix" = self.by-version."bower2nix"."2.1.0";
  by-spec."broadway"."0.2.9" =
    self.by-version."broadway"."0.2.9";
  by-version."broadway"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-broadway-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/broadway/-/broadway-0.2.9.tgz";
        name = "broadway-0.2.9.tgz";
        sha1 = "887008b2257f4171089de5cb9b656969b6c8c9e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."broadway" or []);
    deps = [
      self.by-version."cliff"."0.1.8"
      self.by-version."eventemitter2"."0.4.12"
      self.by-version."nconf"."0.6.9"
      self.by-version."winston"."0.7.2"
      self.by-version."utile"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "broadway" ];
  };
  by-spec."broadway"."0.2.x" =
    self.by-version."broadway"."0.2.9";
  by-spec."browser-pack"."~2.0.0" =
    self.by-version."browser-pack"."2.0.1";
  by-version."browser-pack"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "browser-pack-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-pack/-/browser-pack-2.0.1.tgz";
        name = "browser-pack-2.0.1.tgz";
        sha1 = "5d1c527f56c582677411c4db2a128648ff6bf150";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-pack" or []);
    deps = [
      self.by-version."JSONStream"."0.6.4"
      self.by-version."through"."2.3.4"
      self.by-version."combine-source-map"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "browser-pack" ];
  };
  by-spec."browser-resolve"."~1.2.1" =
    self.by-version."browser-resolve"."1.2.2";
  by-version."browser-resolve"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-browser-resolve-1.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-resolve/-/browser-resolve-1.2.2.tgz";
        name = "browser-resolve-1.2.2.tgz";
        sha1 = "83b1eaed8f120b906f56078e134669db0a4a5c11";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-resolve" or []);
    deps = [
      self.by-version."resolve"."0.6.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "browser-resolve" ];
  };
  by-spec."browser-resolve"."~1.2.2" =
    self.by-version."browser-resolve"."1.2.2";
  by-spec."browserchannel"."*" =
    self.by-version."browserchannel"."1.2.0";
  by-version."browserchannel"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-browserchannel-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserchannel/-/browserchannel-1.2.0.tgz";
        name = "browserchannel-1.2.0.tgz";
        sha1 = "207ce6eb844e00febfdf32084f10d4757cbcf97c";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserchannel" or []);
    deps = [
      self.by-version."hat"."0.0.3"
      self.by-version."connect"."2.14.3"
      self.by-version."request"."2.34.0"
      self.by-version."ascii-json"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "browserchannel" ];
  };
  "browserchannel" = self.by-version."browserchannel"."1.2.0";
  by-spec."browserify"."~3.32.0" =
    self.by-version."browserify"."3.32.1";
  by-version."browserify"."3.32.1" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-3.32.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify/-/browserify-3.32.1.tgz";
        name = "browserify-3.32.1.tgz";
        sha1 = "5d4ad85d5cafee3fc1062e76e56143d0c298bfcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify" or []);
    deps = [
      self.by-version."module-deps"."1.7.1"
      self.by-version."browser-pack"."2.0.1"
      self.by-version."deps-sort"."0.1.1"
      self.by-version."shell-quote"."0.0.1"
      self.by-version."through"."2.3.4"
      self.by-version."duplexer"."0.1.1"
      self.by-version."stream-combiner"."0.0.4"
      self.by-version."concat-stream"."1.4.4"
      self.by-version."insert-module-globals"."3.2.0"
      self.by-version."syntax-error"."0.1.0"
      self.by-version."browser-resolve"."1.2.2"
      self.by-version."inherits"."2.0.1"
      self.by-version."JSONStream"."0.7.1"
      self.by-version."umd"."2.0.0"
      self.by-version."parents"."0.0.2"
      self.by-version."deep-equal"."0.1.2"
      self.by-version."constants-browserify"."0.0.1"
      self.by-version."os-browserify"."0.1.2"
      self.by-version."console-browserify"."1.0.3"
      self.by-version."vm-browserify"."0.0.4"
      self.by-version."zlib-browserify"."0.0.3"
      self.by-version."assert"."1.1.1"
      self.by-version."http-browserify"."1.3.2"
      self.by-version."crypto-browserify"."1.0.9"
      self.by-version."util"."0.10.3"
      self.by-version."events"."1.0.0"
      self.by-version."buffer"."2.1.5"
      self.by-version."url"."0.7.9"
      self.by-version."https-browserify"."0.0.0"
      self.by-version."path-browserify"."0.0.0"
      self.by-version."querystring-es3"."0.2.0"
      self.by-version."stream-browserify"."0.1.3"
      self.by-version."string_decoder"."0.0.1"
      self.by-version."tty-browserify"."0.0.0"
      self.by-version."timers-browserify"."1.0.1"
      self.by-version."punycode"."1.2.4"
      self.by-version."defined"."0.0.0"
      self.by-version."domain-browser"."1.1.1"
      self.by-version."derequire"."0.6.1"
      self.by-version."commondir"."0.0.1"
      self.by-version."shallow-copy"."0.0.1"
      self.by-version."subarg"."0.0.1"
      self.by-version."resolve"."0.6.2"
      self.by-version."glob"."3.2.9"
      self.by-version."builtins"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "browserify" ];
  };
  by-spec."bson"."0.1.8" =
    self.by-version."bson"."0.1.8";
  by-version."bson"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-bson-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.1.8.tgz";
        name = "bson-0.1.8.tgz";
        sha1 = "cf34fdcff081a189b589b4b3e5e9309cd6506c81";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.2" =
    self.by-version."bson"."0.2.2";
  by-version."bson"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-bson-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.2.tgz";
        name = "bson-0.2.2.tgz";
        sha1 = "3dbf984acb9d33a6878b46e6fb7afbd611856a60";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.5" =
    self.by-version."bson"."0.2.5";
  by-version."bson"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-bson-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.5.tgz";
        name = "bson-0.2.5.tgz";
        sha1 = "500d26d883ddc8e02f2c88011627636111c105c5";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.7" =
    self.by-version."bson"."0.2.7";
  by-version."bson"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-bson-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.7.tgz";
        name = "bson-0.2.7.tgz";
        sha1 = "6793161c40e5a9757091d7ee7d52a4717950236b";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = [
      self.by-version."nan"."0.8.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."buffer"."~2.1.4" =
    self.by-version."buffer"."2.1.5";
  by-version."buffer"."2.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-buffer-2.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer/-/buffer-2.1.5.tgz";
        name = "buffer-2.1.5.tgz";
        sha1 = "15373190bc584061de5cbc155db82a0dc1a462de";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer" or []);
    deps = [
      self.by-version."base64-js"."0.0.6"
      self.by-version."ieee754"."1.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffer" ];
  };
  by-spec."buffer-crc32"."0.1.1" =
    self.by-version."buffer-crc32"."0.1.1";
  by-version."buffer-crc32"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-buffer-crc32-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.1.1.tgz";
        name = "buffer-crc32-0.1.1.tgz";
        sha1 = "7e110dc9953908ab7c32acdc70c9f945b1cbc526";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  by-spec."buffer-crc32"."0.2.1" =
    self.by-version."buffer-crc32"."0.2.1";
  by-version."buffer-crc32"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-buffer-crc32-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.1.tgz";
        name = "buffer-crc32-0.2.1.tgz";
        sha1 = "be3e5382fc02b6d6324956ac1af98aa98b08534c";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  by-spec."buffer-crc32"."~0.2.1" =
    self.by-version."buffer-crc32"."0.2.1";
  by-spec."buffers"."~0.1.1" =
    self.by-version."buffers"."0.1.1";
  by-version."buffers"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-buffers-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffers/-/buffers-0.1.1.tgz";
        name = "buffers-0.1.1.tgz";
        sha1 = "b24579c3bed4d6d396aeee6d9a8ae7f5482ab7bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffers" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffers" ];
  };
  by-spec."buffertools"."*" =
    self.by-version."buffertools"."2.1.1";
  by-version."buffertools"."2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-buffertools-2.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-2.1.1.tgz";
        name = "buffertools-2.1.1.tgz";
        sha1 = "10d54433f27ef419e845338a3c6bc6dd2c1f311c";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffertools" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffertools" ];
  };
  "buffertools" = self.by-version."buffertools"."2.1.1";
  by-spec."buffertools".">=1.1.1 <2.0.0" =
    self.by-version."buffertools"."1.1.1";
  by-version."buffertools"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-buffertools-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-1.1.1.tgz";
        name = "buffertools-1.1.1.tgz";
        sha1 = "1071a5f40fe76c39d7a4fe2ea030324d09d6ec9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffertools" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffertools" ];
  };
  by-spec."builtins"."0.0.2" =
    self.by-version."builtins"."0.0.2";
  by-version."builtins"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-builtins-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/builtins/-/builtins-0.0.2.tgz";
        name = "builtins-0.0.2.tgz";
        sha1 = "b738db1ea166b752f7e0144c76f6ad5289448e51";
      })
    ];
    buildInputs =
      (self.nativeDeps."builtins" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "builtins" ];
  };
  by-spec."bunyan"."0.21.1" =
    self.by-version."bunyan"."0.21.1";
  by-version."bunyan"."0.21.1" = lib.makeOverridable self.buildNodePackage {
    name = "bunyan-0.21.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bunyan/-/bunyan-0.21.1.tgz";
        name = "bunyan-0.21.1.tgz";
        sha1 = "ea00a0d5223572e31e1e71efba2237cb1915942a";
      })
    ];
    buildInputs =
      (self.nativeDeps."bunyan" or []);
    deps = [
      self.by-version."mv"."0.0.5"
      self.by-version."dtrace-provider"."0.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bunyan" ];
  };
  by-spec."bytebuffer".">=2.2 <3" =
    self.by-version."bytebuffer"."2.3.1";
  by-version."bytebuffer"."2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-bytebuffer-2.3.1";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/bytebuffer/-/bytebuffer-2.3.1.tgz";
        name = "bytebuffer-2.3.1.tgz";
        sha1 = "17c2c290bfed534b06aadd6513aa5a0096ca2639";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytebuffer" or []);
    deps = [
      self.by-version."long"."1.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bytebuffer" ];
  };
  by-spec."bytes"."0.1.0" =
    self.by-version."bytes"."0.1.0";
  by-version."bytes"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-bytes-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.1.0.tgz";
        name = "bytes-0.1.0.tgz";
        sha1 = "c574812228126d6369d1576925a8579db3f8e5a2";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."0.2.0" =
    self.by-version."bytes"."0.2.0";
  by-version."bytes"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-bytes-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.2.0.tgz";
        name = "bytes-0.2.0.tgz";
        sha1 = "aad33ec14e3dc2ca74e8e7d451f9ba053ad4f7a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."0.2.1" =
    self.by-version."bytes"."0.2.1";
  by-version."bytes"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-bytes-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.2.1.tgz";
        name = "bytes-0.2.1.tgz";
        sha1 = "555b08abcb063f8975905302523e4cd4ffdfdf31";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."~0.2.0" =
    self.by-version."bytes"."0.2.1";
  by-spec."bytes"."~0.2.1" =
    self.by-version."bytes"."0.2.1";
  by-spec."callsite"."~1.0.0" =
    self.by-version."callsite"."1.0.0";
  by-version."callsite"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-callsite-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/callsite/-/callsite-1.0.0.tgz";
        name = "callsite-1.0.0.tgz";
        sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
      })
    ];
    buildInputs =
      (self.nativeDeps."callsite" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "callsite" ];
  };
  by-spec."cardinal"."~0.4.0" =
    self.by-version."cardinal"."0.4.4";
  by-version."cardinal"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "cardinal-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cardinal/-/cardinal-0.4.4.tgz";
        name = "cardinal-0.4.4.tgz";
        sha1 = "ca5bb68a5b511b90fe93b9acea49bdee5c32bfe2";
      })
    ];
    buildInputs =
      (self.nativeDeps."cardinal" or []);
    deps = [
      self.by-version."redeyed"."0.4.4"
      self.by-version."ansicolors"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cardinal" ];
  };
  by-spec."chai"."*" =
    self.by-version."chai"."1.9.1";
  by-version."chai"."1.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-chai-1.9.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chai/-/chai-1.9.1.tgz";
        name = "chai-1.9.1.tgz";
        sha1 = "3711bb6706e1568f34c0b36098bf8f19455c81ae";
      })
    ];
    buildInputs =
      (self.nativeDeps."chai" or []);
    deps = [
      self.by-version."assertion-error"."1.0.0"
      self.by-version."deep-eql"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chai" ];
  };
  "chai" = self.by-version."chai"."1.9.1";
  by-spec."chainsaw"."~0.1.0" =
    self.by-version."chainsaw"."0.1.0";
  by-version."chainsaw"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-chainsaw-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chainsaw/-/chainsaw-0.1.0.tgz";
        name = "chainsaw-0.1.0.tgz";
        sha1 = "5eab50b28afe58074d0d58291388828b5e5fbc98";
      })
    ];
    buildInputs =
      (self.nativeDeps."chainsaw" or []);
    deps = [
      self.by-version."traverse"."0.3.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chainsaw" ];
  };
  by-spec."chalk"."^0.4.0" =
    self.by-version."chalk"."0.4.0";
  by-version."chalk"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-chalk-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.4.0.tgz";
        name = "chalk-0.4.0.tgz";
        sha1 = "5199a3ddcd0c1efe23bc08c1b027b06176e0c64f";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = [
      self.by-version."has-color"."0.1.4"
      self.by-version."ansi-styles"."1.0.0"
      self.by-version."strip-ansi"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.1.1" =
    self.by-version."chalk"."0.1.1";
  by-version."chalk"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-chalk-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.1.1.tgz";
        name = "chalk-0.1.1.tgz";
        sha1 = "fe6d90ae2c270424720c87ed92d36490b7d36ea0";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = [
      self.by-version."has-color"."0.1.4"
      self.by-version."ansi-styles"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.2.0" =
    self.by-version."chalk"."0.2.1";
  by-version."chalk"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-chalk-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.2.1.tgz";
        name = "chalk-0.2.1.tgz";
        sha1 = "7613e1575145b21386483f7f485aa5ffa8cbd10c";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = [
      self.by-version."has-color"."0.1.4"
      self.by-version."ansi-styles"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.3.0" =
    self.by-version."chalk"."0.3.0";
  by-version."chalk"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-chalk-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.3.0.tgz";
        name = "chalk-0.3.0.tgz";
        sha1 = "1c98437737f1199ebcc1d4c48fd41b9f9c8e8f23";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = [
      self.by-version."has-color"."0.1.4"
      self.by-version."ansi-styles"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.4.0" =
    self.by-version."chalk"."0.4.0";
  by-spec."character-parser"."1.2.0" =
    self.by-version."character-parser"."1.2.0";
  by-version."character-parser"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-character-parser-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/character-parser/-/character-parser-1.2.0.tgz";
        name = "character-parser-1.2.0.tgz";
        sha1 = "94134d6e5d870a39be359f7d22460935184ddef6";
      })
    ];
    buildInputs =
      (self.nativeDeps."character-parser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "character-parser" ];
  };
  by-spec."cheerio"."~0.12.0" =
    self.by-version."cheerio"."0.12.4";
  by-version."cheerio"."0.12.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-cheerio-0.12.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.12.4.tgz";
        name = "cheerio-0.12.4.tgz";
        sha1 = "c199626e9e1eb0d4233a91a4793e7f8aaa69a18b";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio" or []);
    deps = [
      self.by-version."cheerio-select"."0.0.3"
      self.by-version."htmlparser2"."3.1.4"
      self.by-version."underscore"."1.4.4"
      self.by-version."entities"."0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  by-spec."cheerio"."~0.13.0" =
    self.by-version."cheerio"."0.13.1";
  by-version."cheerio"."0.13.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-cheerio-0.13.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.13.1.tgz";
        name = "cheerio-0.13.1.tgz";
        sha1 = "48af1134561b3527f83d9156c4f9a8ebd82b06ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio" or []);
    deps = [
      self.by-version."htmlparser2"."3.4.0"
      self.by-version."underscore"."1.5.2"
      self.by-version."entities"."0.5.0"
      self.by-version."CSSselect"."0.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  by-spec."cheerio-select"."*" =
    self.by-version."cheerio-select"."0.0.3";
  by-version."cheerio-select"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-cheerio-select-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio-select/-/cheerio-select-0.0.3.tgz";
        name = "cheerio-select-0.0.3.tgz";
        sha1 = "3f2420114f3ccb0b1b075c245ccfaae5d617a388";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio-select" or []);
    deps = [
      self.by-version."CSSselect"."0.7.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio-select" ];
  };
  by-spec."child-process-close"."~0.1.1" =
    self.by-version."child-process-close"."0.1.1";
  by-version."child-process-close"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-child-process-close-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/child-process-close/-/child-process-close-0.1.1.tgz";
        name = "child-process-close-0.1.1.tgz";
        sha1 = "c153ede7a5eb65ac69e78a38973b1a286377f75f";
      })
    ];
    buildInputs =
      (self.nativeDeps."child-process-close" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "child-process-close" ];
  };
  by-spec."chmodr"."~0.1.0" =
    self.by-version."chmodr"."0.1.0";
  by-version."chmodr"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-chmodr-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chmodr/-/chmodr-0.1.0.tgz";
        name = "chmodr-0.1.0.tgz";
        sha1 = "e09215a1d51542db2a2576969765bcf6125583eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."chmodr" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chmodr" ];
  };
  by-spec."chokidar"."~0.8.0" =
    self.by-version."chokidar"."0.8.2";
  by-version."chokidar"."0.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-chokidar-0.8.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chokidar/-/chokidar-0.8.2.tgz";
        name = "chokidar-0.8.2.tgz";
        sha1 = "767e2509aaa040fd8a23cc46225a783dc1bfc899";
      })
    ];
    buildInputs =
      (self.nativeDeps."chokidar" or []);
    deps = [
      self.by-version."fsevents"."0.2.0"
      self.by-version."recursive-readdir"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chokidar" ];
  };
  by-spec."chownr"."0" =
    self.by-version."chownr"."0.0.1";
  by-version."chownr"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-chownr-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chownr/-/chownr-0.0.1.tgz";
        name = "chownr-0.0.1.tgz";
        sha1 = "51d18189d9092d5f8afd623f3288bfd1c6bf1a62";
      })
    ];
    buildInputs =
      (self.nativeDeps."chownr" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chownr" ];
  };
  by-spec."class-extend"."~0.1.0" =
    self.by-version."class-extend"."0.1.1";
  by-version."class-extend"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-class-extend-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/class-extend/-/class-extend-0.1.1.tgz";
        name = "class-extend-0.1.1.tgz";
        sha1 = "0feb1e59f4ace7bc163b509745f3282c4c7e528a";
      })
    ];
    buildInputs =
      (self.nativeDeps."class-extend" or []);
    deps = [
      self.by-version."lodash"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "class-extend" ];
  };
  by-spec."clean-css"."2.1.x" =
    self.by-version."clean-css"."2.1.7";
  by-version."clean-css"."2.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-2.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-2.1.7.tgz";
        name = "clean-css-2.1.7.tgz";
        sha1 = "beef4e12945c2f8c1ec6101cf0275a38fdf43c65";
      })
    ];
    buildInputs =
      (self.nativeDeps."clean-css" or []);
    deps = [
      self.by-version."commander"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clean-css" ];
  };
  by-spec."clean-css"."~2.1.0" =
    self.by-version."clean-css"."2.1.7";
  by-spec."cli"."0.4.x" =
    self.by-version."cli"."0.4.5";
  by-version."cli"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-cli-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli/-/cli-0.4.5.tgz";
        name = "cli-0.4.5.tgz";
        sha1 = "78f9485cd161b566e9a6c72d7170c4270e81db61";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli" or []);
    deps = [
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli" ];
  };
  by-spec."cli-color"."*" =
    self.by-version."cli-color"."0.2.3";
  by-version."cli-color"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-cli-color-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli-color/-/cli-color-0.2.3.tgz";
        name = "cli-color-0.2.3.tgz";
        sha1 = "0a25ceae5a6a1602be7f77d28563c36700274e88";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli-color" or []);
    deps = [
      self.by-version."es5-ext"."0.9.2"
      self.by-version."memoizee"."0.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli-color" ];
  };
  by-spec."cli-color"."~0.2.2" =
    self.by-version."cli-color"."0.2.3";
  by-spec."cli-color"."~0.2.3" =
    self.by-version."cli-color"."0.2.3";
  by-spec."cli-log"."~0.0.8" =
    self.by-version."cli-log"."0.0.8";
  by-version."cli-log"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-cli-log-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli-log/-/cli-log-0.0.8.tgz";
        name = "cli-log-0.0.8.tgz";
        sha1 = "af738d7f5fcda8aab21bd4dbcd904ee5137c1ad0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli-log" or []);
    deps = [
      self.by-version."cli-color"."0.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli-log" ];
  };
  by-spec."cliff"."0.1.8" =
    self.by-version."cliff"."0.1.8";
  by-version."cliff"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-cliff-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cliff/-/cliff-0.1.8.tgz";
        name = "cliff-0.1.8.tgz";
        sha1 = "43ca8ad9fe3943489693ab62dce0cae22509d272";
      })
    ];
    buildInputs =
      (self.nativeDeps."cliff" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."eyes"."0.1.8"
      self.by-version."winston"."0.6.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cliff" ];
  };
  by-spec."clone"."0.1.11" =
    self.by-version."clone"."0.1.11";
  by-version."clone"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-clone-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.11.tgz";
        name = "clone-0.1.11.tgz";
        sha1 = "408b7d1773eb0dfbf2ddb156c1c47170c17e3a96";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."clone"."0.1.5" =
    self.by-version."clone"."0.1.5";
  by-version."clone"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-clone-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.5.tgz";
        name = "clone-0.1.5.tgz";
        sha1 = "46f29143d0766d663dbd7f80b7520a15783d2042";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."clone"."0.1.6" =
    self.by-version."clone"."0.1.6";
  by-version."clone"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-clone-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.6.tgz";
        name = "clone-0.1.6.tgz";
        sha1 = "4af2296d4a23a64168c2f5fb0a2aa65e80517000";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."cmd-shim"."~1.1.1" =
    self.by-version."cmd-shim"."1.1.1";
  by-version."cmd-shim"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-cmd-shim-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cmd-shim/-/cmd-shim-1.1.1.tgz";
        name = "cmd-shim-1.1.1.tgz";
        sha1 = "348b292db32ed74c8283fcf6c48549b84c6658a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."cmd-shim" or []);
    deps = [
      self.by-version."mkdirp"."0.3.5"
      self.by-version."graceful-fs"."2.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cmd-shim" ];
  };
  by-spec."coffee-script"."*" =
    self.by-version."coffee-script"."1.7.1";
  by-version."coffee-script"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.7.1.tgz";
        name = "coffee-script-1.7.1.tgz";
        sha1 = "62996a861780c75e6d5069d13822723b73404bfc";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = [
      self.by-version."mkdirp"."0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  "coffee-script" = self.by-version."coffee-script"."1.7.1";
  by-spec."coffee-script"."1.6.3" =
    self.by-version."coffee-script"."1.6.3";
  by-version."coffee-script"."1.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        name = "coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  by-spec."coffee-script".">= 0.0.1" =
    self.by-version."coffee-script"."1.7.1";
  by-spec."coffee-script".">=1.2.0" =
    self.by-version."coffee-script"."1.7.1";
  by-spec."coffee-script"."~1.3.3" =
    self.by-version."coffee-script"."1.3.3";
  by-version."coffee-script"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.3.3.tgz";
        name = "coffee-script-1.3.3.tgz";
        sha1 = "150d6b4cb522894369efed6a2101c20bc7f4a4f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  by-spec."coffee-script-redux"."=2.0.0-beta8" =
    self.by-version."coffee-script-redux"."2.0.0-beta8";
  by-version."coffee-script-redux"."2.0.0-beta8" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-redux-2.0.0-beta8";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/coffee-script-redux/-/coffee-script-redux-2.0.0-beta8.tgz";
        name = "coffee-script-redux-2.0.0-beta8.tgz";
        sha1 = "0fd7b8417340dd0d339e8f6fd8b4b8716956e8d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script-redux" or []);
    deps = [
      self.by-version."StringScanner"."0.0.3"
      self.by-version."nopt"."2.1.2"
      self.by-version."esmangle"."0.0.17"
      self.by-version."source-map"."0.1.11"
      self.by-version."escodegen"."0.0.28"
      self.by-version."cscodegen"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script-redux" ];
  };
  by-spec."collections"."^2.0.0" =
    self.by-version."collections"."2.0.1";
  by-version."collections"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-collections-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/collections/-/collections-2.0.1.tgz";
        name = "collections-2.0.1.tgz";
        sha1 = "ee201b142bd1ee5b37a95d62fe13062d87d83db0";
      })
    ];
    buildInputs =
      (self.nativeDeps."collections" or []);
    deps = [
      self.by-version."weak-map"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "collections" ];
  };
  by-spec."color"."~0.5.0" =
    self.by-version."color"."0.5.0";
  by-version."color"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-color-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color/-/color-0.5.0.tgz";
        name = "color-0.5.0.tgz";
        sha1 = "4d283d8bfe4cbc7006de6b6d25a3c26f00e3ee6d";
      })
    ];
    buildInputs =
      (self.nativeDeps."color" or []);
    deps = [
      self.by-version."color-convert"."0.2.1"
      self.by-version."color-string"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color" ];
  };
  by-spec."color-convert"."0.2.x" =
    self.by-version."color-convert"."0.2.1";
  by-version."color-convert"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-color-convert-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-convert/-/color-convert-0.2.1.tgz";
        name = "color-convert-0.2.1.tgz";
        sha1 = "363cab23c94b31a0d64db71048b8c6a940f8c68c";
      })
    ];
    buildInputs =
      (self.nativeDeps."color-convert" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color-convert" ];
  };
  by-spec."color-string"."0.1.x" =
    self.by-version."color-string"."0.1.3";
  by-version."color-string"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-color-string-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-string/-/color-string-0.1.3.tgz";
        name = "color-string-0.1.3.tgz";
        sha1 = "e865d2e3e59f665c3af0de14383f6bf0705685f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."color-string" or []);
    deps = [
      self.by-version."color-convert"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color-string" ];
  };
  by-spec."colors"."0.5.x" =
    self.by-version."colors"."0.5.1";
  by-version."colors"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-colors-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.5.1.tgz";
        name = "colors-0.5.1.tgz";
        sha1 = "7d0023eaeb154e8ee9fce75dcb923d0ed1667774";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-colors-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        name = "colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  by-spec."colors"."0.x.x" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."~0.6.0-1" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."~0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."colour"."*" =
    self.by-version."colour"."0.7.1";
  by-version."colour"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-colour-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colour/-/colour-0.7.1.tgz";
        name = "colour-0.7.1.tgz";
        sha1 = "9cb169917ec5d12c0736d3e8685746df1cadf778";
      })
    ];
    buildInputs =
      (self.nativeDeps."colour" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colour" ];
  };
  by-spec."columnify"."0.1.2" =
    self.by-version."columnify"."0.1.2";
  by-version."columnify"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-columnify-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/columnify/-/columnify-0.1.2.tgz";
        name = "columnify-0.1.2.tgz";
        sha1 = "ab1a1f1e37b26ba4b87c6920fb717fe51c827042";
      })
    ];
    buildInputs =
      (self.nativeDeps."columnify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "columnify" ];
  };
  by-spec."combine-source-map"."~0.3.0" =
    self.by-version."combine-source-map"."0.3.0";
  by-version."combine-source-map"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-combine-source-map-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combine-source-map/-/combine-source-map-0.3.0.tgz";
        name = "combine-source-map-0.3.0.tgz";
        sha1 = "d9e74f593d9cd43807312cb5d846d451efaa9eb7";
      })
    ];
    buildInputs =
      (self.nativeDeps."combine-source-map" or []);
    deps = [
      self.by-version."inline-source-map"."0.3.0"
      self.by-version."convert-source-map"."0.3.3"
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "combine-source-map" ];
  };
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.4";
  by-version."combined-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-combined-stream-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.4.tgz";
        name = "combined-stream-0.0.4.tgz";
        sha1 = "2d1a43347dbe9515a4a2796732e5b88473840b22";
      })
    ];
    buildInputs =
      (self.nativeDeps."combined-stream" or []);
    deps = [
      self.by-version."delayed-stream"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "combined-stream" ];
  };
  by-spec."commander"."0.6.1" =
    self.by-version."commander"."0.6.1";
  by-version."commander"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
        name = "commander-0.6.1.tgz";
        sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."1.3.1" =
    self.by-version."commander"."1.3.1";
  by-version."commander"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-1.3.1.tgz";
        name = "commander-1.3.1.tgz";
        sha1 = "02443e02db96f4b32b674225451abb6e9510000e";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
      self.by-version."keypress"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."1.3.2" =
    self.by-version."commander"."1.3.2";
  by-version."commander"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-1.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-1.3.2.tgz";
        name = "commander-1.3.2.tgz";
        sha1 = "8a8f30ec670a6fdd64af52f1914b907d79ead5b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
      self.by-version."keypress"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.0.0" =
    self.by-version."commander"."2.0.0";
  by-version."commander"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.0.0.tgz";
        name = "commander-2.0.0.tgz";
        sha1 = "d1b86f901f8b64bd941bdeadaf924530393be928";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.1.0" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
        name = "commander-2.1.0.tgz";
        sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.1.x" =
    self.by-version."commander"."2.1.0";
  by-spec."commander"."~0.6.1" =
    self.by-version."commander"."0.6.1";
  by-spec."commander"."~2.1.0" =
    self.by-version."commander"."2.1.0";
  by-spec."commondir"."0.0.1" =
    self.by-version."commondir"."0.0.1";
  by-version."commondir"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-commondir-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commondir/-/commondir-0.0.1.tgz";
        name = "commondir-0.0.1.tgz";
        sha1 = "89f00fdcd51b519c578733fec563e6a6da7f5be2";
      })
    ];
    buildInputs =
      (self.nativeDeps."commondir" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commondir" ];
  };
  by-spec."compressible"."1.0.0" =
    self.by-version."compressible"."1.0.0";
  by-version."compressible"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-compressible-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compressible/-/compressible-1.0.0.tgz";
        name = "compressible-1.0.0.tgz";
        sha1 = "f83e49c1cb61421753545125a8011d68b492427d";
      })
    ];
    buildInputs =
      (self.nativeDeps."compressible" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "compressible" ];
  };
  by-spec."compression"."1.0.0" =
    self.by-version."compression"."1.0.0";
  by-version."compression"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-compression-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compression/-/compression-1.0.0.tgz";
        name = "compression-1.0.0.tgz";
        sha1 = "8aeb85d48db5145d38bc8b181b6352d8eab26020";
      })
    ];
    buildInputs =
      (self.nativeDeps."compression" or []);
    deps = [
      self.by-version."bytes"."0.2.1"
      self.by-version."negotiator"."0.3.0"
      self.by-version."compressible"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "compression" ];
  };
  by-spec."concat-stream"."^1.4.1" =
    self.by-version."concat-stream"."1.4.4";
  by-version."concat-stream"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-concat-stream-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/concat-stream/-/concat-stream-1.4.4.tgz";
        name = "concat-stream-1.4.4.tgz";
        sha1 = "88cf474555dfbbdbeb34453e7f1e417dae97ce21";
      })
    ];
    buildInputs =
      (self.nativeDeps."concat-stream" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
      self.by-version."typedarray"."0.0.5"
      self.by-version."readable-stream"."1.1.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "concat-stream" ];
  };
  by-spec."concat-stream"."~1.4.1" =
    self.by-version."concat-stream"."1.4.4";
  by-spec."config"."0.4.15" =
    self.by-version."config"."0.4.15";
  by-version."config"."0.4.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-config-0.4.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/config/-/config-0.4.15.tgz";
        name = "config-0.4.15.tgz";
        sha1 = "d43ddf58b8df5637fdd1314fc816ccae7bfbcd18";
      })
    ];
    buildInputs =
      (self.nativeDeps."config" or []);
    deps = [
      self.by-version."js-yaml"."0.3.7"
      self.by-version."coffee-script"."1.7.1"
      self.by-version."vows"."0.7.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "config" ];
  };
  by-spec."config-chain"."~1.1.1" =
    self.by-version."config-chain"."1.1.8";
  by-version."config-chain"."1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-config-chain-1.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/config-chain/-/config-chain-1.1.8.tgz";
        name = "config-chain-1.1.8.tgz";
        sha1 = "0943d0b7227213a20d4eaff4434f4a1c0a052cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."config-chain" or []);
    deps = [
      self.by-version."proto-list"."1.2.2"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "config-chain" ];
  };
  by-spec."config-chain"."~1.1.8" =
    self.by-version."config-chain"."1.1.8";
  by-spec."configstore"."~0.2.1" =
    self.by-version."configstore"."0.2.3";
  by-version."configstore"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-configstore-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/configstore/-/configstore-0.2.3.tgz";
        name = "configstore-0.2.3.tgz";
        sha1 = "b1bdc4ad823a25423dc15d220fcc1ae1d7efab02";
      })
    ];
    buildInputs =
      (self.nativeDeps."configstore" or []);
    deps = [
      self.by-version."mkdirp"."0.3.5"
      self.by-version."js-yaml"."3.0.2"
      self.by-version."osenv"."0.0.3"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."uuid"."1.4.1"
      self.by-version."object-assign"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "configstore" ];
  };
  by-spec."configstore"."~0.2.2" =
    self.by-version."configstore"."0.2.3";
  by-spec."connect"."1.x" =
    self.by-version."connect"."1.9.2";
  by-version."connect"."1.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-1.9.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-1.9.2.tgz";
        name = "connect-1.9.2.tgz";
        sha1 = "42880a22e9438ae59a8add74e437f58ae8e52807";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."mime"."1.2.11"
      self.by-version."formidable"."1.0.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.11.0" =
    self.by-version."connect"."2.11.0";
  by-version."connect"."2.11.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.11.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.11.0.tgz";
        name = "connect-2.11.0.tgz";
        sha1 = "9991ce09ff9b85d9ead27f9d41d0b2a2df2f9284";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."qs"."0.6.5"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."cookie"."0.1.0"
      self.by-version."send"."0.1.4"
      self.by-version."bytes"."0.2.1"
      self.by-version."fresh"."0.2.0"
      self.by-version."pause"."0.0.1"
      self.by-version."uid2"."0.0.3"
      self.by-version."debug"."0.7.4"
      self.by-version."methods"."0.0.1"
      self.by-version."raw-body"."0.0.3"
      self.by-version."negotiator"."0.3.0"
      self.by-version."multiparty"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.12.0" =
    self.by-version."connect"."2.12.0";
  by-version."connect"."2.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.12.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.12.0.tgz";
        name = "connect-2.12.0.tgz";
        sha1 = "31d8fa0dcacdf1908d822bd2923be8a2d2a7ed9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."batch"."0.5.0"
      self.by-version."qs"."0.6.6"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."cookie"."0.1.0"
      self.by-version."send"."0.1.4"
      self.by-version."bytes"."0.2.1"
      self.by-version."fresh"."0.2.0"
      self.by-version."pause"."0.0.1"
      self.by-version."uid2"."0.0.3"
      self.by-version."debug"."0.7.4"
      self.by-version."methods"."0.1.0"
      self.by-version."raw-body"."1.1.2"
      self.by-version."negotiator"."0.3.0"
      self.by-version."multiparty"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.14.1" =
    self.by-version."connect"."2.14.1";
  by-version."connect"."2.14.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.14.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.14.1.tgz";
        name = "connect-2.14.1.tgz";
        sha1 = "e6fd676a5735ca703a89eb970f3d283fadecc2c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."basic-auth-connect"."1.0.0"
      self.by-version."cookie-parser"."1.0.1"
      self.by-version."cookie-signature"."1.0.3"
      self.by-version."compression"."1.0.0"
      self.by-version."connect-timeout"."1.0.0"
      self.by-version."csurf"."1.0.0"
      self.by-version."errorhandler"."1.0.0"
      self.by-version."express-session"."1.0.2"
      self.by-version."fresh"."0.2.2"
      self.by-version."method-override"."1.0.0"
      self.by-version."morgan"."1.0.0"
      self.by-version."qs"."0.6.6"
      self.by-version."response-time"."1.0.0"
      self.by-version."serve-index"."1.0.1"
      self.by-version."serve-static"."1.0.2"
      self.by-version."static-favicon"."1.0.0"
      self.by-version."vhost"."1.0.0"
      self.by-version."bytes"."0.2.1"
      self.by-version."pause"."0.0.1"
      self.by-version."debug"."0.7.4"
      self.by-version."raw-body"."1.1.3"
      self.by-version."multiparty"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.3.x" =
    self.by-version."connect"."2.3.9";
  by-version."connect"."2.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.3.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.3.9.tgz";
        name = "connect-2.3.9.tgz";
        sha1 = "4d26ddc485c32e5a1cf1b35854823b4720d25a52";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."qs"."0.4.2"
      self.by-version."formidable"."1.0.11"
      self.by-version."crc"."0.2.0"
      self.by-version."cookie"."0.0.4"
      self.by-version."bytes"."0.1.0"
      self.by-version."send"."0.0.3"
      self.by-version."fresh"."0.1.0"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.7.5" =
    self.by-version."connect"."2.7.5";
  by-version."connect"."2.7.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.7.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.5.tgz";
        name = "connect-2.7.5.tgz";
        sha1 = "139111b4b03f0533a524927a88a646ae467b2c02";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."qs"."0.5.1"
      self.by-version."formidable"."1.0.11"
      self.by-version."cookie-signature"."1.0.0"
      self.by-version."buffer-crc32"."0.1.1"
      self.by-version."cookie"."0.0.5"
      self.by-version."send"."0.1.0"
      self.by-version."bytes"."0.2.0"
      self.by-version."fresh"."0.1.0"
      self.by-version."pause"."0.0.1"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.7.6" =
    self.by-version."connect"."2.7.6";
  by-version."connect"."2.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.7.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.6.tgz";
        name = "connect-2.7.6.tgz";
        sha1 = "b83b68fa6f245c5020e2395472cc8322b0060738";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."qs"."0.5.1"
      self.by-version."formidable"."1.0.11"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."buffer-crc32"."0.1.1"
      self.by-version."cookie"."0.0.5"
      self.by-version."send"."0.1.0"
      self.by-version."bytes"."0.2.0"
      self.by-version."fresh"."0.1.0"
      self.by-version."pause"."0.0.1"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."~2" =
    self.by-version."connect"."2.14.3";
  by-version."connect"."2.14.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-2.14.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.14.3.tgz";
        name = "connect-2.14.3.tgz";
        sha1 = "be8267f116cc905b53b29e0e7c9ea278d71d597b";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."basic-auth-connect"."1.0.0"
      self.by-version."cookie-parser"."1.0.1"
      self.by-version."cookie-signature"."1.0.3"
      self.by-version."compression"."1.0.0"
      self.by-version."connect-timeout"."1.0.0"
      self.by-version."csurf"."1.0.0"
      self.by-version."errorhandler"."1.0.0"
      self.by-version."express-session"."1.0.2"
      self.by-version."fresh"."0.2.2"
      self.by-version."method-override"."1.0.0"
      self.by-version."morgan"."1.0.0"
      self.by-version."qs"."0.6.6"
      self.by-version."response-time"."1.0.0"
      self.by-version."serve-index"."1.0.1"
      self.by-version."serve-static"."1.0.2"
      self.by-version."static-favicon"."1.0.2"
      self.by-version."vhost"."1.0.0"
      self.by-version."bytes"."0.2.1"
      self.by-version."pause"."0.0.1"
      self.by-version."debug"."0.7.4"
      self.by-version."raw-body"."1.1.3"
      self.by-version."multiparty"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."~2.12.0" =
    self.by-version."connect"."2.12.0";
  by-spec."connect-flash"."*" =
    self.by-version."connect-flash"."0.1.1";
  by-version."connect-flash"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-flash-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-flash/-/connect-flash-0.1.1.tgz";
        name = "connect-flash-0.1.1.tgz";
        sha1 = "d8630f26d95a7f851f9956b1e8cc6732f3b6aa30";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-flash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-flash" ];
  };
  "connect-flash" = self.by-version."connect-flash"."0.1.1";
  by-spec."connect-flash"."0.1.0" =
    self.by-version."connect-flash"."0.1.0";
  by-version."connect-flash"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-flash-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-flash/-/connect-flash-0.1.0.tgz";
        name = "connect-flash-0.1.0.tgz";
        sha1 = "82b381d61a12b651437df1c259c1f1c841239b88";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-flash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-flash" ];
  };
  by-spec."connect-jade-static"."*" =
    self.by-version."connect-jade-static"."0.1.3";
  by-version."connect-jade-static"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-jade-static-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-jade-static/-/connect-jade-static-0.1.3.tgz";
        name = "connect-jade-static-0.1.3.tgz";
        sha1 = "ad0e0538c9124355d6da03de13fae63f7b5e0b1b";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-jade-static" or []);
    deps = [
      self.by-version."jade"."1.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-jade-static" ];
  };
  "connect-jade-static" = self.by-version."connect-jade-static"."0.1.3";
  by-spec."connect-mongo"."*" =
    self.by-version."connect-mongo"."0.4.0";
  by-version."connect-mongo"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-mongo-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-mongo/-/connect-mongo-0.4.0.tgz";
        name = "connect-mongo-0.4.0.tgz";
        sha1 = "4cb33728334a8f10f2d9e43d31369dbc2f856336";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-mongo" or []);
    deps = [
      self.by-version."mongodb"."1.3.23"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-mongo" ];
  };
  "connect-mongo" = self.by-version."connect-mongo"."0.4.0";
  by-spec."connect-timeout"."1.0.0" =
    self.by-version."connect-timeout"."1.0.0";
  by-version."connect-timeout"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-connect-timeout-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-timeout/-/connect-timeout-1.0.0.tgz";
        name = "connect-timeout-1.0.0.tgz";
        sha1 = "12054799f90bb9566f8b274efe7842d6465d10bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-timeout" or []);
    deps = [
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-timeout" ];
  };
  by-spec."connection-parse"."0.0.x" =
    self.by-version."connection-parse"."0.0.7";
  by-version."connection-parse"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-connection-parse-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connection-parse/-/connection-parse-0.0.7.tgz";
        name = "connection-parse-0.0.7.tgz";
        sha1 = "18e7318aab06a699267372b10c5226d25a1c9a69";
      })
    ];
    buildInputs =
      (self.nativeDeps."connection-parse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connection-parse" ];
  };
  by-spec."console-browserify"."0.1.x" =
    self.by-version."console-browserify"."0.1.6";
  by-version."console-browserify"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-console-browserify-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/console-browserify/-/console-browserify-0.1.6.tgz";
        name = "console-browserify-0.1.6.tgz";
        sha1 = "d128a3c0bb88350eb5626c6e7c71a6f0fd48983c";
      })
    ];
    buildInputs =
      (self.nativeDeps."console-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "console-browserify" ];
  };
  by-spec."console-browserify"."~1.0.1" =
    self.by-version."console-browserify"."1.0.3";
  by-version."console-browserify"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-console-browserify-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/console-browserify/-/console-browserify-1.0.3.tgz";
        name = "console-browserify-1.0.3.tgz";
        sha1 = "d3898d2c3a93102f364197f8874b4f92b5286a8e";
      })
    ];
    buildInputs =
      (self.nativeDeps."console-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "console-browserify" ];
  };
  by-spec."constantinople"."~1.0.1" =
    self.by-version."constantinople"."1.0.2";
  by-version."constantinople"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-constantinople-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constantinople/-/constantinople-1.0.2.tgz";
        name = "constantinople-1.0.2.tgz";
        sha1 = "0e64747dc836644d3f659247efd95231b48c3e71";
      })
    ];
    buildInputs =
      (self.nativeDeps."constantinople" or []);
    deps = [
      self.by-version."uglify-js"."2.4.13"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "constantinople" ];
  };
  by-spec."constantinople"."~1.0.2" =
    self.by-version."constantinople"."1.0.2";
  by-spec."constantinople"."~2.0.0" =
    self.by-version."constantinople"."2.0.0";
  by-version."constantinople"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-constantinople-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constantinople/-/constantinople-2.0.0.tgz";
        name = "constantinople-2.0.0.tgz";
        sha1 = "0558c3f340095a43acf2386149e5537074330e49";
      })
    ];
    buildInputs =
      (self.nativeDeps."constantinople" or []);
    deps = [
      self.by-version."uglify-js"."2.4.13"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "constantinople" ];
  };
  by-spec."constants-browserify"."~0.0.1" =
    self.by-version."constants-browserify"."0.0.1";
  by-version."constants-browserify"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-constants-browserify-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constants-browserify/-/constants-browserify-0.0.1.tgz";
        name = "constants-browserify-0.0.1.tgz";
        sha1 = "92577db527ba6c4cf0a4568d84bc031f441e21f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."constants-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "constants-browserify" ];
  };
  by-spec."convert-source-map"."~0.3.0" =
    self.by-version."convert-source-map"."0.3.3";
  by-version."convert-source-map"."0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-convert-source-map-0.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/convert-source-map/-/convert-source-map-0.3.3.tgz";
        name = "convert-source-map-0.3.3.tgz";
        sha1 = "f77f130ded4e611d313a1bcf78f988990831c69b";
      })
    ];
    buildInputs =
      (self.nativeDeps."convert-source-map" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "convert-source-map" ];
  };
  by-spec."cookie"."0.0.4" =
    self.by-version."cookie"."0.0.4";
  by-version."cookie"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.0.4.tgz";
        name = "cookie-0.0.4.tgz";
        sha1 = "5456bd47aee2666eac976ea80a6105940483fe98";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie"."0.0.5" =
    self.by-version."cookie"."0.0.5";
  by-version."cookie"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.0.5.tgz";
        name = "cookie-0.0.5.tgz";
        sha1 = "f9acf9db57eb7568c9fcc596256b7bb22e307c81";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie"."0.1.0" =
    self.by-version."cookie"."0.1.0";
  by-version."cookie"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.0.tgz";
        name = "cookie-0.1.0.tgz";
        sha1 = "90eb469ddce905c866de687efc43131d8801f9d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie"."0.1.1" =
    self.by-version."cookie"."0.1.1";
  by-version."cookie"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.1.tgz";
        name = "cookie-0.1.1.tgz";
        sha1 = "cbd4b537aa65f800b6c66ead2520ba8d6afbdf54";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie-jar"."~0.2.0" =
    self.by-version."cookie-jar"."0.2.0";
  by-version."cookie-jar"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-jar-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.2.0.tgz";
        name = "cookie-jar-0.2.0.tgz";
        sha1 = "64ecc06ac978db795e4b5290cbe48ba3781400fa";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  by-spec."cookie-jar"."~0.3.0" =
    self.by-version."cookie-jar"."0.3.0";
  by-version."cookie-jar"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-jar-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.3.0.tgz";
        name = "cookie-jar-0.3.0.tgz";
        sha1 = "bc9a27d4e2b97e186cd57c9e2063cb99fa68cccc";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  by-spec."cookie-parser"."1.0.1" =
    self.by-version."cookie-parser"."1.0.1";
  by-version."cookie-parser"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-parser-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-parser/-/cookie-parser-1.0.1.tgz";
        name = "cookie-parser-1.0.1.tgz";
        sha1 = "17bd622c9717cd0858a912a9fef4c0362360a7b0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-parser" or []);
    deps = [
      self.by-version."cookie"."0.1.0"
      self.by-version."cookie-signature"."1.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-parser" ];
  };
  by-spec."cookie-signature"."1.0.0" =
    self.by-version."cookie-signature"."1.0.0";
  by-version."cookie-signature"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-signature-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.0.tgz";
        name = "cookie-signature-1.0.0.tgz";
        sha1 = "0044f332ac623df851c914e88eacc57f0c9704fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookie-signature"."1.0.1" =
    self.by-version."cookie-signature"."1.0.1";
  by-version."cookie-signature"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-signature-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.1.tgz";
        name = "cookie-signature-1.0.1.tgz";
        sha1 = "44e072148af01e6e8e24afbf12690d68ae698ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookie-signature"."1.0.3" =
    self.by-version."cookie-signature"."1.0.3";
  by-version."cookie-signature"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-signature-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.3.tgz";
        name = "cookie-signature-1.0.3.tgz";
        sha1 = "91cd997cc51fb641595738c69cda020328f50ff9";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookiejar"."1.3.0" =
    self.by-version."cookiejar"."1.3.0";
  by-version."cookiejar"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookiejar-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookiejar/-/cookiejar-1.3.0.tgz";
        name = "cookiejar-1.3.0.tgz";
        sha1 = "dd00b35679021e99cbd4e855b9ad041913474765";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookiejar" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookiejar" ];
  };
  by-spec."cookies".">= 0.2.2" =
    self.by-version."cookies"."0.4.0";
  by-version."cookies"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookies-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookies/-/cookies-0.4.0.tgz";
        name = "cookies-0.4.0.tgz";
        sha1 = "c5d1f8b76217ed653135afe32bdad747c2fa9190";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookies" or []);
    deps = [
      self.by-version."keygrip"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookies" ];
  };
  by-spec."copy-paste"."~0.1.0" =
    self.by-version."copy-paste"."0.1.0";
  by-version."copy-paste"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-copy-paste-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/copy-paste/-/copy-paste-0.1.0.tgz";
        name = "copy-paste-0.1.0.tgz";
        sha1 = "d748638a4eccfa83af064eeb4bfc625cb300d28c";
      })
    ];
    buildInputs =
      (self.nativeDeps."copy-paste" or []);
    deps = [
      self.by-version."execSync"."1.0.1-pre"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "copy-paste" ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-core-util-is-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
        name = "core-util-is-1.0.1.tgz";
        sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
      })
    ];
    buildInputs =
      (self.nativeDeps."core-util-is" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "core-util-is" ];
  };
  by-spec."couch-login"."~0.1.15" =
    self.by-version."couch-login"."0.1.20";
  by-version."couch-login"."0.1.20" = lib.makeOverridable self.buildNodePackage {
    name = "node-couch-login-0.1.20";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/couch-login/-/couch-login-0.1.20.tgz";
        name = "couch-login-0.1.20.tgz";
        sha1 = "007c70ef80089dbae6f59eeeec37480799b39595";
      })
    ];
    buildInputs =
      (self.nativeDeps."couch-login" or []);
    deps = [
      self.by-version."request"."2.34.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "couch-login" ];
  };
  by-spec."coveralls"."*" =
    self.by-version."coveralls"."2.10.0";
  by-version."coveralls"."2.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "coveralls-2.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coveralls/-/coveralls-2.10.0.tgz";
        name = "coveralls-2.10.0.tgz";
        sha1 = "03f0c54070f30e0d336c79ef2b16a5c53728a7e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."coveralls" or []);
    deps = [
      self.by-version."js-yaml"."3.0.1"
      self.by-version."request"."2.16.2"
      self.by-version."lcov-parse"."0.0.6"
      self.by-version."log-driver"."1.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coveralls" ];
  };
  "coveralls" = self.by-version."coveralls"."2.10.0";
  by-spec."crc"."0.2.0" =
    self.by-version."crc"."0.2.0";
  by-version."crc"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-crc-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc/-/crc-0.2.0.tgz";
        name = "crc-0.2.0.tgz";
        sha1 = "f4486b9bf0a12df83c3fca14e31e030fdabd9454";
      })
    ];
    buildInputs =
      (self.nativeDeps."crc" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "crc" ];
  };
  by-spec."crossroads"."~0.12.0" =
    self.by-version."crossroads"."0.12.0";
  by-version."crossroads"."0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-crossroads-0.12.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crossroads/-/crossroads-0.12.0.tgz";
        name = "crossroads-0.12.0.tgz";
        sha1 = "24114f9de3abfa0271df66b4ec56c3b984b7f56e";
      })
    ];
    buildInputs =
      (self.nativeDeps."crossroads" or []);
    deps = [
      self.by-version."signals"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "crossroads" ];
  };
  by-spec."cryptiles"."0.1.x" =
    self.by-version."cryptiles"."0.1.3";
  by-version."cryptiles"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-cryptiles-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.1.3.tgz";
        name = "cryptiles-0.1.3.tgz";
        sha1 = "1a556734f06d24ba34862ae9cb9e709a3afbff1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = [
      self.by-version."boom"."0.3.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-cryptiles-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
        name = "cryptiles-0.2.2.tgz";
        sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = [
      self.by-version."boom"."0.4.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."crypto"."0.0.3" =
    self.by-version."crypto"."0.0.3";
  by-version."crypto"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-crypto-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crypto/-/crypto-0.0.3.tgz";
        name = "crypto-0.0.3.tgz";
        sha1 = "470a81b86be4c5ee17acc8207a1f5315ae20dbb0";
      })
    ];
    buildInputs =
      (self.nativeDeps."crypto" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "crypto" ];
  };
  by-spec."crypto-browserify"."~1.0.9" =
    self.by-version."crypto-browserify"."1.0.9";
  by-version."crypto-browserify"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-crypto-browserify-1.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crypto-browserify/-/crypto-browserify-1.0.9.tgz";
        name = "crypto-browserify-1.0.9.tgz";
        sha1 = "cc5449685dfb85eb11c9828acc7cb87ab5bbfcc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."crypto-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "crypto-browserify" ];
  };
  by-spec."cscodegen"."git://github.com/michaelficarra/cscodegen.git#73fd7202ac086c26f18c9d56f025b18b3c6f5383" =
    self.by-version."cscodegen"."0.1.0";
  by-version."cscodegen"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "cscodegen-0.1.0";
    src = [
      (fetchgit {
        url = "git://github.com/michaelficarra/cscodegen.git";
        rev = "73fd7202ac086c26f18c9d56f025b18b3c6f5383";
        sha256 = "cb527b00ac305ebc6ab3f59ff4e99def7646b417fdd9e35f0186c8ee41cd0829";
      })
    ];
    buildInputs =
      (self.nativeDeps."cscodegen" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cscodegen" ];
  };
  by-spec."css"."~1.0.8" =
    self.by-version."css"."1.0.8";
  by-version."css"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-css-1.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css/-/css-1.0.8.tgz";
        name = "css-1.0.8.tgz";
        sha1 = "9386811ca82bccc9ee7fb5a732b1e2a317c8a3e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."css" or []);
    deps = [
      self.by-version."css-parse"."1.0.4"
      self.by-version."css-stringify"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css" ];
  };
  by-spec."css-parse"."1.0.4" =
    self.by-version."css-parse"."1.0.4";
  by-version."css-parse"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-css-parse-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-parse/-/css-parse-1.0.4.tgz";
        name = "css-parse-1.0.4.tgz";
        sha1 = "38b0503fbf9da9f54e9c1dbda60e145c77117bdd";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-parse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css-parse" ];
  };
  by-spec."css-parse"."1.7.x" =
    self.by-version."css-parse"."1.7.0";
  by-version."css-parse"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-css-parse-1.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-parse/-/css-parse-1.7.0.tgz";
        name = "css-parse-1.7.0.tgz";
        sha1 = "321f6cf73782a6ff751111390fc05e2c657d8c9b";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-parse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css-parse" ];
  };
  by-spec."css-stringify"."1.0.5" =
    self.by-version."css-stringify"."1.0.5";
  by-version."css-stringify"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-css-stringify-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-stringify/-/css-stringify-1.0.5.tgz";
        name = "css-stringify-1.0.5.tgz";
        sha1 = "b0d042946db2953bb9d292900a6cb5f6d0122031";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-stringify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css-stringify" ];
  };
  by-spec."csurf"."1.0.0" =
    self.by-version."csurf"."1.0.0";
  by-version."csurf"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-csurf-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csurf/-/csurf-1.0.0.tgz";
        name = "csurf-1.0.0.tgz";
        sha1 = "a68d5718b988032e270abf1f4b34f272753d745b";
      })
    ];
    buildInputs =
      (self.nativeDeps."csurf" or []);
    deps = [
      self.by-version."uid2"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "csurf" ];
  };
  by-spec."ctype"."0.5.0" =
    self.by-version."ctype"."0.5.0";
  by-version."ctype"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ctype-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.0.tgz";
        name = "ctype-0.5.0.tgz";
        sha1 = "672673ec67587eb495c1ed694da1abb964ff65e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  by-spec."ctype"."0.5.2" =
    self.by-version."ctype"."0.5.2";
  by-version."ctype"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-ctype-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
        name = "ctype-0.5.2.tgz";
        sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-cycle-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
        name = "cycle-1.0.3.tgz";
        sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
      })
    ];
    buildInputs =
      (self.nativeDeps."cycle" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cycle" ];
  };
  by-spec."dargs"."~0.1.0" =
    self.by-version."dargs"."0.1.0";
  by-version."dargs"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-dargs-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dargs/-/dargs-0.1.0.tgz";
        name = "dargs-0.1.0.tgz";
        sha1 = "2364ad9f441f976dcd5fe9961e21715665a5e3c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."dargs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dargs" ];
  };
  by-spec."dateformat"."1.0.2-1.2.3" =
    self.by-version."dateformat"."1.0.2-1.2.3";
  by-version."dateformat"."1.0.2-1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-dateformat-1.0.2-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.2-1.2.3.tgz";
        name = "dateformat-1.0.2-1.2.3.tgz";
        sha1 = "b0220c02de98617433b72851cf47de3df2cdbee9";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  by-spec."dateformat"."~1.0.6" =
    self.by-version."dateformat"."1.0.7-1.2.3";
  by-version."dateformat"."1.0.7-1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-dateformat-1.0.7-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.7-1.2.3.tgz";
        name = "dateformat-1.0.7-1.2.3.tgz";
        sha1 = "ebb561bb7214ee57a8dc2687adab1d555de9419c";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  by-spec."debug"."*" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-debug-0.7.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
        name = "debug-0.7.4.tgz";
        sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."0.5.0" =
    self.by-version."debug"."0.5.0";
  by-version."debug"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-debug-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.5.0.tgz";
        name = "debug-0.5.0.tgz";
        sha1 = "9d48c946fb7d7d59807ffe07822f515fd76d7a9e";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."0.7.4" =
    self.by-version."debug"."0.7.4";
  by-spec."debug".">= 0.7.3 < 1" =
    self.by-version."debug"."0.7.4";
  by-spec."debug"."~0.7.0" =
    self.by-version."debug"."0.7.4";
  by-spec."debug"."~0.7.2" =
    self.by-version."debug"."0.7.4";
  by-spec."debug"."~0.7.3" =
    self.by-version."debug"."0.7.4";
  by-spec."debuglog"."0.0.2" =
    self.by-version."debuglog"."0.0.2";
  by-version."debuglog"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-debuglog-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debuglog/-/debuglog-0.0.2.tgz";
        name = "debuglog-0.0.2.tgz";
        sha1 = "6c0dcf07e2c3f74524629b741668bd46c7b362eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."debuglog" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debuglog" ];
  };
  by-spec."decompress"."~0.1.5" =
    self.by-version."decompress"."0.1.8";
  by-version."decompress"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-decompress-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decompress/-/decompress-0.1.8.tgz";
        name = "decompress-0.1.8.tgz";
        sha1 = "5a8b5caa9ca5dd50112320383f8f047d5823d6e9";
      })
    ];
    buildInputs =
      (self.nativeDeps."decompress" or []);
    deps = [
      self.by-version."adm-zip"."0.4.4"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."mout"."0.9.0"
      self.by-version."rimraf"."2.2.6"
      self.by-version."stream-combiner"."0.0.4"
      self.by-version."tar"."0.1.19"
      self.by-version."tempfile"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "decompress" ];
  };
  by-spec."decompress-zip"."~0.0.3" =
    self.by-version."decompress-zip"."0.0.5";
  by-version."decompress-zip"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "decompress-zip-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decompress-zip/-/decompress-zip-0.0.5.tgz";
        name = "decompress-zip-0.0.5.tgz";
        sha1 = "ab145d0dfe4f1c4249af7efcdff1df669eca0c8c";
      })
    ];
    buildInputs =
      (self.nativeDeps."decompress-zip" or []);
    deps = [
      self.by-version."q"."1.0.1"
      self.by-version."mkpath"."0.1.0"
      self.by-version."binary"."0.3.0"
      self.by-version."touch"."0.0.2"
      self.by-version."readable-stream"."1.1.11"
      self.by-version."nopt"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "decompress-zip" ];
  };
  by-spec."deep-eql"."0.1.3" =
    self.by-version."deep-eql"."0.1.3";
  by-version."deep-eql"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-deep-eql-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-eql/-/deep-eql-0.1.3.tgz";
        name = "deep-eql-0.1.3.tgz";
        sha1 = "ef558acab8de25206cd713906d74e56930eb69f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-eql" or []);
    deps = [
      self.by-version."type-detect"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-eql" ];
  };
  by-spec."deep-equal"."*" =
    self.by-version."deep-equal"."0.2.1";
  by-version."deep-equal"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-deep-equal-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.1.tgz";
        name = "deep-equal-0.2.1.tgz";
        sha1 = "fad7a793224cbf0c3c7786f92ef780e4fc8cc878";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  by-spec."deep-equal"."0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-version."deep-equal"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-deep-equal-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.0.0.tgz";
        name = "deep-equal-0.0.0.tgz";
        sha1 = "99679d3bbd047156fcd450d3d01eeb9068691e83";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  by-spec."deep-equal"."~0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-spec."deep-equal"."~0.1.0" =
    self.by-version."deep-equal"."0.1.2";
  by-version."deep-equal"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-deep-equal-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.1.2.tgz";
        name = "deep-equal-0.1.2.tgz";
        sha1 = "b246c2b80a570a47c11be1d9bd1070ec878b87ce";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  by-spec."deep-extend"."~0.2.5" =
    self.by-version."deep-extend"."0.2.8";
  by-version."deep-extend"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-deep-extend-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.8.tgz";
        name = "deep-extend-0.2.8.tgz";
        sha1 = "6d2893a805286e46d8243137c32fb991b50f4299";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-extend" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-extend" ];
  };
  by-spec."deep-extend"."~0.2.8" =
    self.by-version."deep-extend"."0.2.8";
  by-spec."deepmerge"."*" =
    self.by-version."deepmerge"."0.2.7";
  by-version."deepmerge"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-deepmerge-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deepmerge/-/deepmerge-0.2.7.tgz";
        name = "deepmerge-0.2.7.tgz";
        sha1 = "3a5ab8d37311c4d1aefb22209693afe0a91a0563";
      })
    ];
    buildInputs =
      (self.nativeDeps."deepmerge" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deepmerge" ];
  };
  "deepmerge" = self.by-version."deepmerge"."0.2.7";
  by-spec."defined"."~0.0.0" =
    self.by-version."defined"."0.0.0";
  by-version."defined"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-defined-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/defined/-/defined-0.0.0.tgz";
        name = "defined-0.0.0.tgz";
        sha1 = "f35eea7d705e933baf13b2f03b3f83d921403b3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."defined" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "defined" ];
  };
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-delayed-stream-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
        name = "delayed-stream-0.0.5.tgz";
        sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
      })
    ];
    buildInputs =
      (self.nativeDeps."delayed-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "delayed-stream" ];
  };
  by-spec."deps-sort"."~0.1.1" =
    self.by-version."deps-sort"."0.1.1";
  by-version."deps-sort"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "deps-sort-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deps-sort/-/deps-sort-0.1.1.tgz";
        name = "deps-sort-0.1.1.tgz";
        sha1 = "940d9da1f84a3891c7218ad240ec5ed6084bc8d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."deps-sort" or []);
    deps = [
      self.by-version."through"."2.3.4"
      self.by-version."JSONStream"."0.6.4"
      self.by-version."minimist"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deps-sort" ];
  };
  by-spec."derequire"."~0.6.0" =
    self.by-version."derequire"."0.6.1";
  by-version."derequire"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-derequire-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/derequire/-/derequire-0.6.1.tgz";
        name = "derequire-0.6.1.tgz";
        sha1 = "cce8ee25380de715deb61900f0bdd38222928788";
      })
    ];
    buildInputs =
      (self.nativeDeps."derequire" or []);
    deps = [
      self.by-version."estraverse"."1.5.0"
      self.by-version."esprima-six"."0.0.3"
      self.by-version."esrefactor"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "derequire" ];
  };
  by-spec."detective"."~2.4.0" =
    self.by-version."detective"."2.4.1";
  by-version."detective"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-detective-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/detective/-/detective-2.4.1.tgz";
        name = "detective-2.4.1.tgz";
        sha1 = "943b8eec4c346f6ac501de25da2ea1a57ed77819";
      })
    ];
    buildInputs =
      (self.nativeDeps."detective" or []);
    deps = [
      self.by-version."escodegen"."1.1.0"
      self.by-version."esprima-six"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "detective" ];
  };
  by-spec."di"."~0.0.1" =
    self.by-version."di"."0.0.1";
  by-version."di"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-di-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/di/-/di-0.0.1.tgz";
        name = "di-0.0.1.tgz";
        sha1 = "806649326ceaa7caa3306d75d985ea2748ba913c";
      })
    ];
    buildInputs =
      (self.nativeDeps."di" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "di" ];
  };
  by-spec."diff"."1.0.7" =
    self.by-version."diff"."1.0.7";
  by-version."diff"."1.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-diff-1.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.7.tgz";
        name = "diff-1.0.7.tgz";
        sha1 = "24bbb001c4a7d5522169e7cabdb2c2814ed91cf4";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  by-spec."diff"."~1.0.3" =
    self.by-version."diff"."1.0.8";
  by-version."diff"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-diff-1.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.8.tgz";
        name = "diff-1.0.8.tgz";
        sha1 = "343276308ec991b7bc82267ed55bc1411f971666";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  by-spec."diff"."~1.0.4" =
    self.by-version."diff"."1.0.8";
  by-spec."diff"."~1.0.7" =
    self.by-version."diff"."1.0.8";
  by-spec."director"."1.1.10" =
    self.by-version."director"."1.1.10";
  by-version."director"."1.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-director-1.1.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/director/-/director-1.1.10.tgz";
        name = "director-1.1.10.tgz";
        sha1 = "e6c1d64f2f079216f19ea83b566035dde9901179";
      })
    ];
    buildInputs =
      (self.nativeDeps."director" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "director" ];
  };
  by-spec."dkim-signer"."~0.1.0" =
    self.by-version."dkim-signer"."0.1.0";
  by-version."dkim-signer"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-dkim-signer-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dkim-signer/-/dkim-signer-0.1.0.tgz";
        name = "dkim-signer-0.1.0.tgz";
        sha1 = "c57c29b238029fbb08622afc2729ad596bcb417b";
      })
    ];
    buildInputs =
      (self.nativeDeps."dkim-signer" or []);
    deps = [
      self.by-version."punycode"."1.2.4"
      self.by-version."mimelib"."0.2.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dkim-signer" ];
  };
  by-spec."domain-browser"."~1.1.0" =
    self.by-version."domain-browser"."1.1.1";
  by-version."domain-browser"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-domain-browser-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domain-browser/-/domain-browser-1.1.1.tgz";
        name = "domain-browser-1.1.1.tgz";
        sha1 = "0123c1b9afe3bb7c8a9e856177b2059440957de0";
      })
    ];
    buildInputs =
      (self.nativeDeps."domain-browser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domain-browser" ];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.1.1";
  by-version."domelementtype"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-domelementtype-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.1.tgz";
        name = "domelementtype-1.1.1.tgz";
        sha1 = "7887acbda7614bb0a3dbe1b5e394f77a8ed297cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."domelementtype" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domelementtype" ];
  };
  by-spec."domhandler"."2.0" =
    self.by-version."domhandler"."2.0.3";
  by-version."domhandler"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-domhandler-2.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.0.3.tgz";
        name = "domhandler-2.0.3.tgz";
        sha1 = "889f8df626403af0788e29d66d5d5c6f7ebf0fd6";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domhandler"."2.1" =
    self.by-version."domhandler"."2.1.0";
  by-version."domhandler"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-domhandler-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.1.0.tgz";
        name = "domhandler-2.1.0.tgz";
        sha1 = "d2646f5e57f6c3bab11cf6cb05d3c0acf7412594";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domhandler"."2.2" =
    self.by-version."domhandler"."2.2.0";
  by-version."domhandler"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-domhandler-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.2.0.tgz";
        name = "domhandler-2.2.0.tgz";
        sha1 = "ac9febfa988034b43f78ba056ebf7bd373416476";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domutils"."1.1" =
    self.by-version."domutils"."1.1.6";
  by-version."domutils"."1.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-domutils-1.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.1.6.tgz";
        name = "domutils-1.1.6.tgz";
        sha1 = "bddc3de099b9a2efacc51c623f28f416ecc57485";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."domutils"."1.3" =
    self.by-version."domutils"."1.3.0";
  by-version."domutils"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-domutils-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.3.0.tgz";
        name = "domutils-1.3.0.tgz";
        sha1 = "9ad4d59b5af6ca684c62fe6d768ef170e70df192";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."domutils"."1.4" =
    self.by-version."domutils"."1.4.1";
  by-version."domutils"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-domutils-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.4.1.tgz";
        name = "domutils-1.4.1.tgz";
        sha1 = "e716621c245561dd03c1ecd5667f70e8ddeb2f59";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."download"."~0.1.6" =
    self.by-version."download"."0.1.10";
  by-version."download"."0.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-download-0.1.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/download/-/download-0.1.10.tgz";
        name = "download-0.1.10.tgz";
        sha1 = "732065fc96259abd47543c2711467bcf7ed66af5";
      })
    ];
    buildInputs =
      (self.nativeDeps."download" or []);
    deps = [
      self.by-version."decompress"."0.1.8"
      self.by-version."each-async"."0.1.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."request"."2.31.0"
      self.by-version."through2"."0.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "download" ];
  };
  by-spec."dox"."~0.4.4" =
    self.by-version."dox"."0.4.4";
  by-version."dox"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "dox-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dox/-/dox-0.4.4.tgz";
        name = "dox-0.4.4.tgz";
        sha1 = "4f898abbb88cd879c7c49a4973abc95b7f384823";
      })
    ];
    buildInputs =
      (self.nativeDeps."dox" or []);
    deps = [
      self.by-version."github-flavored-markdown"."1.0.1"
      self.by-version."commander"."0.6.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dox" ];
  };
  by-spec."dtrace-provider"."0.2.8" =
    self.by-version."dtrace-provider"."0.2.8";
  by-version."dtrace-provider"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-dtrace-provider-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dtrace-provider/-/dtrace-provider-0.2.8.tgz";
        name = "dtrace-provider-0.2.8.tgz";
        sha1 = "e243f19219aa95fbf0d8f2ffb07f5bd64e94fe20";
      })
    ];
    buildInputs =
      (self.nativeDeps."dtrace-provider" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dtrace-provider" ];
  };
  by-spec."duplexer"."~0.1.1" =
    self.by-version."duplexer"."0.1.1";
  by-version."duplexer"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-duplexer-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz";
        name = "duplexer-0.1.1.tgz";
        sha1 = "ace6ff808c1ce66b57d1ebf97977acb02334cfc1";
      })
    ];
    buildInputs =
      (self.nativeDeps."duplexer" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "duplexer" ];
  };
  by-spec."each-async"."~0.1.1" =
    self.by-version."each-async"."0.1.2";
  by-version."each-async"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-each-async-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/each-async/-/each-async-0.1.2.tgz";
        name = "each-async-0.1.2.tgz";
        sha1 = "d5b900bd92705ed5b8cad3307a6536adb0f134c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."each-async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "each-async" ];
  };
  by-spec."editor"."0.0.5" =
    self.by-version."editor"."0.0.5";
  by-version."editor"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-editor-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/editor/-/editor-0.0.5.tgz";
        name = "editor-0.0.5.tgz";
        sha1 = "8c38877781f2547011c1aeffdbe50cafcc59794a";
      })
    ];
    buildInputs =
      (self.nativeDeps."editor" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "editor" ];
  };
  by-spec."ejs"."0.8.3" =
    self.by-version."ejs"."0.8.3";
  by-version."ejs"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-ejs-0.8.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ejs/-/ejs-0.8.3.tgz";
        name = "ejs-0.8.3.tgz";
        sha1 = "db8aac47ff80a7df82b4c82c126fe8970870626f";
      })
    ];
    buildInputs =
      (self.nativeDeps."ejs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ejs" ];
  };
  by-spec."emitter-component"."0.0.6" =
    self.by-version."emitter-component"."0.0.6";
  by-version."emitter-component"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-emitter-component-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/emitter-component/-/emitter-component-0.0.6.tgz";
        name = "emitter-component-0.0.6.tgz";
        sha1 = "c155d82f6d0c01b5bee856d58074a4cc59795bca";
      })
    ];
    buildInputs =
      (self.nativeDeps."emitter-component" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "emitter-component" ];
  };
  by-spec."emitter-component"."1.0.0" =
    self.by-version."emitter-component"."1.0.0";
  by-version."emitter-component"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-emitter-component-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/emitter-component/-/emitter-component-1.0.0.tgz";
        name = "emitter-component-1.0.0.tgz";
        sha1 = "f04dd18fc3dc3e9a74cbc0f310b088666e4c016f";
      })
    ];
    buildInputs =
      (self.nativeDeps."emitter-component" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "emitter-component" ];
  };
  by-spec."encoding"."~0.1" =
    self.by-version."encoding"."0.1.7";
  by-version."encoding"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-encoding-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/encoding/-/encoding-0.1.7.tgz";
        name = "encoding-0.1.7.tgz";
        sha1 = "25cc19b34e9225d120c2ea769f9136c91cecc908";
      })
    ];
    buildInputs =
      (self.nativeDeps."encoding" or []);
    deps = [
      self.by-version."iconv-lite"."0.2.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "encoding" ];
  };
  by-spec."entities"."0.x" =
    self.by-version."entities"."0.5.0";
  by-version."entities"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-entities-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-0.5.0.tgz";
        name = "entities-0.5.0.tgz";
        sha1 = "f611cb5ae221050e0012c66979503fd7ae19cc49";
      })
    ];
    buildInputs =
      (self.nativeDeps."entities" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "entities" ];
  };
  by-spec."errorhandler"."1.0.0" =
    self.by-version."errorhandler"."1.0.0";
  by-version."errorhandler"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-errorhandler-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/errorhandler/-/errorhandler-1.0.0.tgz";
        name = "errorhandler-1.0.0.tgz";
        sha1 = "d74b37e8dc38c99afb3f5a79edcebaea022d042a";
      })
    ];
    buildInputs =
      (self.nativeDeps."errorhandler" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "errorhandler" ];
  };
  by-spec."es5-ext"."~0.9.2" =
    self.by-version."es5-ext"."0.9.2";
  by-version."es5-ext"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-es5-ext-0.9.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es5-ext/-/es5-ext-0.9.2.tgz";
        name = "es5-ext-0.9.2.tgz";
        sha1 = "d2e309d1f223b0718648835acf5b8823a8061f8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."es5-ext" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "es5-ext" ];
  };
  by-spec."escape-html"."*" =
    self.by-version."escape-html"."1.0.1";
  by-version."escape-html"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-escape-html-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
        name = "escape-html-1.0.1.tgz";
        sha1 = "181a286ead397a39a92857cfb1d43052e356bff0";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-html" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escape-html" ];
  };
  "escape-html" = self.by-version."escape-html"."1.0.1";
  by-spec."escape-html"."1.0.1" =
    self.by-version."escape-html"."1.0.1";
  by-spec."escodegen"."1.2.x" =
    self.by-version."escodegen"."1.2.0";
  by-version."escodegen"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.2.0.tgz";
        name = "escodegen-1.2.0.tgz";
        sha1 = "09de7967791cc958b7f89a2ddb6d23451af327e1";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."estraverse"."1.5.0"
      self.by-version."esutils"."1.0.0"
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escodegen"."~ 0.0.28" =
    self.by-version."escodegen"."0.0.28";
  by-version."escodegen"."0.0.28" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-0.0.28";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-0.0.28.tgz";
        name = "escodegen-0.0.28.tgz";
        sha1 = "0e4ff1715f328775d6cab51ac44a406cd7abffd3";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."estraverse"."1.3.2"
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escodegen"."~0.0.24" =
    self.by-version."escodegen"."0.0.28";
  by-spec."escodegen"."~1.1.0" =
    self.by-version."escodegen"."1.1.0";
  by-version."escodegen"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.1.0.tgz";
        name = "escodegen-1.1.0.tgz";
        sha1 = "c663923f6e20aad48d0c0fa49f31c6d4f49360cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."estraverse"."1.5.0"
      self.by-version."esutils"."1.0.0"
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escope"."~ 1.0.0" =
    self.by-version."escope"."1.0.1";
  by-version."escope"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-escope-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escope/-/escope-1.0.1.tgz";
        name = "escope-1.0.1.tgz";
        sha1 = "59b04cdccb76555608499ed13502b9028fe73dd8";
      })
    ];
    buildInputs =
      (self.nativeDeps."escope" or []);
    deps = [
      self.by-version."estraverse"."1.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escope" ];
  };
  by-spec."escope"."~0.0.13" =
    self.by-version."escope"."0.0.16";
  by-version."escope"."0.0.16" = lib.makeOverridable self.buildNodePackage {
    name = "node-escope-0.0.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escope/-/escope-0.0.16.tgz";
        name = "escope-0.0.16.tgz";
        sha1 = "418c7a0afca721dafe659193fd986283e746538f";
      })
    ];
    buildInputs =
      (self.nativeDeps."escope" or []);
    deps = [
      self.by-version."estraverse"."1.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escope" ];
  };
  by-spec."esmangle"."~0.0.8" =
    self.by-version."esmangle"."0.0.17";
  by-version."esmangle"."0.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "esmangle-0.0.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esmangle/-/esmangle-0.0.17.tgz";
        name = "esmangle-0.0.17.tgz";
        sha1 = "4c5c93607cde5d1276bad396e836229dba68d90c";
      })
    ];
    buildInputs =
      (self.nativeDeps."esmangle" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."escope"."1.0.1"
      self.by-version."escodegen"."0.0.28"
      self.by-version."estraverse"."1.3.2"
      self.by-version."source-map"."0.1.33"
      self.by-version."esshorten"."0.0.2"
      self.by-version."optimist"."0.6.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esmangle" ];
  };
  by-spec."esprima"."1.0.x" =
    self.by-version."esprima"."1.0.4";
  by-version."esprima"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        name = "esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."esprima"."~ 1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima"."~1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima"."~1.0.4" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima-six"."0.0.3" =
    self.by-version."esprima-six"."0.0.3";
  by-version."esprima-six"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-six-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima-six/-/esprima-six-0.0.3.tgz";
        name = "esprima-six-0.0.3.tgz";
        sha1 = "8eb750435b02d3e50cf09b5736cbce4606a4399f";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima-six" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esprima-six" ];
  };
  by-spec."esprima-six"."~0.0.3" =
    self.by-version."esprima-six"."0.0.3";
  by-spec."esrefactor"."~0.1.0" =
    self.by-version."esrefactor"."0.1.0";
  by-version."esrefactor"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-esrefactor-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esrefactor/-/esrefactor-0.1.0.tgz";
        name = "esrefactor-0.1.0.tgz";
        sha1 = "d142795a282339ab81e936b5b7a21b11bf197b13";
      })
    ];
    buildInputs =
      (self.nativeDeps."esrefactor" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."estraverse"."0.0.4"
      self.by-version."escope"."0.0.16"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esrefactor" ];
  };
  by-spec."esshorten"."~ 0.0.2" =
    self.by-version."esshorten"."0.0.2";
  by-version."esshorten"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-esshorten-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esshorten/-/esshorten-0.0.2.tgz";
        name = "esshorten-0.0.2.tgz";
        sha1 = "28a652f1efd40c8e227f8c6de7dbe6b560ee8129";
      })
    ];
    buildInputs =
      (self.nativeDeps."esshorten" or []);
    deps = [
      self.by-version."escope"."1.0.1"
      self.by-version."estraverse"."1.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esshorten" ];
  };
  by-spec."estraverse".">= 0.0.2" =
    self.by-version."estraverse"."1.5.0";
  by-version."estraverse"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-estraverse-1.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.5.0.tgz";
        name = "estraverse-1.5.0.tgz";
        sha1 = "248ec3f0d4bf39a940109c92a05ceb56d59e53ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~ 1.2.0" =
    self.by-version."estraverse"."1.2.0";
  by-version."estraverse"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-estraverse-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.2.0.tgz";
        name = "estraverse-1.2.0.tgz";
        sha1 = "6a3dc8a46a5d6766e5668639fc782976ce5660fd";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~ 1.3.2" =
    self.by-version."estraverse"."1.3.2";
  by-version."estraverse"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-estraverse-1.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.3.2.tgz";
        name = "estraverse-1.3.2.tgz";
        sha1 = "37c2b893ef13d723f276d878d60d8535152a6c42";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~0.0.4" =
    self.by-version."estraverse"."0.0.4";
  by-version."estraverse"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-estraverse-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-0.0.4.tgz";
        name = "estraverse-0.0.4.tgz";
        sha1 = "01a0932dfee574684a598af5a67c3bf9b6428db2";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~1.3.0" =
    self.by-version."estraverse"."1.3.2";
  by-spec."estraverse"."~1.5.0" =
    self.by-version."estraverse"."1.5.0";
  by-spec."esutils"."~1.0.0" =
    self.by-version."esutils"."1.0.0";
  by-version."esutils"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-esutils-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esutils/-/esutils-1.0.0.tgz";
        name = "esutils-1.0.0.tgz";
        sha1 = "8151d358e20c8acc7fb745e7472c0025fe496570";
      })
    ];
    buildInputs =
      (self.nativeDeps."esutils" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esutils" ];
  };
  by-spec."event-emitter"."~0.2.2" =
    self.by-version."event-emitter"."0.2.2";
  by-version."event-emitter"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-event-emitter-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-emitter/-/event-emitter-0.2.2.tgz";
        name = "event-emitter-0.2.2.tgz";
        sha1 = "c81e3724eb55407c5a0d5ee3299411f700f54291";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-emitter" or []);
    deps = [
      self.by-version."es5-ext"."0.9.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "event-emitter" ];
  };
  by-spec."event-stream"."~0.5" =
    self.by-version."event-stream"."0.5.3";
  by-version."event-stream"."0.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-event-stream-0.5.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-stream/-/event-stream-0.5.3.tgz";
        name = "event-stream-0.5.3.tgz";
        sha1 = "b77b9309f7107addfeab63f0c0eafd8db0bd8c1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-stream" or []);
    deps = [
      self.by-version."optimist"."0.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "event-stream" ];
  };
  by-spec."eventemitter2"."0.4.12" =
    self.by-version."eventemitter2"."0.4.12";
  by-version."eventemitter2"."0.4.12" = lib.makeOverridable self.buildNodePackage {
    name = "node-eventemitter2-0.4.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.12.tgz";
        name = "eventemitter2-0.4.12.tgz";
        sha1 = "6cf14249fdc8799be7416e871e73fd2bb89e35e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  by-spec."eventemitter2"."~0.4.11" =
    self.by-version."eventemitter2"."0.4.13";
  by-version."eventemitter2"."0.4.13" = lib.makeOverridable self.buildNodePackage {
    name = "node-eventemitter2-0.4.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.13.tgz";
        name = "eventemitter2-0.4.13.tgz";
        sha1 = "0a8ab97f9c1b563361b8927f9e80606277509153";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  by-spec."eventemitter2"."~0.4.13" =
    self.by-version."eventemitter2"."0.4.13";
  by-spec."events"."~1.0.0" =
    self.by-version."events"."1.0.0";
  by-version."events"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-events-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/events/-/events-1.0.0.tgz";
        name = "events-1.0.0.tgz";
        sha1 = "63c0f80c74d1435e8eb03b54306a9d8e8f6f9da0";
      })
    ];
    buildInputs =
      (self.nativeDeps."events" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "events" ];
  };
  by-spec."events.node".">= 0.4.0" =
    self.by-version."events.node"."0.4.9";
  by-version."events.node"."0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-events.node-0.4.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/events.node/-/events.node-0.4.9.tgz";
        name = "events.node-0.4.9.tgz";
        sha1 = "82998ea749501145fd2da7cf8ecbe6420fac02a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."events.node" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "events.node" ];
  };
  by-spec."everyauth"."0.4.5" =
    self.by-version."everyauth"."0.4.5";
  by-version."everyauth"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-everyauth-0.4.5";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/everyauth/-/everyauth-0.4.5.tgz";
        name = "everyauth-0.4.5.tgz";
        sha1 = "282d358439d91c30fb4aa2320dc362edac7dd189";
      })
    ];
    buildInputs =
      (self.nativeDeps."everyauth" or []);
    deps = [
      self.by-version."oauth"."0.9.11"
      self.by-version."request"."2.9.203"
      self.by-version."connect"."2.3.9"
      self.by-version."openid"."0.5.5"
      self.by-version."xml2js"."0.4.1"
      self.by-version."node-swt"."0.1.1"
      self.by-version."node-wsfederation"."0.1.1"
      self.by-version."debug"."0.5.0"
      self.by-version."express"."3.5.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "everyauth" ];
  };
  by-spec."execSync"."~1.0.0" =
    self.by-version."execSync"."1.0.1-pre";
  by-version."execSync"."1.0.1-pre" = lib.makeOverridable self.buildNodePackage {
    name = "node-execSync-1.0.1-pre";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/execSync/-/execSync-1.0.1-pre.tgz";
        name = "execSync-1.0.1-pre.tgz";
        sha1 = "8fa8deb748eecdafe61feea49921bb9b7a410d1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."execSync" or []);
    deps = [
      self.by-version."temp"."0.5.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "execSync" ];
  };
  by-spec."exit"."0.1.x" =
    self.by-version."exit"."0.1.2";
  by-version."exit"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-exit-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/exit/-/exit-0.1.2.tgz";
        name = "exit-0.1.2.tgz";
        sha1 = "0632638f8d877cc82107d30a0fff1a17cba1cd0c";
      })
    ];
    buildInputs =
      (self.nativeDeps."exit" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "exit" ];
  };
  by-spec."exit"."~0.1.1" =
    self.by-version."exit"."0.1.2";
  by-spec."express"."*" =
    self.by-version."express"."4.0.0-rc4";
  by-version."express"."4.0.0-rc4" = lib.makeOverridable self.buildNodePackage {
    name = "node-express-4.0.0-rc4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.0.0-rc4.tgz";
        name = "express-4.0.0-rc4.tgz";
        sha1 = "1cedc8790f47b776b9d100f5388e5fb652ea4388";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."parseurl"."1.0.1"
      self.by-version."accepts"."1.0.0"
      self.by-version."type-is"."1.0.0"
      self.by-version."range-parser"."1.0.0"
      self.by-version."cookie"."0.1.0"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."fresh"."0.2.2"
      self.by-version."methods"."0.1.0"
      self.by-version."send"."0.2.0"
      self.by-version."cookie-signature"."1.0.3"
      self.by-version."merge-descriptors"."0.0.2"
      self.by-version."utils-merge"."1.0.0"
      self.by-version."escape-html"."1.0.1"
      self.by-version."qs"."0.6.6"
      self.by-version."serve-static"."1.0.1"
      self.by-version."path-to-regexp"."0.1.2"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  "express" = self.by-version."express"."4.0.0-rc4";
  by-spec."express"."2.5.11" =
    self.by-version."express"."2.5.11";
  by-version."express"."2.5.11" = lib.makeOverridable self.buildNodePackage {
    name = "express-2.5.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-2.5.11.tgz";
        name = "express-2.5.11.tgz";
        sha1 = "4ce8ea1f3635e69e49f0ebb497b6a4b0a51ce6f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."connect"."1.9.2"
      self.by-version."mime"."1.2.4"
      self.by-version."qs"."0.4.2"
      self.by-version."mkdirp"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."3.2.0" =
    self.by-version."express"."3.2.0";
  by-version."express"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.2.0.tgz";
        name = "express-3.2.0.tgz";
        sha1 = "7b66d6c66b038038eedf452804222b3077374ae0";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."connect"."2.7.6"
      self.by-version."commander"."0.6.1"
      self.by-version."range-parser"."0.0.4"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."cookie"."0.0.5"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."fresh"."0.1.0"
      self.by-version."methods"."0.0.1"
      self.by-version."send"."0.1.0"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."3.4.4" =
    self.by-version."express"."3.4.4";
  by-version."express"."3.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.4.tgz";
        name = "express-3.4.4.tgz";
        sha1 = "0b63ae626c96b71b78d13dfce079c10351635a86";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."connect"."2.11.0"
      self.by-version."commander"."1.3.2"
      self.by-version."range-parser"."0.0.4"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."cookie"."0.1.0"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."fresh"."0.2.0"
      self.by-version."methods"."0.1.0"
      self.by-version."send"."0.1.4"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."3.x" =
    self.by-version."express"."3.5.1";
  by-version."express"."3.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.5.1.tgz";
        name = "express-3.5.1.tgz";
        sha1 = "4b333e1117faca336a538f4c724140b9ce1a87e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."connect"."2.14.1"
      self.by-version."commander"."1.3.2"
      self.by-version."range-parser"."1.0.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."cookie"."0.1.1"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."fresh"."0.2.2"
      self.by-version."methods"."0.1.0"
      self.by-version."send"."0.2.0"
      self.by-version."cookie-signature"."1.0.3"
      self.by-version."merge-descriptors"."0.0.2"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."~3.1.1" =
    self.by-version."express"."3.1.2";
  by-version."express"."3.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.1.2.tgz";
        name = "express-3.1.2.tgz";
        sha1 = "52a02c8db8f22bbfa0d7478d847cd45161f985f7";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."connect"."2.7.5"
      self.by-version."commander"."0.6.1"
      self.by-version."range-parser"."0.0.4"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."cookie"."0.0.5"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."fresh"."0.1.0"
      self.by-version."methods"."0.0.1"
      self.by-version."send"."0.1.0"
      self.by-version."cookie-signature"."1.0.0"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."~3.4" =
    self.by-version."express"."3.4.8";
  by-version."express"."3.4.8" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.8.tgz";
        name = "express-3.4.8.tgz";
        sha1 = "aa7a8986de07053337f4bc5ed9a6453d9cc8e2e1";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."connect"."2.12.0"
      self.by-version."commander"."1.3.2"
      self.by-version."range-parser"."0.0.4"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."cookie"."0.1.0"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."fresh"."0.2.0"
      self.by-version."methods"."0.1.0"
      self.by-version."send"."0.1.4"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."merge-descriptors"."0.0.1"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."~3.4.8" =
    self.by-version."express"."3.4.8";
  by-spec."express-form"."*" =
    self.by-version."express-form"."0.12.0";
  by-version."express-form"."0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-express-form-0.12.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-form/-/express-form-0.12.0.tgz";
        name = "express-form-0.12.0.tgz";
        sha1 = "0525ce1365760fd90fb785829a430122aceb893a";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-form" or []);
    deps = [
      self.by-version."validator"."0.4.28"
      self.by-version."object-additions"."0.5.1"
      self.by-version."async"."0.2.10"
    ];
    peerDependencies = [
      self.by-version."express"."3.5.1"
    ];
    passthru.names = [ "express-form" ];
  };
  "express-form" = self.by-version."express-form"."0.12.0";
  by-spec."express-partials"."0.0.6" =
    self.by-version."express-partials"."0.0.6";
  by-version."express-partials"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-express-partials-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-partials/-/express-partials-0.0.6.tgz";
        name = "express-partials-0.0.6.tgz";
        sha1 = "b2664f15c636d5248e60fdbe29131c4440552eda";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-partials" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express-partials" ];
  };
  by-spec."express-session"."1.0.2" =
    self.by-version."express-session"."1.0.2";
  by-version."express-session"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-express-session-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-session/-/express-session-1.0.2.tgz";
        name = "express-session-1.0.2.tgz";
        sha1 = "004478c742561774411ceb79733155a56b6d49eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-session" or []);
    deps = [
      self.by-version."utils-merge"."1.0.0"
      self.by-version."cookie"."0.1.0"
      self.by-version."cookie-signature"."1.0.3"
      self.by-version."uid2"."0.0.3"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express-session" ];
  };
  by-spec."extend"."*" =
    self.by-version."extend"."1.2.1";
  by-version."extend"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-extend-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-1.2.1.tgz";
        name = "extend-1.2.1.tgz";
        sha1 = "a0f5fd6cfc83a5fe49ef698d60ec8a624dd4576c";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extend" ];
  };
  "extend" = self.by-version."extend"."1.2.1";
  by-spec."extend"."~1.2.1" =
    self.by-version."extend"."1.2.1";
  by-spec."extract-opts"."~2.2.0" =
    self.by-version."extract-opts"."2.2.0";
  by-version."extract-opts"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-extract-opts-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extract-opts/-/extract-opts-2.2.0.tgz";
        name = "extract-opts-2.2.0.tgz";
        sha1 = "1fa28eba7352c6db480f885ceb71a46810be6d7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."extract-opts" or []);
    deps = [
      self.by-version."typechecker"."2.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extract-opts" ];
  };
  by-spec."extsprintf"."1.0.0" =
    self.by-version."extsprintf"."1.0.0";
  by-version."extsprintf"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-extsprintf-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.0.tgz";
        name = "extsprintf-1.0.0.tgz";
        sha1 = "4d58b815ace5bebfc4ebf03cf98b0a7604a99b86";
      })
    ];
    buildInputs =
      (self.nativeDeps."extsprintf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extsprintf" ];
  };
  by-spec."extsprintf"."1.0.2" =
    self.by-version."extsprintf"."1.0.2";
  by-version."extsprintf"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-extsprintf-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
        name = "extsprintf-1.0.2.tgz";
        sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
      })
    ];
    buildInputs =
      (self.nativeDeps."extsprintf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extsprintf" ];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-eyes-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        name = "eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eyes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eyes" ];
  };
  by-spec."eyes".">=0.1.6" =
    self.by-version."eyes"."0.1.8";
  by-spec."faye-websocket"."*" =
    self.by-version."faye-websocket"."0.7.2";
  by-version."faye-websocket"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-faye-websocket-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.7.2.tgz";
        name = "faye-websocket-0.7.2.tgz";
        sha1 = "799970386f87105592397434b02abfa4f07bdf70";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket" or []);
    deps = [
      self.by-version."websocket-driver"."0.3.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  "faye-websocket" = self.by-version."faye-websocket"."0.7.2";
  by-spec."faye-websocket"."0.7.0" =
    self.by-version."faye-websocket"."0.7.0";
  by-version."faye-websocket"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-faye-websocket-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.7.0.tgz";
        name = "faye-websocket-0.7.0.tgz";
        sha1 = "c16c50ec0d483357a8eafd1ec6fcc313d027f5be";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket" or []);
    deps = [
      self.by-version."websocket-driver"."0.3.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  by-spec."fetch-bower"."*" =
    self.by-version."fetch-bower"."2.0.0";
  by-version."fetch-bower"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "fetch-bower-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fetch-bower/-/fetch-bower-2.0.0.tgz";
        name = "fetch-bower-2.0.0.tgz";
        sha1 = "c027feb75a512001d1287bbfb3ffaafba67eb92f";
      })
    ];
    buildInputs =
      (self.nativeDeps."fetch-bower" or []);
    deps = [
      self.by-version."bower-endpoint-parser"."0.2.1"
      self.by-version."bower-logger"."0.2.1"
      self.by-version."bower"."1.3.1"
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fetch-bower" ];
  };
  "fetch-bower" = self.by-version."fetch-bower"."2.0.0";
  by-spec."fetch-bower".">=2 <3" =
    self.by-version."fetch-bower"."2.0.0";
  by-spec."fields"."~0.1.11" =
    self.by-version."fields"."0.1.12";
  by-version."fields"."0.1.12" = lib.makeOverridable self.buildNodePackage {
    name = "node-fields-0.1.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fields/-/fields-0.1.12.tgz";
        name = "fields-0.1.12.tgz";
        sha1 = "ded2dfe1e0aad3576aed554bfb8f65a7e7404bc1";
      })
    ];
    buildInputs =
      (self.nativeDeps."fields" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."keypress"."0.1.0"
      self.by-version."sprintf"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fields" ];
  };
  by-spec."file-utils"."~0.1.1" =
    self.by-version."file-utils"."0.1.5";
  by-version."file-utils"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-file-utils-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/file-utils/-/file-utils-0.1.5.tgz";
        name = "file-utils-0.1.5.tgz";
        sha1 = "dc8153c855387cb4dacb0a1725531fa444a6b48c";
      })
    ];
    buildInputs =
      (self.nativeDeps."file-utils" or []);
    deps = [
      self.by-version."lodash"."2.1.0"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."rimraf"."2.2.6"
      self.by-version."glob"."3.2.9"
      self.by-version."minimatch"."0.2.14"
      self.by-version."findup-sync"."0.1.3"
      self.by-version."isbinaryfile"."0.1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "file-utils" ];
  };
  by-spec."file-utils"."~0.1.5" =
    self.by-version."file-utils"."0.1.5";
  by-spec."fileset"."0.1.x" =
    self.by-version."fileset"."0.1.5";
  by-version."fileset"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-fileset-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fileset/-/fileset-0.1.5.tgz";
        name = "fileset-0.1.5.tgz";
        sha1 = "acc423bfaf92843385c66bf75822264d11b7bd94";
      })
    ];
    buildInputs =
      (self.nativeDeps."fileset" or []);
    deps = [
      self.by-version."minimatch"."0.2.14"
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fileset" ];
  };
  by-spec."findit".">=1.1.0 <2.0.0" =
    self.by-version."findit"."1.1.1";
  by-version."findit"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-findit-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findit/-/findit-1.1.1.tgz";
        name = "findit-1.1.1.tgz";
        sha1 = "b460e2f7633d78ed2c217c77c4209ecacaf8262a";
      })
    ];
    buildInputs =
      (self.nativeDeps."findit" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findit" ];
  };
  by-spec."findup"."~0.1.3" =
    self.by-version."findup"."0.1.4";
  by-version."findup"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "findup-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup/-/findup-0.1.4.tgz";
        name = "findup-0.1.4.tgz";
        sha1 = "28cd82e13eb629b40688f08f613f5cae5a29a0f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."commander"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findup" ];
  };
  by-spec."findup-sync"."~0.1.0" =
    self.by-version."findup-sync"."0.1.3";
  by-version."findup-sync"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-findup-sync-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.3.tgz";
        name = "findup-sync-0.1.3.tgz";
        sha1 = "7f3e7a97b82392c653bf06589bd85190e93c3683";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup-sync" or []);
    deps = [
      self.by-version."glob"."3.2.9"
      self.by-version."lodash"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findup-sync" ];
  };
  by-spec."findup-sync"."~0.1.2" =
    self.by-version."findup-sync"."0.1.3";
  by-spec."flatiron"."*" =
    self.by-version."flatiron"."0.3.11";
  by-version."flatiron"."0.3.11" = lib.makeOverridable self.buildNodePackage {
    name = "flatiron-0.3.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flatiron/-/flatiron-0.3.11.tgz";
        name = "flatiron-0.3.11.tgz";
        sha1 = "1cb0190fc2bd9d860f018e04d95fd35f9bd12555";
      })
    ];
    buildInputs =
      (self.nativeDeps."flatiron" or []);
    deps = [
      self.by-version."broadway"."0.2.9"
      self.by-version."optimist"."0.6.0"
      self.by-version."prompt"."0.2.11"
      self.by-version."director"."1.1.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "flatiron" ];
  };
  "flatiron" = self.by-version."flatiron"."0.3.11";
  by-spec."flatiron"."~0.3.11" =
    self.by-version."flatiron"."0.3.11";
  by-spec."follow-redirects"."0.0.3" =
    self.by-version."follow-redirects"."0.0.3";
  by-version."follow-redirects"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-follow-redirects-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/follow-redirects/-/follow-redirects-0.0.3.tgz";
        name = "follow-redirects-0.0.3.tgz";
        sha1 = "6ce67a24db1fe13f226c1171a72a7ef2b17b8f65";
      })
    ];
    buildInputs =
      (self.nativeDeps."follow-redirects" or []);
    deps = [
      self.by-version."underscore"."1.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "follow-redirects" ];
  };
  by-spec."forEachAsync"."~2.2" =
    self.by-version."forEachAsync"."2.2.1";
  by-version."forEachAsync"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-forEachAsync-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forEachAsync/-/forEachAsync-2.2.1.tgz";
        name = "forEachAsync-2.2.1.tgz";
        sha1 = "e3723f00903910e1eb4b1db3ad51b5c64a319fec";
      })
    ];
    buildInputs =
      (self.nativeDeps."forEachAsync" or []);
    deps = [
      self.by-version."sequence"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forEachAsync" ];
  };
  by-spec."forever"."*" =
    self.by-version."forever"."0.10.11";
  by-version."forever"."0.10.11" = lib.makeOverridable self.buildNodePackage {
    name = "forever-0.10.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever/-/forever-0.10.11.tgz";
        name = "forever-0.10.11.tgz";
        sha1 = "925cae528c074a29c0119809ca08e382ef194ad0";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."cliff"."0.1.8"
      self.by-version."flatiron"."0.3.11"
      self.by-version."forever-monitor"."1.2.3"
      self.by-version."nconf"."0.6.9"
      self.by-version."nssocket"."0.5.1"
      self.by-version."optimist"."0.6.1"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."timespan"."2.3.0"
      self.by-version."watch"."0.8.0"
      self.by-version."utile"."0.2.1"
      self.by-version."winston"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever" ];
  };
  "forever" = self.by-version."forever"."0.10.11";
  by-spec."forever-agent"."~0.2.0" =
    self.by-version."forever-agent"."0.2.0";
  by-version."forever-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-forever-agent-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.2.0.tgz";
        name = "forever-agent-0.2.0.tgz";
        sha1 = "e1c25c7ad44e09c38f233876c76fcc24ff843b1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-forever-agent-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
        name = "forever-agent-0.5.2.tgz";
        sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."forever-monitor"."*" =
    self.by-version."forever-monitor"."1.2.3";
  by-version."forever-monitor"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-forever-monitor-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.2.3.tgz";
        name = "forever-monitor-1.2.3.tgz";
        sha1 = "b27ac3acb6fdcc7315d6cd85830f2d004733028b";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor" or []);
    deps = [
      self.by-version."broadway"."0.2.9"
      self.by-version."minimatch"."0.2.14"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."ps-tree"."0.0.3"
      self.by-version."watch"."0.5.1"
      self.by-version."utile"."0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  "forever-monitor" = self.by-version."forever-monitor"."1.2.3";
  by-spec."forever-monitor"."1.1.0" =
    self.by-version."forever-monitor"."1.1.0";
  by-version."forever-monitor"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-forever-monitor-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.1.0.tgz";
        name = "forever-monitor-1.1.0.tgz";
        sha1 = "439ce036f999601cff551aea7f5151001a869ef9";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor" or []);
    deps = [
      self.by-version."broadway"."0.2.9"
      self.by-version."minimatch"."0.0.5"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."ps-tree"."0.0.3"
      self.by-version."watch"."0.5.1"
      self.by-version."utile"."0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  by-spec."forever-monitor"."1.2.3" =
    self.by-version."forever-monitor"."1.2.3";
  by-spec."form-data"."~0.0.3" =
    self.by-version."form-data"."0.0.10";
  by-version."form-data"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-form-data-0.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.10.tgz";
        name = "form-data-0.0.10.tgz";
        sha1 = "db345a5378d86aeeb1ed5d553b869ac192d2f5ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = [
      self.by-version."combined-stream"."0.0.4"
      self.by-version."mime"."1.2.11"
      self.by-version."async"."0.2.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.2";
  by-version."form-data"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-form-data-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.2.tgz";
        name = "form-data-0.1.2.tgz";
        sha1 = "1143c21357911a78dd7913b189b4bab5d5d57445";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = [
      self.by-version."combined-stream"."0.0.4"
      self.by-version."mime"."1.2.11"
      self.by-version."async"."0.2.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."formidable"."1.0.11" =
    self.by-version."formidable"."1.0.11";
  by-version."formidable"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-formidable-1.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.11.tgz";
        name = "formidable-1.0.11.tgz";
        sha1 = "68f63325a035e644b6f7bb3d11243b9761de1b30";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.13" =
    self.by-version."formidable"."1.0.13";
  by-version."formidable"."1.0.13" = lib.makeOverridable self.buildNodePackage {
    name = "node-formidable-1.0.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.13.tgz";
        name = "formidable-1.0.13.tgz";
        sha1 = "70caf0f9d69692a77e04021ddab4f46b01c82aea";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.14" =
    self.by-version."formidable"."1.0.14";
  by-version."formidable"."1.0.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-formidable-1.0.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.14.tgz";
        name = "formidable-1.0.14.tgz";
        sha1 = "2b3f4c411cbb5fdd695c44843e2a23514a43231a";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.9" =
    self.by-version."formidable"."1.0.9";
  by-version."formidable"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-formidable-1.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.9.tgz";
        name = "formidable-1.0.9.tgz";
        sha1 = "419e3bccead3e8874d539f5b3e72a4c503b31a98";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.x" =
    self.by-version."formidable"."1.0.14";
  by-spec."fresh"."0.1.0" =
    self.by-version."fresh"."0.1.0";
  by-version."fresh"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-fresh-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.1.0.tgz";
        name = "fresh-0.1.0.tgz";
        sha1 = "03e4b0178424e4c2d5d19a54d8814cdc97934850";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."0.2.0" =
    self.by-version."fresh"."0.2.0";
  by-version."fresh"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-fresh-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.0.tgz";
        name = "fresh-0.2.0.tgz";
        sha1 = "bfd9402cf3df12c4a4c310c79f99a3dde13d34a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."0.2.2" =
    self.by-version."fresh"."0.2.2";
  by-version."fresh"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-fresh-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.2.tgz";
        name = "fresh-0.2.2.tgz";
        sha1 = "9731dcf5678c7faeb44fb903c4f72df55187fa77";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."~0.2.1" =
    self.by-version."fresh"."0.2.2";
  by-spec."fs-extra"."~0.6.1" =
    self.by-version."fs-extra"."0.6.4";
  by-version."fs-extra"."0.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-fs-extra-0.6.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.6.4.tgz";
        name = "fs-extra-0.6.4.tgz";
        sha1 = "f46f0c75b7841f8d200b3348cd4d691d5a099d15";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-extra" or []);
    deps = [
      self.by-version."ncp"."0.4.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."jsonfile"."1.0.1"
      self.by-version."rimraf"."2.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-extra" ];
  };
  by-spec."fs-walk"."*" =
    self.by-version."fs-walk"."0.0.1";
  by-version."fs-walk"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-fs-walk-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-walk/-/fs-walk-0.0.1.tgz";
        name = "fs-walk-0.0.1.tgz";
        sha1 = "f7fc91c3ae1eead07c998bc5d0dd41f2dbebd335";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-walk" or []);
    deps = [
      self.by-version."async"."0.2.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-walk" ];
  };
  "fs-walk" = self.by-version."fs-walk"."0.0.1";
  by-spec."fs.extra".">=1.2.0 <2.0.0" =
    self.by-version."fs.extra"."1.2.1";
  by-version."fs.extra"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-fs.extra-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs.extra/-/fs.extra-1.2.1.tgz";
        name = "fs.extra-1.2.1.tgz";
        sha1 = "060bf20264f35e39ad247e5e9d2121a2a75a1733";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs.extra" or []);
    deps = [
      self.by-version."mkdirp"."0.3.5"
      self.by-version."fs-extra"."0.6.4"
      self.by-version."walk"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs.extra" ];
  };
  by-spec."fs.extra".">=1.2.1 <2" =
    self.by-version."fs.extra"."1.2.1";
  by-spec."fsevents"."0.2.0" =
    self.by-version."fsevents"."0.2.0";
  by-version."fsevents"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-fsevents-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fsevents/-/fsevents-0.2.0.tgz";
        name = "fsevents-0.2.0.tgz";
        sha1 = "1de161da042818f45bfbe11a853da8e5c6ca5d83";
      })
    ];
    buildInputs =
      (self.nativeDeps."fsevents" or []);
    deps = [
      self.by-version."nan"."0.8.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fsevents" ];
  };
  by-spec."fstream"."0" =
    self.by-version."fstream"."0.1.25";
  by-version."fstream"."0.1.25" = lib.makeOverridable self.buildNodePackage {
    name = "node-fstream-0.1.25";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.25.tgz";
        name = "fstream-0.1.25.tgz";
        sha1 = "deef2db7c7898357c2b37202212a9e5b36abc732";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = [
      self.by-version."rimraf"."2.2.6"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."~0.1.17" =
    self.by-version."fstream"."0.1.25";
  by-spec."fstream"."~0.1.22" =
    self.by-version."fstream"."0.1.25";
  by-spec."fstream"."~0.1.25" =
    self.by-version."fstream"."0.1.25";
  by-spec."fstream"."~0.1.8" =
    self.by-version."fstream"."0.1.25";
  by-spec."fstream-ignore"."~0.0.5" =
    self.by-version."fstream-ignore"."0.0.7";
  by-version."fstream-ignore"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-fstream-ignore-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-0.0.7.tgz";
        name = "fstream-ignore-0.0.7.tgz";
        sha1 = "eea3033f0c3728139de7b57ab1b0d6d89c353c63";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-ignore" or []);
    deps = [
      self.by-version."minimatch"."0.2.14"
      self.by-version."fstream"."0.1.25"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream-ignore" ];
  };
  by-spec."fstream-ignore"."~0.0.6" =
    self.by-version."fstream-ignore"."0.0.7";
  by-spec."fstream-npm"."~0.1.6" =
    self.by-version."fstream-npm"."0.1.6";
  by-version."fstream-npm"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-fstream-npm-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-npm/-/fstream-npm-0.1.6.tgz";
        name = "fstream-npm-0.1.6.tgz";
        sha1 = "1369323075d9bd85cfcc9409f33f0d6fe5be104d";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-npm" or []);
    deps = [
      self.by-version."fstream-ignore"."0.0.7"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream-npm" ];
  };
  by-spec."generator-angular"."*" =
    self.by-version."generator-angular"."0.8.0";
  by-version."generator-angular"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-generator-angular-0.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-angular/-/generator-angular-0.8.0.tgz";
        name = "generator-angular-0.8.0.tgz";
        sha1 = "c2115b1a7a304b884b7f8857cade77dc36b63d13";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-angular" or []);
    deps = [
      self.by-version."chalk"."0.4.0"
      self.by-version."wiredep"."1.0.0"
      self.by-version."yeoman-generator"."0.16.0"
    ];
    peerDependencies = [
      self.by-version."generator-karma"."0.7.0"
      self.by-version."yo"."1.1.2"
    ];
    passthru.names = [ "generator-angular" ];
  };
  "generator-angular" = self.by-version."generator-angular"."0.8.0";
  by-spec."generator-karma".">=0.6.0" =
    self.by-version."generator-karma"."0.7.0";
  by-version."generator-karma"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-generator-karma-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-karma/-/generator-karma-0.7.0.tgz";
        name = "generator-karma-0.7.0.tgz";
        sha1 = "aaa2b6d8905b687343fe6a10b15279afd984048d";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-karma" or []);
    deps = [
      self.by-version."yeoman-generator"."0.16.0"
    ];
    peerDependencies = [
      self.by-version."yo"."1.1.2"
    ];
    passthru.names = [ "generator-karma" ];
  };
  by-spec."generator-mocha".">=0.1.0" =
    self.by-version."generator-mocha"."0.1.3";
  by-version."generator-mocha"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-generator-mocha-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-mocha/-/generator-mocha-0.1.3.tgz";
        name = "generator-mocha-0.1.3.tgz";
        sha1 = "d54977bc0839b30c9b15fdd900e0ecd42afe14c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-mocha" or []);
    deps = [
      self.by-version."yeoman-generator"."0.14.2"
    ];
    peerDependencies = [
      self.by-version."yo"."1.1.2"
    ];
    passthru.names = [ "generator-mocha" ];
  };
  by-spec."generator-webapp"."*" =
    self.by-version."generator-webapp"."0.4.8";
  by-version."generator-webapp"."0.4.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-generator-webapp-0.4.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-webapp/-/generator-webapp-0.4.8.tgz";
        name = "generator-webapp-0.4.8.tgz";
        sha1 = "d0dc7e8040ec41fe6cf42ec43291157a3bd515be";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-webapp" or []);
    deps = [
      self.by-version."yeoman-generator"."0.16.0"
      self.by-version."cheerio"."0.13.1"
      self.by-version."chalk"."0.4.0"
    ];
    peerDependencies = [
      self.by-version."yo"."1.1.2"
      self.by-version."generator-mocha"."0.1.3"
    ];
    passthru.names = [ "generator-webapp" ];
  };
  "generator-webapp" = self.by-version."generator-webapp"."0.4.8";
  by-spec."getmac"."~1.0.6" =
    self.by-version."getmac"."1.0.6";
  by-version."getmac"."1.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "getmac-1.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/getmac/-/getmac-1.0.6.tgz";
        name = "getmac-1.0.6.tgz";
        sha1 = "f222c8178be9de24899df5a04e77557fbaf4e522";
      })
    ];
    buildInputs =
      (self.nativeDeps."getmac" or []);
    deps = [
      self.by-version."extract-opts"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "getmac" ];
  };
  by-spec."getobject"."~0.1.0" =
    self.by-version."getobject"."0.1.0";
  by-version."getobject"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-getobject-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/getobject/-/getobject-0.1.0.tgz";
        name = "getobject-0.1.0.tgz";
        sha1 = "047a449789fa160d018f5486ed91320b6ec7885c";
      })
    ];
    buildInputs =
      (self.nativeDeps."getobject" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "getobject" ];
  };
  by-spec."gh"."*" =
    self.by-version."gh"."1.9.0";
  by-version."gh"."1.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "gh-1.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gh/-/gh-1.9.0.tgz";
        name = "gh-1.9.0.tgz";
        sha1 = "a681f25314d2e69e4f2471fc4bf4378e9b0d8f3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."gh" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."cli-color"."0.2.3"
      self.by-version."cli-log"."0.0.8"
      self.by-version."copy-paste"."0.1.0"
      self.by-version."github"."0.1.15"
      self.by-version."handlebars"."1.0.11"
      self.by-version."inquirer"."0.3.5"
      self.by-version."moment"."2.4.0"
      self.by-version."nopt"."2.1.2"
      self.by-version."open"."0.0.4"
      self.by-version."truncate"."1.0.2"
      self.by-version."update-notifier"."0.1.8"
      self.by-version."userhome"."0.1.0"
      self.by-version."which"."1.0.5"
      self.by-version."wordwrap"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gh" ];
  };
  "gh" = self.by-version."gh"."1.9.0";
  by-spec."github"."~0.1.14" =
    self.by-version."github"."0.1.15";
  by-version."github"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-github-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github/-/github-0.1.15.tgz";
        name = "github-0.1.15.tgz";
        sha1 = "3df037442518fe800c75b1a243a13154d334069c";
      })
    ];
    buildInputs =
      (self.nativeDeps."github" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "github" ];
  };
  by-spec."github-flavored-markdown".">= 0.0.1" =
    self.by-version."github-flavored-markdown"."1.0.1";
  by-version."github-flavored-markdown"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-github-flavored-markdown-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-flavored-markdown/-/github-flavored-markdown-1.0.1.tgz";
        name = "github-flavored-markdown-1.0.1.tgz";
        sha1 = "93361b87a31c25790d9c81a1b798214a737eab38";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-flavored-markdown" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "github-flavored-markdown" ];
  };
  by-spec."github-url-from-git"."1.1.1" =
    self.by-version."github-url-from-git"."1.1.1";
  by-version."github-url-from-git"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-github-url-from-git-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-git/-/github-url-from-git-1.1.1.tgz";
        name = "github-url-from-git-1.1.1.tgz";
        sha1 = "1f89623453123ef9623956e264c60bf4c3cf5ccf";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-url-from-git" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "github-url-from-git" ];
  };
  by-spec."github-url-from-git"."~1.1.1" =
    self.by-version."github-url-from-git"."1.1.1";
  by-spec."github-url-from-username-repo"."0.0.2" =
    self.by-version."github-url-from-username-repo"."0.0.2";
  by-version."github-url-from-username-repo"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-github-url-from-username-repo-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-username-repo/-/github-url-from-username-repo-0.0.2.tgz";
        name = "github-url-from-username-repo-0.0.2.tgz";
        sha1 = "0d9ee8e2bca36d5f065a1bcd23eb3f1fa3d636bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-url-from-username-repo" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "github-url-from-username-repo" ];
  };
  by-spec."glob"."3" =
    self.by-version."glob"."3.2.9";
  by-version."glob"."3.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-glob-3.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.9.tgz";
        name = "glob-3.2.9.tgz";
        sha1 = "56af2289aa43d07d7702666480373eb814d91d40";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = [
      self.by-version."minimatch"."0.2.14"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.2.3" =
    self.by-version."glob"."3.2.3";
  by-version."glob"."3.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-glob-3.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.3.tgz";
        name = "glob-3.2.3.tgz";
        sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = [
      self.by-version."minimatch"."0.2.14"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.2.x" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."3.x" =
    self.by-version."glob"."3.2.9";
  by-spec."glob".">= 3.1.4" =
    self.by-version."glob"."3.2.9";
  by-spec."glob".">=3.2.7 <4" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."~3.1.21" =
    self.by-version."glob"."3.1.21";
  by-version."glob"."3.1.21" = lib.makeOverridable self.buildNodePackage {
    name = "node-glob-3.1.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.1.21.tgz";
        name = "glob-3.1.21.tgz";
        sha1 = "d29e0a055dea5138f4d07ed40e8982e83c2066cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = [
      self.by-version."minimatch"."0.2.14"
      self.by-version."graceful-fs"."1.2.3"
      self.by-version."inherits"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."~3.2.0" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."~3.2.1" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."~3.2.6" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."~3.2.7" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."~3.2.8" =
    self.by-version."glob"."3.2.9";
  by-spec."glob"."~3.2.9" =
    self.by-version."glob"."3.2.9";
  by-spec."graceful-fs"."2" =
    self.by-version."graceful-fs"."2.0.3";
  by-version."graceful-fs"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-graceful-fs-2.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.3.tgz";
        name = "graceful-fs-2.0.3.tgz";
        sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."~1" =
    self.by-version."graceful-fs"."1.2.3";
  by-version."graceful-fs"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-graceful-fs-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        name = "graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."~1.1" =
    self.by-version."graceful-fs"."1.1.14";
  by-version."graceful-fs"."1.1.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-graceful-fs-1.1.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.1.14.tgz";
        name = "graceful-fs-1.1.14.tgz";
        sha1 = "07078db5f6377f6321fceaaedf497de124dc9465";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."~1.2.0" =
    self.by-version."graceful-fs"."1.2.3";
  by-spec."graceful-fs"."~2" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~2.0.0" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~2.0.1" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~2.0.2" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."gridfs-stream"."*" =
    self.by-version."gridfs-stream"."0.4.1";
  by-version."gridfs-stream"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-gridfs-stream-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gridfs-stream/-/gridfs-stream-0.4.1.tgz";
        name = "gridfs-stream-0.4.1.tgz";
        sha1 = "1bcccb1b05b57946363b5e53fbe2bc95dd8877bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."gridfs-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gridfs-stream" ];
  };
  "gridfs-stream" = self.by-version."gridfs-stream"."0.4.1";
  by-spec."growl"."1.7.x" =
    self.by-version."growl"."1.7.0";
  by-version."growl"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-growl-1.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/growl/-/growl-1.7.0.tgz";
        name = "growl-1.7.0.tgz";
        sha1 = "de2d66136d002e112ba70f3f10c31cf7c350b2da";
      })
    ];
    buildInputs =
      (self.nativeDeps."growl" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "growl" ];
  };
  by-spec."grunt"."0.4.x" =
    self.by-version."grunt"."0.4.4";
  by-version."grunt"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt/-/grunt-0.4.4.tgz";
        name = "grunt-0.4.4.tgz";
        sha1 = "f37fa46e2e52e37f9a0370542a74281c09c73f53";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt" or []);
    deps = [
      self.by-version."async"."0.1.22"
      self.by-version."coffee-script"."1.3.3"
      self.by-version."colors"."0.6.2"
      self.by-version."dateformat"."1.0.2-1.2.3"
      self.by-version."eventemitter2"."0.4.13"
      self.by-version."findup-sync"."0.1.3"
      self.by-version."glob"."3.1.21"
      self.by-version."hooker"."0.2.3"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."minimatch"."0.2.14"
      self.by-version."nopt"."1.0.10"
      self.by-version."rimraf"."2.2.6"
      self.by-version."lodash"."0.9.2"
      self.by-version."underscore.string"."2.2.1"
      self.by-version."which"."1.0.5"
      self.by-version."js-yaml"."2.0.5"
      self.by-version."exit"."0.1.2"
      self.by-version."getobject"."0.1.0"
      self.by-version."grunt-legacy-util"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt" ];
  };
  by-spec."grunt"."^0.4.0" =
    self.by-version."grunt"."0.4.4";
  by-spec."grunt"."~0.4" =
    self.by-version."grunt"."0.4.4";
  by-spec."grunt"."~0.4.0" =
    self.by-version."grunt"."0.4.4";
  by-spec."grunt"."~0.4.1" =
    self.by-version."grunt"."0.4.4";
  by-spec."grunt-bower-task"."*" =
    self.by-version."grunt-bower-task"."0.3.4";
  by-version."grunt-bower-task"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-bower-task-0.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-bower-task/-/grunt-bower-task-0.3.4.tgz";
        name = "grunt-bower-task-0.3.4.tgz";
        sha1 = "6f713725ae96bb22ed60b1173cf4c522bbb8583b";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-bower-task" or []);
    deps = [
      self.by-version."bower"."1.2.8"
      self.by-version."lodash"."0.10.0"
      self.by-version."rimraf"."2.0.3"
      self.by-version."wrench"."1.4.4"
      self.by-version."colors"."0.6.2"
      self.by-version."async"."0.1.22"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-bower-task" ];
  };
  "grunt-bower-task" = self.by-version."grunt-bower-task"."0.3.4";
  by-spec."grunt-cli"."*" =
    self.by-version."grunt-cli"."0.1.13";
  by-version."grunt-cli"."0.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-cli-0.1.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-cli/-/grunt-cli-0.1.13.tgz";
        name = "grunt-cli-0.1.13.tgz";
        sha1 = "e9ebc4047631f5012d922770c39378133cad10f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-cli" or []);
    deps = [
      self.by-version."nopt"."1.0.10"
      self.by-version."findup-sync"."0.1.3"
      self.by-version."resolve"."0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-cli" ];
  };
  "grunt-cli" = self.by-version."grunt-cli"."0.1.13";
  by-spec."grunt-cli"."~0.1.7" =
    self.by-version."grunt-cli"."0.1.13";
  by-spec."grunt-contrib-cssmin"."*" =
    self.by-version."grunt-contrib-cssmin"."0.9.0";
  by-version."grunt-contrib-cssmin"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-contrib-cssmin-0.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-cssmin/-/grunt-contrib-cssmin-0.9.0.tgz";
        name = "grunt-contrib-cssmin-0.9.0.tgz";
        sha1 = "27241f0160a8866659dab40dc8c2776c01ec7ce2";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-cssmin" or []);
    deps = [
      self.by-version."chalk"."0.4.0"
      self.by-version."clean-css"."2.1.7"
      self.by-version."maxmin"."0.1.0"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
    ];
    passthru.names = [ "grunt-contrib-cssmin" ];
  };
  "grunt-contrib-cssmin" = self.by-version."grunt-contrib-cssmin"."0.9.0";
  by-spec."grunt-contrib-jshint"."*" =
    self.by-version."grunt-contrib-jshint"."0.9.2";
  by-version."grunt-contrib-jshint"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-contrib-jshint-0.9.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-jshint/-/grunt-contrib-jshint-0.9.2.tgz";
        name = "grunt-contrib-jshint-0.9.2.tgz";
        sha1 = "d6301597bcc3611e95f5f35ff582a7b3d73d20fb";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-jshint" or []);
    deps = [
      self.by-version."jshint"."2.4.4"
      self.by-version."hooker"."0.2.3"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
    ];
    passthru.names = [ "grunt-contrib-jshint" ];
  };
  "grunt-contrib-jshint" = self.by-version."grunt-contrib-jshint"."0.9.2";
  by-spec."grunt-contrib-less"."*" =
    self.by-version."grunt-contrib-less"."0.11.0";
  by-version."grunt-contrib-less"."0.11.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-contrib-less-0.11.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-less/-/grunt-contrib-less-0.11.0.tgz";
        name = "grunt-contrib-less-0.11.0.tgz";
        sha1 = "601cbdda0591f7fde7fe50278cd904fedede90ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-less" or []);
    deps = [
      self.by-version."less"."1.7.0"
      self.by-version."chalk"."0.4.0"
      self.by-version."maxmin"."0.1.0"
      self.by-version."lodash"."2.4.1"
      self.by-version."async"."0.2.10"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
    ];
    passthru.names = [ "grunt-contrib-less" ];
  };
  "grunt-contrib-less" = self.by-version."grunt-contrib-less"."0.11.0";
  by-spec."grunt-contrib-requirejs"."*" =
    self.by-version."grunt-contrib-requirejs"."0.4.3";
  by-version."grunt-contrib-requirejs"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-contrib-requirejs-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-requirejs/-/grunt-contrib-requirejs-0.4.3.tgz";
        name = "grunt-contrib-requirejs-0.4.3.tgz";
        sha1 = "ac243dc312af5c85cd095169da1b3177bfe89c59";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-requirejs" or []);
    deps = [
      self.by-version."requirejs"."2.1.11"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
    ];
    passthru.names = [ "grunt-contrib-requirejs" ];
  };
  "grunt-contrib-requirejs" = self.by-version."grunt-contrib-requirejs"."0.4.3";
  by-spec."grunt-contrib-uglify"."*" =
    self.by-version."grunt-contrib-uglify"."0.4.0";
  by-version."grunt-contrib-uglify"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-contrib-uglify-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-0.4.0.tgz";
        name = "grunt-contrib-uglify-0.4.0.tgz";
        sha1 = "6a4df3e85ccf4bbae484b0328cc71c9f102e80be";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-uglify" or []);
    deps = [
      self.by-version."uglify-js"."2.4.13"
      self.by-version."chalk"."0.4.0"
      self.by-version."maxmin"."0.1.0"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
    ];
    passthru.names = [ "grunt-contrib-uglify" ];
  };
  "grunt-contrib-uglify" = self.by-version."grunt-contrib-uglify"."0.4.0";
  by-spec."grunt-karma"."*" =
    self.by-version."grunt-karma"."0.8.2";
  by-version."grunt-karma"."0.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-karma-0.8.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-karma/-/grunt-karma-0.8.2.tgz";
        name = "grunt-karma-0.8.2.tgz";
        sha1 = "0f422d357e4556fb96ab68c6d9a2be46908f1c84";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-karma" or []);
    deps = [
      self.by-version."lodash"."2.4.1"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
      self.by-version."karma"."0.12.1"
    ];
    passthru.names = [ "grunt-karma" ];
  };
  "grunt-karma" = self.by-version."grunt-karma"."0.8.2";
  by-spec."grunt-legacy-util"."~0.1.2" =
    self.by-version."grunt-legacy-util"."0.1.2";
  by-version."grunt-legacy-util"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-legacy-util-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-legacy-util/-/grunt-legacy-util-0.1.2.tgz";
        name = "grunt-legacy-util-0.1.2.tgz";
        sha1 = "be84d337ef4a0137dc8566092a46528fd8957ebd";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-legacy-util" or []);
    deps = [
      self.by-version."hooker"."0.2.3"
      self.by-version."async"."0.1.22"
      self.by-version."lodash"."0.9.2"
      self.by-version."exit"."0.1.2"
      self.by-version."underscore.string"."2.2.1"
      self.by-version."getobject"."0.1.0"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-legacy-util" ];
  };
  by-spec."grunt-sed"."*" =
    self.by-version."grunt-sed"."0.1.1";
  by-version."grunt-sed"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-grunt-sed-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-sed/-/grunt-sed-0.1.1.tgz";
        name = "grunt-sed-0.1.1.tgz";
        sha1 = "2613d486909319b3f8f4bd75dafb46a642ec3f82";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-sed" or []);
    deps = [
      self.by-version."replace"."0.2.9"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.4"
    ];
    passthru.names = [ "grunt-sed" ];
  };
  "grunt-sed" = self.by-version."grunt-sed"."0.1.1";
  by-spec."guifi-earth"."https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854 " =
    self.by-version."guifi-earth"."0.2.1";
  by-version."guifi-earth"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "guifi-earth-0.2.1";
    src = [
      (fetchurl {
        url = "https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854";
        name = "guifi-earth-0.2.1.tgz";
        sha256 = "a51a5beef55c14c68630275d51cf66c44a4462d1b20c0f08aef6d88a62ca077c";
      })
    ];
    buildInputs =
      (self.nativeDeps."guifi-earth" or []);
    deps = [
      self.by-version."coffee-script"."1.7.1"
      self.by-version."jade"."1.3.0"
      self.by-version."q"."2.0.1"
      self.by-version."xml2js"."0.4.1"
      self.by-version."msgpack"."0.2.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "guifi-earth" ];
  };
  "guifi-earth" = self.by-version."guifi-earth"."0.2.1";
  by-spec."gzip-size"."^0.1.0" =
    self.by-version."gzip-size"."0.1.0";
  by-version."gzip-size"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "gzip-size-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzip-size/-/gzip-size-0.1.0.tgz";
        name = "gzip-size-0.1.0.tgz";
        sha1 = "2beaecdaf4917bd151fe9a9d43ae199392d6c32a";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzip-size" or []);
    deps = [
      self.by-version."concat-stream"."1.4.4"
      self.by-version."zlib-browserify"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gzip-size" ];
  };
  by-spec."gzippo"."*" =
    self.by-version."gzippo"."0.2.0";
  by-version."gzippo"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-gzippo-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzippo/-/gzippo-0.2.0.tgz";
        name = "gzippo-0.2.0.tgz";
        sha1 = "ffc594c482190c56531ed2d4a5864d0b0b7d2733";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzippo" or []);
    deps = [
      self.by-version."send"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gzippo" ];
  };
  "gzippo" = self.by-version."gzippo"."0.2.0";
  by-spec."handlebars"."1.0.11" =
    self.by-version."handlebars"."1.0.11";
  by-version."handlebars"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.0.11.tgz";
        name = "handlebars-1.0.11.tgz";
        sha1 = "28b8af8b1f3658ef377e621e0d6b07078fc450a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars" or []);
    deps = [
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-js"."1.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  by-spec."handlebars"."1.3.x" =
    self.by-version."handlebars"."1.3.0";
  by-version."handlebars"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.3.0.tgz";
        name = "handlebars-1.3.0.tgz";
        sha1 = "9e9b130a93e389491322d975cf3ec1818c37ce34";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars" or []);
    deps = [
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-js"."2.3.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  by-spec."handlebars"."~1.0.11" =
    self.by-version."handlebars"."1.0.12";
  by-version."handlebars"."1.0.12" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.0.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.0.12.tgz";
        name = "handlebars-1.0.12.tgz";
        sha1 = "18c6d3440c35e91b19b3ff582b9151ab4985d4fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars" or []);
    deps = [
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-js"."2.3.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  by-spec."handlebars"."~1.3.0" =
    self.by-version."handlebars"."1.3.0";
  by-spec."has-color"."~0.1.0" =
    self.by-version."has-color"."0.1.4";
  by-version."has-color"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-has-color-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-color/-/has-color-0.1.4.tgz";
        name = "has-color-0.1.4.tgz";
        sha1 = "d1dadeea5b9e8b446bf08603532333710c95a290";
      })
    ];
    buildInputs =
      (self.nativeDeps."has-color" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "has-color" ];
  };
  by-spec."hasher"."~1.2.0" =
    self.by-version."hasher"."1.2.0";
  by-version."hasher"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-hasher-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hasher/-/hasher-1.2.0.tgz";
        name = "hasher-1.2.0.tgz";
        sha1 = "8b5341c3496124b0724ac8555fbb8ca363ebbb73";
      })
    ];
    buildInputs =
      (self.nativeDeps."hasher" or []);
    deps = [
      self.by-version."signals"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hasher" ];
  };
  by-spec."hashring"."1.0.1" =
    self.by-version."hashring"."1.0.1";
  by-version."hashring"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-hashring-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hashring/-/hashring-1.0.1.tgz";
        name = "hashring-1.0.1.tgz";
        sha1 = "b6a7b8c675a0c715ac0d0071786eb241a28d0a7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."hashring" or []);
    deps = [
      self.by-version."connection-parse"."0.0.7"
      self.by-version."simple-lru-cache"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hashring" ];
  };
  by-spec."hat"."*" =
    self.by-version."hat"."0.0.3";
  by-version."hat"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-hat-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hat/-/hat-0.0.3.tgz";
        name = "hat-0.0.3.tgz";
        sha1 = "bb014a9e64b3788aed8005917413d4ff3d502d8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hat" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hat" ];
  };
  by-spec."hawk"."~0.10.0" =
    self.by-version."hawk"."0.10.2";
  by-version."hawk"."0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-hawk-0.10.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.10.2.tgz";
        name = "hawk-0.10.2.tgz";
        sha1 = "9b361dee95a931640e6d504e05609a8fc3ac45d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = [
      self.by-version."hoek"."0.7.6"
      self.by-version."boom"."0.3.8"
      self.by-version."cryptiles"."0.1.3"
      self.by-version."sntp"."0.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."hawk"."~0.10.2" =
    self.by-version."hawk"."0.10.2";
  by-spec."hawk"."~1.0.0" =
    self.by-version."hawk"."1.0.0";
  by-version."hawk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-hawk-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.0.0.tgz";
        name = "hawk-1.0.0.tgz";
        sha1 = "b90bb169807285411da7ffcb8dd2598502d3b52d";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = [
      self.by-version."hoek"."0.9.1"
      self.by-version."boom"."0.4.2"
      self.by-version."cryptiles"."0.2.2"
      self.by-version."sntp"."0.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."he"."~0.3.6" =
    self.by-version."he"."0.3.6";
  by-version."he"."0.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "he-0.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/he/-/he-0.3.6.tgz";
        name = "he-0.3.6.tgz";
        sha1 = "9d7bc446e77963933301dd602d5731cb861135e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."he" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "he" ];
  };
  by-spec."hipache"."*" =
    self.by-version."hipache"."0.2.4";
  by-version."hipache"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "hipache-0.2.4";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/hipache/-/hipache-0.2.4.tgz";
        name = "hipache-0.2.4.tgz";
        sha1 = "1d6a06bf88cac084b5fcd01959392c8b4889ec65";
      })
    ];
    buildInputs =
      (self.nativeDeps."hipache" or []);
    deps = [
      self.by-version."read-installed"."0.2.2"
      self.by-version."http-proxy"."0.10.3"
      self.by-version."redis"."0.8.6"
      self.by-version."lru-cache"."2.2.4"
      self.by-version."optimist"."0.3.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hipache" ];
  };
  "hipache" = self.by-version."hipache"."0.2.4";
  by-spec."hiredis"."*" =
    self.by-version."hiredis"."0.1.16";
  by-version."hiredis"."0.1.16" = lib.makeOverridable self.buildNodePackage {
    name = "node-hiredis-0.1.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hiredis/-/hiredis-0.1.16.tgz";
        name = "hiredis-0.1.16.tgz";
        sha1 = "f6cee1add2589b8b71cef3c4d3936a9fcd638640";
      })
    ];
    buildInputs =
      (self.nativeDeps."hiredis" or []);
    deps = [
      self.by-version."bindings"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hiredis" ];
  };
  by-spec."hoek"."0.7.x" =
    self.by-version."hoek"."0.7.6";
  by-version."hoek"."0.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-hoek-0.7.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.7.6.tgz";
        name = "hoek-0.7.6.tgz";
        sha1 = "60fbd904557541cd2b8795abf308a1b3770e155a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-hoek-0.9.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
        name = "hoek-0.9.1.tgz";
        sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."hooker"."~0.2.3" =
    self.by-version."hooker"."0.2.3";
  by-version."hooker"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-hooker-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hooker/-/hooker-0.2.3.tgz";
        name = "hooker-0.2.3.tgz";
        sha1 = "b834f723cc4a242aa65963459df6d984c5d3d959";
      })
    ];
    buildInputs =
      (self.nativeDeps."hooker" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hooker" ];
  };
  by-spec."hooks"."0.2.1" =
    self.by-version."hooks"."0.2.1";
  by-version."hooks"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-hooks-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hooks/-/hooks-0.2.1.tgz";
        name = "hooks-0.2.1.tgz";
        sha1 = "0f591b1b344bdcb3df59773f62fbbaf85bf4028b";
      })
    ];
    buildInputs =
      (self.nativeDeps."hooks" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hooks" ];
  };
  by-spec."htmlparser2"."3.1.4" =
    self.by-version."htmlparser2"."3.1.4";
  by-version."htmlparser2"."3.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-htmlparser2-3.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.1.4.tgz";
        name = "htmlparser2-3.1.4.tgz";
        sha1 = "72cbe7d5d56c01acf61fcf7b933331f4e45b36f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = [
      self.by-version."domhandler"."2.0.3"
      self.by-version."domutils"."1.1.6"
      self.by-version."domelementtype"."1.1.1"
      self.by-version."readable-stream"."1.0.26"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."htmlparser2"."3.3.x" =
    self.by-version."htmlparser2"."3.3.0";
  by-version."htmlparser2"."3.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-htmlparser2-3.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.3.0.tgz";
        name = "htmlparser2-3.3.0.tgz";
        sha1 = "cc70d05a59f6542e43f0e685c982e14c924a9efe";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = [
      self.by-version."domhandler"."2.1.0"
      self.by-version."domutils"."1.1.6"
      self.by-version."domelementtype"."1.1.1"
      self.by-version."readable-stream"."1.0.26"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."htmlparser2"."~3.4.0" =
    self.by-version."htmlparser2"."3.4.0";
  by-version."htmlparser2"."3.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-htmlparser2-3.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.4.0.tgz";
        name = "htmlparser2-3.4.0.tgz";
        sha1 = "a1cd65f5823ad285e19d63b085ad722d0a51eae7";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = [
      self.by-version."domhandler"."2.2.0"
      self.by-version."domutils"."1.3.0"
      self.by-version."domelementtype"."1.1.1"
      self.by-version."readable-stream"."1.1.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."http-auth"."2.0.7" =
    self.by-version."http-auth"."2.0.7";
  by-version."http-auth"."2.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-http-auth-2.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-auth/-/http-auth-2.0.7.tgz";
        name = "http-auth-2.0.7.tgz";
        sha1 = "aa1a61a4d6baae9d64436c6f0ef0f4de85c430e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-auth" or []);
    deps = [
      self.by-version."coffee-script"."1.6.3"
      self.by-version."node-uuid"."1.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-auth" ];
  };
  by-spec."http-browserify"."~1.3.1" =
    self.by-version."http-browserify"."1.3.2";
  by-version."http-browserify"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-http-browserify-1.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-browserify/-/http-browserify-1.3.2.tgz";
        name = "http-browserify-1.3.2.tgz";
        sha1 = "b562c34479349a690d7a6597df495aefa8c604f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-browserify" or []);
    deps = [
      self.by-version."Base64"."0.2.0"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-browserify" ];
  };
  by-spec."http-proxy"."git://github.com/samalba/node-http-proxy" =
    self.by-version."http-proxy"."0.10.3";
  by-version."http-proxy"."0.10.3" = lib.makeOverridable self.buildNodePackage {
    name = "http-proxy-0.10.3";
    src = [
      (fetchgit {
        url = "git://github.com/samalba/node-http-proxy";
        rev = "8e277989d2d05edaee65e524fb4fba9142c52aa5";
        sha256 = "8ce0e05c73e517eefc6d9bf8b61349351aee119c2fb60763f23170607cc0e41f";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-proxy" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."optimist"."0.3.7"
      self.by-version."pkginfo"."0.2.3"
      self.by-version."utile"."0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-proxy" ];
  };
  by-spec."http-proxy"."~0.10" =
    self.by-version."http-proxy"."0.10.4";
  by-version."http-proxy"."0.10.4" = lib.makeOverridable self.buildNodePackage {
    name = "http-proxy-0.10.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-proxy/-/http-proxy-0.10.4.tgz";
        name = "http-proxy-0.10.4.tgz";
        sha1 = "14ba0ceaa2197f89fa30dea9e7b09e19cd93c22f";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-proxy" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."optimist"."0.6.1"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."utile"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-proxy" ];
  };
  by-spec."http-signature"."0.9.11" =
    self.by-version."http-signature"."0.9.11";
  by-version."http-signature"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-http-signature-0.9.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.9.11.tgz";
        name = "http-signature-0.9.11.tgz";
        sha1 = "9e882714572315e6790a5d0a7955efff1f19e653";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = [
      self.by-version."assert-plus"."0.1.2"
      self.by-version."asn1"."0.1.11"
      self.by-version."ctype"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.0";
  by-version."http-signature"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-http-signature-0.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.0.tgz";
        name = "http-signature-0.10.0.tgz";
        sha1 = "1494e4f5000a83c0f11bcc12d6007c530cb99582";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = [
      self.by-version."assert-plus"."0.1.2"
      self.by-version."asn1"."0.1.11"
      self.by-version."ctype"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."https-browserify"."~0.0.0" =
    self.by-version."https-browserify"."0.0.0";
  by-version."https-browserify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-https-browserify-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/https-browserify/-/https-browserify-0.0.0.tgz";
        name = "https-browserify-0.0.0.tgz";
        sha1 = "b3ffdfe734b2a3d4a9efd58e8654c91fce86eafd";
      })
    ];
    buildInputs =
      (self.nativeDeps."https-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "https-browserify" ];
  };
  by-spec."humanize"."~0.0.9" =
    self.by-version."humanize"."0.0.9";
  by-version."humanize"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-humanize-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/humanize/-/humanize-0.0.9.tgz";
        name = "humanize-0.0.9.tgz";
        sha1 = "1994ffaecdfe9c441ed2bdac7452b7bb4c9e41a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."humanize" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "humanize" ];
  };
  by-spec."i"."0.3.x" =
    self.by-version."i"."0.3.2";
  by-version."i"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-i-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/i/-/i-0.3.2.tgz";
        name = "i-0.3.2.tgz";
        sha1 = "b2e2d6ef47900bd924e281231ff4c5cc798d9ea8";
      })
    ];
    buildInputs =
      (self.nativeDeps."i" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "i" ];
  };
  by-spec."i18next"."*" =
    self.by-version."i18next"."1.7.1";
  by-version."i18next"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-i18next-1.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/i18next/-/i18next-1.7.1.tgz";
        name = "i18next-1.7.1.tgz";
        sha1 = "39616a1fe88258edbdd0da918b9ee49a1bd1e124";
      })
    ];
    buildInputs =
      (self.nativeDeps."i18next" or []);
    deps = [
      self.by-version."cookies"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "i18next" ];
  };
  "i18next" = self.by-version."i18next"."1.7.1";
  by-spec."ibrik"."~1.1.1" =
    self.by-version."ibrik"."1.1.1";
  by-version."ibrik"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "ibrik-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ibrik/-/ibrik-1.1.1.tgz";
        name = "ibrik-1.1.1.tgz";
        sha1 = "c9bd04c5137e967a2f0dbc9e4eb31dbfa04801b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."ibrik" or []);
    deps = [
      self.by-version."lodash"."2.4.1"
      self.by-version."coffee-script-redux"."2.0.0-beta8"
      self.by-version."istanbul"."0.2.6"
      self.by-version."estraverse"."1.5.0"
      self.by-version."escodegen"."1.1.0"
      self.by-version."which"."1.0.5"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."optimist"."0.6.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ibrik" ];
  };
  by-spec."iconv-lite"."~0.2.10" =
    self.by-version."iconv-lite"."0.2.11";
  by-version."iconv-lite"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-iconv-lite-0.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.2.11.tgz";
        name = "iconv-lite-0.2.11.tgz";
        sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  by-spec."iconv-lite"."~0.2.11" =
    self.by-version."iconv-lite"."0.2.11";
  by-spec."ieee754"."~1.1.1" =
    self.by-version."ieee754"."1.1.3";
  by-version."ieee754"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-ieee754-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ieee754/-/ieee754-1.1.3.tgz";
        name = "ieee754-1.1.3.tgz";
        sha1 = "1d4baae872e15ba69f6ab7588a965e09d485ec50";
      })
    ];
    buildInputs =
      (self.nativeDeps."ieee754" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ieee754" ];
  };
  by-spec."indexof"."0.0.1" =
    self.by-version."indexof"."0.0.1";
  by-version."indexof"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-indexof-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/indexof/-/indexof-0.0.1.tgz";
        name = "indexof-0.0.1.tgz";
        sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
      })
    ];
    buildInputs =
      (self.nativeDeps."indexof" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "indexof" ];
  };
  by-spec."inherits"."1" =
    self.by-version."inherits"."1.0.0";
  by-version."inherits"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-inherits-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
        name = "inherits-1.0.0.tgz";
        sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  by-spec."inherits"."1.x" =
    self.by-version."inherits"."1.0.0";
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-inherits-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        name = "inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  by-spec."inherits"."2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~1.0.0" =
    self.by-version."inherits"."1.0.0";
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ini"."1" =
    self.by-version."ini"."1.1.0";
  by-version."ini"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ini-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.1.0.tgz";
        name = "ini-1.1.0.tgz";
        sha1 = "4e808c2ce144c6c1788918e034d6797bc6cf6281";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  by-spec."ini"."1.x.x" =
    self.by-version."ini"."1.1.0";
  by-spec."ini"."~1.1.0" =
    self.by-version."ini"."1.1.0";
  by-spec."init-package-json"."0.0.15" =
    self.by-version."init-package-json"."0.0.15";
  by-version."init-package-json"."0.0.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-init-package-json-0.0.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-0.0.15.tgz";
        name = "init-package-json-0.0.15.tgz";
        sha1 = "d40f0201e4de6aa2b3fdc4208ae162766703ebed";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json" or []);
    deps = [
      self.by-version."promzard"."0.2.1"
      self.by-version."read"."1.0.5"
      self.by-version."read-package-json"."1.1.8"
      self.by-version."semver"."2.2.1"
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  by-spec."inline-source-map"."~0.3.0" =
    self.by-version."inline-source-map"."0.3.0";
  by-version."inline-source-map"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-inline-source-map-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inline-source-map/-/inline-source-map-0.3.0.tgz";
        name = "inline-source-map-0.3.0.tgz";
        sha1 = "ad2acca97d82fcb9d0a56221ee72e8043116424a";
      })
    ];
    buildInputs =
      (self.nativeDeps."inline-source-map" or []);
    deps = [
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inline-source-map" ];
  };
  by-spec."inquirer"."~0.3.0" =
    self.by-version."inquirer"."0.3.5";
  by-version."inquirer"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-inquirer-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.3.5.tgz";
        name = "inquirer-0.3.5.tgz";
        sha1 = "a78be064ac9abf168147c02169a931d9a483a9f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer" or []);
    deps = [
      self.by-version."lodash"."1.2.1"
      self.by-version."async"."0.2.10"
      self.by-version."cli-color"."0.2.3"
      self.by-version."mute-stream"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  by-spec."inquirer"."~0.3.1" =
    self.by-version."inquirer"."0.3.5";
  by-spec."inquirer"."~0.3.4" =
    self.by-version."inquirer"."0.3.5";
  by-spec."inquirer"."~0.4.0" =
    self.by-version."inquirer"."0.4.1";
  by-version."inquirer"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-inquirer-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.4.1.tgz";
        name = "inquirer-0.4.1.tgz";
        sha1 = "6cf74eb1a347f97a1a207bea8ad1c987d0ff4b81";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer" or []);
    deps = [
      self.by-version."lodash"."2.4.1"
      self.by-version."async"."0.2.10"
      self.by-version."cli-color"."0.2.3"
      self.by-version."mute-stream"."0.0.4"
      self.by-version."through"."2.3.4"
      self.by-version."readline2"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  by-spec."insert-module-globals"."~3.2.0" =
    self.by-version."insert-module-globals"."3.2.0";
  by-version."insert-module-globals"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "insert-module-globals-3.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insert-module-globals/-/insert-module-globals-3.2.0.tgz";
        name = "insert-module-globals-3.2.0.tgz";
        sha1 = "5692a834207adebb3effa9f9def7cf314890a63b";
      })
    ];
    buildInputs =
      (self.nativeDeps."insert-module-globals" or []);
    deps = [
      self.by-version."lexical-scope"."0.1.0"
      self.by-version."process"."0.5.2"
      self.by-version."through"."2.3.4"
      self.by-version."JSONStream"."0.7.1"
      self.by-version."concat-stream"."1.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "insert-module-globals" ];
  };
  by-spec."insight"."~0.3.0" =
    self.by-version."insight"."0.3.1";
  by-version."insight"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-insight-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insight/-/insight-0.3.1.tgz";
        name = "insight-0.3.1.tgz";
        sha1 = "1a14f32c06115c0850338c38a253d707b611d448";
      })
    ];
    buildInputs =
      (self.nativeDeps."insight" or []);
    deps = [
      self.by-version."chalk"."0.4.0"
      self.by-version."request"."2.27.0"
      self.by-version."configstore"."0.2.3"
      self.by-version."async"."0.2.10"
      self.by-version."inquirer"."0.4.1"
      self.by-version."object-assign"."0.1.2"
      self.by-version."lodash.debounce"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "insight" ];
  };
  by-spec."intersect"."~0.0.3" =
    self.by-version."intersect"."0.0.3";
  by-version."intersect"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-intersect-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/intersect/-/intersect-0.0.3.tgz";
        name = "intersect-0.0.3.tgz";
        sha1 = "c1a4a5e5eac6ede4af7504cc07e0ada7bc9f4920";
      })
    ];
    buildInputs =
      (self.nativeDeps."intersect" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "intersect" ];
  };
  by-spec."ironhorse"."*" =
    self.by-version."ironhorse"."0.0.9";
  by-version."ironhorse"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-ironhorse-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ironhorse/-/ironhorse-0.0.9.tgz";
        name = "ironhorse-0.0.9.tgz";
        sha1 = "9cfaf75e464a0bf394d511a05c0a8b8de080a1d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."ironhorse" or []);
    deps = [
      self.by-version."underscore"."1.5.2"
      self.by-version."winston"."0.7.3"
      self.by-version."nconf"."0.6.9"
      self.by-version."fs-walk"."0.0.1"
      self.by-version."async"."0.2.10"
      self.by-version."express"."4.0.0-rc4"
      self.by-version."jade"."1.3.0"
      self.by-version."passport"."0.2.0"
      self.by-version."passport-http"."0.2.2"
      self.by-version."js-yaml"."3.0.2"
      self.by-version."mongoose"."3.8.8"
      self.by-version."gridfs-stream"."0.4.1"
      self.by-version."temp"."0.7.0"
      self.by-version."kue"."0.7.5"
      self.by-version."redis"."0.10.1"
      self.by-version."hiredis"."0.1.16"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ironhorse" ];
  };
  "ironhorse" = self.by-version."ironhorse"."0.0.9";
  by-spec."is-promise"."~1" =
    self.by-version."is-promise"."1.0.0";
  by-version."is-promise"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-is-promise-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-promise/-/is-promise-1.0.0.tgz";
        name = "is-promise-1.0.0.tgz";
        sha1 = "b998d17551f16f69f7bd4828f58f018cc81e064f";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-promise" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "is-promise" ];
  };
  by-spec."is-root"."~0.1.0" =
    self.by-version."is-root"."0.1.0";
  by-version."is-root"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-is-root-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-root/-/is-root-0.1.0.tgz";
        name = "is-root-0.1.0.tgz";
        sha1 = "825e394ab593df2d73c5d0092fce507270b53dcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-root" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "is-root" ];
  };
  by-spec."isbinaryfile"."~0.1.8" =
    self.by-version."isbinaryfile"."0.1.9";
  by-version."isbinaryfile"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-isbinaryfile-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isbinaryfile/-/isbinaryfile-0.1.9.tgz";
        name = "isbinaryfile-0.1.9.tgz";
        sha1 = "15eece35c4ab708d8924da99fb874f2b5cc0b6c4";
      })
    ];
    buildInputs =
      (self.nativeDeps."isbinaryfile" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "isbinaryfile" ];
  };
  by-spec."isbinaryfile"."~0.1.9" =
    self.by-version."isbinaryfile"."0.1.9";
  by-spec."isbinaryfile"."~2.0.0" =
    self.by-version."isbinaryfile"."2.0.1";
  by-version."isbinaryfile"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-isbinaryfile-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isbinaryfile/-/isbinaryfile-2.0.1.tgz";
        name = "isbinaryfile-2.0.1.tgz";
        sha1 = "b92369bfdaf616027133e077c5ba145f36699d55";
      })
    ];
    buildInputs =
      (self.nativeDeps."isbinaryfile" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "isbinaryfile" ];
  };
  by-spec."istanbul"."*" =
    self.by-version."istanbul"."0.2.6";
  by-version."istanbul"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.2.6.tgz";
        name = "istanbul-0.2.6.tgz";
        sha1 = "2c56f1c715aa47fc67eed291123adef8bc45e6a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."escodegen"."1.2.0"
      self.by-version."handlebars"."1.3.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."nopt"."2.2.0"
      self.by-version."fileset"."0.1.5"
      self.by-version."which"."1.0.5"
      self.by-version."async"."0.2.10"
      self.by-version."abbrev"."1.0.4"
      self.by-version."wordwrap"."0.0.2"
      self.by-version."resolve"."0.6.2"
      self.by-version."js-yaml"."3.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  "istanbul" = self.by-version."istanbul"."0.2.6";
  by-spec."istanbul"."~0.2.3" =
    self.by-version."istanbul"."0.2.6";
  by-spec."istanbul"."~0.2.4" =
    self.by-version."istanbul"."0.2.6";
  by-spec."jade"."*" =
    self.by-version."jade"."1.3.0";
  by-version."jade"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-1.3.0.tgz";
        name = "jade-1.3.0.tgz";
        sha1 = "776cae93f1ad5af6b61eff2340fcdc19a3225d48";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = [
      self.by-version."commander"."2.1.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."transformers"."2.1.0"
      self.by-version."character-parser"."1.2.0"
      self.by-version."monocle"."1.1.51"
      self.by-version."with"."3.0.0"
      self.by-version."constantinople"."2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  "jade" = self.by-version."jade"."1.3.0";
  by-spec."jade"."0.26.3" =
    self.by-version."jade"."0.26.3";
  by-version."jade"."0.26.3" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.26.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.26.3.tgz";
        name = "jade-0.26.3.tgz";
        sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = [
      self.by-version."commander"."0.6.1"
      self.by-version."mkdirp"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jade"."0.27.0" =
    self.by-version."jade"."0.27.0";
  by-version."jade"."0.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.27.0.tgz";
        name = "jade-0.27.0.tgz";
        sha1 = "dc5ebed10d04a5e0eaf49ef0009bec473d1a6b31";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = [
      self.by-version."commander"."0.6.1"
      self.by-version."mkdirp"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jade"."1.1.5" =
    self.by-version."jade"."1.1.5";
  by-version."jade"."1.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "jade-1.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-1.1.5.tgz";
        name = "jade-1.1.5.tgz";
        sha1 = "e884d3d3565807e280f5ba760f68addb176627a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = [
      self.by-version."commander"."2.1.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."transformers"."2.1.0"
      self.by-version."character-parser"."1.2.0"
      self.by-version."monocle"."1.1.51"
      self.by-version."with"."2.0.0"
      self.by-version."constantinople"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jade".">= 0.0.1" =
    self.by-version."jade"."1.3.0";
  by-spec."jade"."~0.35.0" =
    self.by-version."jade"."0.35.0";
  by-version."jade"."0.35.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.35.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.35.0.tgz";
        name = "jade-0.35.0.tgz";
        sha1 = "75ec1d966a1203733613e8c180e2aa8685c16da9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = [
      self.by-version."commander"."2.0.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."transformers"."2.1.0"
      self.by-version."character-parser"."1.2.0"
      self.by-version."monocle"."1.1.50"
      self.by-version."with"."1.1.1"
      self.by-version."constantinople"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jayschema"."*" =
    self.by-version."jayschema"."0.2.6";
  by-version."jayschema"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "jayschema-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jayschema/-/jayschema-0.2.6.tgz";
        name = "jayschema-0.2.6.tgz";
        sha1 = "c160e767cef66babda76b0fc34a06d4adc44965d";
      })
    ];
    buildInputs =
      (self.nativeDeps."jayschema" or []);
    deps = [
      self.by-version."when"."2.8.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jayschema" ];
  };
  "jayschema" = self.by-version."jayschema"."0.2.6";
  by-spec."js-yaml"."*" =
    self.by-version."js-yaml"."3.0.2";
  by-version."js-yaml"."3.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.0.2.tgz";
        name = "js-yaml-3.0.2.tgz";
        sha1 = "9937865f8e897a5e894e73c2c5cf2e89b32eb771";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = [
      self.by-version."argparse"."0.1.15"
      self.by-version."esprima"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  "js-yaml" = self.by-version."js-yaml"."3.0.2";
  by-spec."js-yaml"."0.3.x" =
    self.by-version."js-yaml"."0.3.7";
  by-version."js-yaml"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-js-yaml-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-0.3.7.tgz";
        name = "js-yaml-0.3.7.tgz";
        sha1 = "d739d8ee86461e54b354d6a7d7d1f2ad9a167f62";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."2.1.0" =
    self.by-version."js-yaml"."2.1.0";
  by-version."js-yaml"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.0.tgz";
        name = "js-yaml-2.1.0.tgz";
        sha1 = "a55a6e4706b01d06326259a6f4bfc42e6ae38b1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = [
      self.by-version."argparse"."0.1.15"
      self.by-version."esprima"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."3.0.1" =
    self.by-version."js-yaml"."3.0.1";
  by-version."js-yaml"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.0.1.tgz";
        name = "js-yaml-3.0.1.tgz";
        sha1 = "76405fea5bce30fc8f405d48c6dca7f0a32c6afe";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = [
      self.by-version."argparse"."0.1.15"
      self.by-version."esprima"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."3.x" =
    self.by-version."js-yaml"."3.0.2";
  by-spec."js-yaml"."~2.0.5" =
    self.by-version."js-yaml"."2.0.5";
  by-version."js-yaml"."2.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.0.5.tgz";
        name = "js-yaml-2.0.5.tgz";
        sha1 = "a25ae6509999e97df278c6719da11bd0687743a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = [
      self.by-version."argparse"."0.1.15"
      self.by-version."esprima"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."~3.0.1" =
    self.by-version."js-yaml"."3.0.2";
  by-spec."jsesc"."0.4.3" =
    self.by-version."jsesc"."0.4.3";
  by-version."jsesc"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "jsesc-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsesc/-/jsesc-0.4.3.tgz";
        name = "jsesc-0.4.3.tgz";
        sha1 = "a9c7f90afd5a1bf2ee64df6c416dab61672d2ae9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsesc" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsesc" ];
  };
  by-spec."jsesc"."~0.4.3" =
    self.by-version."jsesc"."0.4.3";
  by-spec."jshint"."*" =
    self.by-version."jshint"."2.4.4";
  by-version."jshint"."2.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.4.4.tgz";
        name = "jshint-2.4.4.tgz";
        sha1 = "4162238314c649f987752651e8e064e30a68706e";
      })
    ];
    buildInputs =
      (self.nativeDeps."jshint" or []);
    deps = [
      self.by-version."shelljs"."0.1.4"
      self.by-version."underscore"."1.4.4"
      self.by-version."cli"."0.4.5"
      self.by-version."minimatch"."0.2.14"
      self.by-version."htmlparser2"."3.3.0"
      self.by-version."console-browserify"."0.1.6"
      self.by-version."exit"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  "jshint" = self.by-version."jshint"."2.4.4";
  by-spec."jshint"."~2.4.0" =
    self.by-version."jshint"."2.4.4";
  by-spec."json-schema"."0.2.2" =
    self.by-version."json-schema"."0.2.2";
  by-version."json-schema"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-json-schema-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
        name = "json-schema-0.2.2.tgz";
        sha1 = "50354f19f603917c695f70b85afa77c3b0f23506";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-schema" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-schema" ];
  };
  by-spec."json-stringify-safe"."~3.0.0" =
    self.by-version."json-stringify-safe"."3.0.0";
  by-version."json-stringify-safe"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-json-stringify-safe-3.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-3.0.0.tgz";
        name = "json-stringify-safe-3.0.0.tgz";
        sha1 = "9db7b0e530c7f289c5e8c8432af191c2ff75a5b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-json-stringify-safe-5.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
        name = "json-stringify-safe-5.0.0.tgz";
        sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  by-spec."jsonfile"."~1.0.1" =
    self.by-version."jsonfile"."1.0.1";
  by-version."jsonfile"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-jsonfile-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonfile/-/jsonfile-1.0.1.tgz";
        name = "jsonfile-1.0.1.tgz";
        sha1 = "ea5efe40b83690b98667614a7392fc60e842c0dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonfile" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsonfile" ];
  };
  by-spec."jsonify"."~0.0.0" =
    self.by-version."jsonify"."0.0.0";
  by-version."jsonify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-jsonify-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz";
        name = "jsonify-0.0.0.tgz";
        sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsonify" ];
  };
  by-spec."jsonparse"."0.0.5" =
    self.by-version."jsonparse"."0.0.5";
  by-version."jsonparse"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-jsonparse-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonparse/-/jsonparse-0.0.5.tgz";
        name = "jsonparse-0.0.5.tgz";
        sha1 = "330542ad3f0a654665b778f3eb2d9a9fa507ac64";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonparse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsonparse" ];
  };
  by-spec."jsontool"."*" =
    self.by-version."jsontool"."7.0.1";
  by-version."jsontool"."7.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "jsontool-7.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsontool/-/jsontool-7.0.1.tgz";
        name = "jsontool-7.0.1.tgz";
        sha1 = "d5a705e46e305d7377ede769707c072e6d957977";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsontool" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsontool" ];
  };
  "jsontool" = self.by-version."jsontool"."7.0.1";
  by-spec."jsprim"."0.3.0" =
    self.by-version."jsprim"."0.3.0";
  by-version."jsprim"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-jsprim-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsprim/-/jsprim-0.3.0.tgz";
        name = "jsprim-0.3.0.tgz";
        sha1 = "cd13466ea2480dbd8396a570d47d31dda476f8b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsprim" or []);
    deps = [
      self.by-version."extsprintf"."1.0.0"
      self.by-version."json-schema"."0.2.2"
      self.by-version."verror"."1.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsprim" ];
  };
  by-spec."junk"."~0.2.0" =
    self.by-version."junk"."0.2.2";
  by-version."junk"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-junk-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/junk/-/junk-0.2.2.tgz";
        name = "junk-0.2.2.tgz";
        sha1 = "d595eb199b37930cecd1f2c52820847e80e48ae7";
      })
    ];
    buildInputs =
      (self.nativeDeps."junk" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "junk" ];
  };
  by-spec."karma"."*" =
    self.by-version."karma"."0.12.1";
  by-version."karma"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.12.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.12.1.tgz";
        name = "karma-0.12.1.tgz";
        sha1 = "7e785eea935174c8d53d9841f82380079d8c077b";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma" or []);
    deps = [
      self.by-version."di"."0.0.1"
      self.by-version."socket.io"."0.9.16"
      self.by-version."chokidar"."0.8.2"
      self.by-version."glob"."3.2.9"
      self.by-version."minimatch"."0.2.14"
      self.by-version."http-proxy"."0.10.4"
      self.by-version."optimist"."0.6.1"
      self.by-version."rimraf"."2.2.6"
      self.by-version."q"."0.9.7"
      self.by-version."colors"."0.6.2"
      self.by-version."lodash"."2.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."log4js"."0.6.12"
      self.by-version."useragent"."2.0.8"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."connect"."2.12.0"
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "karma" ];
  };
  "karma" = self.by-version."karma"."0.12.1";
  by-spec."karma".">=0.11.11" =
    self.by-version."karma"."0.12.1";
  by-spec."karma".">=0.9" =
    self.by-version."karma"."0.12.1";
  by-spec."karma".">=0.9.3" =
    self.by-version."karma"."0.12.1";
  by-spec."karma"."~0.12.0" =
    self.by-version."karma"."0.12.1";
  by-spec."karma-chrome-launcher"."*" =
    self.by-version."karma-chrome-launcher"."0.1.2";
  by-version."karma-chrome-launcher"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-karma-chrome-launcher-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-0.1.2.tgz";
        name = "karma-chrome-launcher-0.1.2.tgz";
        sha1 = "f7154d03be01f4c246368d56d43d7232e14ccce6";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-chrome-launcher" or []);
    deps = [
    ];
    peerDependencies = [
      self.by-version."karma"."0.12.1"
    ];
    passthru.names = [ "karma-chrome-launcher" ];
  };
  "karma-chrome-launcher" = self.by-version."karma-chrome-launcher"."0.1.2";
  by-spec."karma-coverage"."*" =
    self.by-version."karma-coverage"."0.2.1";
  by-version."karma-coverage"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-karma-coverage-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coverage/-/karma-coverage-0.2.1.tgz";
        name = "karma-coverage-0.2.1.tgz";
        sha1 = "3b1bce268711a631e008e108930906eceae0a623";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-coverage" or []);
    deps = [
      self.by-version."istanbul"."0.2.6"
      self.by-version."ibrik"."1.1.1"
      self.by-version."dateformat"."1.0.7-1.2.3"
    ];
    peerDependencies = [
      self.by-version."karma"."0.12.1"
    ];
    passthru.names = [ "karma-coverage" ];
  };
  "karma-coverage" = self.by-version."karma-coverage"."0.2.1";
  by-spec."karma-junit-reporter"."*" =
    self.by-version."karma-junit-reporter"."0.2.1";
  by-version."karma-junit-reporter"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-karma-junit-reporter-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-junit-reporter/-/karma-junit-reporter-0.2.1.tgz";
        name = "karma-junit-reporter-0.2.1.tgz";
        sha1 = "ae125962683a0d1286dc7768fbf66a8f02e448fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-junit-reporter" or []);
    deps = [
      self.by-version."xmlbuilder"."0.4.2"
    ];
    peerDependencies = [
      self.by-version."karma"."0.12.1"
    ];
    passthru.names = [ "karma-junit-reporter" ];
  };
  "karma-junit-reporter" = self.by-version."karma-junit-reporter"."0.2.1";
  by-spec."karma-mocha"."*" =
    self.by-version."karma-mocha"."0.1.3";
  by-version."karma-mocha"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-karma-mocha-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-mocha/-/karma-mocha-0.1.3.tgz";
        name = "karma-mocha-0.1.3.tgz";
        sha1 = "396e44be8ddb4abf28bfca0387924c3aeddbce1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-mocha" or []);
    deps = [
    ];
    peerDependencies = [
      self.by-version."karma"."0.12.1"
      self.by-version."mocha"."1.18.2"
    ];
    passthru.names = [ "karma-mocha" ];
  };
  "karma-mocha" = self.by-version."karma-mocha"."0.1.3";
  by-spec."karma-requirejs"."*" =
    self.by-version."karma-requirejs"."0.2.1";
  by-version."karma-requirejs"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-karma-requirejs-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-requirejs/-/karma-requirejs-0.2.1.tgz";
        name = "karma-requirejs-0.2.1.tgz";
        sha1 = "7f3ac5df67bccd9d832a928ec658d733ec983c5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-requirejs" or []);
    deps = [
    ];
    peerDependencies = [
      self.by-version."karma"."0.12.1"
      self.by-version."requirejs"."2.1.11"
    ];
    passthru.names = [ "karma-requirejs" ];
  };
  "karma-requirejs" = self.by-version."karma-requirejs"."0.2.1";
  by-spec."karma-sauce-launcher"."*" =
    self.by-version."karma-sauce-launcher"."0.2.4";
  by-version."karma-sauce-launcher"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-karma-sauce-launcher-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-sauce-launcher/-/karma-sauce-launcher-0.2.4.tgz";
        name = "karma-sauce-launcher-0.2.4.tgz";
        sha1 = "9d33b23d44c7580ea0d9d1651fd56d96276d8cd7";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-sauce-launcher" or []);
    deps = [
      self.by-version."wd"."0.2.13"
      self.by-version."sauce-connect-launcher"."0.3.2"
      self.by-version."q"."0.9.7"
      self.by-version."saucelabs"."0.1.1"
    ];
    peerDependencies = [
      self.by-version."karma"."0.12.1"
    ];
    passthru.names = [ "karma-sauce-launcher" ];
  };
  "karma-sauce-launcher" = self.by-version."karma-sauce-launcher"."0.2.4";
  by-spec."keen.io"."~0.0.4" =
    self.by-version."keen.io"."0.0.4";
  by-version."keen.io"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-keen.io-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keen.io/-/keen.io-0.0.4.tgz";
        name = "keen.io-0.0.4.tgz";
        sha1 = "041caa79371a6bec51288e222f3bb2e05c7e6b25";
      })
    ];
    buildInputs =
      (self.nativeDeps."keen.io" or []);
    deps = [
      self.by-version."superagent"."0.13.0"
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keen.io" ];
  };
  by-spec."keep-alive-agent"."0.0.1" =
    self.by-version."keep-alive-agent"."0.0.1";
  by-version."keep-alive-agent"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-keep-alive-agent-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keep-alive-agent/-/keep-alive-agent-0.0.1.tgz";
        name = "keep-alive-agent-0.0.1.tgz";
        sha1 = "44847ca394ce8d6b521ae85816bd64509942b385";
      })
    ];
    buildInputs =
      (self.nativeDeps."keep-alive-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keep-alive-agent" ];
  };
  by-spec."kerberos"."0.0.3" =
    self.by-version."kerberos"."0.0.3";
  by-version."kerberos"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-kerberos-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kerberos/-/kerberos-0.0.3.tgz";
        name = "kerberos-0.0.3.tgz";
        sha1 = "4285d92a0748db2784062f5adcec9f5956cb818a";
      })
    ];
    buildInputs =
      (self.nativeDeps."kerberos" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kerberos" ];
  };
  by-spec."kew"."~0.1.7" =
    self.by-version."kew"."0.1.7";
  by-version."kew"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-kew-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kew/-/kew-0.1.7.tgz";
        name = "kew-0.1.7.tgz";
        sha1 = "0a32a817ff1a9b3b12b8c9bacf4bc4d679af8e72";
      })
    ];
    buildInputs =
      (self.nativeDeps."kew" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kew" ];
  };
  by-spec."keygrip"."~1.0.0" =
    self.by-version."keygrip"."1.0.0";
  by-version."keygrip"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-keygrip-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keygrip/-/keygrip-1.0.0.tgz";
        name = "keygrip-1.0.0.tgz";
        sha1 = "b771120e8e697b8692b76866a84cdff3912fc379";
      })
    ];
    buildInputs =
      (self.nativeDeps."keygrip" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keygrip" ];
  };
  by-spec."keypress"."0.1.x" =
    self.by-version."keypress"."0.1.0";
  by-version."keypress"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-keypress-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keypress/-/keypress-0.1.0.tgz";
        name = "keypress-0.1.0.tgz";
        sha1 = "4a3188d4291b66b4f65edb99f806aa9ae293592a";
      })
    ];
    buildInputs =
      (self.nativeDeps."keypress" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keypress" ];
  };
  by-spec."keypress"."~0.1.0" =
    self.by-version."keypress"."0.1.0";
  by-spec."knockout"."~3.0.0" =
    self.by-version."knockout"."3.0.0";
  by-version."knockout"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-knockout-3.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knockout/-/knockout-3.0.0.tgz";
        name = "knockout-3.0.0.tgz";
        sha1 = "fd8d43ee446237cde7df650f5c7dbcf68ae49a80";
      })
    ];
    buildInputs =
      (self.nativeDeps."knockout" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "knockout" ];
  };
  by-spec."knox"."*" =
    self.by-version."knox"."0.8.9";
  by-version."knox"."0.8.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-knox-0.8.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knox/-/knox-0.8.9.tgz";
        name = "knox-0.8.9.tgz";
        sha1 = "b96ec0b4ec1be75d8006f80cb302bfa818d7001c";
      })
    ];
    buildInputs =
      (self.nativeDeps."knox" or []);
    deps = [
      self.by-version."mime"."1.2.11"
      self.by-version."xml2js"."0.2.8"
      self.by-version."debug"."0.7.4"
      self.by-version."stream-counter"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "knox" ];
  };
  "knox" = self.by-version."knox"."0.8.9";
  by-spec."kue"."*" =
    self.by-version."kue"."0.7.5";
  by-version."kue"."0.7.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-kue-0.7.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kue/-/kue-0.7.5.tgz";
        name = "kue-0.7.5.tgz";
        sha1 = "d815a8a35b22dd28df3f54f0b874403a257dc807";
      })
    ];
    buildInputs =
      (self.nativeDeps."kue" or []);
    deps = [
      self.by-version."redis"."0.10.1"
      self.by-version."express"."3.1.2"
      self.by-version."jade"."1.1.5"
      self.by-version."stylus"."0.42.2"
      self.by-version."nib"."0.5.0"
      self.by-version."reds"."0.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kue" ];
  };
  "kue" = self.by-version."kue"."0.7.5";
  by-spec."lazy"."~1.0.11" =
    self.by-version."lazy"."1.0.11";
  by-version."lazy"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-lazy-1.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lazy/-/lazy-1.0.11.tgz";
        name = "lazy-1.0.11.tgz";
        sha1 = "daa068206282542c088288e975c297c1ae77b690";
      })
    ];
    buildInputs =
      (self.nativeDeps."lazy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lazy" ];
  };
  by-spec."lazystream"."~0.1.0" =
    self.by-version."lazystream"."0.1.0";
  by-version."lazystream"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lazystream-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lazystream/-/lazystream-0.1.0.tgz";
        name = "lazystream-0.1.0.tgz";
        sha1 = "1b25d63c772a4c20f0a5ed0a9d77f484b6e16920";
      })
    ];
    buildInputs =
      (self.nativeDeps."lazystream" or []);
    deps = [
      self.by-version."readable-stream"."1.0.26"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lazystream" ];
  };
  by-spec."lcov-parse"."0.0.6" =
    self.by-version."lcov-parse"."0.0.6";
  by-version."lcov-parse"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-lcov-parse-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-parse/-/lcov-parse-0.0.6.tgz";
        name = "lcov-parse-0.0.6.tgz";
        sha1 = "819e5da8bf0791f9d3f39eea5ed1868187f11175";
      })
    ];
    buildInputs =
      (self.nativeDeps."lcov-parse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lcov-parse" ];
  };
  by-spec."lcov-result-merger"."*" =
    self.by-version."lcov-result-merger"."0.0.2";
  by-version."lcov-result-merger"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "lcov-result-merger-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-result-merger/-/lcov-result-merger-0.0.2.tgz";
        name = "lcov-result-merger-0.0.2.tgz";
        sha1 = "72a538c09f76e5c79b511bcd1053948d4aa98f10";
      })
    ];
    buildInputs =
      (self.nativeDeps."lcov-result-merger" or []);
    deps = [
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lcov-result-merger" ];
  };
  "lcov-result-merger" = self.by-version."lcov-result-merger"."0.0.2";
  by-spec."less"."^1.7.0" =
    self.by-version."less"."1.7.0";
  by-version."less"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "less-1.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-1.7.0.tgz";
        name = "less-1.7.0.tgz";
        sha1 = "6f1293bac1f402c932c2ce21ba7337f7c635ba84";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = [
      self.by-version."mime"."1.2.11"
      self.by-version."request"."2.34.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."clean-css"."2.1.7"
      self.by-version."source-map"."0.1.33"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  by-spec."less"."~1.7.0" =
    self.by-version."less"."1.7.0";
  by-spec."lexical-scope"."~0.1.0" =
    self.by-version."lexical-scope"."0.1.0";
  by-version."lexical-scope"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lexical-scope-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lexical-scope/-/lexical-scope-0.1.0.tgz";
        name = "lexical-scope-0.1.0.tgz";
        sha1 = "8f30004c80234ffac083b990079d7b267e18441b";
      })
    ];
    buildInputs =
      (self.nativeDeps."lexical-scope" or []);
    deps = [
      self.by-version."astw"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lexical-scope" ];
  };
  by-spec."libxmljs"."~0.8.1" =
    self.by-version."libxmljs"."0.8.1";
  by-version."libxmljs"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-libxmljs-0.8.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libxmljs/-/libxmljs-0.8.1.tgz";
        name = "libxmljs-0.8.1.tgz";
        sha1 = "b8b1d3962a92dbc5be9dc798bac028e09db8d630";
      })
    ];
    buildInputs =
      (self.nativeDeps."libxmljs" or []);
    deps = [
      self.by-version."bindings"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "libxmljs" ];
  };
  by-spec."libyaml"."*" =
    self.by-version."libyaml"."0.2.3";
  by-version."libyaml"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-libyaml-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libyaml/-/libyaml-0.2.3.tgz";
        name = "libyaml-0.2.3.tgz";
        sha1 = "c07e7fefcad6e09218ebf9ff814bbd520172add6";
      })
    ];
    buildInputs =
      (self.nativeDeps."libyaml" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "libyaml" ];
  };
  "libyaml" = self.by-version."libyaml"."0.2.3";
  by-spec."lockfile"."~0.4.0" =
    self.by-version."lockfile"."0.4.2";
  by-version."lockfile"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-lockfile-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lockfile/-/lockfile-0.4.2.tgz";
        name = "lockfile-0.4.2.tgz";
        sha1 = "ab91f5d3745bc005ae4fa34d078910d1f2b9612d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lockfile" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lockfile" ];
  };
  by-spec."lodash"."^2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-version."lodash"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.4.1.tgz";
        name = "lodash-2.4.1.tgz";
        sha1 = "5b7723034dda4d262e5a46fb2c58d7cc22f71420";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~0.10.0" =
    self.by-version."lodash"."0.10.0";
  by-version."lodash"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-0.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-0.10.0.tgz";
        name = "lodash-0.10.0.tgz";
        sha1 = "5254bbc2c46c827f535a27d631fd4f2bff374ce7";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~0.9.2" =
    self.by-version."lodash"."0.9.2";
  by-version."lodash"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-0.9.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-0.9.2.tgz";
        name = "lodash-0.9.2.tgz";
        sha1 = "8f3499c5245d346d682e5b0d3b40767e09f1a92c";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~1.2.1" =
    self.by-version."lodash"."1.2.1";
  by-version."lodash"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.2.1.tgz";
        name = "lodash-1.2.1.tgz";
        sha1 = "ed47b16e46f06b2b40309b68e9163c17e93ea304";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~1.3.0" =
    self.by-version."lodash"."1.3.1";
  by-version."lodash"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.3.1.tgz";
        name = "lodash-1.3.1.tgz";
        sha1 = "a4663b53686b895ff074e2ba504dfb76a8e2b770";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~1.3.1" =
    self.by-version."lodash"."1.3.1";
  by-spec."lodash"."~2.1.0" =
    self.by-version."lodash"."2.1.0";
  by-version."lodash"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.1.0.tgz";
        name = "lodash-2.1.0.tgz";
        sha1 = "0637eaaa36a8a1cfc865c3adfb942189bfb0998d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~2.2.1" =
    self.by-version."lodash"."2.2.1";
  by-version."lodash"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.2.1.tgz";
        name = "lodash-2.2.1.tgz";
        sha1 = "ca935fd14ab3c0c872abacf198b9cda501440867";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-spec."lodash._isnative"."~2.4.1" =
    self.by-version."lodash._isnative"."2.4.1";
  by-version."lodash._isnative"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash._isnative-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._isnative/-/lodash._isnative-2.4.1.tgz";
        name = "lodash._isnative-2.4.1.tgz";
        sha1 = "3ea6404b784a7be836c7b57580e1cdf79b14832c";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._isnative" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash._isnative" ];
  };
  by-spec."lodash._objecttypes"."~2.4.1" =
    self.by-version."lodash._objecttypes"."2.4.1";
  by-version."lodash._objecttypes"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash._objecttypes-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._objecttypes/-/lodash._objecttypes-2.4.1.tgz";
        name = "lodash._objecttypes-2.4.1.tgz";
        sha1 = "7c0b7f69d98a1f76529f890b0cdb1b4dfec11c11";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._objecttypes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash._objecttypes" ];
  };
  by-spec."lodash._shimkeys"."~2.4.1" =
    self.by-version."lodash._shimkeys"."2.4.1";
  by-version."lodash._shimkeys"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash._shimkeys-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._shimkeys/-/lodash._shimkeys-2.4.1.tgz";
        name = "lodash._shimkeys-2.4.1.tgz";
        sha1 = "6e9cc9666ff081f0b5a6c978b83e242e6949d203";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._shimkeys" or []);
    deps = [
      self.by-version."lodash._objecttypes"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash._shimkeys" ];
  };
  by-spec."lodash.debounce"."~2.4.1" =
    self.by-version."lodash.debounce"."2.4.1";
  by-version."lodash.debounce"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash.debounce-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.debounce/-/lodash.debounce-2.4.1.tgz";
        name = "lodash.debounce-2.4.1.tgz";
        sha1 = "d8cead246ec4b926e8b85678fc396bfeba8cc6fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.debounce" or []);
    deps = [
      self.by-version."lodash.isfunction"."2.4.1"
      self.by-version."lodash.isobject"."2.4.1"
      self.by-version."lodash.now"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash.debounce" ];
  };
  by-spec."lodash.defaults"."~2.4.1" =
    self.by-version."lodash.defaults"."2.4.1";
  by-version."lodash.defaults"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash.defaults-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.defaults/-/lodash.defaults-2.4.1.tgz";
        name = "lodash.defaults-2.4.1.tgz";
        sha1 = "a7e8885f05e68851144b6e12a8f3678026bc4c54";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.defaults" or []);
    deps = [
      self.by-version."lodash.keys"."2.4.1"
      self.by-version."lodash._objecttypes"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash.defaults" ];
  };
  by-spec."lodash.isfunction"."~2.4.1" =
    self.by-version."lodash.isfunction"."2.4.1";
  by-version."lodash.isfunction"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash.isfunction-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.isfunction/-/lodash.isfunction-2.4.1.tgz";
        name = "lodash.isfunction-2.4.1.tgz";
        sha1 = "2cfd575c73e498ab57e319b77fa02adef13a94d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.isfunction" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash.isfunction" ];
  };
  by-spec."lodash.isobject"."~2.4.1" =
    self.by-version."lodash.isobject"."2.4.1";
  by-version."lodash.isobject"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash.isobject-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.isobject/-/lodash.isobject-2.4.1.tgz";
        name = "lodash.isobject-2.4.1.tgz";
        sha1 = "5a2e47fe69953f1ee631a7eba1fe64d2d06558f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.isobject" or []);
    deps = [
      self.by-version."lodash._objecttypes"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash.isobject" ];
  };
  by-spec."lodash.keys"."~2.4.1" =
    self.by-version."lodash.keys"."2.4.1";
  by-version."lodash.keys"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash.keys-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.keys/-/lodash.keys-2.4.1.tgz";
        name = "lodash.keys-2.4.1.tgz";
        sha1 = "48dea46df8ff7632b10d706b8acb26591e2b3727";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.keys" or []);
    deps = [
      self.by-version."lodash._isnative"."2.4.1"
      self.by-version."lodash.isobject"."2.4.1"
      self.by-version."lodash._shimkeys"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash.keys" ];
  };
  by-spec."lodash.now"."~2.4.1" =
    self.by-version."lodash.now"."2.4.1";
  by-version."lodash.now"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lodash.now-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.now/-/lodash.now-2.4.1.tgz";
        name = "lodash.now-2.4.1.tgz";
        sha1 = "6872156500525185faf96785bb7fe7fe15b562c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.now" or []);
    deps = [
      self.by-version."lodash._isnative"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash.now" ];
  };
  by-spec."log-driver"."1.2.1" =
    self.by-version."log-driver"."1.2.1";
  by-version."log-driver"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-log-driver-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log-driver/-/log-driver-1.2.1.tgz";
        name = "log-driver-1.2.1.tgz";
        sha1 = "ada8202a133e99764306652e195e28268b0bea5b";
      })
    ];
    buildInputs =
      (self.nativeDeps."log-driver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "log-driver" ];
  };
  by-spec."log4js"."~0.6.3" =
    self.by-version."log4js"."0.6.12";
  by-version."log4js"."0.6.12" = lib.makeOverridable self.buildNodePackage {
    name = "node-log4js-0.6.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log4js/-/log4js-0.6.12.tgz";
        name = "log4js-0.6.12.tgz";
        sha1 = "ef806ec669ea3fc7bf5be92a95891fb67517e642";
      })
    ];
    buildInputs =
      (self.nativeDeps."log4js" or []);
    deps = [
      self.by-version."async"."0.1.15"
      self.by-version."semver"."1.1.4"
      self.by-version."readable-stream"."1.0.26"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "log4js" ];
  };
  by-spec."long"."*" =
    self.by-version."long"."1.1.2";
  by-version."long"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-long-1.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/long/-/long-1.1.2.tgz";
        name = "long-1.1.2.tgz";
        sha1 = "eaef5951ca7551d96926b82da242db9d6b28fb53";
      })
    ];
    buildInputs =
      (self.nativeDeps."long" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "long" ];
  };
  by-spec."longjohn"."~0.2.2" =
    self.by-version."longjohn"."0.2.4";
  by-version."longjohn"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-longjohn-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/longjohn/-/longjohn-0.2.4.tgz";
        name = "longjohn-0.2.4.tgz";
        sha1 = "48436a1f359e7666f678e2170ee1f43bba8f8b4c";
      })
    ];
    buildInputs =
      (self.nativeDeps."longjohn" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "longjohn" ];
  };
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.5.0";
  by-version."lru-cache"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-2.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.0.tgz";
        name = "lru-cache-2.5.0.tgz";
        sha1 = "d82388ae9c960becbea0c73bb9eb79b6c6ce9aeb";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.2.0" =
    self.by-version."lru-cache"."2.2.0";
  by-version."lru-cache"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.2.0.tgz";
        name = "lru-cache-2.2.0.tgz";
        sha1 = "ec2bba603f4c5bb3e7a1bf62ce1c1dbc1d474e08";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.2.x" =
    self.by-version."lru-cache"."2.2.4";
  by-version."lru-cache"."2.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-2.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.2.4.tgz";
        name = "lru-cache-2.2.4.tgz";
        sha1 = "6c658619becf14031d0d0b594b16042ce4dc063d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.3.0" =
    self.by-version."lru-cache"."2.3.0";
  by-version."lru-cache"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-2.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.0.tgz";
        name = "lru-cache-2.3.0.tgz";
        sha1 = "1cee12d5a9f28ed1ee37e9c332b8888e6b85412a";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."~1.0.2" =
    self.by-version."lru-cache"."1.0.6";
  by-version."lru-cache"."1.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-1.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-1.0.6.tgz";
        name = "lru-cache-1.0.6.tgz";
        sha1 = "aa50f97047422ac72543bda177a9c9d018d98452";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."~2.3.0" =
    self.by-version."lru-cache"."2.3.1";
  by-version."lru-cache"."2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-2.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
        name = "lru-cache-2.3.1.tgz";
        sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."~2.5.0" =
    self.by-version."lru-cache"."2.5.0";
  by-spec."lsmod"."~0.0.3" =
    self.by-version."lsmod"."0.0.3";
  by-version."lsmod"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-lsmod-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lsmod/-/lsmod-0.0.3.tgz";
        name = "lsmod-0.0.3.tgz";
        sha1 = "17e13d4e1ae91750ea5653548cd89e7147ad0244";
      })
    ];
    buildInputs =
      (self.nativeDeps."lsmod" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lsmod" ];
  };
  by-spec."mailcomposer".">= 0.1.27" =
    self.by-version."mailcomposer"."0.2.8";
  by-version."mailcomposer"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-mailcomposer-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mailcomposer/-/mailcomposer-0.2.8.tgz";
        name = "mailcomposer-0.2.8.tgz";
        sha1 = "bcb4d84aea08ea6f4c007f927c0ad214986370cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."mailcomposer" or []);
    deps = [
      self.by-version."mimelib"."0.2.14"
      self.by-version."mime"."1.2.9"
      self.by-version."he"."0.3.6"
      self.by-version."punycode"."1.2.4"
      self.by-version."follow-redirects"."0.0.3"
      self.by-version."dkim-signer"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mailcomposer" ];
  };
  by-spec."maxmin"."^0.1.0" =
    self.by-version."maxmin"."0.1.0";
  by-version."maxmin"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-maxmin-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/maxmin/-/maxmin-0.1.0.tgz";
        name = "maxmin-0.1.0.tgz";
        sha1 = "95d81c5289e3a9d30f7fc7dc559c024e5030c9d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."maxmin" or []);
    deps = [
      self.by-version."gzip-size"."0.1.0"
      self.by-version."pretty-bytes"."0.1.0"
      self.by-version."chalk"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "maxmin" ];
  };
  by-spec."maxmin"."~0.1.0" =
    self.by-version."maxmin"."0.1.0";
  by-spec."meat"."*" =
    self.by-version."meat"."0.2.5";
  by-version."meat"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "meat-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/meat/-/meat-0.2.5.tgz";
        name = "meat-0.2.5.tgz";
        sha1 = "8f277ec68f51794365e271166c7b7bba8d046869";
      })
    ];
    buildInputs =
      (self.nativeDeps."meat" or []);
    deps = [
      self.by-version."express"."2.5.11"
      self.by-version."jade"."0.27.0"
      self.by-version."open"."0.0.2"
      self.by-version."winston"."0.6.2"
      self.by-version."mkdirp"."0.3.0"
      self.by-version."node.extend"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "meat" ];
  };
  "meat" = self.by-version."meat"."0.2.5";
  by-spec."memoizee"."~0.2.5" =
    self.by-version."memoizee"."0.2.6";
  by-version."memoizee"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-memoizee-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/memoizee/-/memoizee-0.2.6.tgz";
        name = "memoizee-0.2.6.tgz";
        sha1 = "bb45a7ad02530082f1612671dab35219cd2e0741";
      })
    ];
    buildInputs =
      (self.nativeDeps."memoizee" or []);
    deps = [
      self.by-version."es5-ext"."0.9.2"
      self.by-version."event-emitter"."0.2.2"
      self.by-version."next-tick"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "memoizee" ];
  };
  by-spec."merge-descriptors"."0.0.1" =
    self.by-version."merge-descriptors"."0.0.1";
  by-version."merge-descriptors"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-merge-descriptors-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-0.0.1.tgz";
        name = "merge-descriptors-0.0.1.tgz";
        sha1 = "2ff0980c924cf81d0b5d1fb601177cb8bb56c0d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."merge-descriptors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "merge-descriptors" ];
  };
  by-spec."merge-descriptors"."0.0.2" =
    self.by-version."merge-descriptors"."0.0.2";
  by-version."merge-descriptors"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-merge-descriptors-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-0.0.2.tgz";
        name = "merge-descriptors-0.0.2.tgz";
        sha1 = "c36a52a781437513c57275f39dd9d317514ac8c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."merge-descriptors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "merge-descriptors" ];
  };
  by-spec."method-override"."1.0.0" =
    self.by-version."method-override"."1.0.0";
  by-version."method-override"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-method-override-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/method-override/-/method-override-1.0.0.tgz";
        name = "method-override-1.0.0.tgz";
        sha1 = "9e5bfbd80f3b9e043801dd3fe60bbab0f15b5f61";
      })
    ];
    buildInputs =
      (self.nativeDeps."method-override" or []);
    deps = [
      self.by-version."methods"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "method-override" ];
  };
  by-spec."methods"."*" =
    self.by-version."methods"."0.1.0";
  by-version."methods"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-methods-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-0.1.0.tgz";
        name = "methods-0.1.0.tgz";
        sha1 = "335d429eefd21b7bacf2e9c922a8d2bd14a30e4f";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."methods"."0.0.1" =
    self.by-version."methods"."0.0.1";
  by-version."methods"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-methods-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-0.0.1.tgz";
        name = "methods-0.0.1.tgz";
        sha1 = "277c90f8bef39709645a8371c51c3b6c648e068c";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."methods"."0.1.0" =
    self.by-version."methods"."0.1.0";
  by-spec."mime"."*" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        name = "mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.4" =
    self.by-version."mime"."1.2.4";
  by-version."mime"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-1.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.4.tgz";
        name = "mime-1.2.4.tgz";
        sha1 = "11b5fdaf29c2509255176b80ad520294f5de92b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.5" =
    self.by-version."mime"."1.2.5";
  by-version."mime"."1.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-1.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.5.tgz";
        name = "mime-1.2.5.tgz";
        sha1 = "9eed073022a8bf5e16c8566c6867b8832bfbfa13";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.6" =
    self.by-version."mime"."1.2.6";
  by-version."mime"."1.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-1.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.6.tgz";
        name = "mime-1.2.6.tgz";
        sha1 = "b1f86c768c025fa87b48075f1709f28aeaf20365";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.9" =
    self.by-version."mime"."1.2.9";
  by-version."mime"."1.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-1.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.9.tgz";
        name = "mime-1.2.9.tgz";
        sha1 = "009cd40867bd35de521b3b966f04e2f8d4d13d09";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.x" =
    self.by-version."mime"."1.2.11";
  by-spec."mime".">= 0.0.1" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.2" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.7" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.9" =
    self.by-version."mime"."1.2.11";
  by-spec."mimelib"."~0.2.14" =
    self.by-version."mimelib"."0.2.14";
  by-version."mimelib"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-mimelib-0.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mimelib/-/mimelib-0.2.14.tgz";
        name = "mimelib-0.2.14.tgz";
        sha1 = "2a1aa724bd190b85bd526e6317ab6106edfd6831";
      })
    ];
    buildInputs =
      (self.nativeDeps."mimelib" or []);
    deps = [
      self.by-version."encoding"."0.1.7"
      self.by-version."addressparser"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mimelib" ];
  };
  by-spec."minimatch"."0" =
    self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimatch-0.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
        name = "minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = [
      self.by-version."lru-cache"."2.5.0"
      self.by-version."sigmund"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."0.0.x" =
    self.by-version."minimatch"."0.0.5";
  by-version."minimatch"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimatch-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.0.5.tgz";
        name = "minimatch-0.0.5.tgz";
        sha1 = "96bb490bbd3ba6836bbfac111adf75301b1584de";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = [
      self.by-version."lru-cache"."1.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."0.2.x" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."0.x" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."0.x.x" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch".">=0.2.4" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.0" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.11" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.12" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.14" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.9" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimist-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        name = "minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."~0.0.5" =
    self.by-version."minimist"."0.0.8";
  by-spec."minimist"."~0.0.7" =
    self.by-version."minimist"."0.0.8";
  by-spec."ministyle"."~0.1.3" =
    self.by-version."ministyle"."0.1.3";
  by-version."ministyle"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-ministyle-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ministyle/-/ministyle-0.1.3.tgz";
        name = "ministyle-0.1.3.tgz";
        sha1 = "d7a639f29e9450b9d5ebf2255d1fa8d1d9d89900";
      })
    ];
    buildInputs =
      (self.nativeDeps."ministyle" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ministyle" ];
  };
  by-spec."miniwrite"."~0.1.3" =
    self.by-version."miniwrite"."0.1.3";
  by-version."miniwrite"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-miniwrite-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/miniwrite/-/miniwrite-0.1.3.tgz";
        name = "miniwrite-0.1.3.tgz";
        sha1 = "9e893efb435f853454ca0321b86a44378e8c50c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."miniwrite" or []);
    deps = [
      self.by-version."mkdirp"."0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "miniwrite" ];
  };
  by-spec."mkdirp"."*" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        name = "mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  "mkdirp" = self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."0" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."0.3" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."0.3.0" =
    self.by-version."mkdirp"."0.3.0";
  by-version."mkdirp"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mkdirp-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
        name = "mkdirp-0.3.0.tgz";
        sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  by-spec."mkdirp"."0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."0.3.x" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."0.x.x" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.3" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.4" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkpath"."~0.1.0" =
    self.by-version."mkpath"."0.1.0";
  by-version."mkpath"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mkpath-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkpath/-/mkpath-0.1.0.tgz";
        name = "mkpath-0.1.0.tgz";
        sha1 = "7554a6f8d871834cc97b5462b122c4c124d6de91";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkpath" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkpath" ];
  };
  by-spec."mocha"."*" =
    self.by-version."mocha"."1.18.2";
  by-version."mocha"."1.18.2" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-1.18.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-1.18.2.tgz";
        name = "mocha-1.18.2.tgz";
        sha1 = "800848f8f7884c61eefcfa2a27304ba9e5446d0b";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha" or []);
    deps = [
      self.by-version."commander"."2.0.0"
      self.by-version."growl"."1.7.0"
      self.by-version."jade"."0.26.3"
      self.by-version."diff"."1.0.7"
      self.by-version."debug"."0.7.4"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."glob"."3.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mocha" ];
  };
  "mocha" = self.by-version."mocha"."1.18.2";
  by-spec."mocha-unfunk-reporter"."*" =
    self.by-version."mocha-unfunk-reporter"."0.4.0";
  by-version."mocha-unfunk-reporter"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mocha-unfunk-reporter-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha-unfunk-reporter/-/mocha-unfunk-reporter-0.4.0.tgz";
        name = "mocha-unfunk-reporter-0.4.0.tgz";
        sha1 = "59eda97aec6ae6e26d7af4173490a65b7b082d20";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha-unfunk-reporter" or []);
    deps = [
      self.by-version."jsesc"."0.4.3"
      self.by-version."unfunk-diff"."0.0.2"
      self.by-version."miniwrite"."0.1.3"
      self.by-version."ministyle"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mocha-unfunk-reporter" ];
  };
  "mocha-unfunk-reporter" = self.by-version."mocha-unfunk-reporter"."0.4.0";
  by-spec."module-deps"."~1.7.0" =
    self.by-version."module-deps"."1.7.1";
  by-version."module-deps"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "module-deps-1.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/module-deps/-/module-deps-1.7.1.tgz";
        name = "module-deps-1.7.1.tgz";
        sha1 = "1e9a6809727282323abf1d5eee5ce8860b2e7bbf";
      })
    ];
    buildInputs =
      (self.nativeDeps."module-deps" or []);
    deps = [
      self.by-version."through"."2.3.4"
      self.by-version."JSONStream"."0.7.1"
      self.by-version."browser-resolve"."1.2.2"
      self.by-version."resolve"."0.6.2"
      self.by-version."concat-stream"."1.4.4"
      self.by-version."minimist"."0.0.8"
      self.by-version."parents"."0.0.2"
      self.by-version."detective"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "module-deps" ];
  };
  by-spec."moment"."2.1.0" =
    self.by-version."moment"."2.1.0";
  by-version."moment"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-moment-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.1.0.tgz";
        name = "moment-2.1.0.tgz";
        sha1 = "1fd7b1134029a953c6ea371dbaee37598ac03567";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  by-spec."moment"."~2.4.0" =
    self.by-version."moment"."2.4.0";
  by-version."moment"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-moment-2.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.4.0.tgz";
        name = "moment-2.4.0.tgz";
        sha1 = "06dd8dfbbfdb53a03510080ac788163c9490e75d";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  by-spec."moment"."~2.5.1" =
    self.by-version."moment"."2.5.1";
  by-version."moment"."2.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-moment-2.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.5.1.tgz";
        name = "moment-2.5.1.tgz";
        sha1 = "7146a3900533064ca799d5e792f4e480ee0e82bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  by-spec."mongodb"."*" =
    self.by-version."mongodb"."1.4.0-rc9";
  by-version."mongodb"."1.4.0-rc9" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongodb-1.4.0-rc9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.4.0-rc9.tgz";
        name = "mongodb-1.4.0-rc9.tgz";
        sha1 = "1b3887e9b2846de7557a009e1702f7dbc70d4c12";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = [
      self.by-version."bson"."0.2.7"
      self.by-version."kerberos"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  "mongodb" = self.by-version."mongodb"."1.4.0-rc9";
  by-spec."mongodb"."1.2.14" =
    self.by-version."mongodb"."1.2.14";
  by-version."mongodb"."1.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongodb-1.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.2.14.tgz";
        name = "mongodb-1.2.14.tgz";
        sha1 = "269665552066437308d0942036646e6795c3a9a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = [
      self.by-version."bson"."0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb"."1.3.19" =
    self.by-version."mongodb"."1.3.19";
  by-version."mongodb"."1.3.19" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongodb-1.3.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.3.19.tgz";
        name = "mongodb-1.3.19.tgz";
        sha1 = "f229db24098f019d86d135aaf8a1ab5f2658b1d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = [
      self.by-version."bson"."0.2.2"
      self.by-version."kerberos"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb"."1.3.23" =
    self.by-version."mongodb"."1.3.23";
  by-version."mongodb"."1.3.23" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongodb-1.3.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.3.23.tgz";
        name = "mongodb-1.3.23.tgz";
        sha1 = "874a5212162b16188aeeaee5e06067766c8e9e86";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = [
      self.by-version."bson"."0.2.5"
      self.by-version."kerberos"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb"."1.3.x" =
    self.by-version."mongodb"."1.3.23";
  by-spec."mongoose"."*" =
    self.by-version."mongoose"."3.8.8";
  by-version."mongoose"."3.8.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongoose-3.8.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.8.8.tgz";
        name = "mongoose-3.8.8.tgz";
        sha1 = "ab046f1fa17b0bdf090a04b6d034d87d240a47c2";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = [
      self.by-version."hooks"."0.2.1"
      self.by-version."mongodb"."1.3.23"
      self.by-version."ms"."0.1.0"
      self.by-version."sliced"."0.0.5"
      self.by-version."muri"."0.3.1"
      self.by-version."mpromise"."0.4.3"
      self.by-version."mpath"."0.1.1"
      self.by-version."regexp-clone"."0.0.1"
      self.by-version."mquery"."0.5.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  by-spec."mongoose"."3.6.7" =
    self.by-version."mongoose"."3.6.7";
  by-version."mongoose"."3.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongoose-3.6.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.6.7.tgz";
        name = "mongoose-3.6.7.tgz";
        sha1 = "aa6c9f4dfb740c7721dbe734fbb97714e5ab0ebc";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = [
      self.by-version."hooks"."0.2.1"
      self.by-version."mongodb"."1.2.14"
      self.by-version."ms"."0.1.0"
      self.by-version."sliced"."0.0.3"
      self.by-version."muri"."0.3.1"
      self.by-version."mpromise"."0.2.1"
      self.by-version."mpath"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  by-spec."mongoose"."3.6.x" =
    self.by-version."mongoose"."3.6.20";
  by-version."mongoose"."3.6.20" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongoose-3.6.20";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.6.20.tgz";
        name = "mongoose-3.6.20.tgz";
        sha1 = "47263843e6b812ea207eec104c40a36c8d215f53";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = [
      self.by-version."hooks"."0.2.1"
      self.by-version."mongodb"."1.3.19"
      self.by-version."ms"."0.1.0"
      self.by-version."sliced"."0.0.5"
      self.by-version."muri"."0.3.1"
      self.by-version."mpromise"."0.2.1"
      self.by-version."mpath"."0.1.1"
      self.by-version."regexp-clone"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  "mongoose" = self.by-version."mongoose"."3.6.20";
  by-spec."mongoose-lifecycle"."1.0.0" =
    self.by-version."mongoose-lifecycle"."1.0.0";
  by-version."mongoose-lifecycle"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongoose-lifecycle-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose-lifecycle/-/mongoose-lifecycle-1.0.0.tgz";
        name = "mongoose-lifecycle-1.0.0.tgz";
        sha1 = "3bac3f3924a845d147784fc6558dee900b0151e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose-lifecycle" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose-lifecycle" ];
  };
  by-spec."mongoose-schema-extend"."*" =
    self.by-version."mongoose-schema-extend"."0.1.7";
  by-version."mongoose-schema-extend"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-mongoose-schema-extend-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose-schema-extend/-/mongoose-schema-extend-0.1.7.tgz";
        name = "mongoose-schema-extend-0.1.7.tgz";
        sha1 = "50dc366ba63227d00c4cd3db9bb8bf95e9629910";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose-schema-extend" or []);
    deps = [
      self.by-version."owl-deepcopy"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose-schema-extend" ];
  };
  "mongoose-schema-extend" = self.by-version."mongoose-schema-extend"."0.1.7";
  by-spec."monocle"."1.1.50" =
    self.by-version."monocle"."1.1.50";
  by-version."monocle"."1.1.50" = lib.makeOverridable self.buildNodePackage {
    name = "node-monocle-1.1.50";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/monocle/-/monocle-1.1.50.tgz";
        name = "monocle-1.1.50.tgz";
        sha1 = "e21b059d99726d958371f36240c106b8a067fa7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."monocle" or []);
    deps = [
      self.by-version."readdirp"."0.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "monocle" ];
  };
  by-spec."monocle"."1.1.51" =
    self.by-version."monocle"."1.1.51";
  by-version."monocle"."1.1.51" = lib.makeOverridable self.buildNodePackage {
    name = "node-monocle-1.1.51";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/monocle/-/monocle-1.1.51.tgz";
        name = "monocle-1.1.51.tgz";
        sha1 = "22ed16e112e9b056769c5ccac920e375249d89c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."monocle" or []);
    deps = [
      self.by-version."readdirp"."0.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "monocle" ];
  };
  by-spec."morgan"."1.0.0" =
    self.by-version."morgan"."1.0.0";
  by-version."morgan"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-morgan-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/morgan/-/morgan-1.0.0.tgz";
        name = "morgan-1.0.0.tgz";
        sha1 = "83cf74b9f2d841901f1a9a6b8fa7a468d2e47a8d";
      })
    ];
    buildInputs =
      (self.nativeDeps."morgan" or []);
    deps = [
      self.by-version."bytes"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "morgan" ];
  };
  by-spec."mout"."~0.6.0" =
    self.by-version."mout"."0.6.0";
  by-version."mout"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mout-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mout/-/mout-0.6.0.tgz";
        name = "mout-0.6.0.tgz";
        sha1 = "ce7abad8130d796b09d7fb509bcc73b09be024a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."mout" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mout" ];
  };
  by-spec."mout"."~0.7.0" =
    self.by-version."mout"."0.7.1";
  by-version."mout"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-mout-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mout/-/mout-0.7.1.tgz";
        name = "mout-0.7.1.tgz";
        sha1 = "218de2b0880b220d99f4fbaee3fc0c3a5310bda8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mout" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mout" ];
  };
  by-spec."mout"."~0.9.0" =
    self.by-version."mout"."0.9.0";
  by-version."mout"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mout-0.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mout/-/mout-0.9.0.tgz";
        name = "mout-0.9.0.tgz";
        sha1 = "4b6ef8cae5099151d9a7ddb6ebb9a56f9de6aaeb";
      })
    ];
    buildInputs =
      (self.nativeDeps."mout" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mout" ];
  };
  by-spec."mpath"."0.1.1" =
    self.by-version."mpath"."0.1.1";
  by-version."mpath"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-mpath-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpath/-/mpath-0.1.1.tgz";
        name = "mpath-0.1.1.tgz";
        sha1 = "23da852b7c232ee097f4759d29c0ee9cd22d5e46";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpath" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpath" ];
  };
  by-spec."mpromise"."0.2.1" =
    self.by-version."mpromise"."0.2.1";
  by-version."mpromise"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-mpromise-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.2.1.tgz";
        name = "mpromise-0.2.1.tgz";
        sha1 = "fbbdc28cb0207e49b8a4eb1a4c0cea6c2de794c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise" or []);
    deps = [
      self.by-version."sliced"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  by-spec."mpromise"."0.4.3" =
    self.by-version."mpromise"."0.4.3";
  by-version."mpromise"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-mpromise-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.4.3.tgz";
        name = "mpromise-0.4.3.tgz";
        sha1 = "edc47a75a2a177b0e9382735db52dbec3808cc33";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  by-spec."mquery"."0.5.3" =
    self.by-version."mquery"."0.5.3";
  by-version."mquery"."0.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-mquery-0.5.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mquery/-/mquery-0.5.3.tgz";
        name = "mquery-0.5.3.tgz";
        sha1 = "b8a04d096ecf90bf17a81cc39b80dd4e5abcecec";
      })
    ];
    buildInputs =
      (self.nativeDeps."mquery" or []);
    deps = [
      self.by-version."sliced"."0.0.5"
      self.by-version."debug"."0.7.4"
      self.by-version."regexp-clone"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mquery" ];
  };
  by-spec."ms"."0.1.0" =
    self.by-version."ms"."0.1.0";
  by-version."ms"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ms-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.1.0.tgz";
        name = "ms-0.1.0.tgz";
        sha1 = "f21fac490daf1d7667fd180fe9077389cc9442b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."ms" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ms" ];
  };
  by-spec."msgpack".">= 0.0.1" =
    self.by-version."msgpack"."0.2.2";
  by-version."msgpack"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "msgpack-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/msgpack/-/msgpack-0.2.2.tgz";
        name = "msgpack-0.2.2.tgz";
        sha1 = "e7aec9bea24d9b07940dee6cfa536c469cd1776c";
      })
    ];
    buildInputs =
      (self.nativeDeps."msgpack" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "msgpack" ];
  };
  by-spec."multiparty"."2.2.0" =
    self.by-version."multiparty"."2.2.0";
  by-version."multiparty"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-multiparty-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/multiparty/-/multiparty-2.2.0.tgz";
        name = "multiparty-2.2.0.tgz";
        sha1 = "a567c2af000ad22dc8f2a653d91978ae1f5316f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."multiparty" or []);
    deps = [
      self.by-version."readable-stream"."1.1.11"
      self.by-version."stream-counter"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "multiparty" ];
  };
  by-spec."muri"."0.3.1" =
    self.by-version."muri"."0.3.1";
  by-version."muri"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-muri-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/muri/-/muri-0.3.1.tgz";
        name = "muri-0.3.1.tgz";
        sha1 = "861889c5c857f1a43700bee85d50731f61727c9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."muri" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "muri" ];
  };
  by-spec."mute-stream"."0.0.3" =
    self.by-version."mute-stream"."0.0.3";
  by-version."mute-stream"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-mute-stream-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.3.tgz";
        name = "mute-stream-0.0.3.tgz";
        sha1 = "f09c090d333b3063f615cbbcca71b349893f0152";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  by-spec."mute-stream"."0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-mute-stream-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
        name = "mute-stream-0.0.4.tgz";
        sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-spec."mv"."0.0.5" =
    self.by-version."mv"."0.0.5";
  by-version."mv"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-mv-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mv/-/mv-0.0.5.tgz";
        name = "mv-0.0.5.tgz";
        sha1 = "15eac759479884df1131d6de56bce20b654f5391";
      })
    ];
    buildInputs =
      (self.nativeDeps."mv" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mv" ];
  };
  by-spec."nan"."~0.3.0" =
    self.by-version."nan"."0.3.2";
  by-version."nan"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-nan-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.3.2.tgz";
        name = "nan-0.3.2.tgz";
        sha1 = "0df1935cab15369075ef160ad2894107aa14dc2d";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."nan"."~0.6.0" =
    self.by-version."nan"."0.6.0";
  by-version."nan"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-nan-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.6.0.tgz";
        name = "nan-0.6.0.tgz";
        sha1 = "a54ebe59717b467c77425302bd7c17574c887aaa";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."nan"."~0.8.0" =
    self.by-version."nan"."0.8.0";
  by-version."nan"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-nan-0.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.8.0.tgz";
        name = "nan-0.8.0.tgz";
        sha1 = "022a8fa5e9fe8420964ac1fb3dc94e17f449f5fd";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."natural"."0.1.17" =
    self.by-version."natural"."0.1.17";
  by-version."natural"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "node-natural-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/natural/-/natural-0.1.17.tgz";
        name = "natural-0.1.17.tgz";
        sha1 = "0ff654cd30aeb2aa298ab0580e6f7ea9f40954e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."natural" or []);
    deps = [
      self.by-version."sylvester"."0.0.21"
      self.by-version."apparatus"."0.0.8"
      self.by-version."underscore"."1.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "natural" ];
  };
  by-spec."nconf"."*" =
    self.by-version."nconf"."0.6.9";
  by-version."nconf"."0.6.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-nconf-0.6.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nconf/-/nconf-0.6.9.tgz";
        name = "nconf-0.6.9.tgz";
        sha1 = "9570ef15ed6f9ae6b2b3c8d5e71b66d3193cd661";
      })
    ];
    buildInputs =
      (self.nativeDeps."nconf" or []);
    deps = [
      self.by-version."async"."0.2.9"
      self.by-version."ini"."1.1.0"
      self.by-version."optimist"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nconf" ];
  };
  "nconf" = self.by-version."nconf"."0.6.9";
  by-spec."nconf"."0.6.9" =
    self.by-version."nconf"."0.6.9";
  by-spec."nconf"."~0.6.9" =
    self.by-version."nconf"."0.6.9";
  by-spec."ncp"."0.2.x" =
    self.by-version."ncp"."0.2.7";
  by-version."ncp"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.2.7.tgz";
        name = "ncp-0.2.7.tgz";
        sha1 = "46fac2b7dda2560a4cb7e628677bd5f64eac5be1";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  by-spec."ncp"."0.4.2" =
    self.by-version."ncp"."0.4.2";
  by-version."ncp"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.4.2.tgz";
        name = "ncp-0.4.2.tgz";
        sha1 = "abcc6cbd3ec2ed2a729ff6e7c1fa8f01784a8574";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  by-spec."ncp"."0.4.x" =
    self.by-version."ncp"."0.4.2";
  by-spec."ncp"."~0.4.2" =
    self.by-version."ncp"."0.4.2";
  by-spec."negotiator"."0.2.5" =
    self.by-version."negotiator"."0.2.5";
  by-version."negotiator"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-negotiator-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.2.5.tgz";
        name = "negotiator-0.2.5.tgz";
        sha1 = "12ec7b4a9f3b4c894c31d8c4ec015925ba547eec";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."0.3.0" =
    self.by-version."negotiator"."0.3.0";
  by-version."negotiator"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-negotiator-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.3.0.tgz";
        name = "negotiator-0.3.0.tgz";
        sha1 = "706d692efeddf574d57ea9fb1ab89a4fa7ee8f60";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."0.4.2" =
    self.by-version."negotiator"."0.4.2";
  by-version."negotiator"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-negotiator-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.4.2.tgz";
        name = "negotiator-0.4.2.tgz";
        sha1 = "8c43ea7e4c40ddfe40c3c0234c4ef77500b8fd37";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."~0.3.0" =
    self.by-version."negotiator"."0.3.0";
  by-spec."net-ping"."1.1.7" =
    self.by-version."net-ping"."1.1.7";
  by-version."net-ping"."1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-net-ping-1.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/net-ping/-/net-ping-1.1.7.tgz";
        name = "net-ping-1.1.7.tgz";
        sha1 = "49f5bca55a30a3726d69253557f231135a637075";
      })
    ];
    buildInputs =
      (self.nativeDeps."net-ping" or []);
    deps = [
      self.by-version."raw-socket"."1.2.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "net-ping" ];
  };
  by-spec."next-tick"."0.1.x" =
    self.by-version."next-tick"."0.1.0";
  by-version."next-tick"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-next-tick-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/next-tick/-/next-tick-0.1.0.tgz";
        name = "next-tick-0.1.0.tgz";
        sha1 = "1912cce8eb9b697d640fbba94f8f00dec3b94259";
      })
    ];
    buildInputs =
      (self.nativeDeps."next-tick" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "next-tick" ];
  };
  by-spec."nib"."0.5.0" =
    self.by-version."nib"."0.5.0";
  by-version."nib"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-nib-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nib/-/nib-0.5.0.tgz";
        name = "nib-0.5.0.tgz";
        sha1 = "ad0a7dfa2bca8680c8cb8adaa6ab68c80e5221e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."nib" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nib" ];
  };
  by-spec."nijs"."*" =
    self.by-version."nijs"."0.0.13";
  by-version."nijs"."0.0.13" = lib.makeOverridable self.buildNodePackage {
    name = "nijs-0.0.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.13.tgz";
        name = "nijs-0.0.13.tgz";
        sha1 = "eba11ace22e3ff73a9dc526b2b955c2e04472572";
      })
    ];
    buildInputs =
      (self.nativeDeps."nijs" or []);
    deps = [
      self.by-version."optparse"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nijs" ];
  };
  "nijs" = self.by-version."nijs"."0.0.13";
  by-spec."node-appc"."0.2.0" =
    self.by-version."node-appc"."0.2.0";
  by-version."node-appc"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-appc-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-appc/-/node-appc-0.2.0.tgz";
        name = "node-appc-0.2.0.tgz";
        sha1 = "7bc7ec2a9c65e2e0b55a42669fae383329d51609";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-appc" or []);
    deps = [
      self.by-version."adm-zip"."0.4.4"
      self.by-version."async"."0.2.10"
      self.by-version."colors"."0.6.2"
      self.by-version."diff"."1.0.8"
      self.by-version."dox"."0.4.4"
      self.by-version."jade"."0.35.0"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."optimist"."0.6.1"
      self.by-version."request"."2.27.0"
      self.by-version."semver"."2.1.0"
      self.by-version."sprintf"."0.1.3"
      self.by-version."temp"."0.6.0"
      self.by-version."wrench"."1.5.8"
      self.by-version."uglify-js"."2.3.6"
      self.by-version."xmldom"."0.1.19"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-appc" ];
  };
  by-spec."node-expat"."*" =
    self.by-version."node-expat"."2.1.4";
  by-version."node-expat"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-expat-2.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-expat/-/node-expat-2.1.4.tgz";
        name = "node-expat-2.1.4.tgz";
        sha1 = "e55a82249b71afbce09ffa880705ec37553c5121";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-expat" or []);
    deps = [
      self.by-version."nan"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-expat" ];
  };
  "node-expat" = self.by-version."node-expat"."2.1.4";
  by-spec."node-gyp"."*" =
    self.by-version."node-gyp"."0.13.0";
  by-version."node-gyp"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.13.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.13.0.tgz";
        name = "node-gyp-0.13.0.tgz";
        sha1 = "84e216991a64ce5f03d50c95518bd72ca9e10f1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp" or []);
    deps = [
      self.by-version."glob"."3.2.9"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."fstream"."0.1.25"
      self.by-version."minimatch"."0.2.14"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."nopt"."2.2.0"
      self.by-version."npmlog"."0.0.6"
      self.by-version."osenv"."0.0.3"
      self.by-version."request"."2.34.0"
      self.by-version."rimraf"."2.2.6"
      self.by-version."semver"."2.2.1"
      self.by-version."tar"."0.1.19"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  "node-gyp" = self.by-version."node-gyp"."0.13.0";
  by-spec."node-gyp"."~0.13.0" =
    self.by-version."node-gyp"."0.13.0";
  by-spec."node-inspector"."*" =
    self.by-version."node-inspector"."0.7.2";
  by-version."node-inspector"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-inspector-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-inspector/-/node-inspector-0.7.2.tgz";
        name = "node-inspector-0.7.2.tgz";
        sha1 = "b9f1a1bbec7960d504edbfbc4bf191841794aab8";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-inspector" or []);
    deps = [
      self.by-version."express"."3.4.8"
      self.by-version."async"."0.2.10"
      self.by-version."glob"."3.2.9"
      self.by-version."rc"."0.3.4"
      self.by-version."strong-data-uri"."0.1.1"
      self.by-version."debug"."0.7.4"
      self.by-version."ws"."0.4.31"
      self.by-version."opener"."1.3.0"
      self.by-version."yargs"."1.1.3"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-inspector" ];
  };
  "node-inspector" = self.by-version."node-inspector"."0.7.2";
  by-spec."node-protobuf"."*" =
    self.by-version."node-protobuf"."1.0.10";
  by-version."node-protobuf"."1.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-protobuf-1.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-protobuf/-/node-protobuf-1.0.10.tgz";
        name = "node-protobuf-1.0.10.tgz";
        sha1 = "a8a02d55129efe1776bc3e038d7e6c676c001fcd";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-protobuf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-protobuf" ];
  };
  "node-protobuf" = self.by-version."node-protobuf"."1.0.10";
  by-spec."node-swt".">=0.1.1" =
    self.by-version."node-swt"."0.1.1";
  by-version."node-swt"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-swt-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-swt/-/node-swt-0.1.1.tgz";
        name = "node-swt-0.1.1.tgz";
        sha1 = "af0903825784be553b93dbae57d99d59060585dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-swt" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-swt" ];
  };
  by-spec."node-syslog"."1.1.7" =
    self.by-version."node-syslog"."1.1.7";
  by-version."node-syslog"."1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-syslog-1.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-syslog/-/node-syslog-1.1.7.tgz";
        name = "node-syslog-1.1.7.tgz";
        sha1 = "f2b1dfce095c39f5a6d056659862ca134a08a4cb";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-syslog" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-syslog" ];
  };
  by-spec."node-uptime"."https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7" =
    self.by-version."node-uptime"."3.2.0";
  by-version."node-uptime"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-uptime-3.2.0";
    src = [
      (fetchurl {
        url = "https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7";
        name = "node-uptime-3.2.0.tgz";
        sha256 = "46424d7f9553ce7313cc09995ab11d237dd02257c29f260cfb38d2799e7c7746";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uptime" or []);
    deps = [
      self.by-version."mongoose"."3.6.7"
      self.by-version."mongoose-lifecycle"."1.0.0"
      self.by-version."express"."3.2.0"
      self.by-version."express-partials"."0.0.6"
      self.by-version."connect-flash"."0.1.0"
      self.by-version."ejs"."0.8.3"
      self.by-version."config"."0.4.15"
      self.by-version."async"."0.1.22"
      self.by-version."socket.io"."0.9.14"
      self.by-version."semver"."1.1.0"
      self.by-version."moment"."2.1.0"
      self.by-version."nodemailer"."0.3.35"
      self.by-version."net-ping"."1.1.7"
      self.by-version."js-yaml"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uptime" ];
  };
  "node-uptime" = self.by-version."node-uptime"."3.2.0";
  by-spec."node-uuid"."*" =
    self.by-version."node-uuid"."1.4.1";
  by-version."node-uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-uuid-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        name = "node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  "node-uuid" = self.by-version."node-uuid"."1.4.1";
  by-spec."node-uuid"."1.3.3" =
    self.by-version."node-uuid"."1.3.3";
  by-version."node-uuid"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-uuid-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.3.3.tgz";
        name = "node-uuid-1.3.3.tgz";
        sha1 = "d3db4d7b56810d9e4032342766282af07391729b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  by-spec."node-uuid"."1.4.0" =
    self.by-version."node-uuid"."1.4.0";
  by-version."node-uuid"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-uuid-1.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.0.tgz";
        name = "node-uuid-1.4.0.tgz";
        sha1 = "07f9b2337572ff6275c775e1d48513f3a45d7a65";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  by-spec."node-uuid"."1.4.1" =
    self.by-version."node-uuid"."1.4.1";
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.1";
  by-spec."node-uuid"."~1.4.1" =
    self.by-version."node-uuid"."1.4.1";
  by-spec."node-wsfederation".">=0.1.1" =
    self.by-version."node-wsfederation"."0.1.1";
  by-version."node-wsfederation"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-wsfederation-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-wsfederation/-/node-wsfederation-0.1.1.tgz";
        name = "node-wsfederation-0.1.1.tgz";
        sha1 = "9abf1dd3b20a3ab0a38f899c882c218d734e8a7b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-wsfederation" or []);
    deps = [
      self.by-version."xml2js"."0.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-wsfederation" ];
  };
  by-spec."node.extend"."1.0.0" =
    self.by-version."node.extend"."1.0.0";
  by-version."node.extend"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-node.extend-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node.extend/-/node.extend-1.0.0.tgz";
        name = "node.extend-1.0.0.tgz";
        sha1 = "ab83960c477280d01ba5554a0d8fd3acfe39336e";
      })
    ];
    buildInputs =
      (self.nativeDeps."node.extend" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node.extend" ];
  };
  by-spec."nodemailer"."0.3.35" =
    self.by-version."nodemailer"."0.3.35";
  by-version."nodemailer"."0.3.35" = lib.makeOverridable self.buildNodePackage {
    name = "nodemailer-0.3.35";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemailer/-/nodemailer-0.3.35.tgz";
        name = "nodemailer-0.3.35.tgz";
        sha1 = "4d38cdc0ad230bdf88cc27d1256ef49fcb422e19";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemailer" or []);
    deps = [
      self.by-version."mailcomposer"."0.2.8"
      self.by-version."simplesmtp"."0.3.23"
      self.by-version."optimist"."0.6.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nodemailer" ];
  };
  by-spec."nodemon"."*" =
    self.by-version."nodemon"."1.0.17";
  by-version."nodemon"."1.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "nodemon-1.0.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemon/-/nodemon-1.0.17.tgz";
        name = "nodemon-1.0.17.tgz";
        sha1 = "910a3f3cb66c06a3499498455cf4e0119f75799c";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemon" or []);
    deps = [
      self.by-version."update-notifier"."0.1.8"
      self.by-version."minimatch"."0.2.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nodemon" ];
  };
  "nodemon" = self.by-version."nodemon"."1.0.17";
  by-spec."nomnom"."1.6.x" =
    self.by-version."nomnom"."1.6.2";
  by-version."nomnom"."1.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-nomnom-1.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nomnom/-/nomnom-1.6.2.tgz";
        name = "nomnom-1.6.2.tgz";
        sha1 = "84a66a260174408fc5b77a18f888eccc44fb6971";
      })
    ];
    buildInputs =
      (self.nativeDeps."nomnom" or []);
    deps = [
      self.by-version."colors"."0.5.1"
      self.by-version."underscore"."1.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nomnom" ];
  };
  by-spec."nopt"."2" =
    self.by-version."nopt"."2.2.0";
  by-version."nopt"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.2.0.tgz";
        name = "nopt-2.2.0.tgz";
        sha1 = "3d106676f3607ac466af9bf82bd707b1501d3bd5";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."2.0.0" =
    self.by-version."nopt"."2.0.0";
  by-version."nopt"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.0.0.tgz";
        name = "nopt-2.0.0.tgz";
        sha1 = "ca7416f20a5e3f9c3b86180f96295fa3d0b52e0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."2.2.x" =
    self.by-version."nopt"."2.2.0";
  by-spec."nopt"."~1.0.10" =
    self.by-version."nopt"."1.0.10";
  by-version."nopt"."1.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-1.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-1.0.10.tgz";
        name = "nopt-1.0.10.tgz";
        sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."~2.1.1" =
    self.by-version."nopt"."2.1.2";
  by-version."nopt"."2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.1.2.tgz";
        name = "nopt-2.1.2.tgz";
        sha1 = "6cccd977b80132a07731d6e8ce58c2c8303cf9af";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."~2.1.2" =
    self.by-version."nopt"."2.1.2";
  by-spec."nopt"."~2.2.0" =
    self.by-version."nopt"."2.2.0";
  by-spec."normalize-package-data"."~0.2.9" =
    self.by-version."normalize-package-data"."0.2.12";
  by-version."normalize-package-data"."0.2.12" = lib.makeOverridable self.buildNodePackage {
    name = "node-normalize-package-data-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/normalize-package-data/-/normalize-package-data-0.2.12.tgz";
        name = "normalize-package-data-0.2.12.tgz";
        sha1 = "c8284cf0cb0466ea60ee64276b9070722c1da768";
      })
    ];
    buildInputs =
      (self.nativeDeps."normalize-package-data" or []);
    deps = [
      self.by-version."semver"."2.2.1"
      self.by-version."github-url-from-git"."1.1.1"
      self.by-version."github-url-from-username-repo"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "normalize-package-data" ];
  };
  by-spec."npm"."*" =
    self.by-version."npm"."1.4.6";
  by-version."npm"."1.4.6" = lib.makeOverridable self.buildNodePackage {
    name = "npm-1.4.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-1.4.6.tgz";
        name = "npm-1.4.6.tgz";
        sha1 = "0e151bce38e72cf2206a6299fa5164123f04256e";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm" or []);
    deps = [
      self.by-version."abbrev"."1.0.4"
      self.by-version."ansi"."0.2.1"
      self.by-version."ansicolors"."0.3.2"
      self.by-version."ansistyles"."0.1.3"
      self.by-version."archy"."0.0.2"
      self.by-version."block-stream"."0.0.7"
      self.by-version."child-process-close"."0.1.1"
      self.by-version."chmodr"."0.1.0"
      self.by-version."chownr"."0.0.1"
      self.by-version."cmd-shim"."1.1.1"
      self.by-version."columnify"."0.1.2"
      self.by-version."editor"."0.0.5"
      self.by-version."fstream"."0.1.25"
      self.by-version."fstream-npm"."0.1.6"
      self.by-version."github-url-from-git"."1.1.1"
      self.by-version."github-url-from-username-repo"."0.0.2"
      self.by-version."glob"."3.2.9"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."ini"."1.1.0"
      self.by-version."init-package-json"."0.0.15"
      self.by-version."lockfile"."0.4.2"
      self.by-version."lru-cache"."2.5.0"
      self.by-version."minimatch"."0.2.14"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."node-gyp"."0.13.0"
      self.by-version."nopt"."2.2.0"
      self.by-version."npm-install-checks"."1.0.0"
      self.by-version."npm-registry-client"."0.4.5"
      self.by-version."npm-user-validate"."0.0.3"
      self.by-version."npmconf"."0.1.13"
      self.by-version."npmlog"."0.0.6"
      self.by-version."once"."1.3.0"
      self.by-version."opener"."1.3.0"
      self.by-version."osenv"."0.0.3"
      self.by-version."path-is-inside"."1.0.1"
      self.by-version."read"."1.0.5"
      self.by-version."read-installed"."2.0.2"
      self.by-version."read-package-json"."1.1.8"
      self.by-version."request"."2.30.0"
      self.by-version."retry"."0.6.0"
      self.by-version."rimraf"."2.2.6"
      self.by-version."semver"."2.2.1"
      self.by-version."sha"."1.2.3"
      self.by-version."slide"."1.1.5"
      self.by-version."sorted-object"."1.0.0"
      self.by-version."tar"."0.1.19"
      self.by-version."text-table"."0.2.0"
      self.by-version."uid-number"."0.0.5"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  "npm" = self.by-version."npm"."1.4.6";
  by-spec."npm-install-checks"."~1.0.0" =
    self.by-version."npm-install-checks"."1.0.0";
  by-version."npm-install-checks"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-npm-install-checks-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-install-checks/-/npm-install-checks-1.0.0.tgz";
        name = "npm-install-checks-1.0.0.tgz";
        sha1 = "7e1469b5e0c693b2ae2a8830b5fc4e7bf76c88fd";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-install-checks" or []);
    deps = [
      self.by-version."npmlog"."0.0.6"
      self.by-version."semver"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-install-checks" ];
  };
  by-spec."npm-registry-client"."0.2.27" =
    self.by-version."npm-registry-client"."0.2.27";
  by-version."npm-registry-client"."0.2.27" = lib.makeOverridable self.buildNodePackage {
    name = "node-npm-registry-client-0.2.27";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.2.27.tgz";
        name = "npm-registry-client-0.2.27.tgz";
        sha1 = "8f338189d32769267886a07ad7b7fd2267446adf";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = [
      self.by-version."request"."2.34.0"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."semver"."2.0.11"
      self.by-version."slide"."1.1.5"
      self.by-version."chownr"."0.0.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."rimraf"."2.2.6"
      self.by-version."retry"."0.6.0"
      self.by-version."couch-login"."0.1.20"
      self.by-version."npmlog"."0.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-registry-client"."~0.4.4" =
    self.by-version."npm-registry-client"."0.4.5";
  by-version."npm-registry-client"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-npm-registry-client-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.4.5.tgz";
        name = "npm-registry-client-0.4.5.tgz";
        sha1 = "7d6fdca46139470715f9477ddb5ad3e770d4de7b";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = [
      self.by-version."request"."2.34.0"
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."semver"."2.2.1"
      self.by-version."slide"."1.1.5"
      self.by-version."chownr"."0.0.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."rimraf"."2.2.6"
      self.by-version."retry"."0.6.0"
      self.by-version."npmlog"."0.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-registry-client"."~0.4.5" =
    self.by-version."npm-registry-client"."0.4.5";
  by-spec."npm-user-validate"."0.0.3" =
    self.by-version."npm-user-validate"."0.0.3";
  by-version."npm-user-validate"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-npm-user-validate-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-user-validate/-/npm-user-validate-0.0.3.tgz";
        name = "npm-user-validate-0.0.3.tgz";
        sha1 = "818eca4312d13da648f9bc1d7f80bb4f151e0c2e";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-user-validate" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-user-validate" ];
  };
  by-spec."npm2nix"."*" =
    self.by-version."npm2nix"."5.6.0";
  by-version."npm2nix"."5.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "npm2nix-5.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm2nix/-/npm2nix-5.6.0.tgz";
        name = "npm2nix-5.6.0.tgz";
        sha1 = "75680a36a24fe7f434a18199552cd3e7a576e875";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm2nix" or []);
    deps = [
      self.by-version."semver"."2.2.1"
      self.by-version."argparse"."0.1.15"
      self.by-version."npm-registry-client"."0.2.27"
      self.by-version."npmconf"."0.1.1"
      self.by-version."tar"."0.1.17"
      self.by-version."temp"."0.6.0"
      self.by-version."fs.extra"."1.2.1"
      self.by-version."findit"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm2nix" ];
  };
  "npm2nix" = self.by-version."npm2nix"."5.6.0";
  by-spec."npmconf"."0.0.24" =
    self.by-version."npmconf"."0.0.24";
  by-version."npmconf"."0.0.24" = lib.makeOverridable self.buildNodePackage {
    name = "node-npmconf-0.0.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.0.24.tgz";
        name = "npmconf-0.0.24.tgz";
        sha1 = "b78875b088ccc3c0afa3eceb3ce3244b1b52390c";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = [
      self.by-version."config-chain"."1.1.8"
      self.by-version."inherits"."1.0.0"
      self.by-version."once"."1.1.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."osenv"."0.0.3"
      self.by-version."nopt"."2.2.0"
      self.by-version."semver"."1.1.4"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."0.1.1" =
    self.by-version."npmconf"."0.1.1";
  by-version."npmconf"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-npmconf-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.1.tgz";
        name = "npmconf-0.1.1.tgz";
        sha1 = "7a254182591ca22d77b2faecc0d17e0f9bdf25a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = [
      self.by-version."config-chain"."1.1.8"
      self.by-version."inherits"."1.0.0"
      self.by-version."once"."1.1.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."osenv"."0.0.3"
      self.by-version."nopt"."2.2.0"
      self.by-version."semver"."2.2.1"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."~0.1.13" =
    self.by-version."npmconf"."0.1.13";
  by-version."npmconf"."0.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "node-npmconf-0.1.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.13.tgz";
        name = "npmconf-0.1.13.tgz";
        sha1 = "d47241b5b074f554ced90cd888d0dc96e4b1a4da";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = [
      self.by-version."config-chain"."1.1.8"
      self.by-version."inherits"."2.0.1"
      self.by-version."once"."1.3.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."osenv"."0.0.3"
      self.by-version."nopt"."2.2.0"
      self.by-version."semver"."2.2.1"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."~0.1.2" =
    self.by-version."npmconf"."0.1.13";
  by-spec."npmlog"."*" =
    self.by-version."npmlog"."0.0.6";
  by-version."npmlog"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-npmlog-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.6.tgz";
        name = "npmlog-0.0.6.tgz";
        sha1 = "685043fe71aa1665d6e3b2acef180640caf40873";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog" or []);
    deps = [
      self.by-version."ansi"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  by-spec."npmlog"."0" =
    self.by-version."npmlog"."0.0.6";
  by-spec."npmlog"."0.0.6" =
    self.by-version."npmlog"."0.0.6";
  by-spec."nssocket"."~0.5.1" =
    self.by-version."nssocket"."0.5.1";
  by-version."nssocket"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-nssocket-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nssocket/-/nssocket-0.5.1.tgz";
        name = "nssocket-0.5.1.tgz";
        sha1 = "11f0428335ad8d89ff9cf96ab2852a23b1b33b71";
      })
    ];
    buildInputs =
      (self.nativeDeps."nssocket" or []);
    deps = [
      self.by-version."eventemitter2"."0.4.13"
      self.by-version."lazy"."1.0.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nssocket" ];
  };
  by-spec."nth-check"."~1.0.0" =
    self.by-version."nth-check"."1.0.0";
  by-version."nth-check"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-nth-check-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nth-check/-/nth-check-1.0.0.tgz";
        name = "nth-check-1.0.0.tgz";
        sha1 = "02fc1277aa2bf8e6083be456104d6a646101a49d";
      })
    ];
    buildInputs =
      (self.nativeDeps."nth-check" or []);
    deps = [
      self.by-version."boolbase"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nth-check" ];
  };
  by-spec."oauth"."https://github.com/ciaranj/node-oauth/tarball/master" =
    self.by-version."oauth"."0.9.11";
  by-version."oauth"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-oauth-0.9.11";
    src = [
      (fetchurl {
        url = "https://github.com/ciaranj/node-oauth/tarball/master";
        name = "oauth-0.9.11.tgz";
        sha256 = "8716e78676584860379f3ccc0f510beea508152d1728f3f17e8e760e12b0ef8f";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "oauth" ];
  };
  by-spec."oauth-sign"."~0.2.0" =
    self.by-version."oauth-sign"."0.2.0";
  by-version."oauth-sign"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-oauth-sign-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.2.0.tgz";
        name = "oauth-sign-0.2.0.tgz";
        sha1 = "a0e6a1715daed062f322b622b7fe5afd1035b6e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."oauth-sign"."~0.3.0" =
    self.by-version."oauth-sign"."0.3.0";
  by-version."oauth-sign"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-oauth-sign-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
        name = "oauth-sign-0.3.0.tgz";
        sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."object-additions".">= 0.5.0" =
    self.by-version."object-additions"."0.5.1";
  by-version."object-additions"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-object-additions-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-additions/-/object-additions-0.5.1.tgz";
        name = "object-additions-0.5.1.tgz";
        sha1 = "ac624e0995e696c94cc69b41f316462b16a3bda4";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-additions" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "object-additions" ];
  };
  by-spec."object-assign"."~0.1.1" =
    self.by-version."object-assign"."0.1.2";
  by-version."object-assign"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-object-assign-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-assign/-/object-assign-0.1.2.tgz";
        name = "object-assign-0.1.2.tgz";
        sha1 = "036992f073aff7b2db83d06b3fb3155a5ccac37f";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-assign" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "object-assign" ];
  };
  by-spec."object-assign"."~0.1.2" =
    self.by-version."object-assign"."0.1.2";
  by-spec."object-keys"."~0.4.0" =
    self.by-version."object-keys"."0.4.0";
  by-version."object-keys"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-object-keys-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-keys/-/object-keys-0.4.0.tgz";
        name = "object-keys-0.4.0.tgz";
        sha1 = "28a6aae7428dd2c3a92f3d95f21335dd204e0336";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-keys" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "object-keys" ];
  };
  by-spec."once"."1.1.1" =
    self.by-version."once"."1.1.1";
  by-version."once"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-once-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.1.1.tgz";
        name = "once-1.1.1.tgz";
        sha1 = "9db574933ccb08c3a7614d154032c09ea6f339e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."once"."~1.1.1" =
    self.by-version."once"."1.1.1";
  by-spec."once"."~1.3.0" =
    self.by-version."once"."1.3.0";
  by-version."once"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-once-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.0.tgz";
        name = "once-1.3.0.tgz";
        sha1 = "151af86bfc1f08c4b9f07d06ab250ffcbeb56581";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."open"."0.0.2" =
    self.by-version."open"."0.0.2";
  by-version."open"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-open-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/open/-/open-0.0.2.tgz";
        name = "open-0.0.2.tgz";
        sha1 = "0a620ba2574464742f51e69f8ba8eccfd97b5dfc";
      })
    ];
    buildInputs =
      (self.nativeDeps."open" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "open" ];
  };
  by-spec."open"."0.0.4" =
    self.by-version."open"."0.0.4";
  by-version."open"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-open-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/open/-/open-0.0.4.tgz";
        name = "open-0.0.4.tgz";
        sha1 = "5de46a0858b9f49f9f211aa8f26628550657f262";
      })
    ];
    buildInputs =
      (self.nativeDeps."open" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "open" ];
  };
  by-spec."open"."~0.0.3" =
    self.by-version."open"."0.0.4";
  by-spec."open"."~0.0.4" =
    self.by-version."open"."0.0.4";
  by-spec."opener"."~1.3.0" =
    self.by-version."opener"."1.3.0";
  by-version."opener"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "opener-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/opener/-/opener-1.3.0.tgz";
        name = "opener-1.3.0.tgz";
        sha1 = "130ba662213fa842edb4cd0361d31a15301a43e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."opener" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "opener" ];
  };
  by-spec."openid".">=0.2.0" =
    self.by-version."openid"."0.5.5";
  by-version."openid"."0.5.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-openid-0.5.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/openid/-/openid-0.5.5.tgz";
        name = "openid-0.5.5.tgz";
        sha1 = "a4ce534ca82d68f81ccf45109fc92b4547b2cdd1";
      })
    ];
    buildInputs =
      (self.nativeDeps."openid" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "openid" ];
  };
  by-spec."optimist"."*" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-optimist-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
        name = "optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = [
      self.by-version."wordwrap"."0.0.2"
      self.by-version."minimist"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  "optimist" = self.by-version."optimist"."0.6.1";
  by-spec."optimist"."0.2" =
    self.by-version."optimist"."0.2.8";
  by-version."optimist"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-optimist-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.2.8.tgz";
        name = "optimist-0.2.8.tgz";
        sha1 = "e981ab7e268b457948593b55674c099a815cac31";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = [
      self.by-version."wordwrap"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."0.3.x" =
    self.by-version."optimist"."0.3.7";
  by-version."optimist"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-optimist-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        name = "optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = [
      self.by-version."wordwrap"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."0.6.0" =
    self.by-version."optimist"."0.6.0";
  by-version."optimist"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-optimist-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.0.tgz";
        name = "optimist-0.6.0.tgz";
        sha1 = "69424826f3405f79f142e6fc3d9ae58d4dbb9200";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = [
      self.by-version."wordwrap"."0.0.2"
      self.by-version."minimist"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."0.6.x" =
    self.by-version."optimist"."0.6.1";
  by-spec."optimist"."~0.3" =
    self.by-version."optimist"."0.3.7";
  by-spec."optimist"."~0.3.5" =
    self.by-version."optimist"."0.3.7";
  by-spec."optimist"."~0.6.0" =
    self.by-version."optimist"."0.6.1";
  by-spec."optimist"."~0.6.1" =
    self.by-version."optimist"."0.6.1";
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.5";
  by-version."options"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-options-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/options/-/options-0.0.5.tgz";
        name = "options-0.0.5.tgz";
        sha1 = "9a3806378f316536d79038038ba90ccb724816c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."options" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "options" ];
  };
  by-spec."optjs"."*" =
    self.by-version."optjs"."3.2.1-boom";
  by-version."optjs"."3.2.1-boom" = lib.makeOverridable self.buildNodePackage {
    name = "node-optjs-3.2.1-boom";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optjs/-/optjs-3.2.1-boom.tgz";
        name = "optjs-3.2.1-boom.tgz";
        sha1 = "bc0af6c8647db5eec511c4ca2d264f9646add758";
      })
    ];
    buildInputs =
      (self.nativeDeps."optjs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optjs" ];
  };
  by-spec."optparse"."*" =
    self.by-version."optparse"."1.0.5";
  by-version."optparse"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-optparse-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optparse/-/optparse-1.0.5.tgz";
        name = "optparse-1.0.5.tgz";
        sha1 = "75e75a96506611eb1c65ba89018ff08a981e2c16";
      })
    ];
    buildInputs =
      (self.nativeDeps."optparse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optparse" ];
  };
  "optparse" = self.by-version."optparse"."1.0.5";
  by-spec."optparse".">= 1.0.3" =
    self.by-version."optparse"."1.0.5";
  by-spec."os-browserify"."~0.1.1" =
    self.by-version."os-browserify"."0.1.2";
  by-version."os-browserify"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-os-browserify-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/os-browserify/-/os-browserify-0.1.2.tgz";
        name = "os-browserify-0.1.2.tgz";
        sha1 = "49ca0293e0b19590a5f5de10c7f265a617d8fe54";
      })
    ];
    buildInputs =
      (self.nativeDeps."os-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "os-browserify" ];
  };
  by-spec."osenv"."0" =
    self.by-version."osenv"."0.0.3";
  by-version."osenv"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-osenv-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.0.3.tgz";
        name = "osenv-0.0.3.tgz";
        sha1 = "cd6ad8ddb290915ad9e22765576025d411f29cb6";
      })
    ];
    buildInputs =
      (self.nativeDeps."osenv" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "osenv" ];
  };
  by-spec."osenv"."0.0.3" =
    self.by-version."osenv"."0.0.3";
  by-spec."osenv"."~0.0.3" =
    self.by-version."osenv"."0.0.3";
  by-spec."owl-deepcopy"."*" =
    self.by-version."owl-deepcopy"."0.0.2";
  by-version."owl-deepcopy"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-owl-deepcopy-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/owl-deepcopy/-/owl-deepcopy-0.0.2.tgz";
        name = "owl-deepcopy-0.0.2.tgz";
        sha1 = "056c40e1af73dff6e2c7afae983d2a7760fdff88";
      })
    ];
    buildInputs =
      (self.nativeDeps."owl-deepcopy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "owl-deepcopy" ];
  };
  "owl-deepcopy" = self.by-version."owl-deepcopy"."0.0.2";
  by-spec."owl-deepcopy"."~0.0.1" =
    self.by-version."owl-deepcopy"."0.0.2";
  by-spec."p-throttler"."~0.0.1" =
    self.by-version."p-throttler"."0.0.1";
  by-version."p-throttler"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-p-throttler-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/p-throttler/-/p-throttler-0.0.1.tgz";
        name = "p-throttler-0.0.1.tgz";
        sha1 = "c341e3589ec843852a035e6f88e6c1e96150029b";
      })
    ];
    buildInputs =
      (self.nativeDeps."p-throttler" or []);
    deps = [
      self.by-version."q"."0.9.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "p-throttler" ];
  };
  by-spec."parents"."0.0.2" =
    self.by-version."parents"."0.0.2";
  by-version."parents"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "parents-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parents/-/parents-0.0.2.tgz";
        name = "parents-0.0.2.tgz";
        sha1 = "67147826e497d40759aaf5ba4c99659b6034d302";
      })
    ];
    buildInputs =
      (self.nativeDeps."parents" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "parents" ];
  };
  by-spec."parents"."~0.0.1" =
    self.by-version."parents"."0.0.2";
  by-spec."parseurl"."1.0.1" =
    self.by-version."parseurl"."1.0.1";
  by-version."parseurl"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-parseurl-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parseurl/-/parseurl-1.0.1.tgz";
        name = "parseurl-1.0.1.tgz";
        sha1 = "2e57dce6efdd37c3518701030944c22bf388b7b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."parseurl" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "parseurl" ];
  };
  by-spec."passport"."*" =
    self.by-version."passport"."0.2.0";
  by-version."passport"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-passport-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.2.0.tgz";
        name = "passport-0.2.0.tgz";
        sha1 = "ae5ebc5611300d51fdc44032c7ca442a548dbca5";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport" or []);
    deps = [
      self.by-version."passport-strategy"."1.0.0"
      self.by-version."pause"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  "passport" = self.by-version."passport"."0.2.0";
  by-spec."passport"."~0.1.1" =
    self.by-version."passport"."0.1.18";
  by-version."passport"."0.1.18" = lib.makeOverridable self.buildNodePackage {
    name = "node-passport-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.18.tgz";
        name = "passport-0.1.18.tgz";
        sha1 = "c8264479dcb6414cadbb66752d12b37e0b6525a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport" or []);
    deps = [
      self.by-version."pkginfo"."0.2.3"
      self.by-version."pause"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  by-spec."passport"."~0.1.3" =
    self.by-version."passport"."0.1.18";
  by-spec."passport"."~0.2.0" =
    self.by-version."passport"."0.2.0";
  by-spec."passport-http"."*" =
    self.by-version."passport-http"."0.2.2";
  by-version."passport-http"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-passport-http-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-http/-/passport-http-0.2.2.tgz";
        name = "passport-http-0.2.2.tgz";
        sha1 = "2501314c0ff4a831e8a51ccfdb1b68f5c7cbc9f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-http" or []);
    deps = [
      self.by-version."pkginfo"."0.2.3"
      self.by-version."passport"."0.1.18"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-http" ];
  };
  "passport-http" = self.by-version."passport-http"."0.2.2";
  by-spec."passport-local"."*" =
    self.by-version."passport-local"."1.0.0";
  by-version."passport-local"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-passport-local-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-local/-/passport-local-1.0.0.tgz";
        name = "passport-local-1.0.0.tgz";
        sha1 = "1fe63268c92e75606626437e3b906662c15ba6ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-local" or []);
    deps = [
      self.by-version."passport-strategy"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-local" ];
  };
  "passport-local" = self.by-version."passport-local"."1.0.0";
  by-spec."passport-local"."0.1.6" =
    self.by-version."passport-local"."0.1.6";
  by-version."passport-local"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-passport-local-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-local/-/passport-local-0.1.6.tgz";
        name = "passport-local-0.1.6.tgz";
        sha1 = "fb0cf828048db931b67d19985c7aa06dd377a9db";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-local" or []);
    deps = [
      self.by-version."pkginfo"."0.2.3"
      self.by-version."passport"."0.1.18"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-local" ];
  };
  by-spec."passport-strategy"."1.x.x" =
    self.by-version."passport-strategy"."1.0.0";
  by-version."passport-strategy"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-passport-strategy-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-strategy/-/passport-strategy-1.0.0.tgz";
        name = "passport-strategy-1.0.0.tgz";
        sha1 = "b5539aa8fc225a3d1ad179476ddf236b440f52e4";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-strategy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-strategy" ];
  };
  by-spec."path-browserify"."~0.0.0" =
    self.by-version."path-browserify"."0.0.0";
  by-version."path-browserify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-path-browserify-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-browserify/-/path-browserify-0.0.0.tgz";
        name = "path-browserify-0.0.0.tgz";
        sha1 = "a0b870729aae214005b7d5032ec2cbbb0fb4451a";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "path-browserify" ];
  };
  by-spec."path-is-inside"."~1.0.0" =
    self.by-version."path-is-inside"."1.0.1";
  by-version."path-is-inside"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-path-is-inside-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.1.tgz";
        name = "path-is-inside-1.0.1.tgz";
        sha1 = "98d8f1d030bf04bd7aeee4a1ba5485d40318fd89";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-is-inside" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "path-is-inside" ];
  };
  by-spec."path-to-regexp"."0.1.2" =
    self.by-version."path-to-regexp"."0.1.2";
  by-version."path-to-regexp"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-path-to-regexp-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.2.tgz";
        name = "path-to-regexp-0.1.2.tgz";
        sha1 = "9b2b151f9cc3018c9eea50ca95729e05781712b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-to-regexp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "path-to-regexp" ];
  };
  by-spec."pause"."0.0.1" =
    self.by-version."pause"."0.0.1";
  by-version."pause"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-pause-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pause/-/pause-0.0.1.tgz";
        name = "pause-0.0.1.tgz";
        sha1 = "1d408b3fdb76923b9543d96fb4c9dfd535d9cb5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."pause" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pause" ];
  };
  by-spec."phantomjs"."~1.9.1-2" =
    self.by-version."phantomjs"."1.9.7-1";
  by-version."phantomjs"."1.9.7-1" = lib.makeOverridable self.buildNodePackage {
    name = "phantomjs-1.9.7-1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/phantomjs/-/phantomjs-1.9.7-1.tgz";
        name = "phantomjs-1.9.7-1.tgz";
        sha1 = "57a191c908de74d27ac4948bd66100ae88222f47";
      })
    ];
    buildInputs =
      (self.nativeDeps."phantomjs" or []);
    deps = [
      self.by-version."adm-zip"."0.2.1"
      self.by-version."kew"."0.1.7"
      self.by-version."ncp"."0.4.2"
      self.by-version."npmconf"."0.0.24"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."rimraf"."2.2.6"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "phantomjs" ];
  };
  by-spec."pkginfo"."0.2.x" =
    self.by-version."pkginfo"."0.2.3";
  by-version."pkginfo"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-pkginfo-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.2.3.tgz";
        name = "pkginfo-0.2.3.tgz";
        sha1 = "7239c42a5ef6c30b8f328439d9b9ff71042490f8";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  by-spec."pkginfo"."0.3.0" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-pkginfo-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        name = "pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-spec."pkginfo"."0.x.x" =
    self.by-version."pkginfo"."0.3.0";
  by-spec."plist-native"."*" =
    self.by-version."plist-native"."0.2.3";
  by-version."plist-native"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-plist-native-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plist-native/-/plist-native-0.2.3.tgz";
        name = "plist-native-0.2.3.tgz";
        sha1 = "76843a2da80d587b75dcbcc1634c6f3968a2af17";
      })
    ];
    buildInputs =
      (self.nativeDeps."plist-native" or []);
    deps = [
      self.by-version."libxmljs"."0.8.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "plist-native" ];
  };
  "plist-native" = self.by-version."plist-native"."0.2.3";
  by-spec."policyfile"."0.0.4" =
    self.by-version."policyfile"."0.0.4";
  by-version."policyfile"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-policyfile-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/policyfile/-/policyfile-0.0.4.tgz";
        name = "policyfile-0.0.4.tgz";
        sha1 = "d6b82ead98ae79ebe228e2daf5903311ec982e4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."policyfile" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "policyfile" ];
  };
  by-spec."posix"."*" =
    self.by-version."posix"."1.0.3";
  by-version."posix"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-posix-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/posix/-/posix-1.0.3.tgz";
        name = "posix-1.0.3.tgz";
        sha1 = "f0efae90d59c56c4509c8f0ed222b421caa8188a";
      })
    ];
    buildInputs =
      (self.nativeDeps."posix" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "posix" ];
  };
  "posix" = self.by-version."posix"."1.0.3";
  by-spec."posix-getopt"."1.0.0" =
    self.by-version."posix-getopt"."1.0.0";
  by-version."posix-getopt"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-posix-getopt-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/posix-getopt/-/posix-getopt-1.0.0.tgz";
        name = "posix-getopt-1.0.0.tgz";
        sha1 = "42a90eca6119014c78bc4b9b70463d294db1aa87";
      })
    ];
    buildInputs =
      (self.nativeDeps."posix-getopt" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "posix-getopt" ];
  };
  by-spec."pretty-bytes"."^0.1.0" =
    self.by-version."pretty-bytes"."0.1.0";
  by-version."pretty-bytes"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "pretty-bytes-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pretty-bytes/-/pretty-bytes-0.1.0.tgz";
        name = "pretty-bytes-0.1.0.tgz";
        sha1 = "2cad1cdd7838fe59018ae5e0ccf7cae741942f8e";
      })
    ];
    buildInputs =
      (self.nativeDeps."pretty-bytes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pretty-bytes" ];
  };
  by-spec."process"."~0.5.1" =
    self.by-version."process"."0.5.2";
  by-version."process"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-process-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/process/-/process-0.5.2.tgz";
        name = "process-0.5.2.tgz";
        sha1 = "1638d8a8e34c2f440a91db95ab9aeb677fc185cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."process" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "process" ];
  };
  by-spec."promise"."~2.0" =
    self.by-version."promise"."2.0.0";
  by-version."promise"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-promise-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promise/-/promise-2.0.0.tgz";
        name = "promise-2.0.0.tgz";
        sha1 = "46648aa9d605af5d2e70c3024bf59436da02b80e";
      })
    ];
    buildInputs =
      (self.nativeDeps."promise" or []);
    deps = [
      self.by-version."is-promise"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "promise" ];
  };
  by-spec."prompt"."0.2.11" =
    self.by-version."prompt"."0.2.11";
  by-version."prompt"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-prompt-0.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/prompt/-/prompt-0.2.11.tgz";
        name = "prompt-0.2.11.tgz";
        sha1 = "26d455af4b7fac15291dfcdddf2400328c1fa446";
      })
    ];
    buildInputs =
      (self.nativeDeps."prompt" or []);
    deps = [
      self.by-version."pkginfo"."0.3.0"
      self.by-version."read"."1.0.5"
      self.by-version."revalidator"."0.1.6"
      self.by-version."utile"."0.2.1"
      self.by-version."winston"."0.6.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "prompt" ];
  };
  by-spec."promptly"."~0.2.0" =
    self.by-version."promptly"."0.2.0";
  by-version."promptly"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-promptly-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promptly/-/promptly-0.2.0.tgz";
        name = "promptly-0.2.0.tgz";
        sha1 = "73ef200fa8329d5d3a8df41798950b8646ca46d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."promptly" or []);
    deps = [
      self.by-version."read"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "promptly" ];
  };
  by-spec."promzard"."~0.2.0" =
    self.by-version."promzard"."0.2.1";
  by-version."promzard"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-promzard-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promzard/-/promzard-0.2.1.tgz";
        name = "promzard-0.2.1.tgz";
        sha1 = "c4c7cbe5182465c13b43540be9daf47098b4e75b";
      })
    ];
    buildInputs =
      (self.nativeDeps."promzard" or []);
    deps = [
      self.by-version."read"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "promzard" ];
  };
  by-spec."proto-list"."~1.2.1" =
    self.by-version."proto-list"."1.2.2";
  by-version."proto-list"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-proto-list-1.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proto-list/-/proto-list-1.2.2.tgz";
        name = "proto-list-1.2.2.tgz";
        sha1 = "48b88798261ec2c4a785720cdfec6200d57d3326";
      })
    ];
    buildInputs =
      (self.nativeDeps."proto-list" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "proto-list" ];
  };
  by-spec."protobufjs".">= 1.1.4" =
    self.by-version."protobufjs"."2.0.5";
  by-version."protobufjs"."2.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "protobufjs-2.0.5";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/protobufjs/-/protobufjs-2.0.5.tgz";
        name = "protobufjs-2.0.5.tgz";
        sha1 = "7f351178c959b333d2327b773325ca4b2627a242";
      })
    ];
    buildInputs =
      (self.nativeDeps."protobufjs" or []);
    deps = [
      self.by-version."bytebuffer"."2.3.1"
      self.by-version."ascli"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "protobufjs" ];
  };
  by-spec."ps-tree"."0.0.x" =
    self.by-version."ps-tree"."0.0.3";
  by-version."ps-tree"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-ps-tree-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ps-tree/-/ps-tree-0.0.3.tgz";
        name = "ps-tree-0.0.3.tgz";
        sha1 = "dbf8d752a7fe22fa7d58635689499610e9276ddc";
      })
    ];
    buildInputs =
      (self.nativeDeps."ps-tree" or []);
    deps = [
      self.by-version."event-stream"."0.5.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ps-tree" ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.2.4";
  by-version."punycode"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-punycode-1.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.2.4.tgz";
        name = "punycode-1.2.4.tgz";
        sha1 = "54008ac972aec74175def9cba6df7fa9d3918740";
      })
    ];
    buildInputs =
      (self.nativeDeps."punycode" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "punycode" ];
  };
  by-spec."punycode".">=1.0.0 <1.1.0" =
    self.by-version."punycode"."1.0.0";
  by-version."punycode"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-punycode-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.0.0.tgz";
        name = "punycode-1.0.0.tgz";
        sha1 = "ce9e6c6e9c1db5827174fceb12ff4938700a1bd3";
      })
    ];
    buildInputs =
      (self.nativeDeps."punycode" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "punycode" ];
  };
  by-spec."punycode"."~1.2.3" =
    self.by-version."punycode"."1.2.4";
  by-spec."q".">= 0.0.1" =
    self.by-version."q"."2.0.1";
  by-version."q"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-q-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-2.0.1.tgz";
        name = "q-2.0.1.tgz";
        sha1 = "ae9dc1edd970e72820a1ca716ecc1b0fc96c1c5a";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = [
      self.by-version."asap"."1.0.0"
      self.by-version."collections"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  by-spec."q"."~0.9.2" =
    self.by-version."q"."0.9.7";
  by-version."q"."0.9.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-q-0.9.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        name = "q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  by-spec."q"."~0.9.6" =
    self.by-version."q"."0.9.7";
  by-spec."q"."~0.9.7" =
    self.by-version."q"."0.9.7";
  by-spec."q"."~1.0.0" =
    self.by-version."q"."1.0.1";
  by-version."q"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-q-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-1.0.1.tgz";
        name = "q-1.0.1.tgz";
        sha1 = "11872aeedee89268110b10a718448ffb10112a14";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  by-spec."qs"."0.4.2" =
    self.by-version."qs"."0.4.2";
  by-version."qs"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.4.2.tgz";
        name = "qs-0.4.2.tgz";
        sha1 = "3cac4c861e371a8c9c4770ac23cda8de639b8e5f";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.4.x" =
    self.by-version."qs"."0.4.2";
  by-spec."qs"."0.5.1" =
    self.by-version."qs"."0.5.1";
  by-version."qs"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.1.tgz";
        name = "qs-0.5.1.tgz";
        sha1 = "9f6bf5d9ac6c76384e95d36d15b48980e5e4add0";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.5.2" =
    self.by-version."qs"."0.5.2";
  by-version."qs"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.2.tgz";
        name = "qs-0.5.2.tgz";
        sha1 = "e5734acb7009fb918e800fd5c60c2f5b94a7ff43";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.5.5" =
    self.by-version."qs"."0.5.5";
  by-version."qs"."0.5.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.5.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.5.tgz";
        name = "qs-0.5.5.tgz";
        sha1 = "b07f0d7ffe3efc6fc2fcde6c66a20775641423f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.6.5" =
    self.by-version."qs"."0.6.5";
  by-version."qs"."0.6.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.6.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.5.tgz";
        name = "qs-0.6.5.tgz";
        sha1 = "294b268e4b0d4250f6dde19b3b8b34935dff14ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.6.6" =
    self.by-version."qs"."0.6.6";
  by-version."qs"."0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.6.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
        name = "qs-0.6.6.tgz";
        sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs".">= 0.4.0" =
    self.by-version."qs"."0.6.6";
  by-spec."qs"."~0.5.0" =
    self.by-version."qs"."0.5.6";
  by-version."qs"."0.5.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.5.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
        name = "qs-0.5.6.tgz";
        sha1 = "31b1ad058567651c526921506b9a8793911a0384";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."~0.5.4" =
    self.by-version."qs"."0.5.6";
  by-spec."qs"."~0.6.0" =
    self.by-version."qs"."0.6.6";
  by-spec."querystring".">=0.1.0 <0.2.0" =
    self.by-version."querystring"."0.1.0";
  by-version."querystring"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-querystring-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/querystring/-/querystring-0.1.0.tgz";
        name = "querystring-0.1.0.tgz";
        sha1 = "cb76a26cda0a10a94163fcdb3e132827f04b7b10";
      })
    ];
    buildInputs =
      (self.nativeDeps."querystring" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "querystring" ];
  };
  by-spec."querystring-es3"."0.2.0" =
    self.by-version."querystring-es3"."0.2.0";
  by-version."querystring-es3"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-querystring-es3-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.0.tgz";
        name = "querystring-es3-0.2.0.tgz";
        sha1 = "c365a08a69c443accfeb3a9deab35e3f0abaa476";
      })
    ];
    buildInputs =
      (self.nativeDeps."querystring-es3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "querystring-es3" ];
  };
  by-spec."rai"."~0.1" =
    self.by-version."rai"."0.1.9";
  by-version."rai"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-rai-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rai/-/rai-0.1.9.tgz";
        name = "rai-0.1.9.tgz";
        sha1 = "0f71aac1b8787828b0e0bdae73ec4fe64bad11fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."rai" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rai" ];
  };
  by-spec."range-parser"."0.0.4" =
    self.by-version."range-parser"."0.0.4";
  by-version."range-parser"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-range-parser-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-0.0.4.tgz";
        name = "range-parser-0.0.4.tgz";
        sha1 = "c0427ffef51c10acba0782a46c9602e744ff620b";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."range-parser"."1.0.0" =
    self.by-version."range-parser"."1.0.0";
  by-version."range-parser"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-range-parser-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.0.tgz";
        name = "range-parser-1.0.0.tgz";
        sha1 = "a4b264cfe0be5ce36abe3765ac9c2a248746dbc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."range-parser"."~1.0.0" =
    self.by-version."range-parser"."1.0.0";
  by-spec."raven"."~0.6.2" =
    self.by-version."raven"."0.6.2";
  by-version."raven"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "raven-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raven/-/raven-0.6.2.tgz";
        name = "raven-0.6.2.tgz";
        sha1 = "391a7395b6088518a01697f639f21ce6ea9841a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."raven" or []);
    deps = [
      self.by-version."node-uuid"."1.4.1"
      self.by-version."stack-trace"."0.0.7"
      self.by-version."lsmod"."0.0.3"
      self.by-version."cookie"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raven" ];
  };
  by-spec."raw-body"."0.0.3" =
    self.by-version."raw-body"."0.0.3";
  by-version."raw-body"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-raw-body-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-0.0.3.tgz";
        name = "raw-body-0.0.3.tgz";
        sha1 = "0cb3eb22ced1ca607d32dd8fd94a6eb383f3eb8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."raw-body"."1.1.2" =
    self.by-version."raw-body"."1.1.2";
  by-version."raw-body"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-raw-body-1.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.1.2.tgz";
        name = "raw-body-1.1.2.tgz";
        sha1 = "c74b3004dea5defd1696171106ac740ec31d62be";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = [
      self.by-version."bytes"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."raw-body"."1.1.3" =
    self.by-version."raw-body"."1.1.3";
  by-version."raw-body"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-raw-body-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.1.3.tgz";
        name = "raw-body-1.1.3.tgz";
        sha1 = "3d2f91e2449259cc67b8c3ce9f061db5b987935b";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = [
      self.by-version."bytes"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."raw-socket"."*" =
    self.by-version."raw-socket"."1.2.2";
  by-version."raw-socket"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-raw-socket-1.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-socket/-/raw-socket-1.2.2.tgz";
        name = "raw-socket-1.2.2.tgz";
        sha1 = "c9be873878a1ef70497a27e40b6e55b563d8f886";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-socket" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-socket" ];
  };
  by-spec."rbytes"."*" =
    self.by-version."rbytes"."1.0.0";
  by-version."rbytes"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-rbytes-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rbytes/-/rbytes-1.0.0.tgz";
        name = "rbytes-1.0.0.tgz";
        sha1 = "4eeb85c457f710d8147329d5eed5cd02c798fa4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."rbytes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rbytes" ];
  };
  "rbytes" = self.by-version."rbytes"."1.0.0";
  by-spec."rc"."~0.3.0" =
    self.by-version."rc"."0.3.4";
  by-version."rc"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.3.4.tgz";
        name = "rc-0.3.4.tgz";
        sha1 = "01101660fb38363c22afbddfad46ecdb92b42df9";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc" or []);
    deps = [
      self.by-version."minimist"."0.0.8"
      self.by-version."deep-extend"."0.2.8"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  by-spec."rc"."~0.3.4" =
    self.by-version."rc"."0.3.4";
  by-spec."read"."1" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-read-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        name = "read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read" or []);
    deps = [
      self.by-version."mute-stream"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  by-spec."read"."1.0.x" =
    self.by-version."read"."1.0.5";
  by-spec."read"."~1.0.1" =
    self.by-version."read"."1.0.5";
  by-spec."read"."~1.0.4" =
    self.by-version."read"."1.0.5";
  by-spec."read-installed"."0.2.2" =
    self.by-version."read-installed"."0.2.2";
  by-version."read-installed"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-read-installed-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-installed/-/read-installed-0.2.2.tgz";
        name = "read-installed-0.2.2.tgz";
        sha1 = "f570ac84fb29c75f16faa3940a8c1e602c8eecab";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-installed" or []);
    deps = [
      self.by-version."semver"."2.2.1"
      self.by-version."slide"."1.1.5"
      self.by-version."read-package-json"."1.1.8"
      self.by-version."graceful-fs"."1.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
  by-spec."read-installed"."~2.0.1" =
    self.by-version."read-installed"."2.0.2";
  by-version."read-installed"."2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-read-installed-2.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-installed/-/read-installed-2.0.2.tgz";
        name = "read-installed-2.0.2.tgz";
        sha1 = "e69e7e1946af932b2fa454465639ebea4d63773c";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-installed" or []);
    deps = [
      self.by-version."read-package-json"."1.1.8"
      self.by-version."semver"."2.2.1"
      self.by-version."slide"."1.1.5"
      self.by-version."util-extend"."1.0.1"
      self.by-version."graceful-fs"."2.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
  by-spec."read-package-json"."1" =
    self.by-version."read-package-json"."1.1.8";
  by-version."read-package-json"."1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-read-package-json-1.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.1.8.tgz";
        name = "read-package-json-1.1.8.tgz";
        sha1 = "234928819444283fd63f9d93ce03ba00668e94f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json" or []);
    deps = [
      self.by-version."glob"."3.2.9"
      self.by-version."lru-cache"."2.5.0"
      self.by-version."normalize-package-data"."0.2.12"
      self.by-version."graceful-fs"."2.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  by-spec."read-package-json"."~1.1.8" =
    self.by-version."read-package-json"."1.1.8";
  by-spec."readable-stream"."1.0" =
    self.by-version."readable-stream"."1.0.26";
  by-version."readable-stream"."1.0.26" = lib.makeOverridable self.buildNodePackage {
    name = "node-readable-stream-1.0.26";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.26.tgz";
        name = "readable-stream-1.0.26.tgz";
        sha1 = "12a9c4415f6a85374abe18b7831ba52d43105766";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = [
      self.by-version."string_decoder"."0.10.25"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.11";
  by-version."readable-stream"."1.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-readable-stream-1.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.11.tgz";
        name = "readable-stream-1.1.11.tgz";
        sha1 = "76ae0d88df2ac36c59e7c205e0cafc81c57bc07d";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = [
      self.by-version."core-util-is"."1.0.1"
      self.by-version."string_decoder"."0.10.25"
      self.by-version."debuglog"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."~1.0.17" =
    self.by-version."readable-stream"."1.0.26";
  by-spec."readable-stream"."~1.0.2" =
    self.by-version."readable-stream"."1.0.26";
  by-spec."readable-stream"."~1.0.24" =
    self.by-version."readable-stream"."1.0.26";
  by-spec."readable-stream"."~1.1.8" =
    self.by-version."readable-stream"."1.1.11";
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.11";
  by-spec."readdirp"."~0.2.3" =
    self.by-version."readdirp"."0.2.5";
  by-version."readdirp"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-readdirp-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readdirp/-/readdirp-0.2.5.tgz";
        name = "readdirp-0.2.5.tgz";
        sha1 = "c4c276e52977ae25db5191fe51d008550f15d9bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."readdirp" or []);
    deps = [
      self.by-version."minimatch"."0.2.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readdirp" ];
  };
  by-spec."readline2"."~0.1.0" =
    self.by-version."readline2"."0.1.0";
  by-version."readline2"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-readline2-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readline2/-/readline2-0.1.0.tgz";
        name = "readline2-0.1.0.tgz";
        sha1 = "6a272ef89731225b448e4c6799b6e50d5be12b98";
      })
    ];
    buildInputs =
      (self.nativeDeps."readline2" or []);
    deps = [
      self.by-version."mute-stream"."0.0.4"
      self.by-version."lodash"."2.4.1"
      self.by-version."chalk"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readline2" ];
  };
  by-spec."recursive-readdir"."0.0.2" =
    self.by-version."recursive-readdir"."0.0.2";
  by-version."recursive-readdir"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-recursive-readdir-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/recursive-readdir/-/recursive-readdir-0.0.2.tgz";
        name = "recursive-readdir-0.0.2.tgz";
        sha1 = "0bc47dc4838e646dccfba0507b5e57ffbff35f7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."recursive-readdir" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "recursive-readdir" ];
  };
  by-spec."redeyed"."~0.4.0" =
    self.by-version."redeyed"."0.4.4";
  by-version."redeyed"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-redeyed-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redeyed/-/redeyed-0.4.4.tgz";
        name = "redeyed-0.4.4.tgz";
        sha1 = "37e990a6f2b21b2a11c2e6a48fd4135698cba97f";
      })
    ];
    buildInputs =
      (self.nativeDeps."redeyed" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redeyed" ];
  };
  by-spec."redis"."*" =
    self.by-version."redis"."0.10.1";
  by-version."redis"."0.10.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-redis-0.10.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.10.1.tgz";
        name = "redis-0.10.1.tgz";
        sha1 = "4f09258931d961377239fdbd495e1d99a263a8ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  "redis" = self.by-version."redis"."0.10.1";
  by-spec."redis"."0.7.2" =
    self.by-version."redis"."0.7.2";
  by-version."redis"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-redis-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.7.2.tgz";
        name = "redis-0.7.2.tgz";
        sha1 = "fa557fef4985ab3e3384fdc5be6e2541a0bb49af";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = [
      self.by-version."hiredis"."0.1.16"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  by-spec."redis"."0.7.3" =
    self.by-version."redis"."0.7.3";
  by-version."redis"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-redis-0.7.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.7.3.tgz";
        name = "redis-0.7.3.tgz";
        sha1 = "ee57b7a44d25ec1594e44365d8165fa7d1d4811a";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  by-spec."redis"."0.8.x" =
    self.by-version."redis"."0.8.6";
  by-version."redis"."0.8.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-redis-0.8.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.8.6.tgz";
        name = "redis-0.8.6.tgz";
        sha1 = "a7ae8f0d6fad24bdeaffe28158d6cd1f1c9d30b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  by-spec."redis"."~0.10.0" =
    self.by-version."redis"."0.10.1";
  by-spec."reds"."~0.2.4" =
    self.by-version."reds"."0.2.4";
  by-version."reds"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-reds-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/reds/-/reds-0.2.4.tgz";
        name = "reds-0.2.4.tgz";
        sha1 = "a82dcaaa52319635bc6eee3ef9c1ac074411de3c";
      })
    ];
    buildInputs =
      (self.nativeDeps."reds" or []);
    deps = [
      self.by-version."natural"."0.1.17"
      self.by-version."redis"."0.7.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "reds" ];
  };
  by-spec."reduce-component"."1.0.1" =
    self.by-version."reduce-component"."1.0.1";
  by-version."reduce-component"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-reduce-component-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/reduce-component/-/reduce-component-1.0.1.tgz";
        name = "reduce-component-1.0.1.tgz";
        sha1 = "e0c93542c574521bea13df0f9488ed82ab77c5da";
      })
    ];
    buildInputs =
      (self.nativeDeps."reduce-component" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "reduce-component" ];
  };
  by-spec."regexp-clone"."0.0.1" =
    self.by-version."regexp-clone"."0.0.1";
  by-version."regexp-clone"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-regexp-clone-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/regexp-clone/-/regexp-clone-0.0.1.tgz";
        name = "regexp-clone-0.0.1.tgz";
        sha1 = "a7c2e09891fdbf38fbb10d376fb73003e68ac589";
      })
    ];
    buildInputs =
      (self.nativeDeps."regexp-clone" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "regexp-clone" ];
  };
  by-spec."replace"."~0.2.4" =
    self.by-version."replace"."0.2.9";
  by-version."replace"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "replace-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/replace/-/replace-0.2.9.tgz";
        name = "replace-0.2.9.tgz";
        sha1 = "64428de4451717e8cc34965d2d133dd86dace404";
      })
    ];
    buildInputs =
      (self.nativeDeps."replace" or []);
    deps = [
      self.by-version."nomnom"."1.6.2"
      self.by-version."colors"."0.5.1"
      self.by-version."minimatch"."0.2.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "replace" ];
  };
  by-spec."request"."2" =
    self.by-version."request"."2.34.0";
  by-version."request"."2.34.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.34.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.34.0.tgz";
        name = "request-2.34.0.tgz";
        sha1 = "b5d8b9526add4a2d4629f4d417124573996445ae";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."tough-cookie"."0.12.1"
      self.by-version."form-data"."0.1.2"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.10.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."hawk"."1.0.0"
      self.by-version."aws-sign2"."0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2 >=2.20.0" =
    self.by-version."request"."2.34.0";
  by-spec."request"."2 >=2.25.0" =
    self.by-version."request"."2.34.0";
  by-spec."request"."2.16.2" =
    self.by-version."request"."2.16.2";
  by-version."request"."2.16.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.16.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.2.tgz";
        name = "request-2.16.2.tgz";
        sha1 = "83a028be61be4a05163e7e2e7a4b40e35df1bcb9";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."form-data"."0.0.10"
      self.by-version."mime"."1.2.11"
      self.by-version."hawk"."0.10.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."cookie-jar"."0.2.0"
      self.by-version."aws-sign"."0.2.0"
      self.by-version."oauth-sign"."0.2.0"
      self.by-version."forever-agent"."0.2.0"
      self.by-version."tunnel-agent"."0.2.0"
      self.by-version."json-stringify-safe"."3.0.0"
      self.by-version."qs"."0.5.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2.16.x" =
    self.by-version."request"."2.16.6";
  by-version."request"."2.16.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.16.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.6.tgz";
        name = "request-2.16.6.tgz";
        sha1 = "872fe445ae72de266b37879d6ad7dc948fa01cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."form-data"."0.0.10"
      self.by-version."mime"."1.2.11"
      self.by-version."hawk"."0.10.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."cookie-jar"."0.2.0"
      self.by-version."aws-sign"."0.2.0"
      self.by-version."oauth-sign"."0.2.0"
      self.by-version."forever-agent"."0.2.0"
      self.by-version."tunnel-agent"."0.2.0"
      self.by-version."json-stringify-safe"."3.0.0"
      self.by-version."qs"."0.5.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2.9.x" =
    self.by-version."request"."2.9.203";
  by-version."request"."2.9.203" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.9.203";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.9.203.tgz";
        name = "request-2.9.203.tgz";
        sha1 = "6c1711a5407fb94a114219563e44145bcbf4723a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request".">=2.33.0" =
    self.by-version."request"."2.34.0";
  by-spec."request"."~2" =
    self.by-version."request"."2.34.0";
  by-spec."request"."~2.27.0" =
    self.by-version."request"."2.27.0";
  by-version."request"."2.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        name = "request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.2"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.10.0"
      self.by-version."hawk"."1.0.0"
      self.by-version."aws-sign"."0.3.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."cookie-jar"."0.3.0"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."form-data"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.30.0" =
    self.by-version."request"."2.30.0";
  by-version."request"."2.30.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.30.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.30.0.tgz";
        name = "request-2.30.0.tgz";
        sha1 = "8e0d36f0806e8911524b072b64c5ee535a09d861";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."tough-cookie"."0.9.15"
      self.by-version."form-data"."0.1.2"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.10.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."hawk"."1.0.0"
      self.by-version."aws-sign2"."0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.31.0" =
    self.by-version."request"."2.31.0";
  by-version."request"."2.31.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.31.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.31.0.tgz";
        name = "request-2.31.0.tgz";
        sha1 = "4c8ac967c9a4b9410cb4ba1a61fdb644267eeeff";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."tough-cookie"."0.9.15"
      self.by-version."form-data"."0.1.2"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.10.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."hawk"."1.0.0"
      self.by-version."aws-sign2"."0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.33.0" =
    self.by-version."request"."2.33.0";
  by-version."request"."2.33.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.33.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.33.0.tgz";
        name = "request-2.33.0.tgz";
        sha1 = "5167878131726070ec633752ea230a2379dc65ff";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."tough-cookie"."0.12.1"
      self.by-version."form-data"."0.1.2"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.10.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."hawk"."1.0.0"
      self.by-version."aws-sign2"."0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request-progress"."~0.3.0" =
    self.by-version."request-progress"."0.3.1";
  by-version."request-progress"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-progress-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-progress/-/request-progress-0.3.1.tgz";
        name = "request-progress-0.3.1.tgz";
        sha1 = "0721c105d8a96ac6b2ce8b2c89ae2d5ecfcf6b3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-progress" or []);
    deps = [
      self.by-version."throttleit"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request-progress" ];
  };
  by-spec."request-replay"."~0.2.0" =
    self.by-version."request-replay"."0.2.0";
  by-version."request-replay"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-replay-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-replay/-/request-replay-0.2.0.tgz";
        name = "request-replay-0.2.0.tgz";
        sha1 = "9b693a5d118b39f5c596ead5ed91a26444057f60";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-replay" or []);
    deps = [
      self.by-version."retry"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request-replay" ];
  };
  by-spec."requirejs"."~2.1" =
    self.by-version."requirejs"."2.1.11";
  by-version."requirejs"."2.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "requirejs-2.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/requirejs/-/requirejs-2.1.11.tgz";
        name = "requirejs-2.1.11.tgz";
        sha1 = "0eafaa6b46ca9b5b1e13406f119c020190a24442";
      })
    ];
    buildInputs =
      (self.nativeDeps."requirejs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "requirejs" ];
  };
  by-spec."requirejs"."~2.1.0" =
    self.by-version."requirejs"."2.1.11";
  by-spec."resolve"."0.6.1" =
    self.by-version."resolve"."0.6.1";
  by-version."resolve"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-resolve-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.6.1.tgz";
        name = "resolve-0.6.1.tgz";
        sha1 = "b7fc874a8fe240b44de2c92b7f885a2e8598b652";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."resolve"."0.6.x" =
    self.by-version."resolve"."0.6.2";
  by-version."resolve"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-resolve-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.6.2.tgz";
        name = "resolve-0.6.2.tgz";
        sha1 = "7404e59e3c02980aa172272186521db3cf0a15f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."resolve"."~0.3.0" =
    self.by-version."resolve"."0.3.1";
  by-version."resolve"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-resolve-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.3.1.tgz";
        name = "resolve-0.3.1.tgz";
        sha1 = "34c63447c664c70598d1c9b126fc43b2a24310a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."resolve"."~0.3.1" =
    self.by-version."resolve"."0.3.1";
  by-spec."resolve"."~0.6.0" =
    self.by-version."resolve"."0.6.2";
  by-spec."resolve"."~0.6.1" =
    self.by-version."resolve"."0.6.2";
  by-spec."response-time"."1.0.0" =
    self.by-version."response-time"."1.0.0";
  by-version."response-time"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-response-time-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/response-time/-/response-time-1.0.0.tgz";
        name = "response-time-1.0.0.tgz";
        sha1 = "c2bc8d08f3c359f97eae1d6da86eead175fabdc9";
      })
    ];
    buildInputs =
      (self.nativeDeps."response-time" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "response-time" ];
  };
  by-spec."restify"."2.4.1" =
    self.by-version."restify"."2.4.1";
  by-version."restify"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "restify-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/restify/-/restify-2.4.1.tgz";
        name = "restify-2.4.1.tgz";
        sha1 = "35790a052bd0927e7f6a06cc3d079e56fabc9371";
      })
    ];
    buildInputs =
      (self.nativeDeps."restify" or []);
    deps = [
      self.by-version."assert-plus"."0.1.2"
      self.by-version."backoff"."2.1.0"
      self.by-version."bunyan"."0.21.1"
      self.by-version."deep-equal"."0.0.0"
      self.by-version."formidable"."1.0.13"
      self.by-version."http-signature"."0.9.11"
      self.by-version."keep-alive-agent"."0.0.1"
      self.by-version."lru-cache"."2.3.0"
      self.by-version."mime"."1.2.9"
      self.by-version."negotiator"."0.2.5"
      self.by-version."node-uuid"."1.4.0"
      self.by-version."once"."1.1.1"
      self.by-version."qs"."0.5.5"
      self.by-version."semver"."1.1.4"
      self.by-version."spdy"."1.7.1"
      self.by-version."verror"."1.3.6"
      self.by-version."dtrace-provider"."0.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "restify" ];
  };
  by-spec."rethinkdb"."*" =
    self.by-version."rethinkdb"."1.12.0-0";
  by-version."rethinkdb"."1.12.0-0" = lib.makeOverridable self.buildNodePackage {
    name = "node-rethinkdb-1.12.0-0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rethinkdb/-/rethinkdb-1.12.0-0.tgz";
        name = "rethinkdb-1.12.0-0.tgz";
        sha1 = "cad01e869bd12dcd09f235c5ec8f5ccf26cc6f81";
      })
    ];
    buildInputs =
      (self.nativeDeps."rethinkdb" or []);
    deps = [
      self.by-version."protobufjs"."2.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rethinkdb" ];
  };
  "rethinkdb" = self.by-version."rethinkdb"."1.12.0-0";
  by-spec."retry"."0.6.0" =
    self.by-version."retry"."0.6.0";
  by-version."retry"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-retry-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/retry/-/retry-0.6.0.tgz";
        name = "retry-0.6.0.tgz";
        sha1 = "1c010713279a6fd1e8def28af0c3ff1871caa537";
      })
    ];
    buildInputs =
      (self.nativeDeps."retry" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "retry" ];
  };
  by-spec."retry"."~0.6.0" =
    self.by-version."retry"."0.6.0";
  by-spec."revalidator"."0.1.x" =
    self.by-version."revalidator"."0.1.6";
  by-version."revalidator"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-revalidator-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/revalidator/-/revalidator-0.1.6.tgz";
        name = "revalidator-0.1.6.tgz";
        sha1 = "0af2bab68d7d0e766fc4249660ebc2be28b594ba";
      })
    ];
    buildInputs =
      (self.nativeDeps."revalidator" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "revalidator" ];
  };
  by-spec."rfile"."~1.0" =
    self.by-version."rfile"."1.0.0";
  by-version."rfile"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-rfile-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rfile/-/rfile-1.0.0.tgz";
        name = "rfile-1.0.0.tgz";
        sha1 = "59708cf90ca1e74c54c3cfc5c36fdb9810435261";
      })
    ];
    buildInputs =
      (self.nativeDeps."rfile" or []);
    deps = [
      self.by-version."callsite"."1.0.0"
      self.by-version."resolve"."0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rfile" ];
  };
  by-spec."rfile"."~1.0.0" =
    self.by-version."rfile"."1.0.0";
  by-spec."rimraf"."1.x.x" =
    self.by-version."rimraf"."1.0.9";
  by-version."rimraf"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-rimraf-1.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-1.0.9.tgz";
        name = "rimraf-1.0.9.tgz";
        sha1 = "be4801ff76c2ba6f1c50c78e9700eb1d21f239f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."2" =
    self.by-version."rimraf"."2.2.6";
  by-version."rimraf"."2.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.6.tgz";
        name = "rimraf-2.2.6.tgz";
        sha1 = "c59597569b14d956ad29cacc42bdddf5f0ea4f4c";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."2.x.x" =
    self.by-version."rimraf"."2.2.6";
  by-spec."rimraf"."~2" =
    self.by-version."rimraf"."2.2.6";
  by-spec."rimraf"."~2.0.2" =
    self.by-version."rimraf"."2.0.3";
  by-version."rimraf"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-rimraf-2.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.0.3.tgz";
        name = "rimraf-2.0.3.tgz";
        sha1 = "f50a2965e7144e9afd998982f15df706730f56a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = [
      self.by-version."graceful-fs"."1.1.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."~2.1.4" =
    self.by-version."rimraf"."2.1.4";
  by-version."rimraf"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-rimraf-2.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.1.4.tgz";
        name = "rimraf-2.1.4.tgz";
        sha1 = "5a6eb62eeda068f51ede50f29b3e5cd22f3d9bb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = [
      self.by-version."graceful-fs"."1.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."~2.2.0" =
    self.by-version."rimraf"."2.2.6";
  by-spec."rimraf"."~2.2.2" =
    self.by-version."rimraf"."2.2.6";
  by-spec."rimraf"."~2.2.5" =
    self.by-version."rimraf"."2.2.6";
  by-spec."rimraf"."~2.2.6" =
    self.by-version."rimraf"."2.2.6";
  by-spec."ruglify"."~1.0.0" =
    self.by-version."ruglify"."1.0.0";
  by-version."ruglify"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-ruglify-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ruglify/-/ruglify-1.0.0.tgz";
        name = "ruglify-1.0.0.tgz";
        sha1 = "dc8930e2a9544a274301cc9972574c0d0986b675";
      })
    ];
    buildInputs =
      (self.nativeDeps."ruglify" or []);
    deps = [
      self.by-version."rfile"."1.0.0"
      self.by-version."uglify-js"."2.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ruglify" ];
  };
  by-spec."s3http"."*" =
    self.by-version."s3http"."0.0.5";
  by-version."s3http"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "s3http-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/s3http/-/s3http-0.0.5.tgz";
        name = "s3http-0.0.5.tgz";
        sha1 = "c8fa1fffb8258ce68adf75df73f90fbb6f23d198";
      })
    ];
    buildInputs =
      (self.nativeDeps."s3http" or []);
    deps = [
      self.by-version."aws-sdk"."1.18.0"
      self.by-version."commander"."2.0.0"
      self.by-version."http-auth"."2.0.7"
      self.by-version."express"."3.4.4"
      self.by-version."everyauth"."0.4.5"
      self.by-version."string"."1.6.1"
      self.by-version."util"."0.4.9"
      self.by-version."crypto"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "s3http" ];
  };
  "s3http" = self.by-version."s3http"."0.0.5";
  by-spec."sauce-connect-launcher"."~0.3.0" =
    self.by-version."sauce-connect-launcher"."0.3.2";
  by-version."sauce-connect-launcher"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-sauce-connect-launcher-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sauce-connect-launcher/-/sauce-connect-launcher-0.3.2.tgz";
        name = "sauce-connect-launcher-0.3.2.tgz";
        sha1 = "bcae99571cf78d2e7b2d863eee28fa72f9c90846";
      })
    ];
    buildInputs =
      (self.nativeDeps."sauce-connect-launcher" or []);
    deps = [
      self.by-version."lodash"."1.3.1"
      self.by-version."async"."0.2.10"
      self.by-version."adm-zip"."0.4.4"
      self.by-version."rimraf"."2.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sauce-connect-launcher" ];
  };
  by-spec."saucelabs"."~0.1.0" =
    self.by-version."saucelabs"."0.1.1";
  by-version."saucelabs"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-saucelabs-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/saucelabs/-/saucelabs-0.1.1.tgz";
        name = "saucelabs-0.1.1.tgz";
        sha1 = "5e0ea1cf3d735d6ea15fde94b5bda6bc15d2c06d";
      })
    ];
    buildInputs =
      (self.nativeDeps."saucelabs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "saucelabs" ];
  };
  by-spec."sax"."0.5.x" =
    self.by-version."sax"."0.5.8";
  by-version."sax"."0.5.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-sax-0.5.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.5.8.tgz";
        name = "sax-0.5.8.tgz";
        sha1 = "d472db228eb331c2506b0e8c15524adb939d12c1";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  by-spec."sax".">=0.4.2" =
    self.by-version."sax"."0.6.0";
  by-version."sax"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-sax-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.6.0.tgz";
        name = "sax-0.6.0.tgz";
        sha1 = "7a155519b712e3ec56f102ab984f15e15d3859f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  by-spec."selenium-webdriver"."*" =
    self.by-version."selenium-webdriver"."2.40.0";
  by-version."selenium-webdriver"."2.40.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-selenium-webdriver-2.40.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/selenium-webdriver/-/selenium-webdriver-2.40.0.tgz";
        name = "selenium-webdriver-2.40.0.tgz";
        sha1 = "ca4603c08311ec3688d67e1c8e8263cb9c1c1450";
      })
    ];
    buildInputs =
      (self.nativeDeps."selenium-webdriver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "selenium-webdriver" ];
  };
  "selenium-webdriver" = self.by-version."selenium-webdriver"."2.40.0";
  by-spec."semver"."*" =
    self.by-version."semver"."2.2.1";
  by-version."semver"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.2.1.tgz";
        name = "semver-2.2.1.tgz";
        sha1 = "7941182b3ffcc580bff1c17942acdf7951c0d213";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  "semver" = self.by-version."semver"."2.2.1";
  by-spec."semver"."1.1.0" =
    self.by-version."semver"."1.1.0";
  by-version."semver"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.0.tgz";
        name = "semver-1.1.0.tgz";
        sha1 = "da9b9c837e31550a7c928622bc2381de7dd7a53e";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."1.1.4" =
    self.by-version."semver"."1.1.4";
  by-version."semver"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.4.tgz";
        name = "semver-1.1.4.tgz";
        sha1 = "2e5a4e72bab03472cc97f72753b4508912ef5540";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."2" =
    self.by-version."semver"."2.2.1";
  by-spec."semver"."2.x" =
    self.by-version."semver"."2.2.1";
  by-spec."semver".">=2.0.10 <3.0.0" =
    self.by-version."semver"."2.2.1";
  by-spec."semver".">=2.2.1 <3" =
    self.by-version."semver"."2.2.1";
  by-spec."semver"."^2.2.1" =
    self.by-version."semver"."2.2.1";
  by-spec."semver"."~1.1.0" =
    self.by-version."semver"."1.1.4";
  by-spec."semver"."~1.1.4" =
    self.by-version."semver"."1.1.4";
  by-spec."semver"."~2.0.5" =
    self.by-version."semver"."2.0.11";
  by-version."semver"."2.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.0.11.tgz";
        name = "semver-2.0.11.tgz";
        sha1 = "f51f07d03fa5af79beb537fc067a7e141786cced";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~2.1.0" =
    self.by-version."semver"."2.1.0";
  by-version."semver"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        name = "semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~2.2.1" =
    self.by-version."semver"."2.2.1";
  by-spec."send"."*" =
    self.by-version."send"."0.2.0";
  by-version."send"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-send-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.2.0.tgz";
        name = "send-0.2.0.tgz";
        sha1 = "067abf45cff8bffb29cbdb7439725b32388a2c58";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = [
      self.by-version."debug"."0.7.4"
      self.by-version."mime"."1.2.11"
      self.by-version."fresh"."0.2.2"
      self.by-version."range-parser"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.0.3" =
    self.by-version."send"."0.0.3";
  by-version."send"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-send-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.0.3.tgz";
        name = "send-0.0.3.tgz";
        sha1 = "4d5f843edf9d65dac31c8a5d2672c179ecb67184";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = [
      self.by-version."debug"."0.7.4"
      self.by-version."mime"."1.2.6"
      self.by-version."fresh"."0.1.0"
      self.by-version."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.1.0" =
    self.by-version."send"."0.1.0";
  by-version."send"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-send-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.0.tgz";
        name = "send-0.1.0.tgz";
        sha1 = "cfb08ebd3cec9b7fc1a37d9ff9e875a971cf4640";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = [
      self.by-version."debug"."0.7.4"
      self.by-version."mime"."1.2.6"
      self.by-version."fresh"."0.1.0"
      self.by-version."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.1.4" =
    self.by-version."send"."0.1.4";
  by-version."send"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-send-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.4.tgz";
        name = "send-0.1.4.tgz";
        sha1 = "be70d8d1be01de61821af13780b50345a4f71abd";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = [
      self.by-version."debug"."0.7.4"
      self.by-version."mime"."1.2.11"
      self.by-version."fresh"."0.2.0"
      self.by-version."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.2.0" =
    self.by-version."send"."0.2.0";
  by-spec."sequence"."2.2.1" =
    self.by-version."sequence"."2.2.1";
  by-version."sequence"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-sequence-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
        name = "sequence-2.2.1.tgz";
        sha1 = "7f5617895d44351c0a047e764467690490a16b03";
      })
    ];
    buildInputs =
      (self.nativeDeps."sequence" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sequence" ];
  };
  by-spec."sequence"."2.x" =
    self.by-version."sequence"."2.2.1";
  by-spec."serve-index"."1.0.1" =
    self.by-version."serve-index"."1.0.1";
  by-version."serve-index"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-serve-index-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-index/-/serve-index-1.0.1.tgz";
        name = "serve-index-1.0.1.tgz";
        sha1 = "2782ee8ede6cccaae54957962c4715e8ce1921a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-index" or []);
    deps = [
      self.by-version."batch"."0.5.0"
      self.by-version."negotiator"."0.4.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "serve-index" ];
  };
  by-spec."serve-static"."1.0.1" =
    self.by-version."serve-static"."1.0.1";
  by-version."serve-static"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-serve-static-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.0.1.tgz";
        name = "serve-static-1.0.1.tgz";
        sha1 = "10dcbfd44b3e0291a131fc9ab4ab25a9f5a78a42";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = [
      self.by-version."send"."0.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."serve-static"."1.0.2" =
    self.by-version."serve-static"."1.0.2";
  by-version."serve-static"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-serve-static-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.0.2.tgz";
        name = "serve-static-1.0.2.tgz";
        sha1 = "4129f6727b09fb031134fa6d185683e30bfbef54";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = [
      self.by-version."send"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."sha"."~1.2.1" =
    self.by-version."sha"."1.2.3";
  by-version."sha"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-sha-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha/-/sha-1.2.3.tgz";
        name = "sha-1.2.3.tgz";
        sha1 = "3a96ef3054a0fe0b87c9aa985824a6a736fc0329";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha" or []);
    deps = [
      self.by-version."graceful-fs"."2.0.3"
      self.by-version."readable-stream"."1.0.26"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
  };
  by-spec."shallow-copy"."0.0.1" =
    self.by-version."shallow-copy"."0.0.1";
  by-version."shallow-copy"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-shallow-copy-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shallow-copy/-/shallow-copy-0.0.1.tgz";
        name = "shallow-copy-0.0.1.tgz";
        sha1 = "415f42702d73d810330292cc5ee86eae1a11a170";
      })
    ];
    buildInputs =
      (self.nativeDeps."shallow-copy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shallow-copy" ];
  };
  by-spec."shell-quote"."~0.0.1" =
    self.by-version."shell-quote"."0.0.1";
  by-version."shell-quote"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-shell-quote-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shell-quote/-/shell-quote-0.0.1.tgz";
        name = "shell-quote-0.0.1.tgz";
        sha1 = "1a41196f3c0333c482323593d6886ecf153dd986";
      })
    ];
    buildInputs =
      (self.nativeDeps."shell-quote" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shell-quote" ];
  };
  by-spec."shell-quote"."~1.4.1" =
    self.by-version."shell-quote"."1.4.1";
  by-version."shell-quote"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-shell-quote-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shell-quote/-/shell-quote-1.4.1.tgz";
        name = "shell-quote-1.4.1.tgz";
        sha1 = "ae18442b536a08c720239b079d2f228acbedee40";
      })
    ];
    buildInputs =
      (self.nativeDeps."shell-quote" or []);
    deps = [
      self.by-version."jsonify"."0.0.0"
      self.by-version."array-filter"."0.0.1"
      self.by-version."array-reduce"."0.0.0"
      self.by-version."array-map"."0.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shell-quote" ];
  };
  by-spec."shelljs"."0.1.x" =
    self.by-version."shelljs"."0.1.4";
  by-version."shelljs"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "shelljs-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shelljs/-/shelljs-0.1.4.tgz";
        name = "shelljs-0.1.4.tgz";
        sha1 = "dfbbe78d56c3c0168d2fb79e10ecd1dbcb07ec0e";
      })
    ];
    buildInputs =
      (self.nativeDeps."shelljs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shelljs" ];
  };
  by-spec."shelljs"."~0.2.6" =
    self.by-version."shelljs"."0.2.6";
  by-version."shelljs"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "shelljs-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shelljs/-/shelljs-0.2.6.tgz";
        name = "shelljs-0.2.6.tgz";
        sha1 = "90492d72ffcc8159976baba62fb0f6884f0c3378";
      })
    ];
    buildInputs =
      (self.nativeDeps."shelljs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shelljs" ];
  };
  by-spec."should"."*" =
    self.by-version."should"."3.2.0-beta1";
  by-version."should"."3.2.0-beta1" = lib.makeOverridable self.buildNodePackage {
    name = "node-should-3.2.0-beta1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should/-/should-3.2.0-beta1.tgz";
        name = "should-3.2.0-beta1.tgz";
        sha1 = "91481d7eb1a8c1329616a8544ccec05c6a47354c";
      })
    ];
    buildInputs =
      (self.nativeDeps."should" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "should" ];
  };
  "should" = self.by-version."should"."3.2.0-beta1";
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.0";
  by-version."sigmund"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-sigmund-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.0.tgz";
        name = "sigmund-1.0.0.tgz";
        sha1 = "66a2b3a749ae8b5fb89efd4fcc01dc94fbe02296";
      })
    ];
    buildInputs =
      (self.nativeDeps."sigmund" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sigmund" ];
  };
  by-spec."signals"."<2.0" =
    self.by-version."signals"."1.0.0";
  by-version."signals"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-signals-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/signals/-/signals-1.0.0.tgz";
        name = "signals-1.0.0.tgz";
        sha1 = "65f0c1599352b35372ecaae5a250e6107376ed69";
      })
    ];
    buildInputs =
      (self.nativeDeps."signals" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "signals" ];
  };
  by-spec."signals".">0.7 <2.0" =
    self.by-version."signals"."1.0.0";
  by-spec."signals"."~1.0.0" =
    self.by-version."signals"."1.0.0";
  by-spec."simple-lru-cache"."0.0.x" =
    self.by-version."simple-lru-cache"."0.0.1";
  by-version."simple-lru-cache"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-simple-lru-cache-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/simple-lru-cache/-/simple-lru-cache-0.0.1.tgz";
        name = "simple-lru-cache-0.0.1.tgz";
        sha1 = "0334171e40ed4a4861ac29250eb1db23300be4f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."simple-lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "simple-lru-cache" ];
  };
  by-spec."simplesmtp".">= 0.1.22" =
    self.by-version."simplesmtp"."0.3.23";
  by-version."simplesmtp"."0.3.23" = lib.makeOverridable self.buildNodePackage {
    name = "node-simplesmtp-0.3.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/simplesmtp/-/simplesmtp-0.3.23.tgz";
        name = "simplesmtp-0.3.23.tgz";
        sha1 = "f452cb8f6dfa6cdd5bbdded5d6dc010493ff0c27";
      })
    ];
    buildInputs =
      (self.nativeDeps."simplesmtp" or []);
    deps = [
      self.by-version."rai"."0.1.9"
      self.by-version."xoauth2"."0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "simplesmtp" ];
  };
  by-spec."sliced"."0.0.3" =
    self.by-version."sliced"."0.0.3";
  by-version."sliced"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-sliced-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.3.tgz";
        name = "sliced-0.0.3.tgz";
        sha1 = "4f0bac2171eb17162c3ba6df81f5cf040f7c7e50";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  by-spec."sliced"."0.0.4" =
    self.by-version."sliced"."0.0.4";
  by-version."sliced"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-sliced-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.4.tgz";
        name = "sliced-0.0.4.tgz";
        sha1 = "34f89a6db1f31fa525f5a570f5bcf877cf0955ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  by-spec."sliced"."0.0.5" =
    self.by-version."sliced"."0.0.5";
  by-version."sliced"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-sliced-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.5.tgz";
        name = "sliced-0.0.5.tgz";
        sha1 = "5edc044ca4eb6f7816d50ba2fc63e25d8fe4707f";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  by-spec."slide"."~1.1.3" =
    self.by-version."slide"."1.1.5";
  by-version."slide"."1.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-slide-1.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.5.tgz";
        name = "slide-1.1.5.tgz";
        sha1 = "31732adeae78f1d2d60a29b63baf6a032df7c25d";
      })
    ];
    buildInputs =
      (self.nativeDeps."slide" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "slide" ];
  };
  by-spec."slide"."~1.1.5" =
    self.by-version."slide"."1.1.5";
  by-spec."smartdc"."*" =
    self.by-version."smartdc"."7.2.0";
  by-version."smartdc"."7.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-7.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc/-/smartdc-7.2.0.tgz";
        name = "smartdc-7.2.0.tgz";
        sha1 = "2b4f9375f2c709061e96440976767774d5e4fe86";
      })
    ];
    buildInputs =
      (self.nativeDeps."smartdc" or []);
    deps = [
      self.by-version."assert-plus"."0.1.2"
      self.by-version."lru-cache"."2.2.0"
      self.by-version."nopt"."2.0.0"
      self.by-version."restify"."2.4.1"
      self.by-version."bunyan"."0.21.1"
      self.by-version."clone"."0.1.6"
      self.by-version."smartdc-auth"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "smartdc" ];
  };
  "smartdc" = self.by-version."smartdc"."7.2.0";
  by-spec."smartdc-auth"."1.0.1" =
    self.by-version."smartdc-auth"."1.0.1";
  by-version."smartdc-auth"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-smartdc-auth-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc-auth/-/smartdc-auth-1.0.1.tgz";
        name = "smartdc-auth-1.0.1.tgz";
        sha1 = "520bbf918313bdf2da372927d33756d46356b87b";
      })
    ];
    buildInputs =
      (self.nativeDeps."smartdc-auth" or []);
    deps = [
      self.by-version."assert-plus"."0.1.2"
      self.by-version."clone"."0.1.5"
      self.by-version."ssh-agent"."0.2.1"
      self.by-version."once"."1.1.1"
      self.by-version."vasync"."1.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "smartdc-auth" ];
  };
  by-spec."sntp"."0.1.x" =
    self.by-version."sntp"."0.1.4";
  by-version."sntp"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-sntp-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.1.4.tgz";
        name = "sntp-0.1.4.tgz";
        sha1 = "5ef481b951a7b29affdf4afd7f26838fc1120f84";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = [
      self.by-version."hoek"."0.7.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-sntp-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
        name = "sntp-0.2.4.tgz";
        sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = [
      self.by-version."hoek"."0.9.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."socket.io"."0.9.14" =
    self.by-version."socket.io"."0.9.14";
  by-version."socket.io"."0.9.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-socket.io-0.9.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.14.tgz";
        name = "socket.io-0.9.14.tgz";
        sha1 = "81af80ebf3ee8f7f6e71b1495db91f8fa53ff667";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io" or []);
    deps = [
      self.by-version."socket.io-client"."0.9.11"
      self.by-version."policyfile"."0.0.4"
      self.by-version."base64id"."0.1.0"
      self.by-version."redis"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  by-spec."socket.io"."0.9.16" =
    self.by-version."socket.io"."0.9.16";
  by-version."socket.io"."0.9.16" = lib.makeOverridable self.buildNodePackage {
    name = "node-socket.io-0.9.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.16.tgz";
        name = "socket.io-0.9.16.tgz";
        sha1 = "3bab0444e49b55fbbc157424dbd41aa375a51a76";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io" or []);
    deps = [
      self.by-version."socket.io-client"."0.9.16"
      self.by-version."policyfile"."0.0.4"
      self.by-version."base64id"."0.1.0"
      self.by-version."redis"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  by-spec."socket.io"."~0.9.13" =
    self.by-version."socket.io"."0.9.16";
  by-spec."socket.io-client"."0.9.11" =
    self.by-version."socket.io-client"."0.9.11";
  by-version."socket.io-client"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-socket.io-client-0.9.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-0.9.11.tgz";
        name = "socket.io-client-0.9.11.tgz";
        sha1 = "94defc1b29e0d8a8fe958c1cf33300f68d8a19c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io-client" or []);
    deps = [
      self.by-version."uglify-js"."1.2.5"
      self.by-version."ws"."0.4.31"
      self.by-version."xmlhttprequest"."1.4.2"
      self.by-version."active-x-obfuscator"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io-client" ];
  };
  by-spec."socket.io-client"."0.9.16" =
    self.by-version."socket.io-client"."0.9.16";
  by-version."socket.io-client"."0.9.16" = lib.makeOverridable self.buildNodePackage {
    name = "node-socket.io-client-0.9.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-0.9.16.tgz";
        name = "socket.io-client-0.9.16.tgz";
        sha1 = "4da7515c5e773041d1b423970415bcc430f35fc6";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io-client" or []);
    deps = [
      self.by-version."uglify-js"."1.2.5"
      self.by-version."ws"."0.4.31"
      self.by-version."xmlhttprequest"."1.4.2"
      self.by-version."active-x-obfuscator"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io-client" ];
  };
  by-spec."sockjs"."*" =
    self.by-version."sockjs"."0.3.8";
  by-version."sockjs"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-sockjs-0.3.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sockjs/-/sockjs-0.3.8.tgz";
        name = "sockjs-0.3.8.tgz";
        sha1 = "c083cb0505db1ea1a949d3bd12d8a1ea385a456c";
      })
    ];
    buildInputs =
      (self.nativeDeps."sockjs" or []);
    deps = [
      self.by-version."node-uuid"."1.3.3"
      self.by-version."faye-websocket"."0.7.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sockjs" ];
  };
  "sockjs" = self.by-version."sockjs"."0.3.8";
  by-spec."sorted-object"."~1.0.0" =
    self.by-version."sorted-object"."1.0.0";
  by-version."sorted-object"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-sorted-object-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sorted-object/-/sorted-object-1.0.0.tgz";
        name = "sorted-object-1.0.0.tgz";
        sha1 = "5d1f4f9c1fb2cd48965967304e212eb44cfb6d05";
      })
    ];
    buildInputs =
      (self.nativeDeps."sorted-object" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sorted-object" ];
  };
  by-spec."source-map"."*" =
    self.by-version."source-map"."0.1.33";
  by-version."source-map"."0.1.33" = lib.makeOverridable self.buildNodePackage {
    name = "node-source-map-0.1.33";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.33.tgz";
        name = "source-map-0.1.33.tgz";
        sha1 = "c659297a73af18c073b0aa2e7cc91e316b5c570c";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = [
      self.by-version."amdefine"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  "source-map" = self.by-version."source-map"."0.1.33";
  by-spec."source-map"."0.1.11" =
    self.by-version."source-map"."0.1.11";
  by-version."source-map"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-source-map-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.11.tgz";
        name = "source-map-0.1.11.tgz";
        sha1 = "2eef2fd65a74c179880ae5ee6975d99ce21eb7b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = [
      self.by-version."amdefine"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  by-spec."source-map"."0.1.x" =
    self.by-version."source-map"."0.1.33";
  by-spec."source-map".">= 0.1.2" =
    self.by-version."source-map"."0.1.33";
  by-spec."source-map"."~ 0.1.8" =
    self.by-version."source-map"."0.1.33";
  by-spec."source-map"."~0.1.30" =
    self.by-version."source-map"."0.1.33";
  by-spec."source-map"."~0.1.31" =
    self.by-version."source-map"."0.1.33";
  by-spec."source-map"."~0.1.33" =
    self.by-version."source-map"."0.1.33";
  by-spec."source-map"."~0.1.7" =
    self.by-version."source-map"."0.1.33";
  by-spec."spdy"."1.7.1" =
    self.by-version."spdy"."1.7.1";
  by-version."spdy"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-spdy-1.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/spdy/-/spdy-1.7.1.tgz";
        name = "spdy-1.7.1.tgz";
        sha1 = "4fde77e602b20c4ecc39ee8619373dd9bf669152";
      })
    ];
    buildInputs =
      (self.nativeDeps."spdy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "spdy" ];
  };
  by-spec."sprintf"."~0.1.2" =
    self.by-version."sprintf"."0.1.3";
  by-version."sprintf"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-sprintf-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sprintf/-/sprintf-0.1.3.tgz";
        name = "sprintf-0.1.3.tgz";
        sha1 = "530fc31405d47422f6edb40f29bdafac599ede11";
      })
    ];
    buildInputs =
      (self.nativeDeps."sprintf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sprintf" ];
  };
  by-spec."sprintf"."~0.1.3" =
    self.by-version."sprintf"."0.1.3";
  by-spec."ssh-agent"."0.2.1" =
    self.by-version."ssh-agent"."0.2.1";
  by-version."ssh-agent"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ssh-agent-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ssh-agent/-/ssh-agent-0.2.1.tgz";
        name = "ssh-agent-0.2.1.tgz";
        sha1 = "3044e9eaeca88a9e6971dd7deb19bdcc20012929";
      })
    ];
    buildInputs =
      (self.nativeDeps."ssh-agent" or []);
    deps = [
      self.by-version."ctype"."0.5.0"
      self.by-version."posix-getopt"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ssh-agent" ];
  };
  by-spec."stack-trace"."0.0.7" =
    self.by-version."stack-trace"."0.0.7";
  by-version."stack-trace"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-stack-trace-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.7.tgz";
        name = "stack-trace-0.0.7.tgz";
        sha1 = "c72e089744fc3659f508cdce3621af5634ec0fff";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-stack-trace-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
        name = "stack-trace-0.0.9.tgz";
        sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  by-spec."stackdriver-statsd-backend"."*" =
    self.by-version."stackdriver-statsd-backend"."0.1.5";
  by-version."stackdriver-statsd-backend"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-stackdriver-statsd-backend-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stackdriver-statsd-backend/-/stackdriver-statsd-backend-0.1.5.tgz";
        name = "stackdriver-statsd-backend-0.1.5.tgz";
        sha1 = "6f0cda0903fd149c6f69d0e50a9e8b4efd85141b";
      })
    ];
    buildInputs =
      (self.nativeDeps."stackdriver-statsd-backend" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stackdriver-statsd-backend" ];
  };
  "stackdriver-statsd-backend" = self.by-version."stackdriver-statsd-backend"."0.1.5";
  by-spec."static-favicon"."1.0.0" =
    self.by-version."static-favicon"."1.0.0";
  by-version."static-favicon"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-static-favicon-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/static-favicon/-/static-favicon-1.0.0.tgz";
        name = "static-favicon-1.0.0.tgz";
        sha1 = "2e58dcfe58957a2d53337ef7a38cf9ad6c13c0d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."static-favicon" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "static-favicon" ];
  };
  by-spec."static-favicon"."1.0.2" =
    self.by-version."static-favicon"."1.0.2";
  by-version."static-favicon"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-static-favicon-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/static-favicon/-/static-favicon-1.0.2.tgz";
        name = "static-favicon-1.0.2.tgz";
        sha1 = "7c15920dda2bf33f414b0e60aebbd65cdd2a1d2f";
      })
    ];
    buildInputs =
      (self.nativeDeps."static-favicon" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "static-favicon" ];
  };
  by-spec."statsd"."*" =
    self.by-version."statsd"."0.7.1";
  by-version."statsd"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "statsd-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd/-/statsd-0.7.1.tgz";
        name = "statsd-0.7.1.tgz";
        sha1 = "b3a5124948ea5558e59eb26536ccfdedb9ba2a70";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd" or []);
    deps = [
      self.by-version."node-syslog"."1.1.7"
      self.by-version."hashring"."1.0.1"
      self.by-version."winser"."0.1.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "statsd" ];
  };
  "statsd" = self.by-version."statsd"."0.7.1";
  by-spec."statsd-librato-backend"."*" =
    self.by-version."statsd-librato-backend"."0.1.2";
  by-version."statsd-librato-backend"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-statsd-librato-backend-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd-librato-backend/-/statsd-librato-backend-0.1.2.tgz";
        name = "statsd-librato-backend-0.1.2.tgz";
        sha1 = "228718018361ef352109bb69e2e6b3af9ab7d12d";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd-librato-backend" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "statsd-librato-backend" ];
  };
  "statsd-librato-backend" = self.by-version."statsd-librato-backend"."0.1.2";
  by-spec."stream-browserify"."~0.1.0" =
    self.by-version."stream-browserify"."0.1.3";
  by-version."stream-browserify"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-stream-browserify-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-browserify/-/stream-browserify-0.1.3.tgz";
        name = "stream-browserify-0.1.3.tgz";
        sha1 = "95cf1b369772e27adaf46352265152689c6c4be9";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-browserify" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
      self.by-version."process"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-browserify" ];
  };
  by-spec."stream-combiner"."~0.0.2" =
    self.by-version."stream-combiner"."0.0.4";
  by-version."stream-combiner"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-stream-combiner-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz";
        name = "stream-combiner-0.0.4.tgz";
        sha1 = "4d5e433c185261dde623ca3f44c586bcf5c4ad14";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-combiner" or []);
    deps = [
      self.by-version."duplexer"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-combiner" ];
  };
  by-spec."stream-counter"."~0.1.0" =
    self.by-version."stream-counter"."0.1.0";
  by-version."stream-counter"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-stream-counter-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-counter/-/stream-counter-0.1.0.tgz";
        name = "stream-counter-0.1.0.tgz";
        sha1 = "a035e429361fb57f361606e17fcd8a8b9677327b";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-counter" or []);
    deps = [
      self.by-version."readable-stream"."1.0.26"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."stream-counter"."~0.2.0" =
    self.by-version."stream-counter"."0.2.0";
  by-version."stream-counter"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-stream-counter-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-counter/-/stream-counter-0.2.0.tgz";
        name = "stream-counter-0.2.0.tgz";
        sha1 = "ded266556319c8b0e222812b9cf3b26fa7d947de";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-counter" or []);
    deps = [
      self.by-version."readable-stream"."1.1.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."stream-splitter-transform"."*" =
    self.by-version."stream-splitter-transform"."0.0.4";
  by-version."stream-splitter-transform"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-stream-splitter-transform-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-splitter-transform/-/stream-splitter-transform-0.0.4.tgz";
        name = "stream-splitter-transform-0.0.4.tgz";
        sha1 = "0de54e94680633a8d703b252b20fa809ed99331c";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-splitter-transform" or []);
    deps = [
      self.by-version."buffertools"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-splitter-transform" ];
  };
  "stream-splitter-transform" = self.by-version."stream-splitter-transform"."0.0.4";
  by-spec."string"."1.6.1" =
    self.by-version."string"."1.6.1";
  by-version."string"."1.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-string-1.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string/-/string-1.6.1.tgz";
        name = "string-1.6.1.tgz";
        sha1 = "eabe0956da7a8291c6de7486f7b35e58d031cd55";
      })
    ];
    buildInputs =
      (self.nativeDeps."string" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "string" ];
  };
  by-spec."string_decoder"."~0.0.0" =
    self.by-version."string_decoder"."0.0.1";
  by-version."string_decoder"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-string_decoder-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.0.1.tgz";
        name = "string_decoder-0.0.1.tgz";
        sha1 = "f5472d0a8d1650ec823752d24e6fd627b39bf141";
      })
    ];
    buildInputs =
      (self.nativeDeps."string_decoder" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "string_decoder" ];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.25";
  by-version."string_decoder"."0.10.25" = lib.makeOverridable self.buildNodePackage {
    name = "node-string_decoder-0.10.25";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.25.tgz";
        name = "string_decoder-0.10.25.tgz";
        sha1 = "668c9da4f8efbdc937a4a6b6bf1cfbec4e9a82e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."string_decoder" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "string_decoder" ];
  };
  by-spec."stringify-object"."~0.1.4" =
    self.by-version."stringify-object"."0.1.8";
  by-version."stringify-object"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-stringify-object-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringify-object/-/stringify-object-0.1.8.tgz";
        name = "stringify-object-0.1.8.tgz";
        sha1 = "463348f38fdcd4fec1c011084c24a59ac653c1ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."stringify-object" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stringify-object" ];
  };
  by-spec."stringify-object"."~0.2.0" =
    self.by-version."stringify-object"."0.2.0";
  by-version."stringify-object"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-stringify-object-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringify-object/-/stringify-object-0.2.0.tgz";
        name = "stringify-object-0.2.0.tgz";
        sha1 = "832996ea55ab2aaa7570cc9bc0d5774adfc2c585";
      })
    ];
    buildInputs =
      (self.nativeDeps."stringify-object" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stringify-object" ];
  };
  by-spec."strip-ansi"."~0.1.0" =
    self.by-version."strip-ansi"."0.1.1";
  by-version."strip-ansi"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.1.1.tgz";
        name = "strip-ansi-0.1.1.tgz";
        sha1 = "39e8a98d044d150660abe4a6808acf70bb7bc991";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strong-data-uri"."~0.1.0" =
    self.by-version."strong-data-uri"."0.1.1";
  by-version."strong-data-uri"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-strong-data-uri-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strong-data-uri/-/strong-data-uri-0.1.1.tgz";
        name = "strong-data-uri-0.1.1.tgz";
        sha1 = "8660241807461d1d2dd247c70563f2f33e66c8ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."strong-data-uri" or []);
    deps = [
      self.by-version."truncate"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "strong-data-uri" ];
  };
  by-spec."stylus"."*" =
    self.by-version."stylus"."0.42.3";
  by-version."stylus"."0.42.3" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.42.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.42.3.tgz";
        name = "stylus-0.42.3.tgz";
        sha1 = "23e8b3e71eb7f60bc4a657de498c8feb9c366c32";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus" or []);
    deps = [
      self.by-version."css-parse"."1.7.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."debug"."0.7.4"
      self.by-version."sax"."0.5.8"
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  "stylus" = self.by-version."stylus"."0.42.3";
  by-spec."stylus"."0.42.2" =
    self.by-version."stylus"."0.42.2";
  by-version."stylus"."0.42.2" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.42.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.42.2.tgz";
        name = "stylus-0.42.2.tgz";
        sha1 = "bed29107803129bed1983efc4c7e33f4fd34fee7";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus" or []);
    deps = [
      self.by-version."css-parse"."1.7.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."debug"."0.7.4"
      self.by-version."sax"."0.5.8"
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  by-spec."subarg"."0.0.1" =
    self.by-version."subarg"."0.0.1";
  by-version."subarg"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-subarg-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/subarg/-/subarg-0.0.1.tgz";
        name = "subarg-0.0.1.tgz";
        sha1 = "3d56b07dacfbc45bbb63f7672b43b63e46368e3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."subarg" or []);
    deps = [
      self.by-version."minimist"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "subarg" ];
  };
  by-spec."sudo-block"."~0.2.0" =
    self.by-version."sudo-block"."0.2.1";
  by-version."sudo-block"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-sudo-block-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sudo-block/-/sudo-block-0.2.1.tgz";
        name = "sudo-block-0.2.1.tgz";
        sha1 = "b394820741b66c0fe06f97b334f0674036837ba5";
      })
    ];
    buildInputs =
      (self.nativeDeps."sudo-block" or []);
    deps = [
      self.by-version."chalk"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sudo-block" ];
  };
  by-spec."sudo-block"."~0.3.0" =
    self.by-version."sudo-block"."0.3.0";
  by-version."sudo-block"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-sudo-block-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sudo-block/-/sudo-block-0.3.0.tgz";
        name = "sudo-block-0.3.0.tgz";
        sha1 = "aec27fbde8763ee32e3e47b8ba3c70584da7eb9c";
      })
    ];
    buildInputs =
      (self.nativeDeps."sudo-block" or []);
    deps = [
      self.by-version."chalk"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sudo-block" ];
  };
  by-spec."superagent"."0.17.0" =
    self.by-version."superagent"."0.17.0";
  by-version."superagent"."0.17.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-superagent-0.17.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.17.0.tgz";
        name = "superagent-0.17.0.tgz";
        sha1 = "aadcd50fbe5a93e71991118d79bf0714d625bba8";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent" or []);
    deps = [
      self.by-version."qs"."0.6.5"
      self.by-version."formidable"."1.0.14"
      self.by-version."mime"."1.2.5"
      self.by-version."emitter-component"."1.0.0"
      self.by-version."methods"."0.0.1"
      self.by-version."cookiejar"."1.3.0"
      self.by-version."debug"."0.7.4"
      self.by-version."reduce-component"."1.0.1"
      self.by-version."extend"."1.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  by-spec."superagent"."~0.13.0" =
    self.by-version."superagent"."0.13.0";
  by-version."superagent"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-superagent-0.13.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.13.0.tgz";
        name = "superagent-0.13.0.tgz";
        sha1 = "ddfbfa5c26f16790f9c5bce42815ccbde2ca36f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent" or []);
    deps = [
      self.by-version."qs"."0.5.2"
      self.by-version."formidable"."1.0.9"
      self.by-version."mime"."1.2.5"
      self.by-version."emitter-component"."0.0.6"
      self.by-version."methods"."0.0.1"
      self.by-version."cookiejar"."1.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  by-spec."superagent"."~0.16.0" =
    self.by-version."superagent"."0.16.0";
  by-version."superagent"."0.16.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-superagent-0.16.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.16.0.tgz";
        name = "superagent-0.16.0.tgz";
        sha1 = "f38df4a476565dffdbaa07764b81a19f0ab38a4e";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent" or []);
    deps = [
      self.by-version."qs"."0.6.5"
      self.by-version."formidable"."1.0.14"
      self.by-version."mime"."1.2.5"
      self.by-version."emitter-component"."1.0.0"
      self.by-version."methods"."0.0.1"
      self.by-version."cookiejar"."1.3.0"
      self.by-version."debug"."0.7.4"
      self.by-version."reduce-component"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  by-spec."supertest"."*" =
    self.by-version."supertest"."0.10.0";
  by-version."supertest"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-supertest-0.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supertest/-/supertest-0.10.0.tgz";
        name = "supertest-0.10.0.tgz";
        sha1 = "5ba821b5f4e9e643292fcf87268dfd2688bdbb58";
      })
    ];
    buildInputs =
      (self.nativeDeps."supertest" or []);
    deps = [
      self.by-version."superagent"."0.17.0"
      self.by-version."methods"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "supertest" ];
  };
  "supertest" = self.by-version."supertest"."0.10.0";
  by-spec."swig"."0.14.x" =
    self.by-version."swig"."0.14.0";
  by-version."swig"."0.14.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-swig-0.14.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/swig/-/swig-0.14.0.tgz";
        name = "swig-0.14.0.tgz";
        sha1 = "544bfb3bd837608873eed6a72c672a28cb1f1b3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."swig" or []);
    deps = [
      self.by-version."underscore"."1.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "swig" ];
  };
  "swig" = self.by-version."swig"."0.14.0";
  by-spec."sylvester".">= 0.0.12" =
    self.by-version."sylvester"."0.0.21";
  by-version."sylvester"."0.0.21" = lib.makeOverridable self.buildNodePackage {
    name = "node-sylvester-0.0.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sylvester/-/sylvester-0.0.21.tgz";
        name = "sylvester-0.0.21.tgz";
        sha1 = "2987b1ce2bd2f38b0dce2a34388884bfa4400ea7";
      })
    ];
    buildInputs =
      (self.nativeDeps."sylvester" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sylvester" ];
  };
  by-spec."sylvester".">= 0.0.8" =
    self.by-version."sylvester"."0.0.21";
  by-spec."syntax-error"."~0.1.0" =
    self.by-version."syntax-error"."0.1.0";
  by-version."syntax-error"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-syntax-error-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/syntax-error/-/syntax-error-0.1.0.tgz";
        name = "syntax-error-0.1.0.tgz";
        sha1 = "8cb515e730fe4f19d3a887035f8630e6494aac65";
      })
    ];
    buildInputs =
      (self.nativeDeps."syntax-error" or []);
    deps = [
      self.by-version."esprima-six"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "syntax-error" ];
  };
  by-spec."tape"."~0.2.2" =
    self.by-version."tape"."0.2.2";
  by-version."tape"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "tape-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tape/-/tape-0.2.2.tgz";
        name = "tape-0.2.2.tgz";
        sha1 = "64ccfa4b7ecf4a0060007e61716d424781671637";
      })
    ];
    buildInputs =
      (self.nativeDeps."tape" or []);
    deps = [
      self.by-version."jsonify"."0.0.0"
      self.by-version."deep-equal"."0.0.0"
      self.by-version."defined"."0.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tape" ];
  };
  by-spec."tar"."*" =
    self.by-version."tar"."0.1.19";
  by-version."tar"."0.1.19" = lib.makeOverridable self.buildNodePackage {
    name = "node-tar-0.1.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.19.tgz";
        name = "tar-0.1.19.tgz";
        sha1 = "fe45941799e660ce1ea52d875d37481b4bf13eac";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
      self.by-version."block-stream"."0.0.7"
      self.by-version."fstream"."0.1.25"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  "tar" = self.by-version."tar"."0.1.19";
  by-spec."tar"."0" =
    self.by-version."tar"."0.1.19";
  by-spec."tar"."0.1.17" =
    self.by-version."tar"."0.1.17";
  by-version."tar"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "node-tar-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.17.tgz";
        name = "tar-0.1.17.tgz";
        sha1 = "408c8a95deb8e78a65b59b1a51a333183a32badc";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = [
      self.by-version."inherits"."1.0.0"
      self.by-version."block-stream"."0.0.7"
      self.by-version."fstream"."0.1.25"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  by-spec."tar"."~0.1.17" =
    self.by-version."tar"."0.1.19";
  by-spec."tar"."~0.1.18" =
    self.by-version."tar"."0.1.19";
  by-spec."tar"."~0.1.19" =
    self.by-version."tar"."0.1.19";
  by-spec."temp"."*" =
    self.by-version."temp"."0.7.0";
  by-version."temp"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-temp-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.7.0.tgz";
        name = "temp-0.7.0.tgz";
        sha1 = "d34bdc8e7f955da2a6a473fea07ad601d68ba78f";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = [
      self.by-version."rimraf"."2.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  "temp" = self.by-version."temp"."0.7.0";
  by-spec."temp"."0.6.0" =
    self.by-version."temp"."0.6.0";
  by-version."temp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-temp-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.6.0.tgz";
        name = "temp-0.6.0.tgz";
        sha1 = "6b13df5cddf370f2e3a606ca40f202c419173f07";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = [
      self.by-version."rimraf"."2.1.4"
      self.by-version."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  by-spec."temp"."~0.5.1" =
    self.by-version."temp"."0.5.1";
  by-version."temp"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-temp-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.5.1.tgz";
        name = "temp-0.5.1.tgz";
        sha1 = "77ab19c79aa7b593cbe4fac2441768cad987b8df";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = [
      self.by-version."rimraf"."2.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  by-spec."temp"."~0.6.0" =
    self.by-version."temp"."0.6.0";
  by-spec."temp"."~0.7.0" =
    self.by-version."temp"."0.7.0";
  by-spec."tempfile"."~0.1.2" =
    self.by-version."tempfile"."0.1.3";
  by-version."tempfile"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-tempfile-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tempfile/-/tempfile-0.1.3.tgz";
        name = "tempfile-0.1.3.tgz";
        sha1 = "7d6b710047339d39f847327a056dadf183103010";
      })
    ];
    buildInputs =
      (self.nativeDeps."tempfile" or []);
    deps = [
      self.by-version."uuid"."1.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tempfile" ];
  };
  by-spec."text-table"."~0.2.0" =
    self.by-version."text-table"."0.2.0";
  by-version."text-table"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-text-table-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz";
        name = "text-table-0.2.0.tgz";
        sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."text-table" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "text-table" ];
  };
  by-spec."throttleit"."~0.0.2" =
    self.by-version."throttleit"."0.0.2";
  by-version."throttleit"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-throttleit-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/throttleit/-/throttleit-0.0.2.tgz";
        name = "throttleit-0.0.2.tgz";
        sha1 = "cfedf88e60c00dd9697b61fdd2a8343a9b680eaf";
      })
    ];
    buildInputs =
      (self.nativeDeps."throttleit" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "throttleit" ];
  };
  by-spec."through"."~2.2.7" =
    self.by-version."through"."2.2.7";
  by-version."through"."2.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-through-2.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through/-/through-2.2.7.tgz";
        name = "through-2.2.7.tgz";
        sha1 = "6e8e21200191d4eb6a99f6f010df46aa1c6eb2bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."through" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "through" ];
  };
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.4";
  by-version."through"."2.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-through-2.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through/-/through-2.3.4.tgz";
        name = "through-2.3.4.tgz";
        sha1 = "495e40e8d8a8eaebc7c275ea88c2b8fc14c56455";
      })
    ];
    buildInputs =
      (self.nativeDeps."through" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "through" ];
  };
  by-spec."through2"."~0.4.0" =
    self.by-version."through2"."0.4.1";
  by-version."through2"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-through2-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through2/-/through2-0.4.1.tgz";
        name = "through2-0.4.1.tgz";
        sha1 = "afd849c65af513c2541a98a7cfbcfec3a15a9686";
      })
    ];
    buildInputs =
      (self.nativeDeps."through2" or []);
    deps = [
      self.by-version."readable-stream"."1.0.26"
      self.by-version."xtend"."2.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."timers-browserify"."~1.0.1" =
    self.by-version."timers-browserify"."1.0.1";
  by-version."timers-browserify"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-timers-browserify-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timers-browserify/-/timers-browserify-1.0.1.tgz";
        name = "timers-browserify-1.0.1.tgz";
        sha1 = "7c93257b543cb1e3003d3663b57d560ee1d27057";
      })
    ];
    buildInputs =
      (self.nativeDeps."timers-browserify" or []);
    deps = [
      self.by-version."process"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "timers-browserify" ];
  };
  by-spec."timespan"."~2.3.0" =
    self.by-version."timespan"."2.3.0";
  by-version."timespan"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-timespan-2.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timespan/-/timespan-2.3.0.tgz";
        name = "timespan-2.3.0.tgz";
        sha1 = "4902ce040bd13d845c8f59b27e9d59bad6f39929";
      })
    ];
    buildInputs =
      (self.nativeDeps."timespan" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "timespan" ];
  };
  by-spec."timezone"."*" =
    self.by-version."timezone"."0.0.30";
  by-version."timezone"."0.0.30" = lib.makeOverridable self.buildNodePackage {
    name = "node-timezone-0.0.30";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timezone/-/timezone-0.0.30.tgz";
        name = "timezone-0.0.30.tgz";
        sha1 = "f83e46d35c017a33a684a4d8bb8fac3debed49bf";
      })
    ];
    buildInputs =
      (self.nativeDeps."timezone" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "timezone" ];
  };
  "timezone" = self.by-version."timezone"."0.0.30";
  by-spec."tinycolor"."0.x" =
    self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-tinycolor-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
        name = "tinycolor-0.0.1.tgz";
        sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
      })
    ];
    buildInputs =
      (self.nativeDeps."tinycolor" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tinycolor" ];
  };
  by-spec."titanium"."3.2.1" =
    self.by-version."titanium"."3.2.1";
  by-version."titanium"."3.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "titanium-3.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/titanium/-/titanium-3.2.1.tgz";
        name = "titanium-3.2.1.tgz";
        sha1 = "b1d432c6c853c22096fb3ed03626e8263b27e39e";
      })
    ];
    buildInputs =
      (self.nativeDeps."titanium" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."colors"."0.6.2"
      self.by-version."fields"."0.1.12"
      self.by-version."humanize"."0.0.9"
      self.by-version."jade"."0.35.0"
      self.by-version."longjohn"."0.2.4"
      self.by-version."moment"."2.4.0"
      self.by-version."node-appc"."0.2.0"
      self.by-version."optimist"."0.6.1"
      self.by-version."request"."2.27.0"
      self.by-version."semver"."2.2.1"
      self.by-version."sprintf"."0.1.3"
      self.by-version."temp"."0.6.0"
      self.by-version."winston"."0.6.2"
      self.by-version."wrench"."1.5.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "titanium" ];
  };
  "titanium" = self.by-version."titanium"."3.2.1";
  by-spec."tmp"."~0.0.20" =
    self.by-version."tmp"."0.0.23";
  by-version."tmp"."0.0.23" = lib.makeOverridable self.buildNodePackage {
    name = "node-tmp-0.0.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tmp/-/tmp-0.0.23.tgz";
        name = "tmp-0.0.23.tgz";
        sha1 = "de874aa5e974a85f0a32cdfdbd74663cb3bd9c74";
      })
    ];
    buildInputs =
      (self.nativeDeps."tmp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tmp" ];
  };
  by-spec."touch"."0.0.2" =
    self.by-version."touch"."0.0.2";
  by-version."touch"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-touch-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/touch/-/touch-0.0.2.tgz";
        name = "touch-0.0.2.tgz";
        sha1 = "a65a777795e5cbbe1299499bdc42281ffb21b5f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."touch" or []);
    deps = [
      self.by-version."nopt"."1.0.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "touch" ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."0.12.1";
  by-version."tough-cookie"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-tough-cookie-0.12.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
        name = "tough-cookie-0.12.1.tgz";
        sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
      })
    ];
    buildInputs =
      (self.nativeDeps."tough-cookie" or []);
    deps = [
      self.by-version."punycode"."1.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
  };
  by-spec."tough-cookie"."~0.9.15" =
    self.by-version."tough-cookie"."0.9.15";
  by-version."tough-cookie"."0.9.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-tough-cookie-0.9.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.9.15.tgz";
        name = "tough-cookie-0.9.15.tgz";
        sha1 = "75617ac347e3659052b0350131885829677399f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."tough-cookie" or []);
    deps = [
      self.by-version."punycode"."1.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
  };
  by-spec."transformers"."2.1.0" =
    self.by-version."transformers"."2.1.0";
  by-version."transformers"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-transformers-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/transformers/-/transformers-2.1.0.tgz";
        name = "transformers-2.1.0.tgz";
        sha1 = "5d23cb35561dd85dc67fb8482309b47d53cce9a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."transformers" or []);
    deps = [
      self.by-version."promise"."2.0.0"
      self.by-version."css"."1.0.8"
      self.by-version."uglify-js"."2.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "transformers" ];
  };
  by-spec."traverse".">=0.3.0 <0.4" =
    self.by-version."traverse"."0.3.9";
  by-version."traverse"."0.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-traverse-0.3.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traverse/-/traverse-0.3.9.tgz";
        name = "traverse-0.3.9.tgz";
        sha1 = "717b8f220cc0bb7b44e40514c22b2e8bbc70d8b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."traverse" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "traverse" ];
  };
  by-spec."truncate"."~1.0.2" =
    self.by-version."truncate"."1.0.2";
  by-version."truncate"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-truncate-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/truncate/-/truncate-1.0.2.tgz";
        name = "truncate-1.0.2.tgz";
        sha1 = "3221c41f6e747f83e8613f5466c8bfb596226a66";
      })
    ];
    buildInputs =
      (self.nativeDeps."truncate" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "truncate" ];
  };
  by-spec."tty-browserify"."~0.0.0" =
    self.by-version."tty-browserify"."0.0.0";
  by-version."tty-browserify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-tty-browserify-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz";
        name = "tty-browserify-0.0.0.tgz";
        sha1 = "a157ba402da24e9bf957f9aa69d524eed42901a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."tty-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tty-browserify" ];
  };
  by-spec."tunnel-agent"."~0.2.0" =
    self.by-version."tunnel-agent"."0.2.0";
  by-version."tunnel-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-tunnel-agent-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.2.0.tgz";
        name = "tunnel-agent-0.2.0.tgz";
        sha1 = "6853c2afb1b2109e45629e492bde35f459ea69e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."tunnel-agent"."~0.3.0" =
    self.by-version."tunnel-agent"."0.3.0";
  by-version."tunnel-agent"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-tunnel-agent-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.3.0.tgz";
        name = "tunnel-agent-0.3.0.tgz";
        sha1 = "ad681b68f5321ad2827c4cfb1b7d5df2cfe942ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."type-detect"."0.1.1" =
    self.by-version."type-detect"."0.1.1";
  by-version."type-detect"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-type-detect-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-detect/-/type-detect-0.1.1.tgz";
        name = "type-detect-0.1.1.tgz";
        sha1 = "0ba5ec2a885640e470ea4e8505971900dac58822";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-detect" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "type-detect" ];
  };
  by-spec."type-is"."1.0.0" =
    self.by-version."type-is"."1.0.0";
  by-version."type-is"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-type-is-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.0.0.tgz";
        name = "type-is-1.0.0.tgz";
        sha1 = "4ff424e97349a1ee1910b4bfc488595ecdc443fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = [
      self.by-version."mime"."1.2.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
  };
  by-spec."typechecker"."~2.0.1" =
    self.by-version."typechecker"."2.0.8";
  by-version."typechecker"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-typechecker-2.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/typechecker/-/typechecker-2.0.8.tgz";
        name = "typechecker-2.0.8.tgz";
        sha1 = "e83da84bb64c584ccb345838576c40b0337db82e";
      })
    ];
    buildInputs =
      (self.nativeDeps."typechecker" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "typechecker" ];
  };
  by-spec."typedarray"."~0.0.5" =
    self.by-version."typedarray"."0.0.5";
  by-version."typedarray"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-typedarray-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/typedarray/-/typedarray-0.0.5.tgz";
        name = "typedarray-0.0.5.tgz";
        sha1 = "c4158fcd96c8ef91ef03cc72584c95e032877664";
      })
    ];
    buildInputs =
      (self.nativeDeps."typedarray" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "typedarray" ];
  };
  by-spec."uglify-js"."1.2.5" =
    self.by-version."uglify-js"."1.2.5";
  by-version."uglify-js"."1.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-1.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.2.5.tgz";
        name = "uglify-js-1.2.5.tgz";
        sha1 = "b542c2c76f78efb34b200b20177634330ff702b6";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."2.4.0" =
    self.by-version."uglify-js"."2.4.0";
  by-version."uglify-js"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.0.tgz";
        name = "uglify-js-2.4.0.tgz";
        sha1 = "a5f2b6b1b817fb34c16a04234328c89ba1e77137";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."source-map"."0.1.33"
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-to-browserify"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."^2.4.0" =
    self.by-version."uglify-js"."2.4.13";
  by-version."uglify-js"."2.4.13" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.13.tgz";
        name = "uglify-js-2.4.13.tgz";
        sha1 = "18debc9e6ecfc20db1a5ea035f839d436a605aba";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."source-map"."0.1.33"
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-to-browserify"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~1.2" =
    self.by-version."uglify-js"."1.2.6";
  by-version."uglify-js"."1.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-1.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.2.6.tgz";
        name = "uglify-js-1.2.6.tgz";
        sha1 = "d354b2d3c1cf10ebc18fa78c11a28bdd9ce1580d";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.2" =
    self.by-version."uglify-js"."2.2.5";
  by-version."uglify-js"."2.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.2.5.tgz";
        name = "uglify-js-2.2.5.tgz";
        sha1 = "a6e02a70d839792b9780488b7b8b184c095c99c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
      self.by-version."source-map"."0.1.33"
      self.by-version."optimist"."0.3.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.2.5" =
    self.by-version."uglify-js"."2.2.5";
  by-spec."uglify-js"."~2.3" =
    self.by-version."uglify-js"."2.3.6";
  by-version."uglify-js"."2.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.3.6.tgz";
        name = "uglify-js-2.3.6.tgz";
        sha1 = "fa0984770b428b7a9b2a8058f46355d14fef211a";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."source-map"."0.1.33"
      self.by-version."optimist"."0.3.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.3.6" =
    self.by-version."uglify-js"."2.3.6";
  by-spec."uglify-js"."~2.4.0" =
    self.by-version."uglify-js"."2.4.13";
  by-spec."uglify-js"."~2.4.12" =
    self.by-version."uglify-js"."2.4.13";
  by-spec."uglify-to-browserify"."~1.0.0" =
    self.by-version."uglify-to-browserify"."1.0.2";
  by-version."uglify-to-browserify"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-uglify-to-browserify-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
        name = "uglify-to-browserify-1.0.2.tgz";
        sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-to-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-to-browserify" ];
  };
  by-spec."uid-number"."0.0.5" =
    self.by-version."uid-number"."0.0.5";
  by-version."uid-number"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-uid-number-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.5.tgz";
        name = "uid-number-0.0.5.tgz";
        sha1 = "5a3db23ef5dbd55b81fce0ec9a2ac6fccdebb81e";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid-number" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uid-number" ];
  };
  by-spec."uid2"."0.0.3" =
    self.by-version."uid2"."0.0.3";
  by-version."uid2"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-uid2-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid2/-/uid2-0.0.3.tgz";
        name = "uid2-0.0.3.tgz";
        sha1 = "483126e11774df2f71b8b639dcd799c376162b82";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uid2" ];
  };
  by-spec."uid2"."~0.0.2" =
    self.by-version."uid2"."0.0.3";
  by-spec."umd"."~2.0.0" =
    self.by-version."umd"."2.0.0";
  by-version."umd"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "umd-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/umd/-/umd-2.0.0.tgz";
        name = "umd-2.0.0.tgz";
        sha1 = "749683b0d514728ae0e1b6195f5774afc0ad4f8f";
      })
    ];
    buildInputs =
      (self.nativeDeps."umd" or []);
    deps = [
      self.by-version."rfile"."1.0.0"
      self.by-version."ruglify"."1.0.0"
      self.by-version."through"."2.3.4"
      self.by-version."uglify-js"."2.4.13"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "umd" ];
  };
  by-spec."underscore"."*" =
    self.by-version."underscore"."1.6.0";
  by-version."underscore"."1.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore-1.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.6.0.tgz";
        name = "underscore-1.6.0.tgz";
        sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  "underscore" = self.by-version."underscore"."1.6.0";
  by-spec."underscore"."1.4.x" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        name = "underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore".">=1.1.7" =
    self.by-version."underscore"."1.6.0";
  by-spec."underscore".">=1.3.1" =
    self.by-version."underscore"."1.6.0";
  by-spec."underscore".">=1.5.0" =
    self.by-version."underscore"."1.6.0";
  by-spec."underscore".">=1.5.x" =
    self.by-version."underscore"."1.6.0";
  by-spec."underscore"."~1.4" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.4.3" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.4.4" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.5" =
    self.by-version."underscore"."1.5.2";
  by-version."underscore"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore-1.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        name = "underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore"."~1.5.2" =
    self.by-version."underscore"."1.5.2";
  by-spec."underscore.string"."~2.2.1" =
    self.by-version."underscore.string"."2.2.1";
  by-version."underscore.string"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore.string-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.2.1.tgz";
        name = "underscore.string-2.2.1.tgz";
        sha1 = "d7c0fa2af5d5a1a67f4253daee98132e733f0f19";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  by-spec."underscore.string"."~2.3.1" =
    self.by-version."underscore.string"."2.3.3";
  by-version."underscore.string"."2.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore.string-2.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz";
        name = "underscore.string-2.3.3.tgz";
        sha1 = "71c08bf6b428b1133f37e78fa3a21c82f7329b0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  by-spec."underscore.string"."~2.3.3" =
    self.by-version."underscore.string"."2.3.3";
  by-spec."unfunk-diff"."~0.0.1" =
    self.by-version."unfunk-diff"."0.0.2";
  by-version."unfunk-diff"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-unfunk-diff-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/unfunk-diff/-/unfunk-diff-0.0.2.tgz";
        name = "unfunk-diff-0.0.2.tgz";
        sha1 = "8560d6b5cb3dcb1ed4d541e7fe59cea514697578";
      })
    ];
    buildInputs =
      (self.nativeDeps."unfunk-diff" or []);
    deps = [
      self.by-version."diff"."1.0.8"
      self.by-version."jsesc"."0.4.3"
      self.by-version."ministyle"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "unfunk-diff" ];
  };
  by-spec."ungit"."*" =
    self.by-version."ungit"."0.7.2";
  by-version."ungit"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "ungit-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ungit/-/ungit-0.7.2.tgz";
        name = "ungit-0.7.2.tgz";
        sha1 = "fc4d6943c407ca4ed08b7c48841419050e3ce52a";
      })
    ];
    buildInputs =
      (self.nativeDeps."ungit" or []);
    deps = [
      self.by-version."express"."3.4.8"
      self.by-version."superagent"."0.16.0"
      self.by-version."lodash"."2.4.1"
      self.by-version."temp"."0.7.0"
      self.by-version."socket.io"."0.9.16"
      self.by-version."moment"."2.5.1"
      self.by-version."async"."0.2.10"
      self.by-version."rc"."0.3.4"
      self.by-version."uuid"."1.4.1"
      self.by-version."winston"."0.7.3"
      self.by-version."passport"."0.2.0"
      self.by-version."passport-local"."0.1.6"
      self.by-version."semver"."2.2.1"
      self.by-version."forever-monitor"."1.1.0"
      self.by-version."open"."0.0.4"
      self.by-version."optimist"."0.6.1"
      self.by-version."crossroads"."0.12.0"
      self.by-version."signals"."1.0.0"
      self.by-version."hasher"."1.2.0"
      self.by-version."blueimp-md5"."1.1.0"
      self.by-version."color"."0.5.0"
      self.by-version."keen.io"."0.0.4"
      self.by-version."getmac"."1.0.6"
      self.by-version."deep-extend"."0.2.8"
      self.by-version."raven"."0.6.2"
      self.by-version."knockout"."3.0.0"
      self.by-version."npm-registry-client"."0.4.5"
      self.by-version."npmconf"."0.1.13"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."less"."1.7.0"
      self.by-version."browserify"."3.32.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ungit" ];
  };
  "ungit" = self.by-version."ungit"."0.7.2";
  by-spec."update-notifier"."~0.1.3" =
    self.by-version."update-notifier"."0.1.8";
  by-version."update-notifier"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-update-notifier-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.1.8.tgz";
        name = "update-notifier-0.1.8.tgz";
        sha1 = "ebf5c698375f5c232031a419634fab66cc0322a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier" or []);
    deps = [
      self.by-version."request"."2.27.0"
      self.by-version."configstore"."0.2.3"
      self.by-version."semver"."2.1.0"
      self.by-version."chalk"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  by-spec."update-notifier"."~0.1.7" =
    self.by-version."update-notifier"."0.1.8";
  by-spec."url"."~0.7.9" =
    self.by-version."url"."0.7.9";
  by-version."url"."0.7.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-url-0.7.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/url/-/url-0.7.9.tgz";
        name = "url-0.7.9.tgz";
        sha1 = "1959b1a8b361fc017b59513a7c7fa9827f5e4ed0";
      })
    ];
    buildInputs =
      (self.nativeDeps."url" or []);
    deps = [
      self.by-version."querystring"."0.1.0"
      self.by-version."punycode"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "url" ];
  };
  by-spec."useragent"."~2.0.4" =
    self.by-version."useragent"."2.0.8";
  by-version."useragent"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-useragent-2.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/useragent/-/useragent-2.0.8.tgz";
        name = "useragent-2.0.8.tgz";
        sha1 = "32caa86d3f404e92d7d4183831dd103ebc1a3125";
      })
    ];
    buildInputs =
      (self.nativeDeps."useragent" or []);
    deps = [
      self.by-version."lru-cache"."2.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "useragent" ];
  };
  by-spec."userhome"."~0.1.0" =
    self.by-version."userhome"."0.1.0";
  by-version."userhome"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-userhome-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/userhome/-/userhome-0.1.0.tgz";
        name = "userhome-0.1.0.tgz";
        sha1 = "bd2067d90b3f7ac6c026d87612c579d88fb89f86";
      })
    ];
    buildInputs =
      (self.nativeDeps."userhome" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "userhome" ];
  };
  by-spec."util"."0.10.2" =
    self.by-version."util"."0.10.2";
  by-version."util"."0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-util-0.10.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util/-/util-0.10.2.tgz";
        name = "util-0.10.2.tgz";
        sha1 = "8180519cf690fb88bc56480fe55087531f446304";
      })
    ];
    buildInputs =
      (self.nativeDeps."util" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "util" ];
  };
  by-spec."util"."0.4.9" =
    self.by-version."util"."0.4.9";
  by-version."util"."0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-util-0.4.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util/-/util-0.4.9.tgz";
        name = "util-0.4.9.tgz";
        sha1 = "d95d5830d2328ec17dee3c80bfc50c33562b75a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."util" or []);
    deps = [
      self.by-version."events.node"."0.4.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "util" ];
  };
  by-spec."util"."~0.10.1" =
    self.by-version."util"."0.10.3";
  by-version."util"."0.10.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-util-0.10.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util/-/util-0.10.3.tgz";
        name = "util-0.10.3.tgz";
        sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."util" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "util" ];
  };
  by-spec."util-extend"."^1.0.1" =
    self.by-version."util-extend"."1.0.1";
  by-version."util-extend"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-util-extend-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util-extend/-/util-extend-1.0.1.tgz";
        name = "util-extend-1.0.1.tgz";
        sha1 = "bb703b79480293ddcdcfb3c6a9fea20f483415bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."util-extend" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "util-extend" ];
  };
  by-spec."utile"."0.1.x" =
    self.by-version."utile"."0.1.7";
  by-version."utile"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-utile-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.1.7.tgz";
        name = "utile-0.1.7.tgz";
        sha1 = "55db180d54475339fd6dd9e2d14a4c0b52624b69";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile" or []);
    deps = [
      self.by-version."async"."0.1.22"
      self.by-version."deep-equal"."0.2.1"
      self.by-version."i"."0.3.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."ncp"."0.2.7"
      self.by-version."rimraf"."1.0.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  by-spec."utile"."0.2.1" =
    self.by-version."utile"."0.2.1";
  by-version."utile"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-utile-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.2.1.tgz";
        name = "utile-0.2.1.tgz";
        sha1 = "930c88e99098d6220834c356cbd9a770522d90d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."deep-equal"."0.2.1"
      self.by-version."i"."0.3.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."ncp"."0.4.2"
      self.by-version."rimraf"."2.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  by-spec."utile"."0.2.x" =
    self.by-version."utile"."0.2.1";
  by-spec."utile"."~0.1.7" =
    self.by-version."utile"."0.1.7";
  by-spec."utile"."~0.2.1" =
    self.by-version."utile"."0.2.1";
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-utils-merge-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
        name = "utils-merge-1.0.0.tgz";
        sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
      })
    ];
    buildInputs =
      (self.nativeDeps."utils-merge" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utils-merge" ];
  };
  by-spec."uuid"."1.4.1" =
    self.by-version."uuid"."1.4.1";
  by-version."uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uuid/-/uuid-1.4.1.tgz";
        name = "uuid-1.4.1.tgz";
        sha1 = "a337828580d426e375b8ee11bd2bf901a596e0b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."uuid" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uuid" ];
  };
  by-spec."uuid"."~1.4.0" =
    self.by-version."uuid"."1.4.1";
  by-spec."uuid"."~1.4.1" =
    self.by-version."uuid"."1.4.1";
  by-spec."validator"."0.4.x" =
    self.by-version."validator"."0.4.28";
  by-version."validator"."0.4.28" = lib.makeOverridable self.buildNodePackage {
    name = "node-validator-0.4.28";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/validator/-/validator-0.4.28.tgz";
        name = "validator-0.4.28.tgz";
        sha1 = "311d439ae6cf3fbe6f85da6ebaccd0c7007986f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."validator" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "validator" ];
  };
  by-spec."vargs"."~0.1.0" =
    self.by-version."vargs"."0.1.0";
  by-version."vargs"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-vargs-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vargs/-/vargs-0.1.0.tgz";
        name = "vargs-0.1.0.tgz";
        sha1 = "6b6184da6520cc3204ce1b407cac26d92609ebff";
      })
    ];
    buildInputs =
      (self.nativeDeps."vargs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vargs" ];
  };
  by-spec."vasync"."1.3.3" =
    self.by-version."vasync"."1.3.3";
  by-version."vasync"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-vasync-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vasync/-/vasync-1.3.3.tgz";
        name = "vasync-1.3.3.tgz";
        sha1 = "84917680717020b67e043902e63bc143174c8728";
      })
    ];
    buildInputs =
      (self.nativeDeps."vasync" or []);
    deps = [
      self.by-version."jsprim"."0.3.0"
      self.by-version."verror"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vasync" ];
  };
  by-spec."verror"."1.1.0" =
    self.by-version."verror"."1.1.0";
  by-version."verror"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-verror-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.1.0.tgz";
        name = "verror-1.1.0.tgz";
        sha1 = "2a4b4eb14a207051e75a6f94ee51315bf173a1b0";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror" or []);
    deps = [
      self.by-version."extsprintf"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  by-spec."verror"."1.3.3" =
    self.by-version."verror"."1.3.3";
  by-version."verror"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-verror-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.3.3.tgz";
        name = "verror-1.3.3.tgz";
        sha1 = "8a6a4ac3a8c774b6f687fece49bdffd78552e2cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror" or []);
    deps = [
      self.by-version."extsprintf"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  by-spec."verror"."1.3.6" =
    self.by-version."verror"."1.3.6";
  by-version."verror"."1.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-verror-1.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
        name = "verror-1.3.6.tgz";
        sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror" or []);
    deps = [
      self.by-version."extsprintf"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  by-spec."vhost"."1.0.0" =
    self.by-version."vhost"."1.0.0";
  by-version."vhost"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-vhost-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vhost/-/vhost-1.0.0.tgz";
        name = "vhost-1.0.0.tgz";
        sha1 = "654513f289a4f898aab745bbd633e40180c9c4c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."vhost" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vhost" ];
  };
  by-spec."view-helpers"."*" =
    self.by-version."view-helpers"."0.1.4";
  by-version."view-helpers"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-view-helpers-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/view-helpers/-/view-helpers-0.1.4.tgz";
        name = "view-helpers-0.1.4.tgz";
        sha1 = "aeadfbcc2c21343d2b0ef4d4f20f805764286cee";
      })
    ];
    buildInputs =
      (self.nativeDeps."view-helpers" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "view-helpers" ];
  };
  "view-helpers" = self.by-version."view-helpers"."0.1.4";
  by-spec."vm-browserify"."~0.0.1" =
    self.by-version."vm-browserify"."0.0.4";
  by-version."vm-browserify"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-vm-browserify-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vm-browserify/-/vm-browserify-0.0.4.tgz";
        name = "vm-browserify-0.0.4.tgz";
        sha1 = "5d7ea45bbef9e4a6ff65f95438e0a87c357d5a73";
      })
    ];
    buildInputs =
      (self.nativeDeps."vm-browserify" or []);
    deps = [
      self.by-version."indexof"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vm-browserify" ];
  };
  by-spec."vows".">=0.5.13" =
    self.by-version."vows"."0.7.0";
  by-version."vows"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "vows-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vows/-/vows-0.7.0.tgz";
        name = "vows-0.7.0.tgz";
        sha1 = "dd0065f110ba0c0a6d63e844851c3208176d5867";
      })
    ];
    buildInputs =
      (self.nativeDeps."vows" or []);
    deps = [
      self.by-version."eyes"."0.1.8"
      self.by-version."diff"."1.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vows" ];
  };
  by-spec."walk"."*" =
    self.by-version."walk"."2.3.1";
  by-version."walk"."2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-walk-2.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.3.1.tgz";
        name = "walk-2.3.1.tgz";
        sha1 = "015e0ef7a636ac43185661a9673d459572a44050";
      })
    ];
    buildInputs =
      (self.nativeDeps."walk" or []);
    deps = [
      self.by-version."forEachAsync"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
  };
  "walk" = self.by-version."walk"."2.3.1";
  by-spec."walk"."~2.2.1" =
    self.by-version."walk"."2.2.1";
  by-version."walk"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-walk-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.2.1.tgz";
        name = "walk-2.2.1.tgz";
        sha1 = "5ada1f8e49e47d4b7445d8be7a2e1e631ab43016";
      })
    ];
    buildInputs =
      (self.nativeDeps."walk" or []);
    deps = [
      self.by-version."forEachAsync"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
  };
  by-spec."watch"."0.5.x" =
    self.by-version."watch"."0.5.1";
  by-version."watch"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-watch-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.5.1.tgz";
        name = "watch-0.5.1.tgz";
        sha1 = "50ea3a056358c98073e0bca59956de4afd20b213";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "watch" ];
  };
  by-spec."watch"."~0.8.0" =
    self.by-version."watch"."0.8.0";
  by-version."watch"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-watch-0.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.8.0.tgz";
        name = "watch-0.8.0.tgz";
        sha1 = "1bb0eea53defe6e621e9c8c63c0358007ecbdbcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "watch" ];
  };
  by-spec."wd"."~0.2.12" =
    self.by-version."wd"."0.2.13";
  by-version."wd"."0.2.13" = lib.makeOverridable self.buildNodePackage {
    name = "wd-0.2.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wd/-/wd-0.2.13.tgz";
        name = "wd-0.2.13.tgz";
        sha1 = "12dd4a479d9c676a17a290b63da2acf41182e44f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wd" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."vargs"."0.1.0"
      self.by-version."q"."1.0.1"
      self.by-version."request"."2.33.0"
      self.by-version."archiver"."0.5.2"
      self.by-version."lodash"."2.4.1"
      self.by-version."underscore.string"."2.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wd" ];
  };
  by-spec."weak-map"."^1.0.4" =
    self.by-version."weak-map"."1.0.4";
  by-version."weak-map"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-weak-map-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/weak-map/-/weak-map-1.0.4.tgz";
        name = "weak-map-1.0.4.tgz";
        sha1 = "1acddee2cc90eb30950860b7415c79cefc5f07c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."weak-map" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "weak-map" ];
  };
  by-spec."webdrvr"."*" =
    self.by-version."webdrvr"."2.40.0";
  by-version."webdrvr"."2.40.0" = lib.makeOverridable self.buildNodePackage {
    name = "webdrvr-2.40.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/webdrvr/-/webdrvr-2.40.0.tgz";
        name = "webdrvr-2.40.0.tgz";
        sha1 = "689f5d3fad5008ffc7b273d607eea9dd7d26ca42";
      })
    ];
    buildInputs =
      (self.nativeDeps."webdrvr" or []);
    deps = [
      self.by-version."adm-zip"."0.4.4"
      self.by-version."kew"."0.1.7"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."npmconf"."0.1.13"
      self.by-version."phantomjs"."1.9.7-1"
      self.by-version."tmp"."0.0.23"
      self.by-version."follow-redirects"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "webdrvr" ];
  };
  "webdrvr" = self.by-version."webdrvr"."2.40.0";
  by-spec."websocket-driver".">=0.3.0" =
    self.by-version."websocket-driver"."0.3.2";
  by-version."websocket-driver"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-websocket-driver-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.3.2.tgz";
        name = "websocket-driver-0.3.2.tgz";
        sha1 = "f177ef6611390e2401ae47f35e8386dda987daca";
      })
    ];
    buildInputs =
      (self.nativeDeps."websocket-driver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "websocket-driver" ];
  };
  by-spec."websocket-driver".">=0.3.1" =
    self.by-version."websocket-driver"."0.3.2";
  by-spec."when"."~2.8.0" =
    self.by-version."when"."2.8.0";
  by-version."when"."2.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-when-2.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/when/-/when-2.8.0.tgz";
        name = "when-2.8.0.tgz";
        sha1 = "a15eda8b6998ce74c6f4e220dbda18ce2ab3b026";
      })
    ];
    buildInputs =
      (self.nativeDeps."when" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "when" ];
  };
  by-spec."which"."1" =
    self.by-version."which"."1.0.5";
  by-version."which"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.5.tgz";
        name = "which-1.0.5.tgz";
        sha1 = "5630d6819dda692f1464462e7956cb42c0842739";
      })
    ];
    buildInputs =
      (self.nativeDeps."which" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "which" ];
  };
  by-spec."which"."1.0.x" =
    self.by-version."which"."1.0.5";
  by-spec."which"."~1.0.5" =
    self.by-version."which"."1.0.5";
  by-spec."winser"."=0.1.6" =
    self.by-version."winser"."0.1.6";
  by-version."winser"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "winser-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winser/-/winser-0.1.6.tgz";
        name = "winser-0.1.6.tgz";
        sha1 = "08663dc32878a12bbce162d840da5097b48466c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."winser" or []);
    deps = [
      self.by-version."sequence"."2.2.1"
      self.by-version."commander"."1.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winser" ];
  };
  by-spec."winston"."*" =
    self.by-version."winston"."0.7.3";
  by-version."winston"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-winston-0.7.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.3.tgz";
        name = "winston-0.7.3.tgz";
        sha1 = "7ae313ba73fcdc2ecb4aa2f9cd446e8298677266";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."colors"."0.6.2"
      self.by-version."cycle"."1.0.3"
      self.by-version."eyes"."0.1.8"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."request"."2.16.6"
      self.by-version."stack-trace"."0.0.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  "winston" = self.by-version."winston"."0.7.3";
  by-spec."winston"."0.6.2" =
    self.by-version."winston"."0.6.2";
  by-version."winston"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-winston-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.6.2.tgz";
        name = "winston-0.6.2.tgz";
        sha1 = "4144fe2586cdc19a612bf8c035590132c9064bd2";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = [
      self.by-version."async"."0.1.22"
      self.by-version."colors"."0.6.2"
      self.by-version."cycle"."1.0.3"
      self.by-version."eyes"."0.1.8"
      self.by-version."pkginfo"."0.2.3"
      self.by-version."request"."2.9.203"
      self.by-version."stack-trace"."0.0.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."0.6.x" =
    self.by-version."winston"."0.6.2";
  by-spec."winston"."0.7.2" =
    self.by-version."winston"."0.7.2";
  by-version."winston"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-winston-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.2.tgz";
        name = "winston-0.7.2.tgz";
        sha1 = "2570ae1aa1d8a9401e8d5a88362e1cf936550ceb";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."colors"."0.6.2"
      self.by-version."cycle"."1.0.3"
      self.by-version."eyes"."0.1.8"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."request"."2.16.6"
      self.by-version."stack-trace"."0.0.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."~0.7.2" =
    self.by-version."winston"."0.7.3";
  by-spec."wiredep"."~1.0.0" =
    self.by-version."wiredep"."1.0.0";
  by-version."wiredep"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-wiredep-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wiredep/-/wiredep-1.0.0.tgz";
        name = "wiredep-1.0.0.tgz";
        sha1 = "2e570465657b97e7494abf62978a3e52fc37ac52";
      })
    ];
    buildInputs =
      (self.nativeDeps."wiredep" or []);
    deps = [
      self.by-version."lodash"."1.3.1"
      self.by-version."chalk"."0.1.1"
      self.by-version."glob"."3.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wiredep" ];
  };
  by-spec."with"."~1.1.0" =
    self.by-version."with"."1.1.1";
  by-version."with"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-with-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-1.1.1.tgz";
        name = "with-1.1.1.tgz";
        sha1 = "66bd6664deb318b2482dd0424ccdebe822434ac0";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = [
      self.by-version."uglify-js"."2.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  by-spec."with"."~2.0.0" =
    self.by-version."with"."2.0.0";
  by-version."with"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-with-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-2.0.0.tgz";
        name = "with-2.0.0.tgz";
        sha1 = "ec01ff021db9df05639047147ede012f5e6d0afd";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = [
      self.by-version."uglify-js"."2.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  by-spec."with"."~3.0.0" =
    self.by-version."with"."3.0.0";
  by-version."with"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-with-3.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-3.0.0.tgz";
        name = "with-3.0.0.tgz";
        sha1 = "38f5d5859bb974c9dad8812372b51dae4b9594cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = [
      self.by-version."uglify-js"."2.4.13"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  by-spec."wordwrap"."0.0.x" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-wordwrap-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        name = "wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  by-spec."wordwrap".">=0.0.1 <0.1.0" =
    self.by-version."wordwrap"."0.0.2";
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-spec."wrench"."~1.4.3" =
    self.by-version."wrench"."1.4.4";
  by-version."wrench"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-wrench-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wrench/-/wrench-1.4.4.tgz";
        name = "wrench-1.4.4.tgz";
        sha1 = "7f523efdb71b0100e77dce834c06523cbe3d54e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."wrench" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wrench" ];
  };
  by-spec."wrench"."~1.5.0" =
    self.by-version."wrench"."1.5.8";
  by-version."wrench"."1.5.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-wrench-1.5.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wrench/-/wrench-1.5.8.tgz";
        name = "wrench-1.5.8.tgz";
        sha1 = "7a31c97f7869246d76c5cf2f5c977a1c4c8e5ab5";
      })
    ];
    buildInputs =
      (self.nativeDeps."wrench" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wrench" ];
  };
  by-spec."wrench"."~1.5.4" =
    self.by-version."wrench"."1.5.8";
  by-spec."ws"."0.4.x" =
    self.by-version."ws"."0.4.31";
  by-version."ws"."0.4.31" = lib.makeOverridable self.buildNodePackage {
    name = "ws-0.4.31";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ws/-/ws-0.4.31.tgz";
        name = "ws-0.4.31.tgz";
        sha1 = "5a4849e7a9ccd1ed5a81aeb4847c9fedf3122927";
      })
    ];
    buildInputs =
      (self.nativeDeps."ws" or []);
    deps = [
      self.by-version."commander"."0.6.1"
      self.by-version."nan"."0.3.2"
      self.by-version."tinycolor"."0.0.1"
      self.by-version."options"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ws" ];
  };
  by-spec."ws"."~0.4.31" =
    self.by-version."ws"."0.4.31";
  by-spec."wu"."*" =
    self.by-version."wu"."0.1.8";
  by-version."wu"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-wu-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wu/-/wu-0.1.8.tgz";
        name = "wu-0.1.8.tgz";
        sha1 = "619bcdf64974a487894a25755ae095c5208b4a22";
      })
    ];
    buildInputs =
      (self.nativeDeps."wu" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wu" ];
  };
  "wu" = self.by-version."wu"."0.1.8";
  by-spec."x509"."*" =
    self.by-version."x509"."0.0.7";
  by-version."x509"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-x509-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/x509/-/x509-0.0.7.tgz";
        name = "x509-0.0.7.tgz";
        sha1 = "198a57a9691649b030a383e0e5f89e635d6e99e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."x509" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "x509" ];
  };
  "x509" = self.by-version."x509"."0.0.7";
  by-spec."xml2js"."0.2.4" =
    self.by-version."xml2js"."0.2.4";
  by-version."xml2js"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-xml2js-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.4.tgz";
        name = "xml2js-0.2.4.tgz";
        sha1 = "9a5b577fa1e6cdf8923d5e1372f7a3188436e44d";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = [
      self.by-version."sax"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js"."0.2.x" =
    self.by-version."xml2js"."0.2.8";
  by-version."xml2js"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-xml2js-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.8.tgz";
        name = "xml2js-0.2.8.tgz";
        sha1 = "9b81690931631ff09d1957549faf54f4f980b3c2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = [
      self.by-version."sax"."0.5.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js".">= 0.0.1" =
    self.by-version."xml2js"."0.4.1";
  by-version."xml2js"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-xml2js-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.4.1.tgz";
        name = "xml2js-0.4.1.tgz";
        sha1 = "dee0630173a5c6ea62797f848615fd55c6bc6992";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = [
      self.by-version."sax"."0.5.8"
      self.by-version."xmlbuilder"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js".">=0.1.7" =
    self.by-version."xml2js"."0.4.1";
  by-spec."xmlbuilder"."0.4.2" =
    self.by-version."xmlbuilder"."0.4.2";
  by-version."xmlbuilder"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmlbuilder-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.2.tgz";
        name = "xmlbuilder-0.4.2.tgz";
        sha1 = "1776d65f3fdbad470a08d8604cdeb1c4e540ff83";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  by-spec."xmlbuilder".">=0.4.2" =
    self.by-version."xmlbuilder"."2.1.0";
  by-version."xmlbuilder"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmlbuilder-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-2.1.0.tgz";
        name = "xmlbuilder-2.1.0.tgz";
        sha1 = "6ddae31683b6df12100b29fc8a0d4f46349abbed";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder" or []);
    deps = [
      self.by-version."underscore"."1.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  by-spec."xmldom"."~0.1.16" =
    self.by-version."xmldom"."0.1.19";
  by-version."xmldom"."0.1.19" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmldom-0.1.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmldom/-/xmldom-0.1.19.tgz";
        name = "xmldom-0.1.19.tgz";
        sha1 = "631fc07776efd84118bf25171b37ed4d075a0abc";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmldom" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmldom" ];
  };
  by-spec."xmlhttprequest"."1.4.2" =
    self.by-version."xmlhttprequest"."1.4.2";
  by-version."xmlhttprequest"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmlhttprequest-1.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlhttprequest/-/xmlhttprequest-1.4.2.tgz";
        name = "xmlhttprequest-1.4.2.tgz";
        sha1 = "01453a1d9bed1e8f172f6495bbf4c8c426321500";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlhttprequest" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlhttprequest" ];
  };
  by-spec."xoauth2"."~0.1" =
    self.by-version."xoauth2"."0.1.8";
  by-version."xoauth2"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-xoauth2-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xoauth2/-/xoauth2-0.1.8.tgz";
        name = "xoauth2-0.1.8.tgz";
        sha1 = "b916ff10ecfb54320f16f24a3e975120653ab0d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xoauth2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xoauth2" ];
  };
  by-spec."xtend"."~2.1.1" =
    self.by-version."xtend"."2.1.2";
  by-version."xtend"."2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-xtend-2.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-2.1.2.tgz";
        name = "xtend-2.1.2.tgz";
        sha1 = "6efecc2a4dad8e6962c4901b337ce7ba87b5d28b";
      })
    ];
    buildInputs =
      (self.nativeDeps."xtend" or []);
    deps = [
      self.by-version."object-keys"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xtend" ];
  };
  by-spec."yargs"."~1.1.2" =
    self.by-version."yargs"."1.1.3";
  by-version."yargs"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-yargs-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yargs/-/yargs-1.1.3.tgz";
        name = "yargs-1.1.3.tgz";
        sha1 = "c44ed2bb9c86d55b557f2179fea7c7013fe4c42a";
      })
    ];
    buildInputs =
      (self.nativeDeps."yargs" or []);
    deps = [
      self.by-version."minimist"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yargs" ];
  };
  by-spec."yeoman-generator"."~0.14.0" =
    self.by-version."yeoman-generator"."0.14.2";
  by-version."yeoman-generator"."0.14.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-yeoman-generator-0.14.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.14.2.tgz";
        name = "yeoman-generator-0.14.2.tgz";
        sha1 = "6d3e306d1118c83c25ac12a9d3dcb7870aa53397";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator" or []);
    deps = [
      self.by-version."cheerio"."0.12.4"
      self.by-version."rimraf"."2.2.6"
      self.by-version."diff"."1.0.8"
      self.by-version."mime"."1.2.11"
      self.by-version."underscore.string"."2.3.3"
      self.by-version."lodash"."2.2.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."glob"."3.2.9"
      self.by-version."debug"."0.7.4"
      self.by-version."isbinaryfile"."0.1.9"
      self.by-version."dargs"."0.1.0"
      self.by-version."async"."0.2.10"
      self.by-version."inquirer"."0.3.5"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."shelljs"."0.2.6"
      self.by-version."findup-sync"."0.1.3"
      self.by-version."chalk"."0.3.0"
      self.by-version."text-table"."0.2.0"
      self.by-version."download"."0.1.10"
      self.by-version."request"."2.27.0"
      self.by-version."file-utils"."0.1.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  by-spec."yeoman-generator"."~0.16.0" =
    self.by-version."yeoman-generator"."0.16.0";
  by-version."yeoman-generator"."0.16.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-yeoman-generator-0.16.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.16.0.tgz";
        name = "yeoman-generator-0.16.0.tgz";
        sha1 = "0d1b655ea31660ab66837af1e686b795eae57c59";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator" or []);
    deps = [
      self.by-version."cheerio"."0.13.1"
      self.by-version."rimraf"."2.2.6"
      self.by-version."diff"."1.0.8"
      self.by-version."mime"."1.2.11"
      self.by-version."underscore.string"."2.3.3"
      self.by-version."lodash"."2.4.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."glob"."3.2.9"
      self.by-version."debug"."0.7.4"
      self.by-version."isbinaryfile"."2.0.1"
      self.by-version."dargs"."0.1.0"
      self.by-version."async"."0.2.10"
      self.by-version."inquirer"."0.4.1"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."shelljs"."0.2.6"
      self.by-version."findup-sync"."0.1.3"
      self.by-version."chalk"."0.4.0"
      self.by-version."text-table"."0.2.0"
      self.by-version."download"."0.1.10"
      self.by-version."request"."2.30.0"
      self.by-version."file-utils"."0.1.5"
      self.by-version."class-extend"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  by-spec."yo"."*" =
    self.by-version."yo"."1.1.2";
  by-version."yo"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "yo-1.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yo/-/yo-1.1.2.tgz";
        name = "yo-1.1.2.tgz";
        sha1 = "a0d4da72e83fa0e0dbfe1d0ba258881b240ab854";
      })
    ];
    buildInputs =
      (self.nativeDeps."yo" or []);
    deps = [
      self.by-version."yeoman-generator"."0.16.0"
      self.by-version."nopt"."2.1.2"
      self.by-version."lodash"."2.4.1"
      self.by-version."update-notifier"."0.1.8"
      self.by-version."insight"."0.3.1"
      self.by-version."sudo-block"."0.3.0"
      self.by-version."async"."0.2.10"
      self.by-version."open"."0.0.4"
      self.by-version."chalk"."0.4.0"
      self.by-version."findup"."0.1.4"
      self.by-version."shelljs"."0.2.6"
    ];
    peerDependencies = [
      self.by-version."grunt-cli"."0.1.13"
      self.by-version."bower"."1.3.1"
    ];
    passthru.names = [ "yo" ];
  };
  "yo" = self.by-version."yo"."1.1.2";
  by-spec."yo".">=1.0.0" =
    self.by-version."yo"."1.1.2";
  by-spec."yo".">=1.0.0-rc.1.1" =
    self.by-version."yo"."1.1.2";
  by-spec."zeparser"."0.0.5" =
    self.by-version."zeparser"."0.0.5";
  by-version."zeparser"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-zeparser-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zeparser/-/zeparser-0.0.5.tgz";
        name = "zeparser-0.0.5.tgz";
        sha1 = "03726561bc268f2e5444f54c665b7fd4a8c029e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."zeparser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "zeparser" ];
  };
  by-spec."zip-stream"."~0.1.0" =
    self.by-version."zip-stream"."0.1.4";
  by-version."zip-stream"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-zip-stream-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zip-stream/-/zip-stream-0.1.4.tgz";
        name = "zip-stream-0.1.4.tgz";
        sha1 = "fe5b565bc366b8d73d5d4c1606e07c8947de1654";
      })
    ];
    buildInputs =
      (self.nativeDeps."zip-stream" or []);
    deps = [
      self.by-version."readable-stream"."1.0.26"
      self.by-version."lodash.defaults"."2.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "zip-stream" ];
  };
  by-spec."zlib-browserify"."^0.0.3" =
    self.by-version."zlib-browserify"."0.0.3";
  by-version."zlib-browserify"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-zlib-browserify-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zlib-browserify/-/zlib-browserify-0.0.3.tgz";
        name = "zlib-browserify-0.0.3.tgz";
        sha1 = "240ccdbfd0203fa842b130deefb1414122c8cc50";
      })
    ];
    buildInputs =
      (self.nativeDeps."zlib-browserify" or []);
    deps = [
      self.by-version."tape"."0.2.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "zlib-browserify" ];
  };
  by-spec."zlib-browserify"."~0.0.3" =
    self.by-version."zlib-browserify"."0.0.3";
}
