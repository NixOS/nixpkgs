{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."Base64"."~0.2.0" =
    self.by-version."Base64"."0.2.1";
  by-version."Base64"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "Base64-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/Base64/-/Base64-0.2.1.tgz";
        name = "Base64-0.2.1.tgz";
        sha1 = "ba3a4230708e186705065e66babdd4c35cf60028";
      })
    ];
    buildInputs =
      (self.nativeDeps."Base64" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "Base64" ];
  };
  by-spec."JSONStream"."~0.7.1" =
    self.by-version."JSONStream"."0.7.4";
  by-version."JSONStream"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "JSONStream-0.7.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/JSONStream/-/JSONStream-0.7.4.tgz";
        name = "JSONStream-0.7.4.tgz";
        sha1 = "734290e41511eea7c2cfe151fbf9a563a97b9786";
      })
    ];
    buildInputs =
      (self.nativeDeps."JSONStream" or []);
    deps = {
      "jsonparse-0.0.5" = self.by-version."jsonparse"."0.0.5";
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "JSONStream" ];
  };
  by-spec."JSONStream"."~0.8.3" =
    self.by-version."JSONStream"."0.8.4";
  by-version."JSONStream"."0.8.4" = lib.makeOverridable self.buildNodePackage {
    name = "JSONStream-0.8.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/JSONStream/-/JSONStream-0.8.4.tgz";
        name = "JSONStream-0.8.4.tgz";
        sha1 = "91657dfe6ff857483066132b4618b62e8f4887bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."JSONStream" or []);
    deps = {
      "jsonparse-0.0.5" = self.by-version."jsonparse"."0.0.5";
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "JSONStream" ];
  };
  by-spec."JSONStream"."~0.8.4" =
    self.by-version."JSONStream"."0.8.4";
  by-spec."StringScanner"."~0.0.3" =
    self.by-version."StringScanner"."0.0.3";
  by-version."StringScanner"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "StringScanner-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/StringScanner/-/StringScanner-0.0.3.tgz";
        name = "StringScanner-0.0.3.tgz";
        sha1 = "bf06ecfdc90046711f4e6175549243b78ceb38aa";
      })
    ];
    buildInputs =
      (self.nativeDeps."StringScanner" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "StringScanner" ];
  };
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.0.5";
  by-version."abbrev"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "abbrev-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.5.tgz";
        name = "abbrev-1.0.5.tgz";
        sha1 = "5d8257bd9ebe435e698b2fa431afde4fe7b10b03";
      })
    ];
    buildInputs =
      (self.nativeDeps."abbrev" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "abbrev" ];
  };
  by-spec."abbrev"."1.0.x" =
    self.by-version."abbrev"."1.0.5";
  by-spec."abbrev"."~1.0.4" =
    self.by-version."abbrev"."1.0.5";
  by-spec."abbrev"."~1.0.5" =
    self.by-version."abbrev"."1.0.5";
  by-spec."accepts"."1.0.0" =
    self.by-version."accepts"."1.0.0";
  by-version."accepts"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "accepts-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.0.0.tgz";
        name = "accepts-1.0.0.tgz";
        sha1 = "3604c765586c3b9cf7877b6937cdbd4587f947dc";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = {
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "negotiator-0.3.0" = self.by-version."negotiator"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
  by-spec."accepts"."~1.0.7" =
    self.by-version."accepts"."1.0.7";
  by-version."accepts"."1.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "accepts-1.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.0.7.tgz";
        name = "accepts-1.0.7.tgz";
        sha1 = "5b501fb4f0704309964ccdb048172541208dab1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = {
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "negotiator-0.4.7" = self.by-version."negotiator"."0.4.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
  by-spec."accepts"."~1.1.2" =
    self.by-version."accepts"."1.1.2";
  by-version."accepts"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "accepts-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.1.2.tgz";
        name = "accepts-1.1.2.tgz";
        sha1 = "8469a0a0a215b50cb0d156d351662f8978b00876";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = {
      "mime-types-2.0.2" = self.by-version."mime-types"."2.0.2";
      "negotiator-0.4.9" = self.by-version."negotiator"."0.4.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
  by-spec."active-x-obfuscator"."0.0.1" =
    self.by-version."active-x-obfuscator"."0.0.1";
  by-version."active-x-obfuscator"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "active-x-obfuscator-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/active-x-obfuscator/-/active-x-obfuscator-0.0.1.tgz";
        name = "active-x-obfuscator-0.0.1.tgz";
        sha1 = "089b89b37145ff1d9ec74af6530be5526cae1f1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."active-x-obfuscator" or []);
    deps = {
      "zeparser-0.0.5" = self.by-version."zeparser"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "active-x-obfuscator" ];
  };
  by-spec."addressparser"."~0.2.1" =
    self.by-version."addressparser"."0.2.1";
  by-version."addressparser"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "addressparser-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/addressparser/-/addressparser-0.2.1.tgz";
        name = "addressparser-0.2.1.tgz";
        sha1 = "d11a5b2eeda04cfefebdf3196c10ae13db6cd607";
      })
    ];
    buildInputs =
      (self.nativeDeps."addressparser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "addressparser" ];
  };
  by-spec."adm-zip"."0.4.4" =
    self.by-version."adm-zip"."0.4.4";
  by-version."adm-zip"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "adm-zip-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.4.4.tgz";
        name = "adm-zip-0.4.4.tgz";
        sha1 = "a61ed5ae6905c3aea58b3a657d25033091052736";
      })
    ];
    buildInputs =
      (self.nativeDeps."adm-zip" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "adm-zip" ];
  };
  by-spec."adm-zip"."~0.4.3" =
    self.by-version."adm-zip"."0.4.4";
  by-spec."almond"."*" =
    self.by-version."almond"."0.3.0";
  by-version."almond"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "almond-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/almond/-/almond-0.3.0.tgz";
        name = "almond-0.3.0.tgz";
        sha1 = "701510c31038354f85ea31410b89ff3392058014";
      })
    ];
    buildInputs =
      (self.nativeDeps."almond" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "almond" ];
  };
  "almond" = self.by-version."almond"."0.3.0";
  by-spec."amdefine"."*" =
    self.by-version."amdefine"."0.1.0";
  by-version."amdefine"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "amdefine-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-0.1.0.tgz";
        name = "amdefine-0.1.0.tgz";
        sha1 = "3ca9735cf1dde0edf7a4bf6641709c8024f9b227";
      })
    ];
    buildInputs =
      (self.nativeDeps."amdefine" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "amdefine" ];
  };
  "amdefine" = self.by-version."amdefine"."0.1.0";
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."0.1.0";
  by-spec."ansi"."~0.3.0" =
    self.by-version."ansi"."0.3.0";
  by-version."ansi"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.3.0.tgz";
        name = "ansi-0.3.0.tgz";
        sha1 = "74b2f1f187c8553c7f95015bcb76009fb43d38e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi" ];
  };
  by-spec."ansi-regex"."^0.1.0" =
    self.by-version."ansi-regex"."0.1.0";
  by-version."ansi-regex"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-regex-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-0.1.0.tgz";
        name = "ansi-regex-0.1.0.tgz";
        sha1 = "55ca60db6900857c423ae9297980026f941ed903";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-regex" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-regex" ];
  };
  by-spec."ansi-regex"."^0.2.0" =
    self.by-version."ansi-regex"."0.2.1";
  by-version."ansi-regex"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-regex-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-0.2.1.tgz";
        name = "ansi-regex-0.2.1.tgz";
        sha1 = "0d8e946967a3d8143f93e24e298525fc1b2235f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-regex" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-regex" ];
  };
  by-spec."ansi-regex"."^0.2.1" =
    self.by-version."ansi-regex"."0.2.1";
  by-spec."ansi-remover"."*" =
    self.by-version."ansi-remover"."0.0.2";
  by-version."ansi-remover"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-remover-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-remover/-/ansi-remover-0.0.2.tgz";
        name = "ansi-remover-0.0.2.tgz";
        sha1 = "7020086289f10e195d85d828de065ccdd50e6e66";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-remover" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-remover" ];
  };
  "ansi-remover" = self.by-version."ansi-remover"."0.0.2";
  by-spec."ansi-styles"."^1.1.0" =
    self.by-version."ansi-styles"."1.1.0";
  by-version."ansi-styles"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-styles-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-1.1.0.tgz";
        name = "ansi-styles-1.1.0.tgz";
        sha1 = "eaecbf66cd706882760b2f4691582b8f55d7a7de";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  by-spec."ansi-styles"."~1.0.0" =
    self.by-version."ansi-styles"."1.0.0";
  by-version."ansi-styles"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-styles-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-1.0.0.tgz";
        name = "ansi-styles-1.0.0.tgz";
        sha1 = "cb102df1c56f5123eab8b67cd7b98027a0279178";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  by-spec."ansicolors"."~0.3.2" =
    self.by-version."ansicolors"."0.3.2";
  by-version."ansicolors"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "ansicolors-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansicolors/-/ansicolors-0.3.2.tgz";
        name = "ansicolors-0.3.2.tgz";
        sha1 = "665597de86a9ffe3aa9bfbe6cae5c6ea426b4979";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansicolors" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansicolors" ];
  };
  by-spec."ansistyles"."~0.1.3" =
    self.by-version."ansistyles"."0.1.3";
  by-version."ansistyles"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "ansistyles-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansistyles/-/ansistyles-0.1.3.tgz";
        name = "ansistyles-0.1.3.tgz";
        sha1 = "5de60415bda071bb37127854c864f41b23254539";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansistyles" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansistyles" ];
  };
  by-spec."apparatus".">= 0.0.6" =
    self.by-version."apparatus"."0.0.8";
  by-version."apparatus"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "apparatus-0.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/apparatus/-/apparatus-0.0.8.tgz";
        name = "apparatus-0.0.8.tgz";
        sha1 = "14e8aeb84189208b7f8d77f09d9f0307778b079a";
      })
    ];
    buildInputs =
      (self.nativeDeps."apparatus" or []);
    deps = {
      "sylvester-0.0.21" = self.by-version."sylvester"."0.0.21";
    };
    peerDependencies = [
    ];
    passthru.names = [ "apparatus" ];
  };
  by-spec."archiver"."~0.11.0" =
    self.by-version."archiver"."0.11.0";
  by-version."archiver"."0.11.0" = lib.makeOverridable self.buildNodePackage {
    name = "archiver-0.11.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archiver/-/archiver-0.11.0.tgz";
        name = "archiver-0.11.0.tgz";
        sha1 = "98177da7a6c0192b7f2798f30cd6eab8abd76690";
      })
    ];
    buildInputs =
      (self.nativeDeps."archiver" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "lazystream-0.1.0" = self.by-version."lazystream"."0.1.0";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "tar-stream-0.4.7" = self.by-version."tar-stream"."0.4.7";
      "zip-stream-0.4.1" = self.by-version."zip-stream"."0.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "archiver" ];
  };
  by-spec."archy"."0.0.2" =
    self.by-version."archy"."0.0.2";
  by-version."archy"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "archy-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archy/-/archy-0.0.2.tgz";
        name = "archy-0.0.2.tgz";
        sha1 = "910f43bf66141fc335564597abc189df44b3d35e";
      })
    ];
    buildInputs =
      (self.nativeDeps."archy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "archy" ];
  };
  by-spec."archy"."^0.0.2" =
    self.by-version."archy"."0.0.2";
  by-spec."archy"."~1.0.0" =
    self.by-version."archy"."1.0.0";
  by-version."archy"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "archy-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archy/-/archy-1.0.0.tgz";
        name = "archy-1.0.0.tgz";
        sha1 = "f9c8c13757cc1dd7bc379ac77b2c62a5c2868c40";
      })
    ];
    buildInputs =
      (self.nativeDeps."archy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "archy" ];
  };
  by-spec."argparse"."0.1.15" =
    self.by-version."argparse"."0.1.15";
  by-version."argparse"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "argparse-0.1.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/argparse/-/argparse-0.1.15.tgz";
        name = "argparse-0.1.15.tgz";
        sha1 = "28a1f72c43113e763220e5708414301c8840f0a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."argparse" or []);
    deps = {
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "underscore.string-2.3.3" = self.by-version."underscore.string"."2.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "argparse" ];
  };
  by-spec."argparse"."~ 0.1.11" =
    self.by-version."argparse"."0.1.15";
  by-spec."array-filter"."~0.0.0" =
    self.by-version."array-filter"."0.0.1";
  by-version."array-filter"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "array-filter-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-filter/-/array-filter-0.0.1.tgz";
        name = "array-filter-0.0.1.tgz";
        sha1 = "7da8cf2e26628ed732803581fd21f67cacd2eeec";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-filter" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "array-filter" ];
  };
  by-spec."array-map"."~0.0.0" =
    self.by-version."array-map"."0.0.0";
  by-version."array-map"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "array-map-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-map/-/array-map-0.0.0.tgz";
        name = "array-map-0.0.0.tgz";
        sha1 = "88a2bab73d1cf7bcd5c1b118a003f66f665fa662";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-map" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "array-map" ];
  };
  by-spec."array-reduce"."~0.0.0" =
    self.by-version."array-reduce"."0.0.0";
  by-version."array-reduce"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "array-reduce-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-reduce/-/array-reduce-0.0.0.tgz";
        name = "array-reduce-0.0.0.tgz";
        sha1 = "173899d3ffd1c7d9383e4479525dbe278cab5f2b";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-reduce" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "array-reduce" ];
  };
  by-spec."asap"."^1.0.0" =
    self.by-version."asap"."1.0.0";
  by-version."asap"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "asap-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asap/-/asap-1.0.0.tgz";
        name = "asap-1.0.0.tgz";
        sha1 = "b2a45da5fdfa20b0496fc3768cc27c12fa916a7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."asap" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "asap" ];
  };
  by-spec."asap"."~1.0.0" =
    self.by-version."asap"."1.0.0";
  by-spec."ascii-json"."~0.2" =
    self.by-version."ascii-json"."0.2.0";
  by-version."ascii-json"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "ascii-json-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ascii-json/-/ascii-json-0.2.0.tgz";
        name = "ascii-json-0.2.0.tgz";
        sha1 = "10ddb361fd48f72595309fd10a6ea2e7bf2c9218";
      })
    ];
    buildInputs =
      (self.nativeDeps."ascii-json" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ascii-json" ];
  };
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "asn1-0.1.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        name = "asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "asn1" ];
  };
  by-spec."assert"."*" =
    self.by-version."assert"."1.1.2";
  by-version."assert"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "assert-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert/-/assert-1.1.2.tgz";
        name = "assert-1.1.2.tgz";
        sha1 = "adaa04c46bb58c6dd1f294da3eb26e6228eb6e44";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert" or []);
    deps = {
      "util-0.10.3" = self.by-version."util"."0.10.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "assert" ];
  };
  "assert" = self.by-version."assert"."1.1.2";
  by-spec."assert"."~1.1.0" =
    self.by-version."assert"."1.1.2";
  by-spec."assert-plus"."0.1.2" =
    self.by-version."assert-plus"."0.1.2";
  by-version."assert-plus"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "assert-plus-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.2.tgz";
        name = "assert-plus-0.1.2.tgz";
        sha1 = "d93ffdbb67ac5507779be316a7d65146417beef8";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert-plus" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "assert-plus" ];
  };
  by-spec."assert-plus"."0.1.3" =
    self.by-version."assert-plus"."0.1.3";
  by-version."assert-plus"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "assert-plus-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.3.tgz";
        name = "assert-plus-0.1.3.tgz";
        sha1 = "32eba8ac83e50ae4f4b5babab1ae9aa0edec9fef";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert-plus" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "assert-plus" ];
  };
  by-spec."assertion-error"."1.0.0" =
    self.by-version."assertion-error"."1.0.0";
  by-version."assertion-error"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "assertion-error-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assertion-error/-/assertion-error-1.0.0.tgz";
        name = "assertion-error-1.0.0.tgz";
        sha1 = "c7f85438fdd466bc7ca16ab90c81513797a5d23b";
      })
    ];
    buildInputs =
      (self.nativeDeps."assertion-error" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "assertion-error" ];
  };
  by-spec."astw"."~1.1.0" =
    self.by-version."astw"."1.1.0";
  by-version."astw"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "astw-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/astw/-/astw-1.1.0.tgz";
        name = "astw-1.1.0.tgz";
        sha1 = "f394778ab01c4ea467e64a614ed896ace0321a34";
      })
    ];
    buildInputs =
      (self.nativeDeps."astw" or []);
    deps = {
      "esprima-fb-3001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
    };
    peerDependencies = [
    ];
    passthru.names = [ "astw" ];
  };
  by-spec."async"."*" =
    self.by-version."async"."0.9.0";
  by-version."async"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.9.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
        name = "async-0.9.0.tgz";
        sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  "async" = self.by-version."async"."0.9.0";
  by-spec."async"."0.1.22" =
    self.by-version."async"."0.1.22";
  by-version."async"."0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.1.22";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
        name = "async-0.1.22.tgz";
        sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."0.1.x" =
    self.by-version."async"."0.1.22";
  by-spec."async"."0.2.9" =
    self.by-version."async"."0.2.9";
  by-version."async"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        name = "async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
        name = "async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."0.9.x" =
    self.by-version."async"."0.9.0";
  by-spec."async"."^0.2.10" =
    self.by-version."async"."0.2.10";
  by-spec."async"."^0.9.0" =
    self.by-version."async"."0.9.0";
  by-spec."async"."~0.1.22" =
    self.by-version."async"."0.1.22";
  by-spec."async"."~0.2.0" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.6" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.7" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.8" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.9" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.7.0" =
    self.by-version."async"."0.7.0";
  by-version."async"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.7.0.tgz";
        name = "async-0.7.0.tgz";
        sha1 = "4429e0e62f5de0a54f37458c49f0b897eb52ada5";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."~0.8" =
    self.by-version."async"."0.8.0";
  by-version."async"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.8.0.tgz";
        name = "async-0.8.0.tgz";
        sha1 = "ee65ec77298c2ff1456bc4418a052d0f06435112";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-spec."async-some"."~1.0.1" =
    self.by-version."async-some"."1.0.1";
  by-version."async-some"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "async-some-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async-some/-/async-some-1.0.1.tgz";
        name = "async-some-1.0.1.tgz";
        sha1 = "8b54f08d46f0f9babc72ea9d646c245d23a4d9e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."async-some" or []);
    deps = {
      "dezalgo-1.0.1" = self.by-version."dezalgo"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "async-some" ];
  };
  by-spec."aws-sdk"."*" =
    self.by-version."aws-sdk"."2.0.21";
  by-version."aws-sdk"."2.0.21" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-2.0.21";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-2.0.21.tgz";
        name = "aws-sdk-2.0.21.tgz";
        sha1 = "aece051188e5d4a13f2432eb1d00f9dd9a81ef54";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sdk" or []);
    deps = {
      "xml2js-0.2.6" = self.by-version."xml2js"."0.2.6";
      "xmlbuilder-0.4.2" = self.by-version."xmlbuilder"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sdk" ];
  };
  "aws-sdk" = self.by-version."aws-sdk"."2.0.21";
  by-spec."aws-sdk".">=1.2.0 <2" =
    self.by-version."aws-sdk"."1.18.0";
  by-version."aws-sdk"."1.18.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-1.18.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-1.18.0.tgz";
        name = "aws-sdk-1.18.0.tgz";
        sha1 = "00f35b2d27ac91b1f0d3ef2084c98cf1d1f0adc3";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sdk" or []);
    deps = {
      "xml2js-0.2.4" = self.by-version."xml2js"."0.2.4";
      "xmlbuilder-0.4.2" = self.by-version."xmlbuilder"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sdk" ];
  };
  by-spec."aws-sign"."~0.2.0" =
    self.by-version."aws-sign"."0.2.0";
  by-version."aws-sign"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.2.0.tgz";
        name = "aws-sign-0.2.0.tgz";
        sha1 = "c55013856c8194ec854a0cbec90aab5a04ce3ac5";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
  by-spec."aws-sign"."~0.3.0" =
    self.by-version."aws-sign"."0.3.0";
  by-version."aws-sign"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.3.0.tgz";
        name = "aws-sign-0.3.0.tgz";
        sha1 = "3d81ca69b474b1e16518728b51c24ff0bbedc6e9";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign2-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
        name = "aws-sign2-0.5.0.tgz";
        sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign2" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign2" ];
  };
  by-spec."backbone"."*" =
    self.by-version."backbone"."1.1.2";
  by-version."backbone"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "backbone-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backbone/-/backbone-1.1.2.tgz";
        name = "backbone-1.1.2.tgz";
        sha1 = "c2c04c66bf87268fb82c177acebeff7d37ba6f2d";
      })
    ];
    buildInputs =
      (self.nativeDeps."backbone" or []);
    deps = {
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "backbone" ];
  };
  "backbone" = self.by-version."backbone"."1.1.2";
  by-spec."backoff"."2.1.0" =
    self.by-version."backoff"."2.1.0";
  by-version."backoff"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "backoff-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backoff/-/backoff-2.1.0.tgz";
        name = "backoff-2.1.0.tgz";
        sha1 = "19b4e9f9fb75c122ad7bb1c6c376d6085d43ea09";
      })
    ];
    buildInputs =
      (self.nativeDeps."backoff" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "backoff" ];
  };
  by-spec."base62"."0.1.1" =
    self.by-version."base62"."0.1.1";
  by-version."base62"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "base62-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base62/-/base62-0.1.1.tgz";
        name = "base62-0.1.1.tgz";
        sha1 = "7b4174c2f94449753b11c2651c083da841a7b084";
      })
    ];
    buildInputs =
      (self.nativeDeps."base62" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "base62" ];
  };
  by-spec."base64-js"."0.0.7" =
    self.by-version."base64-js"."0.0.7";
  by-version."base64-js"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "base64-js-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64-js/-/base64-js-0.0.7.tgz";
        name = "base64-js-0.0.7.tgz";
        sha1 = "54400dc91d696cec32a8a47902f971522fee8f48";
      })
    ];
    buildInputs =
      (self.nativeDeps."base64-js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "base64-js" ];
  };
  by-spec."base64-url"."1" =
    self.by-version."base64-url"."1.0.0";
  by-version."base64-url"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "base64-url-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64-url/-/base64-url-1.0.0.tgz";
        name = "base64-url-1.0.0.tgz";
        sha1 = "ab694376f2801af6c9260899ffef02f86b40ee2c";
      })
    ];
    buildInputs =
      (self.nativeDeps."base64-url" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "base64-url" ];
  };
  by-spec."base64-url"."1.0.0" =
    self.by-version."base64-url"."1.0.0";
  by-spec."base64id"."0.1.0" =
    self.by-version."base64id"."0.1.0";
  by-version."base64id"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "base64id-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64id/-/base64id-0.1.0.tgz";
        name = "base64id-0.1.0.tgz";
        sha1 = "02ce0fdeee0cef4f40080e1e73e834f0b1bfce3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."base64id" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "base64id" ];
  };
  by-spec."basic-auth"."1.0.0" =
    self.by-version."basic-auth"."1.0.0";
  by-version."basic-auth"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "basic-auth-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/basic-auth/-/basic-auth-1.0.0.tgz";
        name = "basic-auth-1.0.0.tgz";
        sha1 = "111b2d9ff8e4e6d136b8c84ea5e096cb87351637";
      })
    ];
    buildInputs =
      (self.nativeDeps."basic-auth" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "basic-auth" ];
  };
  by-spec."basic-auth-connect"."1.0.0" =
    self.by-version."basic-auth-connect"."1.0.0";
  by-version."basic-auth-connect"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "basic-auth-connect-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/basic-auth-connect/-/basic-auth-connect-1.0.0.tgz";
        name = "basic-auth-connect-1.0.0.tgz";
        sha1 = "fdb0b43962ca7b40456a7c2bb48fe173da2d2122";
      })
    ];
    buildInputs =
      (self.nativeDeps."basic-auth-connect" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "basic-auth-connect" ];
  };
  by-spec."batch"."0.5.0" =
    self.by-version."batch"."0.5.0";
  by-version."batch"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "batch-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/batch/-/batch-0.5.0.tgz";
        name = "batch-0.5.0.tgz";
        sha1 = "fd2e05a7a5d696b4db9314013e285d8ff3557ec3";
      })
    ];
    buildInputs =
      (self.nativeDeps."batch" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "batch" ];
  };
  by-spec."batch"."0.5.1" =
    self.by-version."batch"."0.5.1";
  by-version."batch"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "batch-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/batch/-/batch-0.5.1.tgz";
        name = "batch-0.5.1.tgz";
        sha1 = "36a4bab594c050fd7b507bca0db30c2d92af4ff2";
      })
    ];
    buildInputs =
      (self.nativeDeps."batch" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "batch" ];
  };
  by-spec."bcrypt"."*" =
    self.by-version."bcrypt"."0.8.0";
  by-version."bcrypt"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "bcrypt-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bcrypt/-/bcrypt-0.8.0.tgz";
        name = "bcrypt-0.8.0.tgz";
        sha1 = "b8f226406e5b78c838833a8468a4a0402cbc93c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."bcrypt" or []);
    deps = {
      "bindings-1.0.0" = self.by-version."bindings"."1.0.0";
      "nan-1.3.0" = self.by-version."nan"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bcrypt" ];
  };
  "bcrypt" = self.by-version."bcrypt"."0.8.0";
  by-spec."binary"."~0.3.0" =
    self.by-version."binary"."0.3.0";
  by-version."binary"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "binary-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/binary/-/binary-0.3.0.tgz";
        name = "binary-0.3.0.tgz";
        sha1 = "9f60553bc5ce8c3386f3b553cff47462adecaa79";
      })
    ];
    buildInputs =
      (self.nativeDeps."binary" or []);
    deps = {
      "chainsaw-0.1.0" = self.by-version."chainsaw"."0.1.0";
      "buffers-0.1.1" = self.by-version."buffers"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "binary" ];
  };
  by-spec."bindings"."*" =
    self.by-version."bindings"."1.2.1";
  by-version."bindings"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.2.1.tgz";
        name = "bindings-1.2.1.tgz";
        sha1 = "14ad6113812d2d37d72e67b4cacb4bb726505f11";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  by-spec."bindings"."1.0.0" =
    self.by-version."bindings"."1.0.0";
  by-version."bindings"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.0.0.tgz";
        name = "bindings-1.0.0.tgz";
        sha1 = "c3ccde60e9de6807c6f1aa4ef4843af29191c828";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  by-spec."bindings"."1.1.1" =
    self.by-version."bindings"."1.1.1";
  by-version."bindings"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.1.1.tgz";
        name = "bindings-1.1.1.tgz";
        sha1 = "951f7ae010302ffc50b265b124032017ed2bf6f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  by-spec."bindings".">=1.2.1" =
    self.by-version."bindings"."1.2.1";
  by-spec."bindings"."~1.2.1" =
    self.by-version."bindings"."1.2.1";
  by-spec."bl"."^0.9.0" =
    self.by-version."bl"."0.9.3";
  by-version."bl"."0.9.3" = lib.makeOverridable self.buildNodePackage {
    name = "bl-0.9.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bl/-/bl-0.9.3.tgz";
        name = "bl-0.9.3.tgz";
        sha1 = "c41eff3e7cb31bde107c8f10076d274eff7f7d44";
      })
    ];
    buildInputs =
      (self.nativeDeps."bl" or []);
    deps = {
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bl" ];
  };
  by-spec."bl"."~0.9.0" =
    self.by-version."bl"."0.9.3";
  by-spec."block-stream"."*" =
    self.by-version."block-stream"."0.0.7";
  by-version."block-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "block-stream-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        name = "block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
      })
    ];
    buildInputs =
      (self.nativeDeps."block-stream" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "block-stream" ];
  };
  by-spec."block-stream"."0.0.7" =
    self.by-version."block-stream"."0.0.7";
  by-spec."bluebird".">= 1.2.1" =
    self.by-version."bluebird"."2.3.6";
  by-version."bluebird"."2.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "bluebird-2.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bluebird/-/bluebird-2.3.6.tgz";
        name = "bluebird-2.3.6.tgz";
        sha1 = "aa090a29c1bfbc01089609358f4b1c37683515f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."bluebird" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bluebird" ];
  };
  by-spec."blueimp-md5"."~1.1.0" =
    self.by-version."blueimp-md5"."1.1.0";
  by-version."blueimp-md5"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "blueimp-md5-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/blueimp-md5/-/blueimp-md5-1.1.0.tgz";
        name = "blueimp-md5-1.1.0.tgz";
        sha1 = "041ed794862f3c5f2847282a7481329f1d2352cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."blueimp-md5" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "blueimp-md5" ];
  };
  by-spec."body-parser"."~1.6.5" =
    self.by-version."body-parser"."1.6.7";
  by-version."body-parser"."1.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "body-parser-1.6.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/body-parser/-/body-parser-1.6.7.tgz";
        name = "body-parser-1.6.7.tgz";
        sha1 = "82306becadf44543e826b3907eae93f0237c4e5c";
      })
    ];
    buildInputs =
      (self.nativeDeps."body-parser" or []);
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "depd-0.4.4" = self.by-version."depd"."0.4.4";
      "iconv-lite-0.4.4" = self.by-version."iconv-lite"."0.4.4";
      "media-typer-0.2.0" = self.by-version."media-typer"."0.2.0";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "qs-2.2.2" = self.by-version."qs"."2.2.2";
      "raw-body-1.3.0" = self.by-version."raw-body"."1.3.0";
      "type-is-1.3.2" = self.by-version."type-is"."1.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "body-parser" ];
  };
  by-spec."body-parser"."~1.9.0" =
    self.by-version."body-parser"."1.9.0";
  by-version."body-parser"."1.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "body-parser-1.9.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/body-parser/-/body-parser-1.9.0.tgz";
        name = "body-parser-1.9.0.tgz";
        sha1 = "95d72943b1a4f67f56bbac9e0dcc837b68703605";
      })
    ];
    buildInputs =
      (self.nativeDeps."body-parser" or []);
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "iconv-lite-0.4.4" = self.by-version."iconv-lite"."0.4.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "qs-2.2.4" = self.by-version."qs"."2.2.4";
      "raw-body-1.3.0" = self.by-version."raw-body"."1.3.0";
      "type-is-1.5.2" = self.by-version."type-is"."1.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "body-parser" ];
  };
  by-spec."boom"."0.3.x" =
    self.by-version."boom"."0.3.8";
  by-version."boom"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.3.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.3.8.tgz";
        name = "boom-0.3.8.tgz";
        sha1 = "c8cdb041435912741628c044ecc732d1d17c09ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
        name = "boom-0.4.2.tgz";
        sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."bower"."*" =
    self.by-version."bower"."1.3.12";
  by-version."bower"."1.3.12" = lib.makeOverridable self.buildNodePackage {
    name = "bower-1.3.12";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower/-/bower-1.3.12.tgz";
        name = "bower-1.3.12.tgz";
        sha1 = "37de0edb3904baf90aee13384a1a379a05ee214c";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "archy-0.0.2" = self.by-version."archy"."0.0.2";
      "bower-config-0.5.2" = self.by-version."bower-config"."0.5.2";
      "bower-endpoint-parser-0.2.2" = self.by-version."bower-endpoint-parser"."0.2.2";
      "bower-json-0.4.0" = self.by-version."bower-json"."0.4.0";
      "bower-logger-0.2.2" = self.by-version."bower-logger"."0.2.2";
      "bower-registry-client-0.2.1" = self.by-version."bower-registry-client"."0.2.1";
      "cardinal-0.4.0" = self.by-version."cardinal"."0.4.0";
      "chalk-0.5.0" = self.by-version."chalk"."0.5.0";
      "chmodr-0.1.0" = self.by-version."chmodr"."0.1.0";
      "decompress-zip-0.0.8" = self.by-version."decompress-zip"."0.0.8";
      "fstream-1.0.2" = self.by-version."fstream"."1.0.2";
      "fstream-ignore-1.0.1" = self.by-version."fstream-ignore"."1.0.1";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "handlebars-2.0.0" = self.by-version."handlebars"."2.0.0";
      "inquirer-0.7.1" = self.by-version."inquirer"."0.7.1";
      "insight-0.4.3" = self.by-version."insight"."0.4.3";
      "is-root-1.0.0" = self.by-version."is-root"."1.0.0";
      "junk-1.0.0" = self.by-version."junk"."1.0.0";
      "lockfile-1.0.0" = self.by-version."lockfile"."1.0.0";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "mout-0.9.1" = self.by-version."mout"."0.9.1";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "opn-1.0.0" = self.by-version."opn"."1.0.0";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "p-throttler-0.1.0" = self.by-version."p-throttler"."0.1.0";
      "promptly-0.2.0" = self.by-version."promptly"."0.2.0";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "request-2.42.0" = self.by-version."request"."2.42.0";
      "request-progress-0.3.0" = self.by-version."request-progress"."0.3.0";
      "retry-0.6.0" = self.by-version."retry"."0.6.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "shell-quote-1.4.2" = self.by-version."shell-quote"."1.4.2";
      "stringify-object-1.0.0" = self.by-version."stringify-object"."1.0.0";
      "tar-fs-0.5.2" = self.by-version."tar-fs"."0.5.2";
      "tmp-0.0.23" = self.by-version."tmp"."0.0.23";
      "update-notifier-0.2.0" = self.by-version."update-notifier"."0.2.0";
      "which-1.0.5" = self.by-version."which"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower" ];
  };
  "bower" = self.by-version."bower"."1.3.12";
  by-spec."bower".">=1.2.8 <2" =
    self.by-version."bower"."1.3.12";
  by-spec."bower-config"."~0.5.0" =
    self.by-version."bower-config"."0.5.2";
  by-version."bower-config"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "bower-config-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-config/-/bower-config-0.5.2.tgz";
        name = "bower-config-0.5.2.tgz";
        sha1 = "1f7d2e899e99b70c29a613e70d4c64590414b22e";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-config" or []);
    deps = {
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "mout-0.9.1" = self.by-version."mout"."0.9.1";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  by-spec."bower-config"."~0.5.2" =
    self.by-version."bower-config"."0.5.2";
  by-spec."bower-endpoint-parser"."0.2.1" =
    self.by-version."bower-endpoint-parser"."0.2.1";
  by-version."bower-endpoint-parser"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-endpoint-parser-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-endpoint-parser/-/bower-endpoint-parser-0.2.1.tgz";
        name = "bower-endpoint-parser-0.2.1.tgz";
        sha1 = "8c4010a2900cdab07ea5d38f0bd03e9bbccef90f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-endpoint-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-endpoint-parser" ];
  };
  by-spec."bower-endpoint-parser"."~0.2.2" =
    self.by-version."bower-endpoint-parser"."0.2.2";
  by-version."bower-endpoint-parser"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "bower-endpoint-parser-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-endpoint-parser/-/bower-endpoint-parser-0.2.2.tgz";
        name = "bower-endpoint-parser-0.2.2.tgz";
        sha1 = "00b565adbfab6f2d35addde977e97962acbcb3f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-endpoint-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-endpoint-parser" ];
  };
  by-spec."bower-json"."0.4.0" =
    self.by-version."bower-json"."0.4.0";
  by-version."bower-json"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-json-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-json/-/bower-json-0.4.0.tgz";
        name = "bower-json-0.4.0.tgz";
        sha1 = "a99c3ccf416ef0590ed0ded252c760f1c6d93766";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-json" or []);
    deps = {
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "intersect-0.0.3" = self.by-version."intersect"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-json" ];
  };
  by-spec."bower-json"."~0.4.0" =
    self.by-version."bower-json"."0.4.0";
  by-spec."bower-logger"."0.2.1" =
    self.by-version."bower-logger"."0.2.1";
  by-version."bower-logger"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-logger-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.1.tgz";
        name = "bower-logger-0.2.1.tgz";
        sha1 = "0c1817c48063a88d96cc3d516c55e57fff5d9ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-logger" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-logger" ];
  };
  by-spec."bower-logger"."~0.2.2" =
    self.by-version."bower-logger"."0.2.2";
  by-version."bower-logger"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "bower-logger-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.2.tgz";
        name = "bower-logger-0.2.2.tgz";
        sha1 = "39be07e979b2fc8e03a94634205ed9422373d381";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-logger" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-logger" ];
  };
  by-spec."bower-registry-client"."~0.2.0" =
    self.by-version."bower-registry-client"."0.2.1";
  by-version."bower-registry-client"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-registry-client-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-registry-client/-/bower-registry-client-0.2.1.tgz";
        name = "bower-registry-client-0.2.1.tgz";
        sha1 = "06fbff982f82a4a4045dc53ac9dcb1c43d9cd591";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-registry-client" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "bower-config-0.5.2" = self.by-version."bower-config"."0.5.2";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "lru-cache-2.3.1" = self.by-version."lru-cache"."2.3.1";
      "request-2.27.0" = self.by-version."request"."2.27.0";
      "request-replay-0.2.0" = self.by-version."request-replay"."0.2.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower-registry-client" ];
  };
  by-spec."bower2nix"."*" =
    self.by-version."bower2nix"."2.1.0";
  by-version."bower2nix"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower2nix-2.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower2nix/-/bower2nix-2.1.0.tgz";
        name = "bower2nix-2.1.0.tgz";
        sha1 = "213f507a729b20a1c3cb48f995a034f9c05f53e6";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower2nix" or []);
    deps = {
      "temp-0.6.0" = self.by-version."temp"."0.6.0";
      "fs.extra-1.2.1" = self.by-version."fs.extra"."1.2.1";
      "bower-json-0.4.0" = self.by-version."bower-json"."0.4.0";
      "bower-endpoint-parser-0.2.1" = self.by-version."bower-endpoint-parser"."0.2.1";
      "bower-logger-0.2.1" = self.by-version."bower-logger"."0.2.1";
      "bower-1.3.12" = self.by-version."bower"."1.3.12";
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "clone-0.1.11" = self.by-version."clone"."0.1.11";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "fetch-bower-2.0.0" = self.by-version."fetch-bower"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bower2nix" ];
  };
  "bower2nix" = self.by-version."bower2nix"."2.1.0";
  by-spec."broadway"."0.2.9" =
    self.by-version."broadway"."0.2.9";
  by-version."broadway"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "broadway-0.2.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/broadway/-/broadway-0.2.9.tgz";
        name = "broadway-0.2.9.tgz";
        sha1 = "887008b2257f4171089de5cb9b656969b6c8c9e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."broadway" or []);
    deps = {
      "cliff-0.1.8" = self.by-version."cliff"."0.1.8";
      "eventemitter2-0.4.12" = self.by-version."eventemitter2"."0.4.12";
      "nconf-0.6.9" = self.by-version."nconf"."0.6.9";
      "winston-0.7.2" = self.by-version."winston"."0.7.2";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "broadway" ];
  };
  by-spec."broadway"."0.2.x" =
    self.by-version."broadway"."0.2.10";
  by-version."broadway"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "broadway-0.2.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/broadway/-/broadway-0.2.10.tgz";
        name = "broadway-0.2.10.tgz";
        sha1 = "0f58532be140426e9000e49a93e242a0d1263238";
      })
    ];
    buildInputs =
      (self.nativeDeps."broadway" or []);
    deps = {
      "cliff-0.1.8" = self.by-version."cliff"."0.1.8";
      "eventemitter2-0.4.14" = self.by-version."eventemitter2"."0.4.14";
      "nconf-0.6.9" = self.by-version."nconf"."0.6.9";
      "winston-0.7.2" = self.by-version."winston"."0.7.2";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "broadway" ];
  };
  by-spec."broadway"."~0.3.2" =
    self.by-version."broadway"."0.3.6";
  by-version."broadway"."0.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "broadway-0.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/broadway/-/broadway-0.3.6.tgz";
        name = "broadway-0.3.6.tgz";
        sha1 = "7dbef068b954b7907925fd544963b578a902ba7a";
      })
    ];
    buildInputs =
      (self.nativeDeps."broadway" or []);
    deps = {
      "cliff-0.1.9" = self.by-version."cliff"."0.1.9";
      "eventemitter2-0.4.14" = self.by-version."eventemitter2"."0.4.14";
      "nconf-0.6.9" = self.by-version."nconf"."0.6.9";
      "winston-0.8.0" = self.by-version."winston"."0.8.0";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "broadway" ];
  };
  by-spec."browser-pack"."^3.2.0" =
    self.by-version."browser-pack"."3.2.0";
  by-version."browser-pack"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "browser-pack-3.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-pack/-/browser-pack-3.2.0.tgz";
        name = "browser-pack-3.2.0.tgz";
        sha1 = "faa1cbc41487b1acc4747e373e1148adffd0e2d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-pack" or []);
    deps = {
      "JSONStream-0.8.4" = self.by-version."JSONStream"."0.8.4";
      "combine-source-map-0.3.0" = self.by-version."combine-source-map"."0.3.0";
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
      "umd-2.1.0" = self.by-version."umd"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-pack" ];
  };
  by-spec."browser-resolve"."^1.3.0" =
    self.by-version."browser-resolve"."1.3.2";
  by-version."browser-resolve"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "browser-resolve-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-resolve/-/browser-resolve-1.3.2.tgz";
        name = "browser-resolve-1.3.2.tgz";
        sha1 = "028417dd85828eea872c1bbb3e6609534545d20c";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-resolve" or []);
    deps = {
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-resolve" ];
  };
  by-spec."browser-resolve"."^1.3.1" =
    self.by-version."browser-resolve"."1.3.2";
  by-spec."browserchannel"."*" =
    self.by-version."browserchannel"."2.0.0";
  by-version."browserchannel"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "browserchannel-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserchannel/-/browserchannel-2.0.0.tgz";
        name = "browserchannel-2.0.0.tgz";
        sha1 = "0f211b3cad9995e8729b2bacd46b53c027c0ea63";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserchannel" or []);
    deps = {
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "connect-2.27.0" = self.by-version."connect"."2.27.0";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "ascii-json-0.2.0" = self.by-version."ascii-json"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserchannel" ];
  };
  "browserchannel" = self.by-version."browserchannel"."2.0.0";
  by-spec."browserify"."*" =
    self.by-version."browserify"."6.1.0";
  by-version."browserify"."6.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-6.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify/-/browserify-6.1.0.tgz";
        name = "browserify-6.1.0.tgz";
        sha1 = "8da16d98a0be638b5e53d1cd560f7f344d238cdb";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify" or []);
    deps = {
      "JSONStream-0.8.4" = self.by-version."JSONStream"."0.8.4";
      "assert-1.1.2" = self.by-version."assert"."1.1.2";
      "browser-pack-3.2.0" = self.by-version."browser-pack"."3.2.0";
      "browser-resolve-1.3.2" = self.by-version."browser-resolve"."1.3.2";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
      "buffer-2.7.0" = self.by-version."buffer"."2.7.0";
      "builtins-0.0.7" = self.by-version."builtins"."0.0.7";
      "commondir-0.0.1" = self.by-version."commondir"."0.0.1";
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "console-browserify-1.1.0" = self.by-version."console-browserify"."1.1.0";
      "constants-browserify-0.0.1" = self.by-version."constants-browserify"."0.0.1";
      "crypto-browserify-3.2.8" = self.by-version."crypto-browserify"."3.2.8";
      "deep-equal-0.2.1" = self.by-version."deep-equal"."0.2.1";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "deps-sort-1.3.5" = self.by-version."deps-sort"."1.3.5";
      "domain-browser-1.1.3" = self.by-version."domain-browser"."1.1.3";
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "events-1.0.2" = self.by-version."events"."1.0.2";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "http-browserify-1.7.0" = self.by-version."http-browserify"."1.7.0";
      "https-browserify-0.0.0" = self.by-version."https-browserify"."0.0.0";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "insert-module-globals-6.1.0" = self.by-version."insert-module-globals"."6.1.0";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "labeled-stream-splicer-1.0.0" = self.by-version."labeled-stream-splicer"."1.0.0";
      "module-deps-3.5.6" = self.by-version."module-deps"."3.5.6";
      "os-browserify-0.1.2" = self.by-version."os-browserify"."0.1.2";
      "parents-0.0.3" = self.by-version."parents"."0.0.3";
      "path-browserify-0.0.0" = self.by-version."path-browserify"."0.0.0";
      "process-0.8.0" = self.by-version."process"."0.8.0";
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
      "querystring-es3-0.2.1" = self.by-version."querystring-es3"."0.2.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "shallow-copy-0.0.1" = self.by-version."shallow-copy"."0.0.1";
      "shasum-1.0.0" = self.by-version."shasum"."1.0.0";
      "shell-quote-0.0.1" = self.by-version."shell-quote"."0.0.1";
      "stream-browserify-1.0.0" = self.by-version."stream-browserify"."1.0.0";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "subarg-1.0.0" = self.by-version."subarg"."1.0.0";
      "syntax-error-1.1.1" = self.by-version."syntax-error"."1.1.1";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "timers-browserify-1.1.0" = self.by-version."timers-browserify"."1.1.0";
      "tty-browserify-0.0.0" = self.by-version."tty-browserify"."0.0.0";
      "umd-2.1.0" = self.by-version."umd"."2.1.0";
      "url-0.10.1" = self.by-version."url"."0.10.1";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "vm-browserify-0.0.4" = self.by-version."vm-browserify"."0.0.4";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify" ];
  };
  "browserify" = self.by-version."browserify"."6.1.0";
  by-spec."browserify-zlib"."^0.1.4" =
    self.by-version."browserify-zlib"."0.1.4";
  by-version."browserify-zlib"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-zlib-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.1.4.tgz";
        name = "browserify-zlib-0.1.4.tgz";
        sha1 = "bb35f8a519f600e0fa6b8485241c979d0141fb2d";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify-zlib" or []);
    deps = {
      "pako-0.2.5" = self.by-version."pako"."0.2.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify-zlib" ];
  };
  by-spec."browserify-zlib"."~0.1.2" =
    self.by-version."browserify-zlib"."0.1.4";
  by-spec."bson"."0.1.8" =
    self.by-version."bson"."0.1.8";
  by-version."bson"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.1.8.tgz";
        name = "bson-0.1.8.tgz";
        sha1 = "cf34fdcff081a189b589b4b3e5e9309cd6506c81";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.12" =
    self.by-version."bson"."0.2.12";
  by-version."bson"."0.2.12" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.12";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.12.tgz";
        name = "bson-0.2.12.tgz";
        sha1 = "78bedbef1fd1f629b1c3b8d2f2d1fd87b8d64dd2";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = {
      "nan-1.2.0" = self.by-version."nan"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.2" =
    self.by-version."bson"."0.2.2";
  by-version."bson"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.2.tgz";
        name = "bson-0.2.2.tgz";
        sha1 = "3dbf984acb9d33a6878b46e6fb7afbd611856a60";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.5" =
    self.by-version."bson"."0.2.5";
  by-version."bson"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.5.tgz";
        name = "bson-0.2.5.tgz";
        sha1 = "500d26d883ddc8e02f2c88011627636111c105c5";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."~0.2" =
    self.by-version."bson"."0.2.15";
  by-version."bson"."0.2.15" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.15.tgz";
        name = "bson-0.2.15.tgz";
        sha1 = "556402c74bf33d8008122cc3091dc8b3b90e330c";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = {
      "nan-1.3.0" = self.by-version."nan"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."buffer"."^2.3.0" =
    self.by-version."buffer"."2.7.0";
  by-version."buffer"."2.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-2.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer/-/buffer-2.7.0.tgz";
        name = "buffer-2.7.0.tgz";
        sha1 = "02dfe9655c097f63e03c1b1714ca6e3d83d87bb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer" or []);
    deps = {
      "base64-js-0.0.7" = self.by-version."base64-js"."0.0.7";
      "ieee754-1.1.4" = self.by-version."ieee754"."1.1.4";
      "is-array-1.0.1" = self.by-version."is-array"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffer" ];
  };
  by-spec."buffer-crc32"."0.1.1" =
    self.by-version."buffer-crc32"."0.1.1";
  by-version."buffer-crc32"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.1.1.tgz";
        name = "buffer-crc32-0.1.1.tgz";
        sha1 = "7e110dc9953908ab7c32acdc70c9f945b1cbc526";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  by-spec."buffer-crc32"."0.2.1" =
    self.by-version."buffer-crc32"."0.2.1";
  by-version."buffer-crc32"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.1.tgz";
        name = "buffer-crc32-0.2.1.tgz";
        sha1 = "be3e5382fc02b6d6324956ac1af98aa98b08534c";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  by-spec."buffer-crc32"."0.2.3" =
    self.by-version."buffer-crc32"."0.2.3";
  by-version."buffer-crc32"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.3.tgz";
        name = "buffer-crc32-0.2.3.tgz";
        sha1 = "bb54519e95d107cbd2400e76d0cab1467336d921";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  by-spec."buffer-crc32"."~0.2.1" =
    self.by-version."buffer-crc32"."0.2.3";
  by-spec."buffers"."~0.1.1" =
    self.by-version."buffers"."0.1.1";
  by-version."buffers"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffers-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffers/-/buffers-0.1.1.tgz";
        name = "buffers-0.1.1.tgz";
        sha1 = "b24579c3bed4d6d396aeee6d9a8ae7f5482ab7bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffers" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffers" ];
  };
  by-spec."buffertools"."*" =
    self.by-version."buffertools"."2.1.2";
  by-version."buffertools"."2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "buffertools-2.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-2.1.2.tgz";
        name = "buffertools-2.1.2.tgz";
        sha1 = "d667afc1ef8b9932e90a25f2e3a66a929d42daab";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffertools" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffertools" ];
  };
  "buffertools" = self.by-version."buffertools"."2.1.2";
  by-spec."buffertools".">=1.1.1 <2.0.0" =
    self.by-version."buffertools"."1.1.1";
  by-version."buffertools"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffertools-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-1.1.1.tgz";
        name = "buffertools-1.1.1.tgz";
        sha1 = "1071a5f40fe76c39d7a4fe2ea030324d09d6ec9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffertools" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffertools" ];
  };
  by-spec."builtins"."~0.0.3" =
    self.by-version."builtins"."0.0.7";
  by-version."builtins"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "builtins-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/builtins/-/builtins-0.0.7.tgz";
        name = "builtins-0.0.7.tgz";
        sha1 = "355219cd6cf18dbe7c01cc7fd2dce765cfdc549a";
      })
    ];
    buildInputs =
      (self.nativeDeps."builtins" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "builtins" ];
  };
  by-spec."bunyan"."0.21.1" =
    self.by-version."bunyan"."0.21.1";
  by-version."bunyan"."0.21.1" = lib.makeOverridable self.buildNodePackage {
    name = "bunyan-0.21.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bunyan/-/bunyan-0.21.1.tgz";
        name = "bunyan-0.21.1.tgz";
        sha1 = "ea00a0d5223572e31e1e71efba2237cb1915942a";
      })
    ];
    buildInputs =
      (self.nativeDeps."bunyan" or []);
    deps = {
      "mv-0.0.5" = self.by-version."mv"."0.0.5";
      "dtrace-provider-0.2.8" = self.by-version."dtrace-provider"."0.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bunyan" ];
  };
  by-spec."bytes"."0.1.0" =
    self.by-version."bytes"."0.1.0";
  by-version."bytes"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "bytes-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.1.0.tgz";
        name = "bytes-0.1.0.tgz";
        sha1 = "c574812228126d6369d1576925a8579db3f8e5a2";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."0.2.0" =
    self.by-version."bytes"."0.2.0";
  by-version."bytes"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "bytes-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.2.0.tgz";
        name = "bytes-0.2.0.tgz";
        sha1 = "aad33ec14e3dc2ca74e8e7d451f9ba053ad4f7a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."0.2.1" =
    self.by-version."bytes"."0.2.1";
  by-version."bytes"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bytes-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.2.1.tgz";
        name = "bytes-0.2.1.tgz";
        sha1 = "555b08abcb063f8975905302523e4cd4ffdfdf31";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."1" =
    self.by-version."bytes"."1.0.0";
  by-version."bytes"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "bytes-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-1.0.0.tgz";
        name = "bytes-1.0.0.tgz";
        sha1 = "3569ede8ba34315fab99c3e92cb04c7220de1fa8";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."1.0.0" =
    self.by-version."bytes"."1.0.0";
  by-spec."bytes"."~0.2.1" =
    self.by-version."bytes"."0.2.1";
  by-spec."callsite"."~1.0.0" =
    self.by-version."callsite"."1.0.0";
  by-version."callsite"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "callsite-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/callsite/-/callsite-1.0.0.tgz";
        name = "callsite-1.0.0.tgz";
        sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
      })
    ];
    buildInputs =
      (self.nativeDeps."callsite" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "callsite" ];
  };
  by-spec."cardinal"."0.4.0" =
    self.by-version."cardinal"."0.4.0";
  by-version."cardinal"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "cardinal-0.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cardinal/-/cardinal-0.4.0.tgz";
        name = "cardinal-0.4.0.tgz";
        sha1 = "7d10aafb20837bde043c45e43a0c8c28cdaae45e";
      })
    ];
    buildInputs =
      (self.nativeDeps."cardinal" or []);
    deps = {
      "redeyed-0.4.4" = self.by-version."redeyed"."0.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cardinal" ];
  };
  by-spec."caseless"."~0.6.0" =
    self.by-version."caseless"."0.6.0";
  by-version."caseless"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "caseless-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.6.0.tgz";
        name = "caseless-0.6.0.tgz";
        sha1 = "8167c1ab8397fb5bb95f96d28e5a81c50f247ac4";
      })
    ];
    buildInputs =
      (self.nativeDeps."caseless" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "caseless" ];
  };
  by-spec."chai"."*" =
    self.by-version."chai"."1.9.2";
  by-version."chai"."1.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "chai-1.9.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chai/-/chai-1.9.2.tgz";
        name = "chai-1.9.2.tgz";
        sha1 = "3f1a20f82b0b9d7437577d24d6f12b1a69d3b590";
      })
    ];
    buildInputs =
      (self.nativeDeps."chai" or []);
    deps = {
      "assertion-error-1.0.0" = self.by-version."assertion-error"."1.0.0";
      "deep-eql-0.1.3" = self.by-version."deep-eql"."0.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chai" ];
  };
  "chai" = self.by-version."chai"."1.9.2";
  by-spec."chainsaw"."~0.1.0" =
    self.by-version."chainsaw"."0.1.0";
  by-version."chainsaw"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "chainsaw-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chainsaw/-/chainsaw-0.1.0.tgz";
        name = "chainsaw-0.1.0.tgz";
        sha1 = "5eab50b28afe58074d0d58291388828b5e5fbc98";
      })
    ];
    buildInputs =
      (self.nativeDeps."chainsaw" or []);
    deps = {
      "traverse-0.3.9" = self.by-version."traverse"."0.3.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chainsaw" ];
  };
  by-spec."chalk"."0.5.0" =
    self.by-version."chalk"."0.5.0";
  by-version."chalk"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.5.0.tgz";
        name = "chalk-0.5.0.tgz";
        sha1 = "375dfccbc21c0a60a8b61bc5b78f3dc2a55c212f";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = {
      "ansi-styles-1.1.0" = self.by-version."ansi-styles"."1.1.0";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "has-ansi-0.1.0" = self.by-version."has-ansi"."0.1.0";
      "strip-ansi-0.3.0" = self.by-version."strip-ansi"."0.3.0";
      "supports-color-0.2.0" = self.by-version."supports-color"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."^0.4.0" =
    self.by-version."chalk"."0.4.0";
  by-version."chalk"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.4.0.tgz";
        name = "chalk-0.4.0.tgz";
        sha1 = "5199a3ddcd0c1efe23bc08c1b027b06176e0c64f";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = {
      "has-color-0.1.7" = self.by-version."has-color"."0.1.7";
      "ansi-styles-1.0.0" = self.by-version."ansi-styles"."1.0.0";
      "strip-ansi-0.1.1" = self.by-version."strip-ansi"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."^0.5.0" =
    self.by-version."chalk"."0.5.1";
  by-version."chalk"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.5.1.tgz";
        name = "chalk-0.5.1.tgz";
        sha1 = "663b3a648b68b55d04690d49167aa837858f2174";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = {
      "ansi-styles-1.1.0" = self.by-version."ansi-styles"."1.1.0";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "has-ansi-0.1.0" = self.by-version."has-ansi"."0.1.0";
      "strip-ansi-0.3.0" = self.by-version."strip-ansi"."0.3.0";
      "supports-color-0.2.0" = self.by-version."supports-color"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."^0.5.1" =
    self.by-version."chalk"."0.5.1";
  by-spec."chalk"."~0.4.0" =
    self.by-version."chalk"."0.4.0";
  by-spec."char-spinner"."~1.0.1" =
    self.by-version."char-spinner"."1.0.1";
  by-version."char-spinner"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "char-spinner-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/char-spinner/-/char-spinner-1.0.1.tgz";
        name = "char-spinner-1.0.1.tgz";
        sha1 = "e6ea67bd247e107112983b7ab0479ed362800081";
      })
    ];
    buildInputs =
      (self.nativeDeps."char-spinner" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "char-spinner" ];
  };
  by-spec."character-parser"."1.2.0" =
    self.by-version."character-parser"."1.2.0";
  by-version."character-parser"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "character-parser-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/character-parser/-/character-parser-1.2.0.tgz";
        name = "character-parser-1.2.0.tgz";
        sha1 = "94134d6e5d870a39be359f7d22460935184ddef6";
      })
    ];
    buildInputs =
      (self.nativeDeps."character-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "character-parser" ];
  };
  by-spec."child-process-close"."~0.1.1" =
    self.by-version."child-process-close"."0.1.1";
  by-version."child-process-close"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "child-process-close-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/child-process-close/-/child-process-close-0.1.1.tgz";
        name = "child-process-close-0.1.1.tgz";
        sha1 = "c153ede7a5eb65ac69e78a38973b1a286377f75f";
      })
    ];
    buildInputs =
      (self.nativeDeps."child-process-close" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "child-process-close" ];
  };
  by-spec."chmodr"."0.1.0" =
    self.by-version."chmodr"."0.1.0";
  by-version."chmodr"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "chmodr-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chmodr/-/chmodr-0.1.0.tgz";
        name = "chmodr-0.1.0.tgz";
        sha1 = "e09215a1d51542db2a2576969765bcf6125583eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."chmodr" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "chmodr" ];
  };
  by-spec."chmodr"."~0.1.0" =
    self.by-version."chmodr"."0.1.0";
  by-spec."chokidar".">=0.8.2" =
    self.by-version."chokidar"."0.10.1";
  by-version."chokidar"."0.10.1" = lib.makeOverridable self.buildNodePackage {
    name = "chokidar-0.10.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chokidar/-/chokidar-0.10.1.tgz";
        name = "chokidar-0.10.1.tgz";
        sha1 = "ec2b4e9910c75a2b2e09ff5fdf283029b73af199";
      })
    ];
    buildInputs =
      (self.nativeDeps."chokidar" or []);
    deps = {
      "fsevents-0.3.0" = self.by-version."fsevents"."0.3.0";
      "readdirp-1.1.0" = self.by-version."readdirp"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chokidar" ];
  };
  by-spec."chownr"."0" =
    self.by-version."chownr"."0.0.1";
  by-version."chownr"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "chownr-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chownr/-/chownr-0.0.1.tgz";
        name = "chownr-0.0.1.tgz";
        sha1 = "51d18189d9092d5f8afd623f3288bfd1c6bf1a62";
      })
    ];
    buildInputs =
      (self.nativeDeps."chownr" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "chownr" ];
  };
  by-spec."clean-css"."2.2.x" =
    self.by-version."clean-css"."2.2.16";
  by-version."clean-css"."2.2.16" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-2.2.16";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-2.2.16.tgz";
        name = "clean-css-2.2.16.tgz";
        sha1 = "a79f4fbd6bb8652c4d1668b44406172f180d0283";
      })
    ];
    buildInputs =
      (self.nativeDeps."clean-css" or []);
    deps = {
      "commander-2.2.0" = self.by-version."commander"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "clean-css" ];
  };
  by-spec."clean-css"."~2.2.0" =
    self.by-version."clean-css"."2.2.16";
  by-spec."cli"."0.6.x" =
    self.by-version."cli"."0.6.5";
  by-version."cli"."0.6.5" = lib.makeOverridable self.buildNodePackage {
    name = "cli-0.6.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli/-/cli-0.6.5.tgz";
        name = "cli-0.6.5.tgz";
        sha1 = "f4edda12dfa8d56d726b43b0b558e089b0d2a85c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli" or []);
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cli" ];
  };
  by-spec."cli-color"."~0.3.2" =
    self.by-version."cli-color"."0.3.2";
  by-version."cli-color"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "cli-color-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli-color/-/cli-color-0.3.2.tgz";
        name = "cli-color-0.3.2.tgz";
        sha1 = "75fa5f728c308cc4ac594b05e06cc5d80daccd86";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli-color" or []);
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
      "memoizee-0.3.8" = self.by-version."memoizee"."0.3.8";
      "timers-ext-0.1.0" = self.by-version."timers-ext"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cli-color" ];
  };
  by-spec."cliff"."0.1.8" =
    self.by-version."cliff"."0.1.8";
  by-version."cliff"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "cliff-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cliff/-/cliff-0.1.8.tgz";
        name = "cliff-0.1.8.tgz";
        sha1 = "43ca8ad9fe3943489693ab62dce0cae22509d272";
      })
    ];
    buildInputs =
      (self.nativeDeps."cliff" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "winston-0.6.2" = self.by-version."winston"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cliff" ];
  };
  by-spec."cliff"."0.1.9" =
    self.by-version."cliff"."0.1.9";
  by-version."cliff"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "cliff-0.1.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cliff/-/cliff-0.1.9.tgz";
        name = "cliff-0.1.9.tgz";
        sha1 = "a211e09c6a3de3ba1af27d049d301250d18812bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."cliff" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "winston-0.8.1" = self.by-version."winston"."0.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cliff" ];
  };
  by-spec."clone"."0.1.11" =
    self.by-version."clone"."0.1.11";
  by-version."clone"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.11.tgz";
        name = "clone-0.1.11.tgz";
        sha1 = "408b7d1773eb0dfbf2ddb156c1c47170c17e3a96";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."clone"."0.1.5" =
    self.by-version."clone"."0.1.5";
  by-version."clone"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.5.tgz";
        name = "clone-0.1.5.tgz";
        sha1 = "46f29143d0766d663dbd7f80b7520a15783d2042";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."clone"."0.1.6" =
    self.by-version."clone"."0.1.6";
  by-version."clone"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.6.tgz";
        name = "clone-0.1.6.tgz";
        sha1 = "4af2296d4a23a64168c2f5fb0a2aa65e80517000";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."clone"."~0.1.5" =
    self.by-version."clone"."0.1.18";
  by-version."clone"."0.1.18" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.18";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.18.tgz";
        name = "clone-0.1.18.tgz";
        sha1 = "64a0d5d57eaa85a1a8af380cd1db8c7b3a895f66";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  by-spec."clone-stats"."^0.0.1" =
    self.by-version."clone-stats"."0.0.1";
  by-version."clone-stats"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "clone-stats-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone-stats/-/clone-stats-0.0.1.tgz";
        name = "clone-stats-0.0.1.tgz";
        sha1 = "b88f94a82cf38b8791d58046ea4029ad88ca99d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone-stats" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "clone-stats" ];
  };
  by-spec."clone-stats"."~0.0.1" =
    self.by-version."clone-stats"."0.0.1";
  by-spec."cmd-shim"."~2.0.1" =
    self.by-version."cmd-shim"."2.0.1";
  by-version."cmd-shim"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cmd-shim-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cmd-shim/-/cmd-shim-2.0.1.tgz";
        name = "cmd-shim-2.0.1.tgz";
        sha1 = "4512a373d2391679aec51ad1d4733559e9b85d4a";
      })
    ];
    buildInputs =
      (self.nativeDeps."cmd-shim" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cmd-shim" ];
  };
  by-spec."cmdln"."1.3.2" =
    self.by-version."cmdln"."1.3.2";
  by-version."cmdln"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "cmdln-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cmdln/-/cmdln-1.3.2.tgz";
        name = "cmdln-1.3.2.tgz";
        sha1 = "46a7b362166875cdafe7bc3fe6c73e4644dc6884";
      })
    ];
    buildInputs =
      (self.nativeDeps."cmdln" or []);
    deps = {
      "assert-plus-0.1.3" = self.by-version."assert-plus"."0.1.3";
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
      "verror-1.3.6" = self.by-version."verror"."1.3.6";
      "dashdash-1.3.2" = self.by-version."dashdash"."1.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cmdln" ];
  };
  by-spec."coffee-script"."*" =
    self.by-version."coffee-script"."1.8.0";
  by-version."coffee-script"."1.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.8.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.8.0.tgz";
        name = "coffee-script-1.8.0.tgz";
        sha1 = "9c9f1d2b4a52a000ded15b659791703648263c1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = {
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  "coffee-script" = self.by-version."coffee-script"."1.8.0";
  by-spec."coffee-script"."1.6.3" =
    self.by-version."coffee-script"."1.6.3";
  by-version."coffee-script"."1.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        name = "coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  by-spec."coffee-script".">= 0.0.1" =
    self.by-version."coffee-script"."1.8.0";
  by-spec."coffee-script".">=1.2.0" =
    self.by-version."coffee-script"."1.8.0";
  by-spec."coffee-script"."~1.3.3" =
    self.by-version."coffee-script"."1.3.3";
  by-version."coffee-script"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.3.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.3.3.tgz";
        name = "coffee-script-1.3.3.tgz";
        sha1 = "150d6b4cb522894369efed6a2101c20bc7f4a4f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  by-spec."coffee-script-redux"."=2.0.0-beta8" =
    self.by-version."coffee-script-redux"."2.0.0-beta8";
  by-version."coffee-script-redux"."2.0.0-beta8" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-redux-2.0.0-beta8";
    bin = true;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/coffee-script-redux/-/coffee-script-redux-2.0.0-beta8.tgz";
        name = "coffee-script-redux-2.0.0-beta8.tgz";
        sha1 = "0fd7b8417340dd0d339e8f6fd8b4b8716956e8d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script-redux" or []);
    deps = {
      "StringScanner-0.0.3" = self.by-version."StringScanner"."0.0.3";
      "nopt-2.1.2" = self.by-version."nopt"."2.1.2";
      "esmangle-0.0.17" = self.by-version."esmangle"."0.0.17";
      "source-map-0.1.11" = self.by-version."source-map"."0.1.11";
      "escodegen-0.0.28" = self.by-version."escodegen"."0.0.28";
      "cscodegen-0.1.0" = self.by-version."cscodegen"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script-redux" ];
  };
  by-spec."collections".">=2.0.1 <3.0.0" =
    self.by-version."collections"."2.0.1";
  by-version."collections"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "collections-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/collections/-/collections-2.0.1.tgz";
        name = "collections-2.0.1.tgz";
        sha1 = "ee201b142bd1ee5b37a95d62fe13062d87d83db0";
      })
    ];
    buildInputs =
      (self.nativeDeps."collections" or []);
    deps = {
      "weak-map-1.0.5" = self.by-version."weak-map"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "collections" ];
  };
  by-spec."color"."~0.7.1" =
    self.by-version."color"."0.7.3";
  by-version."color"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "color-0.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color/-/color-0.7.3.tgz";
        name = "color-0.7.3.tgz";
        sha1 = "ab3ae4bc6cb8cfadb5d749c40f34aea088104f89";
      })
    ];
    buildInputs =
      (self.nativeDeps."color" or []);
    deps = {
      "color-convert-0.5.2" = self.by-version."color-convert"."0.5.2";
      "color-string-0.2.1" = self.by-version."color-string"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "color" ];
  };
  by-spec."color-convert"."0.5.x" =
    self.by-version."color-convert"."0.5.2";
  by-version."color-convert"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "color-convert-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-convert/-/color-convert-0.5.2.tgz";
        name = "color-convert-0.5.2.tgz";
        sha1 = "febd9efc33674df3374ff8eeaec3bc56c79a9b35";
      })
    ];
    buildInputs =
      (self.nativeDeps."color-convert" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "color-convert" ];
  };
  by-spec."color-string"."0.2.x" =
    self.by-version."color-string"."0.2.1";
  by-version."color-string"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "color-string-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-string/-/color-string-0.2.1.tgz";
        name = "color-string-0.2.1.tgz";
        sha1 = "2f3c1e6c1d04ddf751633b28db7fbc152055d34e";
      })
    ];
    buildInputs =
      (self.nativeDeps."color-string" or []);
    deps = {
      "color-convert-0.5.2" = self.by-version."color-convert"."0.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "color-string" ];
  };
  by-spec."colors"."0.5.x" =
    self.by-version."colors"."0.5.1";
  by-version."colors"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.5.1.tgz";
        name = "colors-0.5.1.tgz";
        sha1 = "7d0023eaeb154e8ee9fce75dcb923d0ed1667774";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        name = "colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  by-spec."colors"."0.x.x" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."~0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."columnify"."~1.2.1" =
    self.by-version."columnify"."1.2.1";
  by-version."columnify"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "columnify-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/columnify/-/columnify-1.2.1.tgz";
        name = "columnify-1.2.1.tgz";
        sha1 = "921ec51c178f4126d3c07e9acecd67a55c7953e4";
      })
    ];
    buildInputs =
      (self.nativeDeps."columnify" or []);
    deps = {
      "strip-ansi-1.0.0" = self.by-version."strip-ansi"."1.0.0";
      "wcwidth-1.0.0" = self.by-version."wcwidth"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "columnify" ];
  };
  by-spec."combine-source-map"."~0.3.0" =
    self.by-version."combine-source-map"."0.3.0";
  by-version."combine-source-map"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "combine-source-map-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combine-source-map/-/combine-source-map-0.3.0.tgz";
        name = "combine-source-map-0.3.0.tgz";
        sha1 = "d9e74f593d9cd43807312cb5d846d451efaa9eb7";
      })
    ];
    buildInputs =
      (self.nativeDeps."combine-source-map" or []);
    deps = {
      "inline-source-map-0.3.0" = self.by-version."inline-source-map"."0.3.0";
      "convert-source-map-0.3.5" = self.by-version."convert-source-map"."0.3.5";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "combine-source-map" ];
  };
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.5";
  by-version."combined-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "combined-stream-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.5.tgz";
        name = "combined-stream-0.0.5.tgz";
        sha1 = "29ed76e5c9aad07c4acf9ca3d32601cce28697a2";
      })
    ];
    buildInputs =
      (self.nativeDeps."combined-stream" or []);
    deps = {
      "delayed-stream-0.0.5" = self.by-version."delayed-stream"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "combined-stream" ];
  };
  by-spec."commander"."0.6.1" =
    self.by-version."commander"."0.6.1";
  by-version."commander"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
        name = "commander-0.6.1.tgz";
        sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."1.3.1" =
    self.by-version."commander"."1.3.1";
  by-version."commander"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-1.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-1.3.1.tgz";
        name = "commander-1.3.1.tgz";
        sha1 = "02443e02db96f4b32b674225451abb6e9510000e";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
      "keypress-0.1.0" = self.by-version."keypress"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."1.3.2" =
    self.by-version."commander"."1.3.2";
  by-version."commander"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "commander-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-1.3.2.tgz";
        name = "commander-1.3.2.tgz";
        sha1 = "8a8f30ec670a6fdd64af52f1914b907d79ead5b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
      "keypress-0.1.0" = self.by-version."keypress"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.0.0" =
    self.by-version."commander"."2.0.0";
  by-version."commander"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.0.0.tgz";
        name = "commander-2.0.0.tgz";
        sha1 = "d1b86f901f8b64bd941bdeadaf924530393be928";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.1.0" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
        name = "commander-2.1.0.tgz";
        sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.2.x" =
    self.by-version."commander"."2.2.0";
  by-version."commander"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.2.0.tgz";
        name = "commander-2.2.0.tgz";
        sha1 = "175ad4b9317f3ff615f201c1e57224f55a3e91df";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.3.0" =
    self.by-version."commander"."2.3.0";
  by-version."commander"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.3.0.tgz";
        name = "commander-2.3.0.tgz";
        sha1 = "fd430e889832ec353b9acd1de217c11cb3eef873";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.x" =
    self.by-version."commander"."2.4.0";
  by-version."commander"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.4.0.tgz";
        name = "commander-2.4.0.tgz";
        sha1 = "fad884ce8f09509b10a5ec931332cb97786e2fd6";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."~2.0.0" =
    self.by-version."commander"."2.0.0";
  by-spec."commander"."~2.1.0" =
    self.by-version."commander"."2.1.0";
  by-spec."commondir"."0.0.1" =
    self.by-version."commondir"."0.0.1";
  by-version."commondir"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "commondir-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commondir/-/commondir-0.0.1.tgz";
        name = "commondir-0.0.1.tgz";
        sha1 = "89f00fdcd51b519c578733fec563e6a6da7f5be2";
      })
    ];
    buildInputs =
      (self.nativeDeps."commondir" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commondir" ];
  };
  by-spec."component-emitter"."1.1.2" =
    self.by-version."component-emitter"."1.1.2";
  by-version."component-emitter"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "component-emitter-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/component-emitter/-/component-emitter-1.1.2.tgz";
        name = "component-emitter-1.1.2.tgz";
        sha1 = "296594f2753daa63996d2af08d15a95116c9aec3";
      })
    ];
    buildInputs =
      (self.nativeDeps."component-emitter" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "component-emitter" ];
  };
  by-spec."compress-commons"."~0.1.0" =
    self.by-version."compress-commons"."0.1.6";
  by-version."compress-commons"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "compress-commons-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compress-commons/-/compress-commons-0.1.6.tgz";
        name = "compress-commons-0.1.6.tgz";
        sha1 = "0c740870fde58cba516f0ac0c822e33a0b85dfa3";
      })
    ];
    buildInputs =
      (self.nativeDeps."compress-commons" or []);
    deps = {
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
      "crc32-stream-0.3.1" = self.by-version."crc32-stream"."0.3.1";
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compress-commons" ];
  };
  by-spec."compressible"."~2.0.1" =
    self.by-version."compressible"."2.0.1";
  by-version."compressible"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "compressible-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compressible/-/compressible-2.0.1.tgz";
        name = "compressible-2.0.1.tgz";
        sha1 = "3550115793eb3435f7eb16775afe05df1a333ebc";
      })
    ];
    buildInputs =
      (self.nativeDeps."compressible" or []);
    deps = {
      "mime-db-1.1.1" = self.by-version."mime-db"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compressible" ];
  };
  by-spec."compression"."~1.2.0" =
    self.by-version."compression"."1.2.0";
  by-version."compression"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "compression-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compression/-/compression-1.2.0.tgz";
        name = "compression-1.2.0.tgz";
        sha1 = "c6951ca9ad90588ada7617da693c6bbbe8736866";
      })
    ];
    buildInputs =
      (self.nativeDeps."compression" or []);
    deps = {
      "accepts-1.1.2" = self.by-version."accepts"."1.1.2";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "compressible-2.0.1" = self.by-version."compressible"."2.0.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compression" ];
  };
  by-spec."concat-stream"."^1.4.1" =
    self.by-version."concat-stream"."1.4.6";
  by-version."concat-stream"."1.4.6" = lib.makeOverridable self.buildNodePackage {
    name = "concat-stream-1.4.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/concat-stream/-/concat-stream-1.4.6.tgz";
        name = "concat-stream-1.4.6.tgz";
        sha1 = "8cb736a556a32f020f1ddc82fa3448381c5e5cce";
      })
    ];
    buildInputs =
      (self.nativeDeps."concat-stream" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "concat-stream" ];
  };
  by-spec."concat-stream"."~1.4.1" =
    self.by-version."concat-stream"."1.4.6";
  by-spec."concat-stream"."~1.4.5" =
    self.by-version."concat-stream"."1.4.6";
  by-spec."config"."0.4.15" =
    self.by-version."config"."0.4.15";
  by-version."config"."0.4.15" = lib.makeOverridable self.buildNodePackage {
    name = "config-0.4.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/config/-/config-0.4.15.tgz";
        name = "config-0.4.15.tgz";
        sha1 = "d43ddf58b8df5637fdd1314fc816ccae7bfbcd18";
      })
    ];
    buildInputs =
      (self.nativeDeps."config" or []);
    deps = {
      "js-yaml-0.3.7" = self.by-version."js-yaml"."0.3.7";
      "coffee-script-1.8.0" = self.by-version."coffee-script"."1.8.0";
      "vows-0.7.0" = self.by-version."vows"."0.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "config" ];
  };
  by-spec."config-chain"."~1.1.1" =
    self.by-version."config-chain"."1.1.8";
  by-version."config-chain"."1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "config-chain-1.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/config-chain/-/config-chain-1.1.8.tgz";
        name = "config-chain-1.1.8.tgz";
        sha1 = "0943d0b7227213a20d4eaff4434f4a1c0a052cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."config-chain" or []);
    deps = {
      "proto-list-1.2.3" = self.by-version."proto-list"."1.2.3";
      "ini-1.3.0" = self.by-version."ini"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "config-chain" ];
  };
  by-spec."config-chain"."~1.1.8" =
    self.by-version."config-chain"."1.1.8";
  by-spec."configstore"."^0.3.0" =
    self.by-version."configstore"."0.3.1";
  by-version."configstore"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "configstore-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/configstore/-/configstore-0.3.1.tgz";
        name = "configstore-0.3.1.tgz";
        sha1 = "e1b4715994fe5f8e22e69b21d54c7a448339314d";
      })
    ];
    buildInputs =
      (self.nativeDeps."configstore" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "js-yaml-3.0.2" = self.by-version."js-yaml"."3.0.2";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "object-assign-0.3.1" = self.by-version."object-assign"."0.3.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "uuid-1.4.2" = self.by-version."uuid"."1.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "configstore" ];
  };
  by-spec."configstore"."^0.3.1" =
    self.by-version."configstore"."0.3.1";
  by-spec."connect"."1.x" =
    self.by-version."connect"."1.9.2";
  by-version."connect"."1.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "connect-1.9.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-1.9.2.tgz";
        name = "connect-1.9.2.tgz";
        sha1 = "42880a22e9438ae59a8add74e437f58ae8e52807";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "qs-2.2.4" = self.by-version."qs"."2.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "formidable-1.0.15" = self.by-version."formidable"."1.0.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.11.0" =
    self.by-version."connect"."2.11.0";
  by-version."connect"."2.11.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.11.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.11.0.tgz";
        name = "connect-2.11.0.tgz";
        sha1 = "9991ce09ff9b85d9ead27f9d41d0b2a2df2f9284";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "qs-0.6.5" = self.by-version."qs"."0.6.5";
      "cookie-signature-1.0.1" = self.by-version."cookie-signature"."1.0.1";
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "send-0.1.4" = self.by-version."send"."0.1.4";
      "bytes-0.2.1" = self.by-version."bytes"."0.2.1";
      "fresh-0.2.0" = self.by-version."fresh"."0.2.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
      "uid2-0.0.3" = self.by-version."uid2"."0.0.3";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "methods-0.0.1" = self.by-version."methods"."0.0.1";
      "raw-body-0.0.3" = self.by-version."raw-body"."0.0.3";
      "negotiator-0.3.0" = self.by-version."negotiator"."0.3.0";
      "multiparty-2.2.0" = self.by-version."multiparty"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.27.0" =
    self.by-version."connect"."2.27.0";
  by-version."connect"."2.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.27.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.27.0.tgz";
        name = "connect-2.27.0.tgz";
        sha1 = "04a2922c7cbe12455c9466f93bd719c37c433dfa";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "basic-auth-connect-1.0.0" = self.by-version."basic-auth-connect"."1.0.0";
      "body-parser-1.9.0" = self.by-version."body-parser"."1.9.0";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-parser-1.3.3" = self.by-version."cookie-parser"."1.3.3";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "compression-1.2.0" = self.by-version."compression"."1.2.0";
      "connect-timeout-1.4.0" = self.by-version."connect-timeout"."1.4.0";
      "csurf-1.6.2" = self.by-version."csurf"."1.6.2";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "errorhandler-1.2.2" = self.by-version."errorhandler"."1.2.2";
      "express-session-1.9.0" = self.by-version."express-session"."1.9.0";
      "finalhandler-0.3.1" = self.by-version."finalhandler"."0.3.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "method-override-2.3.0" = self.by-version."method-override"."2.3.0";
      "morgan-1.4.0" = self.by-version."morgan"."1.4.0";
      "multiparty-3.3.2" = self.by-version."multiparty"."3.3.2";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "qs-2.2.4" = self.by-version."qs"."2.2.4";
      "response-time-2.2.0" = self.by-version."response-time"."2.2.0";
      "serve-favicon-2.1.6" = self.by-version."serve-favicon"."2.1.6";
      "serve-index-1.5.0" = self.by-version."serve-index"."1.5.0";
      "serve-static-1.7.0" = self.by-version."serve-static"."1.7.0";
      "type-is-1.5.2" = self.by-version."type-is"."1.5.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vhost-3.0.0" = self.by-version."vhost"."3.0.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.3.x" =
    self.by-version."connect"."2.3.9";
  by-version."connect"."2.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.3.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.3.9.tgz";
        name = "connect-2.3.9.tgz";
        sha1 = "4d26ddc485c32e5a1cf1b35854823b4720d25a52";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "qs-0.4.2" = self.by-version."qs"."0.4.2";
      "formidable-1.0.11" = self.by-version."formidable"."1.0.11";
      "crc-0.2.0" = self.by-version."crc"."0.2.0";
      "cookie-0.0.4" = self.by-version."cookie"."0.0.4";
      "bytes-0.1.0" = self.by-version."bytes"."0.1.0";
      "send-0.0.3" = self.by-version."send"."0.0.3";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.7.5" =
    self.by-version."connect"."2.7.5";
  by-version."connect"."2.7.5" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.7.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.5.tgz";
        name = "connect-2.7.5.tgz";
        sha1 = "139111b4b03f0533a524927a88a646ae467b2c02";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "qs-0.5.1" = self.by-version."qs"."0.5.1";
      "formidable-1.0.11" = self.by-version."formidable"."1.0.11";
      "cookie-signature-1.0.0" = self.by-version."cookie-signature"."1.0.0";
      "buffer-crc32-0.1.1" = self.by-version."buffer-crc32"."0.1.1";
      "cookie-0.0.5" = self.by-version."cookie"."0.0.5";
      "send-0.1.0" = self.by-version."send"."0.1.0";
      "bytes-0.2.0" = self.by-version."bytes"."0.2.0";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.7.6" =
    self.by-version."connect"."2.7.6";
  by-version."connect"."2.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.7.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.6.tgz";
        name = "connect-2.7.6.tgz";
        sha1 = "b83b68fa6f245c5020e2395472cc8322b0060738";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "qs-0.5.1" = self.by-version."qs"."0.5.1";
      "formidable-1.0.11" = self.by-version."formidable"."1.0.11";
      "cookie-signature-1.0.1" = self.by-version."cookie-signature"."1.0.1";
      "buffer-crc32-0.1.1" = self.by-version."buffer-crc32"."0.1.1";
      "cookie-0.0.5" = self.by-version."cookie"."0.0.5";
      "send-0.1.0" = self.by-version."send"."0.1.0";
      "bytes-0.2.0" = self.by-version."bytes"."0.2.0";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."~2" =
    self.by-version."connect"."2.27.0";
  by-spec."connect"."~2.12.0" =
    self.by-version."connect"."2.12.0";
  by-version."connect"."2.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.12.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.12.0.tgz";
        name = "connect-2.12.0.tgz";
        sha1 = "31d8fa0dcacdf1908d822bd2923be8a2d2a7ed9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "batch-0.5.0" = self.by-version."batch"."0.5.0";
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "cookie-signature-1.0.1" = self.by-version."cookie-signature"."1.0.1";
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "send-0.1.4" = self.by-version."send"."0.1.4";
      "bytes-0.2.1" = self.by-version."bytes"."0.2.1";
      "fresh-0.2.0" = self.by-version."fresh"."0.2.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
      "uid2-0.0.3" = self.by-version."uid2"."0.0.3";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
      "methods-0.1.0" = self.by-version."methods"."0.1.0";
      "raw-body-1.1.2" = self.by-version."raw-body"."1.1.2";
      "negotiator-0.3.0" = self.by-version."negotiator"."0.3.0";
      "multiparty-2.2.0" = self.by-version."multiparty"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect-flash"."*" =
    self.by-version."connect-flash"."0.1.1";
  by-version."connect-flash"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "connect-flash-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-flash/-/connect-flash-0.1.1.tgz";
        name = "connect-flash-0.1.1.tgz";
        sha1 = "d8630f26d95a7f851f9956b1e8cc6732f3b6aa30";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-flash" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-flash" ];
  };
  "connect-flash" = self.by-version."connect-flash"."0.1.1";
  by-spec."connect-flash"."0.1.0" =
    self.by-version."connect-flash"."0.1.0";
  by-version."connect-flash"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-flash-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-flash/-/connect-flash-0.1.0.tgz";
        name = "connect-flash-0.1.0.tgz";
        sha1 = "82b381d61a12b651437df1c259c1f1c841239b88";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-flash" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-flash" ];
  };
  by-spec."connect-jade-static"."*" =
    self.by-version."connect-jade-static"."0.1.3";
  by-version."connect-jade-static"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "connect-jade-static-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-jade-static/-/connect-jade-static-0.1.3.tgz";
        name = "connect-jade-static-0.1.3.tgz";
        sha1 = "ad0e0538c9124355d6da03de13fae63f7b5e0b1b";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-jade-static" or []);
    deps = {
      "jade-1.7.0" = self.by-version."jade"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-jade-static" ];
  };
  "connect-jade-static" = self.by-version."connect-jade-static"."0.1.3";
  by-spec."connect-mongo"."*" =
    self.by-version."connect-mongo"."0.4.1";
  by-version."connect-mongo"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "connect-mongo-0.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-mongo/-/connect-mongo-0.4.1.tgz";
        name = "connect-mongo-0.4.1.tgz";
        sha1 = "01ed3e71558fb3f0fdc97b784ef974f9909ddd11";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-mongo" or []);
    deps = {
      "mongodb-1.3.23" = self.by-version."mongodb"."1.3.23";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-mongo" ];
  };
  "connect-mongo" = self.by-version."connect-mongo"."0.4.1";
  by-spec."connect-timeout"."~1.4.0" =
    self.by-version."connect-timeout"."1.4.0";
  by-version."connect-timeout"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-timeout-1.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-timeout/-/connect-timeout-1.4.0.tgz";
        name = "connect-timeout-1.4.0.tgz";
        sha1 = "b8003ea155abd18bbdd8a19c91e5284ddc2e465e";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-timeout" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-timeout" ];
  };
  by-spec."connection-parse"."0.0.x" =
    self.by-version."connection-parse"."0.0.7";
  by-version."connection-parse"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "connection-parse-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connection-parse/-/connection-parse-0.0.7.tgz";
        name = "connection-parse-0.0.7.tgz";
        sha1 = "18e7318aab06a699267372b10c5226d25a1c9a69";
      })
    ];
    buildInputs =
      (self.nativeDeps."connection-parse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "connection-parse" ];
  };
  by-spec."console-browserify"."1.1.x" =
    self.by-version."console-browserify"."1.1.0";
  by-version."console-browserify"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "console-browserify-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/console-browserify/-/console-browserify-1.1.0.tgz";
        name = "console-browserify-1.1.0.tgz";
        sha1 = "f0241c45730a9fc6323b206dbf38edc741d0bb10";
      })
    ];
    buildInputs =
      (self.nativeDeps."console-browserify" or []);
    deps = {
      "date-now-0.1.4" = self.by-version."date-now"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "console-browserify" ];
  };
  by-spec."console-browserify"."^1.1.0" =
    self.by-version."console-browserify"."1.1.0";
  by-spec."constantinople"."~1.0.1" =
    self.by-version."constantinople"."1.0.2";
  by-version."constantinople"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "constantinople-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constantinople/-/constantinople-1.0.2.tgz";
        name = "constantinople-1.0.2.tgz";
        sha1 = "0e64747dc836644d3f659247efd95231b48c3e71";
      })
    ];
    buildInputs =
      (self.nativeDeps."constantinople" or []);
    deps = {
      "uglify-js-2.4.15" = self.by-version."uglify-js"."2.4.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "constantinople" ];
  };
  by-spec."constantinople"."~1.0.2" =
    self.by-version."constantinople"."1.0.2";
  by-spec."constantinople"."~2.0.0" =
    self.by-version."constantinople"."2.0.1";
  by-version."constantinople"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "constantinople-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constantinople/-/constantinople-2.0.1.tgz";
        name = "constantinople-2.0.1.tgz";
        sha1 = "5829f856f301a9bdb107d935f77d8eb8ccec4c79";
      })
    ];
    buildInputs =
      (self.nativeDeps."constantinople" or []);
    deps = {
      "uglify-js-2.4.15" = self.by-version."uglify-js"."2.4.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "constantinople" ];
  };
  by-spec."constants-browserify"."~0.0.1" =
    self.by-version."constants-browserify"."0.0.1";
  by-version."constants-browserify"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "constants-browserify-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constants-browserify/-/constants-browserify-0.0.1.tgz";
        name = "constants-browserify-0.0.1.tgz";
        sha1 = "92577db527ba6c4cf0a4568d84bc031f441e21f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."constants-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "constants-browserify" ];
  };
  by-spec."content-disposition"."0.5.0" =
    self.by-version."content-disposition"."0.5.0";
  by-version."content-disposition"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "content-disposition-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/content-disposition/-/content-disposition-0.5.0.tgz";
        name = "content-disposition-0.5.0.tgz";
        sha1 = "4284fe6ae0630874639e44e80a418c2934135e9e";
      })
    ];
    buildInputs =
      (self.nativeDeps."content-disposition" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "content-disposition" ];
  };
  by-spec."convert-source-map"."~0.3.0" =
    self.by-version."convert-source-map"."0.3.5";
  by-version."convert-source-map"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "convert-source-map-0.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/convert-source-map/-/convert-source-map-0.3.5.tgz";
        name = "convert-source-map-0.3.5.tgz";
        sha1 = "f1d802950af7dd2631a1febe0596550c86ab3190";
      })
    ];
    buildInputs =
      (self.nativeDeps."convert-source-map" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "convert-source-map" ];
  };
  by-spec."cookie"."0.0.4" =
    self.by-version."cookie"."0.0.4";
  by-version."cookie"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.0.4.tgz";
        name = "cookie-0.0.4.tgz";
        sha1 = "5456bd47aee2666eac976ea80a6105940483fe98";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie"."0.0.5" =
    self.by-version."cookie"."0.0.5";
  by-version."cookie"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.0.5.tgz";
        name = "cookie-0.0.5.tgz";
        sha1 = "f9acf9db57eb7568c9fcc596256b7bb22e307c81";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie"."0.1.0" =
    self.by-version."cookie"."0.1.0";
  by-version."cookie"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.0.tgz";
        name = "cookie-0.1.0.tgz";
        sha1 = "90eb469ddce905c866de687efc43131d8801f9d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie"."0.1.2" =
    self.by-version."cookie"."0.1.2";
  by-version."cookie"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.2.tgz";
        name = "cookie-0.1.2.tgz";
        sha1 = "72fec3d24e48a3432073d90c12642005061004b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie-jar"."~0.2.0" =
    self.by-version."cookie-jar"."0.2.0";
  by-version."cookie-jar"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-jar-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.2.0.tgz";
        name = "cookie-jar-0.2.0.tgz";
        sha1 = "64ecc06ac978db795e4b5290cbe48ba3781400fa";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  by-spec."cookie-jar"."~0.3.0" =
    self.by-version."cookie-jar"."0.3.0";
  by-version."cookie-jar"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-jar-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.3.0.tgz";
        name = "cookie-jar-0.3.0.tgz";
        sha1 = "bc9a27d4e2b97e186cd57c9e2063cb99fa68cccc";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  by-spec."cookie-parser"."~1.3.2" =
    self.by-version."cookie-parser"."1.3.3";
  by-version."cookie-parser"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-parser-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-parser/-/cookie-parser-1.3.3.tgz";
        name = "cookie-parser-1.3.3.tgz";
        sha1 = "7e3a2c745f4b460d5a340e578a0baa5d7725fe37";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-parser" or []);
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-parser" ];
  };
  by-spec."cookie-parser"."~1.3.3" =
    self.by-version."cookie-parser"."1.3.3";
  by-spec."cookie-signature"."1.0.0" =
    self.by-version."cookie-signature"."1.0.0";
  by-version."cookie-signature"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.0.tgz";
        name = "cookie-signature-1.0.0.tgz";
        sha1 = "0044f332ac623df851c914e88eacc57f0c9704fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookie-signature"."1.0.1" =
    self.by-version."cookie-signature"."1.0.1";
  by-version."cookie-signature"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.1.tgz";
        name = "cookie-signature-1.0.1.tgz";
        sha1 = "44e072148af01e6e8e24afbf12690d68ae698ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookie-signature"."1.0.3" =
    self.by-version."cookie-signature"."1.0.3";
  by-version."cookie-signature"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.3.tgz";
        name = "cookie-signature-1.0.3.tgz";
        sha1 = "91cd997cc51fb641595738c69cda020328f50ff9";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookie-signature"."1.0.4" =
    self.by-version."cookie-signature"."1.0.4";
  by-version."cookie-signature"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.4.tgz";
        name = "cookie-signature-1.0.4.tgz";
        sha1 = "0edd22286e3a111b9a2a70db363e925e867f6aca";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookie-signature"."1.0.5" =
    self.by-version."cookie-signature"."1.0.5";
  by-version."cookie-signature"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.5.tgz";
        name = "cookie-signature-1.0.5.tgz";
        sha1 = "a122e3f1503eca0f5355795b0711bb2368d450f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."cookiejar"."1.3.0" =
    self.by-version."cookiejar"."1.3.0";
  by-version."cookiejar"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookiejar-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookiejar/-/cookiejar-1.3.0.tgz";
        name = "cookiejar-1.3.0.tgz";
        sha1 = "dd00b35679021e99cbd4e855b9ad041913474765";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookiejar" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookiejar" ];
  };
  by-spec."cookiejar"."2.0.1" =
    self.by-version."cookiejar"."2.0.1";
  by-version."cookiejar"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cookiejar-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookiejar/-/cookiejar-2.0.1.tgz";
        name = "cookiejar-2.0.1.tgz";
        sha1 = "3d12752f6adf68a892f332433492bd5812bb668f";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookiejar" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookiejar" ];
  };
  by-spec."cookies".">= 0.2.2" =
    self.by-version."cookies"."0.5.0";
  by-version."cookies"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookies-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookies/-/cookies-0.5.0.tgz";
        name = "cookies-0.5.0.tgz";
        sha1 = "164cac46a1d3ca3b3b87427414c24931d8381025";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookies" or []);
    deps = {
      "keygrip-1.0.1" = self.by-version."keygrip"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookies" ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "core-util-is-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
        name = "core-util-is-1.0.1.tgz";
        sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
      })
    ];
    buildInputs =
      (self.nativeDeps."core-util-is" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "core-util-is" ];
  };
  by-spec."couch-login"."~0.1.15" =
    self.by-version."couch-login"."0.1.20";
  by-version."couch-login"."0.1.20" = lib.makeOverridable self.buildNodePackage {
    name = "couch-login-0.1.20";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/couch-login/-/couch-login-0.1.20.tgz";
        name = "couch-login-0.1.20.tgz";
        sha1 = "007c70ef80089dbae6f59eeeec37480799b39595";
      })
    ];
    buildInputs =
      (self.nativeDeps."couch-login" or []);
    deps = {
      "request-2.45.0" = self.by-version."request"."2.45.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "couch-login" ];
  };
  by-spec."coveralls"."*" =
    self.by-version."coveralls"."2.11.2";
  by-version."coveralls"."2.11.2" = lib.makeOverridable self.buildNodePackage {
    name = "coveralls-2.11.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coveralls/-/coveralls-2.11.2.tgz";
        name = "coveralls-2.11.2.tgz";
        sha1 = "d4d982016cb2f9da89d77ab204d86a8537e6a12d";
      })
    ];
    buildInputs =
      (self.nativeDeps."coveralls" or []);
    deps = {
      "js-yaml-3.0.1" = self.by-version."js-yaml"."3.0.1";
      "lcov-parse-0.0.6" = self.by-version."lcov-parse"."0.0.6";
      "log-driver-1.2.4" = self.by-version."log-driver"."1.2.4";
      "request-2.40.0" = self.by-version."request"."2.40.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "coveralls" ];
  };
  "coveralls" = self.by-version."coveralls"."2.11.2";
  by-spec."crc"."0.2.0" =
    self.by-version."crc"."0.2.0";
  by-version."crc"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "crc-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc/-/crc-0.2.0.tgz";
        name = "crc-0.2.0.tgz";
        sha1 = "f4486b9bf0a12df83c3fca14e31e030fdabd9454";
      })
    ];
    buildInputs =
      (self.nativeDeps."crc" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "crc" ];
  };
  by-spec."crc"."3.0.0" =
    self.by-version."crc"."3.0.0";
  by-version."crc"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "crc-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc/-/crc-3.0.0.tgz";
        name = "crc-3.0.0.tgz";
        sha1 = "d11e97ec44a844e5eb15a74fa2c7875d0aac4b22";
      })
    ];
    buildInputs =
      (self.nativeDeps."crc" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "crc" ];
  };
  by-spec."crc32-stream"."~0.3.1" =
    self.by-version."crc32-stream"."0.3.1";
  by-version."crc32-stream"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "crc32-stream-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc32-stream/-/crc32-stream-0.3.1.tgz";
        name = "crc32-stream-0.3.1.tgz";
        sha1 = "615fcf05ed08342a3d1e938041aed84430ce7837";
      })
    ];
    buildInputs =
      (self.nativeDeps."crc32-stream" or []);
    deps = {
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "crc32-stream" ];
  };
  by-spec."crossroads"."~0.12.0" =
    self.by-version."crossroads"."0.12.0";
  by-version."crossroads"."0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "crossroads-0.12.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crossroads/-/crossroads-0.12.0.tgz";
        name = "crossroads-0.12.0.tgz";
        sha1 = "24114f9de3abfa0271df66b4ec56c3b984b7f56e";
      })
    ];
    buildInputs =
      (self.nativeDeps."crossroads" or []);
    deps = {
      "signals-1.0.0" = self.by-version."signals"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "crossroads" ];
  };
  by-spec."cryptiles"."0.1.x" =
    self.by-version."cryptiles"."0.1.3";
  by-version."cryptiles"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.1.3.tgz";
        name = "cryptiles-0.1.3.tgz";
        sha1 = "1a556734f06d24ba34862ae9cb9e709a3afbff1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = {
      "boom-0.3.8" = self.by-version."boom"."0.3.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
        name = "cryptiles-0.2.2.tgz";
        sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = {
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."crypto"."0.0.3" =
    self.by-version."crypto"."0.0.3";
  by-version."crypto"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "crypto-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crypto/-/crypto-0.0.3.tgz";
        name = "crypto-0.0.3.tgz";
        sha1 = "470a81b86be4c5ee17acc8207a1f5315ae20dbb0";
      })
    ];
    buildInputs =
      (self.nativeDeps."crypto" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "crypto" ];
  };
  by-spec."crypto-browserify"."^3.0.0" =
    self.by-version."crypto-browserify"."3.2.8";
  by-version."crypto-browserify"."3.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "crypto-browserify-3.2.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.2.8.tgz";
        name = "crypto-browserify-3.2.8.tgz";
        sha1 = "b9b11dbe6d9651dd882a01e6cc467df718ecf189";
      })
    ];
    buildInputs =
      (self.nativeDeps."crypto-browserify" or []);
    deps = {
      "pbkdf2-compat-2.0.1" = self.by-version."pbkdf2-compat"."2.0.1";
      "ripemd160-0.2.0" = self.by-version."ripemd160"."0.2.0";
      "sha.js-2.2.6" = self.by-version."sha.js"."2.2.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "crypto-browserify" ];
  };
  by-spec."cscodegen"."git://github.com/michaelficarra/cscodegen.git#73fd7202ac086c26f18c9d56f025b18b3c6f5383" =
    self.by-version."cscodegen"."0.1.0";
  by-version."cscodegen"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "cscodegen-0.1.0";
    bin = true;
    src = [
      (fetchgit {
        url = "git://github.com/michaelficarra/cscodegen.git";
        rev = "73fd7202ac086c26f18c9d56f025b18b3c6f5383";
        sha256 = "cb527b00ac305ebc6ab3f59ff4e99def7646b417fdd9e35f0186c8ee41cd0829";
      })
    ];
    buildInputs =
      (self.nativeDeps."cscodegen" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cscodegen" ];
  };
  by-spec."csrf"."~2.0.1" =
    self.by-version."csrf"."2.0.1";
  by-version."csrf"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "csrf-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csrf/-/csrf-2.0.1.tgz";
        name = "csrf-2.0.1.tgz";
        sha1 = "d673a2efb4db7d0e6805dadd838c57e30ae0ee73";
      })
    ];
    buildInputs =
      (self.nativeDeps."csrf" or []);
    deps = {
      "rndm-1.0.0" = self.by-version."rndm"."1.0.0";
      "scmp-0.0.3" = self.by-version."scmp"."0.0.3";
      "uid-safe-1.0.1" = self.by-version."uid-safe"."1.0.1";
      "base64-url-1.0.0" = self.by-version."base64-url"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "csrf" ];
  };
  by-spec."css"."~1.0.8" =
    self.by-version."css"."1.0.8";
  by-version."css"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "css-1.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css/-/css-1.0.8.tgz";
        name = "css-1.0.8.tgz";
        sha1 = "9386811ca82bccc9ee7fb5a732b1e2a317c8a3e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."css" or []);
    deps = {
      "css-parse-1.0.4" = self.by-version."css-parse"."1.0.4";
      "css-stringify-1.0.5" = self.by-version."css-stringify"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "css" ];
  };
  by-spec."css-parse"."1.0.4" =
    self.by-version."css-parse"."1.0.4";
  by-version."css-parse"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "css-parse-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-parse/-/css-parse-1.0.4.tgz";
        name = "css-parse-1.0.4.tgz";
        sha1 = "38b0503fbf9da9f54e9c1dbda60e145c77117bdd";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-parse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "css-parse" ];
  };
  by-spec."css-parse"."1.7.x" =
    self.by-version."css-parse"."1.7.0";
  by-version."css-parse"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "css-parse-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-parse/-/css-parse-1.7.0.tgz";
        name = "css-parse-1.7.0.tgz";
        sha1 = "321f6cf73782a6ff751111390fc05e2c657d8c9b";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-parse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "css-parse" ];
  };
  by-spec."css-stringify"."1.0.5" =
    self.by-version."css-stringify"."1.0.5";
  by-version."css-stringify"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "css-stringify-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-stringify/-/css-stringify-1.0.5.tgz";
        name = "css-stringify-1.0.5.tgz";
        sha1 = "b0d042946db2953bb9d292900a6cb5f6d0122031";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-stringify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "css-stringify" ];
  };
  by-spec."csurf"."~1.6.2" =
    self.by-version."csurf"."1.6.2";
  by-version."csurf"."1.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "csurf-1.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csurf/-/csurf-1.6.2.tgz";
        name = "csurf-1.6.2.tgz";
        sha1 = "e732b7478b4bef654337fd8bb363d0422a71d9f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."csurf" or []);
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "csrf-2.0.1" = self.by-version."csrf"."2.0.1";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "csurf" ];
  };
  by-spec."ctype"."0.5.0" =
    self.by-version."ctype"."0.5.0";
  by-version."ctype"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.0.tgz";
        name = "ctype-0.5.0.tgz";
        sha1 = "672673ec67587eb495c1ed694da1abb964ff65e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  by-spec."ctype"."0.5.2" =
    self.by-version."ctype"."0.5.2";
  by-version."ctype"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
        name = "ctype-0.5.2.tgz";
        sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "cycle-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
        name = "cycle-1.0.3.tgz";
        sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
      })
    ];
    buildInputs =
      (self.nativeDeps."cycle" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cycle" ];
  };
  by-spec."d"."~0.1.1" =
    self.by-version."d"."0.1.1";
  by-version."d"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "d-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/d/-/d-0.1.1.tgz";
        name = "d-0.1.1.tgz";
        sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
      })
    ];
    buildInputs =
      (self.nativeDeps."d" or []);
    deps = {
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "d" ];
  };
  by-spec."dashdash"."1.3.2" =
    self.by-version."dashdash"."1.3.2";
  by-version."dashdash"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "dashdash-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dashdash/-/dashdash-1.3.2.tgz";
        name = "dashdash-1.3.2.tgz";
        sha1 = "1e76d13fadf25f8f50e70212c98a25beb1b3b8eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."dashdash" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dashdash" ];
  };
  by-spec."dashdash"."1.5.0" =
    self.by-version."dashdash"."1.5.0";
  by-version."dashdash"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "dashdash-1.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dashdash/-/dashdash-1.5.0.tgz";
        name = "dashdash-1.5.0.tgz";
        sha1 = "fa5aa8a9415a7c5c3928be18bd4975458e666452";
      })
    ];
    buildInputs =
      (self.nativeDeps."dashdash" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dashdash" ];
  };
  by-spec."date-now"."^0.1.4" =
    self.by-version."date-now"."0.1.4";
  by-version."date-now"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "date-now-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/date-now/-/date-now-0.1.4.tgz";
        name = "date-now-0.1.4.tgz";
        sha1 = "eaf439fd4d4848ad74e5cc7dbef200672b9e345b";
      })
    ];
    buildInputs =
      (self.nativeDeps."date-now" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "date-now" ];
  };
  by-spec."dateformat"."1.0.2-1.2.3" =
    self.by-version."dateformat"."1.0.2-1.2.3";
  by-version."dateformat"."1.0.2-1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "dateformat-1.0.2-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.2-1.2.3.tgz";
        name = "dateformat-1.0.2-1.2.3.tgz";
        sha1 = "b0220c02de98617433b72851cf47de3df2cdbee9";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  by-spec."dateformat"."^1.0.7-1.2.3" =
    self.by-version."dateformat"."1.0.8";
  by-version."dateformat"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "dateformat-1.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.8.tgz";
        name = "dateformat-1.0.8.tgz";
        sha1 = "87799a3de21bffbf028bdd7ad044981327ac0a26";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  by-spec."dateformat"."~1.0.6" =
    self.by-version."dateformat"."1.0.8";
  by-spec."debug"."*" =
    self.by-version."debug"."2.1.0";
  by-version."debug"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-2.1.0.tgz";
        name = "debug-2.1.0.tgz";
        sha1 = "33ab915659d8c2cc8a41443d94d6ebd37697ed21";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."0.5.0" =
    self.by-version."debug"."0.5.0";
  by-version."debug"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.5.0.tgz";
        name = "debug-0.5.0.tgz";
        sha1 = "9d48c946fb7d7d59807ffe07822f515fd76d7a9e";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."0.7.4" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
        name = "debug-0.7.4.tgz";
        sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."1.0.4" =
    self.by-version."debug"."1.0.4";
  by-version."debug"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "debug-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-1.0.4.tgz";
        name = "debug-1.0.4.tgz";
        sha1 = "5b9c256bd54b6ec02283176fa8a0ede6d154cbf8";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."2.0.0" =
    self.by-version."debug"."2.0.0";
  by-version."debug"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-2.0.0.tgz";
        name = "debug-2.0.0.tgz";
        sha1 = "89bd9df6732b51256bc6705342bba02ed12131ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug".">= 0.7.3 < 1" =
    self.by-version."debug"."0.8.1";
  by-version."debug"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.8.1.tgz";
        name = "debug-0.8.1.tgz";
        sha1 = "20ff4d26f5e422cb68a1bacbbb61039ad8c1c130";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."^1.0.2" =
    self.by-version."debug"."1.0.4";
  by-spec."debug"."~0.8" =
    self.by-version."debug"."0.8.1";
  by-spec."debug"."~1.0.1" =
    self.by-version."debug"."1.0.4";
  by-spec."debug"."~2.0.0" =
    self.by-version."debug"."2.0.0";
  by-spec."debug"."~2.1.0" =
    self.by-version."debug"."2.1.0";
  by-spec."debuglog"."^1.0.1" =
    self.by-version."debuglog"."1.0.1";
  by-version."debuglog"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "debuglog-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debuglog/-/debuglog-1.0.1.tgz";
        name = "debuglog-1.0.1.tgz";
        sha1 = "aa24ffb9ac3df9a2351837cfb2d279360cd78492";
      })
    ];
    buildInputs =
      (self.nativeDeps."debuglog" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "debuglog" ];
  };
  by-spec."decompress-zip"."0.0.8" =
    self.by-version."decompress-zip"."0.0.8";
  by-version."decompress-zip"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "decompress-zip-0.0.8";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decompress-zip/-/decompress-zip-0.0.8.tgz";
        name = "decompress-zip-0.0.8.tgz";
        sha1 = "4a265b22c7b209d7b24fa66f2b2dfbced59044f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."decompress-zip" or []);
    deps = {
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "mkpath-0.1.0" = self.by-version."mkpath"."0.1.0";
      "binary-0.3.0" = self.by-version."binary"."0.3.0";
      "touch-0.0.2" = self.by-version."touch"."0.0.2";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "decompress-zip" ];
  };
  by-spec."deep-eql"."0.1.3" =
    self.by-version."deep-eql"."0.1.3";
  by-version."deep-eql"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "deep-eql-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-eql/-/deep-eql-0.1.3.tgz";
        name = "deep-eql-0.1.3.tgz";
        sha1 = "ef558acab8de25206cd713906d74e56930eb69f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-eql" or []);
    deps = {
      "type-detect-0.1.1" = self.by-version."type-detect"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-eql" ];
  };
  by-spec."deep-equal"."*" =
    self.by-version."deep-equal"."0.2.1";
  by-version."deep-equal"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.1.tgz";
        name = "deep-equal-0.2.1.tgz";
        sha1 = "fad7a793224cbf0c3c7786f92ef780e4fc8cc878";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  by-spec."deep-equal"."0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-version."deep-equal"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.0.0.tgz";
        name = "deep-equal-0.0.0.tgz";
        sha1 = "99679d3bbd047156fcd450d3d01eeb9068691e83";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  by-spec."deep-equal"."~0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-spec."deep-equal"."~0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-spec."deep-extend"."~0.2.11" =
    self.by-version."deep-extend"."0.2.11";
  by-version."deep-extend"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "deep-extend-0.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.11.tgz";
        name = "deep-extend-0.2.11.tgz";
        sha1 = "7a16ba69729132340506170494bc83f7076fe08f";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-extend" ];
  };
  by-spec."deep-extend"."~0.2.5" =
    self.by-version."deep-extend"."0.2.11";
  by-spec."deepmerge"."*" =
    self.by-version."deepmerge"."0.2.7";
  by-version."deepmerge"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "deepmerge-0.2.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deepmerge/-/deepmerge-0.2.7.tgz";
        name = "deepmerge-0.2.7.tgz";
        sha1 = "3a5ab8d37311c4d1aefb22209693afe0a91a0563";
      })
    ];
    buildInputs =
      (self.nativeDeps."deepmerge" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deepmerge" ];
  };
  "deepmerge" = self.by-version."deepmerge"."0.2.7";
  by-spec."defaults"."^1.0.0" =
    self.by-version."defaults"."1.0.0";
  by-version."defaults"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "defaults-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/defaults/-/defaults-1.0.0.tgz";
        name = "defaults-1.0.0.tgz";
        sha1 = "3ae25f44416c6c01f9809a25fcdd285912d2a6b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."defaults" or []);
    deps = {
      "clone-0.1.18" = self.by-version."clone"."0.1.18";
    };
    peerDependencies = [
    ];
    passthru.names = [ "defaults" ];
  };
  by-spec."defined"."~0.0.0" =
    self.by-version."defined"."0.0.0";
  by-version."defined"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "defined-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/defined/-/defined-0.0.0.tgz";
        name = "defined-0.0.0.tgz";
        sha1 = "f35eea7d705e933baf13b2f03b3f83d921403b3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."defined" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "defined" ];
  };
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "delayed-stream-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
        name = "delayed-stream-0.0.5.tgz";
        sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
      })
    ];
    buildInputs =
      (self.nativeDeps."delayed-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "delayed-stream" ];
  };
  by-spec."depd"."0.4.4" =
    self.by-version."depd"."0.4.4";
  by-version."depd"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "depd-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/depd/-/depd-0.4.4.tgz";
        name = "depd-0.4.4.tgz";
        sha1 = "07091fae75f97828d89b4a02a2d4778f0e7c0662";
      })
    ];
    buildInputs =
      (self.nativeDeps."depd" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "depd" ];
  };
  by-spec."depd"."0.4.5" =
    self.by-version."depd"."0.4.5";
  by-version."depd"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "depd-0.4.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/depd/-/depd-0.4.5.tgz";
        name = "depd-0.4.5.tgz";
        sha1 = "1a664b53388b4a6573e8ae67b5f767c693ca97f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."depd" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "depd" ];
  };
  by-spec."depd"."~1.0.0" =
    self.by-version."depd"."1.0.0";
  by-version."depd"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "depd-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/depd/-/depd-1.0.0.tgz";
        name = "depd-1.0.0.tgz";
        sha1 = "2fda0d00e98aae2845d4991ab1bf1f2a199073d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."depd" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "depd" ];
  };
  by-spec."deprecated"."^0.0.1" =
    self.by-version."deprecated"."0.0.1";
  by-version."deprecated"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "deprecated-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deprecated/-/deprecated-0.0.1.tgz";
        name = "deprecated-0.0.1.tgz";
        sha1 = "f9c9af5464afa1e7a971458a8bdef2aa94d5bb19";
      })
    ];
    buildInputs =
      (self.nativeDeps."deprecated" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deprecated" ];
  };
  by-spec."deps-sort"."^1.3.5" =
    self.by-version."deps-sort"."1.3.5";
  by-version."deps-sort"."1.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "deps-sort-1.3.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deps-sort/-/deps-sort-1.3.5.tgz";
        name = "deps-sort-1.3.5.tgz";
        sha1 = "89dc3c323504080558f9909bf57df1f7837c5c6f";
      })
    ];
    buildInputs =
      (self.nativeDeps."deps-sort" or []);
    deps = {
      "JSONStream-0.8.4" = self.by-version."JSONStream"."0.8.4";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "minimist-0.2.0" = self.by-version."minimist"."0.2.0";
      "shasum-1.0.0" = self.by-version."shasum"."1.0.0";
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "deps-sort" ];
  };
  by-spec."destroy"."1.0.3" =
    self.by-version."destroy"."1.0.3";
  by-version."destroy"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "destroy-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
        name = "destroy-1.0.3.tgz";
        sha1 = "b433b4724e71fd8551d9885174851c5fc377e2c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."destroy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "destroy" ];
  };
  by-spec."detective"."^3.1.0" =
    self.by-version."detective"."3.1.0";
  by-version."detective"."3.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "detective-3.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/detective/-/detective-3.1.0.tgz";
        name = "detective-3.1.0.tgz";
        sha1 = "77782444ab752b88ca1be2e9d0a0395f1da25eed";
      })
    ];
    buildInputs =
      (self.nativeDeps."detective" or []);
    deps = {
      "escodegen-1.1.0" = self.by-version."escodegen"."1.1.0";
      "esprima-fb-3001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
    };
    peerDependencies = [
    ];
    passthru.names = [ "detective" ];
  };
  by-spec."dezalgo"."^1.0.0" =
    self.by-version."dezalgo"."1.0.1";
  by-version."dezalgo"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "dezalgo-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dezalgo/-/dezalgo-1.0.1.tgz";
        name = "dezalgo-1.0.1.tgz";
        sha1 = "12bde135060807900d5a7aebb607c2abb7c76937";
      })
    ];
    buildInputs =
      (self.nativeDeps."dezalgo" or []);
    deps = {
      "asap-1.0.0" = self.by-version."asap"."1.0.0";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dezalgo" ];
  };
  by-spec."dezalgo"."^1.0.1" =
    self.by-version."dezalgo"."1.0.1";
  by-spec."dezalgo"."~1.0.1" =
    self.by-version."dezalgo"."1.0.1";
  by-spec."di"."~0.0.1" =
    self.by-version."di"."0.0.1";
  by-version."di"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "di-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/di/-/di-0.0.1.tgz";
        name = "di-0.0.1.tgz";
        sha1 = "806649326ceaa7caa3306d75d985ea2748ba913c";
      })
    ];
    buildInputs =
      (self.nativeDeps."di" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "di" ];
  };
  by-spec."diff"."1.0.7" =
    self.by-version."diff"."1.0.7";
  by-version."diff"."1.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "diff-1.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.7.tgz";
        name = "diff-1.0.7.tgz";
        sha1 = "24bbb001c4a7d5522169e7cabdb2c2814ed91cf4";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  by-spec."diff"."1.0.8" =
    self.by-version."diff"."1.0.8";
  by-version."diff"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "diff-1.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.8.tgz";
        name = "diff-1.0.8.tgz";
        sha1 = "343276308ec991b7bc82267ed55bc1411f971666";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  by-spec."diff"."~1.0.3" =
    self.by-version."diff"."1.0.8";
  by-spec."diff"."~1.0.7" =
    self.by-version."diff"."1.0.8";
  by-spec."director"."1.1.10" =
    self.by-version."director"."1.1.10";
  by-version."director"."1.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "director-1.1.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/director/-/director-1.1.10.tgz";
        name = "director-1.1.10.tgz";
        sha1 = "e6c1d64f2f079216f19ea83b566035dde9901179";
      })
    ];
    buildInputs =
      (self.nativeDeps."director" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "director" ];
  };
  by-spec."director"."1.2.3" =
    self.by-version."director"."1.2.3";
  by-version."director"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "director-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/director/-/director-1.2.3.tgz";
        name = "director-1.2.3.tgz";
        sha1 = "ba68a09312751bb77c52acc75e1f9fd9d3cb15bf";
      })
    ];
    buildInputs =
      (self.nativeDeps."director" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "director" ];
  };
  by-spec."dkim-signer"."~0.1.1" =
    self.by-version."dkim-signer"."0.1.2";
  by-version."dkim-signer"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "dkim-signer-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dkim-signer/-/dkim-signer-0.1.2.tgz";
        name = "dkim-signer-0.1.2.tgz";
        sha1 = "2ff5d61c87d8fbff5a8b131cffc5ec3ba1c25553";
      })
    ];
    buildInputs =
      (self.nativeDeps."dkim-signer" or []);
    deps = {
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
      "mimelib-0.2.17" = self.by-version."mimelib"."0.2.17";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dkim-signer" ];
  };
  by-spec."domain-browser"."~1.1.0" =
    self.by-version."domain-browser"."1.1.3";
  by-version."domain-browser"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "domain-browser-1.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domain-browser/-/domain-browser-1.1.3.tgz";
        name = "domain-browser-1.1.3.tgz";
        sha1 = "ee8b336f1c53dc990b302eac12b4c7fee24923c1";
      })
    ];
    buildInputs =
      (self.nativeDeps."domain-browser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "domain-browser" ];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.1.1";
  by-version."domelementtype"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "domelementtype-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.1.tgz";
        name = "domelementtype-1.1.1.tgz";
        sha1 = "7887acbda7614bb0a3dbe1b5e394f77a8ed297cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."domelementtype" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "domelementtype" ];
  };
  by-spec."domhandler"."2.2" =
    self.by-version."domhandler"."2.2.0";
  by-version."domhandler"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "domhandler-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.2.0.tgz";
        name = "domhandler-2.2.0.tgz";
        sha1 = "ac9febfa988034b43f78ba056ebf7bd373416476";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = {
      "domelementtype-1.1.1" = self.by-version."domelementtype"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domutils"."1.5" =
    self.by-version."domutils"."1.5.0";
  by-version."domutils"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.5.0.tgz";
        name = "domutils-1.5.0.tgz";
        sha1 = "bfa4ceb8b7ab6f9423fe59154e04da6cc3ff3949";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = {
      "domelementtype-1.1.1" = self.by-version."domelementtype"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."dox"."~0.4.4" =
    self.by-version."dox"."0.4.6";
  by-version."dox"."0.4.6" = lib.makeOverridable self.buildNodePackage {
    name = "dox-0.4.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dox/-/dox-0.4.6.tgz";
        name = "dox-0.4.6.tgz";
        sha1 = "b1f53ccd1aa0d7f712fdca22124a666e3ed37215";
      })
    ];
    buildInputs =
      (self.nativeDeps."dox" or []);
    deps = {
      "marked-0.3.2" = self.by-version."marked"."0.3.2";
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dox" ];
  };
  by-spec."dtrace-provider"."0.2.8" =
    self.by-version."dtrace-provider"."0.2.8";
  by-version."dtrace-provider"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "dtrace-provider-0.2.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dtrace-provider/-/dtrace-provider-0.2.8.tgz";
        name = "dtrace-provider-0.2.8.tgz";
        sha1 = "e243f19219aa95fbf0d8f2ffb07f5bd64e94fe20";
      })
    ];
    buildInputs =
      (self.nativeDeps."dtrace-provider" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "dtrace-provider" ];
  };
  by-spec."duplexer2"."0.0.2" =
    self.by-version."duplexer2"."0.0.2";
  by-version."duplexer2"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "duplexer2-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/duplexer2/-/duplexer2-0.0.2.tgz";
        name = "duplexer2-0.0.2.tgz";
        sha1 = "c614dcf67e2fb14995a91711e5a617e8a60a31db";
      })
    ];
    buildInputs =
      (self.nativeDeps."duplexer2" or []);
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "duplexer2" ];
  };
  by-spec."duplexer2"."~0.0.2" =
    self.by-version."duplexer2"."0.0.2";
  by-spec."editor"."~0.1.0" =
    self.by-version."editor"."0.1.0";
  by-version."editor"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "editor-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/editor/-/editor-0.1.0.tgz";
        name = "editor-0.1.0.tgz";
        sha1 = "542f4662c6a8c88e862fc11945e204e51981b9a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."editor" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "editor" ];
  };
  by-spec."ee-first"."1.0.5" =
    self.by-version."ee-first"."1.0.5";
  by-version."ee-first"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "ee-first-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ee-first/-/ee-first-1.0.5.tgz";
        name = "ee-first-1.0.5.tgz";
        sha1 = "8c9b212898d8cd9f1a9436650ce7be202c9e9ff0";
      })
    ];
    buildInputs =
      (self.nativeDeps."ee-first" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ee-first" ];
  };
  by-spec."ejs"."0.8.3" =
    self.by-version."ejs"."0.8.3";
  by-version."ejs"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "ejs-0.8.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ejs/-/ejs-0.8.3.tgz";
        name = "ejs-0.8.3.tgz";
        sha1 = "db8aac47ff80a7df82b4c82c126fe8970870626f";
      })
    ];
    buildInputs =
      (self.nativeDeps."ejs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ejs" ];
  };
  by-spec."emitter-component"."0.0.6" =
    self.by-version."emitter-component"."0.0.6";
  by-version."emitter-component"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "emitter-component-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/emitter-component/-/emitter-component-0.0.6.tgz";
        name = "emitter-component-0.0.6.tgz";
        sha1 = "c155d82f6d0c01b5bee856d58074a4cc59795bca";
      })
    ];
    buildInputs =
      (self.nativeDeps."emitter-component" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "emitter-component" ];
  };
  by-spec."encoding"."~0.1.7" =
    self.by-version."encoding"."0.1.10";
  by-version."encoding"."0.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "encoding-0.1.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/encoding/-/encoding-0.1.10.tgz";
        name = "encoding-0.1.10.tgz";
        sha1 = "4463122033a7e3fdae4e81bf306f675dd8e4612c";
      })
    ];
    buildInputs =
      (self.nativeDeps."encoding" or []);
    deps = {
      "iconv-lite-0.4.4" = self.by-version."iconv-lite"."0.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "encoding" ];
  };
  by-spec."end-of-stream"."^1.0.0" =
    self.by-version."end-of-stream"."1.1.0";
  by-version."end-of-stream"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "end-of-stream-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/end-of-stream/-/end-of-stream-1.1.0.tgz";
        name = "end-of-stream-1.1.0.tgz";
        sha1 = "e9353258baa9108965efc41cb0ef8ade2f3cfb07";
      })
    ];
    buildInputs =
      (self.nativeDeps."end-of-stream" or []);
    deps = {
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "end-of-stream" ];
  };
  by-spec."end-of-stream"."~0.1.5" =
    self.by-version."end-of-stream"."0.1.5";
  by-version."end-of-stream"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "end-of-stream-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/end-of-stream/-/end-of-stream-0.1.5.tgz";
        name = "end-of-stream-0.1.5.tgz";
        sha1 = "8e177206c3c80837d85632e8b9359dfe8b2f6eaf";
      })
    ];
    buildInputs =
      (self.nativeDeps."end-of-stream" or []);
    deps = {
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "end-of-stream" ];
  };
  by-spec."end-of-stream"."~1.0.0" =
    self.by-version."end-of-stream"."1.0.0";
  by-version."end-of-stream"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "end-of-stream-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/end-of-stream/-/end-of-stream-1.0.0.tgz";
        name = "end-of-stream-1.0.0.tgz";
        sha1 = "d4596e702734a93e40e9af864319eabd99ff2f0e";
      })
    ];
    buildInputs =
      (self.nativeDeps."end-of-stream" or []);
    deps = {
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "end-of-stream" ];
  };
  by-spec."entities"."1.0" =
    self.by-version."entities"."1.0.0";
  by-version."entities"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "entities-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-1.0.0.tgz";
        name = "entities-1.0.0.tgz";
        sha1 = "b2987aa3821347fcde642b24fdfc9e4fb712bf26";
      })
    ];
    buildInputs =
      (self.nativeDeps."entities" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "entities" ];
  };
  by-spec."envify"."^3.0.0" =
    self.by-version."envify"."3.0.0";
  by-version."envify"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "envify-3.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/envify/-/envify-3.0.0.tgz";
        name = "envify-3.0.0.tgz";
        sha1 = "af81202306f69df13845d0bfcb25a19abcb5f510";
      })
    ];
    buildInputs =
      (self.nativeDeps."envify" or []);
    deps = {
      "xtend-2.1.2" = self.by-version."xtend"."2.1.2";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "esprima-fb-4001.3001.0-dev-harmony-fb" = self.by-version."esprima-fb"."4001.3001.0-dev-harmony-fb";
      "jstransform-6.3.2" = self.by-version."jstransform"."6.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "envify" ];
  };
  by-spec."errorhandler"."~1.2.2" =
    self.by-version."errorhandler"."1.2.2";
  by-version."errorhandler"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "errorhandler-1.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/errorhandler/-/errorhandler-1.2.2.tgz";
        name = "errorhandler-1.2.2.tgz";
        sha1 = "be0249eee868cf21649648e346da8899d0195984";
      })
    ];
    buildInputs =
      (self.nativeDeps."errorhandler" or []);
    deps = {
      "accepts-1.1.2" = self.by-version."accepts"."1.1.2";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "errorhandler" ];
  };
  by-spec."es5-ext"."~0.10.2" =
    self.by-version."es5-ext"."0.10.4";
  by-version."es5-ext"."0.10.4" = lib.makeOverridable self.buildNodePackage {
    name = "es5-ext-0.10.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es5-ext/-/es5-ext-0.10.4.tgz";
        name = "es5-ext-0.10.4.tgz";
        sha1 = "f4d7d85d45acfbe93379d4c0948fbae6466ec876";
      })
    ];
    buildInputs =
      (self.nativeDeps."es5-ext" or []);
    deps = {
      "es6-iterator-0.1.1" = self.by-version."es6-iterator"."0.1.1";
      "es6-symbol-0.1.1" = self.by-version."es6-symbol"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "es5-ext" ];
  };
  by-spec."es5-ext"."~0.10.4" =
    self.by-version."es5-ext"."0.10.4";
  by-spec."es6-iterator"."~0.1.1" =
    self.by-version."es6-iterator"."0.1.1";
  by-version."es6-iterator"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "es6-iterator-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es6-iterator/-/es6-iterator-0.1.1.tgz";
        name = "es6-iterator-0.1.1.tgz";
        sha1 = "5e136c899aa1c26296414f90859b73934812d275";
      })
    ];
    buildInputs =
      (self.nativeDeps."es6-iterator" or []);
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
      "es6-symbol-0.1.1" = self.by-version."es6-symbol"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "es6-iterator" ];
  };
  by-spec."es6-symbol"."0.1.x" =
    self.by-version."es6-symbol"."0.1.1";
  by-version."es6-symbol"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "es6-symbol-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es6-symbol/-/es6-symbol-0.1.1.tgz";
        name = "es6-symbol-0.1.1.tgz";
        sha1 = "9cf7fab2edaff1b1da8fe8e68bfe3f5aca6ca218";
      })
    ];
    buildInputs =
      (self.nativeDeps."es6-symbol" or []);
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "es6-symbol" ];
  };
  by-spec."es6-weak-map"."~0.1.2" =
    self.by-version."es6-weak-map"."0.1.2";
  by-version."es6-weak-map"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "es6-weak-map-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es6-weak-map/-/es6-weak-map-0.1.2.tgz";
        name = "es6-weak-map-0.1.2.tgz";
        sha1 = "bc5b5fab73f68f6f77a6b39c481fce3d7856d385";
      })
    ];
    buildInputs =
      (self.nativeDeps."es6-weak-map" or []);
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
      "es6-iterator-0.1.1" = self.by-version."es6-iterator"."0.1.1";
      "es6-symbol-0.1.1" = self.by-version."es6-symbol"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "es6-weak-map" ];
  };
  by-spec."escape-html"."*" =
    self.by-version."escape-html"."1.0.1";
  by-version."escape-html"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "escape-html-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
        name = "escape-html-1.0.1.tgz";
        sha1 = "181a286ead397a39a92857cfb1d43052e356bff0";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-html" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "escape-html" ];
  };
  "escape-html" = self.by-version."escape-html"."1.0.1";
  by-spec."escape-html"."1.0.1" =
    self.by-version."escape-html"."1.0.1";
  by-spec."escape-string-regexp"."1.0.2" =
    self.by-version."escape-string-regexp"."1.0.2";
  by-version."escape-string-regexp"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "escape-string-regexp-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.2.tgz";
        name = "escape-string-regexp-1.0.2.tgz";
        sha1 = "4dbc2fe674e71949caf3fb2695ce7f2dc1d9a8d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-string-regexp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "escape-string-regexp" ];
  };
  by-spec."escape-string-regexp"."^1.0.0" =
    self.by-version."escape-string-regexp"."1.0.2";
  by-spec."escodegen"."1.3.x" =
    self.by-version."escodegen"."1.3.3";
  by-version."escodegen"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-1.3.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.3.3.tgz";
        name = "escodegen-1.3.3.tgz";
        sha1 = "f024016f5a88e046fd12005055e939802e6c5f23";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "esutils-1.0.0" = self.by-version."esutils"."1.0.0";
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "esprima-1.1.1" = self.by-version."esprima"."1.1.1";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escodegen"."~ 0.0.28" =
    self.by-version."escodegen"."0.0.28";
  by-version."escodegen"."0.0.28" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-0.0.28";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-0.0.28.tgz";
        name = "escodegen-0.0.28.tgz";
        sha1 = "0e4ff1715f328775d6cab51ac44a406cd7abffd3";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "estraverse-1.3.2" = self.by-version."estraverse"."1.3.2";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
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
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.1.0.tgz";
        name = "escodegen-1.1.0.tgz";
        sha1 = "c663923f6e20aad48d0c0fa49f31c6d4f49360cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "esutils-1.0.0" = self.by-version."esutils"."1.0.0";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escope"."~ 1.0.0" =
    self.by-version."escope"."1.0.1";
  by-version."escope"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "escope-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escope/-/escope-1.0.1.tgz";
        name = "escope-1.0.1.tgz";
        sha1 = "59b04cdccb76555608499ed13502b9028fe73dd8";
      })
    ];
    buildInputs =
      (self.nativeDeps."escope" or []);
    deps = {
      "estraverse-1.7.0" = self.by-version."estraverse"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escope" ];
  };
  by-spec."esmangle"."~0.0.8" =
    self.by-version."esmangle"."0.0.17";
  by-version."esmangle"."0.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "esmangle-0.0.17";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esmangle/-/esmangle-0.0.17.tgz";
        name = "esmangle-0.0.17.tgz";
        sha1 = "4c5c93607cde5d1276bad396e836229dba68d90c";
      })
    ];
    buildInputs =
      (self.nativeDeps."esmangle" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "escope-1.0.1" = self.by-version."escope"."1.0.1";
      "escodegen-0.0.28" = self.by-version."escodegen"."0.0.28";
      "estraverse-1.3.2" = self.by-version."estraverse"."1.3.2";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
      "esshorten-0.0.2" = self.by-version."esshorten"."0.0.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "esmangle" ];
  };
  by-spec."esprima"."1.2.x" =
    self.by-version."esprima"."1.2.2";
  by-version."esprima"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.2.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.2.2.tgz";
        name = "esprima-1.2.2.tgz";
        sha1 = "76a0fd66fcfe154fd292667dc264019750b1657b";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."esprima"."~ 1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-version."esprima"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        name = "esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."esprima"."~1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima"."~1.0.4" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima"."~1.1.1" =
    self.by-version."esprima"."1.1.1";
  by-version."esprima"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.1.1.tgz";
        name = "esprima-1.1.1.tgz";
        sha1 = "5b6f1547f4d102e670e140c509be6771d6aeb549";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."esprima-fb"."3001.1.0-dev-harmony-fb" =
    self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
  by-version."esprima-fb"."3001.1.0-dev-harmony-fb" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-fb-3001.1.0-dev-harmony-fb";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima-fb/-/esprima-fb-3001.0001.0000-dev-harmony-fb.tgz";
        name = "esprima-fb-3001.1.0-dev-harmony-fb.tgz";
        sha1 = "b77d37abcd38ea0b77426bb8bc2922ce6b426411";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima-fb" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima-fb" ];
  };
  by-spec."esprima-fb"."^4001.3001.0-dev-harmony-fb" =
    self.by-version."esprima-fb"."4001.3001.0-dev-harmony-fb";
  by-version."esprima-fb"."4001.3001.0-dev-harmony-fb" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-fb-4001.3001.0-dev-harmony-fb";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima-fb/-/esprima-fb-4001.3001.0-dev-harmony-fb.tgz";
        name = "esprima-fb-4001.3001.0-dev-harmony-fb.tgz";
        sha1 = "659f1f5dc87f2f474db234a7db2a1b6c3e40af14";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima-fb" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima-fb" ];
  };
  by-spec."esprima-fb"."~6001.1.0-dev-harmony-fb" =
    self.by-version."esprima-fb"."6001.1.0-dev-harmony-fb";
  by-version."esprima-fb"."6001.1.0-dev-harmony-fb" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-fb-6001.1.0-dev-harmony-fb";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima-fb/-/esprima-fb-6001.1.0-dev-harmony-fb.tgz";
        name = "esprima-fb-6001.1.0-dev-harmony-fb.tgz";
        sha1 = "72705de7030b45ca41bbf16400a3636ffa0ca4eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima-fb" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima-fb" ];
  };
  by-spec."esshorten"."~ 0.0.2" =
    self.by-version."esshorten"."0.0.2";
  by-version."esshorten"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "esshorten-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esshorten/-/esshorten-0.0.2.tgz";
        name = "esshorten-0.0.2.tgz";
        sha1 = "28a652f1efd40c8e227f8c6de7dbe6b560ee8129";
      })
    ];
    buildInputs =
      (self.nativeDeps."esshorten" or []);
    deps = {
      "escope-1.0.1" = self.by-version."escope"."1.0.1";
      "estraverse-1.2.0" = self.by-version."estraverse"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "esshorten" ];
  };
  by-spec."estraverse".">= 0.0.2" =
    self.by-version."estraverse"."1.7.0";
  by-version."estraverse"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.7.0.tgz";
        name = "estraverse-1.7.0.tgz";
        sha1 = "05dbae27f44ee7cd795e16d118ceff05f1b6a413";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~ 1.2.0" =
    self.by-version."estraverse"."1.2.0";
  by-version."estraverse"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.2.0.tgz";
        name = "estraverse-1.2.0.tgz";
        sha1 = "6a3dc8a46a5d6766e5668639fc782976ce5660fd";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~ 1.3.2" =
    self.by-version."estraverse"."1.3.2";
  by-version."estraverse"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.3.2.tgz";
        name = "estraverse-1.3.2.tgz";
        sha1 = "37c2b893ef13d723f276d878d60d8535152a6c42";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."estraverse"."~1.3.0" =
    self.by-version."estraverse"."1.3.2";
  by-spec."estraverse"."~1.5.0" =
    self.by-version."estraverse"."1.5.1";
  by-version."estraverse"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.5.1.tgz";
        name = "estraverse-1.5.1.tgz";
        sha1 = "867a3e8e58a9f84618afb6c2ddbcd916b7cbaf71";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."esutils"."~1.0.0" =
    self.by-version."esutils"."1.0.0";
  by-version."esutils"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "esutils-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esutils/-/esutils-1.0.0.tgz";
        name = "esutils-1.0.0.tgz";
        sha1 = "8151d358e20c8acc7fb745e7472c0025fe496570";
      })
    ];
    buildInputs =
      (self.nativeDeps."esutils" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esutils" ];
  };
  by-spec."etag"."~1.4.0" =
    self.by-version."etag"."1.4.0";
  by-version."etag"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "etag-1.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/etag/-/etag-1.4.0.tgz";
        name = "etag-1.4.0.tgz";
        sha1 = "3050991615857707c04119d075ba2088e0701225";
      })
    ];
    buildInputs =
      (self.nativeDeps."etag" or []);
    deps = {
      "crc-3.0.0" = self.by-version."crc"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "etag" ];
  };
  by-spec."etag"."~1.5.0" =
    self.by-version."etag"."1.5.0";
  by-version."etag"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "etag-1.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/etag/-/etag-1.5.0.tgz";
        name = "etag-1.5.0.tgz";
        sha1 = "8ca0f7a30b4b7305f034e8902fb8ec3c321491e4";
      })
    ];
    buildInputs =
      (self.nativeDeps."etag" or []);
    deps = {
      "crc-3.0.0" = self.by-version."crc"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "etag" ];
  };
  by-spec."event-emitter"."~0.3.1" =
    self.by-version."event-emitter"."0.3.1";
  by-version."event-emitter"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "event-emitter-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-emitter/-/event-emitter-0.3.1.tgz";
        name = "event-emitter-0.3.1.tgz";
        sha1 = "1425ca9c5649a1a31ba835bd9dba6bfad3880238";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-emitter" or []);
    deps = {
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
      "d-0.1.1" = self.by-version."d"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "event-emitter" ];
  };
  by-spec."event-stream"."~0.5" =
    self.by-version."event-stream"."0.5.3";
  by-version."event-stream"."0.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "event-stream-0.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-stream/-/event-stream-0.5.3.tgz";
        name = "event-stream-0.5.3.tgz";
        sha1 = "b77b9309f7107addfeab63f0c0eafd8db0bd8c1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-stream" or []);
    deps = {
      "optimist-0.2.8" = self.by-version."optimist"."0.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "event-stream" ];
  };
  by-spec."eventemitter2"."0.4.12" =
    self.by-version."eventemitter2"."0.4.12";
  by-version."eventemitter2"."0.4.12" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter2-0.4.12";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.12.tgz";
        name = "eventemitter2-0.4.12.tgz";
        sha1 = "6cf14249fdc8799be7416e871e73fd2bb89e35e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  by-spec."eventemitter2"."0.4.14" =
    self.by-version."eventemitter2"."0.4.14";
  by-version."eventemitter2"."0.4.14" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter2-0.4.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.14.tgz";
        name = "eventemitter2-0.4.14.tgz";
        sha1 = "8f61b75cde012b2e9eb284d4545583b5643b61ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  by-spec."eventemitter2"."~0.4.11" =
    self.by-version."eventemitter2"."0.4.14";
  by-spec."eventemitter2"."~0.4.13" =
    self.by-version."eventemitter2"."0.4.14";
  by-spec."eventemitter3"."*" =
    self.by-version."eventemitter3"."0.1.5";
  by-version."eventemitter3"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter3-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter3/-/eventemitter3-0.1.5.tgz";
        name = "eventemitter3-0.1.5.tgz";
        sha1 = "fbb0655172b87911ba782bb7175409c801e5059f";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter3" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter3" ];
  };
  by-spec."events"."~1.0.0" =
    self.by-version."events"."1.0.2";
  by-version."events"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "events-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/events/-/events-1.0.2.tgz";
        name = "events-1.0.2.tgz";
        sha1 = "75849dcfe93d10fb057c30055afdbd51d06a8e24";
      })
    ];
    buildInputs =
      (self.nativeDeps."events" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "events" ];
  };
  by-spec."events.node".">= 0.4.0" =
    self.by-version."events.node"."0.4.9";
  by-version."events.node"."0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "events.node-0.4.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/events.node/-/events.node-0.4.9.tgz";
        name = "events.node-0.4.9.tgz";
        sha1 = "82998ea749501145fd2da7cf8ecbe6420fac02a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."events.node" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "events.node" ];
  };
  by-spec."everyauth"."0.4.5" =
    self.by-version."everyauth"."0.4.5";
  by-version."everyauth"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "everyauth-0.4.5";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/everyauth/-/everyauth-0.4.5.tgz";
        name = "everyauth-0.4.5.tgz";
        sha1 = "282d358439d91c30fb4aa2320dc362edac7dd189";
      })
    ];
    buildInputs =
      (self.nativeDeps."everyauth" or []);
    deps = {
      "oauth-0.9.11" = self.by-version."oauth"."0.9.11";
      "request-2.9.203" = self.by-version."request"."2.9.203";
      "connect-2.3.9" = self.by-version."connect"."2.3.9";
      "openid-0.5.9" = self.by-version."openid"."0.5.9";
      "xml2js-0.4.4" = self.by-version."xml2js"."0.4.4";
      "node-swt-0.1.1" = self.by-version."node-swt"."0.1.1";
      "node-wsfederation-0.1.1" = self.by-version."node-wsfederation"."0.1.1";
      "debug-0.5.0" = self.by-version."debug"."0.5.0";
      "express-3.18.0" = self.by-version."express"."3.18.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "everyauth" ];
  };
  by-spec."exit"."0.1.2" =
    self.by-version."exit"."0.1.2";
  by-version."exit"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "exit-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/exit/-/exit-0.1.2.tgz";
        name = "exit-0.1.2.tgz";
        sha1 = "0632638f8d877cc82107d30a0fff1a17cba1cd0c";
      })
    ];
    buildInputs =
      (self.nativeDeps."exit" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "exit" ];
  };
  by-spec."exit"."0.1.x" =
    self.by-version."exit"."0.1.2";
  by-spec."exit"."~0.1.1" =
    self.by-version."exit"."0.1.2";
  by-spec."express"."*" =
    self.by-version."express"."4.9.8";
  by-version."express"."4.9.8" = lib.makeOverridable self.buildNodePackage {
    name = "express-4.9.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.9.8.tgz";
        name = "express-4.9.8.tgz";
        sha1 = "f360f596baeabbd0e5223b603d6eb578d9d2d10d";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "accepts-1.1.2" = self.by-version."accepts"."1.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "depd-0.4.5" = self.by-version."depd"."0.4.5";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.4.0" = self.by-version."etag"."1.4.0";
      "finalhandler-0.2.0" = self.by-version."finalhandler"."0.2.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.3" = self.by-version."proxy-addr"."1.0.3";
      "qs-2.2.4" = self.by-version."qs"."2.2.4";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.9.3" = self.by-version."send"."0.9.3";
      "serve-static-1.6.4" = self.by-version."serve-static"."1.6.4";
      "type-is-1.5.2" = self.by-version."type-is"."1.5.2";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  "express" = self.by-version."express"."4.9.8";
  by-spec."express"."2.5.11" =
    self.by-version."express"."2.5.11";
  by-version."express"."2.5.11" = lib.makeOverridable self.buildNodePackage {
    name = "express-2.5.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-2.5.11.tgz";
        name = "express-2.5.11.tgz";
        sha1 = "4ce8ea1f3635e69e49f0ebb497b6a4b0a51ce6f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "connect-1.9.2" = self.by-version."connect"."1.9.2";
      "mime-1.2.4" = self.by-version."mime"."1.2.4";
      "qs-0.4.2" = self.by-version."qs"."0.4.2";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."3.2.0" =
    self.by-version."express"."3.2.0";
  by-version."express"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.2.0.tgz";
        name = "express-3.2.0.tgz";
        sha1 = "7b66d6c66b038038eedf452804222b3077374ae0";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "connect-2.7.6" = self.by-version."connect"."2.7.6";
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "cookie-0.0.5" = self.by-version."cookie"."0.0.5";
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "methods-0.0.1" = self.by-version."methods"."0.0.1";
      "send-0.1.0" = self.by-version."send"."0.1.0";
      "cookie-signature-1.0.1" = self.by-version."cookie-signature"."1.0.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."3.4.4" =
    self.by-version."express"."3.4.4";
  by-version."express"."3.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.4.tgz";
        name = "express-3.4.4.tgz";
        sha1 = "0b63ae626c96b71b78d13dfce079c10351635a86";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "connect-2.11.0" = self.by-version."connect"."2.11.0";
      "commander-1.3.2" = self.by-version."commander"."1.3.2";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "fresh-0.2.0" = self.by-version."fresh"."0.2.0";
      "methods-0.1.0" = self.by-version."methods"."0.1.0";
      "send-0.1.4" = self.by-version."send"."0.1.4";
      "cookie-signature-1.0.1" = self.by-version."cookie-signature"."1.0.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."3.x" =
    self.by-version."express"."3.18.0";
  by-version."express"."3.18.0" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.18.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.18.0.tgz";
        name = "express-3.18.0.tgz";
        sha1 = "ff1f4ee689ba6e622a087e397994f7c2115c5c57";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "connect-2.27.0" = self.by-version."connect"."2.27.0";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "commander-1.3.2" = self.by-version."commander"."1.3.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.0" = self.by-version."etag"."1.5.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "proxy-addr-1.0.3" = self.by-version."proxy-addr"."1.0.3";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.10.0" = self.by-version."send"."0.10.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express".">=3.0.0" =
    self.by-version."express"."4.9.8";
  by-spec."express"."~3.1.1" =
    self.by-version."express"."3.1.2";
  by-version."express"."3.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.1.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.1.2.tgz";
        name = "express-3.1.2.tgz";
        sha1 = "52a02c8db8f22bbfa0d7478d847cd45161f985f7";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "connect-2.7.5" = self.by-version."connect"."2.7.5";
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "cookie-0.0.5" = self.by-version."cookie"."0.0.5";
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "methods-0.0.1" = self.by-version."methods"."0.0.1";
      "send-0.1.0" = self.by-version."send"."0.1.0";
      "cookie-signature-1.0.0" = self.by-version."cookie-signature"."1.0.0";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."~4.0" =
    self.by-version."express"."4.0.0";
  by-version."express"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "express-4.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.0.0.tgz";
        name = "express-4.0.0.tgz";
        sha1 = "274dc82933c9f574cc38a0ce5ea8172be9c6b094";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "parseurl-1.0.1" = self.by-version."parseurl"."1.0.1";
      "accepts-1.0.0" = self.by-version."accepts"."1.0.0";
      "type-is-1.0.0" = self.by-version."type-is"."1.0.0";
      "range-parser-1.0.0" = self.by-version."range-parser"."1.0.0";
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "fresh-0.2.2" = self.by-version."fresh"."0.2.2";
      "methods-0.1.0" = self.by-version."methods"."0.1.0";
      "send-0.2.0" = self.by-version."send"."0.2.0";
      "cookie-signature-1.0.3" = self.by-version."cookie-signature"."1.0.3";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "serve-static-1.0.1" = self.by-version."serve-static"."1.0.1";
      "path-to-regexp-0.1.2" = self.by-version."path-to-regexp"."0.1.2";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express"."~4.8.5" =
    self.by-version."express"."4.8.8";
  by-version."express"."4.8.8" = lib.makeOverridable self.buildNodePackage {
    name = "express-4.8.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.8.8.tgz";
        name = "express-4.8.8.tgz";
        sha1 = "6aba348ccdfa87608040b12ca0010107a0aac28e";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "accepts-1.0.7" = self.by-version."accepts"."1.0.7";
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "depd-0.4.4" = self.by-version."depd"."0.4.4";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "finalhandler-0.1.0" = self.by-version."finalhandler"."0.1.0";
      "media-typer-0.2.0" = self.by-version."media-typer"."0.2.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.1" = self.by-version."proxy-addr"."1.0.1";
      "qs-2.2.2" = self.by-version."qs"."2.2.2";
      "range-parser-1.0.0" = self.by-version."range-parser"."1.0.0";
      "send-0.8.5" = self.by-version."send"."0.8.5";
      "serve-static-1.5.4" = self.by-version."serve-static"."1.5.4";
      "type-is-1.3.2" = self.by-version."type-is"."1.3.2";
      "vary-0.1.0" = self.by-version."vary"."0.1.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "fresh-0.2.2" = self.by-version."fresh"."0.2.2";
      "cookie-signature-1.0.4" = self.by-version."cookie-signature"."1.0.4";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express-form"."*" =
    self.by-version."express-form"."0.12.3";
  by-version."express-form"."0.12.3" = lib.makeOverridable self.buildNodePackage {
    name = "express-form-0.12.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-form/-/express-form-0.12.3.tgz";
        name = "express-form-0.12.3.tgz";
        sha1 = "e3d944b892b621524925837bee0d658f84833139";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-form" or []);
    deps = {
      "validator-0.4.28" = self.by-version."validator"."0.4.28";
      "object-additions-0.5.1" = self.by-version."object-additions"."0.5.1";
      "async-0.7.0" = self.by-version."async"."0.7.0";
    };
    peerDependencies = [
      self.by-version."express"."4.9.8"
    ];
    passthru.names = [ "express-form" ];
  };
  "express-form" = self.by-version."express-form"."0.12.3";
  by-spec."express-partials"."0.0.6" =
    self.by-version."express-partials"."0.0.6";
  by-version."express-partials"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "express-partials-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-partials/-/express-partials-0.0.6.tgz";
        name = "express-partials-0.0.6.tgz";
        sha1 = "b2664f15c636d5248e60fdbe29131c4440552eda";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-partials" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "express-partials" ];
  };
  by-spec."express-session"."~1.7.6" =
    self.by-version."express-session"."1.7.6";
  by-version."express-session"."1.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "express-session-1.7.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-session/-/express-session-1.7.6.tgz";
        name = "express-session-1.7.6.tgz";
        sha1 = "e1c369ba2176f7afdb79e77d65dcd8c7c46e48a5";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-session" or []);
    deps = {
      "buffer-crc32-0.2.3" = self.by-version."buffer-crc32"."0.2.3";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.4" = self.by-version."cookie-signature"."1.0.4";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "depd-0.4.4" = self.by-version."depd"."0.4.4";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "uid-safe-1.0.1" = self.by-version."uid-safe"."1.0.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express-session" ];
  };
  by-spec."express-session"."~1.9.0" =
    self.by-version."express-session"."1.9.0";
  by-version."express-session"."1.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "express-session-1.9.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-session/-/express-session-1.9.0.tgz";
        name = "express-session-1.9.0.tgz";
        sha1 = "75ceb80194e5f3d0c71922e4affb90bc40c119f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-session" or []);
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "crc-3.0.0" = self.by-version."crc"."3.0.0";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "uid-safe-1.0.1" = self.by-version."uid-safe"."1.0.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express-session" ];
  };
  by-spec."extend"."*" =
    self.by-version."extend"."2.0.0";
  by-version."extend"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "extend-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-2.0.0.tgz";
        name = "extend-2.0.0.tgz";
        sha1 = "cc3c1e238521df4c28e3f30868b7324bb5898a5c";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extend" ];
  };
  "extend" = self.by-version."extend"."2.0.0";
  by-spec."extend"."~1.2.1" =
    self.by-version."extend"."1.2.1";
  by-version."extend"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "extend-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-1.2.1.tgz";
        name = "extend-1.2.1.tgz";
        sha1 = "a0f5fd6cfc83a5fe49ef698d60ec8a624dd4576c";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extend" ];
  };
  by-spec."extend"."~1.3.0" =
    self.by-version."extend"."1.3.0";
  by-version."extend"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "extend-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-1.3.0.tgz";
        name = "extend-1.3.0.tgz";
        sha1 = "d1516fb0ff5624d2ebf9123ea1dac5a1994004f8";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extend" ];
  };
  by-spec."extract-opts"."~2.2.0" =
    self.by-version."extract-opts"."2.2.0";
  by-version."extract-opts"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "extract-opts-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extract-opts/-/extract-opts-2.2.0.tgz";
        name = "extract-opts-2.2.0.tgz";
        sha1 = "1fa28eba7352c6db480f885ceb71a46810be6d7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."extract-opts" or []);
    deps = {
      "typechecker-2.0.8" = self.by-version."typechecker"."2.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "extract-opts" ];
  };
  by-spec."extsprintf"."1.0.0" =
    self.by-version."extsprintf"."1.0.0";
  by-version."extsprintf"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "extsprintf-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.0.tgz";
        name = "extsprintf-1.0.0.tgz";
        sha1 = "4d58b815ace5bebfc4ebf03cf98b0a7604a99b86";
      })
    ];
    buildInputs =
      (self.nativeDeps."extsprintf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extsprintf" ];
  };
  by-spec."extsprintf"."1.0.2" =
    self.by-version."extsprintf"."1.0.2";
  by-version."extsprintf"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "extsprintf-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
        name = "extsprintf-1.0.2.tgz";
        sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
      })
    ];
    buildInputs =
      (self.nativeDeps."extsprintf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extsprintf" ];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "eyes-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        name = "eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eyes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "eyes" ];
  };
  by-spec."eyes".">=0.1.6" =
    self.by-version."eyes"."0.1.8";
  by-spec."faye-websocket"."*" =
    self.by-version."faye-websocket"."0.7.3";
  by-version."faye-websocket"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.7.3.tgz";
        name = "faye-websocket-0.7.3.tgz";
        sha1 = "cc4074c7f4a4dfd03af54dd65c354b135132ce11";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket" or []);
    deps = {
      "websocket-driver-0.3.6" = self.by-version."websocket-driver"."0.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  "faye-websocket" = self.by-version."faye-websocket"."0.7.3";
  by-spec."faye-websocket"."0.7.2" =
    self.by-version."faye-websocket"."0.7.2";
  by-version."faye-websocket"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.7.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.7.2.tgz";
        name = "faye-websocket-0.7.2.tgz";
        sha1 = "799970386f87105592397434b02abfa4f07bdf70";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket" or []);
    deps = {
      "websocket-driver-0.3.6" = self.by-version."websocket-driver"."0.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  by-spec."fetch-bower".">=2 <3" =
    self.by-version."fetch-bower"."2.0.0";
  by-version."fetch-bower"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "fetch-bower-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fetch-bower/-/fetch-bower-2.0.0.tgz";
        name = "fetch-bower-2.0.0.tgz";
        sha1 = "c027feb75a512001d1287bbfb3ffaafba67eb92f";
      })
    ];
    buildInputs =
      (self.nativeDeps."fetch-bower" or []);
    deps = {
      "bower-endpoint-parser-0.2.1" = self.by-version."bower-endpoint-parser"."0.2.1";
      "bower-logger-0.2.1" = self.by-version."bower-logger"."0.2.1";
      "bower-1.3.12" = self.by-version."bower"."1.3.12";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fetch-bower" ];
  };
  by-spec."fields"."~0.1.11" =
    self.by-version."fields"."0.1.17";
  by-version."fields"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "fields-0.1.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fields/-/fields-0.1.17.tgz";
        name = "fields-0.1.17.tgz";
        sha1 = "4d5d87d68f7e6f5b46098546821aa939a248cdbf";
      })
    ];
    buildInputs =
      (self.nativeDeps."fields" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "keypress-0.2.1" = self.by-version."keypress"."0.2.1";
      "sprintf-0.1.4" = self.by-version."sprintf"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fields" ];
  };
  by-spec."figures"."^1.0.1" =
    self.by-version."figures"."1.3.3";
  by-version."figures"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "figures-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/figures/-/figures-1.3.3.tgz";
        name = "figures-1.3.3.tgz";
        sha1 = "a0952f9ba076e6be3dd5e2bad8e6a013c00d3d36";
      })
    ];
    buildInputs =
      (self.nativeDeps."figures" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "figures" ];
  };
  by-spec."figures"."^1.3.2" =
    self.by-version."figures"."1.3.3";
  by-spec."fileset"."0.1.x" =
    self.by-version."fileset"."0.1.5";
  by-version."fileset"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "fileset-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fileset/-/fileset-0.1.5.tgz";
        name = "fileset-0.1.5.tgz";
        sha1 = "acc423bfaf92843385c66bf75822264d11b7bd94";
      })
    ];
    buildInputs =
      (self.nativeDeps."fileset" or []);
    deps = {
      "minimatch-0.4.0" = self.by-version."minimatch"."0.4.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fileset" ];
  };
  by-spec."finalhandler"."0.1.0" =
    self.by-version."finalhandler"."0.1.0";
  by-version."finalhandler"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "finalhandler-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.1.0.tgz";
        name = "finalhandler-0.1.0.tgz";
        sha1 = "da05bbc4f5f4a30c84ce1d91f3c154007c4e9daa";
      })
    ];
    buildInputs =
      (self.nativeDeps."finalhandler" or []);
    deps = {
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "finalhandler" ];
  };
  by-spec."finalhandler"."0.2.0" =
    self.by-version."finalhandler"."0.2.0";
  by-version."finalhandler"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "finalhandler-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.2.0.tgz";
        name = "finalhandler-0.2.0.tgz";
        sha1 = "794082424b17f6a4b2a0eda39f9db6948ee4be8d";
      })
    ];
    buildInputs =
      (self.nativeDeps."finalhandler" or []);
    deps = {
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "finalhandler" ];
  };
  by-spec."finalhandler"."0.3.1" =
    self.by-version."finalhandler"."0.3.1";
  by-version."finalhandler"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "finalhandler-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.3.1.tgz";
        name = "finalhandler-0.3.1.tgz";
        sha1 = "ffda7643228678c6b088c89421a8381663961808";
      })
    ];
    buildInputs =
      (self.nativeDeps."finalhandler" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "finalhandler" ];
  };
  by-spec."findit".">=1.1.0 <2.0.0" =
    self.by-version."findit"."1.2.0";
  by-version."findit"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "findit-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findit/-/findit-1.2.0.tgz";
        name = "findit-1.2.0.tgz";
        sha1 = "f571a3a840749ae8b0cbf4bf43ced7659eec3ce8";
      })
    ];
    buildInputs =
      (self.nativeDeps."findit" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "findit" ];
  };
  by-spec."findup-sync"."~0.1.0" =
    self.by-version."findup-sync"."0.1.3";
  by-version."findup-sync"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "findup-sync-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.3.tgz";
        name = "findup-sync-0.1.3.tgz";
        sha1 = "7f3e7a97b82392c653bf06589bd85190e93c3683";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup-sync" or []);
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "findup-sync" ];
  };
  by-spec."findup-sync"."~0.1.2" =
    self.by-version."findup-sync"."0.1.3";
  by-spec."first-chunk-stream"."^1.0.0" =
    self.by-version."first-chunk-stream"."1.0.0";
  by-version."first-chunk-stream"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "first-chunk-stream-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/first-chunk-stream/-/first-chunk-stream-1.0.0.tgz";
        name = "first-chunk-stream-1.0.0.tgz";
        sha1 = "59bfb50cd905f60d7c394cd3d9acaab4e6ad934e";
      })
    ];
    buildInputs =
      (self.nativeDeps."first-chunk-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "first-chunk-stream" ];
  };
  by-spec."flagged-respawn"."~0.3.0" =
    self.by-version."flagged-respawn"."0.3.1";
  by-version."flagged-respawn"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "flagged-respawn-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flagged-respawn/-/flagged-respawn-0.3.1.tgz";
        name = "flagged-respawn-0.3.1.tgz";
        sha1 = "397700925df6e12452202a71e89d89545fbbbe9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."flagged-respawn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "flagged-respawn" ];
  };
  by-spec."flatiron"."*" =
    self.by-version."flatiron"."0.4.2";
  by-version."flatiron"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "flatiron-0.4.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flatiron/-/flatiron-0.4.2.tgz";
        name = "flatiron-0.4.2.tgz";
        sha1 = "cffae218dae8229d6668c34453eefd9a44c0e418";
      })
    ];
    buildInputs =
      (self.nativeDeps."flatiron" or []);
    deps = {
      "broadway-0.3.6" = self.by-version."broadway"."0.3.6";
      "optimist-0.6.0" = self.by-version."optimist"."0.6.0";
      "prompt-0.2.14" = self.by-version."prompt"."0.2.14";
      "director-1.2.3" = self.by-version."director"."1.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "flatiron" ];
  };
  "flatiron" = self.by-version."flatiron"."0.4.2";
  by-spec."flatiron"."~0.3.11" =
    self.by-version."flatiron"."0.3.11";
  by-version."flatiron"."0.3.11" = lib.makeOverridable self.buildNodePackage {
    name = "flatiron-0.3.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flatiron/-/flatiron-0.3.11.tgz";
        name = "flatiron-0.3.11.tgz";
        sha1 = "1cb0190fc2bd9d860f018e04d95fd35f9bd12555";
      })
    ];
    buildInputs =
      (self.nativeDeps."flatiron" or []);
    deps = {
      "broadway-0.2.9" = self.by-version."broadway"."0.2.9";
      "optimist-0.6.0" = self.by-version."optimist"."0.6.0";
      "prompt-0.2.11" = self.by-version."prompt"."0.2.11";
      "director-1.1.10" = self.by-version."director"."1.1.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "flatiron" ];
  };
  by-spec."follow-redirects"."0.0.3" =
    self.by-version."follow-redirects"."0.0.3";
  by-version."follow-redirects"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "follow-redirects-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/follow-redirects/-/follow-redirects-0.0.3.tgz";
        name = "follow-redirects-0.0.3.tgz";
        sha1 = "6ce67a24db1fe13f226c1171a72a7ef2b17b8f65";
      })
    ];
    buildInputs =
      (self.nativeDeps."follow-redirects" or []);
    deps = {
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "follow-redirects" ];
  };
  by-spec."forEachAsync"."~2.2" =
    self.by-version."forEachAsync"."2.2.1";
  by-version."forEachAsync"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "forEachAsync-2.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forEachAsync/-/forEachAsync-2.2.1.tgz";
        name = "forEachAsync-2.2.1.tgz";
        sha1 = "e3723f00903910e1eb4b1db3ad51b5c64a319fec";
      })
    ];
    buildInputs =
      (self.nativeDeps."forEachAsync" or []);
    deps = {
      "sequence-2.2.1" = self.by-version."sequence"."2.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forEachAsync" ];
  };
  by-spec."foreachasync"."3.x" =
    self.by-version."foreachasync"."3.0.0";
  by-version."foreachasync"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "foreachasync-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/foreachasync/-/foreachasync-3.0.0.tgz";
        name = "foreachasync-3.0.0.tgz";
        sha1 = "5502987dc8714be3392097f32e0071c9dee07cf6";
      })
    ];
    buildInputs =
      (self.nativeDeps."foreachasync" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "foreachasync" ];
  };
  by-spec."forever"."*" =
    self.by-version."forever"."0.11.1";
  by-version."forever"."0.11.1" = lib.makeOverridable self.buildNodePackage {
    name = "forever-0.11.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever/-/forever-0.11.1.tgz";
        name = "forever-0.11.1.tgz";
        sha1 = "50ac8744c0a6e0c266524c4746397f74d6b09c5b";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cliff-0.1.8" = self.by-version."cliff"."0.1.8";
      "flatiron-0.3.11" = self.by-version."flatiron"."0.3.11";
      "forever-monitor-1.2.3" = self.by-version."forever-monitor"."1.2.3";
      "nconf-0.6.9" = self.by-version."nconf"."0.6.9";
      "nssocket-0.5.1" = self.by-version."nssocket"."0.5.1";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "timespan-2.3.0" = self.by-version."timespan"."2.3.0";
      "watch-0.8.0" = self.by-version."watch"."0.8.0";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
      "winston-0.7.3" = self.by-version."winston"."0.7.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever" ];
  };
  "forever" = self.by-version."forever"."0.11.1";
  by-spec."forever-agent"."~0.2.0" =
    self.by-version."forever-agent"."0.2.0";
  by-version."forever-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.2.0.tgz";
        name = "forever-agent-0.2.0.tgz";
        sha1 = "e1c25c7ad44e09c38f233876c76fcc24ff843b1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
        name = "forever-agent-0.5.2.tgz";
        sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."forever-monitor"."*" =
    self.by-version."forever-monitor"."1.3.0";
  by-version."forever-monitor"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.3.0.tgz";
        name = "forever-monitor-1.3.0.tgz";
        sha1 = "57e883da03ec0eb690ad4259afbccf22f609d52e";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor" or []);
    deps = {
      "broadway-0.2.10" = self.by-version."broadway"."0.2.10";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "ps-tree-0.0.3" = self.by-version."ps-tree"."0.0.3";
      "watch-0.5.1" = self.by-version."watch"."0.5.1";
      "utile-0.1.7" = self.by-version."utile"."0.1.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  "forever-monitor" = self.by-version."forever-monitor"."1.3.0";
  by-spec."forever-monitor"."1.1.0" =
    self.by-version."forever-monitor"."1.1.0";
  by-version."forever-monitor"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.1.0.tgz";
        name = "forever-monitor-1.1.0.tgz";
        sha1 = "439ce036f999601cff551aea7f5151001a869ef9";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor" or []);
    deps = {
      "broadway-0.2.10" = self.by-version."broadway"."0.2.10";
      "minimatch-0.0.5" = self.by-version."minimatch"."0.0.5";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "ps-tree-0.0.3" = self.by-version."ps-tree"."0.0.3";
      "watch-0.5.1" = self.by-version."watch"."0.5.1";
      "utile-0.1.7" = self.by-version."utile"."0.1.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  by-spec."forever-monitor"."1.2.3" =
    self.by-version."forever-monitor"."1.2.3";
  by-version."forever-monitor"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.2.3.tgz";
        name = "forever-monitor-1.2.3.tgz";
        sha1 = "b27ac3acb6fdcc7315d6cd85830f2d004733028b";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor" or []);
    deps = {
      "broadway-0.2.10" = self.by-version."broadway"."0.2.10";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "ps-tree-0.0.3" = self.by-version."ps-tree"."0.0.3";
      "watch-0.5.1" = self.by-version."watch"."0.5.1";
      "utile-0.1.7" = self.by-version."utile"."0.1.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  by-spec."form-data"."0.1.3" =
    self.by-version."form-data"."0.1.3";
  by-version."form-data"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.3.tgz";
        name = "form-data-0.1.3.tgz";
        sha1 = "4ee4346e6eb5362e8344a02075bd8dbd8c7373ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "combined-stream-0.0.5" = self.by-version."combined-stream"."0.0.5";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."form-data"."~0.0.3" =
    self.by-version."form-data"."0.0.10";
  by-version."form-data"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.10.tgz";
        name = "form-data-0.0.10.tgz";
        sha1 = "db345a5378d86aeeb1ed5d553b869ac192d2f5ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "combined-stream-0.0.5" = self.by-version."combined-stream"."0.0.5";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.2.10" = self.by-version."async"."0.2.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.4";
  by-version."form-data"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.4.tgz";
        name = "form-data-0.1.4.tgz";
        sha1 = "91abd788aba9702b1aabfa8bc01031a2ac9e3b12";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "combined-stream-0.0.5" = self.by-version."combined-stream"."0.0.5";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."formatio"."~1.0" =
    self.by-version."formatio"."1.0.2";
  by-version."formatio"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "formatio-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formatio/-/formatio-1.0.2.tgz";
        name = "formatio-1.0.2.tgz";
        sha1 = "e7991ca144ff7d8cff07bb9ac86a9b79c6ba47ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."formatio" or []);
    deps = {
      "samsam-1.1.1" = self.by-version."samsam"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "formatio" ];
  };
  by-spec."formidable"."1.0.11" =
    self.by-version."formidable"."1.0.11";
  by-version."formidable"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.11.tgz";
        name = "formidable-1.0.11.tgz";
        sha1 = "68f63325a035e644b6f7bb3d11243b9761de1b30";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.13" =
    self.by-version."formidable"."1.0.13";
  by-version."formidable"."1.0.13" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.13.tgz";
        name = "formidable-1.0.13.tgz";
        sha1 = "70caf0f9d69692a77e04021ddab4f46b01c82aea";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.14" =
    self.by-version."formidable"."1.0.14";
  by-version."formidable"."1.0.14" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.14.tgz";
        name = "formidable-1.0.14.tgz";
        sha1 = "2b3f4c411cbb5fdd695c44843e2a23514a43231a";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.9" =
    self.by-version."formidable"."1.0.9";
  by-version."formidable"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.9.tgz";
        name = "formidable-1.0.9.tgz";
        sha1 = "419e3bccead3e8874d539f5b3e72a4c503b31a98";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."formidable"."1.0.x" =
    self.by-version."formidable"."1.0.15";
  by-version."formidable"."1.0.15" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.15.tgz";
        name = "formidable-1.0.15.tgz";
        sha1 = "91363d59cc51ddca2be84ca0336ec0135606c155";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  by-spec."forwarded"."~0.1.0" =
    self.by-version."forwarded"."0.1.0";
  by-version."forwarded"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "forwarded-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
        name = "forwarded-0.1.0.tgz";
        sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
      })
    ];
    buildInputs =
      (self.nativeDeps."forwarded" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "forwarded" ];
  };
  by-spec."fresh"."0.1.0" =
    self.by-version."fresh"."0.1.0";
  by-version."fresh"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.1.0.tgz";
        name = "fresh-0.1.0.tgz";
        sha1 = "03e4b0178424e4c2d5d19a54d8814cdc97934850";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."0.2.0" =
    self.by-version."fresh"."0.2.0";
  by-version."fresh"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.0.tgz";
        name = "fresh-0.2.0.tgz";
        sha1 = "bfd9402cf3df12c4a4c310c79f99a3dde13d34a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."0.2.2" =
    self.by-version."fresh"."0.2.2";
  by-version."fresh"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.2.tgz";
        name = "fresh-0.2.2.tgz";
        sha1 = "9731dcf5678c7faeb44fb903c4f72df55187fa77";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."0.2.4" =
    self.by-version."fresh"."0.2.4";
  by-version."fresh"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.4.tgz";
        name = "fresh-0.2.4.tgz";
        sha1 = "3582499206c9723714190edd74b4604feb4a614c";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fresh"."~0.2.1" =
    self.by-version."fresh"."0.2.4";
  by-spec."fs-extra"."~0.6.1" =
    self.by-version."fs-extra"."0.6.4";
  by-version."fs-extra"."0.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "fs-extra-0.6.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.6.4.tgz";
        name = "fs-extra-0.6.4.tgz";
        sha1 = "f46f0c75b7841f8d200b3348cd4d691d5a099d15";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-extra" or []);
    deps = {
      "ncp-0.4.2" = self.by-version."ncp"."0.4.2";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "jsonfile-1.0.1" = self.by-version."jsonfile"."1.0.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fs-extra" ];
  };
  by-spec."fs-vacuum"."~1.2.1" =
    self.by-version."fs-vacuum"."1.2.1";
  by-version."fs-vacuum"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "fs-vacuum-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-vacuum/-/fs-vacuum-1.2.1.tgz";
        name = "fs-vacuum-1.2.1.tgz";
        sha1 = "1bc3c62da30d6272569b8b9089c9811abb0a600b";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-vacuum" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fs-vacuum" ];
  };
  by-spec."fs-walk"."*" =
    self.by-version."fs-walk"."0.0.1";
  by-version."fs-walk"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "fs-walk-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-walk/-/fs-walk-0.0.1.tgz";
        name = "fs-walk-0.0.1.tgz";
        sha1 = "f7fc91c3ae1eead07c998bc5d0dd41f2dbebd335";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-walk" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fs-walk" ];
  };
  "fs-walk" = self.by-version."fs-walk"."0.0.1";
  by-spec."fs-write-stream-atomic"."~1.0.2" =
    self.by-version."fs-write-stream-atomic"."1.0.2";
  by-version."fs-write-stream-atomic"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "fs-write-stream-atomic-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.2.tgz";
        name = "fs-write-stream-atomic-1.0.2.tgz";
        sha1 = "fe0c6cec75256072b2fef8180d97e309fe3f5efb";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-write-stream-atomic" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fs-write-stream-atomic" ];
  };
  by-spec."fs.extra".">=1.2.0 <2.0.0" =
    self.by-version."fs.extra"."1.2.1";
  by-version."fs.extra"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "fs.extra-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs.extra/-/fs.extra-1.2.1.tgz";
        name = "fs.extra-1.2.1.tgz";
        sha1 = "060bf20264f35e39ad247e5e9d2121a2a75a1733";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs.extra" or []);
    deps = {
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "fs-extra-0.6.4" = self.by-version."fs-extra"."0.6.4";
      "walk-2.2.1" = self.by-version."walk"."2.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fs.extra" ];
  };
  by-spec."fs.extra".">=1.2.1 <2" =
    self.by-version."fs.extra"."1.2.1";
  by-spec."fsevents"."0.3.0" =
    self.by-version."fsevents"."0.3.0";
  by-version."fsevents"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "fsevents-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fsevents/-/fsevents-0.3.0.tgz";
        name = "fsevents-0.3.0.tgz";
        sha1 = "90723a3d0bbab877b62d0a78db633ef2688d8a81";
      })
    ];
    buildInputs =
      (self.nativeDeps."fsevents" or []);
    deps = {
      "nan-1.2.0" = self.by-version."nan"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fsevents" ];
  };
  by-spec."fstream"."^1.0.0" =
    self.by-version."fstream"."1.0.2";
  by-version."fstream"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-1.0.2.tgz";
        name = "fstream-1.0.2.tgz";
        sha1 = "56930ff1b4d4d7b1a689c8656b3a11e744ab92c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."^1.0.2" =
    self.by-version."fstream"."1.0.2";
  by-spec."fstream"."~0.1.8" =
    self.by-version."fstream"."0.1.31";
  by-version."fstream"."0.1.31" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.31.tgz";
        name = "fstream-0.1.31.tgz";
        sha1 = "7337f058fbbbbefa8c9f561a28cab0849202c988";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."~1.0.2" =
    self.by-version."fstream"."1.0.2";
  by-spec."fstream-ignore"."^1.0.0" =
    self.by-version."fstream-ignore"."1.0.1";
  by-version."fstream-ignore"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-ignore-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-1.0.1.tgz";
        name = "fstream-ignore-1.0.1.tgz";
        sha1 = "153df36c4fa2cb006fb915dc71ac9d75f6a17c82";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-ignore" or []);
    deps = {
      "fstream-1.0.2" = self.by-version."fstream"."1.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream-ignore" ];
  };
  by-spec."fstream-ignore"."~1.0.1" =
    self.by-version."fstream-ignore"."1.0.1";
  by-spec."fstream-npm"."~1.0.0" =
    self.by-version."fstream-npm"."1.0.1";
  by-version."fstream-npm"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-npm-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-npm/-/fstream-npm-1.0.1.tgz";
        name = "fstream-npm-1.0.1.tgz";
        sha1 = "1e35c77f0fa24f5d6367e6d447ae7d6ddb482db2";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-npm" or []);
    deps = {
      "fstream-ignore-1.0.1" = self.by-version."fstream-ignore"."1.0.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream-npm" ];
  };
  by-spec."gaze"."^0.5.1" =
    self.by-version."gaze"."0.5.1";
  by-version."gaze"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "gaze-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gaze/-/gaze-0.5.1.tgz";
        name = "gaze-0.5.1.tgz";
        sha1 = "22e731078ef3e49d1c4ab1115ac091192051824c";
      })
    ];
    buildInputs =
      (self.nativeDeps."gaze" or []);
    deps = {
      "globule-0.1.0" = self.by-version."globule"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gaze" ];
  };
  by-spec."get-stdin"."^1.0.0" =
    self.by-version."get-stdin"."1.0.0";
  by-version."get-stdin"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "get-stdin-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/get-stdin/-/get-stdin-1.0.0.tgz";
        name = "get-stdin-1.0.0.tgz";
        sha1 = "00bd5a494c81c372f5629bea103bbffe7a1da3ce";
      })
    ];
    buildInputs =
      (self.nativeDeps."get-stdin" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "get-stdin" ];
  };
  by-spec."getmac"."~1.0.6" =
    self.by-version."getmac"."1.0.6";
  by-version."getmac"."1.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "getmac-1.0.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/getmac/-/getmac-1.0.6.tgz";
        name = "getmac-1.0.6.tgz";
        sha1 = "f222c8178be9de24899df5a04e77557fbaf4e522";
      })
    ];
    buildInputs =
      (self.nativeDeps."getmac" or []);
    deps = {
      "extract-opts-2.2.0" = self.by-version."extract-opts"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "getmac" ];
  };
  by-spec."getobject"."~0.1.0" =
    self.by-version."getobject"."0.1.0";
  by-version."getobject"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "getobject-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/getobject/-/getobject-0.1.0.tgz";
        name = "getobject-0.1.0.tgz";
        sha1 = "047a449789fa160d018f5486ed91320b6ec7885c";
      })
    ];
    buildInputs =
      (self.nativeDeps."getobject" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "getobject" ];
  };
  by-spec."git-run"."*" =
    self.by-version."git-run"."0.2.0";
  by-version."git-run"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "git-run-0.2.0";
    bin = true;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/git-run/-/git-run-0.2.0.tgz";
        name = "git-run-0.2.0.tgz";
        sha1 = "9aa3b203edbb7fcfbc06604c43454d47627d8ac0";
      })
    ];
    buildInputs =
      (self.nativeDeps."git-run" or []);
    deps = {
      "minilog-2.0.6" = self.by-version."minilog"."2.0.6";
      "tabtab-0.0.2" = self.by-version."tabtab"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "git-run" ];
  };
  "git-run" = self.by-version."git-run"."0.2.0";
  by-spec."github-url-from-git"."^1.3.0" =
    self.by-version."github-url-from-git"."1.4.0";
  by-version."github-url-from-git"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-git-1.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-git/-/github-url-from-git-1.4.0.tgz";
        name = "github-url-from-git-1.4.0.tgz";
        sha1 = "285e6b520819001bde128674704379e4ff03e0de";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-url-from-git" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "github-url-from-git" ];
  };
  by-spec."github-url-from-git"."~1.4.0" =
    self.by-version."github-url-from-git"."1.4.0";
  by-spec."github-url-from-username-repo"."^1.0.0" =
    self.by-version."github-url-from-username-repo"."1.0.2";
  by-version."github-url-from-username-repo"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-username-repo-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-username-repo/-/github-url-from-username-repo-1.0.2.tgz";
        name = "github-url-from-username-repo-1.0.2.tgz";
        sha1 = "7dd79330d2abe69c10c2cef79714c97215791dfa";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-url-from-username-repo" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "github-url-from-username-repo" ];
  };
  by-spec."github-url-from-username-repo"."~1.0.0" =
    self.by-version."github-url-from-username-repo"."1.0.2";
  by-spec."github-url-from-username-repo"."~1.0.2" =
    self.by-version."github-url-from-username-repo"."1.0.2";
  by-spec."glob"."3 || 4" =
    self.by-version."glob"."4.0.6";
  by-version."glob"."4.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "glob-4.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-4.0.6.tgz";
        name = "glob-4.0.6.tgz";
        sha1 = "695c50bdd4e2fb5c5d370b091f388d3707e291a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.2.3" =
    self.by-version."glob"."3.2.3";
  by-version."glob"."3.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.3.tgz";
        name = "glob-3.2.3.tgz";
        sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.2.x" =
    self.by-version."glob"."3.2.11";
  by-version."glob"."3.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.11.tgz";
        name = "glob-3.2.11.tgz";
        sha1 = "4a973f635b9190f715d10987d5c00fd2815ebe3d";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.x" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."4.x" =
    self.by-version."glob"."4.0.6";
  by-spec."glob".">=3.2.7 <4" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."^4.0.0" =
    self.by-version."glob"."4.0.6";
  by-spec."glob"."^4.0.2" =
    self.by-version."glob"."4.0.6";
  by-spec."glob"."^4.0.5" =
    self.by-version."glob"."4.0.6";
  by-spec."glob"."~ 3.2.1" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.1.21" =
    self.by-version."glob"."3.1.21";
  by-version."glob"."3.1.21" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.1.21";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.1.21.tgz";
        name = "glob-3.1.21.tgz";
        sha1 = "d29e0a055dea5138f4d07ed40e8982e83c2066cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
      "inherits-1.0.0" = self.by-version."inherits"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."~3.2.1" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.6" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.7" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.9" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~4.0.2" =
    self.by-version."glob"."4.0.6";
  by-spec."glob"."~4.0.6" =
    self.by-version."glob"."4.0.6";
  by-spec."glob-stream"."^3.1.5" =
    self.by-version."glob-stream"."3.1.15";
  by-version."glob-stream"."3.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "glob-stream-3.1.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob-stream/-/glob-stream-3.1.15.tgz";
        name = "glob-stream-3.1.15.tgz";
        sha1 = "084bdbe9d8203fbb48bcf05c382dbb7e6666f8f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob-stream" or []);
    deps = {
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "ordered-read-streams-0.0.8" = self.by-version."ordered-read-streams"."0.0.8";
      "glob2base-0.0.11" = self.by-version."glob2base"."0.0.11";
      "unique-stream-1.0.0" = self.by-version."unique-stream"."1.0.0";
      "through2-0.6.3" = self.by-version."through2"."0.6.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob-stream" ];
  };
  by-spec."glob-watcher"."^0.0.6" =
    self.by-version."glob-watcher"."0.0.6";
  by-version."glob-watcher"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "glob-watcher-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob-watcher/-/glob-watcher-0.0.6.tgz";
        name = "glob-watcher-0.0.6.tgz";
        sha1 = "b95b4a8df74b39c83298b0c05c978b4d9a3b710b";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob-watcher" or []);
    deps = {
      "gaze-0.5.1" = self.by-version."gaze"."0.5.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob-watcher" ];
  };
  by-spec."glob2base"."^0.0.11" =
    self.by-version."glob2base"."0.0.11";
  by-version."glob2base"."0.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "glob2base-0.0.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob2base/-/glob2base-0.0.11.tgz";
        name = "glob2base-0.0.11.tgz";
        sha1 = "e56904ae5292c2d9cefbc5b97f419614fb56b660";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob2base" or []);
    deps = {
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob2base" ];
  };
  by-spec."globule"."~0.1.0" =
    self.by-version."globule"."0.1.0";
  by-version."globule"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "globule-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/globule/-/globule-0.1.0.tgz";
        name = "globule-0.1.0.tgz";
        sha1 = "d9c8edde1da79d125a151b79533b978676346ae5";
      })
    ];
    buildInputs =
      (self.nativeDeps."globule" or []);
    deps = {
      "lodash-1.0.1" = self.by-version."lodash"."1.0.1";
      "glob-3.1.21" = self.by-version."glob"."3.1.21";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
    };
    peerDependencies = [
    ];
    passthru.names = [ "globule" ];
  };
  by-spec."got"."^0.3.0" =
    self.by-version."got"."0.3.0";
  by-version."got"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "got-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/got/-/got-0.3.0.tgz";
        name = "got-0.3.0.tgz";
        sha1 = "888ec66ca4bc735ab089dbe959496d0f79485493";
      })
    ];
    buildInputs =
      (self.nativeDeps."got" or []);
    deps = {
      "object-assign-0.3.1" = self.by-version."object-assign"."0.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "got" ];
  };
  by-spec."graceful-fs"."2 || 3" =
    self.by-version."graceful-fs"."3.0.4";
  by-version."graceful-fs"."3.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-3.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.4.tgz";
        name = "graceful-fs-3.0.4.tgz";
        sha1 = "a0306d9b0940e0fc512d33b5df1014e88e0637a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."3" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs".">3.0.1 <4.0.0-0" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs"."^3.0.0" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs"."^3.0.2" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs"."~1" =
    self.by-version."graceful-fs"."1.2.3";
  by-version."graceful-fs"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        name = "graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."~1.2.0" =
    self.by-version."graceful-fs"."1.2.3";
  by-spec."graceful-fs"."~2.0.0" =
    self.by-version."graceful-fs"."2.0.3";
  by-version."graceful-fs"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.3.tgz";
        name = "graceful-fs-2.0.3.tgz";
        sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."~2.0.1" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~3.0.0" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs"."~3.0.1" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs"."~3.0.2" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."graceful-fs"."~3.0.4" =
    self.by-version."graceful-fs"."3.0.4";
  by-spec."gridfs-stream"."*" =
    self.by-version."gridfs-stream"."0.5.1";
  by-version."gridfs-stream"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "gridfs-stream-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gridfs-stream/-/gridfs-stream-0.5.1.tgz";
        name = "gridfs-stream-0.5.1.tgz";
        sha1 = "5fd94b0da4df1a602f7b0a02fb2365460d91b90c";
      })
    ];
    buildInputs =
      (self.nativeDeps."gridfs-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "gridfs-stream" ];
  };
  "gridfs-stream" = self.by-version."gridfs-stream"."0.5.1";
  by-spec."growl"."1.7.x" =
    self.by-version."growl"."1.7.0";
  by-version."growl"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "growl-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/growl/-/growl-1.7.0.tgz";
        name = "growl-1.7.0.tgz";
        sha1 = "de2d66136d002e112ba70f3f10c31cf7c350b2da";
      })
    ];
    buildInputs =
      (self.nativeDeps."growl" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "growl" ];
  };
  by-spec."growl"."1.8.1" =
    self.by-version."growl"."1.8.1";
  by-version."growl"."1.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "growl-1.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/growl/-/growl-1.8.1.tgz";
        name = "growl-1.8.1.tgz";
        sha1 = "4b2dec8d907e93db336624dcec0183502f8c9428";
      })
    ];
    buildInputs =
      (self.nativeDeps."growl" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "growl" ];
  };
  by-spec."grunt"."0.4.x" =
    self.by-version."grunt"."0.4.5";
  by-version."grunt"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-0.4.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt/-/grunt-0.4.5.tgz";
        name = "grunt-0.4.5.tgz";
        sha1 = "56937cd5194324adff6d207631832a9d6ba4e7f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt" or []);
    deps = {
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "coffee-script-1.3.3" = self.by-version."coffee-script"."1.3.3";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "dateformat-1.0.2-1.2.3" = self.by-version."dateformat"."1.0.2-1.2.3";
      "eventemitter2-0.4.14" = self.by-version."eventemitter2"."0.4.14";
      "findup-sync-0.1.3" = self.by-version."findup-sync"."0.1.3";
      "glob-3.1.21" = self.by-version."glob"."3.1.21";
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
      "iconv-lite-0.2.11" = self.by-version."iconv-lite"."0.2.11";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "lodash-0.9.2" = self.by-version."lodash"."0.9.2";
      "underscore.string-2.2.1" = self.by-version."underscore.string"."2.2.1";
      "which-1.0.5" = self.by-version."which"."1.0.5";
      "js-yaml-2.0.5" = self.by-version."js-yaml"."2.0.5";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "getobject-0.1.0" = self.by-version."getobject"."0.1.0";
      "grunt-legacy-util-0.2.0" = self.by-version."grunt-legacy-util"."0.2.0";
      "grunt-legacy-log-0.1.1" = self.by-version."grunt-legacy-log"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "grunt" ];
  };
  by-spec."grunt"."~0.4" =
    self.by-version."grunt"."0.4.5";
  by-spec."grunt"."~0.4.0" =
    self.by-version."grunt"."0.4.5";
  by-spec."grunt"."~0.4.1" =
    self.by-version."grunt"."0.4.5";
  by-spec."grunt-cli"."*" =
    self.by-version."grunt-cli"."0.1.13";
  by-version."grunt-cli"."0.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-cli-0.1.13";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-cli/-/grunt-cli-0.1.13.tgz";
        name = "grunt-cli-0.1.13.tgz";
        sha1 = "e9ebc4047631f5012d922770c39378133cad10f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-cli" or []);
    deps = {
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
      "findup-sync-0.1.3" = self.by-version."findup-sync"."0.1.3";
      "resolve-0.3.1" = self.by-version."resolve"."0.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "grunt-cli" ];
  };
  "grunt-cli" = self.by-version."grunt-cli"."0.1.13";
  by-spec."grunt-contrib-cssmin"."*" =
    self.by-version."grunt-contrib-cssmin"."0.10.0";
  by-version."grunt-contrib-cssmin"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-cssmin-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-cssmin/-/grunt-contrib-cssmin-0.10.0.tgz";
        name = "grunt-contrib-cssmin-0.10.0.tgz";
        sha1 = "e05f341e753a9674b2b1070220fdcbac22079418";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-cssmin" or []);
    deps = {
      "chalk-0.4.0" = self.by-version."chalk"."0.4.0";
      "clean-css-2.2.16" = self.by-version."clean-css"."2.2.16";
      "maxmin-0.2.2" = self.by-version."maxmin"."0.2.2";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-contrib-cssmin" ];
  };
  "grunt-contrib-cssmin" = self.by-version."grunt-contrib-cssmin"."0.10.0";
  by-spec."grunt-contrib-jshint"."*" =
    self.by-version."grunt-contrib-jshint"."0.10.0";
  by-version."grunt-contrib-jshint"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-jshint-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-jshint/-/grunt-contrib-jshint-0.10.0.tgz";
        name = "grunt-contrib-jshint-0.10.0.tgz";
        sha1 = "57ebccca87e8f327af6645d8a3c586d4845e4d81";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-jshint" or []);
    deps = {
      "jshint-2.5.6" = self.by-version."jshint"."2.5.6";
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-contrib-jshint" ];
  };
  "grunt-contrib-jshint" = self.by-version."grunt-contrib-jshint"."0.10.0";
  by-spec."grunt-contrib-less"."*" =
    self.by-version."grunt-contrib-less"."0.11.4";
  by-version."grunt-contrib-less"."0.11.4" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-less-0.11.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-less/-/grunt-contrib-less-0.11.4.tgz";
        name = "grunt-contrib-less-0.11.4.tgz";
        sha1 = "5667475ac4517f32ca623b9a4d81d6cf4aed2b51";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-less" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "less-1.7.5" = self.by-version."less"."1.7.5";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "maxmin-0.1.0" = self.by-version."maxmin"."0.1.0";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-contrib-less" ];
  };
  "grunt-contrib-less" = self.by-version."grunt-contrib-less"."0.11.4";
  by-spec."grunt-contrib-requirejs"."*" =
    self.by-version."grunt-contrib-requirejs"."0.4.4";
  by-version."grunt-contrib-requirejs"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-requirejs-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-requirejs/-/grunt-contrib-requirejs-0.4.4.tgz";
        name = "grunt-contrib-requirejs-0.4.4.tgz";
        sha1 = "87f2165a981e48a45d22f8cc5299d0934031b972";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-requirejs" or []);
    deps = {
      "requirejs-2.1.15" = self.by-version."requirejs"."2.1.15";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-contrib-requirejs" ];
  };
  "grunt-contrib-requirejs" = self.by-version."grunt-contrib-requirejs"."0.4.4";
  by-spec."grunt-contrib-uglify"."*" =
    self.by-version."grunt-contrib-uglify"."0.6.0";
  by-version."grunt-contrib-uglify"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-uglify-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-0.6.0.tgz";
        name = "grunt-contrib-uglify-0.6.0.tgz";
        sha1 = "3a271d4dc4daba64691d0d0d08550ec54a7ec0ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-uglify" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "maxmin-1.0.0" = self.by-version."maxmin"."1.0.0";
      "uglify-js-2.4.15" = self.by-version."uglify-js"."2.4.15";
      "uri-path-0.0.2" = self.by-version."uri-path"."0.0.2";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-contrib-uglify" ];
  };
  "grunt-contrib-uglify" = self.by-version."grunt-contrib-uglify"."0.6.0";
  by-spec."grunt-karma"."*" =
    self.by-version."grunt-karma"."0.9.0";
  by-version."grunt-karma"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-karma-0.9.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-karma/-/grunt-karma-0.9.0.tgz";
        name = "grunt-karma-0.9.0.tgz";
        sha1 = "de3d6ac478ffca350e729f3457457d5b0910e96b";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-karma" or []);
    deps = {
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
      self.by-version."karma"."0.12.24"
    ];
    passthru.names = [ "grunt-karma" ];
  };
  "grunt-karma" = self.by-version."grunt-karma"."0.9.0";
  by-spec."grunt-legacy-log"."~0.1.0" =
    self.by-version."grunt-legacy-log"."0.1.1";
  by-version."grunt-legacy-log"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-legacy-log-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-legacy-log/-/grunt-legacy-log-0.1.1.tgz";
        name = "grunt-legacy-log-0.1.1.tgz";
        sha1 = "d41f1a6abc9b0b1256a2b5ff02f4c3298dfcd57a";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-legacy-log" or []);
    deps = {
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "underscore.string-2.3.3" = self.by-version."underscore.string"."2.3.3";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "grunt-legacy-log" ];
  };
  by-spec."grunt-legacy-util"."~0.2.0" =
    self.by-version."grunt-legacy-util"."0.2.0";
  by-version."grunt-legacy-util"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-legacy-util-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-legacy-util/-/grunt-legacy-util-0.2.0.tgz";
        name = "grunt-legacy-util-0.2.0.tgz";
        sha1 = "93324884dbf7e37a9ff7c026dff451d94a9e554b";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-legacy-util" or []);
    deps = {
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "lodash-0.9.2" = self.by-version."lodash"."0.9.2";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "underscore.string-2.2.1" = self.by-version."underscore.string"."2.2.1";
      "getobject-0.1.0" = self.by-version."getobject"."0.1.0";
      "which-1.0.5" = self.by-version."which"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "grunt-legacy-util" ];
  };
  by-spec."grunt-sed"."*" =
    self.by-version."grunt-sed"."0.1.1";
  by-version."grunt-sed"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-sed-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-sed/-/grunt-sed-0.1.1.tgz";
        name = "grunt-sed-0.1.1.tgz";
        sha1 = "2613d486909319b3f8f4bd75dafb46a642ec3f82";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-sed" or []);
    deps = {
      "replace-0.2.10" = self.by-version."replace"."0.2.10";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-sed" ];
  };
  "grunt-sed" = self.by-version."grunt-sed"."0.1.1";
  by-spec."guifi-earth"."https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854 " =
    self.by-version."guifi-earth"."0.2.1";
  by-version."guifi-earth"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "guifi-earth-0.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854";
        name = "guifi-earth-0.2.1.tgz";
        sha256 = "a51a5beef55c14c68630275d51cf66c44a4462d1b20c0f08aef6d88a62ca077c";
      })
    ];
    buildInputs =
      (self.nativeDeps."guifi-earth" or []);
    deps = {
      "coffee-script-1.8.0" = self.by-version."coffee-script"."1.8.0";
      "jade-1.7.0" = self.by-version."jade"."1.7.0";
      "q-2.0.2" = self.by-version."q"."2.0.2";
      "xml2js-0.4.4" = self.by-version."xml2js"."0.4.4";
      "msgpack-0.2.4" = self.by-version."msgpack"."0.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "guifi-earth" ];
  };
  "guifi-earth" = self.by-version."guifi-earth"."0.2.1";
  by-spec."gulp"."*" =
    self.by-version."gulp"."3.8.9";
  by-version."gulp"."3.8.9" = lib.makeOverridable self.buildNodePackage {
    name = "gulp-3.8.9";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gulp/-/gulp-3.8.9.tgz";
        name = "gulp-3.8.9.tgz";
        sha1 = "90773dc79cb0b3087e5443c695b0f5a21548ccce";
      })
    ];
    buildInputs =
      (self.nativeDeps."gulp" or []);
    deps = {
      "archy-0.0.2" = self.by-version."archy"."0.0.2";
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "deprecated-0.0.1" = self.by-version."deprecated"."0.0.1";
      "gulp-util-3.0.1" = self.by-version."gulp-util"."3.0.1";
      "interpret-0.3.7" = self.by-version."interpret"."0.3.7";
      "liftoff-0.13.5" = self.by-version."liftoff"."0.13.5";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "orchestrator-0.3.7" = self.by-version."orchestrator"."0.3.7";
      "pretty-hrtime-0.2.2" = self.by-version."pretty-hrtime"."0.2.2";
      "semver-3.0.1" = self.by-version."semver"."3.0.1";
      "tildify-1.0.0" = self.by-version."tildify"."1.0.0";
      "v8flags-1.0.1" = self.by-version."v8flags"."1.0.1";
      "vinyl-fs-0.3.10" = self.by-version."vinyl-fs"."0.3.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gulp" ];
  };
  "gulp" = self.by-version."gulp"."3.8.9";
  by-spec."gulp-util"."^3.0.0" =
    self.by-version."gulp-util"."3.0.1";
  by-version."gulp-util"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "gulp-util-3.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gulp-util/-/gulp-util-3.0.1.tgz";
        name = "gulp-util-3.0.1.tgz";
        sha1 = "8214894d05c2bb6cc7f5544918a51ddf88180f00";
      })
    ];
    buildInputs =
      (self.nativeDeps."gulp-util" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "dateformat-1.0.8" = self.by-version."dateformat"."1.0.8";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "lodash._reinterpolate-2.4.1" = self.by-version."lodash._reinterpolate"."2.4.1";
      "lodash.template-2.4.1" = self.by-version."lodash.template"."2.4.1";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "multipipe-0.1.1" = self.by-version."multipipe"."0.1.1";
      "through2-0.6.3" = self.by-version."through2"."0.6.3";
      "vinyl-0.4.3" = self.by-version."vinyl"."0.4.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gulp-util" ];
  };
  by-spec."gzip-size"."^0.1.0" =
    self.by-version."gzip-size"."0.1.1";
  by-version."gzip-size"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "gzip-size-0.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzip-size/-/gzip-size-0.1.1.tgz";
        name = "gzip-size-0.1.1.tgz";
        sha1 = "ae33483b6fc8224e8342296de108ef93757f76e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzip-size" or []);
    deps = {
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "zlib-browserify-0.0.3" = self.by-version."zlib-browserify"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gzip-size" ];
  };
  by-spec."gzip-size"."^0.2.0" =
    self.by-version."gzip-size"."0.2.0";
  by-version."gzip-size"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "gzip-size-0.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzip-size/-/gzip-size-0.2.0.tgz";
        name = "gzip-size-0.2.0.tgz";
        sha1 = "e3a2a191205fe56ee326f5c271435dfaecfb3e1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzip-size" or []);
    deps = {
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gzip-size" ];
  };
  by-spec."gzip-size"."^1.0.0" =
    self.by-version."gzip-size"."1.0.0";
  by-version."gzip-size"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "gzip-size-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzip-size/-/gzip-size-1.0.0.tgz";
        name = "gzip-size-1.0.0.tgz";
        sha1 = "66cf8b101047227b95bace6ea1da0c177ed5c22f";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzip-size" or []);
    deps = {
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gzip-size" ];
  };
  by-spec."gzippo"."*" =
    self.by-version."gzippo"."0.2.0";
  by-version."gzippo"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "gzippo-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzippo/-/gzippo-0.2.0.tgz";
        name = "gzippo-0.2.0.tgz";
        sha1 = "ffc594c482190c56531ed2d4a5864d0b0b7d2733";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzippo" or []);
    deps = {
      "send-0.10.0" = self.by-version."send"."0.10.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gzippo" ];
  };
  "gzippo" = self.by-version."gzippo"."0.2.0";
  by-spec."handlebars"."1.3.x" =
    self.by-version."handlebars"."1.3.0";
  by-version."handlebars"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.3.0.tgz";
        name = "handlebars-1.3.0.tgz";
        sha1 = "9e9b130a93e389491322d975cf3ec1818c37ce34";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars" or []);
    deps = {
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
      "uglify-js-2.3.6" = self.by-version."uglify-js"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  by-spec."handlebars"."~2.0.0" =
    self.by-version."handlebars"."2.0.0";
  by-version."handlebars"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-2.0.0.tgz";
        name = "handlebars-2.0.0.tgz";
        sha1 = "6e9d7f8514a3467fa5e9f82cc158ecfc1d5ac76f";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars" or []);
    deps = {
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
      "uglify-js-2.3.6" = self.by-version."uglify-js"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  by-spec."has-ansi"."^0.1.0" =
    self.by-version."has-ansi"."0.1.0";
  by-version."has-ansi"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "has-ansi-0.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-ansi/-/has-ansi-0.1.0.tgz";
        name = "has-ansi-0.1.0.tgz";
        sha1 = "84f265aae8c0e6a88a12d7022894b7568894c62e";
      })
    ];
    buildInputs =
      (self.nativeDeps."has-ansi" or []);
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "has-ansi" ];
  };
  by-spec."has-color"."~0.1.0" =
    self.by-version."has-color"."0.1.7";
  by-version."has-color"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "has-color-0.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-color/-/has-color-0.1.7.tgz";
        name = "has-color-0.1.7.tgz";
        sha1 = "67144a5260c34fc3cca677d041daf52fe7b78b2f";
      })
    ];
    buildInputs =
      (self.nativeDeps."has-color" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "has-color" ];
  };
  by-spec."hasher"."~1.2.0" =
    self.by-version."hasher"."1.2.0";
  by-version."hasher"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "hasher-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hasher/-/hasher-1.2.0.tgz";
        name = "hasher-1.2.0.tgz";
        sha1 = "8b5341c3496124b0724ac8555fbb8ca363ebbb73";
      })
    ];
    buildInputs =
      (self.nativeDeps."hasher" or []);
    deps = {
      "signals-1.0.0" = self.by-version."signals"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hasher" ];
  };
  by-spec."hashring"."1.0.1" =
    self.by-version."hashring"."1.0.1";
  by-version."hashring"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "hashring-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hashring/-/hashring-1.0.1.tgz";
        name = "hashring-1.0.1.tgz";
        sha1 = "b6a7b8c675a0c715ac0d0071786eb241a28d0a7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."hashring" or []);
    deps = {
      "connection-parse-0.0.7" = self.by-version."connection-parse"."0.0.7";
      "simple-lru-cache-0.0.1" = self.by-version."simple-lru-cache"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hashring" ];
  };
  by-spec."hat"."*" =
    self.by-version."hat"."0.0.3";
  by-version."hat"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "hat-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hat/-/hat-0.0.3.tgz";
        name = "hat-0.0.3.tgz";
        sha1 = "bb014a9e64b3788aed8005917413d4ff3d502d8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hat" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hat" ];
  };
  by-spec."hawk"."1.1.1" =
    self.by-version."hawk"."1.1.1";
  by-version."hawk"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.1.1.tgz";
        name = "hawk-1.1.1.tgz";
        sha1 = "87cd491f9b46e4e2aeaca335416766885d2d1ed9";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."hawk"."~0.10.2" =
    self.by-version."hawk"."0.10.2";
  by-version."hawk"."0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.10.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.10.2.tgz";
        name = "hawk-0.10.2.tgz";
        sha1 = "9b361dee95a931640e6d504e05609a8fc3ac45d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
      "boom-0.3.8" = self.by-version."boom"."0.3.8";
      "cryptiles-0.1.3" = self.by-version."cryptiles"."0.1.3";
      "sntp-0.1.4" = self.by-version."sntp"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."hawk"."~1.0.0" =
    self.by-version."hawk"."1.0.0";
  by-version."hawk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.0.0.tgz";
        name = "hawk-1.0.0.tgz";
        sha1 = "b90bb169807285411da7ffcb8dd2598502d3b52d";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."he"."~0.3.6" =
    self.by-version."he"."0.3.6";
  by-version."he"."0.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "he-0.3.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/he/-/he-0.3.6.tgz";
        name = "he-0.3.6.tgz";
        sha1 = "9d7bc446e77963933301dd602d5731cb861135e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."he" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "he" ];
  };
  by-spec."hipache"."*" =
    self.by-version."hipache"."0.3.1";
  by-version."hipache"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "hipache-0.3.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hipache/-/hipache-0.3.1.tgz";
        name = "hipache-0.3.1.tgz";
        sha1 = "e21764eafe6429ec8dc9377b55e1ca86799704d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."hipache" or []);
    deps = {
      "http-proxy-1.0.2" = self.by-version."http-proxy"."1.0.2";
      "redis-0.10.3" = self.by-version."redis"."0.10.3";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hipache" ];
  };
  "hipache" = self.by-version."hipache"."0.3.1";
  by-spec."hiredis"."*" =
    self.by-version."hiredis"."0.1.17";
  by-version."hiredis"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "hiredis-0.1.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hiredis/-/hiredis-0.1.17.tgz";
        name = "hiredis-0.1.17.tgz";
        sha1 = "60a33a968efc9a974e7ebb832f33aa965d3d354e";
      })
    ];
    buildInputs =
      (self.nativeDeps."hiredis" or []);
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.1.2" = self.by-version."nan"."1.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hiredis" ];
  };
  by-spec."hoek"."0.7.x" =
    self.by-version."hoek"."0.7.6";
  by-version."hoek"."0.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.7.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.7.6.tgz";
        name = "hoek-0.7.6.tgz";
        sha1 = "60fbd904557541cd2b8795abf308a1b3770e155a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.9.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
        name = "hoek-0.9.1.tgz";
        sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."hooker"."~0.2.3" =
    self.by-version."hooker"."0.2.3";
  by-version."hooker"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "hooker-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hooker/-/hooker-0.2.3.tgz";
        name = "hooker-0.2.3.tgz";
        sha1 = "b834f723cc4a242aa65963459df6d984c5d3d959";
      })
    ];
    buildInputs =
      (self.nativeDeps."hooker" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hooker" ];
  };
  by-spec."hooks"."0.2.1" =
    self.by-version."hooks"."0.2.1";
  by-version."hooks"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "hooks-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hooks/-/hooks-0.2.1.tgz";
        name = "hooks-0.2.1.tgz";
        sha1 = "0f591b1b344bdcb3df59773f62fbbaf85bf4028b";
      })
    ];
    buildInputs =
      (self.nativeDeps."hooks" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hooks" ];
  };
  by-spec."htmlparser2"."3.7.x" =
    self.by-version."htmlparser2"."3.7.3";
  by-version."htmlparser2"."3.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-3.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.7.3.tgz";
        name = "htmlparser2-3.7.3.tgz";
        sha1 = "6a64c77637c08c6f30ec2a8157a53333be7cb05e";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = {
      "domhandler-2.2.0" = self.by-version."domhandler"."2.2.0";
      "domutils-1.5.0" = self.by-version."domutils"."1.5.0";
      "domelementtype-1.1.1" = self.by-version."domelementtype"."1.1.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "entities-1.0.0" = self.by-version."entities"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."http-auth"."2.0.7" =
    self.by-version."http-auth"."2.0.7";
  by-version."http-auth"."2.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "http-auth-2.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-auth/-/http-auth-2.0.7.tgz";
        name = "http-auth-2.0.7.tgz";
        sha1 = "aa1a61a4d6baae9d64436c6f0ef0f4de85c430e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-auth" or []);
    deps = {
      "coffee-script-1.6.3" = self.by-version."coffee-script"."1.6.3";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-auth" ];
  };
  by-spec."http-browserify"."^1.4.0" =
    self.by-version."http-browserify"."1.7.0";
  by-version."http-browserify"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "http-browserify-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-browserify/-/http-browserify-1.7.0.tgz";
        name = "http-browserify-1.7.0.tgz";
        sha1 = "33795ade72df88acfbfd36773cefeda764735b20";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-browserify" or []);
    deps = {
      "Base64-0.2.1" = self.by-version."Base64"."0.2.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-browserify" ];
  };
  by-spec."http-errors"."~1.2.6" =
    self.by-version."http-errors"."1.2.7";
  by-version."http-errors"."1.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "http-errors-1.2.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-errors/-/http-errors-1.2.7.tgz";
        name = "http-errors-1.2.7.tgz";
        sha1 = "b881fa12c59b0079fd4ced456bf8dbc9610d3b78";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-errors" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "statuses-1.2.0" = self.by-version."statuses"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-errors" ];
  };
  by-spec."http-errors"."~1.2.7" =
    self.by-version."http-errors"."1.2.7";
  by-spec."http-proxy"."1.0.2" =
    self.by-version."http-proxy"."1.0.2";
  by-version."http-proxy"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "http-proxy-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-proxy/-/http-proxy-1.0.2.tgz";
        name = "http-proxy-1.0.2.tgz";
        sha1 = "08060ff2edb2189e57aa3a152d3ac63ed1af7254";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-proxy" or []);
    deps = {
      "eventemitter3-0.1.5" = self.by-version."eventemitter3"."0.1.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-proxy" ];
  };
  by-spec."http-proxy"."~0.10" =
    self.by-version."http-proxy"."0.10.4";
  by-version."http-proxy"."0.10.4" = lib.makeOverridable self.buildNodePackage {
    name = "http-proxy-0.10.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-proxy/-/http-proxy-0.10.4.tgz";
        name = "http-proxy-0.10.4.tgz";
        sha1 = "14ba0ceaa2197f89fa30dea9e7b09e19cd93c22f";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-proxy" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-proxy" ];
  };
  by-spec."http-signature"."0.9.11" =
    self.by-version."http-signature"."0.9.11";
  by-version."http-signature"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.9.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.9.11.tgz";
        name = "http-signature-0.9.11.tgz";
        sha1 = "9e882714572315e6790a5d0a7955efff1f19e653";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.2" = self.by-version."ctype"."0.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.0";
  by-version."http-signature"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.0.tgz";
        name = "http-signature-0.10.0.tgz";
        sha1 = "1494e4f5000a83c0f11bcc12d6007c530cb99582";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.2" = self.by-version."ctype"."0.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."https-browserify"."~0.0.0" =
    self.by-version."https-browserify"."0.0.0";
  by-version."https-browserify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "https-browserify-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/https-browserify/-/https-browserify-0.0.0.tgz";
        name = "https-browserify-0.0.0.tgz";
        sha1 = "b3ffdfe734b2a3d4a9efd58e8654c91fce86eafd";
      })
    ];
    buildInputs =
      (self.nativeDeps."https-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "https-browserify" ];
  };
  by-spec."humanize"."~0.0.9" =
    self.by-version."humanize"."0.0.9";
  by-version."humanize"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "humanize-0.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/humanize/-/humanize-0.0.9.tgz";
        name = "humanize-0.0.9.tgz";
        sha1 = "1994ffaecdfe9c441ed2bdac7452b7bb4c9e41a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."humanize" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "humanize" ];
  };
  by-spec."i"."0.3.x" =
    self.by-version."i"."0.3.2";
  by-version."i"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "i-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/i/-/i-0.3.2.tgz";
        name = "i-0.3.2.tgz";
        sha1 = "b2e2d6ef47900bd924e281231ff4c5cc798d9ea8";
      })
    ];
    buildInputs =
      (self.nativeDeps."i" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "i" ];
  };
  by-spec."i18next"."*" =
    self.by-version."i18next"."1.7.4";
  by-version."i18next"."1.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "i18next-1.7.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/i18next/-/i18next-1.7.4.tgz";
        name = "i18next-1.7.4.tgz";
        sha1 = "b61629c9de95a5c076acb2f954f8a882ac0772af";
      })
    ];
    buildInputs =
      (self.nativeDeps."i18next" or []);
    deps = {
      "cookies-0.5.0" = self.by-version."cookies"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "i18next" ];
  };
  "i18next" = self.by-version."i18next"."1.7.4";
  by-spec."ibrik"."~1.1.1" =
    self.by-version."ibrik"."1.1.1";
  by-version."ibrik"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "ibrik-1.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ibrik/-/ibrik-1.1.1.tgz";
        name = "ibrik-1.1.1.tgz";
        sha1 = "c9bd04c5137e967a2f0dbc9e4eb31dbfa04801b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."ibrik" or []);
    deps = {
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "coffee-script-redux-2.0.0-beta8" = self.by-version."coffee-script-redux"."2.0.0-beta8";
      "istanbul-0.2.16" = self.by-version."istanbul"."0.2.16";
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "escodegen-1.1.0" = self.by-version."escodegen"."1.1.0";
      "which-1.0.5" = self.by-version."which"."1.0.5";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ibrik" ];
  };
  by-spec."iconv-lite"."0.4.4" =
    self.by-version."iconv-lite"."0.4.4";
  by-version."iconv-lite"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.4.tgz";
        name = "iconv-lite-0.4.4.tgz";
        sha1 = "e95f2e41db0735fc21652f7827a5ee32e63c83a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  by-spec."iconv-lite"."~0.2.11" =
    self.by-version."iconv-lite"."0.2.11";
  by-version."iconv-lite"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.2.11.tgz";
        name = "iconv-lite-0.2.11.tgz";
        sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  by-spec."iconv-lite"."~0.4.4" =
    self.by-version."iconv-lite"."0.4.4";
  by-spec."ieee754"."^1.1.4" =
    self.by-version."ieee754"."1.1.4";
  by-version."ieee754"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "ieee754-1.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ieee754/-/ieee754-1.1.4.tgz";
        name = "ieee754-1.1.4.tgz";
        sha1 = "e3ec65200d4ad531d359aabdb6d3ec812699a30b";
      })
    ];
    buildInputs =
      (self.nativeDeps."ieee754" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ieee754" ];
  };
  by-spec."indexof"."0.0.1" =
    self.by-version."indexof"."0.0.1";
  by-version."indexof"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "indexof-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/indexof/-/indexof-0.0.1.tgz";
        name = "indexof-0.0.1.tgz";
        sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
      })
    ];
    buildInputs =
      (self.nativeDeps."indexof" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "indexof" ];
  };
  by-spec."inflight"."~1.0.4" =
    self.by-version."inflight"."1.0.4";
  by-version."inflight"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "inflight-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
        name = "inflight-1.0.4.tgz";
        sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
      })
    ];
    buildInputs =
      (self.nativeDeps."inflight" or []);
    deps = {
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "inflight" ];
  };
  by-spec."inherits"."1" =
    self.by-version."inherits"."1.0.0";
  by-version."inherits"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
        name = "inherits-1.0.0.tgz";
        sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  by-spec."inherits"."1.x" =
    self.by-version."inherits"."1.0.0";
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        name = "inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  by-spec."inherits"."2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."^2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~1.0.0" =
    self.by-version."inherits"."1.0.0";
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ini"."1" =
    self.by-version."ini"."1.3.0";
  by-version."ini"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.3.0.tgz";
        name = "ini-1.3.0.tgz";
        sha1 = "625483e56c643a7721014c76604d3353f44bd429";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  by-spec."ini"."1.x.x" =
    self.by-version."ini"."1.3.0";
  by-spec."ini"."^1.2.0" =
    self.by-version."ini"."1.3.0";
  by-spec."ini"."~1.1.0" =
    self.by-version."ini"."1.1.0";
  by-version."ini"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.1.0.tgz";
        name = "ini-1.1.0.tgz";
        sha1 = "4e808c2ce144c6c1788918e034d6797bc6cf6281";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  by-spec."ini"."~1.3.0" =
    self.by-version."ini"."1.3.0";
  by-spec."init-package-json"."~1.1.0" =
    self.by-version."init-package-json"."1.1.0";
  by-version."init-package-json"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-1.1.0.tgz";
        name = "init-package-json-1.1.0.tgz";
        sha1 = "fea80c641974421ddd4c6169c3a911118b116d5c";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json" or []);
    deps = {
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "promzard-0.2.2" = self.by-version."promzard"."0.2.2";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  by-spec."inline-source-map"."~0.3.0" =
    self.by-version."inline-source-map"."0.3.0";
  by-version."inline-source-map"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "inline-source-map-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inline-source-map/-/inline-source-map-0.3.0.tgz";
        name = "inline-source-map-0.3.0.tgz";
        sha1 = "ad2acca97d82fcb9d0a56221ee72e8043116424a";
      })
    ];
    buildInputs =
      (self.nativeDeps."inline-source-map" or []);
    deps = {
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "inline-source-map" ];
  };
  by-spec."inquirer"."0.7.1" =
    self.by-version."inquirer"."0.7.1";
  by-version."inquirer"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.7.1.tgz";
        name = "inquirer-0.7.1.tgz";
        sha1 = "b8acf140165bd581862ed1198fb6d26430091fac";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "cli-color-0.3.2" = self.by-version."cli-color"."0.3.2";
      "figures-1.3.3" = self.by-version."figures"."1.3.3";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
      "readline2-0.1.0" = self.by-version."readline2"."0.1.0";
      "rx-2.3.13" = self.by-version."rx"."2.3.13";
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  by-spec."inquirer"."^0.6.0" =
    self.by-version."inquirer"."0.6.0";
  by-version."inquirer"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.6.0.tgz";
        name = "inquirer-0.6.0.tgz";
        sha1 = "614d7bb3e48f9e6a8028e94a0c38f23ef29823d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "cli-color-0.3.2" = self.by-version."cli-color"."0.3.2";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
      "readline2-0.1.0" = self.by-version."readline2"."0.1.0";
      "rx-2.3.13" = self.by-version."rx"."2.3.13";
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  by-spec."insert-module-globals"."^6.1.0" =
    self.by-version."insert-module-globals"."6.1.0";
  by-version."insert-module-globals"."6.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "insert-module-globals-6.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insert-module-globals/-/insert-module-globals-6.1.0.tgz";
        name = "insert-module-globals-6.1.0.tgz";
        sha1 = "b0ee36d97057e9eda133ad6d4b00a8821cd63663";
      })
    ];
    buildInputs =
      (self.nativeDeps."insert-module-globals" or []);
    deps = {
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "lexical-scope-1.1.0" = self.by-version."lexical-scope"."1.1.0";
      "process-0.6.0" = self.by-version."process"."0.6.0";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insert-module-globals" ];
  };
  by-spec."insight"."0.4.3" =
    self.by-version."insight"."0.4.3";
  by-version."insight"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "insight-0.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insight/-/insight-0.4.3.tgz";
        name = "insight-0.4.3.tgz";
        sha1 = "76d653c5c0d8048b03cdba6385a6948f74614af0";
      })
    ];
    buildInputs =
      (self.nativeDeps."insight" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "configstore-0.3.1" = self.by-version."configstore"."0.3.1";
      "inquirer-0.6.0" = self.by-version."inquirer"."0.6.0";
      "lodash.debounce-2.4.1" = self.by-version."lodash.debounce"."2.4.1";
      "object-assign-1.0.0" = self.by-version."object-assign"."1.0.0";
      "os-name-1.0.1" = self.by-version."os-name"."1.0.1";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insight" ];
  };
  by-spec."interpret"."^0.3.2" =
    self.by-version."interpret"."0.3.7";
  by-version."interpret"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "interpret-0.3.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/interpret/-/interpret-0.3.7.tgz";
        name = "interpret-0.3.7.tgz";
        sha1 = "18727eda04d50632ffa4b5eafb342b7ff398b36e";
      })
    ];
    buildInputs =
      (self.nativeDeps."interpret" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "interpret" ];
  };
  by-spec."intersect"."~0.0.3" =
    self.by-version."intersect"."0.0.3";
  by-version."intersect"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "intersect-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/intersect/-/intersect-0.0.3.tgz";
        name = "intersect-0.0.3.tgz";
        sha1 = "c1a4a5e5eac6ede4af7504cc07e0ada7bc9f4920";
      })
    ];
    buildInputs =
      (self.nativeDeps."intersect" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "intersect" ];
  };
  by-spec."ipaddr.js"."0.1.2" =
    self.by-version."ipaddr.js"."0.1.2";
  by-version."ipaddr.js"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "ipaddr.js-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.2.tgz";
        name = "ipaddr.js-0.1.2.tgz";
        sha1 = "6a1fd3d854f5002965c34d7bbcd9b4a8d4b0467e";
      })
    ];
    buildInputs =
      (self.nativeDeps."ipaddr.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ipaddr.js" ];
  };
  by-spec."ipaddr.js"."0.1.3" =
    self.by-version."ipaddr.js"."0.1.3";
  by-version."ipaddr.js"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "ipaddr.js-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.3.tgz";
        name = "ipaddr.js-0.1.3.tgz";
        sha1 = "27a9ca37f148d2102b0ef191ccbf2c51a8f025c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."ipaddr.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ipaddr.js" ];
  };
  by-spec."ironhorse"."*" =
    self.by-version."ironhorse"."0.0.10";
  by-version."ironhorse"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "ironhorse-0.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ironhorse/-/ironhorse-0.0.10.tgz";
        name = "ironhorse-0.0.10.tgz";
        sha1 = "98c1c9e29889fabbaaea0ce558501c47f9319856";
      })
    ];
    buildInputs =
      (self.nativeDeps."ironhorse" or []);
    deps = {
      "underscore-1.5.2" = self.by-version."underscore"."1.5.2";
      "winston-0.8.1" = self.by-version."winston"."0.8.1";
      "nconf-0.6.9" = self.by-version."nconf"."0.6.9";
      "fs-walk-0.0.1" = self.by-version."fs-walk"."0.0.1";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "express-4.9.8" = self.by-version."express"."4.9.8";
      "jade-1.7.0" = self.by-version."jade"."1.7.0";
      "passport-0.2.1" = self.by-version."passport"."0.2.1";
      "passport-http-0.2.2" = self.by-version."passport-http"."0.2.2";
      "js-yaml-3.2.2" = self.by-version."js-yaml"."3.2.2";
      "mongoose-3.8.17" = self.by-version."mongoose"."3.8.17";
      "gridfs-stream-0.5.1" = self.by-version."gridfs-stream"."0.5.1";
      "temp-0.8.1" = self.by-version."temp"."0.8.1";
      "kue-0.8.9" = self.by-version."kue"."0.8.9";
      "redis-0.12.1" = self.by-version."redis"."0.12.1";
      "hiredis-0.1.17" = self.by-version."hiredis"."0.1.17";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ironhorse" ];
  };
  "ironhorse" = self.by-version."ironhorse"."0.0.10";
  by-spec."is-array"."^1.0.1" =
    self.by-version."is-array"."1.0.1";
  by-version."is-array"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "is-array-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-array/-/is-array-1.0.1.tgz";
        name = "is-array-1.0.1.tgz";
        sha1 = "e9850cc2cc860c3bc0977e84ccf0dd464584279a";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-array" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-array" ];
  };
  by-spec."is-promise"."~1" =
    self.by-version."is-promise"."1.0.1";
  by-version."is-promise"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "is-promise-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-promise/-/is-promise-1.0.1.tgz";
        name = "is-promise-1.0.1.tgz";
        sha1 = "31573761c057e33c2e91aab9e96da08cefbe76e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-promise" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-promise" ];
  };
  by-spec."is-root"."~1.0.0" =
    self.by-version."is-root"."1.0.0";
  by-version."is-root"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-root-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-root/-/is-root-1.0.0.tgz";
        name = "is-root-1.0.0.tgz";
        sha1 = "07b6c233bc394cd9d02ba15c966bd6660d6342d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-root" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-root" ];
  };
  by-spec."is-utf8"."^0.2.0" =
    self.by-version."is-utf8"."0.2.0";
  by-version."is-utf8"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-utf8-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-utf8/-/is-utf8-0.2.0.tgz";
        name = "is-utf8-0.2.0.tgz";
        sha1 = "b8aa54125ae626bfe4e3beb965f16a89c58a1137";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-utf8" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-utf8" ];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "isarray-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
        name = "isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      })
    ];
    buildInputs =
      (self.nativeDeps."isarray" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "isarray" ];
  };
  by-spec."isarray"."~0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-spec."istanbul"."*" =
    self.by-version."istanbul"."0.3.2";
  by-version."istanbul"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.3.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.3.2.tgz";
        name = "istanbul-0.3.2.tgz";
        sha1 = "e1ce9a9ec80d51dcbbeca82149f3befdc21d6835";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul" or []);
    deps = {
      "esprima-1.2.2" = self.by-version."esprima"."1.2.2";
      "escodegen-1.3.3" = self.by-version."escodegen"."1.3.3";
      "handlebars-1.3.0" = self.by-version."handlebars"."1.3.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "fileset-0.1.5" = self.by-version."fileset"."0.1.5";
      "which-1.0.5" = self.by-version."which"."1.0.5";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "js-yaml-3.2.2" = self.by-version."js-yaml"."3.2.2";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  "istanbul" = self.by-version."istanbul"."0.3.2";
  by-spec."istanbul"."~0.2.4" =
    self.by-version."istanbul"."0.2.16";
  by-version."istanbul"."0.2.16" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.2.16";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.2.16.tgz";
        name = "istanbul-0.2.16.tgz";
        sha1 = "870545a0d4f4b4ce161039e9e805a98c2c700bd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul" or []);
    deps = {
      "esprima-1.2.2" = self.by-version."esprima"."1.2.2";
      "escodegen-1.3.3" = self.by-version."escodegen"."1.3.3";
      "handlebars-1.3.0" = self.by-version."handlebars"."1.3.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "fileset-0.1.5" = self.by-version."fileset"."0.1.5";
      "which-1.0.5" = self.by-version."which"."1.0.5";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "js-yaml-3.2.2" = self.by-version."js-yaml"."3.2.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  by-spec."istanbul"."~0.3.0" =
    self.by-version."istanbul"."0.3.2";
  by-spec."jade"."*" =
    self.by-version."jade"."1.7.0";
  by-version."jade"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-1.7.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-1.7.0.tgz";
        name = "jade-1.7.0.tgz";
        sha1 = "fa0251e9536cd363034ea88f61e99c7e98991524";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "character-parser-1.2.0" = self.by-version."character-parser"."1.2.0";
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
      "constantinople-2.0.1" = self.by-version."constantinople"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "monocle-1.1.51" = self.by-version."monocle"."1.1.51";
      "transformers-2.1.0" = self.by-version."transformers"."2.1.0";
      "void-elements-1.0.0" = self.by-version."void-elements"."1.0.0";
      "with-3.0.1" = self.by-version."with"."3.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  "jade" = self.by-version."jade"."1.7.0";
  by-spec."jade"."0.26.3" =
    self.by-version."jade"."0.26.3";
  by-version."jade"."0.26.3" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.26.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.26.3.tgz";
        name = "jade-0.26.3.tgz";
        sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jade"."0.27.0" =
    self.by-version."jade"."0.27.0";
  by-version."jade"."0.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.27.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.27.0.tgz";
        name = "jade-0.27.0.tgz";
        sha1 = "dc5ebed10d04a5e0eaf49ef0009bec473d1a6b31";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jade"."1.1.5" =
    self.by-version."jade"."1.1.5";
  by-version."jade"."1.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "jade-1.1.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-1.1.5.tgz";
        name = "jade-1.1.5.tgz";
        sha1 = "e884d3d3565807e280f5ba760f68addb176627a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "transformers-2.1.0" = self.by-version."transformers"."2.1.0";
      "character-parser-1.2.0" = self.by-version."character-parser"."1.2.0";
      "monocle-1.1.51" = self.by-version."monocle"."1.1.51";
      "with-2.0.0" = self.by-version."with"."2.0.0";
      "constantinople-1.0.2" = self.by-version."constantinople"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jade".">= 0.0.1" =
    self.by-version."jade"."1.7.0";
  by-spec."jade"."~0.35.0" =
    self.by-version."jade"."0.35.0";
  by-version."jade"."0.35.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.35.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.35.0.tgz";
        name = "jade-0.35.0.tgz";
        sha1 = "75ec1d966a1203733613e8c180e2aa8685c16da9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "commander-2.0.0" = self.by-version."commander"."2.0.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "transformers-2.1.0" = self.by-version."transformers"."2.1.0";
      "character-parser-1.2.0" = self.by-version."character-parser"."1.2.0";
      "monocle-1.1.50" = self.by-version."monocle"."1.1.50";
      "with-1.1.1" = self.by-version."with"."1.1.1";
      "constantinople-1.0.2" = self.by-version."constantinople"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jayschema"."*" =
    self.by-version."jayschema"."0.3.1";
  by-version."jayschema"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "jayschema-0.3.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jayschema/-/jayschema-0.3.1.tgz";
        name = "jayschema-0.3.1.tgz";
        sha1 = "76f4769f9b172ef7d5dcde4875b49cb736179b58";
      })
    ];
    buildInputs =
      (self.nativeDeps."jayschema" or []);
    deps = {
      "when-3.4.6" = self.by-version."when"."3.4.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jayschema" ];
  };
  "jayschema" = self.by-version."jayschema"."0.3.1";
  by-spec."js-yaml"."*" =
    self.by-version."js-yaml"."3.2.2";
  by-version."js-yaml"."3.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.2.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.2.2.tgz";
        name = "js-yaml-3.2.2.tgz";
        sha1 = "a34e77fe8d5e10270e225d21d07790fa17fd2927";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  "js-yaml" = self.by-version."js-yaml"."3.2.2";
  by-spec."js-yaml"."0.3.x" =
    self.by-version."js-yaml"."0.3.7";
  by-version."js-yaml"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-0.3.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-0.3.7.tgz";
        name = "js-yaml-0.3.7.tgz";
        sha1 = "d739d8ee86461e54b354d6a7d7d1f2ad9a167f62";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."2.1.0" =
    self.by-version."js-yaml"."2.1.0";
  by-version."js-yaml"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.0.tgz";
        name = "js-yaml-2.1.0.tgz";
        sha1 = "a55a6e4706b01d06326259a6f4bfc42e6ae38b1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."3.0.1" =
    self.by-version."js-yaml"."3.0.1";
  by-version."js-yaml"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.0.1.tgz";
        name = "js-yaml-3.0.1.tgz";
        sha1 = "76405fea5bce30fc8f405d48c6dca7f0a32c6afe";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."3.x" =
    self.by-version."js-yaml"."3.2.2";
  by-spec."js-yaml"."~2.0.5" =
    self.by-version."js-yaml"."2.0.5";
  by-version."js-yaml"."2.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.0.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.0.5.tgz";
        name = "js-yaml-2.0.5.tgz";
        sha1 = "a25ae6509999e97df278c6719da11bd0687743a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."~3.0.1" =
    self.by-version."js-yaml"."3.0.2";
  by-version."js-yaml"."3.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.0.2.tgz";
        name = "js-yaml-3.0.2.tgz";
        sha1 = "9937865f8e897a5e894e73c2c5cf2e89b32eb771";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."jsesc"."0.4.3" =
    self.by-version."jsesc"."0.4.3";
  by-version."jsesc"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "jsesc-0.4.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsesc/-/jsesc-0.4.3.tgz";
        name = "jsesc-0.4.3.tgz";
        sha1 = "a9c7f90afd5a1bf2ee64df6c416dab61672d2ae9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsesc" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsesc" ];
  };
  by-spec."jsesc"."~0.4.3" =
    self.by-version."jsesc"."0.4.3";
  by-spec."jshint"."*" =
    self.by-version."jshint"."2.5.6";
  by-version."jshint"."2.5.6" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.5.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.5.6.tgz";
        name = "jshint-2.5.6.tgz";
        sha1 = "1685ce1f9e1c74832375d83fe89728589bd9d8c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."jshint" or []);
    deps = {
      "shelljs-0.3.0" = self.by-version."shelljs"."0.3.0";
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
      "cli-0.6.5" = self.by-version."cli"."0.6.5";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "htmlparser2-3.7.3" = self.by-version."htmlparser2"."3.7.3";
      "console-browserify-1.1.0" = self.by-version."console-browserify"."1.1.0";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "strip-json-comments-1.0.2" = self.by-version."strip-json-comments"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  "jshint" = self.by-version."jshint"."2.5.6";
  by-spec."jshint"."~2.5.0" =
    self.by-version."jshint"."2.5.6";
  by-spec."json-schema"."0.2.2" =
    self.by-version."json-schema"."0.2.2";
  by-version."json-schema"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "json-schema-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
        name = "json-schema-0.2.2.tgz";
        sha1 = "50354f19f603917c695f70b85afa77c3b0f23506";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-schema" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "json-schema" ];
  };
  by-spec."json-stable-stringify"."~0.0.0" =
    self.by-version."json-stable-stringify"."0.0.1";
  by-version."json-stable-stringify"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "json-stable-stringify-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stable-stringify/-/json-stable-stringify-0.0.1.tgz";
        name = "json-stable-stringify-0.0.1.tgz";
        sha1 = "611c23e814db375527df851193db59dd2af27f45";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stable-stringify" or []);
    deps = {
      "jsonify-0.0.0" = self.by-version."jsonify"."0.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "json-stable-stringify" ];
  };
  by-spec."json-stringify-safe"."~3.0.0" =
    self.by-version."json-stringify-safe"."3.0.0";
  by-version."json-stringify-safe"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-3.0.0.tgz";
        name = "json-stringify-safe-3.0.0.tgz";
        sha1 = "9db7b0e530c7f289c5e8c8432af191c2ff75a5b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-5.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
        name = "json-stringify-safe-5.0.0.tgz";
        sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  by-spec."jsonfile"."~1.0.1" =
    self.by-version."jsonfile"."1.0.1";
  by-version."jsonfile"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "jsonfile-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonfile/-/jsonfile-1.0.1.tgz";
        name = "jsonfile-1.0.1.tgz";
        sha1 = "ea5efe40b83690b98667614a7392fc60e842c0dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonfile" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsonfile" ];
  };
  by-spec."jsonify"."~0.0.0" =
    self.by-version."jsonify"."0.0.0";
  by-version."jsonify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "jsonify-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz";
        name = "jsonify-0.0.0.tgz";
        sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsonify" ];
  };
  by-spec."jsonparse"."0.0.5" =
    self.by-version."jsonparse"."0.0.5";
  by-version."jsonparse"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "jsonparse-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonparse/-/jsonparse-0.0.5.tgz";
        name = "jsonparse-0.0.5.tgz";
        sha1 = "330542ad3f0a654665b778f3eb2d9a9fa507ac64";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonparse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsonparse" ];
  };
  by-spec."jsontool"."*" =
    self.by-version."jsontool"."7.0.2";
  by-version."jsontool"."7.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "jsontool-7.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsontool/-/jsontool-7.0.2.tgz";
        name = "jsontool-7.0.2.tgz";
        sha1 = "e29d3d1b0766ba4e179a18a96578b904dca43207";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsontool" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsontool" ];
  };
  "jsontool" = self.by-version."jsontool"."7.0.2";
  by-spec."jsprim"."0.3.0" =
    self.by-version."jsprim"."0.3.0";
  by-version."jsprim"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "jsprim-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsprim/-/jsprim-0.3.0.tgz";
        name = "jsprim-0.3.0.tgz";
        sha1 = "cd13466ea2480dbd8396a570d47d31dda476f8b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsprim" or []);
    deps = {
      "extsprintf-1.0.0" = self.by-version."extsprintf"."1.0.0";
      "json-schema-0.2.2" = self.by-version."json-schema"."0.2.2";
      "verror-1.3.3" = self.by-version."verror"."1.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsprim" ];
  };
  by-spec."jstransform"."^6.1.0" =
    self.by-version."jstransform"."6.3.2";
  by-version."jstransform"."6.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "jstransform-6.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jstransform/-/jstransform-6.3.2.tgz";
        name = "jstransform-6.3.2.tgz";
        sha1 = "1e7a99ca7540b26676d972ab75f1d2e74e6b23a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jstransform" or []);
    deps = {
      "base62-0.1.1" = self.by-version."base62"."0.1.1";
      "esprima-fb-6001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."6001.1.0-dev-harmony-fb";
      "source-map-0.1.31" = self.by-version."source-map"."0.1.31";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jstransform" ];
  };
  by-spec."junk"."~1.0.0" =
    self.by-version."junk"."1.0.0";
  by-version."junk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "junk-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/junk/-/junk-1.0.0.tgz";
        name = "junk-1.0.0.tgz";
        sha1 = "22b05ee710f40c44f82fb260602ffecd489223b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."junk" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "junk" ];
  };
  by-spec."karma"."*" =
    self.by-version."karma"."0.12.24";
  by-version."karma"."0.12.24" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.12.24";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.12.24.tgz";
        name = "karma-0.12.24.tgz";
        sha1 = "edd66dd4698acb2227b2b3797467a477d951379d";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma" or []);
    deps = {
      "di-0.0.1" = self.by-version."di"."0.0.1";
      "socket.io-0.9.17" = self.by-version."socket.io"."0.9.17";
      "chokidar-0.10.1" = self.by-version."chokidar"."0.10.1";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "http-proxy-0.10.4" = self.by-version."http-proxy"."0.10.4";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "q-0.9.7" = self.by-version."q"."0.9.7";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "log4js-0.6.21" = self.by-version."log4js"."0.6.21";
      "useragent-2.0.10" = self.by-version."useragent"."2.0.10";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "connect-2.12.0" = self.by-version."connect"."2.12.0";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "karma" ];
  };
  "karma" = self.by-version."karma"."0.12.24";
  by-spec."karma".">=0.11.11" =
    self.by-version."karma"."0.12.24";
  by-spec."karma".">=0.12.8" =
    self.by-version."karma"."0.12.24";
  by-spec."karma".">=0.9" =
    self.by-version."karma"."0.12.24";
  by-spec."karma".">=0.9.3" =
    self.by-version."karma"."0.12.24";
  by-spec."karma"."~0.12.0" =
    self.by-version."karma"."0.12.24";
  by-spec."karma-chrome-launcher"."*" =
    self.by-version."karma-chrome-launcher"."0.1.5";
  by-version."karma-chrome-launcher"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "karma-chrome-launcher-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-0.1.5.tgz";
        name = "karma-chrome-launcher-0.1.5.tgz";
        sha1 = "70e95dca5c4d7a15884850daa3ab60d648dbfe8b";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-chrome-launcher" or []);
    deps = {
    };
    peerDependencies = [
      self.by-version."karma"."0.12.24"
    ];
    passthru.names = [ "karma-chrome-launcher" ];
  };
  "karma-chrome-launcher" = self.by-version."karma-chrome-launcher"."0.1.5";
  by-spec."karma-coverage"."*" =
    self.by-version."karma-coverage"."0.2.6";
  by-version."karma-coverage"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "karma-coverage-0.2.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coverage/-/karma-coverage-0.2.6.tgz";
        name = "karma-coverage-0.2.6.tgz";
        sha1 = "6ab53e69a03a6e0fe2a0563216895a720040fca9";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-coverage" or []);
    deps = {
      "istanbul-0.3.2" = self.by-version."istanbul"."0.3.2";
      "ibrik-1.1.1" = self.by-version."ibrik"."1.1.1";
      "dateformat-1.0.8" = self.by-version."dateformat"."1.0.8";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    peerDependencies = [
      self.by-version."karma"."0.12.24"
    ];
    passthru.names = [ "karma-coverage" ];
  };
  "karma-coverage" = self.by-version."karma-coverage"."0.2.6";
  by-spec."karma-junit-reporter"."*" =
    self.by-version."karma-junit-reporter"."0.2.2";
  by-version."karma-junit-reporter"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "karma-junit-reporter-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-junit-reporter/-/karma-junit-reporter-0.2.2.tgz";
        name = "karma-junit-reporter-0.2.2.tgz";
        sha1 = "4cdd4e21affd3e090e7ba73e3c766ea9e13c45ba";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-junit-reporter" or []);
    deps = {
      "xmlbuilder-0.4.2" = self.by-version."xmlbuilder"."0.4.2";
    };
    peerDependencies = [
      self.by-version."karma"."0.12.24"
    ];
    passthru.names = [ "karma-junit-reporter" ];
  };
  "karma-junit-reporter" = self.by-version."karma-junit-reporter"."0.2.2";
  by-spec."karma-mocha"."*" =
    self.by-version."karma-mocha"."0.1.9";
  by-version."karma-mocha"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "karma-mocha-0.1.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-mocha/-/karma-mocha-0.1.9.tgz";
        name = "karma-mocha-0.1.9.tgz";
        sha1 = "d777a98d655e08330f7893e833c369f82bd10191";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-mocha" or []);
    deps = {
    };
    peerDependencies = [
      self.by-version."karma"."0.12.24"
      self.by-version."mocha"."2.0.0"
    ];
    passthru.names = [ "karma-mocha" ];
  };
  "karma-mocha" = self.by-version."karma-mocha"."0.1.9";
  by-spec."karma-requirejs"."*" =
    self.by-version."karma-requirejs"."0.2.2";
  by-version."karma-requirejs"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "karma-requirejs-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-requirejs/-/karma-requirejs-0.2.2.tgz";
        name = "karma-requirejs-0.2.2.tgz";
        sha1 = "e497ca0868e2e09a9b8e3f646745c31a935fe8b6";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-requirejs" or []);
    deps = {
    };
    peerDependencies = [
      self.by-version."karma"."0.12.24"
      self.by-version."requirejs"."2.1.15"
    ];
    passthru.names = [ "karma-requirejs" ];
  };
  "karma-requirejs" = self.by-version."karma-requirejs"."0.2.2";
  by-spec."karma-sauce-launcher"."*" =
    self.by-version."karma-sauce-launcher"."0.2.10";
  by-version."karma-sauce-launcher"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "karma-sauce-launcher-0.2.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-sauce-launcher/-/karma-sauce-launcher-0.2.10.tgz";
        name = "karma-sauce-launcher-0.2.10.tgz";
        sha1 = "9aed0df47934c630d2ceb7faa954f5c454deddb0";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-sauce-launcher" or []);
    deps = {
      "wd-0.3.9" = self.by-version."wd"."0.3.9";
      "sauce-connect-launcher-0.6.1" = self.by-version."sauce-connect-launcher"."0.6.1";
      "q-0.9.7" = self.by-version."q"."0.9.7";
      "saucelabs-0.1.1" = self.by-version."saucelabs"."0.1.1";
    };
    peerDependencies = [
      self.by-version."karma"."0.12.24"
    ];
    passthru.names = [ "karma-sauce-launcher" ];
  };
  "karma-sauce-launcher" = self.by-version."karma-sauce-launcher"."0.2.10";
  by-spec."keen.io"."~0.1.2" =
    self.by-version."keen.io"."0.1.2";
  by-version."keen.io"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "keen.io-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keen.io/-/keen.io-0.1.2.tgz";
        name = "keen.io-0.1.2.tgz";
        sha1 = "a55b9d1d8b4354a8845f2a224eb3a6f7271378b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."keen.io" or []);
    deps = {
      "superagent-0.13.0" = self.by-version."superagent"."0.13.0";
      "underscore-1.5.2" = self.by-version."underscore"."1.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "keen.io" ];
  };
  by-spec."keep-alive-agent"."0.0.1" =
    self.by-version."keep-alive-agent"."0.0.1";
  by-version."keep-alive-agent"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "keep-alive-agent-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keep-alive-agent/-/keep-alive-agent-0.0.1.tgz";
        name = "keep-alive-agent-0.0.1.tgz";
        sha1 = "44847ca394ce8d6b521ae85816bd64509942b385";
      })
    ];
    buildInputs =
      (self.nativeDeps."keep-alive-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "keep-alive-agent" ];
  };
  by-spec."kerberos"."0.0.3" =
    self.by-version."kerberos"."0.0.3";
  by-version."kerberos"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "kerberos-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kerberos/-/kerberos-0.0.3.tgz";
        name = "kerberos-0.0.3.tgz";
        sha1 = "4285d92a0748db2784062f5adcec9f5956cb818a";
      })
    ];
    buildInputs =
      (self.nativeDeps."kerberos" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "kerberos" ];
  };
  by-spec."kerberos"."0.0.5" =
    self.by-version."kerberos"."0.0.5";
  by-version."kerberos"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "kerberos-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kerberos/-/kerberos-0.0.5.tgz";
        name = "kerberos-0.0.5.tgz";
        sha1 = "48170d7f75bc1570044aa46c501af1c87b1e7cf0";
      })
    ];
    buildInputs =
      (self.nativeDeps."kerberos" or []);
    deps = {
      "nan-1.3.0" = self.by-version."nan"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "kerberos" ];
  };
  by-spec."kew"."0.4.0" =
    self.by-version."kew"."0.4.0";
  by-version."kew"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "kew-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kew/-/kew-0.4.0.tgz";
        name = "kew-0.4.0.tgz";
        sha1 = "da97484f1b06502146f3c60cec05ac6012cd993f";
      })
    ];
    buildInputs =
      (self.nativeDeps."kew" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "kew" ];
  };
  by-spec."kew"."~0.1.7" =
    self.by-version."kew"."0.1.7";
  by-version."kew"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "kew-0.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kew/-/kew-0.1.7.tgz";
        name = "kew-0.1.7.tgz";
        sha1 = "0a32a817ff1a9b3b12b8c9bacf4bc4d679af8e72";
      })
    ];
    buildInputs =
      (self.nativeDeps."kew" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "kew" ];
  };
  by-spec."keygrip"."~1.0.0" =
    self.by-version."keygrip"."1.0.1";
  by-version."keygrip"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "keygrip-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keygrip/-/keygrip-1.0.1.tgz";
        name = "keygrip-1.0.1.tgz";
        sha1 = "b02fa4816eef21a8c4b35ca9e52921ffc89a30e9";
      })
    ];
    buildInputs =
      (self.nativeDeps."keygrip" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "keygrip" ];
  };
  by-spec."keypress"."0.1.x" =
    self.by-version."keypress"."0.1.0";
  by-version."keypress"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "keypress-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keypress/-/keypress-0.1.0.tgz";
        name = "keypress-0.1.0.tgz";
        sha1 = "4a3188d4291b66b4f65edb99f806aa9ae293592a";
      })
    ];
    buildInputs =
      (self.nativeDeps."keypress" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "keypress" ];
  };
  by-spec."keypress"."~0.2.1" =
    self.by-version."keypress"."0.2.1";
  by-version."keypress"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "keypress-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keypress/-/keypress-0.2.1.tgz";
        name = "keypress-0.2.1.tgz";
        sha1 = "1e80454250018dbad4c3fe94497d6e67b6269c77";
      })
    ];
    buildInputs =
      (self.nativeDeps."keypress" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "keypress" ];
  };
  by-spec."knockout"."~3.2.0" =
    self.by-version."knockout"."3.2.0";
  by-version."knockout"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "knockout-3.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knockout/-/knockout-3.2.0.tgz";
        name = "knockout-3.2.0.tgz";
        sha1 = "3f394eb67d721bea115e2d0d7be082256ca46a11";
      })
    ];
    buildInputs =
      (self.nativeDeps."knockout" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "knockout" ];
  };
  by-spec."knox"."*" =
    self.by-version."knox"."0.9.1";
  by-version."knox"."0.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "knox-0.9.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knox/-/knox-0.9.1.tgz";
        name = "knox-0.9.1.tgz";
        sha1 = "3e53398e3d2307d27822abdcd74cd6aa32dc1ccf";
      })
    ];
    buildInputs =
      (self.nativeDeps."knox" or []);
    deps = {
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "xml2js-0.4.4" = self.by-version."xml2js"."0.4.4";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "stream-counter-1.0.0" = self.by-version."stream-counter"."1.0.0";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "knox" ];
  };
  "knox" = self.by-version."knox"."0.9.1";
  by-spec."kue"."*" =
    self.by-version."kue"."0.8.9";
  by-version."kue"."0.8.9" = lib.makeOverridable self.buildNodePackage {
    name = "kue-0.8.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kue/-/kue-0.8.9.tgz";
        name = "kue-0.8.9.tgz";
        sha1 = "6fb2c7d4014f26a64ebf76c092085fe9db16fdcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."kue" or []);
    deps = {
      "redis-0.10.3" = self.by-version."redis"."0.10.3";
      "express-3.1.2" = self.by-version."express"."3.1.2";
      "jade-1.1.5" = self.by-version."jade"."1.1.5";
      "stylus-0.42.2" = self.by-version."stylus"."0.42.2";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "lodash-deep-1.4.2" = self.by-version."lodash-deep"."1.4.2";
      "nib-0.5.0" = self.by-version."nib"."0.5.0";
      "reds-0.2.4" = self.by-version."reds"."0.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "kue" ];
  };
  "kue" = self.by-version."kue"."0.8.9";
  by-spec."labeled-stream-splicer"."^1.0.0" =
    self.by-version."labeled-stream-splicer"."1.0.0";
  by-version."labeled-stream-splicer"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "labeled-stream-splicer-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/labeled-stream-splicer/-/labeled-stream-splicer-1.0.0.tgz";
        name = "labeled-stream-splicer-1.0.0.tgz";
        sha1 = "cb1282bc2d8e9a4bfb3bcda184e8f017deea7c1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."labeled-stream-splicer" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "stream-splicer-1.3.1" = self.by-version."stream-splicer"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "labeled-stream-splicer" ];
  };
  by-spec."latest-version"."^0.2.0" =
    self.by-version."latest-version"."0.2.0";
  by-version."latest-version"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "latest-version-0.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/latest-version/-/latest-version-0.2.0.tgz";
        name = "latest-version-0.2.0.tgz";
        sha1 = "adaf898d5f22380d3f9c45386efdff0a1b5b7501";
      })
    ];
    buildInputs =
      (self.nativeDeps."latest-version" or []);
    deps = {
      "package-json-0.2.0" = self.by-version."package-json"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "latest-version" ];
  };
  by-spec."lazy"."~1.0.11" =
    self.by-version."lazy"."1.0.11";
  by-version."lazy"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "lazy-1.0.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lazy/-/lazy-1.0.11.tgz";
        name = "lazy-1.0.11.tgz";
        sha1 = "daa068206282542c088288e975c297c1ae77b690";
      })
    ];
    buildInputs =
      (self.nativeDeps."lazy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lazy" ];
  };
  by-spec."lazystream"."~0.1.0" =
    self.by-version."lazystream"."0.1.0";
  by-version."lazystream"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "lazystream-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lazystream/-/lazystream-0.1.0.tgz";
        name = "lazystream-0.1.0.tgz";
        sha1 = "1b25d63c772a4c20f0a5ed0a9d77f484b6e16920";
      })
    ];
    buildInputs =
      (self.nativeDeps."lazystream" or []);
    deps = {
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lazystream" ];
  };
  by-spec."lcov-parse"."0.0.6" =
    self.by-version."lcov-parse"."0.0.6";
  by-version."lcov-parse"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "lcov-parse-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-parse/-/lcov-parse-0.0.6.tgz";
        name = "lcov-parse-0.0.6.tgz";
        sha1 = "819e5da8bf0791f9d3f39eea5ed1868187f11175";
      })
    ];
    buildInputs =
      (self.nativeDeps."lcov-parse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lcov-parse" ];
  };
  by-spec."lcov-result-merger"."*" =
    self.by-version."lcov-result-merger"."1.0.0";
  by-version."lcov-result-merger"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "lcov-result-merger-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-result-merger/-/lcov-result-merger-1.0.0.tgz";
        name = "lcov-result-merger-1.0.0.tgz";
        sha1 = "c0afba9711b1cd8ef6a43e71254a39a9882f6ff5";
      })
    ];
    buildInputs =
      (self.nativeDeps."lcov-result-merger" or []);
    deps = {
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
      "vinyl-0.2.3" = self.by-version."vinyl"."0.2.3";
      "vinyl-fs-0.3.10" = self.by-version."vinyl-fs"."0.3.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lcov-result-merger" ];
  };
  "lcov-result-merger" = self.by-version."lcov-result-merger"."1.0.0";
  by-spec."less"."*" =
    self.by-version."less"."2.0.0-b1";
  by-version."less"."2.0.0-b1" = lib.makeOverridable self.buildNodePackage {
    name = "less-2.0.0-b1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-2.0.0-b1.tgz";
        name = "less-2.0.0-b1.tgz";
        sha1 = "3dcb5815b2052c89435c00def2aeb58ddb321b6a";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
      "promise-6.0.1" = self.by-version."promise"."6.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  "less" = self.by-version."less"."2.0.0-b1";
  by-spec."less"."^1.7.2" =
    self.by-version."less"."1.7.5";
  by-version."less"."1.7.5" = lib.makeOverridable self.buildNodePackage {
    name = "less-1.7.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-1.7.5.tgz";
        name = "less-1.7.5.tgz";
        sha1 = "4f220cf7288a27eaca739df6e4808a2d4c0d5756";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "request-2.40.0" = self.by-version."request"."2.40.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "clean-css-2.2.16" = self.by-version."clean-css"."2.2.16";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  by-spec."lexical-scope"."~1.1.0" =
    self.by-version."lexical-scope"."1.1.0";
  by-version."lexical-scope"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "lexical-scope-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lexical-scope/-/lexical-scope-1.1.0.tgz";
        name = "lexical-scope-1.1.0.tgz";
        sha1 = "899f36c4ec9c5af19736361aae290a6ef2af0800";
      })
    ];
    buildInputs =
      (self.nativeDeps."lexical-scope" or []);
    deps = {
      "astw-1.1.0" = self.by-version."astw"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lexical-scope" ];
  };
  by-spec."libxmljs"."~0.10.0" =
    self.by-version."libxmljs"."0.10.0";
  by-version."libxmljs"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "libxmljs-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libxmljs/-/libxmljs-0.10.0.tgz";
        name = "libxmljs-0.10.0.tgz";
        sha1 = "847eb4b0545b02d1c235e1f8371818cf709d3256";
      })
    ];
    buildInputs =
      (self.nativeDeps."libxmljs" or []);
    deps = {
      "bindings-1.1.1" = self.by-version."bindings"."1.1.1";
      "nan-1.1.2" = self.by-version."nan"."1.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "libxmljs" ];
  };
  by-spec."libyaml"."*" =
    self.by-version."libyaml"."0.2.5";
  by-version."libyaml"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "libyaml-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libyaml/-/libyaml-0.2.5.tgz";
        name = "libyaml-0.2.5.tgz";
        sha1 = "f34a920b728d8c1eddea56a6fa8698c28ceab6df";
      })
    ];
    buildInputs =
      (self.nativeDeps."libyaml" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "libyaml" ];
  };
  "libyaml" = self.by-version."libyaml"."0.2.5";
  by-spec."liftoff"."^0.13.2" =
    self.by-version."liftoff"."0.13.5";
  by-version."liftoff"."0.13.5" = lib.makeOverridable self.buildNodePackage {
    name = "liftoff-0.13.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/liftoff/-/liftoff-0.13.5.tgz";
        name = "liftoff-0.13.5.tgz";
        sha1 = "fb603b0ba34e9ab77a3737529f452d344562386c";
      })
    ];
    buildInputs =
      (self.nativeDeps."liftoff" or []);
    deps = {
      "findup-sync-0.1.3" = self.by-version."findup-sync"."0.1.3";
      "resolve-1.0.0" = self.by-version."resolve"."1.0.0";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "extend-1.3.0" = self.by-version."extend"."1.3.0";
      "flagged-respawn-0.3.1" = self.by-version."flagged-respawn"."0.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "liftoff" ];
  };
  by-spec."lockfile"."~1.0.0" =
    self.by-version."lockfile"."1.0.0";
  by-version."lockfile"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "lockfile-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lockfile/-/lockfile-1.0.0.tgz";
        name = "lockfile-1.0.0.tgz";
        sha1 = "b3a7609dda6012060083bacb0ab0ecbca58e9203";
      })
    ];
    buildInputs =
      (self.nativeDeps."lockfile" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lockfile" ];
  };
  by-spec."lodash"."2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-version."lodash"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.4.1.tgz";
        name = "lodash-2.4.1.tgz";
        sha1 = "5b7723034dda4d262e5a46fb2c58d7cc22f71420";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash".">=2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-spec."lodash"."^2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-spec."lodash"."~0.9.2" =
    self.by-version."lodash"."0.9.2";
  by-version."lodash"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-0.9.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-0.9.2.tgz";
        name = "lodash-0.9.2.tgz";
        sha1 = "8f3499c5245d346d682e5b0d3b40767e09f1a92c";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~1.0.1" =
    self.by-version."lodash"."1.0.1";
  by-version."lodash"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.0.1.tgz";
        name = "lodash-1.0.1.tgz";
        sha1 = "57945732498d92310e5bd4b1ff4f273a79e6c9fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  by-spec."lodash"."~2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-spec."lodash-deep"."^1.1.0" =
    self.by-version."lodash-deep"."1.4.2";
  by-version."lodash-deep"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-deep-1.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash-deep/-/lodash-deep-1.4.2.tgz";
        name = "lodash-deep-1.4.2.tgz";
        sha1 = "451704eb282c2ad3d6602e9602b7cd25db52e37d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash-deep" or []);
    deps = {
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash-deep" ];
  };
  by-spec."lodash-node"."~2.4.1" =
    self.by-version."lodash-node"."2.4.1";
  by-version."lodash-node"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-node-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash-node/-/lodash-node-2.4.1.tgz";
        name = "lodash-node-2.4.1.tgz";
        sha1 = "ea82f7b100c733d1a42af76801e506105e2a80ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash-node" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash-node" ];
  };
  by-spec."lodash._escapehtmlchar"."~2.4.1" =
    self.by-version."lodash._escapehtmlchar"."2.4.1";
  by-version."lodash._escapehtmlchar"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._escapehtmlchar-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._escapehtmlchar/-/lodash._escapehtmlchar-2.4.1.tgz";
        name = "lodash._escapehtmlchar-2.4.1.tgz";
        sha1 = "df67c3bb6b7e8e1e831ab48bfa0795b92afe899d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._escapehtmlchar" or []);
    deps = {
      "lodash._htmlescapes-2.4.1" = self.by-version."lodash._htmlescapes"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._escapehtmlchar" ];
  };
  by-spec."lodash._escapestringchar"."~2.4.1" =
    self.by-version."lodash._escapestringchar"."2.4.1";
  by-version."lodash._escapestringchar"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._escapestringchar-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._escapestringchar/-/lodash._escapestringchar-2.4.1.tgz";
        name = "lodash._escapestringchar-2.4.1.tgz";
        sha1 = "ecfe22618a2ade50bfeea43937e51df66f0edb72";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._escapestringchar" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._escapestringchar" ];
  };
  by-spec."lodash._htmlescapes"."~2.4.1" =
    self.by-version."lodash._htmlescapes"."2.4.1";
  by-version."lodash._htmlescapes"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._htmlescapes-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._htmlescapes/-/lodash._htmlescapes-2.4.1.tgz";
        name = "lodash._htmlescapes-2.4.1.tgz";
        sha1 = "32d14bf0844b6de6f8b62a051b4f67c228b624cb";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._htmlescapes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._htmlescapes" ];
  };
  by-spec."lodash._isnative"."~2.4.1" =
    self.by-version."lodash._isnative"."2.4.1";
  by-version."lodash._isnative"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._isnative-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._isnative/-/lodash._isnative-2.4.1.tgz";
        name = "lodash._isnative-2.4.1.tgz";
        sha1 = "3ea6404b784a7be836c7b57580e1cdf79b14832c";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._isnative" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._isnative" ];
  };
  by-spec."lodash._objecttypes"."~2.4.1" =
    self.by-version."lodash._objecttypes"."2.4.1";
  by-version."lodash._objecttypes"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._objecttypes-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._objecttypes/-/lodash._objecttypes-2.4.1.tgz";
        name = "lodash._objecttypes-2.4.1.tgz";
        sha1 = "7c0b7f69d98a1f76529f890b0cdb1b4dfec11c11";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._objecttypes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._objecttypes" ];
  };
  by-spec."lodash._reinterpolate"."^2.4.1" =
    self.by-version."lodash._reinterpolate"."2.4.1";
  by-version."lodash._reinterpolate"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._reinterpolate-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._reinterpolate/-/lodash._reinterpolate-2.4.1.tgz";
        name = "lodash._reinterpolate-2.4.1.tgz";
        sha1 = "4f1227aa5a8711fc632f5b07a1f4607aab8b3222";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._reinterpolate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._reinterpolate" ];
  };
  by-spec."lodash._reinterpolate"."~2.4.1" =
    self.by-version."lodash._reinterpolate"."2.4.1";
  by-spec."lodash._reunescapedhtml"."~2.4.1" =
    self.by-version."lodash._reunescapedhtml"."2.4.1";
  by-version."lodash._reunescapedhtml"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._reunescapedhtml-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._reunescapedhtml/-/lodash._reunescapedhtml-2.4.1.tgz";
        name = "lodash._reunescapedhtml-2.4.1.tgz";
        sha1 = "747c4fc40103eb3bb8a0976e571f7a2659e93ba7";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._reunescapedhtml" or []);
    deps = {
      "lodash._htmlescapes-2.4.1" = self.by-version."lodash._htmlescapes"."2.4.1";
      "lodash.keys-2.4.1" = self.by-version."lodash.keys"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._reunescapedhtml" ];
  };
  by-spec."lodash._shimkeys"."~2.4.1" =
    self.by-version."lodash._shimkeys"."2.4.1";
  by-version."lodash._shimkeys"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash._shimkeys-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash._shimkeys/-/lodash._shimkeys-2.4.1.tgz";
        name = "lodash._shimkeys-2.4.1.tgz";
        sha1 = "6e9cc9666ff081f0b5a6c978b83e242e6949d203";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash._shimkeys" or []);
    deps = {
      "lodash._objecttypes-2.4.1" = self.by-version."lodash._objecttypes"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash._shimkeys" ];
  };
  by-spec."lodash.debounce"."^2.4.1" =
    self.by-version."lodash.debounce"."2.4.1";
  by-version."lodash.debounce"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.debounce-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.debounce/-/lodash.debounce-2.4.1.tgz";
        name = "lodash.debounce-2.4.1.tgz";
        sha1 = "d8cead246ec4b926e8b85678fc396bfeba8cc6fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.debounce" or []);
    deps = {
      "lodash.isfunction-2.4.1" = self.by-version."lodash.isfunction"."2.4.1";
      "lodash.isobject-2.4.1" = self.by-version."lodash.isobject"."2.4.1";
      "lodash.now-2.4.1" = self.by-version."lodash.now"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.debounce" ];
  };
  by-spec."lodash.defaults"."~2.4.1" =
    self.by-version."lodash.defaults"."2.4.1";
  by-version."lodash.defaults"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.defaults-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.defaults/-/lodash.defaults-2.4.1.tgz";
        name = "lodash.defaults-2.4.1.tgz";
        sha1 = "a7e8885f05e68851144b6e12a8f3678026bc4c54";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.defaults" or []);
    deps = {
      "lodash.keys-2.4.1" = self.by-version."lodash.keys"."2.4.1";
      "lodash._objecttypes-2.4.1" = self.by-version."lodash._objecttypes"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.defaults" ];
  };
  by-spec."lodash.escape"."~2.4.1" =
    self.by-version."lodash.escape"."2.4.1";
  by-version."lodash.escape"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.escape-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.escape/-/lodash.escape-2.4.1.tgz";
        name = "lodash.escape-2.4.1.tgz";
        sha1 = "2ce12c5e084db0a57dda5e5d1eeeb9f5d175a3b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.escape" or []);
    deps = {
      "lodash._escapehtmlchar-2.4.1" = self.by-version."lodash._escapehtmlchar"."2.4.1";
      "lodash.keys-2.4.1" = self.by-version."lodash.keys"."2.4.1";
      "lodash._reunescapedhtml-2.4.1" = self.by-version."lodash._reunescapedhtml"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.escape" ];
  };
  by-spec."lodash.isfunction"."~2.4.1" =
    self.by-version."lodash.isfunction"."2.4.1";
  by-version."lodash.isfunction"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.isfunction-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.isfunction/-/lodash.isfunction-2.4.1.tgz";
        name = "lodash.isfunction-2.4.1.tgz";
        sha1 = "2cfd575c73e498ab57e319b77fa02adef13a94d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.isfunction" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.isfunction" ];
  };
  by-spec."lodash.isobject"."~2.4.1" =
    self.by-version."lodash.isobject"."2.4.1";
  by-version."lodash.isobject"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.isobject-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.isobject/-/lodash.isobject-2.4.1.tgz";
        name = "lodash.isobject-2.4.1.tgz";
        sha1 = "5a2e47fe69953f1ee631a7eba1fe64d2d06558f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.isobject" or []);
    deps = {
      "lodash._objecttypes-2.4.1" = self.by-version."lodash._objecttypes"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.isobject" ];
  };
  by-spec."lodash.keys"."~2.4.1" =
    self.by-version."lodash.keys"."2.4.1";
  by-version."lodash.keys"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.keys-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.keys/-/lodash.keys-2.4.1.tgz";
        name = "lodash.keys-2.4.1.tgz";
        sha1 = "48dea46df8ff7632b10d706b8acb26591e2b3727";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.keys" or []);
    deps = {
      "lodash._isnative-2.4.1" = self.by-version."lodash._isnative"."2.4.1";
      "lodash.isobject-2.4.1" = self.by-version."lodash.isobject"."2.4.1";
      "lodash._shimkeys-2.4.1" = self.by-version."lodash._shimkeys"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.keys" ];
  };
  by-spec."lodash.now"."~2.4.1" =
    self.by-version."lodash.now"."2.4.1";
  by-version."lodash.now"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.now-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.now/-/lodash.now-2.4.1.tgz";
        name = "lodash.now-2.4.1.tgz";
        sha1 = "6872156500525185faf96785bb7fe7fe15b562c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.now" or []);
    deps = {
      "lodash._isnative-2.4.1" = self.by-version."lodash._isnative"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.now" ];
  };
  by-spec."lodash.template"."^2.4.1" =
    self.by-version."lodash.template"."2.4.1";
  by-version."lodash.template"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.template-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.template/-/lodash.template-2.4.1.tgz";
        name = "lodash.template-2.4.1.tgz";
        sha1 = "9e611007edf629129a974ab3c48b817b3e1cf20d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.template" or []);
    deps = {
      "lodash.defaults-2.4.1" = self.by-version."lodash.defaults"."2.4.1";
      "lodash.escape-2.4.1" = self.by-version."lodash.escape"."2.4.1";
      "lodash._escapestringchar-2.4.1" = self.by-version."lodash._escapestringchar"."2.4.1";
      "lodash.keys-2.4.1" = self.by-version."lodash.keys"."2.4.1";
      "lodash._reinterpolate-2.4.1" = self.by-version."lodash._reinterpolate"."2.4.1";
      "lodash.templatesettings-2.4.1" = self.by-version."lodash.templatesettings"."2.4.1";
      "lodash.values-2.4.1" = self.by-version."lodash.values"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.template" ];
  };
  by-spec."lodash.templatesettings"."~2.4.1" =
    self.by-version."lodash.templatesettings"."2.4.1";
  by-version."lodash.templatesettings"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.templatesettings-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.templatesettings/-/lodash.templatesettings-2.4.1.tgz";
        name = "lodash.templatesettings-2.4.1.tgz";
        sha1 = "ea76c75d11eb86d4dbe89a83893bb861929ac699";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.templatesettings" or []);
    deps = {
      "lodash.escape-2.4.1" = self.by-version."lodash.escape"."2.4.1";
      "lodash._reinterpolate-2.4.1" = self.by-version."lodash._reinterpolate"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.templatesettings" ];
  };
  by-spec."lodash.values"."~2.4.1" =
    self.by-version."lodash.values"."2.4.1";
  by-version."lodash.values"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash.values-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash.values/-/lodash.values-2.4.1.tgz";
        name = "lodash.values-2.4.1.tgz";
        sha1 = "abf514436b3cb705001627978cbcf30b1280eea4";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash.values" or []);
    deps = {
      "lodash.keys-2.4.1" = self.by-version."lodash.keys"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash.values" ];
  };
  by-spec."log-driver"."1.2.4" =
    self.by-version."log-driver"."1.2.4";
  by-version."log-driver"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "log-driver-1.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log-driver/-/log-driver-1.2.4.tgz";
        name = "log-driver-1.2.4.tgz";
        sha1 = "2d62d7faef45d8a71341961a04b0761eca99cfa3";
      })
    ];
    buildInputs =
      (self.nativeDeps."log-driver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "log-driver" ];
  };
  by-spec."log4js"."~0.6.3" =
    self.by-version."log4js"."0.6.21";
  by-version."log4js"."0.6.21" = lib.makeOverridable self.buildNodePackage {
    name = "log4js-0.6.21";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log4js/-/log4js-0.6.21.tgz";
        name = "log4js-0.6.21.tgz";
        sha1 = "674ed09ef0ffe913c2a35074f697bd047bb53b5f";
      })
    ];
    buildInputs =
      (self.nativeDeps."log4js" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "semver-1.1.4" = self.by-version."semver"."1.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "log4js" ];
  };
  by-spec."longjohn"."~0.2.2" =
    self.by-version."longjohn"."0.2.4";
  by-version."longjohn"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "longjohn-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/longjohn/-/longjohn-0.2.4.tgz";
        name = "longjohn-0.2.4.tgz";
        sha1 = "48436a1f359e7666f678e2170ee1f43bba8f8b4c";
      })
    ];
    buildInputs =
      (self.nativeDeps."longjohn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "longjohn" ];
  };
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.5.0";
  by-version."lru-cache"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.0.tgz";
        name = "lru-cache-2.5.0.tgz";
        sha1 = "d82388ae9c960becbea0c73bb9eb79b6c6ce9aeb";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.2.0" =
    self.by-version."lru-cache"."2.2.0";
  by-version."lru-cache"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.2.0.tgz";
        name = "lru-cache-2.2.0.tgz";
        sha1 = "ec2bba603f4c5bb3e7a1bf62ce1c1dbc1d474e08";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.2.x" =
    self.by-version."lru-cache"."2.2.4";
  by-version."lru-cache"."2.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.2.4.tgz";
        name = "lru-cache-2.2.4.tgz";
        sha1 = "6c658619becf14031d0d0b594b16042ce4dc063d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.3.0" =
    self.by-version."lru-cache"."2.3.0";
  by-version."lru-cache"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.0.tgz";
        name = "lru-cache-2.3.0.tgz";
        sha1 = "1cee12d5a9f28ed1ee37e9c332b8888e6b85412a";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."2.5.x" =
    self.by-version."lru-cache"."2.5.0";
  by-spec."lru-cache"."~1.0.2" =
    self.by-version."lru-cache"."1.0.6";
  by-version."lru-cache"."1.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-1.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-1.0.6.tgz";
        name = "lru-cache-1.0.6.tgz";
        sha1 = "aa50f97047422ac72543bda177a9c9d018d98452";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."~2.3.0" =
    self.by-version."lru-cache"."2.3.1";
  by-version."lru-cache"."2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
        name = "lru-cache-2.3.1.tgz";
        sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."lru-cache"."~2.5.0" =
    self.by-version."lru-cache"."2.5.0";
  by-spec."lru-queue"."0.1" =
    self.by-version."lru-queue"."0.1.0";
  by-version."lru-queue"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-queue-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-queue/-/lru-queue-0.1.0.tgz";
        name = "lru-queue-0.1.0.tgz";
        sha1 = "2738bd9f0d3cf4f84490c5736c48699ac632cda3";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-queue" or []);
    deps = {
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-queue" ];
  };
  by-spec."lsmod"."~0.0.3" =
    self.by-version."lsmod"."0.0.3";
  by-version."lsmod"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "lsmod-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lsmod/-/lsmod-0.0.3.tgz";
        name = "lsmod-0.0.3.tgz";
        sha1 = "17e13d4e1ae91750ea5653548cd89e7147ad0244";
      })
    ];
    buildInputs =
      (self.nativeDeps."lsmod" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lsmod" ];
  };
  by-spec."mailcomposer".">= 0.1.27" =
    self.by-version."mailcomposer"."0.2.12";
  by-version."mailcomposer"."0.2.12" = lib.makeOverridable self.buildNodePackage {
    name = "mailcomposer-0.2.12";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mailcomposer/-/mailcomposer-0.2.12.tgz";
        name = "mailcomposer-0.2.12.tgz";
        sha1 = "4d02a604616adcb45fb36d37513f4c1bd0b75681";
      })
    ];
    buildInputs =
      (self.nativeDeps."mailcomposer" or []);
    deps = {
      "mimelib-0.2.17" = self.by-version."mimelib"."0.2.17";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "he-0.3.6" = self.by-version."he"."0.3.6";
      "follow-redirects-0.0.3" = self.by-version."follow-redirects"."0.0.3";
      "dkim-signer-0.1.2" = self.by-version."dkim-signer"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mailcomposer" ];
  };
  by-spec."marked"."*" =
    self.by-version."marked"."0.3.2";
  by-version."marked"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "marked-0.3.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/marked/-/marked-0.3.2.tgz";
        name = "marked-0.3.2.tgz";
        sha1 = "015db158864438f24a64bdd61a0428b418706d09";
      })
    ];
    buildInputs =
      (self.nativeDeps."marked" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "marked" ];
  };
  "marked" = self.by-version."marked"."0.3.2";
  by-spec."marked".">=0.3.1" =
    self.by-version."marked"."0.3.2";
  by-spec."maxmin"."^0.1.0" =
    self.by-version."maxmin"."0.1.0";
  by-version."maxmin"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "maxmin-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/maxmin/-/maxmin-0.1.0.tgz";
        name = "maxmin-0.1.0.tgz";
        sha1 = "95d81c5289e3a9d30f7fc7dc559c024e5030c9d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."maxmin" or []);
    deps = {
      "gzip-size-0.1.1" = self.by-version."gzip-size"."0.1.1";
      "pretty-bytes-0.1.2" = self.by-version."pretty-bytes"."0.1.2";
      "chalk-0.4.0" = self.by-version."chalk"."0.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "maxmin" ];
  };
  by-spec."maxmin"."^1.0.0" =
    self.by-version."maxmin"."1.0.0";
  by-version."maxmin"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "maxmin-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/maxmin/-/maxmin-1.0.0.tgz";
        name = "maxmin-1.0.0.tgz";
        sha1 = "040b7a15ba5c6f3b08581cbf201df0bdd64e19f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."maxmin" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "figures-1.3.3" = self.by-version."figures"."1.3.3";
      "gzip-size-1.0.0" = self.by-version."gzip-size"."1.0.0";
      "pretty-bytes-1.0.1" = self.by-version."pretty-bytes"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "maxmin" ];
  };
  by-spec."maxmin"."~0.2.0" =
    self.by-version."maxmin"."0.2.2";
  by-version."maxmin"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "maxmin-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/maxmin/-/maxmin-0.2.2.tgz";
        name = "maxmin-0.2.2.tgz";
        sha1 = "a36ced8cc22e3abcd108cfb797a3a4b40275593f";
      })
    ];
    buildInputs =
      (self.nativeDeps."maxmin" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "figures-1.3.3" = self.by-version."figures"."1.3.3";
      "gzip-size-0.2.0" = self.by-version."gzip-size"."0.2.0";
      "pretty-bytes-0.1.2" = self.by-version."pretty-bytes"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "maxmin" ];
  };
  by-spec."meat"."*" =
    self.by-version."meat"."0.3.2";
  by-version."meat"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "meat-0.3.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/meat/-/meat-0.3.2.tgz";
        name = "meat-0.3.2.tgz";
        sha1 = "f385317a6273c6d92d00b40de91e99554cc6f194";
      })
    ];
    buildInputs =
      (self.nativeDeps."meat" or []);
    deps = {
      "express-2.5.11" = self.by-version."express"."2.5.11";
      "jade-0.27.0" = self.by-version."jade"."0.27.0";
      "open-0.0.2" = self.by-version."open"."0.0.2";
      "winston-0.6.2" = self.by-version."winston"."0.6.2";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
      "node.extend-1.0.0" = self.by-version."node.extend"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "meat" ];
  };
  "meat" = self.by-version."meat"."0.3.2";
  by-spec."media-typer"."0.2.0" =
    self.by-version."media-typer"."0.2.0";
  by-version."media-typer"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "media-typer-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/media-typer/-/media-typer-0.2.0.tgz";
        name = "media-typer-0.2.0.tgz";
        sha1 = "d8a065213adfeaa2e76321a2b6dda36ff6335984";
      })
    ];
    buildInputs =
      (self.nativeDeps."media-typer" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "media-typer" ];
  };
  by-spec."media-typer"."0.3.0" =
    self.by-version."media-typer"."0.3.0";
  by-version."media-typer"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "media-typer-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
        name = "media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      })
    ];
    buildInputs =
      (self.nativeDeps."media-typer" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "media-typer" ];
  };
  by-spec."memoizee"."0.3.x" =
    self.by-version."memoizee"."0.3.8";
  by-version."memoizee"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "memoizee-0.3.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/memoizee/-/memoizee-0.3.8.tgz";
        name = "memoizee-0.3.8.tgz";
        sha1 = "b5faf419f02fafe3c2cc1cf5d3907c210fc7efdc";
      })
    ];
    buildInputs =
      (self.nativeDeps."memoizee" or []);
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
      "es6-weak-map-0.1.2" = self.by-version."es6-weak-map"."0.1.2";
      "event-emitter-0.3.1" = self.by-version."event-emitter"."0.3.1";
      "lru-queue-0.1.0" = self.by-version."lru-queue"."0.1.0";
      "next-tick-0.2.2" = self.by-version."next-tick"."0.2.2";
      "timers-ext-0.1.0" = self.by-version."timers-ext"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "memoizee" ];
  };
  by-spec."merge-descriptors"."0.0.2" =
    self.by-version."merge-descriptors"."0.0.2";
  by-version."merge-descriptors"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "merge-descriptors-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-0.0.2.tgz";
        name = "merge-descriptors-0.0.2.tgz";
        sha1 = "c36a52a781437513c57275f39dd9d317514ac8c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."merge-descriptors" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "merge-descriptors" ];
  };
  by-spec."method-override"."~2.3.0" =
    self.by-version."method-override"."2.3.0";
  by-version."method-override"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "method-override-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/method-override/-/method-override-2.3.0.tgz";
        name = "method-override-2.3.0.tgz";
        sha1 = "fe820769594247ede8a6ca87b8eaa413084e595e";
      })
    ];
    buildInputs =
      (self.nativeDeps."method-override" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "method-override" ];
  };
  by-spec."methods"."0.0.1" =
    self.by-version."methods"."0.0.1";
  by-version."methods"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "methods-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-0.0.1.tgz";
        name = "methods-0.0.1.tgz";
        sha1 = "277c90f8bef39709645a8371c51c3b6c648e068c";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."methods"."0.1.0" =
    self.by-version."methods"."0.1.0";
  by-version."methods"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "methods-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-0.1.0.tgz";
        name = "methods-0.1.0.tgz";
        sha1 = "335d429eefd21b7bacf2e9c922a8d2bd14a30e4f";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."methods"."1.0.1" =
    self.by-version."methods"."1.0.1";
  by-version."methods"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "methods-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-1.0.1.tgz";
        name = "methods-1.0.1.tgz";
        sha1 = "75bc91943dffd7da037cf3eeb0ed73a0037cd14b";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."methods"."1.1.0" =
    self.by-version."methods"."1.1.0";
  by-version."methods"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "methods-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-1.1.0.tgz";
        name = "methods-1.1.0.tgz";
        sha1 = "5dca4ee12df52ff3b056145986a8f01cbc86436f";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."microee"."0.0.2" =
    self.by-version."microee"."0.0.2";
  by-version."microee"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "microee-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/microee/-/microee-0.0.2.tgz";
        name = "microee-0.0.2.tgz";
        sha1 = "72e80d477075e5e799470f5defea96d1dd121587";
      })
    ];
    buildInputs =
      (self.nativeDeps."microee" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "microee" ];
  };
  by-spec."mime"."*" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        name = "mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.11" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."1.2.4" =
    self.by-version."mime"."1.2.4";
  by-version."mime"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.4.tgz";
        name = "mime-1.2.4.tgz";
        sha1 = "11b5fdaf29c2509255176b80ad520294f5de92b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.5" =
    self.by-version."mime"."1.2.5";
  by-version."mime"."1.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.5.tgz";
        name = "mime-1.2.5.tgz";
        sha1 = "9eed073022a8bf5e16c8566c6867b8832bfbfa13";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.6" =
    self.by-version."mime"."1.2.6";
  by-version."mime"."1.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.6.tgz";
        name = "mime-1.2.6.tgz";
        sha1 = "b1f86c768c025fa87b48075f1709f28aeaf20365";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.9" =
    self.by-version."mime"."1.2.9";
  by-version."mime"."1.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.9.tgz";
        name = "mime-1.2.9.tgz";
        sha1 = "009cd40867bd35de521b3b966f04e2f8d4d13d09";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
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
  by-spec."mime-db"."1.x" =
    self.by-version."mime-db"."1.1.1";
  by-version."mime-db"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "mime-db-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.1.1.tgz";
        name = "mime-db-1.1.1.tgz";
        sha1 = "0fc890cda05d0edadefde73d241ef7e28d110a98";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-db" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-db" ];
  };
  by-spec."mime-db"."~1.1.0" =
    self.by-version."mime-db"."1.1.1";
  by-spec."mime-types"."~1.0.0" =
    self.by-version."mime-types"."1.0.2";
  by-version."mime-types"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "mime-types-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-1.0.2.tgz";
        name = "mime-types-1.0.2.tgz";
        sha1 = "995ae1392ab8affcbfcb2641dd054e943c0d5dce";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
  };
  by-spec."mime-types"."~1.0.1" =
    self.by-version."mime-types"."1.0.2";
  by-spec."mime-types"."~2.0.2" =
    self.by-version."mime-types"."2.0.2";
  by-version."mime-types"."2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "mime-types-2.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.2.tgz";
        name = "mime-types-2.0.2.tgz";
        sha1 = "c74b779f2896c367888622bd537aaaad4c0a2c08";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = {
      "mime-db-1.1.1" = self.by-version."mime-db"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
  };
  by-spec."mimelib"."~0.2.15" =
    self.by-version."mimelib"."0.2.17";
  by-version."mimelib"."0.2.17" = lib.makeOverridable self.buildNodePackage {
    name = "mimelib-0.2.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mimelib/-/mimelib-0.2.17.tgz";
        name = "mimelib-0.2.17.tgz";
        sha1 = "6b0cb91a6451b92649e4cc98c5b64eed2d19a4aa";
      })
    ];
    buildInputs =
      (self.nativeDeps."mimelib" or []);
    deps = {
      "encoding-0.1.10" = self.by-version."encoding"."0.1.10";
      "addressparser-0.2.1" = self.by-version."addressparser"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mimelib" ];
  };
  by-spec."minilog"."~2.0.2" =
    self.by-version."minilog"."2.0.6";
  by-version."minilog"."2.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "minilog-2.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minilog/-/minilog-2.0.6.tgz";
        name = "minilog-2.0.6.tgz";
        sha1 = "665601f32a08bda58406c0e933b08713b3a50ad4";
      })
    ];
    buildInputs =
      (self.nativeDeps."minilog" or []);
    deps = {
      "microee-0.0.2" = self.by-version."microee"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minilog" ];
  };
  by-spec."minimatch"."0.0.x" =
    self.by-version."minimatch"."0.0.5";
  by-version."minimatch"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.0.5.tgz";
        name = "minimatch-0.0.5.tgz";
        sha1 = "96bb490bbd3ba6836bbfac111adf75301b1584de";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-1.0.6" = self.by-version."lru-cache"."1.0.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."0.2.x" =
    self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
        name = "minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."0.3" =
    self.by-version."minimatch"."0.3.0";
  by-version."minimatch"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz";
        name = "minimatch-0.3.0.tgz";
        sha1 = "275d8edaac4f1bb3326472089e7949c8394699dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."0.x" =
    self.by-version."minimatch"."0.4.0";
  by-version."minimatch"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.4.0.tgz";
        name = "minimatch-0.4.0.tgz";
        sha1 = "bd2c7d060d2c8c8fd7cde7f1f2ed2d5b270fdb1b";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."1" =
    self.by-version."minimatch"."1.0.0";
  by-version."minimatch"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-1.0.0.tgz";
        name = "minimatch-1.0.0.tgz";
        sha1 = "e0dd2120b49e1b724ce8d714c520822a9438576d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."1.0.x" =
    self.by-version."minimatch"."1.0.0";
  by-spec."minimatch".">=0.2.4" =
    self.by-version."minimatch"."1.0.0";
  by-spec."minimatch"."^1.0.0" =
    self.by-version."minimatch"."1.0.0";
  by-spec."minimatch"."~0.2" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.11" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.12" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.9" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.3.0" =
    self.by-version."minimatch"."0.3.0";
  by-spec."minimatch"."~1.0.0" =
    self.by-version."minimatch"."1.0.0";
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        name = "minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."^0.1.0" =
    self.by-version."minimist"."0.1.0";
  by-version."minimist"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.1.0.tgz";
        name = "minimist-0.1.0.tgz";
        sha1 = "99df657a52574c21c9057497df742790b2b4c0de";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."^1.1.0" =
    self.by-version."minimist"."1.1.0";
  by-version."minimist"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-1.1.0.tgz";
        name = "minimist-1.1.0.tgz";
        sha1 = "cdf225e8898f840a258ded44fc91776770afdc93";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
        name = "minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."~0.0.7" =
    self.by-version."minimist"."0.0.10";
  by-spec."minimist"."~0.2.0" =
    self.by-version."minimist"."0.2.0";
  by-version."minimist"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.2.0.tgz";
        name = "minimist-0.2.0.tgz";
        sha1 = "4dffe525dae2b864c66c2e23c6271d7afdecefce";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."~1.1.0" =
    self.by-version."minimist"."1.1.0";
  by-spec."ministyle"."~0.1.3" =
    self.by-version."ministyle"."0.1.4";
  by-version."ministyle"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "ministyle-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ministyle/-/ministyle-0.1.4.tgz";
        name = "ministyle-0.1.4.tgz";
        sha1 = "b10481eb16aa8f7b6cd983817393a44da0e5a0cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."ministyle" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ministyle" ];
  };
  by-spec."miniwrite"."~0.1.3" =
    self.by-version."miniwrite"."0.1.3";
  by-version."miniwrite"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "miniwrite-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/miniwrite/-/miniwrite-0.1.3.tgz";
        name = "miniwrite-0.1.3.tgz";
        sha1 = "9e893efb435f853454ca0321b86a44378e8c50c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."miniwrite" or []);
    deps = {
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "miniwrite" ];
  };
  by-spec."mkdirp"."*" =
    self.by-version."mkdirp"."0.5.0";
  by-version."mkdirp"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.5.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
        name = "mkdirp-0.5.0.tgz";
        sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = {
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  "mkdirp" = self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."0.3.0" =
    self.by-version."mkdirp"."0.3.0";
  by-version."mkdirp"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
        name = "mkdirp-0.3.0.tgz";
        sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  by-spec."mkdirp"."0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        name = "mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  by-spec."mkdirp"."0.3.x" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."0.5" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."0.5.x" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."0.x.x" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp".">=0.5 0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."^0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."~0.3.3" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.4" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkpath"."~0.1.0" =
    self.by-version."mkpath"."0.1.0";
  by-version."mkpath"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkpath-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkpath/-/mkpath-0.1.0.tgz";
        name = "mkpath-0.1.0.tgz";
        sha1 = "7554a6f8d871834cc97b5462b122c4c124d6de91";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkpath" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mkpath" ];
  };
  by-spec."mocha"."*" =
    self.by-version."mocha"."2.0.0";
  by-version."mocha"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-2.0.0.tgz";
        name = "mocha-2.0.0.tgz";
        sha1 = "4f737685475046533432494b76c3e81cb5005c54";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha" or []);
    deps = {
      "commander-2.3.0" = self.by-version."commander"."2.3.0";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "glob-3.2.3" = self.by-version."glob"."3.2.3";
      "growl-1.8.1" = self.by-version."growl"."1.8.1";
      "jade-0.26.3" = self.by-version."jade"."0.26.3";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mocha" ];
  };
  "mocha" = self.by-version."mocha"."2.0.0";
  by-spec."mocha"."~1.20.1" =
    self.by-version."mocha"."1.20.1";
  by-version."mocha"."1.20.1" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-1.20.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-1.20.1.tgz";
        name = "mocha-1.20.1.tgz";
        sha1 = "f343832d9fe0c7d97c64fc70448f5136df9fed5b";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha" or []);
    deps = {
      "commander-2.0.0" = self.by-version."commander"."2.0.0";
      "growl-1.7.0" = self.by-version."growl"."1.7.0";
      "jade-0.26.3" = self.by-version."jade"."0.26.3";
      "diff-1.0.7" = self.by-version."diff"."1.0.7";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "glob-3.2.3" = self.by-version."glob"."3.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mocha" ];
  };
  by-spec."mocha-phantomjs"."*" =
    self.by-version."mocha-phantomjs"."3.5.1";
  by-version."mocha-phantomjs"."3.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-phantomjs-3.5.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha-phantomjs/-/mocha-phantomjs-3.5.1.tgz";
        name = "mocha-phantomjs-3.5.1.tgz";
        sha1 = "e5460eff3e859b98be73a743f11cb5cae3c58d00";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha-phantomjs" or []);
    deps = {
      "mocha-1.20.1" = self.by-version."mocha"."1.20.1";
      "commander-2.0.0" = self.by-version."commander"."2.0.0";
    };
    peerDependencies = [
      self.by-version."phantomjs"."1.9.11"
    ];
    passthru.names = [ "mocha-phantomjs" ];
  };
  "mocha-phantomjs" = self.by-version."mocha-phantomjs"."3.5.1";
  by-spec."mocha-unfunk-reporter"."*" =
    self.by-version."mocha-unfunk-reporter"."0.4.0";
  by-version."mocha-unfunk-reporter"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-unfunk-reporter-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha-unfunk-reporter/-/mocha-unfunk-reporter-0.4.0.tgz";
        name = "mocha-unfunk-reporter-0.4.0.tgz";
        sha1 = "59eda97aec6ae6e26d7af4173490a65b7b082d20";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha-unfunk-reporter" or []);
    deps = {
      "jsesc-0.4.3" = self.by-version."jsesc"."0.4.3";
      "unfunk-diff-0.0.2" = self.by-version."unfunk-diff"."0.0.2";
      "miniwrite-0.1.3" = self.by-version."miniwrite"."0.1.3";
      "ministyle-0.1.4" = self.by-version."ministyle"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mocha-unfunk-reporter" ];
  };
  "mocha-unfunk-reporter" = self.by-version."mocha-unfunk-reporter"."0.4.0";
  by-spec."module-deps"."^3.5.0" =
    self.by-version."module-deps"."3.5.6";
  by-version."module-deps"."3.5.6" = lib.makeOverridable self.buildNodePackage {
    name = "module-deps-3.5.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/module-deps/-/module-deps-3.5.6.tgz";
        name = "module-deps-3.5.6.tgz";
        sha1 = "3853bb0be43b0d6632d25d96e4099abdfdf989d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."module-deps" or []);
    deps = {
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "browser-resolve-1.3.2" = self.by-version."browser-resolve"."1.3.2";
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "detective-3.1.0" = self.by-version."detective"."3.1.0";
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimist-0.2.0" = self.by-version."minimist"."0.2.0";
      "parents-1.0.0" = self.by-version."parents"."1.0.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "shallow-copy-0.0.1" = self.by-version."shallow-copy"."0.0.1";
      "stream-combiner2-1.0.2" = self.by-version."stream-combiner2"."1.0.2";
      "subarg-0.0.1" = self.by-version."subarg"."0.0.1";
      "through2-0.4.2" = self.by-version."through2"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "module-deps" ];
  };
  by-spec."moment"."2.1.0" =
    self.by-version."moment"."2.1.0";
  by-version."moment"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.1.0.tgz";
        name = "moment-2.1.0.tgz";
        sha1 = "1fd7b1134029a953c6ea371dbaee37598ac03567";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  by-spec."moment"."~2.4.0" =
    self.by-version."moment"."2.4.0";
  by-version."moment"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.4.0.tgz";
        name = "moment-2.4.0.tgz";
        sha1 = "06dd8dfbbfdb53a03510080ac788163c9490e75d";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  by-spec."moment"."~2.8.2" =
    self.by-version."moment"."2.8.3";
  by-version."moment"."2.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.8.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.8.3.tgz";
        name = "moment-2.8.3.tgz";
        sha1 = "a01427bf8910f014fc4baa1b8d96f17f7e3f29a2";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  by-spec."mongodb"."*" =
    self.by-version."mongodb"."2.0.3";
  by-version."mongodb"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-2.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-2.0.3.tgz";
        name = "mongodb-2.0.3.tgz";
        sha1 = "78dd12c11aaa8cf8666c16128fd19f55a8f9b313";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = {
      "mongodb-core-1.0.3" = self.by-version."mongodb-core"."1.0.3";
      "readable-stream-1.0.31" = self.by-version."readable-stream"."1.0.31";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  "mongodb" = self.by-version."mongodb"."2.0.3";
  by-spec."mongodb"."1.2.14" =
    self.by-version."mongodb"."1.2.14";
  by-version."mongodb"."1.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.2.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.2.14.tgz";
        name = "mongodb-1.2.14.tgz";
        sha1 = "269665552066437308d0942036646e6795c3a9a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = {
      "bson-0.1.8" = self.by-version."bson"."0.1.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb"."1.3.19" =
    self.by-version."mongodb"."1.3.19";
  by-version."mongodb"."1.3.19" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.3.19";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.3.19.tgz";
        name = "mongodb-1.3.19.tgz";
        sha1 = "f229db24098f019d86d135aaf8a1ab5f2658b1d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = {
      "bson-0.2.2" = self.by-version."bson"."0.2.2";
      "kerberos-0.0.3" = self.by-version."kerberos"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb"."1.3.x" =
    self.by-version."mongodb"."1.3.23";
  by-version."mongodb"."1.3.23" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.3.23";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.3.23.tgz";
        name = "mongodb-1.3.23.tgz";
        sha1 = "874a5212162b16188aeeaee5e06067766c8e9e86";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = {
      "bson-0.2.5" = self.by-version."bson"."0.2.5";
      "kerberos-0.0.3" = self.by-version."kerberos"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb"."1.4.9" =
    self.by-version."mongodb"."1.4.9";
  by-version."mongodb"."1.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.4.9";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.4.9.tgz";
        name = "mongodb-1.4.9.tgz";
        sha1 = "c30b9724248be471d30235e2d542646d3b869bc2";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = {
      "bson-0.2.12" = self.by-version."bson"."0.2.12";
      "kerberos-0.0.3" = self.by-version."kerberos"."0.0.3";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  by-spec."mongodb-core"."~1.0" =
    self.by-version."mongodb-core"."1.0.3";
  by-version."mongodb-core"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-core-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb-core/-/mongodb-core-1.0.3.tgz";
        name = "mongodb-core-1.0.3.tgz";
        sha1 = "387649e432368dcd02c983f39454700d6958619a";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb-core" or []);
    deps = {
      "bson-0.2.15" = self.by-version."bson"."0.2.15";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.6" = self.by-version."rimraf"."2.2.6";
      "kerberos-0.0.5" = self.by-version."kerberos"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb-core" ];
  };
  by-spec."mongoose"."3.6.7" =
    self.by-version."mongoose"."3.6.7";
  by-version."mongoose"."3.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.6.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.6.7.tgz";
        name = "mongoose-3.6.7.tgz";
        sha1 = "aa6c9f4dfb740c7721dbe734fbb97714e5ab0ebc";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = {
      "hooks-0.2.1" = self.by-version."hooks"."0.2.1";
      "mongodb-1.2.14" = self.by-version."mongodb"."1.2.14";
      "ms-0.1.0" = self.by-version."ms"."0.1.0";
      "sliced-0.0.3" = self.by-version."sliced"."0.0.3";
      "muri-0.3.1" = self.by-version."muri"."0.3.1";
      "mpromise-0.2.1" = self.by-version."mpromise"."0.2.1";
      "mpath-0.1.1" = self.by-version."mpath"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  by-spec."mongoose"."3.6.x" =
    self.by-version."mongoose"."3.6.20";
  by-version."mongoose"."3.6.20" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.6.20";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.6.20.tgz";
        name = "mongoose-3.6.20.tgz";
        sha1 = "47263843e6b812ea207eec104c40a36c8d215f53";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = {
      "hooks-0.2.1" = self.by-version."hooks"."0.2.1";
      "mongodb-1.3.19" = self.by-version."mongodb"."1.3.19";
      "ms-0.1.0" = self.by-version."ms"."0.1.0";
      "sliced-0.0.5" = self.by-version."sliced"."0.0.5";
      "muri-0.3.1" = self.by-version."muri"."0.3.1";
      "mpromise-0.2.1" = self.by-version."mpromise"."0.2.1";
      "mpath-0.1.1" = self.by-version."mpath"."0.1.1";
      "regexp-clone-0.0.1" = self.by-version."regexp-clone"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  "mongoose" = self.by-version."mongoose"."3.6.20";
  by-spec."mongoose"."3.8.x" =
    self.by-version."mongoose"."3.8.17";
  by-version."mongoose"."3.8.17" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.8.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.8.17.tgz";
        name = "mongoose-3.8.17.tgz";
        sha1 = "23426b3aea84255623dca28823de64a8fcd53da8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = {
      "mongodb-1.4.9" = self.by-version."mongodb"."1.4.9";
      "hooks-0.2.1" = self.by-version."hooks"."0.2.1";
      "ms-0.1.0" = self.by-version."ms"."0.1.0";
      "sliced-0.0.5" = self.by-version."sliced"."0.0.5";
      "muri-0.3.1" = self.by-version."muri"."0.3.1";
      "mpromise-0.4.3" = self.by-version."mpromise"."0.4.3";
      "mpath-0.1.1" = self.by-version."mpath"."0.1.1";
      "regexp-clone-0.0.1" = self.by-version."regexp-clone"."0.0.1";
      "mquery-0.8.0" = self.by-version."mquery"."0.8.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  by-spec."mongoose-lifecycle"."1.0.0" =
    self.by-version."mongoose-lifecycle"."1.0.0";
  by-version."mongoose-lifecycle"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-lifecycle-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose-lifecycle/-/mongoose-lifecycle-1.0.0.tgz";
        name = "mongoose-lifecycle-1.0.0.tgz";
        sha1 = "3bac3f3924a845d147784fc6558dee900b0151e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose-lifecycle" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongoose-lifecycle" ];
  };
  by-spec."mongoose-schema-extend"."*" =
    self.by-version."mongoose-schema-extend"."0.1.7";
  by-version."mongoose-schema-extend"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-schema-extend-0.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose-schema-extend/-/mongoose-schema-extend-0.1.7.tgz";
        name = "mongoose-schema-extend-0.1.7.tgz";
        sha1 = "50dc366ba63227d00c4cd3db9bb8bf95e9629910";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose-schema-extend" or []);
    deps = {
      "owl-deepcopy-0.0.4" = self.by-version."owl-deepcopy"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongoose-schema-extend" ];
  };
  "mongoose-schema-extend" = self.by-version."mongoose-schema-extend"."0.1.7";
  by-spec."monocle"."1.1.50" =
    self.by-version."monocle"."1.1.50";
  by-version."monocle"."1.1.50" = lib.makeOverridable self.buildNodePackage {
    name = "monocle-1.1.50";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/monocle/-/monocle-1.1.50.tgz";
        name = "monocle-1.1.50.tgz";
        sha1 = "e21b059d99726d958371f36240c106b8a067fa7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."monocle" or []);
    deps = {
      "readdirp-0.2.5" = self.by-version."readdirp"."0.2.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "monocle" ];
  };
  by-spec."monocle"."1.1.51" =
    self.by-version."monocle"."1.1.51";
  by-version."monocle"."1.1.51" = lib.makeOverridable self.buildNodePackage {
    name = "monocle-1.1.51";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/monocle/-/monocle-1.1.51.tgz";
        name = "monocle-1.1.51.tgz";
        sha1 = "22ed16e112e9b056769c5ccac920e375249d89c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."monocle" or []);
    deps = {
      "readdirp-0.2.5" = self.by-version."readdirp"."0.2.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "monocle" ];
  };
  by-spec."morgan"."~1.4.0" =
    self.by-version."morgan"."1.4.0";
  by-version."morgan"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "morgan-1.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/morgan/-/morgan-1.4.0.tgz";
        name = "morgan-1.4.0.tgz";
        sha1 = "ce3c6ee28f794f85f59165476575b70ed386eb3d";
      })
    ];
    buildInputs =
      (self.nativeDeps."morgan" or []);
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "morgan" ];
  };
  by-spec."mout"."~0.9.0" =
    self.by-version."mout"."0.9.1";
  by-version."mout"."0.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "mout-0.9.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mout/-/mout-0.9.1.tgz";
        name = "mout-0.9.1.tgz";
        sha1 = "84f0f3fd6acc7317f63de2affdcc0cee009b0477";
      })
    ];
    buildInputs =
      (self.nativeDeps."mout" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mout" ];
  };
  by-spec."mpath"."0.1.1" =
    self.by-version."mpath"."0.1.1";
  by-version."mpath"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "mpath-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpath/-/mpath-0.1.1.tgz";
        name = "mpath-0.1.1.tgz";
        sha1 = "23da852b7c232ee097f4759d29c0ee9cd22d5e46";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpath" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mpath" ];
  };
  by-spec."mpromise"."0.2.1" =
    self.by-version."mpromise"."0.2.1";
  by-version."mpromise"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "mpromise-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.2.1.tgz";
        name = "mpromise-0.2.1.tgz";
        sha1 = "fbbdc28cb0207e49b8a4eb1a4c0cea6c2de794c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise" or []);
    deps = {
      "sliced-0.0.4" = self.by-version."sliced"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  by-spec."mpromise"."0.4.3" =
    self.by-version."mpromise"."0.4.3";
  by-version."mpromise"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "mpromise-0.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.4.3.tgz";
        name = "mpromise-0.4.3.tgz";
        sha1 = "edc47a75a2a177b0e9382735db52dbec3808cc33";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  by-spec."mquery"."0.8.0" =
    self.by-version."mquery"."0.8.0";
  by-version."mquery"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "mquery-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mquery/-/mquery-0.8.0.tgz";
        name = "mquery-0.8.0.tgz";
        sha1 = "1e5b8c2a5a52f5583bd08932700b85440ee25f60";
      })
    ];
    buildInputs =
      (self.nativeDeps."mquery" or []);
    deps = {
      "sliced-0.0.5" = self.by-version."sliced"."0.0.5";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "regexp-clone-0.0.1" = self.by-version."regexp-clone"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mquery" ];
  };
  by-spec."ms"."0.1.0" =
    self.by-version."ms"."0.1.0";
  by-version."ms"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ms-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.1.0.tgz";
        name = "ms-0.1.0.tgz";
        sha1 = "f21fac490daf1d7667fd180fe9077389cc9442b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."ms" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ms" ];
  };
  by-spec."ms"."0.6.2" =
    self.by-version."ms"."0.6.2";
  by-version."ms"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "ms-0.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.6.2.tgz";
        name = "ms-0.6.2.tgz";
        sha1 = "d89c2124c6fdc1353d65a8b77bf1aac4b193708c";
      })
    ];
    buildInputs =
      (self.nativeDeps."ms" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ms" ];
  };
  by-spec."msgpack".">= 0.0.1" =
    self.by-version."msgpack"."0.2.4";
  by-version."msgpack"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "msgpack-0.2.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/msgpack/-/msgpack-0.2.4.tgz";
        name = "msgpack-0.2.4.tgz";
        sha1 = "17ac333ea5320b45059f80c992d7465fed4fe706";
      })
    ];
    buildInputs =
      (self.nativeDeps."msgpack" or []);
    deps = {
      "nan-1.0.0" = self.by-version."nan"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "msgpack" ];
  };
  by-spec."multiparty"."2.2.0" =
    self.by-version."multiparty"."2.2.0";
  by-version."multiparty"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "multiparty-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/multiparty/-/multiparty-2.2.0.tgz";
        name = "multiparty-2.2.0.tgz";
        sha1 = "a567c2af000ad22dc8f2a653d91978ae1f5316f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."multiparty" or []);
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "stream-counter-0.2.0" = self.by-version."stream-counter"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "multiparty" ];
  };
  by-spec."multiparty"."3.3.2" =
    self.by-version."multiparty"."3.3.2";
  by-version."multiparty"."3.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "multiparty-3.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/multiparty/-/multiparty-3.3.2.tgz";
        name = "multiparty-3.3.2.tgz";
        sha1 = "35de6804dc19643e5249f3d3e3bdc6c8ce301d3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."multiparty" or []);
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "stream-counter-0.2.0" = self.by-version."stream-counter"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "multiparty" ];
  };
  by-spec."multipipe"."^0.1.0" =
    self.by-version."multipipe"."0.1.1";
  by-version."multipipe"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "multipipe-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/multipipe/-/multipipe-0.1.1.tgz";
        name = "multipipe-0.1.1.tgz";
        sha1 = "bc271fbb2bf3a5ed3e43cc6ba3d7dbc1c4eb07fb";
      })
    ];
    buildInputs =
      (self.nativeDeps."multipipe" or []);
    deps = {
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "multipipe" ];
  };
  by-spec."muri"."0.3.1" =
    self.by-version."muri"."0.3.1";
  by-version."muri"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "muri-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/muri/-/muri-0.3.1.tgz";
        name = "muri-0.3.1.tgz";
        sha1 = "861889c5c857f1a43700bee85d50731f61727c9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."muri" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "muri" ];
  };
  by-spec."mute-stream"."0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "mute-stream-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
        name = "mute-stream-0.0.4.tgz";
        sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-spec."mv"."0.0.5" =
    self.by-version."mv"."0.0.5";
  by-version."mv"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "mv-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mv/-/mv-0.0.5.tgz";
        name = "mv-0.0.5.tgz";
        sha1 = "15eac759479884df1131d6de56bce20b654f5391";
      })
    ];
    buildInputs =
      (self.nativeDeps."mv" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mv" ];
  };
  by-spec."mz"."1" =
    self.by-version."mz"."1.0.2";
  by-version."mz"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "mz-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mz/-/mz-1.0.2.tgz";
        name = "mz-1.0.2.tgz";
        sha1 = "1c861e902ed75527399ca0d95152b9726aea73ac";
      })
    ];
    buildInputs =
      (self.nativeDeps."mz" or []);
    deps = {
      "native-or-bluebird-1.1.1" = self.by-version."native-or-bluebird"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mz" ];
  };
  by-spec."nan"."1.1.2" =
    self.by-version."nan"."1.1.2";
  by-version."nan"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.1.2.tgz";
        name = "nan-1.1.2.tgz";
        sha1 = "bbd48552fc0758673ebe8fada360b60278a6636b";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."nan"."1.2.0" =
    self.by-version."nan"."1.2.0";
  by-version."nan"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.2.0.tgz";
        name = "nan-1.2.0.tgz";
        sha1 = "9c4d63ce9e4f8e95de2d574e18f7925554a8a8ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."nan"."1.3.0" =
    self.by-version."nan"."1.3.0";
  by-version."nan"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.3.0.tgz";
        name = "nan-1.3.0.tgz";
        sha1 = "9a5b8d5ef97a10df3050e59b2c362d3baf779742";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."nan".">=1.3.0" =
    self.by-version."nan"."1.3.0";
  by-spec."nan"."^1.3.0" =
    self.by-version."nan"."1.3.0";
  by-spec."nan"."~1.0.0" =
    self.by-version."nan"."1.0.0";
  by-version."nan"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.0.0.tgz";
        name = "nan-1.0.0.tgz";
        sha1 = "ae24f8850818d662fcab5acf7f3b95bfaa2ccf38";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."nan"."~1.1.0" =
    self.by-version."nan"."1.1.2";
  by-spec."nan"."~1.2.0" =
    self.by-version."nan"."1.2.0";
  by-spec."native-or-bluebird"."1" =
    self.by-version."native-or-bluebird"."1.1.1";
  by-version."native-or-bluebird"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "native-or-bluebird-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/native-or-bluebird/-/native-or-bluebird-1.1.1.tgz";
        name = "native-or-bluebird-1.1.1.tgz";
        sha1 = "9131a6d6532afdfb5635f9703734cc6652c905ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."native-or-bluebird" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "native-or-bluebird" ];
  };
  by-spec."natural"."0.1.17" =
    self.by-version."natural"."0.1.17";
  by-version."natural"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "natural-0.1.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/natural/-/natural-0.1.17.tgz";
        name = "natural-0.1.17.tgz";
        sha1 = "0ff654cd30aeb2aa298ab0580e6f7ea9f40954e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."natural" or []);
    deps = {
      "sylvester-0.0.21" = self.by-version."sylvester"."0.0.21";
      "apparatus-0.0.8" = self.by-version."apparatus"."0.0.8";
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "natural" ];
  };
  by-spec."nconf"."*" =
    self.by-version."nconf"."0.6.9";
  by-version."nconf"."0.6.9" = lib.makeOverridable self.buildNodePackage {
    name = "nconf-0.6.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nconf/-/nconf-0.6.9.tgz";
        name = "nconf-0.6.9.tgz";
        sha1 = "9570ef15ed6f9ae6b2b3c8d5e71b66d3193cd661";
      })
    ];
    buildInputs =
      (self.nativeDeps."nconf" or []);
    deps = {
      "async-0.2.9" = self.by-version."async"."0.2.9";
      "ini-1.3.0" = self.by-version."ini"."1.3.0";
      "optimist-0.6.0" = self.by-version."optimist"."0.6.0";
    };
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
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.2.7.tgz";
        name = "ncp-0.2.7.tgz";
        sha1 = "46fac2b7dda2560a4cb7e628677bd5f64eac5be1";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  by-spec."ncp"."0.4.x" =
    self.by-version."ncp"."0.4.2";
  by-version."ncp"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.4.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.4.2.tgz";
        name = "ncp-0.4.2.tgz";
        sha1 = "abcc6cbd3ec2ed2a729ff6e7c1fa8f01784a8574";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  by-spec."ncp"."0.6.0" =
    self.by-version."ncp"."0.6.0";
  by-version."ncp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.6.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.6.0.tgz";
        name = "ncp-0.6.0.tgz";
        sha1 = "df8ce021e262be21b52feb3d3e5cfaab12491f0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  by-spec."ncp"."~0.4.2" =
    self.by-version."ncp"."0.4.2";
  by-spec."negotiator"."0.2.5" =
    self.by-version."negotiator"."0.2.5";
  by-version."negotiator"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.2.5.tgz";
        name = "negotiator-0.2.5.tgz";
        sha1 = "12ec7b4a9f3b4c894c31d8c4ec015925ba547eec";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."0.3.0" =
    self.by-version."negotiator"."0.3.0";
  by-version."negotiator"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.3.0.tgz";
        name = "negotiator-0.3.0.tgz";
        sha1 = "706d692efeddf574d57ea9fb1ab89a4fa7ee8f60";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."0.4.7" =
    self.by-version."negotiator"."0.4.7";
  by-version."negotiator"."0.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.4.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.4.7.tgz";
        name = "negotiator-0.4.7.tgz";
        sha1 = "a4160f7177ec806738631d0d3052325da42abdc8";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."0.4.9" =
    self.by-version."negotiator"."0.4.9";
  by-version."negotiator"."0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.4.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.4.9.tgz";
        name = "negotiator-0.4.9.tgz";
        sha1 = "92e46b6db53c7e421ed64a2bc94f08be7630df3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."negotiator"."~0.3.0" =
    self.by-version."negotiator"."0.3.0";
  by-spec."net-ping"."1.1.7" =
    self.by-version."net-ping"."1.1.7";
  by-version."net-ping"."1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "net-ping-1.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/net-ping/-/net-ping-1.1.7.tgz";
        name = "net-ping-1.1.7.tgz";
        sha1 = "49f5bca55a30a3726d69253557f231135a637075";
      })
    ];
    buildInputs =
      (self.nativeDeps."net-ping" or []);
    deps = {
      "raw-socket-1.2.2" = self.by-version."raw-socket"."1.2.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "net-ping" ];
  };
  by-spec."next-tick"."~0.2.2" =
    self.by-version."next-tick"."0.2.2";
  by-version."next-tick"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "next-tick-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/next-tick/-/next-tick-0.2.2.tgz";
        name = "next-tick-0.2.2.tgz";
        sha1 = "75da4a927ee5887e39065880065b7336413b310d";
      })
    ];
    buildInputs =
      (self.nativeDeps."next-tick" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "next-tick" ];
  };
  by-spec."nib"."0.5.0" =
    self.by-version."nib"."0.5.0";
  by-version."nib"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "nib-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nib/-/nib-0.5.0.tgz";
        name = "nib-0.5.0.tgz";
        sha1 = "ad0a7dfa2bca8680c8cb8adaa6ab68c80e5221e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."nib" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nib" ];
  };
  by-spec."nijs"."*" =
    self.by-version."nijs"."0.0.20";
  by-version."nijs"."0.0.20" = lib.makeOverridable self.buildNodePackage {
    name = "nijs-0.0.20";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.20.tgz";
        name = "nijs-0.0.20.tgz";
        sha1 = "db193f4ed5fc9571ee6fb58542778e96e38f0f7e";
      })
    ];
    buildInputs =
      (self.nativeDeps."nijs" or []);
    deps = {
      "optparse-1.0.5" = self.by-version."optparse"."1.0.5";
      "slasp-0.0.4" = self.by-version."slasp"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nijs" ];
  };
  "nijs" = self.by-version."nijs"."0.0.20";
  by-spec."node-appc"."0.2.14" =
    self.by-version."node-appc"."0.2.14";
  by-version."node-appc"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "node-appc-0.2.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-appc/-/node-appc-0.2.14.tgz";
        name = "node-appc-0.2.14.tgz";
        sha1 = "74f20eca49ebf940799fac44bcb224321582cf98";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-appc" or []);
    deps = {
      "adm-zip-0.4.4" = self.by-version."adm-zip"."0.4.4";
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "dox-0.4.6" = self.by-version."dox"."0.4.6";
      "jade-0.35.0" = self.by-version."jade"."0.35.0";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "request-2.27.0" = self.by-version."request"."2.27.0";
      "semver-2.1.0" = self.by-version."semver"."2.1.0";
      "sprintf-0.1.4" = self.by-version."sprintf"."0.1.4";
      "temp-0.6.0" = self.by-version."temp"."0.6.0";
      "wrench-1.5.8" = self.by-version."wrench"."1.5.8";
      "uglify-js-2.3.6" = self.by-version."uglify-js"."2.3.6";
      "xmldom-0.1.19" = self.by-version."xmldom"."0.1.19";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-appc" ];
  };
  by-spec."node-expat"."*" =
    self.by-version."node-expat"."2.3.1";
  by-version."node-expat"."2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-expat-2.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-expat/-/node-expat-2.3.1.tgz";
        name = "node-expat-2.3.1.tgz";
        sha1 = "32c515a4d1cf747fb655d3ad4374696537592413";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-expat" or []);
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.2.0" = self.by-version."nan"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-expat" ];
  };
  "node-expat" = self.by-version."node-expat"."2.3.1";
  by-spec."node-gyp"."*" =
    self.by-version."node-gyp"."1.0.2";
  by-version."node-gyp"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-1.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-1.0.2.tgz";
        name = "node-gyp-1.0.2.tgz";
        sha1 = "b0bb6d2d762271408dd904853e7aa3000ed2eb57";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp" or []);
    deps = {
      "fstream-1.0.2" = self.by-version."fstream"."1.0.2";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "tar-1.0.1" = self.by-version."tar"."1.0.1";
      "which-1.0.5" = self.by-version."which"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  "node-gyp" = self.by-version."node-gyp"."1.0.2";
  by-spec."node-gyp"."~1.0.1" =
    self.by-version."node-gyp"."1.0.2";
  by-spec."node-inspector"."*" =
    self.by-version."node-inspector"."0.7.4";
  by-version."node-inspector"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-inspector-0.7.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-inspector/-/node-inspector-0.7.4.tgz";
        name = "node-inspector-0.7.4.tgz";
        sha1 = "3d07234f0834e7f1e21a1669eceaa224a7be43f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-inspector" or []);
    deps = {
      "express-4.0.0" = self.by-version."express"."4.0.0";
      "async-0.8.0" = self.by-version."async"."0.8.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "rc-0.3.5" = self.by-version."rc"."0.3.5";
      "strong-data-uri-0.1.1" = self.by-version."strong-data-uri"."0.1.1";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
      "ws-0.4.32" = self.by-version."ws"."0.4.32";
      "opener-1.3.0" = self.by-version."opener"."1.3.0";
      "yargs-1.2.6" = self.by-version."yargs"."1.2.6";
      "which-1.0.5" = self.by-version."which"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-inspector" ];
  };
  "node-inspector" = self.by-version."node-inspector"."0.7.4";
  by-spec."node-protobuf"."*" =
    self.by-version."node-protobuf"."1.2.2";
  by-version."node-protobuf"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-protobuf-1.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-protobuf/-/node-protobuf-1.2.2.tgz";
        name = "node-protobuf-1.2.2.tgz";
        sha1 = "8d512499fe012358c1fd89d6b4d84ad80317acb3";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-protobuf" or []);
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.3.0" = self.by-version."nan"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-protobuf" ];
  };
  "node-protobuf" = self.by-version."node-protobuf"."1.2.2";
  by-spec."node-swt".">=0.1.1" =
    self.by-version."node-swt"."0.1.1";
  by-version."node-swt"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-swt-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-swt/-/node-swt-0.1.1.tgz";
        name = "node-swt-0.1.1.tgz";
        sha1 = "af0903825784be553b93dbae57d99d59060585dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-swt" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-swt" ];
  };
  by-spec."node-syslog"."1.1.7" =
    self.by-version."node-syslog"."1.1.7";
  by-version."node-syslog"."1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-syslog-1.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-syslog/-/node-syslog-1.1.7.tgz";
        name = "node-syslog-1.1.7.tgz";
        sha1 = "f2b1dfce095c39f5a6d056659862ca134a08a4cb";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-syslog" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-syslog" ];
  };
  by-spec."node-uptime"."https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7" =
    self.by-version."node-uptime"."3.2.0";
  by-version."node-uptime"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-uptime-3.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7";
        name = "node-uptime-3.2.0.tgz";
        sha256 = "46424d7f9553ce7313cc09995ab11d237dd02257c29f260cfb38d2799e7c7746";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uptime" or []);
    deps = {
      "mongoose-3.6.7" = self.by-version."mongoose"."3.6.7";
      "mongoose-lifecycle-1.0.0" = self.by-version."mongoose-lifecycle"."1.0.0";
      "express-3.2.0" = self.by-version."express"."3.2.0";
      "express-partials-0.0.6" = self.by-version."express-partials"."0.0.6";
      "connect-flash-0.1.0" = self.by-version."connect-flash"."0.1.0";
      "ejs-0.8.3" = self.by-version."ejs"."0.8.3";
      "config-0.4.15" = self.by-version."config"."0.4.15";
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "socket.io-0.9.14" = self.by-version."socket.io"."0.9.14";
      "semver-1.1.0" = self.by-version."semver"."1.1.0";
      "moment-2.1.0" = self.by-version."moment"."2.1.0";
      "nodemailer-0.3.35" = self.by-version."nodemailer"."0.3.35";
      "net-ping-1.1.7" = self.by-version."net-ping"."1.1.7";
      "js-yaml-2.1.0" = self.by-version."js-yaml"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-uptime" ];
  };
  "node-uptime" = self.by-version."node-uptime"."3.2.0";
  by-spec."node-uuid"."*" =
    self.by-version."node-uuid"."1.4.1";
  by-version."node-uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        name = "node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  "node-uuid" = self.by-version."node-uuid"."1.4.1";
  by-spec."node-uuid"."1.3.3" =
    self.by-version."node-uuid"."1.3.3";
  by-version."node-uuid"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.3.3.tgz";
        name = "node-uuid-1.3.3.tgz";
        sha1 = "d3db4d7b56810d9e4032342766282af07391729b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  by-spec."node-uuid"."1.4.0" =
    self.by-version."node-uuid"."1.4.0";
  by-version."node-uuid"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.0.tgz";
        name = "node-uuid-1.4.0.tgz";
        sha1 = "07f9b2337572ff6275c775e1d48513f3a45d7a65";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = {
    };
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
    name = "node-wsfederation-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-wsfederation/-/node-wsfederation-0.1.1.tgz";
        name = "node-wsfederation-0.1.1.tgz";
        sha1 = "9abf1dd3b20a3ab0a38f899c882c218d734e8a7b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-wsfederation" or []);
    deps = {
      "xml2js-0.4.4" = self.by-version."xml2js"."0.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-wsfederation" ];
  };
  by-spec."node.extend"."1.0.0" =
    self.by-version."node.extend"."1.0.0";
  by-version."node.extend"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node.extend-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node.extend/-/node.extend-1.0.0.tgz";
        name = "node.extend-1.0.0.tgz";
        sha1 = "ab83960c477280d01ba5554a0d8fd3acfe39336e";
      })
    ];
    buildInputs =
      (self.nativeDeps."node.extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "node.extend" ];
  };
  by-spec."nodemailer"."0.3.35" =
    self.by-version."nodemailer"."0.3.35";
  by-version."nodemailer"."0.3.35" = lib.makeOverridable self.buildNodePackage {
    name = "nodemailer-0.3.35";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemailer/-/nodemailer-0.3.35.tgz";
        name = "nodemailer-0.3.35.tgz";
        sha1 = "4d38cdc0ad230bdf88cc27d1256ef49fcb422e19";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemailer" or []);
    deps = {
      "mailcomposer-0.2.12" = self.by-version."mailcomposer"."0.2.12";
      "simplesmtp-0.3.33" = self.by-version."simplesmtp"."0.3.33";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nodemailer" ];
  };
  by-spec."nodemon"."*" =
    self.by-version."nodemon"."1.2.1";
  by-version."nodemon"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "nodemon-1.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemon/-/nodemon-1.2.1.tgz";
        name = "nodemon-1.2.1.tgz";
        sha1 = "02a288045652e92350e7d752a8054472ed2c4824";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemon" or []);
    deps = {
      "update-notifier-0.1.10" = self.by-version."update-notifier"."0.1.10";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
      "ps-tree-0.0.3" = self.by-version."ps-tree"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nodemon" ];
  };
  "nodemon" = self.by-version."nodemon"."1.2.1";
  by-spec."nomnom"."1.6.x" =
    self.by-version."nomnom"."1.6.2";
  by-version."nomnom"."1.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "nomnom-1.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nomnom/-/nomnom-1.6.2.tgz";
        name = "nomnom-1.6.2.tgz";
        sha1 = "84a66a260174408fc5b77a18f888eccc44fb6971";
      })
    ];
    buildInputs =
      (self.nativeDeps."nomnom" or []);
    deps = {
      "colors-0.5.1" = self.by-version."colors"."0.5.1";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nomnom" ];
  };
  by-spec."nopt"."2" =
    self.by-version."nopt"."2.2.1";
  by-version."nopt"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.2.1.tgz";
        name = "nopt-2.2.1.tgz";
        sha1 = "2aa09b7d1768487b3b89a9c5aa52335bff0baea7";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."2 || 3" =
    self.by-version."nopt"."3.0.1";
  by-version."nopt"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-3.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-3.0.1.tgz";
        name = "nopt-3.0.1.tgz";
        sha1 = "bce5c42446a3291f47622a370abbf158fbbacbfd";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."2.0.0" =
    self.by-version."nopt"."2.0.0";
  by-version."nopt"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.0.0.tgz";
        name = "nopt-2.0.0.tgz";
        sha1 = "ca7416f20a5e3f9c3b86180f96295fa3d0b52e0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."3.x" =
    self.by-version."nopt"."3.0.1";
  by-spec."nopt"."~1.0.10" =
    self.by-version."nopt"."1.0.10";
  by-version."nopt"."1.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-1.0.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-1.0.10.tgz";
        name = "nopt-1.0.10.tgz";
        sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."~2.1.2" =
    self.by-version."nopt"."2.1.2";
  by-version."nopt"."2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.1.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.1.2.tgz";
        name = "nopt-2.1.2.tgz";
        sha1 = "6cccd977b80132a07731d6e8ce58c2c8303cf9af";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nopt"."~2.2.0" =
    self.by-version."nopt"."2.2.1";
  by-spec."nopt"."~3.0.0" =
    self.by-version."nopt"."3.0.1";
  by-spec."nopt"."~3.0.1" =
    self.by-version."nopt"."3.0.1";
  by-spec."normalize-package-data"."^1.0.0" =
    self.by-version."normalize-package-data"."1.0.3";
  by-version."normalize-package-data"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "normalize-package-data-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/normalize-package-data/-/normalize-package-data-1.0.3.tgz";
        name = "normalize-package-data-1.0.3.tgz";
        sha1 = "8be955b8907af975f1a4584ea8bb9b41492312f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."normalize-package-data" or []);
    deps = {
      "github-url-from-git-1.4.0" = self.by-version."github-url-from-git"."1.4.0";
      "github-url-from-username-repo-1.0.2" = self.by-version."github-url-from-username-repo"."1.0.2";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "normalize-package-data" ];
  };
  by-spec."normalize-package-data"."~1.0.1" =
    self.by-version."normalize-package-data"."1.0.3";
  by-spec."normalize-package-data"."~1.0.3" =
    self.by-version."normalize-package-data"."1.0.3";
  by-spec."npm"."*" =
    self.by-version."npm"."2.1.5";
  by-version."npm"."2.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "npm-2.1.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-2.1.5.tgz";
        name = "npm-2.1.5.tgz";
        sha1 = "ce343163a56f1ff14ffa295c140d99833b9764cb";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "ansi-0.3.0" = self.by-version."ansi"."0.3.0";
      "ansicolors-0.3.2" = self.by-version."ansicolors"."0.3.2";
      "ansistyles-0.1.3" = self.by-version."ansistyles"."0.1.3";
      "archy-1.0.0" = self.by-version."archy"."1.0.0";
      "async-some-1.0.1" = self.by-version."async-some"."1.0.1";
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "char-spinner-1.0.1" = self.by-version."char-spinner"."1.0.1";
      "child-process-close-0.1.1" = self.by-version."child-process-close"."0.1.1";
      "chmodr-0.1.0" = self.by-version."chmodr"."0.1.0";
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "cmd-shim-2.0.1" = self.by-version."cmd-shim"."2.0.1";
      "columnify-1.2.1" = self.by-version."columnify"."1.2.1";
      "config-chain-1.1.8" = self.by-version."config-chain"."1.1.8";
      "dezalgo-1.0.1" = self.by-version."dezalgo"."1.0.1";
      "editor-0.1.0" = self.by-version."editor"."0.1.0";
      "fs-vacuum-1.2.1" = self.by-version."fs-vacuum"."1.2.1";
      "fs-write-stream-atomic-1.0.2" = self.by-version."fs-write-stream-atomic"."1.0.2";
      "fstream-1.0.2" = self.by-version."fstream"."1.0.2";
      "fstream-npm-1.0.1" = self.by-version."fstream-npm"."1.0.1";
      "github-url-from-git-1.4.0" = self.by-version."github-url-from-git"."1.4.0";
      "github-url-from-username-repo-1.0.2" = self.by-version."github-url-from-username-repo"."1.0.2";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "ini-1.3.0" = self.by-version."ini"."1.3.0";
      "init-package-json-1.1.0" = self.by-version."init-package-json"."1.1.0";
      "lockfile-1.0.0" = self.by-version."lockfile"."1.0.0";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "node-gyp-1.0.2" = self.by-version."node-gyp"."1.0.2";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "normalize-package-data-1.0.3" = self.by-version."normalize-package-data"."1.0.3";
      "npm-cache-filename-1.0.1" = self.by-version."npm-cache-filename"."1.0.1";
      "npm-install-checks-1.0.4" = self.by-version."npm-install-checks"."1.0.4";
      "npm-package-arg-2.1.3" = self.by-version."npm-package-arg"."2.1.3";
      "npm-registry-client-3.2.4" = self.by-version."npm-registry-client"."3.2.4";
      "npm-user-validate-0.1.1" = self.by-version."npm-user-validate"."0.1.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "opener-1.4.0" = self.by-version."opener"."1.4.0";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "path-is-inside-1.0.1" = self.by-version."path-is-inside"."1.0.1";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "read-installed-3.1.3" = self.by-version."read-installed"."3.1.3";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "realize-package-specifier-1.2.0" = self.by-version."realize-package-specifier"."1.2.0";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "sha-1.3.0" = self.by-version."sha"."1.3.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "sorted-object-1.0.0" = self.by-version."sorted-object"."1.0.0";
      "tar-1.0.1" = self.by-version."tar"."1.0.1";
      "text-table-0.2.0" = self.by-version."text-table"."0.2.0";
      "uid-number-0.0.5" = self.by-version."uid-number"."0.0.5";
      "which-1.0.5" = self.by-version."which"."1.0.5";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
      "write-file-atomic-1.1.0" = self.by-version."write-file-atomic"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  "npm" = self.by-version."npm"."2.1.5";
  by-spec."npm-cache-filename"."^1.0.0" =
    self.by-version."npm-cache-filename"."1.0.1";
  by-version."npm-cache-filename"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "npm-cache-filename-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-cache-filename/-/npm-cache-filename-1.0.1.tgz";
        name = "npm-cache-filename-1.0.1.tgz";
        sha1 = "9b640f0c1a5ba1145659685372a9ff71f70c4323";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-cache-filename" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-cache-filename" ];
  };
  by-spec."npm-cache-filename"."~1.0.1" =
    self.by-version."npm-cache-filename"."1.0.1";
  by-spec."npm-install-checks"."~1.0.2" =
    self.by-version."npm-install-checks"."1.0.4";
  by-version."npm-install-checks"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "npm-install-checks-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-install-checks/-/npm-install-checks-1.0.4.tgz";
        name = "npm-install-checks-1.0.4.tgz";
        sha1 = "9757c6f9d4d493c2489465da6d07a8ed416d44c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-install-checks" or []);
    deps = {
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-install-checks" ];
  };
  by-spec."npm-package-arg"."^2.1.3" =
    self.by-version."npm-package-arg"."2.1.3";
  by-version."npm-package-arg"."2.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "npm-package-arg-2.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-package-arg/-/npm-package-arg-2.1.3.tgz";
        name = "npm-package-arg-2.1.3.tgz";
        sha1 = "dfba34bd82dd327c10cb43a65c8db6ef0b812bf7";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-package-arg" or []);
    deps = {
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-package-arg" ];
  };
  by-spec."npm-package-arg"."~2.1.3" =
    self.by-version."npm-package-arg"."2.1.3";
  by-spec."npm-registry-client"."0.2.27" =
    self.by-version."npm-registry-client"."0.2.27";
  by-version."npm-registry-client"."0.2.27" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.2.27";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.2.27.tgz";
        name = "npm-registry-client-0.2.27.tgz";
        sha1 = "8f338189d32769267886a07ad7b7fd2267446adf";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = {
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "semver-2.0.11" = self.by-version."semver"."2.0.11";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "retry-0.6.0" = self.by-version."retry"."0.6.0";
      "couch-login-0.1.20" = self.by-version."couch-login"."0.1.20";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-registry-client"."~3.1.4" =
    self.by-version."npm-registry-client"."3.1.8";
  by-version."npm-registry-client"."3.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-3.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-3.1.8.tgz";
        name = "npm-registry-client-3.1.8.tgz";
        sha1 = "8cc5e0e6523683a95ba0735e53fddb5819372033";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = {
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "normalize-package-data-1.0.3" = self.by-version."normalize-package-data"."1.0.3";
      "npm-cache-filename-1.0.1" = self.by-version."npm-cache-filename"."1.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "retry-0.6.0" = self.by-version."retry"."0.6.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-registry-client"."~3.2.4" =
    self.by-version."npm-registry-client"."3.2.4";
  by-version."npm-registry-client"."3.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-3.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-3.2.4.tgz";
        name = "npm-registry-client-3.2.4.tgz";
        sha1 = "8659b3449e1c9a9f8181dad142cadb048bfe521f";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = {
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "normalize-package-data-1.0.3" = self.by-version."normalize-package-data"."1.0.3";
      "npm-cache-filename-1.0.1" = self.by-version."npm-cache-filename"."1.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-user-validate"."~0.1.1" =
    self.by-version."npm-user-validate"."0.1.1";
  by-version."npm-user-validate"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npm-user-validate-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-user-validate/-/npm-user-validate-0.1.1.tgz";
        name = "npm-user-validate-0.1.1.tgz";
        sha1 = "ea7774636c3c8fe6d01e174bd9f2ee0e22eeed57";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-user-validate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-user-validate" ];
  };
  by-spec."npm2nix"."*" =
    self.by-version."npm2nix"."5.8.1";
  by-version."npm2nix"."5.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "npm2nix-5.8.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm2nix/-/npm2nix-5.8.1.tgz";
        name = "npm2nix-5.8.1.tgz";
        sha1 = "0d8356b458caaa677b4a1225fea4900f2995982f";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm2nix" or []);
    deps = {
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "npm-registry-client-0.2.27" = self.by-version."npm-registry-client"."0.2.27";
      "npmconf-0.1.1" = self.by-version."npmconf"."0.1.1";
      "tar-0.1.17" = self.by-version."tar"."0.1.17";
      "temp-0.6.0" = self.by-version."temp"."0.6.0";
      "fs.extra-1.2.1" = self.by-version."fs.extra"."1.2.1";
      "findit-1.2.0" = self.by-version."findit"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm2nix" ];
  };
  "npm2nix" = self.by-version."npm2nix"."5.8.1";
  by-spec."npmconf"."0.1.1" =
    self.by-version."npmconf"."0.1.1";
  by-version."npmconf"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.1.tgz";
        name = "npmconf-0.1.1.tgz";
        sha1 = "7a254182591ca22d77b2faecc0d17e0f9bdf25a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = {
      "config-chain-1.1.8" = self.by-version."config-chain"."1.1.8";
      "inherits-1.0.0" = self.by-version."inherits"."1.0.0";
      "once-1.1.1" = self.by-version."once"."1.1.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."2.0.9" =
    self.by-version."npmconf"."2.0.9";
  by-version."npmconf"."2.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-2.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-2.0.9.tgz";
        name = "npmconf-2.0.9.tgz";
        sha1 = "5c87e5fb308104eceeca781e3d9115d216351ef2";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = {
      "config-chain-1.1.8" = self.by-version."config-chain"."1.1.8";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "ini-1.3.0" = self.by-version."ini"."1.3.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "uid-number-0.0.5" = self.by-version."uid-number"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."^2.0.1" =
    self.by-version."npmconf"."2.1.1";
  by-version."npmconf"."2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-2.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-2.1.1.tgz";
        name = "npmconf-2.1.1.tgz";
        sha1 = "a266c7e5c56695eb7f55caf3a5a7328f24510dae";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = {
      "config-chain-1.1.8" = self.by-version."config-chain"."1.1.8";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "ini-1.3.0" = self.by-version."ini"."1.3.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "uid-number-0.0.5" = self.by-version."uid-number"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."~0.1.2" =
    self.by-version."npmconf"."0.1.16";
  by-version."npmconf"."0.1.16" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.1.16";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.16.tgz";
        name = "npmconf-0.1.16.tgz";
        sha1 = "0bdca78b8551419686b3a98004f06f0819edcd2a";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf" or []);
    deps = {
      "config-chain-1.1.8" = self.by-version."config-chain"."1.1.8";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."~2.0.5" =
    self.by-version."npmconf"."2.0.9";
  by-spec."npmlog"."*" =
    self.by-version."npmlog"."0.1.1";
  by-version."npmlog"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.1.1.tgz";
        name = "npmlog-0.1.1.tgz";
        sha1 = "8b9b9e4405d7ec48c31c2346965aadc7abaecaa5";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog" or []);
    deps = {
      "ansi-0.3.0" = self.by-version."ansi"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  by-spec."npmlog"."0" =
    self.by-version."npmlog"."0.1.1";
  by-spec."npmlog"."0.1" =
    self.by-version."npmlog"."0.1.1";
  by-spec."npmlog"."~0.1.1" =
    self.by-version."npmlog"."0.1.1";
  by-spec."nssocket"."~0.5.1" =
    self.by-version."nssocket"."0.5.1";
  by-version."nssocket"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "nssocket-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nssocket/-/nssocket-0.5.1.tgz";
        name = "nssocket-0.5.1.tgz";
        sha1 = "11f0428335ad8d89ff9cf96ab2852a23b1b33b71";
      })
    ];
    buildInputs =
      (self.nativeDeps."nssocket" or []);
    deps = {
      "eventemitter2-0.4.14" = self.by-version."eventemitter2"."0.4.14";
      "lazy-1.0.11" = self.by-version."lazy"."1.0.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nssocket" ];
  };
  by-spec."oauth"."https://github.com/ciaranj/node-oauth/tarball/master" =
    self.by-version."oauth"."0.9.11";
  by-version."oauth"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-0.9.11";
    bin = false;
    src = [
      (fetchurl {
        url = "https://github.com/ciaranj/node-oauth/tarball/master";
        name = "oauth-0.9.11.tgz";
        sha256 = "783dead39b8df22dfff8961fcfb3e65622375d4308c12c1fbce2ae2e4da20184";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "oauth" ];
  };
  by-spec."oauth-sign"."~0.2.0" =
    self.by-version."oauth-sign"."0.2.0";
  by-version."oauth-sign"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.2.0.tgz";
        name = "oauth-sign-0.2.0.tgz";
        sha1 = "a0e6a1715daed062f322b622b7fe5afd1035b6e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."oauth-sign"."~0.3.0" =
    self.by-version."oauth-sign"."0.3.0";
  by-version."oauth-sign"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
        name = "oauth-sign-0.3.0.tgz";
        sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."oauth-sign"."~0.4.0" =
    self.by-version."oauth-sign"."0.4.0";
  by-version."oauth-sign"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.4.0.tgz";
        name = "oauth-sign-0.4.0.tgz";
        sha1 = "f22956f31ea7151a821e5f2fb32c113cad8b9f69";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."object-additions".">= 0.5.0" =
    self.by-version."object-additions"."0.5.1";
  by-version."object-additions"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "object-additions-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-additions/-/object-additions-0.5.1.tgz";
        name = "object-additions-0.5.1.tgz";
        sha1 = "ac624e0995e696c94cc69b41f316462b16a3bda4";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-additions" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-additions" ];
  };
  by-spec."object-assign"."^0.3.0" =
    self.by-version."object-assign"."0.3.1";
  by-version."object-assign"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "object-assign-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-assign/-/object-assign-0.3.1.tgz";
        name = "object-assign-0.3.1.tgz";
        sha1 = "060e2a2a27d7c0d77ec77b78f11aa47fd88008d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-assign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-assign" ];
  };
  by-spec."object-assign"."^1.0.0" =
    self.by-version."object-assign"."1.0.0";
  by-version."object-assign"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-assign-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-assign/-/object-assign-1.0.0.tgz";
        name = "object-assign-1.0.0.tgz";
        sha1 = "e65dc8766d3b47b4b8307465c8311da030b070a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-assign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-assign" ];
  };
  by-spec."object-assign"."~0.3.1" =
    self.by-version."object-assign"."0.3.1";
  by-spec."object-keys"."~0.4.0" =
    self.by-version."object-keys"."0.4.0";
  by-version."object-keys"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-keys-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-keys/-/object-keys-0.4.0.tgz";
        name = "object-keys-0.4.0.tgz";
        sha1 = "28a6aae7428dd2c3a92f3d95f21335dd204e0336";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-keys" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-keys" ];
  };
  by-spec."on-finished"."2.1.0" =
    self.by-version."on-finished"."2.1.0";
  by-version."on-finished"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "on-finished-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/on-finished/-/on-finished-2.1.0.tgz";
        name = "on-finished-2.1.0.tgz";
        sha1 = "0c539f09291e8ffadde0c8a25850fb2cedc7022d";
      })
    ];
    buildInputs =
      (self.nativeDeps."on-finished" or []);
    deps = {
      "ee-first-1.0.5" = self.by-version."ee-first"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "on-finished" ];
  };
  by-spec."on-finished"."~2.1.0" =
    self.by-version."on-finished"."2.1.0";
  by-spec."on-headers"."~1.0.0" =
    self.by-version."on-headers"."1.0.0";
  by-version."on-headers"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "on-headers-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/on-headers/-/on-headers-1.0.0.tgz";
        name = "on-headers-1.0.0.tgz";
        sha1 = "2c75b5da4375513d0161c6052e7fcbe4953fca5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."on-headers" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "on-headers" ];
  };
  by-spec."once"."1.1.1" =
    self.by-version."once"."1.1.1";
  by-version."once"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.1.1.tgz";
        name = "once-1.1.1.tgz";
        sha1 = "9db574933ccb08c3a7614d154032c09ea6f339e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."once"."1.x" =
    self.by-version."once"."1.3.1";
  by-version."once"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.1.tgz";
        name = "once-1.3.1.tgz";
        sha1 = "f3f3e4da5b7d27b5c732969ee3e67e729457b31f";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = {
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.1";
  by-spec."once"."~1.1.1" =
    self.by-version."once"."1.1.1";
  by-spec."once"."~1.2.0" =
    self.by-version."once"."1.2.0";
  by-version."once"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.2.0.tgz";
        name = "once-1.2.0.tgz";
        sha1 = "de1905c636af874a8fba862d9aabddd1f920461c";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."once"."~1.3.0" =
    self.by-version."once"."1.3.1";
  by-spec."once"."~1.3.1" =
    self.by-version."once"."1.3.1";
  by-spec."open"."0.0.2" =
    self.by-version."open"."0.0.2";
  by-version."open"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "open-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/open/-/open-0.0.2.tgz";
        name = "open-0.0.2.tgz";
        sha1 = "0a620ba2574464742f51e69f8ba8eccfd97b5dfc";
      })
    ];
    buildInputs =
      (self.nativeDeps."open" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "open" ];
  };
  by-spec."open"."~0.0.5" =
    self.by-version."open"."0.0.5";
  by-version."open"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "open-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/open/-/open-0.0.5.tgz";
        name = "open-0.0.5.tgz";
        sha1 = "42c3e18ec95466b6bf0dc42f3a2945c3f0cad8fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."open" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "open" ];
  };
  by-spec."opener"."~1.3.0" =
    self.by-version."opener"."1.3.0";
  by-version."opener"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "opener-1.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/opener/-/opener-1.3.0.tgz";
        name = "opener-1.3.0.tgz";
        sha1 = "130ba662213fa842edb4cd0361d31a15301a43e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."opener" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "opener" ];
  };
  by-spec."opener"."~1.4.0" =
    self.by-version."opener"."1.4.0";
  by-version."opener"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "opener-1.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/opener/-/opener-1.4.0.tgz";
        name = "opener-1.4.0.tgz";
        sha1 = "d11f86eeeb076883735c9d509f538fe82d10b941";
      })
    ];
    buildInputs =
      (self.nativeDeps."opener" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "opener" ];
  };
  by-spec."openid".">=0.2.0" =
    self.by-version."openid"."0.5.9";
  by-version."openid"."0.5.9" = lib.makeOverridable self.buildNodePackage {
    name = "openid-0.5.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/openid/-/openid-0.5.9.tgz";
        name = "openid-0.5.9.tgz";
        sha1 = "f44dd2609764c458c65fb22c03db068579e4bfa8";
      })
    ];
    buildInputs =
      (self.nativeDeps."openid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "openid" ];
  };
  by-spec."opn"."~1.0.0" =
    self.by-version."opn"."1.0.0";
  by-version."opn"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "opn-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/opn/-/opn-1.0.0.tgz";
        name = "opn-1.0.0.tgz";
        sha1 = "1baa822af649a45fca744179a29a8b4c19346574";
      })
    ];
    buildInputs =
      (self.nativeDeps."opn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "opn" ];
  };
  by-spec."optimist"."*" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
        name = "optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = {
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  "optimist" = self.by-version."optimist"."0.6.1";
  by-spec."optimist"."0.2" =
    self.by-version."optimist"."0.2.8";
  by-version."optimist"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.2.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.2.8.tgz";
        name = "optimist-0.2.8.tgz";
        sha1 = "e981ab7e268b457948593b55674c099a815cac31";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = {
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."0.6.0" =
    self.by-version."optimist"."0.6.0";
  by-version."optimist"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.0.tgz";
        name = "optimist-0.6.0.tgz";
        sha1 = "69424826f3405f79f142e6fc3d9ae58d4dbb9200";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = {
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."0.6.x" =
    self.by-version."optimist"."0.6.1";
  by-spec."optimist"."~0.3" =
    self.by-version."optimist"."0.3.7";
  by-version."optimist"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        name = "optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = {
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."~0.3.5" =
    self.by-version."optimist"."0.3.7";
  by-spec."optimist"."~0.6.0" =
    self.by-version."optimist"."0.6.1";
  by-spec."optimist"."~0.6.1" =
    self.by-version."optimist"."0.6.1";
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "options-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/options/-/options-0.0.6.tgz";
        name = "options-0.0.6.tgz";
        sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
      })
    ];
    buildInputs =
      (self.nativeDeps."options" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "options" ];
  };
  by-spec."optparse"."*" =
    self.by-version."optparse"."1.0.5";
  by-version."optparse"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "optparse-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optparse/-/optparse-1.0.5.tgz";
        name = "optparse-1.0.5.tgz";
        sha1 = "75e75a96506611eb1c65ba89018ff08a981e2c16";
      })
    ];
    buildInputs =
      (self.nativeDeps."optparse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "optparse" ];
  };
  "optparse" = self.by-version."optparse"."1.0.5";
  by-spec."optparse".">= 1.0.3" =
    self.by-version."optparse"."1.0.5";
  by-spec."orchestrator"."^0.3.0" =
    self.by-version."orchestrator"."0.3.7";
  by-version."orchestrator"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "orchestrator-0.3.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/orchestrator/-/orchestrator-0.3.7.tgz";
        name = "orchestrator-0.3.7.tgz";
        sha1 = "c45064e22c5a2a7b99734f409a95ffedc7d3c3df";
      })
    ];
    buildInputs =
      (self.nativeDeps."orchestrator" or []);
    deps = {
      "end-of-stream-0.1.5" = self.by-version."end-of-stream"."0.1.5";
      "sequencify-0.0.7" = self.by-version."sequencify"."0.0.7";
      "stream-consume-0.1.0" = self.by-version."stream-consume"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "orchestrator" ];
  };
  by-spec."ordered-read-streams"."0.0.8" =
    self.by-version."ordered-read-streams"."0.0.8";
  by-version."ordered-read-streams"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "ordered-read-streams-0.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ordered-read-streams/-/ordered-read-streams-0.0.8.tgz";
        name = "ordered-read-streams-0.0.8.tgz";
        sha1 = "fd921331b1a130b66aeef711b219aee01d89e0c5";
      })
    ];
    buildInputs =
      (self.nativeDeps."ordered-read-streams" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ordered-read-streams" ];
  };
  by-spec."os-browserify"."~0.1.1" =
    self.by-version."os-browserify"."0.1.2";
  by-version."os-browserify"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "os-browserify-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/os-browserify/-/os-browserify-0.1.2.tgz";
        name = "os-browserify-0.1.2.tgz";
        sha1 = "49ca0293e0b19590a5f5de10c7f265a617d8fe54";
      })
    ];
    buildInputs =
      (self.nativeDeps."os-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "os-browserify" ];
  };
  by-spec."os-name"."^1.0.0" =
    self.by-version."os-name"."1.0.1";
  by-version."os-name"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "os-name-1.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/os-name/-/os-name-1.0.1.tgz";
        name = "os-name-1.0.1.tgz";
        sha1 = "5d78a4a0d6bc96f7fce8e060fef19525422dcc8f";
      })
    ];
    buildInputs =
      (self.nativeDeps."os-name" or []);
    deps = {
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "osx-release-1.0.0" = self.by-version."osx-release"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "os-name" ];
  };
  by-spec."osenv"."0" =
    self.by-version."osenv"."0.1.0";
  by-version."osenv"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.1.0.tgz";
        name = "osenv-0.1.0.tgz";
        sha1 = "61668121eec584955030b9f470b1d2309504bfcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."osenv" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "osenv" ];
  };
  by-spec."osenv"."0.0.3" =
    self.by-version."osenv"."0.0.3";
  by-version."osenv"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.0.3.tgz";
        name = "osenv-0.0.3.tgz";
        sha1 = "cd6ad8ddb290915ad9e22765576025d411f29cb6";
      })
    ];
    buildInputs =
      (self.nativeDeps."osenv" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "osenv" ];
  };
  by-spec."osenv"."0.1.0" =
    self.by-version."osenv"."0.1.0";
  by-spec."osenv"."^0.1.0" =
    self.by-version."osenv"."0.1.0";
  by-spec."osenv"."~0.1.0" =
    self.by-version."osenv"."0.1.0";
  by-spec."osx-release"."^1.0.0" =
    self.by-version."osx-release"."1.0.0";
  by-version."osx-release"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "osx-release-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osx-release/-/osx-release-1.0.0.tgz";
        name = "osx-release-1.0.0.tgz";
        sha1 = "02bee80f3b898aaa88922d2f86e178605974beac";
      })
    ];
    buildInputs =
      (self.nativeDeps."osx-release" or []);
    deps = {
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "osx-release" ];
  };
  by-spec."owl-deepcopy"."*" =
    self.by-version."owl-deepcopy"."0.0.4";
  by-version."owl-deepcopy"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "owl-deepcopy-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/owl-deepcopy/-/owl-deepcopy-0.0.4.tgz";
        name = "owl-deepcopy-0.0.4.tgz";
        sha1 = "665f3aeafab74302d98ecaeeb7b3e764ae21f369";
      })
    ];
    buildInputs =
      (self.nativeDeps."owl-deepcopy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "owl-deepcopy" ];
  };
  "owl-deepcopy" = self.by-version."owl-deepcopy"."0.0.4";
  by-spec."owl-deepcopy"."~0.0.1" =
    self.by-version."owl-deepcopy"."0.0.4";
  by-spec."p-throttler"."0.1.0" =
    self.by-version."p-throttler"."0.1.0";
  by-version."p-throttler"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "p-throttler-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/p-throttler/-/p-throttler-0.1.0.tgz";
        name = "p-throttler-0.1.0.tgz";
        sha1 = "1b16907942c333e6f1ddeabcb3479204b8c417c4";
      })
    ];
    buildInputs =
      (self.nativeDeps."p-throttler" or []);
    deps = {
      "q-0.9.7" = self.by-version."q"."0.9.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "p-throttler" ];
  };
  by-spec."package-json"."^0.2.0" =
    self.by-version."package-json"."0.2.0";
  by-version."package-json"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "package-json-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/package-json/-/package-json-0.2.0.tgz";
        name = "package-json-0.2.0.tgz";
        sha1 = "0316e177b8eb149985d34f706b4a5543b274bec5";
      })
    ];
    buildInputs =
      (self.nativeDeps."package-json" or []);
    deps = {
      "got-0.3.0" = self.by-version."got"."0.3.0";
      "registry-url-0.1.1" = self.by-version."registry-url"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "package-json" ];
  };
  by-spec."pako"."~0.2.0" =
    self.by-version."pako"."0.2.5";
  by-version."pako"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "pako-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pako/-/pako-0.2.5.tgz";
        name = "pako-0.2.5.tgz";
        sha1 = "36df19467a3879152e9adcc44784f07d0a80c525";
      })
    ];
    buildInputs =
      (self.nativeDeps."pako" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pako" ];
  };
  by-spec."parents"."^1.0.0" =
    self.by-version."parents"."1.0.0";
  by-version."parents"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "parents-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parents/-/parents-1.0.0.tgz";
        name = "parents-1.0.0.tgz";
        sha1 = "05726fdb61b60d8c9e3d5d9c595aa78c881c8479";
      })
    ];
    buildInputs =
      (self.nativeDeps."parents" or []);
    deps = {
      "path-platform-0.0.1" = self.by-version."path-platform"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "parents" ];
  };
  by-spec."parents"."~0.0.1" =
    self.by-version."parents"."0.0.3";
  by-version."parents"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "parents-0.0.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parents/-/parents-0.0.3.tgz";
        name = "parents-0.0.3.tgz";
        sha1 = "fa212f024d9fa6318dbb6b4ce676c8be493b9c43";
      })
    ];
    buildInputs =
      (self.nativeDeps."parents" or []);
    deps = {
      "path-platform-0.0.1" = self.by-version."path-platform"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "parents" ];
  };
  by-spec."parseurl"."1.0.1" =
    self.by-version."parseurl"."1.0.1";
  by-version."parseurl"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "parseurl-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parseurl/-/parseurl-1.0.1.tgz";
        name = "parseurl-1.0.1.tgz";
        sha1 = "2e57dce6efdd37c3518701030944c22bf388b7b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."parseurl" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "parseurl" ];
  };
  by-spec."parseurl"."~1.3.0" =
    self.by-version."parseurl"."1.3.0";
  by-version."parseurl"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "parseurl-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parseurl/-/parseurl-1.3.0.tgz";
        name = "parseurl-1.3.0.tgz";
        sha1 = "b58046db4223e145afa76009e61bac87cc2281b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."parseurl" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "parseurl" ];
  };
  by-spec."passport"."*" =
    self.by-version."passport"."0.2.1";
  by-version."passport"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.2.1.tgz";
        name = "passport-0.2.1.tgz";
        sha1 = "a7d34c07b30fb605be885edbc8c93e5142e38574";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport" or []);
    deps = {
      "passport-strategy-1.0.0" = self.by-version."passport-strategy"."1.0.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  "passport" = self.by-version."passport"."0.2.1";
  by-spec."passport"."~0.1.3" =
    self.by-version."passport"."0.1.18";
  by-version."passport"."0.1.18" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.1.18";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.18.tgz";
        name = "passport-0.1.18.tgz";
        sha1 = "c8264479dcb6414cadbb66752d12b37e0b6525a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport" or []);
    deps = {
      "pkginfo-0.2.3" = self.by-version."pkginfo"."0.2.3";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  by-spec."passport"."~0.2.0" =
    self.by-version."passport"."0.2.1";
  by-spec."passport-http"."*" =
    self.by-version."passport-http"."0.2.2";
  by-version."passport-http"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "passport-http-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-http/-/passport-http-0.2.2.tgz";
        name = "passport-http-0.2.2.tgz";
        sha1 = "2501314c0ff4a831e8a51ccfdb1b68f5c7cbc9f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-http" or []);
    deps = {
      "pkginfo-0.2.3" = self.by-version."pkginfo"."0.2.3";
      "passport-0.1.18" = self.by-version."passport"."0.1.18";
    };
    peerDependencies = [
    ];
    passthru.names = [ "passport-http" ];
  };
  "passport-http" = self.by-version."passport-http"."0.2.2";
  by-spec."passport-local"."*" =
    self.by-version."passport-local"."1.0.0";
  by-version."passport-local"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "passport-local-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-local/-/passport-local-1.0.0.tgz";
        name = "passport-local-1.0.0.tgz";
        sha1 = "1fe63268c92e75606626437e3b906662c15ba6ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-local" or []);
    deps = {
      "passport-strategy-1.0.0" = self.by-version."passport-strategy"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "passport-local" ];
  };
  "passport-local" = self.by-version."passport-local"."1.0.0";
  by-spec."passport-local"."~1.0.0" =
    self.by-version."passport-local"."1.0.0";
  by-spec."passport-strategy"."1.x.x" =
    self.by-version."passport-strategy"."1.0.0";
  by-version."passport-strategy"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "passport-strategy-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-strategy/-/passport-strategy-1.0.0.tgz";
        name = "passport-strategy-1.0.0.tgz";
        sha1 = "b5539aa8fc225a3d1ad179476ddf236b440f52e4";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-strategy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "passport-strategy" ];
  };
  by-spec."path-browserify"."~0.0.0" =
    self.by-version."path-browserify"."0.0.0";
  by-version."path-browserify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "path-browserify-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-browserify/-/path-browserify-0.0.0.tgz";
        name = "path-browserify-0.0.0.tgz";
        sha1 = "a0b870729aae214005b7d5032ec2cbbb0fb4451a";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-browserify" ];
  };
  by-spec."path-is-inside"."~1.0.0" =
    self.by-version."path-is-inside"."1.0.1";
  by-version."path-is-inside"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "path-is-inside-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.1.tgz";
        name = "path-is-inside-1.0.1.tgz";
        sha1 = "98d8f1d030bf04bd7aeee4a1ba5485d40318fd89";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-is-inside" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-is-inside" ];
  };
  by-spec."path-platform"."^0.0.1" =
    self.by-version."path-platform"."0.0.1";
  by-version."path-platform"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "path-platform-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-platform/-/path-platform-0.0.1.tgz";
        name = "path-platform-0.0.1.tgz";
        sha1 = "b5585d7c3c463d89aa0060d86611cf1afd617e2a";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-platform" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-platform" ];
  };
  by-spec."path-to-regexp"."0.1.2" =
    self.by-version."path-to-regexp"."0.1.2";
  by-version."path-to-regexp"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "path-to-regexp-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.2.tgz";
        name = "path-to-regexp-0.1.2.tgz";
        sha1 = "9b2b151f9cc3018c9eea50ca95729e05781712b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-to-regexp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-to-regexp" ];
  };
  by-spec."path-to-regexp"."0.1.3" =
    self.by-version."path-to-regexp"."0.1.3";
  by-version."path-to-regexp"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "path-to-regexp-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.3.tgz";
        name = "path-to-regexp-0.1.3.tgz";
        sha1 = "21b9ab82274279de25b156ea08fd12ca51b8aecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-to-regexp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-to-regexp" ];
  };
  by-spec."pause"."0.0.1" =
    self.by-version."pause"."0.0.1";
  by-version."pause"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "pause-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pause/-/pause-0.0.1.tgz";
        name = "pause-0.0.1.tgz";
        sha1 = "1d408b3fdb76923b9543d96fb4c9dfd535d9cb5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."pause" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pause" ];
  };
  by-spec."pbkdf2-compat"."2.0.1" =
    self.by-version."pbkdf2-compat"."2.0.1";
  by-version."pbkdf2-compat"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "pbkdf2-compat-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pbkdf2-compat/-/pbkdf2-compat-2.0.1.tgz";
        name = "pbkdf2-compat-2.0.1.tgz";
        sha1 = "b6e0c8fa99494d94e0511575802a59a5c142f288";
      })
    ];
    buildInputs =
      (self.nativeDeps."pbkdf2-compat" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pbkdf2-compat" ];
  };
  by-spec."phantomjs"."*" =
    self.by-version."phantomjs"."1.9.11";
  by-version."phantomjs"."1.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "phantomjs-1.9.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/phantomjs/-/phantomjs-1.9.11.tgz";
        name = "phantomjs-1.9.11.tgz";
        sha1 = "de822affca7858382b6ab9c931ba4541e5b8a0ae";
      })
    ];
    buildInputs =
      (self.nativeDeps."phantomjs" or []);
    deps = {
      "adm-zip-0.4.4" = self.by-version."adm-zip"."0.4.4";
      "kew-0.4.0" = self.by-version."kew"."0.4.0";
      "ncp-0.6.0" = self.by-version."ncp"."0.6.0";
      "npmconf-2.0.9" = self.by-version."npmconf"."2.0.9";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "progress-1.1.8" = self.by-version."progress"."1.1.8";
      "request-2.42.0" = self.by-version."request"."2.42.0";
      "request-progress-0.3.1" = self.by-version."request-progress"."0.3.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "which-1.0.5" = self.by-version."which"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "phantomjs" ];
  };
  "phantomjs" = self.by-version."phantomjs"."1.9.11";
  by-spec."phantomjs"."~1.9.1" =
    self.by-version."phantomjs"."1.9.11";
  by-spec."phantomjs"."~1.9.10" =
    self.by-version."phantomjs"."1.9.11";
  by-spec."pkginfo"."0.2.x" =
    self.by-version."pkginfo"."0.2.3";
  by-version."pkginfo"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.2.3.tgz";
        name = "pkginfo-0.2.3.tgz";
        sha1 = "7239c42a5ef6c30b8f328439d9b9ff71042490f8";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  by-spec."pkginfo"."0.3.0" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        name = "pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-spec."pkginfo"."0.x.x" =
    self.by-version."pkginfo"."0.3.0";
  by-spec."plist-native"."*" =
    self.by-version."plist-native"."0.3.1";
  by-version."plist-native"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "plist-native-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plist-native/-/plist-native-0.3.1.tgz";
        name = "plist-native-0.3.1.tgz";
        sha1 = "c9cd71ae2ac6aa16c315dde213c65d6cc53dee1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."plist-native" or []);
    deps = {
      "libxmljs-0.10.0" = self.by-version."libxmljs"."0.10.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "plist-native" ];
  };
  "plist-native" = self.by-version."plist-native"."0.3.1";
  by-spec."policyfile"."0.0.4" =
    self.by-version."policyfile"."0.0.4";
  by-version."policyfile"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "policyfile-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/policyfile/-/policyfile-0.0.4.tgz";
        name = "policyfile-0.0.4.tgz";
        sha1 = "d6b82ead98ae79ebe228e2daf5903311ec982e4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."policyfile" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "policyfile" ];
  };
  by-spec."posix"."*" =
    self.by-version."posix"."1.0.3";
  by-version."posix"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "posix-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/posix/-/posix-1.0.3.tgz";
        name = "posix-1.0.3.tgz";
        sha1 = "f0efae90d59c56c4509c8f0ed222b421caa8188a";
      })
    ];
    buildInputs =
      (self.nativeDeps."posix" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "posix" ];
  };
  "posix" = self.by-version."posix"."1.0.3";
  by-spec."posix-getopt"."1.0.0" =
    self.by-version."posix-getopt"."1.0.0";
  by-version."posix-getopt"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "posix-getopt-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/posix-getopt/-/posix-getopt-1.0.0.tgz";
        name = "posix-getopt-1.0.0.tgz";
        sha1 = "42a90eca6119014c78bc4b9b70463d294db1aa87";
      })
    ];
    buildInputs =
      (self.nativeDeps."posix-getopt" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "posix-getopt" ];
  };
  by-spec."pretty-bytes"."^0.1.0" =
    self.by-version."pretty-bytes"."0.1.2";
  by-version."pretty-bytes"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "pretty-bytes-0.1.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pretty-bytes/-/pretty-bytes-0.1.2.tgz";
        name = "pretty-bytes-0.1.2.tgz";
        sha1 = "cd90294d58a1ca4e8a5d0fb9c8225998881acf00";
      })
    ];
    buildInputs =
      (self.nativeDeps."pretty-bytes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pretty-bytes" ];
  };
  by-spec."pretty-bytes"."^1.0.0" =
    self.by-version."pretty-bytes"."1.0.1";
  by-version."pretty-bytes"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "pretty-bytes-1.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pretty-bytes/-/pretty-bytes-1.0.1.tgz";
        name = "pretty-bytes-1.0.1.tgz";
        sha1 = "afd0b459da61834ac36617b05f9daa0beb043e3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."pretty-bytes" or []);
    deps = {
      "get-stdin-1.0.0" = self.by-version."get-stdin"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "pretty-bytes" ];
  };
  by-spec."pretty-hrtime"."^0.2.0" =
    self.by-version."pretty-hrtime"."0.2.2";
  by-version."pretty-hrtime"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "pretty-hrtime-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pretty-hrtime/-/pretty-hrtime-0.2.2.tgz";
        name = "pretty-hrtime-0.2.2.tgz";
        sha1 = "d4fd88351e3a4741f8173af7d6a4b846f9895c00";
      })
    ];
    buildInputs =
      (self.nativeDeps."pretty-hrtime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pretty-hrtime" ];
  };
  by-spec."process"."^0.8.0" =
    self.by-version."process"."0.8.0";
  by-version."process"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "process-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/process/-/process-0.8.0.tgz";
        name = "process-0.8.0.tgz";
        sha1 = "7bbaf7187fe6ded3fd5be0cb6103fba9cacb9798";
      })
    ];
    buildInputs =
      (self.nativeDeps."process" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "process" ];
  };
  by-spec."process"."~0.5.1" =
    self.by-version."process"."0.5.2";
  by-version."process"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "process-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/process/-/process-0.5.2.tgz";
        name = "process-0.5.2.tgz";
        sha1 = "1638d8a8e34c2f440a91db95ab9aeb677fc185cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."process" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "process" ];
  };
  by-spec."process"."~0.6.0" =
    self.by-version."process"."0.6.0";
  by-version."process"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "process-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/process/-/process-0.6.0.tgz";
        name = "process-0.6.0.tgz";
        sha1 = "7dd9be80ffaaedd4cb628f1827f1cbab6dc0918f";
      })
    ];
    buildInputs =
      (self.nativeDeps."process" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "process" ];
  };
  by-spec."progress"."1.1.8" =
    self.by-version."progress"."1.1.8";
  by-version."progress"."1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "progress-1.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/progress/-/progress-1.1.8.tgz";
        name = "progress-1.1.8.tgz";
        sha1 = "e260c78f6161cdd9b0e56cc3e0a85de17c7a57be";
      })
    ];
    buildInputs =
      (self.nativeDeps."progress" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "progress" ];
  };
  by-spec."promise"."~2.0" =
    self.by-version."promise"."2.0.0";
  by-version."promise"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "promise-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promise/-/promise-2.0.0.tgz";
        name = "promise-2.0.0.tgz";
        sha1 = "46648aa9d605af5d2e70c3024bf59436da02b80e";
      })
    ];
    buildInputs =
      (self.nativeDeps."promise" or []);
    deps = {
      "is-promise-1.0.1" = self.by-version."is-promise"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "promise" ];
  };
  by-spec."promise"."~6.0.1" =
    self.by-version."promise"."6.0.1";
  by-version."promise"."6.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "promise-6.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promise/-/promise-6.0.1.tgz";
        name = "promise-6.0.1.tgz";
        sha1 = "d475cff81c083a27fe87ae19952b72c1a6936237";
      })
    ];
    buildInputs =
      (self.nativeDeps."promise" or []);
    deps = {
      "asap-1.0.0" = self.by-version."asap"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "promise" ];
  };
  by-spec."prompt"."0.2.11" =
    self.by-version."prompt"."0.2.11";
  by-version."prompt"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "prompt-0.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/prompt/-/prompt-0.2.11.tgz";
        name = "prompt-0.2.11.tgz";
        sha1 = "26d455af4b7fac15291dfcdddf2400328c1fa446";
      })
    ];
    buildInputs =
      (self.nativeDeps."prompt" or []);
    deps = {
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "revalidator-0.1.8" = self.by-version."revalidator"."0.1.8";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
      "winston-0.6.2" = self.by-version."winston"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "prompt" ];
  };
  by-spec."prompt"."0.2.14" =
    self.by-version."prompt"."0.2.14";
  by-version."prompt"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "prompt-0.2.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/prompt/-/prompt-0.2.14.tgz";
        name = "prompt-0.2.14.tgz";
        sha1 = "57754f64f543fd7b0845707c818ece618f05ffdc";
      })
    ];
    buildInputs =
      (self.nativeDeps."prompt" or []);
    deps = {
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "revalidator-0.1.8" = self.by-version."revalidator"."0.1.8";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
      "winston-0.8.1" = self.by-version."winston"."0.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "prompt" ];
  };
  by-spec."promptly"."0.2.0" =
    self.by-version."promptly"."0.2.0";
  by-version."promptly"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "promptly-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promptly/-/promptly-0.2.0.tgz";
        name = "promptly-0.2.0.tgz";
        sha1 = "73ef200fa8329d5d3a8df41798950b8646ca46d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."promptly" or []);
    deps = {
      "read-1.0.5" = self.by-version."read"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "promptly" ];
  };
  by-spec."promzard"."~0.2.0" =
    self.by-version."promzard"."0.2.2";
  by-version."promzard"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "promzard-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promzard/-/promzard-0.2.2.tgz";
        name = "promzard-0.2.2.tgz";
        sha1 = "918b9f2b29458cb001781a8856502e4a79b016e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."promzard" or []);
    deps = {
      "read-1.0.5" = self.by-version."read"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "promzard" ];
  };
  by-spec."proto-list"."~1.2.1" =
    self.by-version."proto-list"."1.2.3";
  by-version."proto-list"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "proto-list-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proto-list/-/proto-list-1.2.3.tgz";
        name = "proto-list-1.2.3.tgz";
        sha1 = "6235554a1bca1f0d15e3ca12ca7329d5def42bd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."proto-list" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "proto-list" ];
  };
  by-spec."proxy-addr"."1.0.1" =
    self.by-version."proxy-addr"."1.0.1";
  by-version."proxy-addr"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "proxy-addr-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.1.tgz";
        name = "proxy-addr-1.0.1.tgz";
        sha1 = "c7c566d5eb4e3fad67eeb9c77c5558ccc39b88a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."proxy-addr" or []);
    deps = {
      "ipaddr.js-0.1.2" = self.by-version."ipaddr.js"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "proxy-addr" ];
  };
  by-spec."proxy-addr"."~1.0.3" =
    self.by-version."proxy-addr"."1.0.3";
  by-version."proxy-addr"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "proxy-addr-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.3.tgz";
        name = "proxy-addr-1.0.3.tgz";
        sha1 = "17d824aac844707441249da6d1ea5e889007cdd6";
      })
    ];
    buildInputs =
      (self.nativeDeps."proxy-addr" or []);
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-0.1.3" = self.by-version."ipaddr.js"."0.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "proxy-addr" ];
  };
  by-spec."ps-tree"."0.0.x" =
    self.by-version."ps-tree"."0.0.3";
  by-version."ps-tree"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "ps-tree-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ps-tree/-/ps-tree-0.0.3.tgz";
        name = "ps-tree-0.0.3.tgz";
        sha1 = "dbf8d752a7fe22fa7d58635689499610e9276ddc";
      })
    ];
    buildInputs =
      (self.nativeDeps."ps-tree" or []);
    deps = {
      "event-stream-0.5.3" = self.by-version."event-stream"."0.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ps-tree" ];
  };
  by-spec."ps-tree"."~0.0.3" =
    self.by-version."ps-tree"."0.0.3";
  by-spec."pump"."^0.3.5" =
    self.by-version."pump"."0.3.5";
  by-version."pump"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "pump-0.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pump/-/pump-0.3.5.tgz";
        name = "pump-0.3.5.tgz";
        sha1 = "ae5ff8c1f93ed87adc6530a97565b126f585454b";
      })
    ];
    buildInputs =
      (self.nativeDeps."pump" or []);
    deps = {
      "once-1.2.0" = self.by-version."once"."1.2.0";
      "end-of-stream-1.0.0" = self.by-version."end-of-stream"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "pump" ];
  };
  by-spec."punycode"."1.2.4" =
    self.by-version."punycode"."1.2.4";
  by-version."punycode"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "punycode-1.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.2.4.tgz";
        name = "punycode-1.2.4.tgz";
        sha1 = "54008ac972aec74175def9cba6df7fa9d3918740";
      })
    ];
    buildInputs =
      (self.nativeDeps."punycode" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "punycode" ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "punycode-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
        name = "punycode-1.3.2.tgz";
        sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
      })
    ];
    buildInputs =
      (self.nativeDeps."punycode" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "punycode" ];
  };
  by-spec."punycode"."~1.2.3" =
    self.by-version."punycode"."1.2.4";
  by-spec."punycode"."~1.2.4" =
    self.by-version."punycode"."1.2.4";
  by-spec."pure-css"."git://github.com/yui/pure.git#v0.5.0-rc-1" =
    self.by-version."pure-css"."0.5.0-rc-1";
  by-version."pure-css"."0.5.0-rc-1" = lib.makeOverridable self.buildNodePackage {
    name = "pure-0.5.0-rc-1";
    bin = false;
    src = [
      (fetchgit {
        url = "git://github.com/yui/pure.git";
        rev = "f5ce3ae4b48ce252adac7b6ddac50c9518729a2d";
        sha256 = "049ac2ef812771852978d11cd5aecac2dd561e97bb16ad89c79eb1e10aa57672";
      })
    ];
    buildInputs =
      (self.nativeDeps."pure" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pure" ];
  };
  "pure-css" = self.by-version."pure-css"."0.5.0-rc-1";
  by-spec."q".">= 0.0.1" =
    self.by-version."q"."2.0.2";
  by-version."q"."2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "q-2.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-2.0.2.tgz";
        name = "q-2.0.2.tgz";
        sha1 = "4629e6cc668ff8554cfa775dab5aba50bad8f56d";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = {
      "asap-1.0.0" = self.by-version."asap"."1.0.0";
      "collections-2.0.1" = self.by-version."collections"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  by-spec."q"."~0.9.2" =
    self.by-version."q"."0.9.7";
  by-version."q"."0.9.7" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        name = "q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = {
    };
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
    name = "q-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-1.0.1.tgz";
        name = "q-1.0.1.tgz";
        sha1 = "11872aeedee89268110b10a718448ffb10112a14";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  by-spec."q"."~1.0.1" =
    self.by-version."q"."1.0.1";
  by-spec."qs"."0.4.2" =
    self.by-version."qs"."0.4.2";
  by-version."qs"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.4.2.tgz";
        name = "qs-0.4.2.tgz";
        sha1 = "3cac4c861e371a8c9c4770ac23cda8de639b8e5f";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.4.x" =
    self.by-version."qs"."0.4.2";
  by-spec."qs"."0.5.1" =
    self.by-version."qs"."0.5.1";
  by-version."qs"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.1.tgz";
        name = "qs-0.5.1.tgz";
        sha1 = "9f6bf5d9ac6c76384e95d36d15b48980e5e4add0";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.5.2" =
    self.by-version."qs"."0.5.2";
  by-version."qs"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.2.tgz";
        name = "qs-0.5.2.tgz";
        sha1 = "e5734acb7009fb918e800fd5c60c2f5b94a7ff43";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.5.5" =
    self.by-version."qs"."0.5.5";
  by-version."qs"."0.5.5" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.5.tgz";
        name = "qs-0.5.5.tgz";
        sha1 = "b07f0d7ffe3efc6fc2fcde6c66a20775641423f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.6.5" =
    self.by-version."qs"."0.6.5";
  by-version."qs"."0.6.5" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.6.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.5.tgz";
        name = "qs-0.6.5.tgz";
        sha1 = "294b268e4b0d4250f6dde19b3b8b34935dff14ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."0.6.6" =
    self.by-version."qs"."0.6.6";
  by-version."qs"."0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.6.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
        name = "qs-0.6.6.tgz";
        sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."1.2.0" =
    self.by-version."qs"."1.2.0";
  by-version."qs"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "qs-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-1.2.0.tgz";
        name = "qs-1.2.0.tgz";
        sha1 = "ed079be28682147e6fd9a34cc2b0c1e0ec6453ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."2.2.2" =
    self.by-version."qs"."2.2.2";
  by-version."qs"."2.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-2.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.2.2.tgz";
        name = "qs-2.2.2.tgz";
        sha1 = "dfe783f1854b1ac2b3ade92775ad03e27e03218c";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."2.2.4" =
    self.by-version."qs"."2.2.4";
  by-version."qs"."2.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "qs-2.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.2.4.tgz";
        name = "qs-2.2.4.tgz";
        sha1 = "2e9fbcd34b540e3421c924ecd01e90aa975319c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs".">= 0.4.0" =
    self.by-version."qs"."2.2.4";
  by-spec."qs"."~0.5.4" =
    self.by-version."qs"."0.5.6";
  by-version."qs"."0.5.6" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
        name = "qs-0.5.6.tgz";
        sha1 = "31b1ad058567651c526921506b9a8793911a0384";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."~0.6.0" =
    self.by-version."qs"."0.6.6";
  by-spec."qs"."~1.0.0" =
    self.by-version."qs"."1.0.2";
  by-version."qs"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-1.0.2.tgz";
        name = "qs-1.0.2.tgz";
        sha1 = "50a93e2b5af6691c31bcea5dae78ee6ea1903768";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."~1.2.0" =
    self.by-version."qs"."1.2.2";
  by-version."qs"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-1.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-1.2.2.tgz";
        name = "qs-1.2.2.tgz";
        sha1 = "19b57ff24dc2a99ce1f8bdf6afcda59f8ef61f88";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."querystring-es3"."~0.2.0" =
    self.by-version."querystring-es3"."0.2.1";
  by-version."querystring-es3"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "querystring-es3-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.1.tgz";
        name = "querystring-es3-0.2.1.tgz";
        sha1 = "9ec61f79049875707d69414596fd907a4d711e73";
      })
    ];
    buildInputs =
      (self.nativeDeps."querystring-es3" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "querystring-es3" ];
  };
  by-spec."rai"."~0.1.11" =
    self.by-version."rai"."0.1.11";
  by-version."rai"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "rai-0.1.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rai/-/rai-0.1.11.tgz";
        name = "rai-0.1.11.tgz";
        sha1 = "ea0ba30ceecfb77a46d3b2d849e3d4249d056228";
      })
    ];
    buildInputs =
      (self.nativeDeps."rai" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rai" ];
  };
  by-spec."range-parser"."0.0.4" =
    self.by-version."range-parser"."0.0.4";
  by-version."range-parser"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "range-parser-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-0.0.4.tgz";
        name = "range-parser-0.0.4.tgz";
        sha1 = "c0427ffef51c10acba0782a46c9602e744ff620b";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."range-parser"."1.0.0" =
    self.by-version."range-parser"."1.0.0";
  by-version."range-parser"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "range-parser-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.0.tgz";
        name = "range-parser-1.0.0.tgz";
        sha1 = "a4b264cfe0be5ce36abe3765ac9c2a248746dbc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."range-parser"."~1.0.0" =
    self.by-version."range-parser"."1.0.2";
  by-version."range-parser"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "range-parser-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.2.tgz";
        name = "range-parser-1.0.2.tgz";
        sha1 = "06a12a42e5131ba8e457cd892044867f2344e549";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.2";
  by-spec."raven"."~0.7.0" =
    self.by-version."raven"."0.7.2";
  by-version."raven"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "raven-0.7.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raven/-/raven-0.7.2.tgz";
        name = "raven-0.7.2.tgz";
        sha1 = "51c1268e5d947e45c53fdb2e0a88b829c24a02a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."raven" or []);
    deps = {
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "lsmod-0.0.3" = self.by-version."lsmod"."0.0.3";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "stack-trace-0.0.7" = self.by-version."stack-trace"."0.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "raven" ];
  };
  by-spec."raw-body"."0.0.3" =
    self.by-version."raw-body"."0.0.3";
  by-version."raw-body"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "raw-body-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-0.0.3.tgz";
        name = "raw-body-0.0.3.tgz";
        sha1 = "0cb3eb22ced1ca607d32dd8fd94a6eb383f3eb8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."raw-body"."1.1.2" =
    self.by-version."raw-body"."1.1.2";
  by-version."raw-body"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "raw-body-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.1.2.tgz";
        name = "raw-body-1.1.2.tgz";
        sha1 = "c74b3004dea5defd1696171106ac740ec31d62be";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = {
      "bytes-0.2.1" = self.by-version."bytes"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."raw-body"."1.3.0" =
    self.by-version."raw-body"."1.3.0";
  by-version."raw-body"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "raw-body-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.3.0.tgz";
        name = "raw-body-1.3.0.tgz";
        sha1 = "978230a156a5548f42eef14de22d0f4f610083d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "iconv-lite-0.4.4" = self.by-version."iconv-lite"."0.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."raw-socket"."*" =
    self.by-version."raw-socket"."1.2.2";
  by-version."raw-socket"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "raw-socket-1.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-socket/-/raw-socket-1.2.2.tgz";
        name = "raw-socket-1.2.2.tgz";
        sha1 = "c9be873878a1ef70497a27e40b6e55b563d8f886";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-socket" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "raw-socket" ];
  };
  by-spec."rbytes"."*" =
    self.by-version."rbytes"."1.1.0";
  by-version."rbytes"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "rbytes-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rbytes/-/rbytes-1.1.0.tgz";
        name = "rbytes-1.1.0.tgz";
        sha1 = "50234097e70c079bcdf5227494311b1038f3d619";
      })
    ];
    buildInputs =
      (self.nativeDeps."rbytes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rbytes" ];
  };
  "rbytes" = self.by-version."rbytes"."1.1.0";
  by-spec."rc"."~0.3.0" =
    self.by-version."rc"."0.3.5";
  by-version."rc"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.3.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.3.5.tgz";
        name = "rc-0.3.5.tgz";
        sha1 = "fce2220593be57aa1296685a7e37ed003dfcc728";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc" or []);
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  by-spec."rc"."~0.5.0" =
    self.by-version."rc"."0.5.1";
  by-version."rc"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.5.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.5.1.tgz";
        name = "rc-0.5.1.tgz";
        sha1 = "b88ef9421a08151352a659e0c3a58c4b82eb7576";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc" or []);
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "strip-json-comments-0.1.3" = self.by-version."strip-json-comments"."0.1.3";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  by-spec."react"."*" =
    self.by-version."react"."0.12.0-rc1";
  by-version."react"."0.12.0-rc1" = lib.makeOverridable self.buildNodePackage {
    name = "react-0.12.0-rc1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/react/-/react-0.12.0-rc1.tgz";
        name = "react-0.12.0-rc1.tgz";
        sha1 = "de56afc07e834fdf2f988a9c1026c25b93a61636";
      })
    ];
    buildInputs =
      (self.nativeDeps."react" or []);
    deps = {
      "envify-3.0.0" = self.by-version."envify"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "react" ];
  };
  "react" = self.by-version."react"."0.12.0-rc1";
  by-spec."read"."1" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        name = "read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read" or []);
    deps = {
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
    };
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
  by-spec."read-installed"."~3.1.2" =
    self.by-version."read-installed"."3.1.3";
  by-version."read-installed"."3.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "read-installed-3.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-installed/-/read-installed-3.1.3.tgz";
        name = "read-installed-3.1.3.tgz";
        sha1 = "c09092a13c2117f22842cad16804f3b059129d11";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-installed" or []);
    deps = {
      "debuglog-1.0.1" = self.by-version."debuglog"."1.0.1";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "readdir-scoped-modules-1.0.0" = self.by-version."readdir-scoped-modules"."1.0.0";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "util-extend-1.0.1" = self.by-version."util-extend"."1.0.1";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
  by-spec."read-package-json"."1" =
    self.by-version."read-package-json"."1.2.7";
  by-version."read-package-json"."1.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "read-package-json-1.2.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.2.7.tgz";
        name = "read-package-json-1.2.7.tgz";
        sha1 = "f0b440c461a218f4dbf48b094e80fc65c5248502";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json" or []);
    deps = {
      "github-url-from-git-1.4.0" = self.by-version."github-url-from-git"."1.4.0";
      "github-url-from-username-repo-1.0.2" = self.by-version."github-url-from-username-repo"."1.0.2";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "normalize-package-data-1.0.3" = self.by-version."normalize-package-data"."1.0.3";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  by-spec."read-package-json"."~1.2.7" =
    self.by-version."read-package-json"."1.2.7";
  by-spec."readable-stream"."*" =
    self.by-version."readable-stream"."1.1.13";
  by-version."readable-stream"."1.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.1.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.13.tgz";
        name = "readable-stream-1.1.13.tgz";
        sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."1.0.27-1" =
    self.by-version."readable-stream"."1.0.27-1";
  by-version."readable-stream"."1.0.27-1" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.27-1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.27-1.tgz";
        name = "readable-stream-1.0.27-1.tgz";
        sha1 = "6b67983c20357cefd07f0165001a16d710d91078";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."1.0.31" =
    self.by-version."readable-stream"."1.0.31";
  by-version."readable-stream"."1.0.31" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.31.tgz";
        name = "readable-stream-1.0.31.tgz";
        sha1 = "8f2502e0bc9e3b0da1b94520aabb4e2603ecafae";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream".">=1.0.33-1 <1.1.0-0" =
    self.by-version."readable-stream"."1.0.33-1";
  by-version."readable-stream"."1.0.33-1" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.33-1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.33-1.tgz";
        name = "readable-stream-1.0.33-1.tgz";
        sha1 = "40d0d91338691291a9117c05d78adb5497c37810";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream".">=1.1.13-1 <1.2.0-0" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.0.27-1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.1.13-1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."~1.0.17" =
    self.by-version."readable-stream"."1.0.33-1";
  by-spec."readable-stream"."~1.0.2" =
    self.by-version."readable-stream"."1.0.33-1";
  by-spec."readable-stream"."~1.0.24" =
    self.by-version."readable-stream"."1.0.33-1";
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.33-1";
  by-spec."readable-stream"."~1.0.26-2" =
    self.by-version."readable-stream"."1.0.33-1";
  by-spec."readable-stream"."~1.0.32" =
    self.by-version."readable-stream"."1.0.33-1";
  by-spec."readable-stream"."~1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."~1.1.8" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-wrap"."^1.0.0" =
    self.by-version."readable-wrap"."1.0.0";
  by-version."readable-wrap"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "readable-wrap-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-wrap/-/readable-wrap-1.0.0.tgz";
        name = "readable-wrap-1.0.0.tgz";
        sha1 = "3b5a211c631e12303a54991c806c17e7ae206bff";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-wrap" or []);
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-wrap" ];
  };
  by-spec."readdir-scoped-modules"."^1.0.0" =
    self.by-version."readdir-scoped-modules"."1.0.0";
  by-version."readdir-scoped-modules"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "readdir-scoped-modules-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readdir-scoped-modules/-/readdir-scoped-modules-1.0.0.tgz";
        name = "readdir-scoped-modules-1.0.0.tgz";
        sha1 = "e939de969b38b3e7dfaa14fbcfe7a2fd15a4ea37";
      })
    ];
    buildInputs =
      (self.nativeDeps."readdir-scoped-modules" or []);
    deps = {
      "debuglog-1.0.1" = self.by-version."debuglog"."1.0.1";
      "dezalgo-1.0.1" = self.by-version."dezalgo"."1.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readdir-scoped-modules" ];
  };
  by-spec."readdirp"."~0.2.3" =
    self.by-version."readdirp"."0.2.5";
  by-version."readdirp"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "readdirp-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readdirp/-/readdirp-0.2.5.tgz";
        name = "readdirp-0.2.5.tgz";
        sha1 = "c4c276e52977ae25db5191fe51d008550f15d9bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."readdirp" or []);
    deps = {
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readdirp" ];
  };
  by-spec."readdirp"."~1.1.0" =
    self.by-version."readdirp"."1.1.0";
  by-version."readdirp"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "readdirp-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readdirp/-/readdirp-1.1.0.tgz";
        name = "readdirp-1.1.0.tgz";
        sha1 = "6506f9d5d8bb2edc19c855a60bb92feca5fae39c";
      })
    ];
    buildInputs =
      (self.nativeDeps."readdirp" or []);
    deps = {
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readdirp" ];
  };
  by-spec."readline2"."~0.1.0" =
    self.by-version."readline2"."0.1.0";
  by-version."readline2"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "readline2-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readline2/-/readline2-0.1.0.tgz";
        name = "readline2-0.1.0.tgz";
        sha1 = "6a272ef89731225b448e4c6799b6e50d5be12b98";
      })
    ];
    buildInputs =
      (self.nativeDeps."readline2" or []);
    deps = {
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "chalk-0.4.0" = self.by-version."chalk"."0.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readline2" ];
  };
  by-spec."realize-package-specifier"."~1.2.0" =
    self.by-version."realize-package-specifier"."1.2.0";
  by-version."realize-package-specifier"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "realize-package-specifier-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/realize-package-specifier/-/realize-package-specifier-1.2.0.tgz";
        name = "realize-package-specifier-1.2.0.tgz";
        sha1 = "93364e40dee38369f92e9b0c76124500342132f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."realize-package-specifier" or []);
    deps = {
      "dezalgo-1.0.1" = self.by-version."dezalgo"."1.0.1";
      "npm-package-arg-2.1.3" = self.by-version."npm-package-arg"."2.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "realize-package-specifier" ];
  };
  by-spec."redeyed"."~0.4.0" =
    self.by-version."redeyed"."0.4.4";
  by-version."redeyed"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "redeyed-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redeyed/-/redeyed-0.4.4.tgz";
        name = "redeyed-0.4.4.tgz";
        sha1 = "37e990a6f2b21b2a11c2e6a48fd4135698cba97f";
      })
    ];
    buildInputs =
      (self.nativeDeps."redeyed" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "redeyed" ];
  };
  by-spec."redis"."*" =
    self.by-version."redis"."0.12.1";
  by-version."redis"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.12.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.12.1.tgz";
        name = "redis-0.12.1.tgz";
        sha1 = "64df76ad0fc8acebaebd2a0645e8a48fac49185e";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  "redis" = self.by-version."redis"."0.12.1";
  by-spec."redis"."0.10.x" =
    self.by-version."redis"."0.10.3";
  by-version."redis"."0.10.3" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.10.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.10.3.tgz";
        name = "redis-0.10.3.tgz";
        sha1 = "8927fe2110ee39617bcf3fd37b89d8e123911bb6";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  by-spec."redis"."0.7.2" =
    self.by-version."redis"."0.7.2";
  by-version."redis"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.7.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.7.2.tgz";
        name = "redis-0.7.2.tgz";
        sha1 = "fa557fef4985ab3e3384fdc5be6e2541a0bb49af";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = {
      "hiredis-0.1.17" = self.by-version."hiredis"."0.1.17";
    };
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  by-spec."redis"."0.7.3" =
    self.by-version."redis"."0.7.3";
  by-version."redis"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.7.3.tgz";
        name = "redis-0.7.3.tgz";
        sha1 = "ee57b7a44d25ec1594e44365d8165fa7d1d4811a";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  by-spec."redis"."~0.10.0" =
    self.by-version."redis"."0.10.3";
  by-spec."reds"."~0.2.4" =
    self.by-version."reds"."0.2.4";
  by-version."reds"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "reds-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/reds/-/reds-0.2.4.tgz";
        name = "reds-0.2.4.tgz";
        sha1 = "a82dcaaa52319635bc6eee3ef9c1ac074411de3c";
      })
    ];
    buildInputs =
      (self.nativeDeps."reds" or []);
    deps = {
      "natural-0.1.17" = self.by-version."natural"."0.1.17";
      "redis-0.7.2" = self.by-version."redis"."0.7.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "reds" ];
  };
  by-spec."reduce-component"."1.0.1" =
    self.by-version."reduce-component"."1.0.1";
  by-version."reduce-component"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "reduce-component-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/reduce-component/-/reduce-component-1.0.1.tgz";
        name = "reduce-component-1.0.1.tgz";
        sha1 = "e0c93542c574521bea13df0f9488ed82ab77c5da";
      })
    ];
    buildInputs =
      (self.nativeDeps."reduce-component" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "reduce-component" ];
  };
  by-spec."regexp-clone"."0.0.1" =
    self.by-version."regexp-clone"."0.0.1";
  by-version."regexp-clone"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "regexp-clone-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/regexp-clone/-/regexp-clone-0.0.1.tgz";
        name = "regexp-clone-0.0.1.tgz";
        sha1 = "a7c2e09891fdbf38fbb10d376fb73003e68ac589";
      })
    ];
    buildInputs =
      (self.nativeDeps."regexp-clone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "regexp-clone" ];
  };
  by-spec."registry-url"."^0.1.0" =
    self.by-version."registry-url"."0.1.1";
  by-version."registry-url"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "registry-url-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/registry-url/-/registry-url-0.1.1.tgz";
        name = "registry-url-0.1.1.tgz";
        sha1 = "1739427b81b110b302482a1c7cd727ffcc82d5be";
      })
    ];
    buildInputs =
      (self.nativeDeps."registry-url" or []);
    deps = {
      "npmconf-2.1.1" = self.by-version."npmconf"."2.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "registry-url" ];
  };
  by-spec."replace"."~0.2.4" =
    self.by-version."replace"."0.2.10";
  by-version."replace"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "replace-0.2.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/replace/-/replace-0.2.10.tgz";
        name = "replace-0.2.10.tgz";
        sha1 = "1123397e995b3bfef9985fc63cddcf79a014fd64";
      })
    ];
    buildInputs =
      (self.nativeDeps."replace" or []);
    deps = {
      "nomnom-1.6.2" = self.by-version."nomnom"."1.6.2";
      "colors-0.5.1" = self.by-version."colors"."0.5.1";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
    };
    peerDependencies = [
    ];
    passthru.names = [ "replace" ];
  };
  by-spec."request"."2" =
    self.by-version."request"."2.45.0";
  by-version."request"."2.45.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.45.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.45.0.tgz";
        name = "request-2.45.0.tgz";
        sha1 = "29d713a0a07f17fb2e7b61815d2010681718e93c";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "caseless-0.6.0" = self.by-version."caseless"."0.6.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "qs-1.2.2" = self.by-version."qs"."1.2.2";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.4.0" = self.by-version."oauth-sign"."0.4.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2 >=2.20.0" =
    self.by-version."request"."2.45.0";
  by-spec."request"."2 >=2.25.0" =
    self.by-version."request"."2.45.0";
  by-spec."request"."2.16.x" =
    self.by-version."request"."2.16.6";
  by-version."request"."2.16.6" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.16.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.6.tgz";
        name = "request-2.16.6.tgz";
        sha1 = "872fe445ae72de266b37879d6ad7dc948fa01cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "form-data-0.0.10" = self.by-version."form-data"."0.0.10";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "hawk-0.10.2" = self.by-version."hawk"."0.10.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "cookie-jar-0.2.0" = self.by-version."cookie-jar"."0.2.0";
      "aws-sign-0.2.0" = self.by-version."aws-sign"."0.2.0";
      "oauth-sign-0.2.0" = self.by-version."oauth-sign"."0.2.0";
      "forever-agent-0.2.0" = self.by-version."forever-agent"."0.2.0";
      "tunnel-agent-0.2.0" = self.by-version."tunnel-agent"."0.2.0";
      "json-stringify-safe-3.0.0" = self.by-version."json-stringify-safe"."3.0.0";
      "qs-0.5.6" = self.by-version."qs"."0.5.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2.40.0" =
    self.by-version."request"."2.40.0";
  by-version."request"."2.40.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.40.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.40.0.tgz";
        name = "request-2.40.0.tgz";
        sha1 = "4dd670f696f1e6e842e66b4b5e839301ab9beb67";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "qs-1.0.2" = self.by-version."qs"."1.0.2";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2.42.0" =
    self.by-version."request"."2.42.0";
  by-version."request"."2.42.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.42.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.42.0.tgz";
        name = "request-2.42.0.tgz";
        sha1 = "572bd0148938564040ac7ab148b96423a063304a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "caseless-0.6.0" = self.by-version."caseless"."0.6.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "qs-1.2.2" = self.by-version."qs"."1.2.2";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.4.0" = self.by-version."oauth-sign"."0.4.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2.9.x" =
    self.by-version."request"."2.9.203";
  by-version."request"."2.9.203" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.9.203";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.9.203.tgz";
        name = "request-2.9.203.tgz";
        sha1 = "6c1711a5407fb94a114219563e44145bcbf4723a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."^2.36.0" =
    self.by-version."request"."2.45.0";
  by-spec."request"."^2.40.0" =
    self.by-version."request"."2.45.0";
  by-spec."request"."~2" =
    self.by-version."request"."2.45.0";
  by-spec."request"."~2.27.0" =
    self.by-version."request"."2.27.0";
  by-version."request"."2.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        name = "request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "tunnel-agent-0.3.0" = self.by-version."tunnel-agent"."0.3.0";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "hawk-1.0.0" = self.by-version."hawk"."1.0.0";
      "aws-sign-0.3.0" = self.by-version."aws-sign"."0.3.0";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "cookie-jar-0.3.0" = self.by-version."cookie-jar"."0.3.0";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.40.0" =
    self.by-version."request"."2.40.0";
  by-spec."request"."~2.42.0" =
    self.by-version."request"."2.42.0";
  by-spec."request"."~2.45.0" =
    self.by-version."request"."2.45.0";
  by-spec."request-progress"."0.3.0" =
    self.by-version."request-progress"."0.3.0";
  by-version."request-progress"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-progress-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-progress/-/request-progress-0.3.0.tgz";
        name = "request-progress-0.3.0.tgz";
        sha1 = "bdf2062bfc197c5d492500d44cb3aff7865b492e";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-progress" or []);
    deps = {
      "throttleit-0.0.2" = self.by-version."throttleit"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request-progress" ];
  };
  by-spec."request-progress"."0.3.1" =
    self.by-version."request-progress"."0.3.1";
  by-version."request-progress"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "request-progress-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-progress/-/request-progress-0.3.1.tgz";
        name = "request-progress-0.3.1.tgz";
        sha1 = "0721c105d8a96ac6b2ce8b2c89ae2d5ecfcf6b3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-progress" or []);
    deps = {
      "throttleit-0.0.2" = self.by-version."throttleit"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request-progress" ];
  };
  by-spec."request-replay"."~0.2.0" =
    self.by-version."request-replay"."0.2.0";
  by-version."request-replay"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-replay-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-replay/-/request-replay-0.2.0.tgz";
        name = "request-replay-0.2.0.tgz";
        sha1 = "9b693a5d118b39f5c596ead5ed91a26444057f60";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-replay" or []);
    deps = {
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request-replay" ];
  };
  by-spec."requirejs"."~2.1" =
    self.by-version."requirejs"."2.1.15";
  by-version."requirejs"."2.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "requirejs-2.1.15";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/requirejs/-/requirejs-2.1.15.tgz";
        name = "requirejs-2.1.15.tgz";
        sha1 = "cbcfce55d584ae5983c00a20daa8eade37d18892";
      })
    ];
    buildInputs =
      (self.nativeDeps."requirejs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "requirejs" ];
  };
  by-spec."requirejs"."~2.1.0" =
    self.by-version."requirejs"."2.1.15";
  by-spec."resolve"."0.7.4" =
    self.by-version."resolve"."0.7.4";
  by-version."resolve"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.7.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.7.4.tgz";
        name = "resolve-0.7.4.tgz";
        sha1 = "395a9ef9e873fbfe12bd14408bd91bb936003d69";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."resolve"."0.7.x" =
    self.by-version."resolve"."0.7.4";
  by-spec."resolve"."~0.3.0" =
    self.by-version."resolve"."0.3.1";
  by-version."resolve"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.3.1.tgz";
        name = "resolve-0.3.1.tgz";
        sha1 = "34c63447c664c70598d1c9b126fc43b2a24310a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."resolve"."~0.3.1" =
    self.by-version."resolve"."0.3.1";
  by-spec."resolve"."~0.7.1" =
    self.by-version."resolve"."0.7.4";
  by-spec."resolve"."~0.7.2" =
    self.by-version."resolve"."0.7.4";
  by-spec."resolve"."~1.0.0" =
    self.by-version."resolve"."1.0.0";
  by-version."resolve"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-1.0.0.tgz";
        name = "resolve-1.0.0.tgz";
        sha1 = "2a6e3b314dcd57c6519e8e2282af8687e8de61c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."response-time"."~2.2.0" =
    self.by-version."response-time"."2.2.0";
  by-version."response-time"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "response-time-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/response-time/-/response-time-2.2.0.tgz";
        name = "response-time-2.2.0.tgz";
        sha1 = "77ab4688cbf030e9c5f82dc1eac7fe5226d3c8eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."response-time" or []);
    deps = {
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "response-time" ];
  };
  by-spec."restify"."2.4.1" =
    self.by-version."restify"."2.4.1";
  by-version."restify"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "restify-2.4.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/restify/-/restify-2.4.1.tgz";
        name = "restify-2.4.1.tgz";
        sha1 = "35790a052bd0927e7f6a06cc3d079e56fabc9371";
      })
    ];
    buildInputs =
      (self.nativeDeps."restify" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
      "backoff-2.1.0" = self.by-version."backoff"."2.1.0";
      "bunyan-0.21.1" = self.by-version."bunyan"."0.21.1";
      "deep-equal-0.0.0" = self.by-version."deep-equal"."0.0.0";
      "formidable-1.0.13" = self.by-version."formidable"."1.0.13";
      "http-signature-0.9.11" = self.by-version."http-signature"."0.9.11";
      "keep-alive-agent-0.0.1" = self.by-version."keep-alive-agent"."0.0.1";
      "lru-cache-2.3.0" = self.by-version."lru-cache"."2.3.0";
      "mime-1.2.9" = self.by-version."mime"."1.2.9";
      "negotiator-0.2.5" = self.by-version."negotiator"."0.2.5";
      "node-uuid-1.4.0" = self.by-version."node-uuid"."1.4.0";
      "once-1.1.1" = self.by-version."once"."1.1.1";
      "qs-0.5.5" = self.by-version."qs"."0.5.5";
      "semver-1.1.4" = self.by-version."semver"."1.1.4";
      "spdy-1.7.1" = self.by-version."spdy"."1.7.1";
      "verror-1.3.6" = self.by-version."verror"."1.3.6";
      "dtrace-provider-0.2.8" = self.by-version."dtrace-provider"."0.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "restify" ];
  };
  by-spec."rethinkdb"."*" =
    self.by-version."rethinkdb"."1.15.0-0";
  by-version."rethinkdb"."1.15.0-0" = lib.makeOverridable self.buildNodePackage {
    name = "rethinkdb-1.15.0-0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rethinkdb/-/rethinkdb-1.15.0-0.tgz";
        name = "rethinkdb-1.15.0-0.tgz";
        sha1 = "7b2efb0d3f51a66ab661dfdf43905de77dfb5a94";
      })
    ];
    buildInputs =
      (self.nativeDeps."rethinkdb" or []);
    deps = {
      "bluebird-2.3.6" = self.by-version."bluebird"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rethinkdb" ];
  };
  "rethinkdb" = self.by-version."rethinkdb"."1.15.0-0";
  by-spec."retry"."0.6.0" =
    self.by-version."retry"."0.6.0";
  by-version."retry"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "retry-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/retry/-/retry-0.6.0.tgz";
        name = "retry-0.6.0.tgz";
        sha1 = "1c010713279a6fd1e8def28af0c3ff1871caa537";
      })
    ];
    buildInputs =
      (self.nativeDeps."retry" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "retry" ];
  };
  by-spec."retry"."^0.6.1" =
    self.by-version."retry"."0.6.1";
  by-version."retry"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "retry-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/retry/-/retry-0.6.1.tgz";
        name = "retry-0.6.1.tgz";
        sha1 = "fdc90eed943fde11b893554b8cc63d0e899ba918";
      })
    ];
    buildInputs =
      (self.nativeDeps."retry" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "retry" ];
  };
  by-spec."retry"."~0.6.0" =
    self.by-version."retry"."0.6.1";
  by-spec."retry"."~0.6.1" =
    self.by-version."retry"."0.6.1";
  by-spec."revalidator"."0.1.x" =
    self.by-version."revalidator"."0.1.8";
  by-version."revalidator"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "revalidator-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/revalidator/-/revalidator-0.1.8.tgz";
        name = "revalidator-0.1.8.tgz";
        sha1 = "fece61bfa0c1b52a206bd6b18198184bdd523a3b";
      })
    ];
    buildInputs =
      (self.nativeDeps."revalidator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "revalidator" ];
  };
  by-spec."rfile"."~1.0" =
    self.by-version."rfile"."1.0.0";
  by-version."rfile"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "rfile-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rfile/-/rfile-1.0.0.tgz";
        name = "rfile-1.0.0.tgz";
        sha1 = "59708cf90ca1e74c54c3cfc5c36fdb9810435261";
      })
    ];
    buildInputs =
      (self.nativeDeps."rfile" or []);
    deps = {
      "callsite-1.0.0" = self.by-version."callsite"."1.0.0";
      "resolve-0.3.1" = self.by-version."resolve"."0.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rfile" ];
  };
  by-spec."rfile"."~1.0.0" =
    self.by-version."rfile"."1.0.0";
  by-spec."rimraf"."1.x.x" =
    self.by-version."rimraf"."1.0.9";
  by-version."rimraf"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-1.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-1.0.9.tgz";
        name = "rimraf-1.0.9.tgz";
        sha1 = "be4801ff76c2ba6f1c50c78e9700eb1d21f239f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."2" =
    self.by-version."rimraf"."2.2.8";
  by-version."rimraf"."2.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.8";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        name = "rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."2.2.6" =
    self.by-version."rimraf"."2.2.6";
  by-version."rimraf"."2.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.6.tgz";
        name = "rimraf-2.2.6.tgz";
        sha1 = "c59597569b14d956ad29cacc42bdddf5f0ea4f4c";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."2.x.x" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2.1.4" =
    self.by-version."rimraf"."2.1.4";
  by-version."rimraf"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.1.4.tgz";
        name = "rimraf-2.1.4.tgz";
        sha1 = "5a6eb62eeda068f51ede50f29b3e5cd22f3d9bb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."~2.2.0" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2.2.5" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2.2.6" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2.2.8" =
    self.by-version."rimraf"."2.2.8";
  by-spec."ripemd160"."0.2.0" =
    self.by-version."ripemd160"."0.2.0";
  by-version."ripemd160"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "ripemd160-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ripemd160/-/ripemd160-0.2.0.tgz";
        name = "ripemd160-0.2.0.tgz";
        sha1 = "2bf198bde167cacfa51c0a928e84b68bbe171fce";
      })
    ];
    buildInputs =
      (self.nativeDeps."ripemd160" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ripemd160" ];
  };
  by-spec."rndm"."~1.0.0" =
    self.by-version."rndm"."1.0.0";
  by-version."rndm"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "rndm-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rndm/-/rndm-1.0.0.tgz";
        name = "rndm-1.0.0.tgz";
        sha1 = "dcb6eb485b9b416d15e097f39c31458e4cfda2da";
      })
    ];
    buildInputs =
      (self.nativeDeps."rndm" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rndm" ];
  };
  by-spec."ruglify"."~1.0.0" =
    self.by-version."ruglify"."1.0.0";
  by-version."ruglify"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "ruglify-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ruglify/-/ruglify-1.0.0.tgz";
        name = "ruglify-1.0.0.tgz";
        sha1 = "dc8930e2a9544a274301cc9972574c0d0986b675";
      })
    ];
    buildInputs =
      (self.nativeDeps."ruglify" or []);
    deps = {
      "rfile-1.0.0" = self.by-version."rfile"."1.0.0";
      "uglify-js-2.2.5" = self.by-version."uglify-js"."2.2.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ruglify" ];
  };
  by-spec."rx"."^2.2.27" =
    self.by-version."rx"."2.3.13";
  by-version."rx"."2.3.13" = lib.makeOverridable self.buildNodePackage {
    name = "rx-2.3.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rx/-/rx-2.3.13.tgz";
        name = "rx-2.3.13.tgz";
        sha1 = "8a42c6079e4bf7a712c17780ed17c408633a6cbc";
      })
    ];
    buildInputs =
      (self.nativeDeps."rx" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rx" ];
  };
  by-spec."s3http"."*" =
    self.by-version."s3http"."0.0.5";
  by-version."s3http"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "s3http-0.0.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/s3http/-/s3http-0.0.5.tgz";
        name = "s3http-0.0.5.tgz";
        sha1 = "c8fa1fffb8258ce68adf75df73f90fbb6f23d198";
      })
    ];
    buildInputs =
      (self.nativeDeps."s3http" or []);
    deps = {
      "aws-sdk-1.18.0" = self.by-version."aws-sdk"."1.18.0";
      "commander-2.0.0" = self.by-version."commander"."2.0.0";
      "http-auth-2.0.7" = self.by-version."http-auth"."2.0.7";
      "express-3.4.4" = self.by-version."express"."3.4.4";
      "everyauth-0.4.5" = self.by-version."everyauth"."0.4.5";
      "string-1.6.1" = self.by-version."string"."1.6.1";
      "util-0.4.9" = self.by-version."util"."0.4.9";
      "crypto-0.0.3" = self.by-version."crypto"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "s3http" ];
  };
  "s3http" = self.by-version."s3http"."0.0.5";
  by-spec."samsam"."~1.1" =
    self.by-version."samsam"."1.1.1";
  by-version."samsam"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "samsam-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/samsam/-/samsam-1.1.1.tgz";
        name = "samsam-1.1.1.tgz";
        sha1 = "48d64ee2a7aecaaeccebe2f0a68a49687d3a49b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."samsam" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "samsam" ];
  };
  by-spec."sauce-connect-launcher"."~0.6.0" =
    self.by-version."sauce-connect-launcher"."0.6.1";
  by-version."sauce-connect-launcher"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "sauce-connect-launcher-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sauce-connect-launcher/-/sauce-connect-launcher-0.6.1.tgz";
        name = "sauce-connect-launcher-0.6.1.tgz";
        sha1 = "a770184d8d9860cbb1e76c344af28cdf5d0e247a";
      })
    ];
    buildInputs =
      (self.nativeDeps."sauce-connect-launcher" or []);
    deps = {
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "adm-zip-0.4.4" = self.by-version."adm-zip"."0.4.4";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sauce-connect-launcher" ];
  };
  by-spec."saucelabs"."~0.1.0" =
    self.by-version."saucelabs"."0.1.1";
  by-version."saucelabs"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "saucelabs-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/saucelabs/-/saucelabs-0.1.1.tgz";
        name = "saucelabs-0.1.1.tgz";
        sha1 = "5e0ea1cf3d735d6ea15fde94b5bda6bc15d2c06d";
      })
    ];
    buildInputs =
      (self.nativeDeps."saucelabs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "saucelabs" ];
  };
  by-spec."sax"."0.4.2" =
    self.by-version."sax"."0.4.2";
  by-version."sax"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.4.2.tgz";
        name = "sax-0.4.2.tgz";
        sha1 = "39f3b601733d6bec97105b242a2a40fd6978ac3c";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  by-spec."sax"."0.5.x" =
    self.by-version."sax"."0.5.8";
  by-version."sax"."0.5.8" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.5.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.5.8.tgz";
        name = "sax-0.5.8.tgz";
        sha1 = "d472db228eb331c2506b0e8c15524adb939d12c1";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  by-spec."sax"."0.6.x" =
    self.by-version."sax"."0.6.1";
  by-version."sax"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.6.1.tgz";
        name = "sax-0.6.1.tgz";
        sha1 = "563b19c7c1de892e09bfc4f2fc30e3c27f0952b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  by-spec."sax".">=0.4.2" =
    self.by-version."sax"."0.6.1";
  by-spec."scmp"."0.0.3" =
    self.by-version."scmp"."0.0.3";
  by-version."scmp"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "scmp-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/scmp/-/scmp-0.0.3.tgz";
        name = "scmp-0.0.3.tgz";
        sha1 = "3648df2d7294641e7f78673ffc29681d9bad9073";
      })
    ];
    buildInputs =
      (self.nativeDeps."scmp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "scmp" ];
  };
  by-spec."selenium-webdriver"."*" =
    self.by-version."selenium-webdriver"."2.43.5";
  by-version."selenium-webdriver"."2.43.5" = lib.makeOverridable self.buildNodePackage {
    name = "selenium-webdriver-2.43.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/selenium-webdriver/-/selenium-webdriver-2.43.5.tgz";
        name = "selenium-webdriver-2.43.5.tgz";
        sha1 = "6ac04302e3e81dfe59956454a19f90eeadfe5573";
      })
    ];
    buildInputs =
      (self.nativeDeps."selenium-webdriver" or []);
    deps = {
      "adm-zip-0.4.4" = self.by-version."adm-zip"."0.4.4";
      "tmp-0.0.24" = self.by-version."tmp"."0.0.24";
      "xml2js-0.4.4" = self.by-version."xml2js"."0.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "selenium-webdriver" ];
  };
  "selenium-webdriver" = self.by-version."selenium-webdriver"."2.43.5";
  by-spec."semver"."*" =
    self.by-version."semver"."4.1.0";
  by-version."semver"."4.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-4.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-4.1.0.tgz";
        name = "semver-4.1.0.tgz";
        sha1 = "bc80a9ff68532814362cc3cfda3c7b75ed9c321c";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  "semver" = self.by-version."semver"."4.1.0";
  by-spec."semver"."1.1.0" =
    self.by-version."semver"."1.1.0";
  by-version."semver"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.0.tgz";
        name = "semver-1.1.0.tgz";
        sha1 = "da9b9c837e31550a7c928622bc2381de7dd7a53e";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."1.1.4" =
    self.by-version."semver"."1.1.4";
  by-version."semver"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.4.tgz";
        name = "semver-1.1.4.tgz";
        sha1 = "2e5a4e72bab03472cc97f72753b4508912ef5540";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."2" =
    self.by-version."semver"."2.3.2";
  by-version."semver"."2.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.3.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.3.2.tgz";
        name = "semver-2.3.2.tgz";
        sha1 = "b9848f25d6cf36333073ec9ef8856d42f1233e52";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."2 >=2.2.1 || 3.x || 4" =
    self.by-version."semver"."4.1.0";
  by-spec."semver"."2 || 3 || 4" =
    self.by-version."semver"."4.1.0";
  by-spec."semver"."2.x" =
    self.by-version."semver"."2.3.2";
  by-spec."semver"."2.x || 3.x || 4" =
    self.by-version."semver"."4.1.0";
  by-spec."semver"."4" =
    self.by-version."semver"."4.1.0";
  by-spec."semver".">=2.0.10 <3.0.0" =
    self.by-version."semver"."2.3.2";
  by-spec."semver".">=2.2.1 <3" =
    self.by-version."semver"."2.3.2";
  by-spec."semver"."^2.2.1" =
    self.by-version."semver"."2.3.2";
  by-spec."semver"."^2.3.0" =
    self.by-version."semver"."2.3.2";
  by-spec."semver"."^2.3.0 || 3.x || 4" =
    self.by-version."semver"."4.1.0";
  by-spec."semver"."^3.0.1" =
    self.by-version."semver"."3.0.1";
  by-version."semver"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "semver-3.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-3.0.1.tgz";
        name = "semver-3.0.1.tgz";
        sha1 = "720ac012515a252f91fb0dd2e99a56a70d6cf078";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~1.1.4" =
    self.by-version."semver"."1.1.4";
  by-spec."semver"."~2.0.5" =
    self.by-version."semver"."2.0.11";
  by-version."semver"."2.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.0.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.0.11.tgz";
        name = "semver-2.0.11.tgz";
        sha1 = "f51f07d03fa5af79beb537fc067a7e141786cced";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~2.1.0" =
    self.by-version."semver"."2.1.0";
  by-version."semver"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        name = "semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~2.2.1" =
    self.by-version."semver"."2.2.1";
  by-version."semver"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.2.1.tgz";
        name = "semver-2.2.1.tgz";
        sha1 = "7941182b3ffcc580bff1c17942acdf7951c0d213";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~2.3.0" =
    self.by-version."semver"."2.3.2";
  by-spec."semver"."~3.0.1" =
    self.by-version."semver"."3.0.1";
  by-spec."semver"."~4.1.0" =
    self.by-version."semver"."4.1.0";
  by-spec."semver-diff"."^0.1.0" =
    self.by-version."semver-diff"."0.1.0";
  by-version."semver-diff"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-diff-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver-diff/-/semver-diff-0.1.0.tgz";
        name = "semver-diff-0.1.0.tgz";
        sha1 = "4f6057ca3eba23cc484b51f64aaf88b131a3855d";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver-diff" or []);
    deps = {
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver-diff" ];
  };
  by-spec."send"."*" =
    self.by-version."send"."0.10.0";
  by-version."send"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.10.0.tgz";
        name = "send-0.10.0.tgz";
        sha1 = "2f984b703934c628b72b72d70557b75ca906ea6c";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.0" = self.by-version."etag"."1.5.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.0.3" =
    self.by-version."send"."0.0.3";
  by-version."send"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.0.3.tgz";
        name = "send-0.0.3.tgz";
        sha1 = "4d5f843edf9d65dac31c8a5d2672c179ecb67184";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "mime-1.2.6" = self.by-version."mime"."1.2.6";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.1.0" =
    self.by-version."send"."0.1.0";
  by-version."send"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.0.tgz";
        name = "send-0.1.0.tgz";
        sha1 = "cfb08ebd3cec9b7fc1a37d9ff9e875a971cf4640";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "mime-1.2.6" = self.by-version."mime"."1.2.6";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.1.4" =
    self.by-version."send"."0.1.4";
  by-version."send"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.4.tgz";
        name = "send-0.1.4.tgz";
        sha1 = "be70d8d1be01de61821af13780b50345a4f71abd";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "fresh-0.2.0" = self.by-version."fresh"."0.2.0";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.10.0" =
    self.by-version."send"."0.10.0";
  by-spec."send"."0.2.0" =
    self.by-version."send"."0.2.0";
  by-version."send"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.2.0.tgz";
        name = "send-0.2.0.tgz";
        sha1 = "067abf45cff8bffb29cbdb7439725b32388a2c58";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.8.5" =
    self.by-version."send"."0.8.5";
  by-version."send"."0.8.5" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.8.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.8.5.tgz";
        name = "send-0.8.5.tgz";
        sha1 = "37f708216e6f50c175e74c69fec53484e2fd82c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "depd-0.4.4" = self.by-version."depd"."0.4.4";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "fresh-0.2.2" = self.by-version."fresh"."0.2.2";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."send"."0.9.3" =
    self.by-version."send"."0.9.3";
  by-version."send"."0.9.3" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.9.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.9.3.tgz";
        name = "send-0.9.3.tgz";
        sha1 = "b43a7414cd089b7fbec9b755246f7c37b7b85cc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "depd-0.4.5" = self.by-version."depd"."0.4.5";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.4.0" = self.by-version."etag"."1.4.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."sequence"."2.2.1" =
    self.by-version."sequence"."2.2.1";
  by-version."sequence"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "sequence-2.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
        name = "sequence-2.2.1.tgz";
        sha1 = "7f5617895d44351c0a047e764467690490a16b03";
      })
    ];
    buildInputs =
      (self.nativeDeps."sequence" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sequence" ];
  };
  by-spec."sequence"."2.x" =
    self.by-version."sequence"."2.2.1";
  by-spec."sequencify"."~0.0.7" =
    self.by-version."sequencify"."0.0.7";
  by-version."sequencify"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "sequencify-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sequencify/-/sequencify-0.0.7.tgz";
        name = "sequencify-0.0.7.tgz";
        sha1 = "90cff19d02e07027fd767f5ead3e7b95d1e7380c";
      })
    ];
    buildInputs =
      (self.nativeDeps."sequencify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sequencify" ];
  };
  by-spec."serve-favicon"."~2.1.6" =
    self.by-version."serve-favicon"."2.1.6";
  by-version."serve-favicon"."2.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "serve-favicon-2.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-favicon/-/serve-favicon-2.1.6.tgz";
        name = "serve-favicon-2.1.6.tgz";
        sha1 = "46326a9eb64a0fa5cf012a4f85efe9fda95820e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-favicon" or []);
    deps = {
      "etag-1.5.0" = self.by-version."etag"."1.5.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-favicon" ];
  };
  by-spec."serve-index"."~1.5.0" =
    self.by-version."serve-index"."1.5.0";
  by-version."serve-index"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "serve-index-1.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-index/-/serve-index-1.5.0.tgz";
        name = "serve-index-1.5.0.tgz";
        sha1 = "066a35ff1564146cceb2105014a5b070af68707e";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-index" or []);
    deps = {
      "accepts-1.1.2" = self.by-version."accepts"."1.1.2";
      "batch-0.5.1" = self.by-version."batch"."0.5.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
      "mime-types-2.0.2" = self.by-version."mime-types"."2.0.2";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-index" ];
  };
  by-spec."serve-static"."1.0.1" =
    self.by-version."serve-static"."1.0.1";
  by-version."serve-static"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.0.1.tgz";
        name = "serve-static-1.0.1.tgz";
        sha1 = "10dcbfd44b3e0291a131fc9ab4ab25a9f5a78a42";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "send-0.1.4" = self.by-version."send"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."serve-static"."~1.5.3" =
    self.by-version."serve-static"."1.5.4";
  by-version."serve-static"."1.5.4" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.5.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.5.4.tgz";
        name = "serve-static-1.5.4.tgz";
        sha1 = "819fb37ae46bd02dd520b77fcf7fd8f5112f9782";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.8.5" = self.by-version."send"."0.8.5";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."serve-static"."~1.5.4" =
    self.by-version."serve-static"."1.5.4";
  by-spec."serve-static"."~1.6.4" =
    self.by-version."serve-static"."1.6.4";
  by-version."serve-static"."1.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.6.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.6.4.tgz";
        name = "serve-static-1.6.4.tgz";
        sha1 = "c512e4188d7a9366672db24e40d294f0c6212367";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.9.3" = self.by-version."send"."0.9.3";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."serve-static"."~1.7.0" =
    self.by-version."serve-static"."1.7.0";
  by-version."serve-static"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.7.0.tgz";
        name = "serve-static-1.7.0.tgz";
        sha1 = "af2ad4e619fa2d46dcd19dd59e3b034c92510e4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.10.0" = self.by-version."send"."0.10.0";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."sha"."~1.3.0" =
    self.by-version."sha"."1.3.0";
  by-version."sha"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "sha-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha/-/sha-1.3.0.tgz";
        name = "sha-1.3.0.tgz";
        sha1 = "79f4787045d0ede7327d702c25c443460dbc6764";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
  };
  by-spec."sha.js"."2.2.6" =
    self.by-version."sha.js"."2.2.6";
  by-version."sha.js"."2.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "sha.js-2.2.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha.js/-/sha.js-2.2.6.tgz";
        name = "sha.js-2.2.6.tgz";
        sha1 = "17ddeddc5f722fb66501658895461977867315ba";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sha.js" ];
  };
  by-spec."shallow-copy"."0.0.1" =
    self.by-version."shallow-copy"."0.0.1";
  by-version."shallow-copy"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "shallow-copy-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shallow-copy/-/shallow-copy-0.0.1.tgz";
        name = "shallow-copy-0.0.1.tgz";
        sha1 = "415f42702d73d810330292cc5ee86eae1a11a170";
      })
    ];
    buildInputs =
      (self.nativeDeps."shallow-copy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "shallow-copy" ];
  };
  by-spec."shasum"."^1.0.0" =
    self.by-version."shasum"."1.0.0";
  by-version."shasum"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "shasum-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shasum/-/shasum-1.0.0.tgz";
        name = "shasum-1.0.0.tgz";
        sha1 = "26e3f2cef88577da2d976c7c160a5f297eb2ea36";
      })
    ];
    buildInputs =
      (self.nativeDeps."shasum" or []);
    deps = {
      "json-stable-stringify-0.0.1" = self.by-version."json-stable-stringify"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "shasum" ];
  };
  by-spec."shell-quote"."~0.0.1" =
    self.by-version."shell-quote"."0.0.1";
  by-version."shell-quote"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "shell-quote-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shell-quote/-/shell-quote-0.0.1.tgz";
        name = "shell-quote-0.0.1.tgz";
        sha1 = "1a41196f3c0333c482323593d6886ecf153dd986";
      })
    ];
    buildInputs =
      (self.nativeDeps."shell-quote" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "shell-quote" ];
  };
  by-spec."shell-quote"."~1.4.1" =
    self.by-version."shell-quote"."1.4.2";
  by-version."shell-quote"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "shell-quote-1.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shell-quote/-/shell-quote-1.4.2.tgz";
        name = "shell-quote-1.4.2.tgz";
        sha1 = "f132a54f2030d69280d370d4974155f85f62f67b";
      })
    ];
    buildInputs =
      (self.nativeDeps."shell-quote" or []);
    deps = {
      "jsonify-0.0.0" = self.by-version."jsonify"."0.0.0";
      "array-filter-0.0.1" = self.by-version."array-filter"."0.0.1";
      "array-reduce-0.0.0" = self.by-version."array-reduce"."0.0.0";
      "array-map-0.0.0" = self.by-version."array-map"."0.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "shell-quote" ];
  };
  by-spec."shelljs"."*" =
    self.by-version."shelljs"."0.3.0";
  by-version."shelljs"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "shelljs-0.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shelljs/-/shelljs-0.3.0.tgz";
        name = "shelljs-0.3.0.tgz";
        sha1 = "3596e6307a781544f591f37da618360f31db57b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."shelljs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "shelljs" ];
  };
  "shelljs" = self.by-version."shelljs"."0.3.0";
  by-spec."shelljs"."0.3.x" =
    self.by-version."shelljs"."0.3.0";
  by-spec."should"."*" =
    self.by-version."should"."4.1.0";
  by-version."should"."4.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "should-4.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should/-/should-4.1.0.tgz";
        name = "should-4.1.0.tgz";
        sha1 = "ae3335655a1fdbb156e0b338bf191106f59dab21";
      })
    ];
    buildInputs =
      (self.nativeDeps."should" or []);
    deps = {
      "should-equal-0.0.1" = self.by-version."should-equal"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should" ];
  };
  "should" = self.by-version."should"."4.1.0";
  by-spec."should-equal"."0.0.1" =
    self.by-version."should-equal"."0.0.1";
  by-version."should-equal"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "should-equal-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-equal/-/should-equal-0.0.1.tgz";
        name = "should-equal-0.0.1.tgz";
        sha1 = "55066653a9f03211da695a2fea768b19956a9c0b";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-equal" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-equal" ];
  };
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.0";
  by-version."sigmund"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "sigmund-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.0.tgz";
        name = "sigmund-1.0.0.tgz";
        sha1 = "66a2b3a749ae8b5fb89efd4fcc01dc94fbe02296";
      })
    ];
    buildInputs =
      (self.nativeDeps."sigmund" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sigmund" ];
  };
  by-spec."signals"."<2.0" =
    self.by-version."signals"."1.0.0";
  by-version."signals"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "signals-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/signals/-/signals-1.0.0.tgz";
        name = "signals-1.0.0.tgz";
        sha1 = "65f0c1599352b35372ecaae5a250e6107376ed69";
      })
    ];
    buildInputs =
      (self.nativeDeps."signals" or []);
    deps = {
    };
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
    name = "simple-lru-cache-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/simple-lru-cache/-/simple-lru-cache-0.0.1.tgz";
        name = "simple-lru-cache-0.0.1.tgz";
        sha1 = "0334171e40ed4a4861ac29250eb1db23300be4f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."simple-lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "simple-lru-cache" ];
  };
  by-spec."simplesmtp".">= 0.1.22" =
    self.by-version."simplesmtp"."0.3.33";
  by-version."simplesmtp"."0.3.33" = lib.makeOverridable self.buildNodePackage {
    name = "simplesmtp-0.3.33";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/simplesmtp/-/simplesmtp-0.3.33.tgz";
        name = "simplesmtp-0.3.33.tgz";
        sha1 = "f25e12431d8c6363755c106595b998f5f965aad9";
      })
    ];
    buildInputs =
      (self.nativeDeps."simplesmtp" or []);
    deps = {
      "rai-0.1.11" = self.by-version."rai"."0.1.11";
      "xoauth2-0.1.8" = self.by-version."xoauth2"."0.1.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "simplesmtp" ];
  };
  by-spec."sinon"."*" =
    self.by-version."sinon"."1.10.3";
  by-version."sinon"."1.10.3" = lib.makeOverridable self.buildNodePackage {
    name = "sinon-1.10.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sinon/-/sinon-1.10.3.tgz";
        name = "sinon-1.10.3.tgz";
        sha1 = "c063e0e99d8327dc199113aab52eb83a2e9e3c2c";
      })
    ];
    buildInputs =
      (self.nativeDeps."sinon" or []);
    deps = {
      "formatio-1.0.2" = self.by-version."formatio"."1.0.2";
      "util-0.10.3" = self.by-version."util"."0.10.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sinon" ];
  };
  "sinon" = self.by-version."sinon"."1.10.3";
  by-spec."slasp"."*" =
    self.by-version."slasp"."0.0.4";
  by-version."slasp"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "slasp-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slasp/-/slasp-0.0.4.tgz";
        name = "slasp-0.0.4.tgz";
        sha1 = "9adc26ee729a0f95095851a5489f87a5258d57a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."slasp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "slasp" ];
  };
  "slasp" = self.by-version."slasp"."0.0.4";
  by-spec."slasp"."0.0.4" =
    self.by-version."slasp"."0.0.4";
  by-spec."sliced"."0.0.3" =
    self.by-version."sliced"."0.0.3";
  by-version."sliced"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "sliced-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.3.tgz";
        name = "sliced-0.0.3.tgz";
        sha1 = "4f0bac2171eb17162c3ba6df81f5cf040f7c7e50";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  by-spec."sliced"."0.0.4" =
    self.by-version."sliced"."0.0.4";
  by-version."sliced"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "sliced-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.4.tgz";
        name = "sliced-0.0.4.tgz";
        sha1 = "34f89a6db1f31fa525f5a570f5bcf877cf0955ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  by-spec."sliced"."0.0.5" =
    self.by-version."sliced"."0.0.5";
  by-version."sliced"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "sliced-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.5.tgz";
        name = "sliced-0.0.5.tgz";
        sha1 = "5edc044ca4eb6f7816d50ba2fc63e25d8fe4707f";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  by-spec."slide"."^1.1.3" =
    self.by-version."slide"."1.1.6";
  by-version."slide"."1.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "slide-1.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.6.tgz";
        name = "slide-1.1.6.tgz";
        sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
      })
    ];
    buildInputs =
      (self.nativeDeps."slide" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "slide" ];
  };
  by-spec."slide"."^1.1.5" =
    self.by-version."slide"."1.1.6";
  by-spec."slide"."~1.1.3" =
    self.by-version."slide"."1.1.6";
  by-spec."slide"."~1.1.6" =
    self.by-version."slide"."1.1.6";
  by-spec."smartdc"."*" =
    self.by-version."smartdc"."7.3.0";
  by-version."smartdc"."7.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-7.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc/-/smartdc-7.3.0.tgz";
        name = "smartdc-7.3.0.tgz";
        sha1 = "d932196df2d75599fcb98a628803e83c8f9fbe45";
      })
    ];
    buildInputs =
      (self.nativeDeps."smartdc" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
      "lru-cache-2.2.0" = self.by-version."lru-cache"."2.2.0";
      "nopt-2.0.0" = self.by-version."nopt"."2.0.0";
      "restify-2.4.1" = self.by-version."restify"."2.4.1";
      "bunyan-0.21.1" = self.by-version."bunyan"."0.21.1";
      "clone-0.1.6" = self.by-version."clone"."0.1.6";
      "smartdc-auth-1.0.1" = self.by-version."smartdc-auth"."1.0.1";
      "cmdln-1.3.2" = self.by-version."cmdln"."1.3.2";
      "dashdash-1.5.0" = self.by-version."dashdash"."1.5.0";
      "vasync-1.4.3" = self.by-version."vasync"."1.4.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "smartdc" ];
  };
  "smartdc" = self.by-version."smartdc"."7.3.0";
  by-spec."smartdc-auth"."1.0.1" =
    self.by-version."smartdc-auth"."1.0.1";
  by-version."smartdc-auth"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-auth-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc-auth/-/smartdc-auth-1.0.1.tgz";
        name = "smartdc-auth-1.0.1.tgz";
        sha1 = "520bbf918313bdf2da372927d33756d46356b87b";
      })
    ];
    buildInputs =
      (self.nativeDeps."smartdc-auth" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
      "clone-0.1.5" = self.by-version."clone"."0.1.5";
      "ssh-agent-0.2.1" = self.by-version."ssh-agent"."0.2.1";
      "once-1.1.1" = self.by-version."once"."1.1.1";
      "vasync-1.3.3" = self.by-version."vasync"."1.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "smartdc-auth" ];
  };
  by-spec."sntp"."0.1.x" =
    self.by-version."sntp"."0.1.4";
  by-version."sntp"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.1.4.tgz";
        name = "sntp-0.1.4.tgz";
        sha1 = "5ef481b951a7b29affdf4afd7f26838fc1120f84";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
        name = "sntp-0.2.4.tgz";
        sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."socket.io"."0.9.14" =
    self.by-version."socket.io"."0.9.14";
  by-version."socket.io"."0.9.14" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-0.9.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.14.tgz";
        name = "socket.io-0.9.14.tgz";
        sha1 = "81af80ebf3ee8f7f6e71b1495db91f8fa53ff667";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io" or []);
    deps = {
      "socket.io-client-0.9.11" = self.by-version."socket.io-client"."0.9.11";
      "policyfile-0.0.4" = self.by-version."policyfile"."0.0.4";
      "base64id-0.1.0" = self.by-version."base64id"."0.1.0";
      "redis-0.7.3" = self.by-version."redis"."0.7.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  by-spec."socket.io"."~0.9.13" =
    self.by-version."socket.io"."0.9.17";
  by-version."socket.io"."0.9.17" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-0.9.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.17.tgz";
        name = "socket.io-0.9.17.tgz";
        sha1 = "ca389268fb2cd5df4b59218490a08c907581c9ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io" or []);
    deps = {
      "socket.io-client-0.9.16" = self.by-version."socket.io-client"."0.9.16";
      "policyfile-0.0.4" = self.by-version."policyfile"."0.0.4";
      "base64id-0.1.0" = self.by-version."base64id"."0.1.0";
      "redis-0.7.3" = self.by-version."redis"."0.7.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  by-spec."socket.io"."~0.9.16" =
    self.by-version."socket.io"."0.9.17";
  by-spec."socket.io-client"."0.9.11" =
    self.by-version."socket.io-client"."0.9.11";
  by-version."socket.io-client"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-client-0.9.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-0.9.11.tgz";
        name = "socket.io-client-0.9.11.tgz";
        sha1 = "94defc1b29e0d8a8fe958c1cf33300f68d8a19c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io-client" or []);
    deps = {
      "uglify-js-1.2.5" = self.by-version."uglify-js"."1.2.5";
      "ws-0.4.32" = self.by-version."ws"."0.4.32";
      "xmlhttprequest-1.4.2" = self.by-version."xmlhttprequest"."1.4.2";
      "active-x-obfuscator-0.0.1" = self.by-version."active-x-obfuscator"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "socket.io-client" ];
  };
  by-spec."socket.io-client"."0.9.16" =
    self.by-version."socket.io-client"."0.9.16";
  by-version."socket.io-client"."0.9.16" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-client-0.9.16";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-0.9.16.tgz";
        name = "socket.io-client-0.9.16.tgz";
        sha1 = "4da7515c5e773041d1b423970415bcc430f35fc6";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io-client" or []);
    deps = {
      "uglify-js-1.2.5" = self.by-version."uglify-js"."1.2.5";
      "ws-0.4.32" = self.by-version."ws"."0.4.32";
      "xmlhttprequest-1.4.2" = self.by-version."xmlhttprequest"."1.4.2";
      "active-x-obfuscator-0.0.1" = self.by-version."active-x-obfuscator"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "socket.io-client" ];
  };
  by-spec."sockjs"."*" =
    self.by-version."sockjs"."0.3.9";
  by-version."sockjs"."0.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "sockjs-0.3.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sockjs/-/sockjs-0.3.9.tgz";
        name = "sockjs-0.3.9.tgz";
        sha1 = "5ae2c732dac07f6d7e9e8a9a60ec86ec4fc3ffc7";
      })
    ];
    buildInputs =
      (self.nativeDeps."sockjs" or []);
    deps = {
      "node-uuid-1.3.3" = self.by-version."node-uuid"."1.3.3";
      "faye-websocket-0.7.2" = self.by-version."faye-websocket"."0.7.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sockjs" ];
  };
  "sockjs" = self.by-version."sockjs"."0.3.9";
  by-spec."sorted-object"."~1.0.0" =
    self.by-version."sorted-object"."1.0.0";
  by-version."sorted-object"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "sorted-object-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sorted-object/-/sorted-object-1.0.0.tgz";
        name = "sorted-object-1.0.0.tgz";
        sha1 = "5d1f4f9c1fb2cd48965967304e212eb44cfb6d05";
      })
    ];
    buildInputs =
      (self.nativeDeps."sorted-object" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sorted-object" ];
  };
  by-spec."source-map"."*" =
    self.by-version."source-map"."0.1.40";
  by-version."source-map"."0.1.40" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.40";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.40.tgz";
        name = "source-map-0.1.40.tgz";
        sha1 = "7e0ee49ec0452aa9ac2b93ad5ae54ef33e82b37f";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  "source-map" = self.by-version."source-map"."0.1.40";
  by-spec."source-map"."0.1.11" =
    self.by-version."source-map"."0.1.11";
  by-version."source-map"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.11.tgz";
        name = "source-map-0.1.11.tgz";
        sha1 = "2eef2fd65a74c179880ae5ee6975d99ce21eb7b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  by-spec."source-map"."0.1.31" =
    self.by-version."source-map"."0.1.31";
  by-version."source-map"."0.1.31" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.31.tgz";
        name = "source-map-0.1.31.tgz";
        sha1 = "9f704d0d69d9e138a81badf6ebb4fde33d151c61";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  by-spec."source-map"."0.1.34" =
    self.by-version."source-map"."0.1.34";
  by-version."source-map"."0.1.34" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.34";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.34.tgz";
        name = "source-map-0.1.34.tgz";
        sha1 = "a7cfe89aec7b1682c3b198d0acfb47d7d090566b";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  by-spec."source-map"."0.1.x" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map".">= 0.1.2" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~ 0.1.8" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.30" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.31" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.33" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.7" =
    self.by-version."source-map"."0.1.40";
  by-spec."spdy"."1.7.1" =
    self.by-version."spdy"."1.7.1";
  by-version."spdy"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "spdy-1.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/spdy/-/spdy-1.7.1.tgz";
        name = "spdy-1.7.1.tgz";
        sha1 = "4fde77e602b20c4ecc39ee8619373dd9bf669152";
      })
    ];
    buildInputs =
      (self.nativeDeps."spdy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "spdy" ];
  };
  by-spec."sprintf"."~0.1.2" =
    self.by-version."sprintf"."0.1.4";
  by-version."sprintf"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "sprintf-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sprintf/-/sprintf-0.1.4.tgz";
        name = "sprintf-0.1.4.tgz";
        sha1 = "6f870a8f4aae1c7fe53eee02b6ca31aa2d78863b";
      })
    ];
    buildInputs =
      (self.nativeDeps."sprintf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sprintf" ];
  };
  by-spec."sprintf"."~0.1.3" =
    self.by-version."sprintf"."0.1.4";
  by-spec."sprintf"."~0.1.4" =
    self.by-version."sprintf"."0.1.4";
  by-spec."ssh-agent"."0.2.1" =
    self.by-version."ssh-agent"."0.2.1";
  by-version."ssh-agent"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ssh-agent-0.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ssh-agent/-/ssh-agent-0.2.1.tgz";
        name = "ssh-agent-0.2.1.tgz";
        sha1 = "3044e9eaeca88a9e6971dd7deb19bdcc20012929";
      })
    ];
    buildInputs =
      (self.nativeDeps."ssh-agent" or []);
    deps = {
      "ctype-0.5.0" = self.by-version."ctype"."0.5.0";
      "posix-getopt-1.0.0" = self.by-version."posix-getopt"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ssh-agent" ];
  };
  by-spec."stack-trace"."0.0.7" =
    self.by-version."stack-trace"."0.0.7";
  by-version."stack-trace"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "stack-trace-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.7.tgz";
        name = "stack-trace-0.0.7.tgz";
        sha1 = "c72e089744fc3659f508cdce3621af5634ec0fff";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "stack-trace-0.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
        name = "stack-trace-0.0.9.tgz";
        sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  by-spec."stackdriver-statsd-backend"."*" =
    self.by-version."stackdriver-statsd-backend"."0.2.2";
  by-version."stackdriver-statsd-backend"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "stackdriver-statsd-backend-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stackdriver-statsd-backend/-/stackdriver-statsd-backend-0.2.2.tgz";
        name = "stackdriver-statsd-backend-0.2.2.tgz";
        sha1 = "15bdc95adf083cfbfa20d7ff8f67277d7eba38f8";
      })
    ];
    buildInputs =
      (self.nativeDeps."stackdriver-statsd-backend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stackdriver-statsd-backend" ];
  };
  "stackdriver-statsd-backend" = self.by-version."stackdriver-statsd-backend"."0.2.2";
  by-spec."statsd"."*" =
    self.by-version."statsd"."0.7.2";
  by-version."statsd"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "statsd-0.7.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd/-/statsd-0.7.2.tgz";
        name = "statsd-0.7.2.tgz";
        sha1 = "88901c5f30fa51da5fa3520468c94d7992ef576e";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd" or []);
    deps = {
      "node-syslog-1.1.7" = self.by-version."node-syslog"."1.1.7";
      "hashring-1.0.1" = self.by-version."hashring"."1.0.1";
      "winser-0.1.6" = self.by-version."winser"."0.1.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "statsd" ];
  };
  "statsd" = self.by-version."statsd"."0.7.2";
  by-spec."statsd-influxdb-backend"."*" =
    self.by-version."statsd-influxdb-backend"."0.3.0";
  by-version."statsd-influxdb-backend"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "statsd-influxdb-backend-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd-influxdb-backend/-/statsd-influxdb-backend-0.3.0.tgz";
        name = "statsd-influxdb-backend-0.3.0.tgz";
        sha1 = "f66197570545c04743c8637af1fbbc914096ec44";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd-influxdb-backend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "statsd-influxdb-backend" ];
  };
  "statsd-influxdb-backend" = self.by-version."statsd-influxdb-backend"."0.3.0";
  by-spec."statsd-librato-backend"."*" =
    self.by-version."statsd-librato-backend"."0.1.3";
  by-version."statsd-librato-backend"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "statsd-librato-backend-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd-librato-backend/-/statsd-librato-backend-0.1.3.tgz";
        name = "statsd-librato-backend-0.1.3.tgz";
        sha1 = "a72b885f6114a1d8ad460aff6a8319631b8c4e08";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd-librato-backend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "statsd-librato-backend" ];
  };
  "statsd-librato-backend" = self.by-version."statsd-librato-backend"."0.1.3";
  by-spec."statuses"."1" =
    self.by-version."statuses"."1.2.0";
  by-version."statuses"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "statuses-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statuses/-/statuses-1.2.0.tgz";
        name = "statuses-1.2.0.tgz";
        sha1 = "4445790d65bec29184f50d54810f67e290c1679e";
      })
    ];
    buildInputs =
      (self.nativeDeps."statuses" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "statuses" ];
  };
  by-spec."stream-browserify"."^1.0.0" =
    self.by-version."stream-browserify"."1.0.0";
  by-version."stream-browserify"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-browserify-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-browserify/-/stream-browserify-1.0.0.tgz";
        name = "stream-browserify-1.0.0.tgz";
        sha1 = "bf9b4abfb42b274d751479e44e0ff2656b6f1193";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-browserify" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-browserify" ];
  };
  by-spec."stream-combiner2"."~1.0.0" =
    self.by-version."stream-combiner2"."1.0.2";
  by-version."stream-combiner2"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "stream-combiner2-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-combiner2/-/stream-combiner2-1.0.2.tgz";
        name = "stream-combiner2-1.0.2.tgz";
        sha1 = "ba72a6b50cbfabfa950fc8bc87604bd01eb60671";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-combiner2" or []);
    deps = {
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-combiner2" ];
  };
  by-spec."stream-consume"."~0.1.0" =
    self.by-version."stream-consume"."0.1.0";
  by-version."stream-consume"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-consume-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-consume/-/stream-consume-0.1.0.tgz";
        name = "stream-consume-0.1.0.tgz";
        sha1 = "a41ead1a6d6081ceb79f65b061901b6d8f3d1d0f";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-consume" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-consume" ];
  };
  by-spec."stream-counter"."^1.0.0" =
    self.by-version."stream-counter"."1.0.0";
  by-version."stream-counter"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-counter-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-counter/-/stream-counter-1.0.0.tgz";
        name = "stream-counter-1.0.0.tgz";
        sha1 = "91cf2569ce4dc5061febcd7acb26394a5a114751";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-counter" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."stream-counter"."~0.2.0" =
    self.by-version."stream-counter"."0.2.0";
  by-version."stream-counter"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-counter-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-counter/-/stream-counter-0.2.0.tgz";
        name = "stream-counter-0.2.0.tgz";
        sha1 = "ded266556319c8b0e222812b9cf3b26fa7d947de";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-counter" or []);
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."stream-splicer"."^1.1.0" =
    self.by-version."stream-splicer"."1.3.1";
  by-version."stream-splicer"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "stream-splicer-1.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-splicer/-/stream-splicer-1.3.1.tgz";
        name = "stream-splicer-1.3.1.tgz";
        sha1 = "87737a08777aa00d6a27d92562e7bc88070c081d";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-splicer" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "readable-wrap-1.0.0" = self.by-version."readable-wrap"."1.0.0";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-splicer" ];
  };
  by-spec."stream-splitter-transform"."*" =
    self.by-version."stream-splitter-transform"."0.0.4";
  by-version."stream-splitter-transform"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "stream-splitter-transform-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-splitter-transform/-/stream-splitter-transform-0.0.4.tgz";
        name = "stream-splitter-transform-0.0.4.tgz";
        sha1 = "0de54e94680633a8d703b252b20fa809ed99331c";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-splitter-transform" or []);
    deps = {
      "buffertools-1.1.1" = self.by-version."buffertools"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-splitter-transform" ];
  };
  "stream-splitter-transform" = self.by-version."stream-splitter-transform"."0.0.4";
  by-spec."string"."1.6.1" =
    self.by-version."string"."1.6.1";
  by-version."string"."1.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "string-1.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string/-/string-1.6.1.tgz";
        name = "string-1.6.1.tgz";
        sha1 = "eabe0956da7a8291c6de7486f7b35e58d031cd55";
      })
    ];
    buildInputs =
      (self.nativeDeps."string" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "string" ];
  };
  by-spec."string-length"."^0.1.2" =
    self.by-version."string-length"."0.1.2";
  by-version."string-length"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "string-length-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string-length/-/string-length-0.1.2.tgz";
        name = "string-length-0.1.2.tgz";
        sha1 = "ab04bb33867ee74beed7fb89bb7f089d392780f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."string-length" or []);
    deps = {
      "strip-ansi-0.2.2" = self.by-version."strip-ansi"."0.2.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "string-length" ];
  };
  by-spec."string_decoder"."~0.10.0" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = lib.makeOverridable self.buildNodePackage {
    name = "string_decoder-0.10.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
        name = "string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      })
    ];
    buildInputs =
      (self.nativeDeps."string_decoder" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "string_decoder" ];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-spec."stringify-object"."~1.0.0" =
    self.by-version."stringify-object"."1.0.0";
  by-version."stringify-object"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "stringify-object-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringify-object/-/stringify-object-1.0.0.tgz";
        name = "stringify-object-1.0.0.tgz";
        sha1 = "333875ef8fd210f696d70b374146be84646bc346";
      })
    ];
    buildInputs =
      (self.nativeDeps."stringify-object" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stringify-object" ];
  };
  by-spec."stringstream"."~0.0.4" =
    self.by-version."stringstream"."0.0.4";
  by-version."stringstream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "stringstream-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.4.tgz";
        name = "stringstream-0.0.4.tgz";
        sha1 = "0f0e3423f942960b5692ac324a57dd093bc41a92";
      })
    ];
    buildInputs =
      (self.nativeDeps."stringstream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stringstream" ];
  };
  by-spec."strip-ansi"."^0.2.1" =
    self.by-version."strip-ansi"."0.2.2";
  by-version."strip-ansi"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-0.2.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.2.2.tgz";
        name = "strip-ansi-0.2.2.tgz";
        sha1 = "854d290c981525fc8c397a910b025ae2d54ffc08";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = {
      "ansi-regex-0.1.0" = self.by-version."ansi-regex"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-ansi"."^0.3.0" =
    self.by-version."strip-ansi"."0.3.0";
  by-version."strip-ansi"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-0.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.3.0.tgz";
        name = "strip-ansi-0.3.0.tgz";
        sha1 = "25f48ea22ca79187f3174a4db8759347bb126220";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-ansi"."^1.0.0" =
    self.by-version."strip-ansi"."1.0.0";
  by-version."strip-ansi"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-1.0.0.tgz";
        name = "strip-ansi-1.0.0.tgz";
        sha1 = "6c021321d6ece161a3c608fbab268c7328901c73";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-ansi"."~0.1.0" =
    self.by-version."strip-ansi"."0.1.1";
  by-version."strip-ansi"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-0.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.1.1.tgz";
        name = "strip-ansi-0.1.1.tgz";
        sha1 = "39e8a98d044d150660abe4a6808acf70bb7bc991";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-bom"."^1.0.0" =
    self.by-version."strip-bom"."1.0.0";
  by-version."strip-bom"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "strip-bom-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-bom/-/strip-bom-1.0.0.tgz";
        name = "strip-bom-1.0.0.tgz";
        sha1 = "85b8862f3844b5a6d5ec8467a93598173a36f794";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-bom" or []);
    deps = {
      "first-chunk-stream-1.0.0" = self.by-version."first-chunk-stream"."1.0.0";
      "is-utf8-0.2.0" = self.by-version."is-utf8"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-bom" ];
  };
  by-spec."strip-json-comments"."0.1.x" =
    self.by-version."strip-json-comments"."0.1.3";
  by-version."strip-json-comments"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "strip-json-comments-0.1.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-json-comments/-/strip-json-comments-0.1.3.tgz";
        name = "strip-json-comments-0.1.3.tgz";
        sha1 = "164c64e370a8a3cc00c9e01b539e569823f0ee54";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-json-comments" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-json-comments" ];
  };
  by-spec."strip-json-comments"."1.0.x" =
    self.by-version."strip-json-comments"."1.0.2";
  by-version."strip-json-comments"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "strip-json-comments-1.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-json-comments/-/strip-json-comments-1.0.2.tgz";
        name = "strip-json-comments-1.0.2.tgz";
        sha1 = "5a48ab96023dbac1b7b8d0ffabf6f63f1677be9f";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-json-comments" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-json-comments" ];
  };
  by-spec."strong-data-uri"."~0.1.0" =
    self.by-version."strong-data-uri"."0.1.1";
  by-version."strong-data-uri"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "strong-data-uri-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strong-data-uri/-/strong-data-uri-0.1.1.tgz";
        name = "strong-data-uri-0.1.1.tgz";
        sha1 = "8660241807461d1d2dd247c70563f2f33e66c8ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."strong-data-uri" or []);
    deps = {
      "truncate-1.0.4" = self.by-version."truncate"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strong-data-uri" ];
  };
  by-spec."stylus"."*" =
    self.by-version."stylus"."0.49.2";
  by-version."stylus"."0.49.2" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.49.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.49.2.tgz";
        name = "stylus-0.49.2.tgz";
        sha1 = "c72a9ea9d904d24bb07c8fd609e6abc28620000a";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus" or []);
    deps = {
      "css-parse-1.7.0" = self.by-version."css-parse"."1.7.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "sax-0.5.8" = self.by-version."sax"."0.5.8";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  "stylus" = self.by-version."stylus"."0.49.2";
  by-spec."stylus"."0.42.2" =
    self.by-version."stylus"."0.42.2";
  by-version."stylus"."0.42.2" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.42.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.42.2.tgz";
        name = "stylus-0.42.2.tgz";
        sha1 = "bed29107803129bed1983efc4c7e33f4fd34fee7";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus" or []);
    deps = {
      "css-parse-1.7.0" = self.by-version."css-parse"."1.7.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "sax-0.5.8" = self.by-version."sax"."0.5.8";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  by-spec."subarg"."0.0.1" =
    self.by-version."subarg"."0.0.1";
  by-version."subarg"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "subarg-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/subarg/-/subarg-0.0.1.tgz";
        name = "subarg-0.0.1.tgz";
        sha1 = "3d56b07dacfbc45bbb63f7672b43b63e46368e3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."subarg" or []);
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "subarg" ];
  };
  by-spec."subarg"."^1.0.0" =
    self.by-version."subarg"."1.0.0";
  by-version."subarg"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "subarg-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/subarg/-/subarg-1.0.0.tgz";
        name = "subarg-1.0.0.tgz";
        sha1 = "f62cf17581e996b48fc965699f54c06ae268b8d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."subarg" or []);
    deps = {
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "subarg" ];
  };
  by-spec."superagent"."0.19.0" =
    self.by-version."superagent"."0.19.0";
  by-version."superagent"."0.19.0" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.19.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.19.0.tgz";
        name = "superagent-0.19.0.tgz";
        sha1 = "e3f0fe5c07a429779a4e201c3e7b15b6577e4fbb";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent" or []);
    deps = {
      "qs-1.2.0" = self.by-version."qs"."1.2.0";
      "formidable-1.0.14" = self.by-version."formidable"."1.0.14";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "methods-1.0.1" = self.by-version."methods"."1.0.1";
      "cookiejar-2.0.1" = self.by-version."cookiejar"."2.0.1";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "reduce-component-1.0.1" = self.by-version."reduce-component"."1.0.1";
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "form-data-0.1.3" = self.by-version."form-data"."0.1.3";
      "readable-stream-1.0.27-1" = self.by-version."readable-stream"."1.0.27-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  by-spec."superagent"."~0.13.0" =
    self.by-version."superagent"."0.13.0";
  by-version."superagent"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.13.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.13.0.tgz";
        name = "superagent-0.13.0.tgz";
        sha1 = "ddfbfa5c26f16790f9c5bce42815ccbde2ca36f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent" or []);
    deps = {
      "qs-0.5.2" = self.by-version."qs"."0.5.2";
      "formidable-1.0.9" = self.by-version."formidable"."1.0.9";
      "mime-1.2.5" = self.by-version."mime"."1.2.5";
      "emitter-component-0.0.6" = self.by-version."emitter-component"."0.0.6";
      "methods-0.0.1" = self.by-version."methods"."0.0.1";
      "cookiejar-1.3.0" = self.by-version."cookiejar"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  by-spec."superagent"."~0.18.2" =
    self.by-version."superagent"."0.18.2";
  by-version."superagent"."0.18.2" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.18.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.18.2.tgz";
        name = "superagent-0.18.2.tgz";
        sha1 = "9afc6276a9475f4bdcd535ac6a0685ebc4b560eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent" or []);
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "formidable-1.0.14" = self.by-version."formidable"."1.0.14";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "methods-1.0.1" = self.by-version."methods"."1.0.1";
      "cookiejar-2.0.1" = self.by-version."cookiejar"."2.0.1";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "reduce-component-1.0.1" = self.by-version."reduce-component"."1.0.1";
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "form-data-0.1.3" = self.by-version."form-data"."0.1.3";
      "readable-stream-1.0.27-1" = self.by-version."readable-stream"."1.0.27-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  by-spec."supertest"."*" =
    self.by-version."supertest"."0.14.0";
  by-version."supertest"."0.14.0" = lib.makeOverridable self.buildNodePackage {
    name = "supertest-0.14.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supertest/-/supertest-0.14.0.tgz";
        name = "supertest-0.14.0.tgz";
        sha1 = "d385a8ebced95350de8bde26460d848917dee305";
      })
    ];
    buildInputs =
      (self.nativeDeps."supertest" or []);
    deps = {
      "superagent-0.19.0" = self.by-version."superagent"."0.19.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "supertest" ];
  };
  "supertest" = self.by-version."supertest"."0.14.0";
  by-spec."supports-color"."^0.2.0" =
    self.by-version."supports-color"."0.2.0";
  by-version."supports-color"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "supports-color-0.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-0.2.0.tgz";
        name = "supports-color-0.2.0.tgz";
        sha1 = "d92de2694eb3f67323973d7ae3d8b55b4c22190a";
      })
    ];
    buildInputs =
      (self.nativeDeps."supports-color" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "supports-color" ];
  };
  by-spec."swig"."0.14.x" =
    self.by-version."swig"."0.14.0";
  by-version."swig"."0.14.0" = lib.makeOverridable self.buildNodePackage {
    name = "swig-0.14.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/swig/-/swig-0.14.0.tgz";
        name = "swig-0.14.0.tgz";
        sha1 = "544bfb3bd837608873eed6a72c672a28cb1f1b3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."swig" or []);
    deps = {
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "swig" ];
  };
  "swig" = self.by-version."swig"."0.14.0";
  by-spec."sylvester".">= 0.0.12" =
    self.by-version."sylvester"."0.0.21";
  by-version."sylvester"."0.0.21" = lib.makeOverridable self.buildNodePackage {
    name = "sylvester-0.0.21";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sylvester/-/sylvester-0.0.21.tgz";
        name = "sylvester-0.0.21.tgz";
        sha1 = "2987b1ce2bd2f38b0dce2a34388884bfa4400ea7";
      })
    ];
    buildInputs =
      (self.nativeDeps."sylvester" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sylvester" ];
  };
  by-spec."sylvester".">= 0.0.8" =
    self.by-version."sylvester"."0.0.21";
  by-spec."syntax-error"."^1.1.1" =
    self.by-version."syntax-error"."1.1.1";
  by-version."syntax-error"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "syntax-error-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/syntax-error/-/syntax-error-1.1.1.tgz";
        name = "syntax-error-1.1.1.tgz";
        sha1 = "50a4f836356f3803a8e954ce5dfd4a0f95ba6a87";
      })
    ];
    buildInputs =
      (self.nativeDeps."syntax-error" or []);
    deps = {
      "esprima-fb-3001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
    };
    peerDependencies = [
    ];
    passthru.names = [ "syntax-error" ];
  };
  by-spec."tabtab"."git+https://github.com/mixu/node-tabtab.git" =
    self.by-version."tabtab"."0.0.2";
  by-version."tabtab"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "tabtab-0.0.2";
    bin = false;
    src = [
      (fetchgit {
        url = "https://github.com/mixu/node-tabtab.git";
        rev = "94af2b878b174527b6636aec88acd46979247755";
        sha256 = "7be2daa2fe7893478d38d90b213de359c9a662a7ef06ad9cbfaac11ad399a149";
      })
    ];
    buildInputs =
      (self.nativeDeps."tabtab" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tabtab" ];
  };
  by-spec."tape"."~0.2.2" =
    self.by-version."tape"."0.2.2";
  by-version."tape"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "tape-0.2.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tape/-/tape-0.2.2.tgz";
        name = "tape-0.2.2.tgz";
        sha1 = "64ccfa4b7ecf4a0060007e61716d424781671637";
      })
    ];
    buildInputs =
      (self.nativeDeps."tape" or []);
    deps = {
      "jsonify-0.0.0" = self.by-version."jsonify"."0.0.0";
      "deep-equal-0.0.0" = self.by-version."deep-equal"."0.0.0";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tape" ];
  };
  by-spec."tar"."*" =
    self.by-version."tar"."1.0.1";
  by-version."tar"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "tar-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-1.0.1.tgz";
        name = "tar-1.0.1.tgz";
        sha1 = "6075b5a1f236defe0c7e3756d3d9b3ebdad0f19a";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-1.0.2" = self.by-version."fstream"."1.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  "tar" = self.by-version."tar"."1.0.1";
  by-spec."tar"."0.1.17" =
    self.by-version."tar"."0.1.17";
  by-version."tar"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.17.tgz";
        name = "tar-0.1.17.tgz";
        sha1 = "408c8a95deb8e78a65b59b1a51a333183a32badc";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "inherits-1.0.0" = self.by-version."inherits"."1.0.0";
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  by-spec."tar"."^1.0.0" =
    self.by-version."tar"."1.0.1";
  by-spec."tar"."~1.0.1" =
    self.by-version."tar"."1.0.1";
  by-spec."tar-fs"."0.5.2" =
    self.by-version."tar-fs"."0.5.2";
  by-version."tar-fs"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "tar-fs-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar-fs/-/tar-fs-0.5.2.tgz";
        name = "tar-fs-0.5.2.tgz";
        sha1 = "0f59424be7eeee45232316e302f66d3f6ea6db3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar-fs" or []);
    deps = {
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "pump-0.3.5" = self.by-version."pump"."0.3.5";
      "tar-stream-0.4.7" = self.by-version."tar-stream"."0.4.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar-fs" ];
  };
  by-spec."tar-stream"."^0.4.6" =
    self.by-version."tar-stream"."0.4.7";
  by-version."tar-stream"."0.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "tar-stream-0.4.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar-stream/-/tar-stream-0.4.7.tgz";
        name = "tar-stream-0.4.7.tgz";
        sha1 = "1f1d2ce9ebc7b42765243ca0e8f1b7bfda0aadcd";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar-stream" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "end-of-stream-1.1.0" = self.by-version."end-of-stream"."1.1.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar-stream" ];
  };
  by-spec."tar-stream"."~0.4.0" =
    self.by-version."tar-stream"."0.4.7";
  by-spec."temp"."*" =
    self.by-version."temp"."0.8.1";
  by-version."temp"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.8.1.tgz";
        name = "temp-0.8.1.tgz";
        sha1 = "4b7b4ffde85bb09f2dd6ba6cc43b44213c94fd3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = {
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  "temp" = self.by-version."temp"."0.8.1";
  by-spec."temp"."0.6.0" =
    self.by-version."temp"."0.6.0";
  by-version."temp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.6.0.tgz";
        name = "temp-0.6.0.tgz";
        sha1 = "6b13df5cddf370f2e3a606ca40f202c419173f07";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = {
      "rimraf-2.1.4" = self.by-version."rimraf"."2.1.4";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  by-spec."temp"."~0.6.0" =
    self.by-version."temp"."0.6.0";
  by-spec."temp"."~0.8.1" =
    self.by-version."temp"."0.8.1";
  by-spec."text-table"."~0.2.0" =
    self.by-version."text-table"."0.2.0";
  by-version."text-table"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "text-table-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz";
        name = "text-table-0.2.0.tgz";
        sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."text-table" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "text-table" ];
  };
  by-spec."throttleit"."~0.0.2" =
    self.by-version."throttleit"."0.0.2";
  by-version."throttleit"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "throttleit-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/throttleit/-/throttleit-0.0.2.tgz";
        name = "throttleit-0.0.2.tgz";
        sha1 = "cfedf88e60c00dd9697b61fdd2a8343a9b680eaf";
      })
    ];
    buildInputs =
      (self.nativeDeps."throttleit" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "throttleit" ];
  };
  by-spec."through".">=2.2.7 <3" =
    self.by-version."through"."2.3.6";
  by-version."through"."2.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "through-2.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through/-/through-2.3.6.tgz";
        name = "through-2.3.6.tgz";
        sha1 = "26681c0f524671021d4e29df7c36bce2d0ecf2e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."through" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "through" ];
  };
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.6";
  by-spec."through2"."^0.5.1" =
    self.by-version."through2"."0.5.1";
  by-version."through2"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "through2-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through2/-/through2-0.5.1.tgz";
        name = "through2-0.5.1.tgz";
        sha1 = "dfdd012eb9c700e2323fd334f38ac622ab372da7";
      })
    ];
    buildInputs =
      (self.nativeDeps."through2" or []);
    deps = {
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."through2"."^0.6.1" =
    self.by-version."through2"."0.6.3";
  by-version."through2"."0.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "through2-0.6.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through2/-/through2-0.6.3.tgz";
        name = "through2-0.6.3.tgz";
        sha1 = "795292fde9f254c2a368b38f9cc5d1bd4663afb6";
      })
    ];
    buildInputs =
      (self.nativeDeps."through2" or []);
    deps = {
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."through2"."^1.0.0" =
    self.by-version."through2"."1.1.1";
  by-version."through2"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "through2-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through2/-/through2-1.1.1.tgz";
        name = "through2-1.1.1.tgz";
        sha1 = "0847cbc4449f3405574dbdccd9bb841b83ac3545";
      })
    ];
    buildInputs =
      (self.nativeDeps."through2" or []);
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."through2"."~0.4.1" =
    self.by-version."through2"."0.4.2";
  by-version."through2"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "through2-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through2/-/through2-0.4.2.tgz";
        name = "through2-0.4.2.tgz";
        sha1 = "dbf5866031151ec8352bb6c4db64a2292a840b9b";
      })
    ];
    buildInputs =
      (self.nativeDeps."through2" or []);
    deps = {
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
      "xtend-2.1.2" = self.by-version."xtend"."2.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."through2"."~0.5.1" =
    self.by-version."through2"."0.5.1";
  by-spec."tildify"."^1.0.0" =
    self.by-version."tildify"."1.0.0";
  by-version."tildify"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "tildify-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tildify/-/tildify-1.0.0.tgz";
        name = "tildify-1.0.0.tgz";
        sha1 = "2a021db5e8fbde0a8f8b4df37adaa8fb1d39d7dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."tildify" or []);
    deps = {
      "user-home-1.1.0" = self.by-version."user-home"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tildify" ];
  };
  by-spec."timers-browserify"."^1.0.1" =
    self.by-version."timers-browserify"."1.1.0";
  by-version."timers-browserify"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "timers-browserify-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timers-browserify/-/timers-browserify-1.1.0.tgz";
        name = "timers-browserify-1.1.0.tgz";
        sha1 = "bffd11af00fe82b089b015e8de4dc6a911b7ec3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."timers-browserify" or []);
    deps = {
      "process-0.5.2" = self.by-version."process"."0.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "timers-browserify" ];
  };
  by-spec."timers-ext"."0.1" =
    self.by-version."timers-ext"."0.1.0";
  by-version."timers-ext"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "timers-ext-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timers-ext/-/timers-ext-0.1.0.tgz";
        name = "timers-ext-0.1.0.tgz";
        sha1 = "00345a2ca93089d1251322054389d263e27b77e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."timers-ext" or []);
    deps = {
      "es5-ext-0.10.4" = self.by-version."es5-ext"."0.10.4";
      "next-tick-0.2.2" = self.by-version."next-tick"."0.2.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "timers-ext" ];
  };
  by-spec."timers-ext"."0.1.x" =
    self.by-version."timers-ext"."0.1.0";
  by-spec."timespan"."~2.3.0" =
    self.by-version."timespan"."2.3.0";
  by-version."timespan"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "timespan-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timespan/-/timespan-2.3.0.tgz";
        name = "timespan-2.3.0.tgz";
        sha1 = "4902ce040bd13d845c8f59b27e9d59bad6f39929";
      })
    ];
    buildInputs =
      (self.nativeDeps."timespan" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "timespan" ];
  };
  by-spec."timezone"."*" =
    self.by-version."timezone"."0.0.34";
  by-version."timezone"."0.0.34" = lib.makeOverridable self.buildNodePackage {
    name = "timezone-0.0.34";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timezone/-/timezone-0.0.34.tgz";
        name = "timezone-0.0.34.tgz";
        sha1 = "be56c3259448897b7e2eab6e2aeac46d5ab718d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."timezone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "timezone" ];
  };
  "timezone" = self.by-version."timezone"."0.0.34";
  by-spec."tinycolor"."0.x" =
    self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "tinycolor-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
        name = "tinycolor-0.0.1.tgz";
        sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
      })
    ];
    buildInputs =
      (self.nativeDeps."tinycolor" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tinycolor" ];
  };
  by-spec."titanium"."*" =
    self.by-version."titanium"."3.4.0";
  by-version."titanium"."3.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "titanium-3.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/titanium/-/titanium-3.4.0.tgz";
        name = "titanium-3.4.0.tgz";
        sha1 = "5b4fca5cd15fadd187725dd46f7469eed9405683";
      })
    ];
    buildInputs =
      (self.nativeDeps."titanium" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "fields-0.1.17" = self.by-version."fields"."0.1.17";
      "humanize-0.0.9" = self.by-version."humanize"."0.0.9";
      "jade-0.35.0" = self.by-version."jade"."0.35.0";
      "longjohn-0.2.4" = self.by-version."longjohn"."0.2.4";
      "moment-2.4.0" = self.by-version."moment"."2.4.0";
      "node-appc-0.2.14" = self.by-version."node-appc"."0.2.14";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "request-2.27.0" = self.by-version."request"."2.27.0";
      "semver-2.2.1" = self.by-version."semver"."2.2.1";
      "sprintf-0.1.4" = self.by-version."sprintf"."0.1.4";
      "temp-0.6.0" = self.by-version."temp"."0.6.0";
      "winston-0.6.2" = self.by-version."winston"."0.6.2";
      "wrench-1.5.8" = self.by-version."wrench"."1.5.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "titanium" ];
  };
  "titanium" = self.by-version."titanium"."3.4.0";
  by-spec."tmp"."0.0.23" =
    self.by-version."tmp"."0.0.23";
  by-version."tmp"."0.0.23" = lib.makeOverridable self.buildNodePackage {
    name = "tmp-0.0.23";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tmp/-/tmp-0.0.23.tgz";
        name = "tmp-0.0.23.tgz";
        sha1 = "de874aa5e974a85f0a32cdfdbd74663cb3bd9c74";
      })
    ];
    buildInputs =
      (self.nativeDeps."tmp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tmp" ];
  };
  by-spec."tmp"."0.0.24" =
    self.by-version."tmp"."0.0.24";
  by-version."tmp"."0.0.24" = lib.makeOverridable self.buildNodePackage {
    name = "tmp-0.0.24";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tmp/-/tmp-0.0.24.tgz";
        name = "tmp-0.0.24.tgz";
        sha1 = "d6a5e198d14a9835cc6f2d7c3d9e302428c8cf12";
      })
    ];
    buildInputs =
      (self.nativeDeps."tmp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tmp" ];
  };
  by-spec."tmp"."~0.0.20" =
    self.by-version."tmp"."0.0.24";
  by-spec."touch"."0.0.2" =
    self.by-version."touch"."0.0.2";
  by-version."touch"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "touch-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/touch/-/touch-0.0.2.tgz";
        name = "touch-0.0.2.tgz";
        sha1 = "a65a777795e5cbbe1299499bdc42281ffb21b5f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."touch" or []);
    deps = {
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "touch" ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."0.12.1";
  by-version."tough-cookie"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "tough-cookie-0.12.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
        name = "tough-cookie-0.12.1.tgz";
        sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
      })
    ];
    buildInputs =
      (self.nativeDeps."tough-cookie" or []);
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
  };
  by-spec."tough-cookie"."^0.12.1" =
    self.by-version."tough-cookie"."0.12.1";
  by-spec."traceur"."0.0.55" =
    self.by-version."traceur"."0.0.55";
  by-version."traceur"."0.0.55" = lib.makeOverridable self.buildNodePackage {
    name = "traceur-0.0.55";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traceur/-/traceur-0.0.55.tgz";
        name = "traceur-0.0.55.tgz";
        sha1 = "b1a44b69bfbabb9db2c7c284713f4ebacf46f733";
      })
    ];
    buildInputs =
      (self.nativeDeps."traceur" or []);
    deps = {
      "commander-2.4.0" = self.by-version."commander"."2.4.0";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "traceur" ];
  };
  by-spec."transformers"."2.1.0" =
    self.by-version."transformers"."2.1.0";
  by-version."transformers"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "transformers-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/transformers/-/transformers-2.1.0.tgz";
        name = "transformers-2.1.0.tgz";
        sha1 = "5d23cb35561dd85dc67fb8482309b47d53cce9a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."transformers" or []);
    deps = {
      "promise-2.0.0" = self.by-version."promise"."2.0.0";
      "css-1.0.8" = self.by-version."css"."1.0.8";
      "uglify-js-2.2.5" = self.by-version."uglify-js"."2.2.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "transformers" ];
  };
  by-spec."traverse".">=0.3.0 <0.4" =
    self.by-version."traverse"."0.3.9";
  by-version."traverse"."0.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "traverse-0.3.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traverse/-/traverse-0.3.9.tgz";
        name = "traverse-0.3.9.tgz";
        sha1 = "717b8f220cc0bb7b44e40514c22b2e8bbc70d8b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."traverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "traverse" ];
  };
  by-spec."truncate"."~1.0.2" =
    self.by-version."truncate"."1.0.4";
  by-version."truncate"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "truncate-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/truncate/-/truncate-1.0.4.tgz";
        name = "truncate-1.0.4.tgz";
        sha1 = "2bcfbbff4a97b9089b693c1ae37c5105ec8775aa";
      })
    ];
    buildInputs =
      (self.nativeDeps."truncate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "truncate" ];
  };
  by-spec."tty-browserify"."~0.0.0" =
    self.by-version."tty-browserify"."0.0.0";
  by-version."tty-browserify"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "tty-browserify-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz";
        name = "tty-browserify-0.0.0.tgz";
        sha1 = "a157ba402da24e9bf957f9aa69d524eed42901a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."tty-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tty-browserify" ];
  };
  by-spec."tunnel-agent"."~0.2.0" =
    self.by-version."tunnel-agent"."0.2.0";
  by-version."tunnel-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.2.0.tgz";
        name = "tunnel-agent-0.2.0.tgz";
        sha1 = "6853c2afb1b2109e45629e492bde35f459ea69e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."tunnel-agent"."~0.3.0" =
    self.by-version."tunnel-agent"."0.3.0";
  by-version."tunnel-agent"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.3.0.tgz";
        name = "tunnel-agent-0.3.0.tgz";
        sha1 = "ad681b68f5321ad2827c4cfb1b7d5df2cfe942ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."tunnel-agent"."~0.4.0" =
    self.by-version."tunnel-agent"."0.4.0";
  by-version."tunnel-agent"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.0.tgz";
        name = "tunnel-agent-0.4.0.tgz";
        sha1 = "b1184e312ffbcf70b3b4c78e8c219de7ebb1c550";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."type-detect"."0.1.1" =
    self.by-version."type-detect"."0.1.1";
  by-version."type-detect"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "type-detect-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-detect/-/type-detect-0.1.1.tgz";
        name = "type-detect-0.1.1.tgz";
        sha1 = "0ba5ec2a885640e470ea4e8505971900dac58822";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-detect" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "type-detect" ];
  };
  by-spec."type-is"."1.0.0" =
    self.by-version."type-is"."1.0.0";
  by-version."type-is"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "type-is-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.0.0.tgz";
        name = "type-is-1.0.0.tgz";
        sha1 = "4ff424e97349a1ee1910b4bfc488595ecdc443fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = {
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
  };
  by-spec."type-is"."~1.3.2" =
    self.by-version."type-is"."1.3.2";
  by-version."type-is"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "type-is-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.3.2.tgz";
        name = "type-is-1.3.2.tgz";
        sha1 = "4f2a5dc58775ca1630250afc7186f8b36309d1bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = {
      "media-typer-0.2.0" = self.by-version."media-typer"."0.2.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
  };
  by-spec."type-is"."~1.5.1" =
    self.by-version."type-is"."1.5.2";
  by-version."type-is"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "type-is-1.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.5.2.tgz";
        name = "type-is-1.5.2.tgz";
        sha1 = "8291bbe845a904acfaffd05a41fdeb234bfa9e5f";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.0.2" = self.by-version."mime-types"."2.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
  };
  by-spec."type-is"."~1.5.2" =
    self.by-version."type-is"."1.5.2";
  by-spec."typechecker"."~2.0.1" =
    self.by-version."typechecker"."2.0.8";
  by-version."typechecker"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "typechecker-2.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/typechecker/-/typechecker-2.0.8.tgz";
        name = "typechecker-2.0.8.tgz";
        sha1 = "e83da84bb64c584ccb345838576c40b0337db82e";
      })
    ];
    buildInputs =
      (self.nativeDeps."typechecker" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "typechecker" ];
  };
  by-spec."typedarray"."~0.0.5" =
    self.by-version."typedarray"."0.0.6";
  by-version."typedarray"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "typedarray-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
        name = "typedarray-0.0.6.tgz";
        sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
      })
    ];
    buildInputs =
      (self.nativeDeps."typedarray" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "typedarray" ];
  };
  by-spec."typescript"."*" =
    self.by-version."typescript"."1.1.0-1";
  by-version."typescript"."1.1.0-1" = lib.makeOverridable self.buildNodePackage {
    name = "typescript-1.1.0-1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/typescript/-/typescript-1.1.0-1.tgz";
        name = "typescript-1.1.0-1.tgz";
        sha1 = "ad83fb48dd52312564fc795fb2e1ecc43d5e9d6e";
      })
    ];
    buildInputs =
      (self.nativeDeps."typescript" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "typescript" ];
  };
  "typescript" = self.by-version."typescript"."1.1.0-1";
  by-spec."uglify-js"."*" =
    self.by-version."uglify-js"."2.4.15";
  by-version."uglify-js"."2.4.15" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.15";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.15.tgz";
        name = "uglify-js-2.4.15.tgz";
        sha1 = "12bc6d84345fbc306e13f7075d6437a8bf64d7e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.34" = self.by-version."source-map"."0.1.34";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  "uglify-js" = self.by-version."uglify-js"."2.4.15";
  by-spec."uglify-js"."1.2.5" =
    self.by-version."uglify-js"."1.2.5";
  by-version."uglify-js"."1.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-1.2.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.2.5.tgz";
        name = "uglify-js-1.2.5.tgz";
        sha1 = "b542c2c76f78efb34b200b20177634330ff702b6";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."2.4.0" =
    self.by-version."uglify-js"."2.4.0";
  by-version."uglify-js"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.0.tgz";
        name = "uglify-js-2.4.0.tgz";
        sha1 = "a5f2b6b1b817fb34c16a04234328c89ba1e77137";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."^2.4.0" =
    self.by-version."uglify-js"."2.4.15";
  by-spec."uglify-js"."~2.2" =
    self.by-version."uglify-js"."2.2.5";
  by-version."uglify-js"."2.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.2.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.2.5.tgz";
        name = "uglify-js-2.2.5.tgz";
        sha1 = "a6e02a70d839792b9780488b7b8b184c095c99c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
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
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.3.6.tgz";
        name = "uglify-js-2.3.6.tgz";
        sha1 = "fa0984770b428b7a9b2a8058f46355d14fef211a";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.3.6" =
    self.by-version."uglify-js"."2.3.6";
  by-spec."uglify-js"."~2.4.0" =
    self.by-version."uglify-js"."2.4.15";
  by-spec."uglify-js"."~2.4.12" =
    self.by-version."uglify-js"."2.4.15";
  by-spec."uglify-to-browserify"."~1.0.0" =
    self.by-version."uglify-to-browserify"."1.0.2";
  by-version."uglify-to-browserify"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-to-browserify-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
        name = "uglify-to-browserify-1.0.2.tgz";
        sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-to-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-to-browserify" ];
  };
  by-spec."uid-number"."0.0.5" =
    self.by-version."uid-number"."0.0.5";
  by-version."uid-number"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "uid-number-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.5.tgz";
        name = "uid-number-0.0.5.tgz";
        sha1 = "5a3db23ef5dbd55b81fce0ec9a2ac6fccdebb81e";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid-number" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uid-number" ];
  };
  by-spec."uid-safe"."1.0.1" =
    self.by-version."uid-safe"."1.0.1";
  by-version."uid-safe"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "uid-safe-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-safe/-/uid-safe-1.0.1.tgz";
        name = "uid-safe-1.0.1.tgz";
        sha1 = "5bd148460a2e84f54f193fd20352c8c3d7de6ac8";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid-safe" or []);
    deps = {
      "mz-1.0.2" = self.by-version."mz"."1.0.2";
      "base64-url-1.0.0" = self.by-version."base64-url"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uid-safe" ];
  };
  by-spec."uid-safe"."~1.0.1" =
    self.by-version."uid-safe"."1.0.1";
  by-spec."uid2"."0.0.3" =
    self.by-version."uid2"."0.0.3";
  by-version."uid2"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "uid2-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid2/-/uid2-0.0.3.tgz";
        name = "uid2-0.0.3.tgz";
        sha1 = "483126e11774df2f71b8b639dcd799c376162b82";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid2" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uid2" ];
  };
  by-spec."umd"."^2.1.0" =
    self.by-version."umd"."2.1.0";
  by-version."umd"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "umd-2.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/umd/-/umd-2.1.0.tgz";
        name = "umd-2.1.0.tgz";
        sha1 = "4a6307b762f17f02d201b5fa154e673396c263cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."umd" or []);
    deps = {
      "rfile-1.0.0" = self.by-version."rfile"."1.0.0";
      "ruglify-1.0.0" = self.by-version."ruglify"."1.0.0";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "uglify-js-2.4.15" = self.by-version."uglify-js"."2.4.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "umd" ];
  };
  by-spec."umd"."~2.1.0" =
    self.by-version."umd"."2.1.0";
  by-spec."underscore"."*" =
    self.by-version."underscore"."1.7.0";
  by-version."underscore"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.7.0.tgz";
        name = "underscore-1.7.0.tgz";
        sha1 = "6bbaf0877500d36be34ecaa584e0db9fef035209";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  "underscore" = self.by-version."underscore"."1.7.0";
  by-spec."underscore"."1.6.x" =
    self.by-version."underscore"."1.6.0";
  by-version."underscore"."1.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.6.0.tgz";
        name = "underscore-1.6.0.tgz";
        sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore".">=1.1.7" =
    self.by-version."underscore"."1.7.0";
  by-spec."underscore".">=1.3.1" =
    self.by-version."underscore"."1.7.0";
  by-spec."underscore".">=1.5.0" =
    self.by-version."underscore"."1.7.0";
  by-spec."underscore"."~1.4.3" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        name = "underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore"."~1.4.4" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.5.2" =
    self.by-version."underscore"."1.5.2";
  by-version."underscore"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        name = "underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore.string"."~2.2.1" =
    self.by-version."underscore.string"."2.2.1";
  by-version."underscore.string"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "underscore.string-2.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.2.1.tgz";
        name = "underscore.string-2.2.1.tgz";
        sha1 = "d7c0fa2af5d5a1a67f4253daee98132e733f0f19";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  by-spec."underscore.string"."~2.3.1" =
    self.by-version."underscore.string"."2.3.3";
  by-version."underscore.string"."2.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "underscore.string-2.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz";
        name = "underscore.string-2.3.3.tgz";
        sha1 = "71c08bf6b428b1133f37e78fa3a21c82f7329b0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  by-spec."underscore.string"."~2.3.3" =
    self.by-version."underscore.string"."2.3.3";
  by-spec."unfunk-diff"."~0.0.1" =
    self.by-version."unfunk-diff"."0.0.2";
  by-version."unfunk-diff"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "unfunk-diff-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/unfunk-diff/-/unfunk-diff-0.0.2.tgz";
        name = "unfunk-diff-0.0.2.tgz";
        sha1 = "8560d6b5cb3dcb1ed4d541e7fe59cea514697578";
      })
    ];
    buildInputs =
      (self.nativeDeps."unfunk-diff" or []);
    deps = {
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "jsesc-0.4.3" = self.by-version."jsesc"."0.4.3";
      "ministyle-0.1.4" = self.by-version."ministyle"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "unfunk-diff" ];
  };
  by-spec."ungit"."*" =
    self.by-version."ungit"."0.8.3";
  by-version."ungit"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "ungit-0.8.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ungit/-/ungit-0.8.3.tgz";
        name = "ungit-0.8.3.tgz";
        sha1 = "93ea5734cb8408ef9ba3406102fa5254abfeaa4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."ungit" or []);
    deps = {
      "express-4.8.8" = self.by-version."express"."4.8.8";
      "superagent-0.18.2" = self.by-version."superagent"."0.18.2";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "temp-0.8.1" = self.by-version."temp"."0.8.1";
      "socket.io-0.9.17" = self.by-version."socket.io"."0.9.17";
      "moment-2.8.3" = self.by-version."moment"."2.8.3";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "rc-0.5.1" = self.by-version."rc"."0.5.1";
      "uuid-1.4.1" = self.by-version."uuid"."1.4.1";
      "winston-0.7.3" = self.by-version."winston"."0.7.3";
      "passport-0.2.1" = self.by-version."passport"."0.2.1";
      "passport-local-1.0.0" = self.by-version."passport-local"."1.0.0";
      "semver-3.0.1" = self.by-version."semver"."3.0.1";
      "forever-monitor-1.1.0" = self.by-version."forever-monitor"."1.1.0";
      "open-0.0.5" = self.by-version."open"."0.0.5";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "crossroads-0.12.0" = self.by-version."crossroads"."0.12.0";
      "signals-1.0.0" = self.by-version."signals"."1.0.0";
      "hasher-1.2.0" = self.by-version."hasher"."1.2.0";
      "blueimp-md5-1.1.0" = self.by-version."blueimp-md5"."1.1.0";
      "color-0.7.3" = self.by-version."color"."0.7.3";
      "keen.io-0.1.2" = self.by-version."keen.io"."0.1.2";
      "getmac-1.0.6" = self.by-version."getmac"."1.0.6";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "raven-0.7.2" = self.by-version."raven"."0.7.2";
      "knockout-3.2.0" = self.by-version."knockout"."3.2.0";
      "npm-registry-client-3.1.8" = self.by-version."npm-registry-client"."3.1.8";
      "npmconf-2.0.9" = self.by-version."npmconf"."2.0.9";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "body-parser-1.6.7" = self.by-version."body-parser"."1.6.7";
      "cookie-parser-1.3.3" = self.by-version."cookie-parser"."1.3.3";
      "express-session-1.7.6" = self.by-version."express-session"."1.7.6";
      "serve-static-1.5.4" = self.by-version."serve-static"."1.5.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ungit" ];
  };
  "ungit" = self.by-version."ungit"."0.8.3";
  by-spec."unique-stream"."^1.0.0" =
    self.by-version."unique-stream"."1.0.0";
  by-version."unique-stream"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "unique-stream-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/unique-stream/-/unique-stream-1.0.0.tgz";
        name = "unique-stream-1.0.0.tgz";
        sha1 = "d59a4a75427447d9aa6c91e70263f8d26a4b104b";
      })
    ];
    buildInputs =
      (self.nativeDeps."unique-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "unique-stream" ];
  };
  by-spec."update-notifier"."0.2.0" =
    self.by-version."update-notifier"."0.2.0";
  by-version."update-notifier"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "update-notifier-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.2.0.tgz";
        name = "update-notifier-0.2.0.tgz";
        sha1 = "a010c928adcf02090b8e0ce7fef6fb0a7cacc34a";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "configstore-0.3.1" = self.by-version."configstore"."0.3.1";
      "latest-version-0.2.0" = self.by-version."latest-version"."0.2.0";
      "semver-diff-0.1.0" = self.by-version."semver-diff"."0.1.0";
      "string-length-0.1.2" = self.by-version."string-length"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  by-spec."update-notifier"."~0.1.8" =
    self.by-version."update-notifier"."0.1.10";
  by-version."update-notifier"."0.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "update-notifier-0.1.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.1.10.tgz";
        name = "update-notifier-0.1.10.tgz";
        sha1 = "215cbe1053369f0d4a44f84b51eba7cb80484695";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier" or []);
    deps = {
      "chalk-0.4.0" = self.by-version."chalk"."0.4.0";
      "configstore-0.3.1" = self.by-version."configstore"."0.3.1";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  by-spec."uri-path"."0.0.2" =
    self.by-version."uri-path"."0.0.2";
  by-version."uri-path"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "uri-path-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uri-path/-/uri-path-0.0.2.tgz";
        name = "uri-path-0.0.2.tgz";
        sha1 = "803eb01f2feb17927dcce0f6187e72b75f53f554";
      })
    ];
    buildInputs =
      (self.nativeDeps."uri-path" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uri-path" ];
  };
  by-spec."url"."~0.10.1" =
    self.by-version."url"."0.10.1";
  by-version."url"."0.10.1" = lib.makeOverridable self.buildNodePackage {
    name = "url-0.10.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/url/-/url-0.10.1.tgz";
        name = "url-0.10.1.tgz";
        sha1 = "d8eba8f267cec7645ddd93d2cdcf2320c876d25b";
      })
    ];
    buildInputs =
      (self.nativeDeps."url" or []);
    deps = {
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "url" ];
  };
  by-spec."user-home"."^1.0.0" =
    self.by-version."user-home"."1.1.0";
  by-version."user-home"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "user-home-1.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/user-home/-/user-home-1.1.0.tgz";
        name = "user-home-1.1.0.tgz";
        sha1 = "1f4e6bce5458aeec4ac80ebcdcc66119c1070cdf";
      })
    ];
    buildInputs =
      (self.nativeDeps."user-home" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "user-home" ];
  };
  by-spec."useragent"."~2.0.4" =
    self.by-version."useragent"."2.0.10";
  by-version."useragent"."2.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "useragent-2.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/useragent/-/useragent-2.0.10.tgz";
        name = "useragent-2.0.10.tgz";
        sha1 = "af2c1cc641159361e4d830866eb716ba4679de33";
      })
    ];
    buildInputs =
      (self.nativeDeps."useragent" or []);
    deps = {
      "lru-cache-2.2.4" = self.by-version."lru-cache"."2.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "useragent" ];
  };
  by-spec."util"."0.10.3" =
    self.by-version."util"."0.10.3";
  by-version."util"."0.10.3" = lib.makeOverridable self.buildNodePackage {
    name = "util-0.10.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util/-/util-0.10.3.tgz";
        name = "util-0.10.3.tgz";
        sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."util" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "util" ];
  };
  by-spec."util"."0.4.9" =
    self.by-version."util"."0.4.9";
  by-version."util"."0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "util-0.4.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util/-/util-0.4.9.tgz";
        name = "util-0.4.9.tgz";
        sha1 = "d95d5830d2328ec17dee3c80bfc50c33562b75a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."util" or []);
    deps = {
      "events.node-0.4.9" = self.by-version."events.node"."0.4.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "util" ];
  };
  by-spec."util".">=0.10.3 <1" =
    self.by-version."util"."0.10.3";
  by-spec."util"."~0.10.1" =
    self.by-version."util"."0.10.3";
  by-spec."util-extend"."^1.0.1" =
    self.by-version."util-extend"."1.0.1";
  by-version."util-extend"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "util-extend-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util-extend/-/util-extend-1.0.1.tgz";
        name = "util-extend-1.0.1.tgz";
        sha1 = "bb703b79480293ddcdcfb3c6a9fea20f483415bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."util-extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "util-extend" ];
  };
  by-spec."utile"."0.1.x" =
    self.by-version."utile"."0.1.7";
  by-version."utile"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.1.7.tgz";
        name = "utile-0.1.7.tgz";
        sha1 = "55db180d54475339fd6dd9e2d14a4c0b52624b69";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile" or []);
    deps = {
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "deep-equal-0.2.1" = self.by-version."deep-equal"."0.2.1";
      "i-0.3.2" = self.by-version."i"."0.3.2";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "ncp-0.2.7" = self.by-version."ncp"."0.2.7";
      "rimraf-1.0.9" = self.by-version."rimraf"."1.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  by-spec."utile"."0.2.1" =
    self.by-version."utile"."0.2.1";
  by-version."utile"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.2.1.tgz";
        name = "utile-0.2.1.tgz";
        sha1 = "930c88e99098d6220834c356cbd9a770522d90d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "deep-equal-0.2.1" = self.by-version."deep-equal"."0.2.1";
      "i-0.3.2" = self.by-version."i"."0.3.2";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "ncp-0.4.2" = self.by-version."ncp"."0.4.2";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  by-spec."utile"."0.2.x" =
    self.by-version."utile"."0.2.1";
  by-spec."utile"."~0.2.1" =
    self.by-version."utile"."0.2.1";
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "utils-merge-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
        name = "utils-merge-1.0.0.tgz";
        sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
      })
    ];
    buildInputs =
      (self.nativeDeps."utils-merge" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "utils-merge" ];
  };
  by-spec."uuid"."1.4.1" =
    self.by-version."uuid"."1.4.1";
  by-version."uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "uuid-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uuid/-/uuid-1.4.1.tgz";
        name = "uuid-1.4.1.tgz";
        sha1 = "a337828580d426e375b8ee11bd2bf901a596e0b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."uuid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uuid" ];
  };
  by-spec."uuid"."~1.4.1" =
    self.by-version."uuid"."1.4.2";
  by-version."uuid"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "uuid-1.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uuid/-/uuid-1.4.2.tgz";
        name = "uuid-1.4.2.tgz";
        sha1 = "453019f686966a6df83cdc5244e7c990ecc332fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."uuid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uuid" ];
  };
  by-spec."v8flags"."^1.0.1" =
    self.by-version."v8flags"."1.0.1";
  by-version."v8flags"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "v8flags-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/v8flags/-/v8flags-1.0.1.tgz";
        name = "v8flags-1.0.1.tgz";
        sha1 = "a35328d86fd040ef9cdeed5387a8e5bcb25216ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."v8flags" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "v8flags" ];
  };
  by-spec."validator"."0.4.x" =
    self.by-version."validator"."0.4.28";
  by-version."validator"."0.4.28" = lib.makeOverridable self.buildNodePackage {
    name = "validator-0.4.28";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/validator/-/validator-0.4.28.tgz";
        name = "validator-0.4.28.tgz";
        sha1 = "311d439ae6cf3fbe6f85da6ebaccd0c7007986f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."validator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "validator" ];
  };
  by-spec."vargs"."~0.1.0" =
    self.by-version."vargs"."0.1.0";
  by-version."vargs"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "vargs-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vargs/-/vargs-0.1.0.tgz";
        name = "vargs-0.1.0.tgz";
        sha1 = "6b6184da6520cc3204ce1b407cac26d92609ebff";
      })
    ];
    buildInputs =
      (self.nativeDeps."vargs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "vargs" ];
  };
  by-spec."vary"."0.1.0" =
    self.by-version."vary"."0.1.0";
  by-version."vary"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "vary-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vary/-/vary-0.1.0.tgz";
        name = "vary-0.1.0.tgz";
        sha1 = "df0945899e93c0cc5bd18cc8321d9d21e74f6176";
      })
    ];
    buildInputs =
      (self.nativeDeps."vary" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "vary" ];
  };
  by-spec."vary"."~1.0.0" =
    self.by-version."vary"."1.0.0";
  by-version."vary"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "vary-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vary/-/vary-1.0.0.tgz";
        name = "vary-1.0.0.tgz";
        sha1 = "c5e76cec20d3820d8f2a96e7bee38731c34da1e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."vary" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "vary" ];
  };
  by-spec."vasync"."1.3.3" =
    self.by-version."vasync"."1.3.3";
  by-version."vasync"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "vasync-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vasync/-/vasync-1.3.3.tgz";
        name = "vasync-1.3.3.tgz";
        sha1 = "84917680717020b67e043902e63bc143174c8728";
      })
    ];
    buildInputs =
      (self.nativeDeps."vasync" or []);
    deps = {
      "jsprim-0.3.0" = self.by-version."jsprim"."0.3.0";
      "verror-1.1.0" = self.by-version."verror"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vasync" ];
  };
  by-spec."vasync"."1.4.3" =
    self.by-version."vasync"."1.4.3";
  by-version."vasync"."1.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "vasync-1.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vasync/-/vasync-1.4.3.tgz";
        name = "vasync-1.4.3.tgz";
        sha1 = "c86d52e2b71613d29eedf159f3135dbe749cee37";
      })
    ];
    buildInputs =
      (self.nativeDeps."vasync" or []);
    deps = {
      "jsprim-0.3.0" = self.by-version."jsprim"."0.3.0";
      "verror-1.1.0" = self.by-version."verror"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vasync" ];
  };
  by-spec."verror"."1.1.0" =
    self.by-version."verror"."1.1.0";
  by-version."verror"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "verror-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.1.0.tgz";
        name = "verror-1.1.0.tgz";
        sha1 = "2a4b4eb14a207051e75a6f94ee51315bf173a1b0";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror" or []);
    deps = {
      "extsprintf-1.0.0" = self.by-version."extsprintf"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  by-spec."verror"."1.3.3" =
    self.by-version."verror"."1.3.3";
  by-version."verror"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "verror-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.3.3.tgz";
        name = "verror-1.3.3.tgz";
        sha1 = "8a6a4ac3a8c774b6f687fece49bdffd78552e2cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror" or []);
    deps = {
      "extsprintf-1.0.0" = self.by-version."extsprintf"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  by-spec."verror"."1.3.6" =
    self.by-version."verror"."1.3.6";
  by-version."verror"."1.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "verror-1.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
        name = "verror-1.3.6.tgz";
        sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror" or []);
    deps = {
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  by-spec."vhost"."~3.0.0" =
    self.by-version."vhost"."3.0.0";
  by-version."vhost"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "vhost-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vhost/-/vhost-3.0.0.tgz";
        name = "vhost-3.0.0.tgz";
        sha1 = "2d0ec59a3e012278b65adbe17c1717a5a5023045";
      })
    ];
    buildInputs =
      (self.nativeDeps."vhost" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "vhost" ];
  };
  by-spec."view-helpers"."*" =
    self.by-version."view-helpers"."0.1.5";
  by-version."view-helpers"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "view-helpers-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/view-helpers/-/view-helpers-0.1.5.tgz";
        name = "view-helpers-0.1.5.tgz";
        sha1 = "175d220a6afeca8e3b497b003e2337bcc596f761";
      })
    ];
    buildInputs =
      (self.nativeDeps."view-helpers" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "view-helpers" ];
  };
  "view-helpers" = self.by-version."view-helpers"."0.1.5";
  by-spec."vinyl"."^0.2.3" =
    self.by-version."vinyl"."0.2.3";
  by-version."vinyl"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "vinyl-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vinyl/-/vinyl-0.2.3.tgz";
        name = "vinyl-0.2.3.tgz";
        sha1 = "bca938209582ec5a49ad538a00fa1f125e513252";
      })
    ];
    buildInputs =
      (self.nativeDeps."vinyl" or []);
    deps = {
      "clone-stats-0.0.1" = self.by-version."clone-stats"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vinyl" ];
  };
  by-spec."vinyl"."^0.4.0" =
    self.by-version."vinyl"."0.4.3";
  by-version."vinyl"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "vinyl-0.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vinyl/-/vinyl-0.4.3.tgz";
        name = "vinyl-0.4.3.tgz";
        sha1 = "19f61a1b28e72b4c50697889dbe91d7503943ecf";
      })
    ];
    buildInputs =
      (self.nativeDeps."vinyl" or []);
    deps = {
      "clone-stats-0.0.1" = self.by-version."clone-stats"."0.0.1";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vinyl" ];
  };
  by-spec."vinyl-fs"."^0.3.0" =
    self.by-version."vinyl-fs"."0.3.10";
  by-version."vinyl-fs"."0.3.10" = lib.makeOverridable self.buildNodePackage {
    name = "vinyl-fs-0.3.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vinyl-fs/-/vinyl-fs-0.3.10.tgz";
        name = "vinyl-fs-0.3.10.tgz";
        sha1 = "f59ac977cb040e95df865ad34cdeb00f57f31f47";
      })
    ];
    buildInputs =
      (self.nativeDeps."vinyl-fs" or []);
    deps = {
      "glob-stream-3.1.15" = self.by-version."glob-stream"."3.1.15";
      "glob-watcher-0.0.6" = self.by-version."glob-watcher"."0.0.6";
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "strip-bom-1.0.0" = self.by-version."strip-bom"."1.0.0";
      "through2-0.6.3" = self.by-version."through2"."0.6.3";
      "vinyl-0.4.3" = self.by-version."vinyl"."0.4.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vinyl-fs" ];
  };
  by-spec."vinyl-fs"."^0.3.3" =
    self.by-version."vinyl-fs"."0.3.10";
  by-spec."vm-browserify"."~0.0.1" =
    self.by-version."vm-browserify"."0.0.4";
  by-version."vm-browserify"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "vm-browserify-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vm-browserify/-/vm-browserify-0.0.4.tgz";
        name = "vm-browserify-0.0.4.tgz";
        sha1 = "5d7ea45bbef9e4a6ff65f95438e0a87c357d5a73";
      })
    ];
    buildInputs =
      (self.nativeDeps."vm-browserify" or []);
    deps = {
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vm-browserify" ];
  };
  by-spec."void-elements"."~1.0.0" =
    self.by-version."void-elements"."1.0.0";
  by-version."void-elements"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "void-elements-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/void-elements/-/void-elements-1.0.0.tgz";
        name = "void-elements-1.0.0.tgz";
        sha1 = "6e5db1e35d591f5ac690ce1a340f793a817b2c2a";
      })
    ];
    buildInputs =
      (self.nativeDeps."void-elements" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "void-elements" ];
  };
  by-spec."vows".">=0.5.13" =
    self.by-version."vows"."0.7.0";
  by-version."vows"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "vows-0.7.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vows/-/vows-0.7.0.tgz";
        name = "vows-0.7.0.tgz";
        sha1 = "dd0065f110ba0c0a6d63e844851c3208176d5867";
      })
    ];
    buildInputs =
      (self.nativeDeps."vows" or []);
    deps = {
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vows" ];
  };
  by-spec."walk"."*" =
    self.by-version."walk"."2.3.4";
  by-version."walk"."2.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "walk-2.3.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.3.4.tgz";
        name = "walk-2.3.4.tgz";
        sha1 = "06ce1541535313e8acc28e92eb425e9b64f4c500";
      })
    ];
    buildInputs =
      (self.nativeDeps."walk" or []);
    deps = {
      "foreachasync-3.0.0" = self.by-version."foreachasync"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
  };
  "walk" = self.by-version."walk"."2.3.4";
  by-spec."walk"."~2.2.1" =
    self.by-version."walk"."2.2.1";
  by-version."walk"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "walk-2.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.2.1.tgz";
        name = "walk-2.2.1.tgz";
        sha1 = "5ada1f8e49e47d4b7445d8be7a2e1e631ab43016";
      })
    ];
    buildInputs =
      (self.nativeDeps."walk" or []);
    deps = {
      "forEachAsync-2.2.1" = self.by-version."forEachAsync"."2.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
  };
  by-spec."watch"."0.5.x" =
    self.by-version."watch"."0.5.1";
  by-version."watch"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "watch-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.5.1.tgz";
        name = "watch-0.5.1.tgz";
        sha1 = "50ea3a056358c98073e0bca59956de4afd20b213";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "watch" ];
  };
  by-spec."watch"."~0.8.0" =
    self.by-version."watch"."0.8.0";
  by-version."watch"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "watch-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.8.0.tgz";
        name = "watch-0.8.0.tgz";
        sha1 = "1bb0eea53defe6e621e9c8c63c0358007ecbdbcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "watch" ];
  };
  by-spec."wcwidth"."^1.0.0" =
    self.by-version."wcwidth"."1.0.0";
  by-version."wcwidth"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "wcwidth-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wcwidth/-/wcwidth-1.0.0.tgz";
        name = "wcwidth-1.0.0.tgz";
        sha1 = "02d059ff7a8fc741e0f6b5da1e69b2b40daeca6f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wcwidth" or []);
    deps = {
      "defaults-1.0.0" = self.by-version."defaults"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "wcwidth" ];
  };
  by-spec."wd"."~0.3.4" =
    self.by-version."wd"."0.3.9";
  by-version."wd"."0.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "wd-0.3.9";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wd/-/wd-0.3.9.tgz";
        name = "wd-0.3.9.tgz";
        sha1 = "857130517e5976203653dd325edc4bdc2dbd946f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wd" or []);
    deps = {
      "archiver-0.11.0" = self.by-version."archiver"."0.11.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "underscore.string-2.3.3" = self.by-version."underscore.string"."2.3.3";
      "vargs-0.1.0" = self.by-version."vargs"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "wd" ];
  };
  by-spec."weak-map"."^1.0.4" =
    self.by-version."weak-map"."1.0.5";
  by-version."weak-map"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "weak-map-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/weak-map/-/weak-map-1.0.5.tgz";
        name = "weak-map-1.0.5.tgz";
        sha1 = "79691584d98607f5070bd3b70a40e6bb22e401eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."weak-map" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "weak-map" ];
  };
  by-spec."webdrvr"."*" =
    self.by-version."webdrvr"."2.43.0-0";
  by-version."webdrvr"."2.43.0-0" = lib.makeOverridable self.buildNodePackage {
    name = "webdrvr-2.43.0-0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/webdrvr/-/webdrvr-2.43.0-0.tgz";
        name = "webdrvr-2.43.0-0.tgz";
        sha1 = "b022266b1d5fba25e22d923337c55587048c2953";
      })
    ];
    buildInputs =
      (self.nativeDeps."webdrvr" or []);
    deps = {
      "adm-zip-0.4.4" = self.by-version."adm-zip"."0.4.4";
      "kew-0.1.7" = self.by-version."kew"."0.1.7";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "npmconf-0.1.16" = self.by-version."npmconf"."0.1.16";
      "phantomjs-1.9.11" = self.by-version."phantomjs"."1.9.11";
      "tmp-0.0.24" = self.by-version."tmp"."0.0.24";
      "follow-redirects-0.0.3" = self.by-version."follow-redirects"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "webdrvr" ];
  };
  "webdrvr" = self.by-version."webdrvr"."2.43.0-0";
  by-spec."websocket-driver".">=0.3.1" =
    self.by-version."websocket-driver"."0.3.6";
  by-version."websocket-driver"."0.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "websocket-driver-0.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.3.6.tgz";
        name = "websocket-driver-0.3.6.tgz";
        sha1 = "85d03e26be0b820b4466a78bbf36a6596bc2aa75";
      })
    ];
    buildInputs =
      (self.nativeDeps."websocket-driver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "websocket-driver" ];
  };
  by-spec."websocket-driver".">=0.3.6" =
    self.by-version."websocket-driver"."0.3.6";
  by-spec."when"."~3.4.6" =
    self.by-version."when"."3.4.6";
  by-version."when"."3.4.6" = lib.makeOverridable self.buildNodePackage {
    name = "when-3.4.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/when/-/when-3.4.6.tgz";
        name = "when-3.4.6.tgz";
        sha1 = "8fbcb7cc1439d2c3a68c431f1516e6dcce9ad28c";
      })
    ];
    buildInputs =
      (self.nativeDeps."when" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "when" ];
  };
  by-spec."which"."1" =
    self.by-version."which"."1.0.5";
  by-version."which"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.5.tgz";
        name = "which-1.0.5.tgz";
        sha1 = "5630d6819dda692f1464462e7956cb42c0842739";
      })
    ];
    buildInputs =
      (self.nativeDeps."which" or []);
    deps = {
    };
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
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winser/-/winser-0.1.6.tgz";
        name = "winser-0.1.6.tgz";
        sha1 = "08663dc32878a12bbce162d840da5097b48466c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."winser" or []);
    deps = {
      "sequence-2.2.1" = self.by-version."sequence"."2.2.1";
      "commander-1.3.1" = self.by-version."commander"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winser" ];
  };
  by-spec."winston"."*" =
    self.by-version."winston"."0.8.1";
  by-version."winston"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.8.1.tgz";
        name = "winston-0.8.1.tgz";
        sha1 = "86bc9ec6c02aefe5c6dfdb88f3aff1b19d629216";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  "winston" = self.by-version."winston"."0.8.1";
  by-spec."winston"."0.6.2" =
    self.by-version."winston"."0.6.2";
  by-version."winston"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.6.2.tgz";
        name = "winston-0.6.2.tgz";
        sha1 = "4144fe2586cdc19a612bf8c035590132c9064bd2";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.2.3" = self.by-version."pkginfo"."0.2.3";
      "request-2.9.203" = self.by-version."request"."2.9.203";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."0.6.x" =
    self.by-version."winston"."0.6.2";
  by-spec."winston"."0.7.2" =
    self.by-version."winston"."0.7.2";
  by-version."winston"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.7.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.2.tgz";
        name = "winston-0.7.2.tgz";
        sha1 = "2570ae1aa1d8a9401e8d5a88362e1cf936550ceb";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "request-2.16.6" = self.by-version."request"."2.16.6";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."0.8.0" =
    self.by-version."winston"."0.8.0";
  by-version."winston"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.8.0.tgz";
        name = "winston-0.8.0.tgz";
        sha1 = "61d0830fa699706212206b0a2b5ca69a93043668";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."0.8.x" =
    self.by-version."winston"."0.8.1";
  by-spec."winston"."~0.7.2" =
    self.by-version."winston"."0.7.3";
  by-version."winston"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.3.tgz";
        name = "winston-0.7.3.tgz";
        sha1 = "7ae313ba73fcdc2ecb4aa2f9cd446e8298677266";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "request-2.16.6" = self.by-version."request"."2.16.6";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."~0.7.3" =
    self.by-version."winston"."0.7.3";
  by-spec."with"."~1.1.0" =
    self.by-version."with"."1.1.1";
  by-version."with"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "with-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-1.1.1.tgz";
        name = "with-1.1.1.tgz";
        sha1 = "66bd6664deb318b2482dd0424ccdebe822434ac0";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = {
      "uglify-js-2.4.0" = self.by-version."uglify-js"."2.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  by-spec."with"."~2.0.0" =
    self.by-version."with"."2.0.0";
  by-version."with"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "with-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-2.0.0.tgz";
        name = "with-2.0.0.tgz";
        sha1 = "ec01ff021db9df05639047147ede012f5e6d0afd";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = {
      "uglify-js-2.4.0" = self.by-version."uglify-js"."2.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  by-spec."with"."~3.0.0" =
    self.by-version."with"."3.0.1";
  by-version."with"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "with-3.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-3.0.1.tgz";
        name = "with-3.0.1.tgz";
        sha1 = "08354da410243cf6173fb142bb04e6c66f96f854";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = {
      "uglify-js-2.4.15" = self.by-version."uglify-js"."2.4.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  by-spec."wordwrap"."0.0.x" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "wordwrap-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        name = "wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  by-spec."wordwrap".">=0.0.1 <0.1.0" =
    self.by-version."wordwrap"."0.0.2";
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "wrappy-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
        name = "wrappy-1.0.1.tgz";
        sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
      })
    ];
    buildInputs =
      (self.nativeDeps."wrappy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "wrappy" ];
  };
  by-spec."wrappy"."~1.0.1" =
    self.by-version."wrappy"."1.0.1";
  by-spec."wrench"."~1.5.0" =
    self.by-version."wrench"."1.5.8";
  by-version."wrench"."1.5.8" = lib.makeOverridable self.buildNodePackage {
    name = "wrench-1.5.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wrench/-/wrench-1.5.8.tgz";
        name = "wrench-1.5.8.tgz";
        sha1 = "7a31c97f7869246d76c5cf2f5c977a1c4c8e5ab5";
      })
    ];
    buildInputs =
      (self.nativeDeps."wrench" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "wrench" ];
  };
  by-spec."wrench"."~1.5.4" =
    self.by-version."wrench"."1.5.8";
  by-spec."write-file-atomic"."~1.1.0" =
    self.by-version."write-file-atomic"."1.1.0";
  by-version."write-file-atomic"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "write-file-atomic-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/write-file-atomic/-/write-file-atomic-1.1.0.tgz";
        name = "write-file-atomic-1.1.0.tgz";
        sha1 = "e114cfb8f82188353f98217c5945451c9b4dc060";
      })
    ];
    buildInputs =
      (self.nativeDeps."write-file-atomic" or []);
    deps = {
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "write-file-atomic" ];
  };
  by-spec."ws"."0.4.x" =
    self.by-version."ws"."0.4.32";
  by-version."ws"."0.4.32" = lib.makeOverridable self.buildNodePackage {
    name = "ws-0.4.32";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ws/-/ws-0.4.32.tgz";
        name = "ws-0.4.32.tgz";
        sha1 = "787a6154414f3c99ed83c5772153b20feb0cec32";
      })
    ];
    buildInputs =
      (self.nativeDeps."ws" or []);
    deps = {
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
      "nan-1.0.0" = self.by-version."nan"."1.0.0";
      "tinycolor-0.0.1" = self.by-version."tinycolor"."0.0.1";
      "options-0.0.6" = self.by-version."options"."0.0.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ws" ];
  };
  by-spec."ws"."~0.4.31" =
    self.by-version."ws"."0.4.32";
  by-spec."wu"."*" =
    self.by-version."wu"."2.0.0";
  by-version."wu"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "wu-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wu/-/wu-2.0.0.tgz";
        name = "wu-2.0.0.tgz";
        sha1 = "abda06a014dd1c54c2163862f5c2c5230721bc27";
      })
    ];
    buildInputs =
      (self.nativeDeps."wu" or []);
    deps = {
      "traceur-0.0.55" = self.by-version."traceur"."0.0.55";
    };
    peerDependencies = [
    ];
    passthru.names = [ "wu" ];
  };
  "wu" = self.by-version."wu"."2.0.0";
  by-spec."x509"."*" =
    self.by-version."x509"."0.1.4";
  by-version."x509"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "x509-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/x509/-/x509-0.1.4.tgz";
        name = "x509-0.1.4.tgz";
        sha1 = "08d016ed165db0c68a192edeb1cdca0f5d43cb22";
      })
    ];
    buildInputs =
      (self.nativeDeps."x509" or []);
    deps = {
      "nan-1.3.0" = self.by-version."nan"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "x509" ];
  };
  "x509" = self.by-version."x509"."0.1.4";
  by-spec."xml2js"."0.2.4" =
    self.by-version."xml2js"."0.2.4";
  by-version."xml2js"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.4.tgz";
        name = "xml2js-0.2.4.tgz";
        sha1 = "9a5b577fa1e6cdf8923d5e1372f7a3188436e44d";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = {
      "sax-0.6.1" = self.by-version."sax"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js"."0.2.6" =
    self.by-version."xml2js"."0.2.6";
  by-version."xml2js"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.6.tgz";
        name = "xml2js-0.2.6.tgz";
        sha1 = "d209c4e4dda1fc9c452141ef41c077f5adfdf6c4";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = {
      "sax-0.4.2" = self.by-version."sax"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js"."0.4.4" =
    self.by-version."xml2js"."0.4.4";
  by-version."xml2js"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.4.4.tgz";
        name = "xml2js-0.4.4.tgz";
        sha1 = "3111010003008ae19240eba17497b57c729c555d";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = {
      "sax-0.6.1" = self.by-version."sax"."0.6.1";
      "xmlbuilder-2.4.4" = self.by-version."xmlbuilder"."2.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js".">= 0.0.1" =
    self.by-version."xml2js"."0.4.4";
  by-spec."xml2js".">=0.1.7" =
    self.by-version."xml2js"."0.4.4";
  by-spec."xml2js"."^0.4.4" =
    self.by-version."xml2js"."0.4.4";
  by-spec."xmlbuilder"."0.4.2" =
    self.by-version."xmlbuilder"."0.4.2";
  by-version."xmlbuilder"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.2.tgz";
        name = "xmlbuilder-0.4.2.tgz";
        sha1 = "1776d65f3fdbad470a08d8604cdeb1c4e540ff83";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  by-spec."xmlbuilder".">=1.0.0" =
    self.by-version."xmlbuilder"."2.4.4";
  by-version."xmlbuilder"."2.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-2.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-2.4.4.tgz";
        name = "xmlbuilder-2.4.4.tgz";
        sha1 = "6e2a84da5df79e11abb0a05bad2f0acc12e33893";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder" or []);
    deps = {
      "lodash-node-2.4.1" = self.by-version."lodash-node"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  by-spec."xmldom"."~0.1.16" =
    self.by-version."xmldom"."0.1.19";
  by-version."xmldom"."0.1.19" = lib.makeOverridable self.buildNodePackage {
    name = "xmldom-0.1.19";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmldom/-/xmldom-0.1.19.tgz";
        name = "xmldom-0.1.19.tgz";
        sha1 = "631fc07776efd84118bf25171b37ed4d075a0abc";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmldom" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xmldom" ];
  };
  by-spec."xmlhttprequest"."1.4.2" =
    self.by-version."xmlhttprequest"."1.4.2";
  by-version."xmlhttprequest"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "xmlhttprequest-1.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlhttprequest/-/xmlhttprequest-1.4.2.tgz";
        name = "xmlhttprequest-1.4.2.tgz";
        sha1 = "01453a1d9bed1e8f172f6495bbf4c8c426321500";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlhttprequest" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xmlhttprequest" ];
  };
  by-spec."xoauth2"."~0.1.8" =
    self.by-version."xoauth2"."0.1.8";
  by-version."xoauth2"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "xoauth2-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xoauth2/-/xoauth2-0.1.8.tgz";
        name = "xoauth2-0.1.8.tgz";
        sha1 = "b916ff10ecfb54320f16f24a3e975120653ab0d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xoauth2" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xoauth2" ];
  };
  by-spec."xtend".">=4.0.0 <4.1.0-0" =
    self.by-version."xtend"."4.0.0";
  by-version."xtend"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "xtend-4.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-4.0.0.tgz";
        name = "xtend-4.0.0.tgz";
        sha1 = "8bc36ff87aedbe7ce9eaf0bca36b2354a743840f";
      })
    ];
    buildInputs =
      (self.nativeDeps."xtend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xtend" ];
  };
  by-spec."xtend"."^3.0.0" =
    self.by-version."xtend"."3.0.0";
  by-version."xtend"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "xtend-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-3.0.0.tgz";
        name = "xtend-3.0.0.tgz";
        sha1 = "5cce7407baf642cba7becda568111c493f59665a";
      })
    ];
    buildInputs =
      (self.nativeDeps."xtend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xtend" ];
  };
  by-spec."xtend"."^4.0.0" =
    self.by-version."xtend"."4.0.0";
  by-spec."xtend"."~2.1.1" =
    self.by-version."xtend"."2.1.2";
  by-version."xtend"."2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "xtend-2.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-2.1.2.tgz";
        name = "xtend-2.1.2.tgz";
        sha1 = "6efecc2a4dad8e6962c4901b337ce7ba87b5d28b";
      })
    ];
    buildInputs =
      (self.nativeDeps."xtend" or []);
    deps = {
      "object-keys-0.4.0" = self.by-version."object-keys"."0.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xtend" ];
  };
  by-spec."xtend"."~2.1.2" =
    self.by-version."xtend"."2.1.2";
  by-spec."xtend"."~3.0.0" =
    self.by-version."xtend"."3.0.0";
  by-spec."yargs"."~1.2.1" =
    self.by-version."yargs"."1.2.6";
  by-version."yargs"."1.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "yargs-1.2.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yargs/-/yargs-1.2.6.tgz";
        name = "yargs-1.2.6.tgz";
        sha1 = "9c7b4a82fd5d595b2bf17ab6dcc43135432fe34b";
      })
    ];
    buildInputs =
      (self.nativeDeps."yargs" or []);
    deps = {
      "minimist-0.1.0" = self.by-version."minimist"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "yargs" ];
  };
  by-spec."zeparser"."0.0.5" =
    self.by-version."zeparser"."0.0.5";
  by-version."zeparser"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "zeparser-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zeparser/-/zeparser-0.0.5.tgz";
        name = "zeparser-0.0.5.tgz";
        sha1 = "03726561bc268f2e5444f54c665b7fd4a8c029e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."zeparser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "zeparser" ];
  };
  by-spec."zip-stream"."~0.4.0" =
    self.by-version."zip-stream"."0.4.1";
  by-version."zip-stream"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "zip-stream-0.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zip-stream/-/zip-stream-0.4.1.tgz";
        name = "zip-stream-0.4.1.tgz";
        sha1 = "4ea795a8ce19e9fab49a31d1d0877214159f03a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."zip-stream" or []);
    deps = {
      "compress-commons-0.1.6" = self.by-version."compress-commons"."0.1.6";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "readable-stream-1.0.33-1" = self.by-version."readable-stream"."1.0.33-1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "zip-stream" ];
  };
  by-spec."zlib-browserify"."^0.0.3" =
    self.by-version."zlib-browserify"."0.0.3";
  by-version."zlib-browserify"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "zlib-browserify-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zlib-browserify/-/zlib-browserify-0.0.3.tgz";
        name = "zlib-browserify-0.0.3.tgz";
        sha1 = "240ccdbfd0203fa842b130deefb1414122c8cc50";
      })
    ];
    buildInputs =
      (self.nativeDeps."zlib-browserify" or []);
    deps = {
      "tape-0.2.2" = self.by-version."tape"."0.2.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "zlib-browserify" ];
  };
}
