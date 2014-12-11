{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."7f"."*" =
    self.by-version."7f"."1.1.3";
  by-version."7f"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "7f-1.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/7f/-/7f-1.1.3.tgz";
        name = "7f-1.1.3.tgz";
        sha1 = "88d2cb194fceeb96db7b24bc710b283451e7a851";
      })
    ];
    buildInputs =
      (self.nativeDeps."7f" or []);
    deps = {
      "bits-0.1.1" = self.by-version."bits"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "7f" ];
  };
  "7f" = self.by-version."7f"."1.1.3";
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
  by-spec."JSONStream"."~0.6.4" =
    self.by-version."JSONStream"."0.6.4";
  by-version."JSONStream"."0.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "JSONStream-0.6.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/JSONStream/-/JSONStream-0.6.4.tgz";
        name = "JSONStream-0.6.4.tgz";
        sha1 = "4b2c8063f8f512787b2375f7ee9db69208fa2dcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."JSONStream" or []);
    deps = {
      "jsonparse-0.0.5" = self.by-version."jsonparse"."0.0.5";
      "through-2.2.7" = self.by-version."through"."2.2.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "JSONStream" ];
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
  by-spec."accepts"."~1.1.0" =
    self.by-version."accepts"."1.1.3";
  by-version."accepts"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "accepts-1.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.1.3.tgz";
        name = "accepts-1.1.3.tgz";
        sha1 = "14d99f8ee3ea69f8709d4bd17ffe153bef0f6c6d";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = {
      "mime-types-2.0.3" = self.by-version."mime-types"."2.0.3";
      "negotiator-0.4.9" = self.by-version."negotiator"."0.4.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
  by-spec."accepts"."~1.1.2" =
    self.by-version."accepts"."1.1.3";
  by-spec."accepts"."~1.1.3" =
    self.by-version."accepts"."1.1.3";
  by-spec."acorn"."^0.8.0" =
    self.by-version."acorn"."0.8.0";
  by-version."acorn"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "acorn-0.8.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/acorn/-/acorn-0.8.0.tgz";
        name = "acorn-0.8.0.tgz";
        sha1 = "e07ae6721110b22878242950ae2e96658b0aac7e";
      })
    ];
    buildInputs =
      (self.nativeDeps."acorn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "acorn" ];
  };
  by-spec."acorn"."~0.9.0" =
    self.by-version."acorn"."0.9.0";
  by-version."acorn"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "acorn-0.9.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/acorn/-/acorn-0.9.0.tgz";
        name = "acorn-0.9.0.tgz";
        sha1 = "67728e0acad6cc61dfb901c121837694db5b926b";
      })
    ];
    buildInputs =
      (self.nativeDeps."acorn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "acorn" ];
  };
  by-spec."acorn-globals"."^1.0.0" =
    self.by-version."acorn-globals"."1.0.1";
  by-version."acorn-globals"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "acorn-globals-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/acorn-globals/-/acorn-globals-1.0.1.tgz";
        name = "acorn-globals-1.0.1.tgz";
        sha1 = "00013368c24311f9fc2c2d420df6c311b9df64d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."acorn-globals" or []);
    deps = {
      "acorn-0.8.0" = self.by-version."acorn"."0.8.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "acorn-globals" ];
  };
  by-spec."acorn-globals"."^1.0.1" =
    self.by-version."acorn-globals"."1.0.1";
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
  by-spec."addr-to-ip-port"."^1.0.0" =
    self.by-version."addr-to-ip-port"."1.4.0";
  by-version."addr-to-ip-port"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "addr-to-ip-port-1.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/addr-to-ip-port/-/addr-to-ip-port-1.4.0.tgz";
        name = "addr-to-ip-port-1.4.0.tgz";
        sha1 = "9b784874d8a6a284c64d453f2c0f6430f201a8db";
      })
    ];
    buildInputs =
      (self.nativeDeps."addr-to-ip-port" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "addr-to-ip-port" ];
  };
  by-spec."addr-to-ip-port"."^1.0.1" =
    self.by-version."addr-to-ip-port"."1.4.0";
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
  by-spec."airplay-js"."^0.2.5" =
    self.by-version."airplay-js"."0.2.6";
  by-version."airplay-js"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "airplay-js-0.2.6";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/airplay-js/-/airplay-js-0.2.6.tgz";
        name = "airplay-js-0.2.6.tgz";
        sha1 = "a7038ed3559d9dd6d8c96d553b56158bf9434f7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."airplay-js" or []);
    deps = {
      "mdns-js-0.2.2" = self.by-version."mdns-js"."0.2.2";
      "plist-with-patches-0.5.1" = self.by-version."plist-with-patches"."0.5.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "airplay-js" ];
  };
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
  by-spec."ansi"."~0.1.2" =
    self.by-version."ansi"."0.1.2";
  by-version."ansi"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-0.1.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.1.2.tgz";
        name = "ansi-0.1.2.tgz";
        sha1 = "2627e29498f06e2a1c2ece9c21e28fd494430827";
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
  by-spec."ansi"."~0.2.1" =
    self.by-version."ansi"."0.2.1";
  by-version."ansi"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-0.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.2.1.tgz";
        name = "ansi-0.2.1.tgz";
        sha1 = "3ab568ec18cd0ab7753c83117d57dad684a1c017";
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
  by-spec."archiver"."~0.12.0" =
    self.by-version."archiver"."0.12.0";
  by-version."archiver"."0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "archiver-0.12.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archiver/-/archiver-0.12.0.tgz";
        name = "archiver-0.12.0.tgz";
        sha1 = "b8ccde2508cab9092bb7106630139c0f39a280cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."archiver" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "buffer-crc32-0.2.4" = self.by-version."buffer-crc32"."0.2.4";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "lazystream-0.1.0" = self.by-version."lazystream"."0.1.0";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "tar-stream-1.0.2" = self.by-version."tar-stream"."1.0.2";
      "zip-stream-0.4.1" = self.by-version."zip-stream"."0.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "archiver" ];
  };
  by-spec."archy"."0" =
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
  by-spec."archy"."0.0.2" =
    self.by-version."archy"."0.0.2";
  by-spec."archy"."^1.0.0" =
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
  by-spec."archy"."~1.0.0" =
    self.by-version."archy"."1.0.0";
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
  by-spec."asn1.js".">=0.6.0-0 >=0.6.4-0 <0.7.0-0" =
    self.by-version."asn1.js"."0.6.5";
  by-version."asn1.js"."0.6.5" = lib.makeOverridable self.buildNodePackage {
    name = "asn1.js-0.6.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1.js/-/asn1.js-0.6.5.tgz";
        name = "asn1.js-0.6.5.tgz";
        sha1 = "92219d0eeaffa92bd9c26da38f66a990b63c4579";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1.js" or []);
    deps = {
      "bn.js-0.15.2" = self.by-version."bn.js"."0.15.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "asn1.js" ];
  };
  by-spec."asn1.js"."^0.6.0" =
    self.by-version."asn1.js"."0.6.5";
  by-spec."asn1.js"."^0.6.4" =
    self.by-version."asn1.js"."0.6.5";
  by-spec."asn1.js-rfc3280"."^0.5.1" =
    self.by-version."asn1.js-rfc3280"."0.5.1";
  by-version."asn1.js-rfc3280"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "asn1.js-rfc3280-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1.js-rfc3280/-/asn1.js-rfc3280-0.5.1.tgz";
        name = "asn1.js-rfc3280-0.5.1.tgz";
        sha1 = "86b527b34fda63a571647c7ef54d4a680c0be122";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1.js-rfc3280" or []);
    deps = {
    };
    peerDependencies = [
      self.by-version."asn1.js"."0.6.5"
    ];
    passthru.names = [ "asn1.js-rfc3280" ];
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
  by-spec."astw"."~0.0.0" =
    self.by-version."astw"."0.0.0";
  by-version."astw"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "astw-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/astw/-/astw-0.0.0.tgz";
        name = "astw-0.0.0.tgz";
        sha1 = "4490866a3ef116aaf91adba63ca7ddf70b6d59bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."astw" or []);
    deps = {
      "esprima-1.0.2" = self.by-version."esprima"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "astw" ];
  };
  by-spec."astw"."~0.1.0" =
    self.by-version."astw"."0.1.0";
  by-version."astw"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "astw-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/astw/-/astw-0.1.0.tgz";
        name = "astw-0.1.0.tgz";
        sha1 = "098be2758a6e9e9e15465d4fc4ba36265de11085";
      })
    ];
    buildInputs =
      (self.nativeDeps."astw" or []);
    deps = {
      "esprima-six-0.0.3" = self.by-version."esprima-six"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "astw" ];
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
  by-spec."async-each"."~0.1.5" =
    self.by-version."async-each"."0.1.6";
  by-version."async-each"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "async-each-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async-each/-/async-each-0.1.6.tgz";
        name = "async-each-0.1.6.tgz";
        sha1 = "b67e99edcddf96541e44af56290cd7d5c6e70439";
      })
    ];
    buildInputs =
      (self.nativeDeps."async-each" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async-each" ];
  };
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
    self.by-version."aws-sdk"."2.0.29";
  by-version."aws-sdk"."2.0.29" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-2.0.29";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-2.0.29.tgz";
        name = "aws-sdk-2.0.29.tgz";
        sha1 = "01c8f18d43a1174637e04dad20cd04673385e18b";
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
  "aws-sdk" = self.by-version."aws-sdk"."2.0.29";
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
  by-spec."backoff"."~2.3.0" =
    self.by-version."backoff"."2.3.0";
  by-version."backoff"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "backoff-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backoff/-/backoff-2.3.0.tgz";
        name = "backoff-2.3.0.tgz";
        sha1 = "ee7c7e38093f92e472859db635e7652454fc21ea";
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
  by-spec."base64-js"."0.0.6" =
    self.by-version."base64-js"."0.0.6";
  by-version."base64-js"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "base64-js-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64-js/-/base64-js-0.0.6.tgz";
        name = "base64-js-0.0.6.tgz";
        sha1 = "7b859f79f0bbbd55867ba67a7fab397e24a20947";
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
  by-spec."base64-js"."~0.0.4" =
    self.by-version."base64-js"."0.0.7";
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
  by-spec."bencode"."^0.6.0" =
    self.by-version."bencode"."0.6.0";
  by-version."bencode"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "bencode-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bencode/-/bencode-0.6.0.tgz";
        name = "bencode-0.6.0.tgz";
        sha1 = "04d6190e1d7467c56a969e1a94d1668076eac050";
      })
    ];
    buildInputs =
      (self.nativeDeps."bencode" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bencode" ];
  };
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
  by-spec."bindings"."1.1.0" =
    self.by-version."bindings"."1.1.0";
  by-version."bindings"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.1.0.tgz";
        name = "bindings-1.1.0.tgz";
        sha1 = "f3cc4deec19fe31f255864eb1e6ffad857266ef0";
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
  by-spec."bindings"."~1.1.1" =
    self.by-version."bindings"."1.1.1";
  by-spec."bindings"."~1.2.1" =
    self.by-version."bindings"."1.2.1";
  by-spec."bitfield"."^0.1.0" =
    self.by-version."bitfield"."0.1.0";
  by-version."bitfield"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "bitfield-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bitfield/-/bitfield-0.1.0.tgz";
        name = "bitfield-0.1.0.tgz";
        sha1 = "b05d8b5f0d09f2df35a9db3b3a62d3808c46c457";
      })
    ];
    buildInputs =
      (self.nativeDeps."bitfield" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bitfield" ];
  };
  by-spec."bits"."~0.1.1" =
    self.by-version."bits"."0.1.1";
  by-version."bits"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "bits-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bits/-/bits-0.1.1.tgz";
        name = "bits-0.1.1.tgz";
        sha1 = "7082eb8b7bdf12e47b0a8cf8f7ad3af4e7053a96";
      })
    ];
    buildInputs =
      (self.nativeDeps."bits" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bits" ];
  };
  by-spec."bittorrent-dht"."^1.0.0" =
    self.by-version."bittorrent-dht"."1.5.0";
  by-version."bittorrent-dht"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "bittorrent-dht-1.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bittorrent-dht/-/bittorrent-dht-1.5.0.tgz";
        name = "bittorrent-dht-1.5.0.tgz";
        sha1 = "b14b34eace8f44e795a8bad69a44b08ca485c355";
      })
    ];
    buildInputs =
      (self.nativeDeps."bittorrent-dht" or []);
    deps = {
      "bencode-0.6.0" = self.by-version."bencode"."0.6.0";
      "buffer-equal-0.0.1" = self.by-version."buffer-equal"."0.0.1";
      "compact2string-1.3.0" = self.by-version."compact2string"."1.3.0";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "k-bucket-0.4.2" = self.by-version."k-bucket"."0.4.2";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "portfinder-0.2.1" = self.by-version."portfinder"."0.2.1";
      "run-parallel-1.0.0" = self.by-version."run-parallel"."1.0.0";
      "string2compact-1.2.0" = self.by-version."string2compact"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bittorrent-dht" ];
  };
  by-spec."bittorrent-dht"."^2.6.4" =
    self.by-version."bittorrent-dht"."2.6.4";
  by-version."bittorrent-dht"."2.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "bittorrent-dht-2.6.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bittorrent-dht/-/bittorrent-dht-2.6.4.tgz";
        name = "bittorrent-dht-2.6.4.tgz";
        sha1 = "af090c6576f6228596fdd5c538d3439aaf50577b";
      })
    ];
    buildInputs =
      (self.nativeDeps."bittorrent-dht" or []);
    deps = {
      "addr-to-ip-port-1.4.0" = self.by-version."addr-to-ip-port"."1.4.0";
      "bencode-0.6.0" = self.by-version."bencode"."0.6.0";
      "buffer-equal-0.0.1" = self.by-version."buffer-equal"."0.0.1";
      "compact2string-1.3.0" = self.by-version."compact2string"."1.3.0";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "is-ip-1.0.0" = self.by-version."is-ip"."1.0.0";
      "k-bucket-0.4.2" = self.by-version."k-bucket"."0.4.2";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "run-parallel-1.0.0" = self.by-version."run-parallel"."1.0.0";
      "string2compact-1.2.0" = self.by-version."string2compact"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bittorrent-dht" ];
  };
  by-spec."bittorrent-tracker"."^2.0.0" =
    self.by-version."bittorrent-tracker"."2.9.1";
  by-version."bittorrent-tracker"."2.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "bittorrent-tracker-2.9.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bittorrent-tracker/-/bittorrent-tracker-2.9.1.tgz";
        name = "bittorrent-tracker-2.9.1.tgz";
        sha1 = "a1168960898a02bc193f95d60d07504a31154cee";
      })
    ];
    buildInputs =
      (self.nativeDeps."bittorrent-tracker" or []);
    deps = {
      "bencode-0.6.0" = self.by-version."bencode"."0.6.0";
      "bn.js-0.15.2" = self.by-version."bn.js"."0.15.2";
      "buffer-equal-0.0.1" = self.by-version."buffer-equal"."0.0.1";
      "compact2string-1.3.0" = self.by-version."compact2string"."1.3.0";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "extend.js-0.0.1" = self.by-version."extend.js"."0.0.1";
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "ip-0.3.2" = self.by-version."ip"."0.3.2";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "portfinder-0.2.1" = self.by-version."portfinder"."0.2.1";
      "string2compact-1.2.0" = self.by-version."string2compact"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bittorrent-tracker" ];
  };
  by-spec."bittorrent-tracker"."^2.6.0" =
    self.by-version."bittorrent-tracker"."2.9.1";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
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
    self.by-version."bluebird"."2.3.11";
  by-version."bluebird"."2.3.11" = lib.makeOverridable self.buildNodePackage {
    name = "bluebird-2.3.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bluebird/-/bluebird-2.3.11.tgz";
        name = "bluebird-2.3.11.tgz";
        sha1 = "15bb78ed32abf27b090640c0f85e4b91f615c8b6";
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
  by-spec."bn.js"."0.15.2" =
    self.by-version."bn.js"."0.15.2";
  by-version."bn.js"."0.15.2" = lib.makeOverridable self.buildNodePackage {
    name = "bn.js-0.15.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bn.js/-/bn.js-0.15.2.tgz";
        name = "bn.js-0.15.2.tgz";
        sha1 = "a83b283accdacbf28e89774747cac352216f886a";
      })
    ];
    buildInputs =
      (self.nativeDeps."bn.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bn.js" ];
  };
  by-spec."bn.js".">=0.15.0-0 0.15.2" =
    self.by-version."bn.js"."0.15.2";
  by-spec."bn.js"."^0.15.0" =
    self.by-version."bn.js"."0.15.2";
  by-spec."bn.js"."^0.15.2" =
    self.by-version."bn.js"."0.15.2";
  by-spec."bncode"."^0.2.3" =
    self.by-version."bncode"."0.2.3";
  by-version."bncode"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "bncode-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bncode/-/bncode-0.2.3.tgz";
        name = "bncode-0.2.3.tgz";
        sha1 = "37f851dc8e47188a83fbc0f6fa4775cacc9a3296";
      })
    ];
    buildInputs =
      (self.nativeDeps."bncode" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bncode" ];
  };
  by-spec."bncode"."^0.5.2" =
    self.by-version."bncode"."0.5.3";
  by-version."bncode"."0.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "bncode-0.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bncode/-/bncode-0.5.3.tgz";
        name = "bncode-0.5.3.tgz";
        sha1 = "e16661697452d436bf9886238cc791b08d66a61a";
      })
    ];
    buildInputs =
      (self.nativeDeps."bncode" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bncode" ];
  };
  by-spec."body-parser"."~1.8.4" =
    self.by-version."body-parser"."1.8.4";
  by-version."body-parser"."1.8.4" = lib.makeOverridable self.buildNodePackage {
    name = "body-parser-1.8.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/body-parser/-/body-parser-1.8.4.tgz";
        name = "body-parser-1.8.4.tgz";
        sha1 = "d497e04bc13b3f9a8bd8c70bb0cdc16f2e028898";
      })
    ];
    buildInputs =
      (self.nativeDeps."body-parser" or []);
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "depd-0.4.5" = self.by-version."depd"."0.4.5";
      "iconv-lite-0.4.4" = self.by-version."iconv-lite"."0.4.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
      "qs-2.2.4" = self.by-version."qs"."2.2.4";
      "raw-body-1.3.0" = self.by-version."raw-body"."1.3.0";
      "type-is-1.5.3" = self.by-version."type-is"."1.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "body-parser" ];
  };
  by-spec."body-parser"."~1.9.3" =
    self.by-version."body-parser"."1.9.3";
  by-version."body-parser"."1.9.3" = lib.makeOverridable self.buildNodePackage {
    name = "body-parser-1.9.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/body-parser/-/body-parser-1.9.3.tgz";
        name = "body-parser-1.9.3.tgz";
        sha1 = "edfacd4fcfad87dfe74f861a5cc712900aef2623";
      })
    ];
    buildInputs =
      (self.nativeDeps."body-parser" or []);
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "iconv-lite-0.4.5" = self.by-version."iconv-lite"."0.4.5";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "on-finished-2.1.1" = self.by-version."on-finished"."2.1.1";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "raw-body-1.3.1" = self.by-version."raw-body"."1.3.1";
      "type-is-1.5.3" = self.by-version."type-is"."1.5.3";
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
      "fstream-1.0.3" = self.by-version."fstream"."1.0.3";
      "fstream-ignore-1.0.1" = self.by-version."fstream-ignore"."1.0.1";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
      "which-1.0.7" = self.by-version."which"."1.0.7";
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
  by-spec."bplist-parser"."0.0.6" =
    self.by-version."bplist-parser"."0.0.6";
  by-version."bplist-parser"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "bplist-parser-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bplist-parser/-/bplist-parser-0.0.6.tgz";
        name = "bplist-parser-0.0.6.tgz";
        sha1 = "38da3471817df9d44ab3892e27707bbbd75a11b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."bplist-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bplist-parser" ];
  };
  by-spec."brfs"."0.0.8" =
    self.by-version."brfs"."0.0.8";
  by-version."brfs"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "brfs-0.0.8";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/brfs/-/brfs-0.0.8.tgz";
        name = "brfs-0.0.8.tgz";
        sha1 = "e4377a177638a4b0520901bb134491dd7e38a386";
      })
    ];
    buildInputs =
      (self.nativeDeps."brfs" or []);
    deps = {
      "through-2.2.7" = self.by-version."through"."2.2.7";
      "falafel-0.1.6" = self.by-version."falafel"."0.1.6";
      "escodegen-0.0.17" = self.by-version."escodegen"."0.0.17";
    };
    peerDependencies = [
    ];
    passthru.names = [ "brfs" ];
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
  by-spec."broadway"."~0.3.6" =
    self.by-version."broadway"."0.3.6";
  by-spec."brorand"."^1.0.1" =
    self.by-version."brorand"."1.0.5";
  by-version."brorand"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "brorand-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/brorand/-/brorand-1.0.5.tgz";
        name = "brorand-1.0.5.tgz";
        sha1 = "07b54ca30286abd1718a0e2a830803efdc9bfa04";
      })
    ];
    buildInputs =
      (self.nativeDeps."brorand" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "brorand" ];
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
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
      "umd-2.1.0" = self.by-version."umd"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-pack" ];
  };
  by-spec."browser-pack"."~2.0.0" =
    self.by-version."browser-pack"."2.0.1";
  by-version."browser-pack"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "browser-pack-2.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-pack/-/browser-pack-2.0.1.tgz";
        name = "browser-pack-2.0.1.tgz";
        sha1 = "5d1c527f56c582677411c4db2a128648ff6bf150";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-pack" or []);
    deps = {
      "JSONStream-0.6.4" = self.by-version."JSONStream"."0.6.4";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "combine-source-map-0.3.0" = self.by-version."combine-source-map"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-pack" ];
  };
  by-spec."browser-request".">= 0.2.0" =
    self.by-version."browser-request"."0.3.3";
  by-version."browser-request"."0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "browser-request-0.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-request/-/browser-request-0.3.3.tgz";
        name = "browser-request-0.3.3.tgz";
        sha1 = "9ece5b5aca89a29932242e18bf933def9876cc17";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-request" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-request" ];
  };
  by-spec."browser-request"."~0.3.1" =
    self.by-version."browser-request"."0.3.3";
  by-spec."browser-resolve"."^1.3.0" =
    self.by-version."browser-resolve"."1.4.1";
  by-version."browser-resolve"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "browser-resolve-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-resolve/-/browser-resolve-1.4.1.tgz";
        name = "browser-resolve-1.4.1.tgz";
        sha1 = "65ac7963f65bd49fa50711c877a1e273bb17a85b";
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
    self.by-version."browser-resolve"."1.4.1";
  by-spec."browser-resolve"."~1.2.1" =
    self.by-version."browser-resolve"."1.2.4";
  by-version."browser-resolve"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "browser-resolve-1.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-resolve/-/browser-resolve-1.2.4.tgz";
        name = "browser-resolve-1.2.4.tgz";
        sha1 = "59ae7820a82955ecd32f5fb7c468ac21c4723806";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-resolve" or []);
    deps = {
      "resolve-0.6.3" = self.by-version."resolve"."0.6.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-resolve" ];
  };
  by-spec."browser-resolve"."~1.2.2" =
    self.by-version."browser-resolve"."1.2.4";
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
      "connect-2.27.4" = self.by-version."connect"."2.27.4";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "ascii-json-0.2.0" = self.by-version."ascii-json"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserchannel" ];
  };
  "browserchannel" = self.by-version."browserchannel"."2.0.0";
  by-spec."browserify"."*" =
    self.by-version."browserify"."6.3.3";
  by-version."browserify"."6.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-6.3.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify/-/browserify-6.3.3.tgz";
        name = "browserify-6.3.3.tgz";
        sha1 = "d2a5031a24aec8045eb8174b501bf3f6248455d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify" or []);
    deps = {
      "JSONStream-0.8.4" = self.by-version."JSONStream"."0.8.4";
      "assert-1.1.2" = self.by-version."assert"."1.1.2";
      "browser-pack-3.2.0" = self.by-version."browser-pack"."3.2.0";
      "browser-resolve-1.4.1" = self.by-version."browser-resolve"."1.4.1";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
      "buffer-2.8.1" = self.by-version."buffer"."2.8.1";
      "builtins-0.0.7" = self.by-version."builtins"."0.0.7";
      "commondir-0.0.1" = self.by-version."commondir"."0.0.1";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "console-browserify-1.1.0" = self.by-version."console-browserify"."1.1.0";
      "constants-browserify-0.0.1" = self.by-version."constants-browserify"."0.0.1";
      "crypto-browserify-3.6.0" = self.by-version."crypto-browserify"."3.6.0";
      "deep-equal-0.2.1" = self.by-version."deep-equal"."0.2.1";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "deps-sort-1.3.5" = self.by-version."deps-sort"."1.3.5";
      "domain-browser-1.1.3" = self.by-version."domain-browser"."1.1.3";
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "events-1.0.2" = self.by-version."events"."1.0.2";
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
      "http-browserify-1.7.0" = self.by-version."http-browserify"."1.7.0";
      "https-browserify-0.0.0" = self.by-version."https-browserify"."0.0.0";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "insert-module-globals-6.1.0" = self.by-version."insert-module-globals"."6.1.0";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "labeled-stream-splicer-1.0.2" = self.by-version."labeled-stream-splicer"."1.0.2";
      "module-deps-3.5.10" = self.by-version."module-deps"."3.5.10";
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
      "syntax-error-1.1.2" = self.by-version."syntax-error"."1.1.2";
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
  "browserify" = self.by-version."browserify"."6.3.3";
  by-spec."browserify"."3.46.0" =
    self.by-version."browserify"."3.46.0";
  by-version."browserify"."3.46.0" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-3.46.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify/-/browserify-3.46.0.tgz";
        name = "browserify-3.46.0.tgz";
        sha1 = "dc32dd189efcb0b9e7ca88f5099b11654ab3c50f";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify" or []);
    deps = {
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "assert-1.1.2" = self.by-version."assert"."1.1.2";
      "browser-pack-2.0.1" = self.by-version."browser-pack"."2.0.1";
      "browser-resolve-1.2.4" = self.by-version."browser-resolve"."1.2.4";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
      "buffer-2.1.13" = self.by-version."buffer"."2.1.13";
      "builtins-0.0.7" = self.by-version."builtins"."0.0.7";
      "commondir-0.0.1" = self.by-version."commondir"."0.0.1";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "console-browserify-1.0.3" = self.by-version."console-browserify"."1.0.3";
      "constants-browserify-0.0.1" = self.by-version."constants-browserify"."0.0.1";
      "crypto-browserify-1.0.9" = self.by-version."crypto-browserify"."1.0.9";
      "deep-equal-0.1.2" = self.by-version."deep-equal"."0.1.2";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "deps-sort-0.1.2" = self.by-version."deps-sort"."0.1.2";
      "derequire-0.8.0" = self.by-version."derequire"."0.8.0";
      "domain-browser-1.1.3" = self.by-version."domain-browser"."1.1.3";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "events-1.0.2" = self.by-version."events"."1.0.2";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "http-browserify-1.3.2" = self.by-version."http-browserify"."1.3.2";
      "https-browserify-0.0.0" = self.by-version."https-browserify"."0.0.0";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "insert-module-globals-5.0.1" = self.by-version."insert-module-globals"."5.0.1";
      "module-deps-1.10.0" = self.by-version."module-deps"."1.10.0";
      "os-browserify-0.1.2" = self.by-version."os-browserify"."0.1.2";
      "parents-0.0.3" = self.by-version."parents"."0.0.3";
      "path-browserify-0.0.0" = self.by-version."path-browserify"."0.0.0";
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
      "querystring-es3-0.2.0" = self.by-version."querystring-es3"."0.2.0";
      "resolve-0.6.3" = self.by-version."resolve"."0.6.3";
      "shallow-copy-0.0.1" = self.by-version."shallow-copy"."0.0.1";
      "shell-quote-0.0.1" = self.by-version."shell-quote"."0.0.1";
      "stream-browserify-0.1.3" = self.by-version."stream-browserify"."0.1.3";
      "stream-combiner-0.0.4" = self.by-version."stream-combiner"."0.0.4";
      "string_decoder-0.0.1" = self.by-version."string_decoder"."0.0.1";
      "subarg-0.0.1" = self.by-version."subarg"."0.0.1";
      "syntax-error-1.1.2" = self.by-version."syntax-error"."1.1.2";
      "through2-0.4.2" = self.by-version."through2"."0.4.2";
      "timers-browserify-1.0.3" = self.by-version."timers-browserify"."1.0.3";
      "tty-browserify-0.0.0" = self.by-version."tty-browserify"."0.0.0";
      "umd-2.0.0" = self.by-version."umd"."2.0.0";
      "url-0.10.1" = self.by-version."url"."0.10.1";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "vm-browserify-0.0.4" = self.by-version."vm-browserify"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify" ];
  };
  by-spec."browserify"."~3.19.1" =
    self.by-version."browserify"."3.19.1";
  by-version."browserify"."3.19.1" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-3.19.1";
    bin = true;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/browserify/-/browserify-3.19.1.tgz";
        name = "browserify-3.19.1.tgz";
        sha1 = "e4e994f7c8313432df46b1a2b029d8bab13a456b";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify" or []);
    deps = {
      "module-deps-1.2.2" = self.by-version."module-deps"."1.2.2";
      "browser-pack-2.0.1" = self.by-version."browser-pack"."2.0.1";
      "deps-sort-0.1.2" = self.by-version."deps-sort"."0.1.2";
      "shell-quote-0.0.1" = self.by-version."shell-quote"."0.0.1";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "stream-combiner-0.0.4" = self.by-version."stream-combiner"."0.0.4";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "insert-module-globals-2.3.4" = self.by-version."insert-module-globals"."2.3.4";
      "syntax-error-0.0.1" = self.by-version."syntax-error"."0.0.1";
      "browser-resolve-1.2.4" = self.by-version."browser-resolve"."1.2.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "umd-2.0.0" = self.by-version."umd"."2.0.0";
      "parents-0.0.3" = self.by-version."parents"."0.0.3";
      "deep-equal-0.1.2" = self.by-version."deep-equal"."0.1.2";
      "constants-browserify-0.0.1" = self.by-version."constants-browserify"."0.0.1";
      "os-browserify-0.1.2" = self.by-version."os-browserify"."0.1.2";
      "console-browserify-1.0.3" = self.by-version."console-browserify"."1.0.3";
      "vm-browserify-0.0.4" = self.by-version."vm-browserify"."0.0.4";
      "zlib-browserify-0.0.3" = self.by-version."zlib-browserify"."0.0.3";
      "assert-1.1.2" = self.by-version."assert"."1.1.2";
      "http-browserify-1.1.0" = self.by-version."http-browserify"."1.1.0";
      "crypto-browserify-1.0.9" = self.by-version."crypto-browserify"."1.0.9";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "events-1.0.2" = self.by-version."events"."1.0.2";
      "native-buffer-browserify-2.0.17" = self.by-version."native-buffer-browserify"."2.0.17";
      "url-0.7.9" = self.by-version."url"."0.7.9";
      "https-browserify-0.0.0" = self.by-version."https-browserify"."0.0.0";
      "path-browserify-0.0.0" = self.by-version."path-browserify"."0.0.0";
      "querystring-0.2.0" = self.by-version."querystring"."0.2.0";
      "stream-browserify-0.1.3" = self.by-version."stream-browserify"."0.1.3";
      "string_decoder-0.0.1" = self.by-version."string_decoder"."0.0.1";
      "tty-browserify-0.0.0" = self.by-version."tty-browserify"."0.0.0";
      "timers-browserify-1.0.3" = self.by-version."timers-browserify"."1.0.3";
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "domain-browser-1.1.3" = self.by-version."domain-browser"."1.1.3";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify" ];
  };
  by-spec."browserify"."~3.24.1" =
    self.by-version."browserify"."3.24.13";
  by-version."browserify"."3.24.13" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-3.24.13";
    bin = true;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/browserify/-/browserify-3.24.13.tgz";
        name = "browserify-3.24.13.tgz";
        sha1 = "d82012886791c4b1edd36612ad508a614e9ad86e";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify" or []);
    deps = {
      "module-deps-1.4.2" = self.by-version."module-deps"."1.4.2";
      "browser-pack-2.0.1" = self.by-version."browser-pack"."2.0.1";
      "deps-sort-0.1.2" = self.by-version."deps-sort"."0.1.2";
      "shell-quote-0.0.1" = self.by-version."shell-quote"."0.0.1";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "stream-combiner-0.0.4" = self.by-version."stream-combiner"."0.0.4";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "insert-module-globals-3.1.3" = self.by-version."insert-module-globals"."3.1.3";
      "syntax-error-0.1.0" = self.by-version."syntax-error"."0.1.0";
      "browser-resolve-1.2.4" = self.by-version."browser-resolve"."1.2.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "umd-2.0.0" = self.by-version."umd"."2.0.0";
      "parents-0.0.3" = self.by-version."parents"."0.0.3";
      "deep-equal-0.1.2" = self.by-version."deep-equal"."0.1.2";
      "constants-browserify-0.0.1" = self.by-version."constants-browserify"."0.0.1";
      "os-browserify-0.1.2" = self.by-version."os-browserify"."0.1.2";
      "console-browserify-1.0.3" = self.by-version."console-browserify"."1.0.3";
      "vm-browserify-0.0.4" = self.by-version."vm-browserify"."0.0.4";
      "zlib-browserify-0.0.3" = self.by-version."zlib-browserify"."0.0.3";
      "assert-1.1.2" = self.by-version."assert"."1.1.2";
      "http-browserify-1.1.0" = self.by-version."http-browserify"."1.1.0";
      "crypto-browserify-1.0.9" = self.by-version."crypto-browserify"."1.0.9";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "events-1.0.2" = self.by-version."events"."1.0.2";
      "native-buffer-browserify-2.0.17" = self.by-version."native-buffer-browserify"."2.0.17";
      "url-0.7.9" = self.by-version."url"."0.7.9";
      "https-browserify-0.0.0" = self.by-version."https-browserify"."0.0.0";
      "path-browserify-0.0.0" = self.by-version."path-browserify"."0.0.0";
      "querystring-0.2.0" = self.by-version."querystring"."0.2.0";
      "stream-browserify-0.1.3" = self.by-version."stream-browserify"."0.1.3";
      "string_decoder-0.0.1" = self.by-version."string_decoder"."0.0.1";
      "tty-browserify-0.0.0" = self.by-version."tty-browserify"."0.0.0";
      "timers-browserify-1.0.3" = self.by-version."timers-browserify"."1.0.3";
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "domain-browser-1.1.3" = self.by-version."domain-browser"."1.1.3";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "derequire-0.6.1" = self.by-version."derequire"."0.6.1";
      "commondir-0.0.1" = self.by-version."commondir"."0.0.1";
      "shallow-copy-0.0.1" = self.by-version."shallow-copy"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify" ];
  };
  by-spec."browserify-aes"."0.6.0" =
    self.by-version."browserify-aes"."0.6.0";
  by-version."browserify-aes"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-aes-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify-aes/-/browserify-aes-0.6.0.tgz";
        name = "browserify-aes-0.6.0.tgz";
        sha1 = "07df03037306a94f453da08cbaf1b42afcc3b18f";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify-aes" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify-aes" ];
  };
  by-spec."browserify-sign"."2.4.0" =
    self.by-version."browserify-sign"."2.4.0";
  by-version."browserify-sign"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "browserify-sign-2.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserify-sign/-/browserify-sign-2.4.0.tgz";
        name = "browserify-sign-2.4.0.tgz";
        sha1 = "55bef52192091216336db4fb0bcc88c1d8f049fd";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserify-sign" or []);
    deps = {
      "asn1.js-0.6.5" = self.by-version."asn1.js"."0.6.5";
      "asn1.js-rfc3280-0.5.1" = self.by-version."asn1.js-rfc3280"."0.5.1";
      "bn.js-0.15.2" = self.by-version."bn.js"."0.15.2";
      "elliptic-0.15.15" = self.by-version."elliptic"."0.15.15";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "pemstrip-0.0.1" = self.by-version."pemstrip"."0.0.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "browserify-sign" ];
  };
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
    self.by-version."buffer"."2.8.1";
  by-version."buffer"."2.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-2.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer/-/buffer-2.8.1.tgz";
        name = "buffer-2.8.1.tgz";
        sha1 = "6c632bf47cb7ec86509254ed42ab080937986114";
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
  by-spec."buffer"."~2.1.4" =
    self.by-version."buffer"."2.1.13";
  by-version."buffer"."2.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-2.1.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer/-/buffer-2.1.13.tgz";
        name = "buffer-2.1.13.tgz";
        sha1 = "c88838ebf79f30b8b4a707788470bea8a62c2355";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer" or []);
    deps = {
      "base64-js-0.0.7" = self.by-version."base64-js"."0.0.7";
      "ieee754-1.1.4" = self.by-version."ieee754"."1.1.4";
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
  by-spec."buffer-crc32"."~0.2.1" =
    self.by-version."buffer-crc32"."0.2.4";
  by-version."buffer-crc32"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.4.tgz";
        name = "buffer-crc32-0.2.4.tgz";
        sha1 = "f729c4c5d2eb39ba49f29422175cc20b0bf1b96f";
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
  by-spec."buffer-equal"."0.0.1" =
    self.by-version."buffer-equal"."0.0.1";
  by-version."buffer-equal"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-equal-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz";
        name = "buffer-equal-0.0.1.tgz";
        sha1 = "91bc74b11ea405bc916bc6aa908faafa5b4aac4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-equal" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffer-equal" ];
  };
  by-spec."buffer-equal"."^0.0.1" =
    self.by-version."buffer-equal"."0.0.1";
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
  by-spec."bytes"."0.3.0" =
    self.by-version."bytes"."0.3.0";
  by-version."bytes"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "bytes-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.3.0.tgz";
        name = "bytes-0.3.0.tgz";
        sha1 = "78e2e0e28c7f9c7b988ea8aee0db4d5fa9941935";
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
  by-spec."bytes"."~0.2.0" =
    self.by-version."bytes"."0.2.1";
  by-spec."bytes"."~0.3.0" =
    self.by-version."bytes"."0.3.0";
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
  by-spec."camelcase"."^1.0.1" =
    self.by-version."camelcase"."1.0.2";
  by-version."camelcase"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "camelcase-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/camelcase/-/camelcase-1.0.2.tgz";
        name = "camelcase-1.0.2.tgz";
        sha1 = "7912eac1d496836782c976c2d73e874dc54f2eaf";
      })
    ];
    buildInputs =
      (self.nativeDeps."camelcase" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "camelcase" ];
  };
  by-spec."camelcase-keys"."^1.0.0" =
    self.by-version."camelcase-keys"."1.0.0";
  by-version."camelcase-keys"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "camelcase-keys-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/camelcase-keys/-/camelcase-keys-1.0.0.tgz";
        name = "camelcase-keys-1.0.0.tgz";
        sha1 = "bd1a11bf9b31a1ce493493a930de1a0baf4ad7ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."camelcase-keys" or []);
    deps = {
      "camelcase-1.0.2" = self.by-version."camelcase"."1.0.2";
      "map-obj-1.0.0" = self.by-version."map-obj"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "camelcase-keys" ];
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
  by-spec."caseless"."~0.7.0" =
    self.by-version."caseless"."0.7.0";
  by-version."caseless"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "caseless-0.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.7.0.tgz";
        name = "caseless-0.7.0.tgz";
        sha1 = "cbd705ae6229158bb0bc971bf7d7a04bdbd51ff8";
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
  by-spec."caseless"."~0.8.0" =
    self.by-version."caseless"."0.8.0";
  by-version."caseless"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "caseless-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.8.0.tgz";
        name = "caseless-0.8.0.tgz";
        sha1 = "5bca2881d41437f54b2407ebe34888c7b9ad4f7d";
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
    self.by-version."chai"."1.10.0";
  by-version."chai"."1.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "chai-1.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chai/-/chai-1.10.0.tgz";
        name = "chai-1.10.0.tgz";
        sha1 = "e4031cc87654461a75943e5a35ab46eaf39c1eb9";
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
  "chai" = self.by-version."chai"."1.10.0";
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
  by-spec."character-parser"."1.2.1" =
    self.by-version."character-parser"."1.2.1";
  by-version."character-parser"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "character-parser-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/character-parser/-/character-parser-1.2.1.tgz";
        name = "character-parser-1.2.1.tgz";
        sha1 = "c0dde4ab182713b919b970959a123ecc1a30fcd6";
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
    self.by-version."chokidar"."0.11.1";
  by-version."chokidar"."0.11.1" = lib.makeOverridable self.buildNodePackage {
    name = "chokidar-0.11.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chokidar/-/chokidar-0.11.1.tgz";
        name = "chokidar-0.11.1.tgz";
        sha1 = "b00e01717de445783782ef5c48a803e05fed0fc4";
      })
    ];
    buildInputs =
      (self.nativeDeps."chokidar" or []);
    deps = {
      "readdirp-1.1.0" = self.by-version."readdirp"."1.1.0";
      "async-each-0.1.6" = self.by-version."async-each"."0.1.6";
      "fsevents-0.3.1" = self.by-version."fsevents"."0.3.1";
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
    self.by-version."clean-css"."2.2.19";
  by-version."clean-css"."2.2.19" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-2.2.19";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-2.2.19.tgz";
        name = "clean-css-2.2.19.tgz";
        sha1 = "b5863312e2e13fdf693e44d60b41ce45cbb6fdbd";
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
    self.by-version."clean-css"."2.2.19";
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
  by-spec."cli-table"."^0.3.0" =
    self.by-version."cli-table"."0.3.1";
  by-version."cli-table"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "cli-table-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli-table/-/cli-table-0.3.1.tgz";
        name = "cli-table-0.3.1.tgz";
        sha1 = "f53b05266a8b1a0b934b3d0821e6e2dc5914ae23";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli-table" or []);
    deps = {
      "colors-1.0.3" = self.by-version."colors"."1.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cli-table" ];
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
      "winston-0.8.3" = self.by-version."winston"."0.8.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cliff" ];
  };
  by-spec."cliff"."~0.1.9" =
    self.by-version."cliff"."0.1.9";
  by-spec."clivas"."^0.1.4" =
    self.by-version."clivas"."0.1.4";
  by-version."clivas"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "clivas-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clivas/-/clivas-0.1.4.tgz";
        name = "clivas-0.1.4.tgz";
        sha1 = "e1c1e481d1273d57f1752132b0e4410a0d88235a";
      })
    ];
    buildInputs =
      (self.nativeDeps."clivas" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "clivas" ];
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
  by-spec."clone"."^0.1.18" =
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
  by-spec."clone"."~0.1.18" =
    self.by-version."clone"."0.1.18";
  by-spec."clone"."~0.1.5" =
    self.by-version."clone"."0.1.18";
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
  by-spec."cmd-shim"."~1.1.0" =
    self.by-version."cmd-shim"."1.1.2";
  by-version."cmd-shim"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "cmd-shim-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cmd-shim/-/cmd-shim-1.1.2.tgz";
        name = "cmd-shim-1.1.2.tgz";
        sha1 = "e4f9198802e361e8eb43b591959ef4dc6cdb6754";
      })
    ];
    buildInputs =
      (self.nativeDeps."cmd-shim" or []);
    deps = {
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cmd-shim" ];
  };
  by-spec."cmd-shim"."~1.1.1" =
    self.by-version."cmd-shim"."1.1.2";
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
  by-spec."coffee-script"."~1.8.0" =
    self.by-version."coffee-script"."1.8.0";
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
  by-spec."color"."~0.7.3" =
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
  by-spec."colors"."1.0.3" =
    self.by-version."colors"."1.0.3";
  by-version."colors"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "colors-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
        name = "colors-1.0.3.tgz";
        sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
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
  by-spec."colors"."~0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."columnify"."0.1.2" =
    self.by-version."columnify"."0.1.2";
  by-version."columnify"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "columnify-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/columnify/-/columnify-0.1.2.tgz";
        name = "columnify-0.1.2.tgz";
        sha1 = "ab1a1f1e37b26ba4b87c6920fb717fe51c827042";
      })
    ];
    buildInputs =
      (self.nativeDeps."columnify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "columnify" ];
  };
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
    self.by-version."combined-stream"."0.0.7";
  by-version."combined-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "combined-stream-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
        name = "combined-stream-0.0.7.tgz";
        sha1 = "0137e657baa5a7541c57ac37ac5fc07d73b4dc1f";
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
  by-spec."combined-stream"."~0.0.5" =
    self.by-version."combined-stream"."0.0.7";
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
  by-spec."commander"."2.0.x" =
    self.by-version."commander"."2.0.0";
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
    self.by-version."commander"."2.5.0";
  by-version."commander"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.5.0.tgz";
        name = "commander-2.5.0.tgz";
        sha1 = "d777b6a4d847d423e5d475da864294ac1ff5aa9d";
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
  by-spec."commander"."~2.3.0" =
    self.by-version."commander"."2.3.0";
  by-spec."commander"."~2.5.0" =
    self.by-version."commander"."2.5.0";
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
  by-spec."commondir"."~0.0.1" =
    self.by-version."commondir"."0.0.1";
  by-spec."compact2string"."^1.2.0" =
    self.by-version."compact2string"."1.3.0";
  by-version."compact2string"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "compact2string-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compact2string/-/compact2string-1.3.0.tgz";
        name = "compact2string-1.3.0.tgz";
        sha1 = "5e5d32fe4d40ca853ec0f6f22f7952aa9fe36135";
      })
    ];
    buildInputs =
      (self.nativeDeps."compact2string" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "compact2string" ];
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
      "buffer-crc32-0.2.4" = self.by-version."buffer-crc32"."0.2.4";
      "crc32-stream-0.3.1" = self.by-version."crc32-stream"."0.3.1";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compress-commons" ];
  };
  by-spec."compressible"."1.0.0" =
    self.by-version."compressible"."1.0.0";
  by-version."compressible"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "compressible-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compressible/-/compressible-1.0.0.tgz";
        name = "compressible-1.0.0.tgz";
        sha1 = "f83e49c1cb61421753545125a8011d68b492427d";
      })
    ];
    buildInputs =
      (self.nativeDeps."compressible" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "compressible" ];
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
      "mime-db-1.2.0" = self.by-version."mime-db"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compressible" ];
  };
  by-spec."compression"."1.0.0" =
    self.by-version."compression"."1.0.0";
  by-version."compression"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "compression-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compression/-/compression-1.0.0.tgz";
        name = "compression-1.0.0.tgz";
        sha1 = "8aeb85d48db5145d38bc8b181b6352d8eab26020";
      })
    ];
    buildInputs =
      (self.nativeDeps."compression" or []);
    deps = {
      "bytes-0.2.1" = self.by-version."bytes"."0.2.1";
      "negotiator-0.3.0" = self.by-version."negotiator"."0.3.0";
      "compressible-1.0.0" = self.by-version."compressible"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compression" ];
  };
  by-spec."compression"."~1.1.2" =
    self.by-version."compression"."1.1.2";
  by-version."compression"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "compression-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compression/-/compression-1.1.2.tgz";
        name = "compression-1.1.2.tgz";
        sha1 = "f93fb7fcdb3573ec4c7d5398984caae230e2a8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."compression" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "compressible-2.0.1" = self.by-version."compressible"."2.0.1";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "compression" ];
  };
  by-spec."compression"."~1.2.1" =
    self.by-version."compression"."1.2.1";
  by-version."compression"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "compression-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/compression/-/compression-1.2.1.tgz";
        name = "compression-1.2.1.tgz";
        sha1 = "12ebaac04d308ca6103618a9716ce5634b939e9c";
      })
    ];
    buildInputs =
      (self.nativeDeps."compression" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
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
    self.by-version."concat-stream"."1.4.7";
  by-version."concat-stream"."1.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "concat-stream-1.4.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/concat-stream/-/concat-stream-1.4.7.tgz";
        name = "concat-stream-1.4.7.tgz";
        sha1 = "0ceaa47b87a581d2a7a782b92b81d5020c3f9925";
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
  by-spec."concat-stream"."^1.4.5" =
    self.by-version."concat-stream"."1.4.7";
  by-spec."concat-stream"."^1.4.6" =
    self.by-version."concat-stream"."1.4.7";
  by-spec."concat-stream"."~1.4.1" =
    self.by-version."concat-stream"."1.4.7";
  by-spec."concat-stream"."~1.4.5" =
    self.by-version."concat-stream"."1.4.7";
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
      "vows-0.8.1" = self.by-version."vows"."0.8.1";
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
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
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
  by-spec."connect"."2.14.5" =
    self.by-version."connect"."2.14.5";
  by-version."connect"."2.14.5" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.14.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.14.5.tgz";
        name = "connect-2.14.5.tgz";
        sha1 = "73217513152c152ebe049c499fa09211b8c476f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "basic-auth-connect-1.0.0" = self.by-version."basic-auth-connect"."1.0.0";
      "cookie-parser-1.0.1" = self.by-version."cookie-parser"."1.0.1";
      "cookie-signature-1.0.3" = self.by-version."cookie-signature"."1.0.3";
      "compression-1.0.0" = self.by-version."compression"."1.0.0";
      "connect-timeout-1.0.0" = self.by-version."connect-timeout"."1.0.0";
      "csurf-1.1.0" = self.by-version."csurf"."1.1.0";
      "errorhandler-1.0.0" = self.by-version."errorhandler"."1.0.0";
      "express-session-1.0.2" = self.by-version."express-session"."1.0.2";
      "fresh-0.2.2" = self.by-version."fresh"."0.2.2";
      "method-override-1.0.0" = self.by-version."method-override"."1.0.0";
      "morgan-1.0.0" = self.by-version."morgan"."1.0.0";
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "raw-body-1.1.4" = self.by-version."raw-body"."1.1.4";
      "response-time-1.0.0" = self.by-version."response-time"."1.0.0";
      "setimmediate-1.0.1" = self.by-version."setimmediate"."1.0.1";
      "serve-index-1.0.1" = self.by-version."serve-index"."1.0.1";
      "serve-static-1.1.0" = self.by-version."serve-static"."1.1.0";
      "static-favicon-1.0.2" = self.by-version."static-favicon"."1.0.2";
      "vhost-1.0.0" = self.by-version."vhost"."1.0.0";
      "bytes-0.3.0" = self.by-version."bytes"."0.3.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
      "multiparty-2.2.0" = self.by-version."multiparty"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect"."2.27.4" =
    self.by-version."connect"."2.27.4";
  by-version."connect"."2.27.4" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.27.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.27.4.tgz";
        name = "connect-2.27.4.tgz";
        sha1 = "12592c9d105326c5191176f8d57e760d6650c830";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "basic-auth-connect-1.0.0" = self.by-version."basic-auth-connect"."1.0.0";
      "body-parser-1.9.3" = self.by-version."body-parser"."1.9.3";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-parser-1.3.3" = self.by-version."cookie-parser"."1.3.3";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "compression-1.2.1" = self.by-version."compression"."1.2.1";
      "connect-timeout-1.4.0" = self.by-version."connect-timeout"."1.4.0";
      "csurf-1.6.3" = self.by-version."csurf"."1.6.3";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "errorhandler-1.2.3" = self.by-version."errorhandler"."1.2.3";
      "express-session-1.9.2" = self.by-version."express-session"."1.9.2";
      "finalhandler-0.3.2" = self.by-version."finalhandler"."0.3.2";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "method-override-2.3.0" = self.by-version."method-override"."2.3.0";
      "morgan-1.4.1" = self.by-version."morgan"."1.4.1";
      "multiparty-3.3.2" = self.by-version."multiparty"."3.3.2";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "response-time-2.2.0" = self.by-version."response-time"."2.2.0";
      "serve-favicon-2.1.7" = self.by-version."serve-favicon"."2.1.7";
      "serve-index-1.5.1" = self.by-version."serve-index"."1.5.1";
      "serve-static-1.7.1" = self.by-version."serve-static"."1.7.1";
      "type-is-1.5.3" = self.by-version."type-is"."1.5.3";
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
    self.by-version."connect"."2.27.4";
  by-spec."connect"."~2.26.0" =
    self.by-version."connect"."2.26.6";
  by-version."connect"."2.26.6" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.26.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.26.6.tgz";
        name = "connect-2.26.6.tgz";
        sha1 = "94f3eef3fdeeb405806ea46dc036ee0b2acae700";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "basic-auth-connect-1.0.0" = self.by-version."basic-auth-connect"."1.0.0";
      "body-parser-1.8.4" = self.by-version."body-parser"."1.8.4";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-parser-1.3.3" = self.by-version."cookie-parser"."1.3.3";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "compression-1.1.2" = self.by-version."compression"."1.1.2";
      "connect-timeout-1.3.0" = self.by-version."connect-timeout"."1.3.0";
      "csurf-1.6.3" = self.by-version."csurf"."1.6.3";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "depd-0.4.5" = self.by-version."depd"."0.4.5";
      "errorhandler-1.2.3" = self.by-version."errorhandler"."1.2.3";
      "express-session-1.8.2" = self.by-version."express-session"."1.8.2";
      "finalhandler-0.2.0" = self.by-version."finalhandler"."0.2.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "method-override-2.2.0" = self.by-version."method-override"."2.2.0";
      "morgan-1.3.2" = self.by-version."morgan"."1.3.2";
      "multiparty-3.3.2" = self.by-version."multiparty"."3.3.2";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "qs-2.2.4" = self.by-version."qs"."2.2.4";
      "response-time-2.0.1" = self.by-version."response-time"."2.0.1";
      "serve-favicon-2.1.7" = self.by-version."serve-favicon"."2.1.7";
      "serve-index-1.2.1" = self.by-version."serve-index"."1.2.1";
      "serve-static-1.6.4" = self.by-version."serve-static"."1.6.4";
      "type-is-1.5.3" = self.by-version."type-is"."1.5.3";
      "vhost-3.0.0" = self.by-version."vhost"."3.0.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
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
    self.by-version."connect-jade-static"."0.1.4";
  by-version."connect-jade-static"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "connect-jade-static-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-jade-static/-/connect-jade-static-0.1.4.tgz";
        name = "connect-jade-static-0.1.4.tgz";
        sha1 = "d6cc8b768ff6e5ac26f759480e69408f64eb55e4";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-jade-static" or []);
    deps = {
      "jade-1.8.1" = self.by-version."jade"."1.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-jade-static" ];
  };
  "connect-jade-static" = self.by-version."connect-jade-static"."0.1.4";
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
  by-spec."connect-timeout"."1.0.0" =
    self.by-version."connect-timeout"."1.0.0";
  by-version."connect-timeout"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-timeout-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-timeout/-/connect-timeout-1.0.0.tgz";
        name = "connect-timeout-1.0.0.tgz";
        sha1 = "12054799f90bb9566f8b274efe7842d6465d10bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-timeout" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-timeout" ];
  };
  by-spec."connect-timeout"."~1.3.0" =
    self.by-version."connect-timeout"."1.3.0";
  by-version."connect-timeout"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-timeout-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-timeout/-/connect-timeout-1.3.0.tgz";
        name = "connect-timeout-1.3.0.tgz";
        sha1 = "d9d1d2df2900d490ed54190809f37e6b4508a1ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-timeout" or []);
    deps = {
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-timeout" ];
  };
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
  by-spec."console-browserify"."~1.0.1" =
    self.by-version."console-browserify"."1.0.3";
  by-version."console-browserify"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "console-browserify-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/console-browserify/-/console-browserify-1.0.3.tgz";
        name = "console-browserify-1.0.3.tgz";
        sha1 = "d3898d2c3a93102f364197f8874b4f92b5286a8e";
      })
    ];
    buildInputs =
      (self.nativeDeps."console-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "console-browserify" ];
  };
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
  by-spec."constantinople"."~3.0.1" =
    self.by-version."constantinople"."3.0.1";
  by-version."constantinople"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "constantinople-3.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constantinople/-/constantinople-3.0.1.tgz";
        name = "constantinople-3.0.1.tgz";
        sha1 = "1ddf9deac0d14c4367c1d5b3f16fb2763f123108";
      })
    ];
    buildInputs =
      (self.nativeDeps."constantinople" or []);
    deps = {
      "acorn-globals-1.0.1" = self.by-version."acorn-globals"."1.0.1";
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
  by-spec."cookie-parser"."1.0.1" =
    self.by-version."cookie-parser"."1.0.1";
  by-version."cookie-parser"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-parser-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-parser/-/cookie-parser-1.0.1.tgz";
        name = "cookie-parser-1.0.1.tgz";
        sha1 = "17bd622c9717cd0858a912a9fef4c0362360a7b0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-parser" or []);
    deps = {
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "cookie-signature-1.0.3" = self.by-version."cookie-signature"."1.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-parser" ];
  };
  by-spec."cookie-parser"."~1.3.3" =
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
  by-spec."cordova"."*" =
    self.by-version."cordova"."4.1.3-nightly.2014.10.21";
  by-version."cordova"."4.1.3-nightly.2014.10.21" = lib.makeOverridable self.buildNodePackage {
    name = "cordova-4.1.3-nightly.2014.10.21";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cordova/-/cordova-4.1.3-nightly.2014.10.21.tgz";
        name = "cordova-4.1.3-nightly.2014.10.21.tgz";
        sha1 = "7bcaa450fb91cbe3291dbc8fe1ae64ec9412474b";
      })
    ];
    buildInputs =
      (self.nativeDeps."cordova" or []);
    deps = {
      "cordova-lib-4.1.3-nightly.2014.10.21" = self.by-version."cordova-lib"."4.1.3-nightly.2014.10.21";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cordova" ];
  };
  "cordova" = self.by-version."cordova"."4.1.3-nightly.2014.10.21";
  by-spec."cordova-js"."3.7.2" =
    self.by-version."cordova-js"."3.7.2";
  by-version."cordova-js"."3.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "cordova-js-3.7.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cordova-js/-/cordova-js-3.7.2.tgz";
        name = "cordova-js-3.7.2.tgz";
        sha1 = "3535e08d9682bc130ce250fb01c797d9a7eea500";
      })
    ];
    buildInputs =
      (self.nativeDeps."cordova-js" or []);
    deps = {
      "uglify-js-2.4.15" = self.by-version."uglify-js"."2.4.15";
      "browserify-3.46.0" = self.by-version."browserify"."3.46.0";
      "through-2.3.4" = self.by-version."through"."2.3.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cordova-js" ];
  };
  by-spec."cordova-lib"."4.1.3-nightly.2014.10.21" =
    self.by-version."cordova-lib"."4.1.3-nightly.2014.10.21";
  by-version."cordova-lib"."4.1.3-nightly.2014.10.21" = lib.makeOverridable self.buildNodePackage {
    name = "cordova-lib-4.1.3-nightly.2014.10.21";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cordova-lib/-/cordova-lib-4.1.3-nightly.2014.10.21.tgz";
        name = "cordova-lib-4.1.3-nightly.2014.10.21.tgz";
        sha1 = "0686184667fde1aa1c7c543f8485b3d7b75feba7";
      })
    ];
    buildInputs =
      (self.nativeDeps."cordova-lib" or []);
    deps = {
      "bplist-parser-0.0.6" = self.by-version."bplist-parser"."0.0.6";
      "dep-graph-1.1.0" = self.by-version."dep-graph"."1.1.0";
      "elementtree-0.1.5" = self.by-version."elementtree"."0.1.5";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "npm-1.3.4" = self.by-version."npm"."1.3.4";
      "npmconf-0.1.16" = self.by-version."npmconf"."0.1.16";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "plist-1.1.0" = self.by-version."plist"."1.1.0";
      "properties-parser-0.2.3" = self.by-version."properties-parser"."0.2.3";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "rc-0.5.2" = self.by-version."rc"."0.5.2";
      "request-2.47.0" = self.by-version."request"."2.47.0";
      "semver-2.0.11" = self.by-version."semver"."2.0.11";
      "shelljs-0.3.0" = self.by-version."shelljs"."0.3.0";
      "tar-1.0.2" = self.by-version."tar"."1.0.2";
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
      "xcode-0.6.7" = self.by-version."xcode"."0.6.7";
      "cordova-js-3.7.2" = self.by-version."cordova-js"."3.7.2";
      "d8-0.4.4" = self.by-version."d8"."0.4.4";
      "unorm-1.3.3" = self.by-version."unorm"."1.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cordova-lib" ];
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
      "request-2.49.0" = self.by-version."request"."2.49.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "couch-login" ];
  };
  by-spec."couch-login"."~0.1.18" =
    self.by-version."couch-login"."0.1.20";
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
  by-spec."crc"."3.2.1" =
    self.by-version."crc"."3.2.1";
  by-version."crc"."3.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "crc-3.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc/-/crc-3.2.1.tgz";
        name = "crc-3.2.1.tgz";
        sha1 = "5d9c8fb77a245cd5eca291e5d2d005334bab0082";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "buffer-crc32-0.2.4" = self.by-version."buffer-crc32"."0.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "crc32-stream" ];
  };
  by-spec."create-ecdh"."1.0.0" =
    self.by-version."create-ecdh"."1.0.0";
  by-version."create-ecdh"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "create-ecdh-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/create-ecdh/-/create-ecdh-1.0.0.tgz";
        name = "create-ecdh-1.0.0.tgz";
        sha1 = "7016bf4c68b1000d71d9ccb0112e7105789d4b1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."create-ecdh" or []);
    deps = {
      "bn.js-0.15.2" = self.by-version."bn.js"."0.15.2";
      "elliptic-0.15.15" = self.by-version."elliptic"."0.15.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "create-ecdh" ];
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
    self.by-version."crypto-browserify"."3.6.0";
  by-version."crypto-browserify"."3.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "crypto-browserify-3.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.6.0.tgz";
        name = "crypto-browserify-3.6.0.tgz";
        sha1 = "6f74a6d30cf0bd11ef5168410bbdc7a65f6d01cb";
      })
    ];
    buildInputs =
      (self.nativeDeps."crypto-browserify" or []);
    deps = {
      "browserify-aes-0.6.0" = self.by-version."browserify-aes"."0.6.0";
      "browserify-sign-2.4.0" = self.by-version."browserify-sign"."2.4.0";
      "create-ecdh-1.0.0" = self.by-version."create-ecdh"."1.0.0";
      "diffie-hellman-2.2.0" = self.by-version."diffie-hellman"."2.2.0";
      "pbkdf2-compat-2.0.1" = self.by-version."pbkdf2-compat"."2.0.1";
      "ripemd160-0.2.0" = self.by-version."ripemd160"."0.2.0";
      "sha.js-2.3.0" = self.by-version."sha.js"."2.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "crypto-browserify" ];
  };
  by-spec."crypto-browserify"."~1.0.9" =
    self.by-version."crypto-browserify"."1.0.9";
  by-version."crypto-browserify"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "crypto-browserify-1.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crypto-browserify/-/crypto-browserify-1.0.9.tgz";
        name = "crypto-browserify-1.0.9.tgz";
        sha1 = "cc5449685dfb85eb11c9828acc7cb87ab5bbfcc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."crypto-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "crypto-browserify" ];
  };
  by-spec."csrf"."~2.0.2" =
    self.by-version."csrf"."2.0.2";
  by-version."csrf"."2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "csrf-2.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csrf/-/csrf-2.0.2.tgz";
        name = "csrf-2.0.2.tgz";
        sha1 = "d8d3f1f83705b0acc5ed8995b4eadf4a921959f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."csrf" or []);
    deps = {
      "rndm-1.0.0" = self.by-version."rndm"."1.0.0";
      "scmp-1.0.0" = self.by-version."scmp"."1.0.0";
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
  by-spec."csurf"."1.1.0" =
    self.by-version."csurf"."1.1.0";
  by-version."csurf"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "csurf-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csurf/-/csurf-1.1.0.tgz";
        name = "csurf-1.1.0.tgz";
        sha1 = "5dd459df40df43b9eb828284d6d03132f42cb8b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."csurf" or []);
    deps = {
      "uid2-0.0.3" = self.by-version."uid2"."0.0.3";
      "scmp-0.0.3" = self.by-version."scmp"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "csurf" ];
  };
  by-spec."csurf"."~1.6.2" =
    self.by-version."csurf"."1.6.3";
  by-version."csurf"."1.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "csurf-1.6.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csurf/-/csurf-1.6.3.tgz";
        name = "csurf-1.6.3.tgz";
        sha1 = "042e4d5d4ff02507f24df4fb5252393915cd6d44";
      })
    ];
    buildInputs =
      (self.nativeDeps."csurf" or []);
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "csrf-2.0.2" = self.by-version."csrf"."2.0.2";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "csurf" ];
  };
  by-spec."csurf"."~1.6.3" =
    self.by-version."csurf"."1.6.3";
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
  by-spec."d8"."0.4.4" =
    self.by-version."d8"."0.4.4";
  by-version."d8"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "d8-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/d8/-/d8-0.4.4.tgz";
        name = "d8-0.4.4.tgz";
        sha1 = "5989dd62b90bdd853d3978f1261a4bc76bcf6485";
      })
    ];
    buildInputs =
      (self.nativeDeps."d8" or []);
    deps = {
      "m8-0.4.4" = self.by-version."m8"."0.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "d8" ];
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
    self.by-version."dateformat"."1.0.11";
  by-version."dateformat"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "dateformat-1.0.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.11.tgz";
        name = "dateformat-1.0.11.tgz";
        sha1 = "f27cbee7a012bbfb82ea051562d3977f6093dbb1";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat" or []);
    deps = {
      "get-stdin-3.0.2" = self.by-version."get-stdin"."3.0.2";
      "meow-2.0.0" = self.by-version."meow"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  by-spec."dateformat"."~1.0.6" =
    self.by-version."dateformat"."1.0.11";
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
  by-spec."debug"."0.8.0" =
    self.by-version."debug"."0.8.0";
  by-version."debug"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.8.0.tgz";
        name = "debug-0.8.0.tgz";
        sha1 = "0541ea91f0e503fdf0c5eed418a32550234967f0";
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
  by-spec."debug"."2" =
    self.by-version."debug"."2.1.0";
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
  by-spec."debug"."^0.8.1" =
    self.by-version."debug"."0.8.1";
  by-spec."debug"."^1.0.0" =
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
  by-spec."debug"."^1.0.2" =
    self.by-version."debug"."1.0.4";
  by-spec."debug"."^2.0.0" =
    self.by-version."debug"."2.1.0";
  by-spec."debug"."^2.1.0" =
    self.by-version."debug"."2.1.0";
  by-spec."debug"."~0.7.4" =
    self.by-version."debug"."0.7.4";
  by-spec."debug"."~0.8" =
    self.by-version."debug"."0.8.1";
  by-spec."debug"."~0.8.1" =
    self.by-version."debug"."0.8.1";
  by-spec."debug"."~0.x" =
    self.by-version."debug"."0.8.1";
  by-spec."debug"."~1.0.0" =
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
  by-spec."deep-equal"."~0.1.0" =
    self.by-version."deep-equal"."0.1.2";
  by-version."deep-equal"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.1.2.tgz";
        name = "deep-equal-0.1.2.tgz";
        sha1 = "b246c2b80a570a47c11be1d9bd1070ec878b87ce";
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
  by-spec."deep-equal"."~0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-spec."deep-extend"."~0.2.5" =
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
  by-spec."deep-extend"."~0.3.2" =
    self.by-version."deep-extend"."0.3.2";
  by-version."deep-extend"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "deep-extend-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.3.2.tgz";
        name = "deep-extend-0.3.2.tgz";
        sha1 = "c75dff89f1c639e98438894d156c30b4f87b3a56";
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
  by-spec."defined"."0.0.0" =
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
  by-spec."defined"."~0.0.0" =
    self.by-version."defined"."0.0.0";
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
  by-spec."dep-graph"."1.1.0" =
    self.by-version."dep-graph"."1.1.0";
  by-version."dep-graph"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "dep-graph-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dep-graph/-/dep-graph-1.1.0.tgz";
        name = "dep-graph-1.1.0.tgz";
        sha1 = "fade86a92799a813e9b42511cdf3dfa6cc8dbefe";
      })
    ];
    buildInputs =
      (self.nativeDeps."dep-graph" or []);
    deps = {
      "underscore-1.2.1" = self.by-version."underscore"."1.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dep-graph" ];
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
  by-spec."deps-sort"."~0.1.1" =
    self.by-version."deps-sort"."0.1.2";
  by-version."deps-sort"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "deps-sort-0.1.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deps-sort/-/deps-sort-0.1.2.tgz";
        name = "deps-sort-0.1.2.tgz";
        sha1 = "daa2fb614a17c9637d801e2f55339ae370f3611a";
      })
    ];
    buildInputs =
      (self.nativeDeps."deps-sort" or []);
    deps = {
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "JSONStream-0.6.4" = self.by-version."JSONStream"."0.6.4";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "deps-sort" ];
  };
  by-spec."derequire"."~0.6.0" =
    self.by-version."derequire"."0.6.1";
  by-version."derequire"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "derequire-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/derequire/-/derequire-0.6.1.tgz";
        name = "derequire-0.6.1.tgz";
        sha1 = "cce8ee25380de715deb61900f0bdd38222928788";
      })
    ];
    buildInputs =
      (self.nativeDeps."derequire" or []);
    deps = {
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "esprima-six-0.0.3" = self.by-version."esprima-six"."0.0.3";
      "esrefactor-0.1.0" = self.by-version."esrefactor"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "derequire" ];
  };
  by-spec."derequire"."~0.8.0" =
    self.by-version."derequire"."0.8.0";
  by-version."derequire"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "derequire-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/derequire/-/derequire-0.8.0.tgz";
        name = "derequire-0.8.0.tgz";
        sha1 = "c1f7f1da2cede44adede047378f03f444e9c4c0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."derequire" or []);
    deps = {
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "esrefactor-0.1.0" = self.by-version."esrefactor"."0.1.0";
      "esprima-fb-3001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
    };
    peerDependencies = [
    ];
    passthru.names = [ "derequire" ];
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
  by-spec."detective"."^4.0.0" =
    self.by-version."detective"."4.0.0";
  by-version."detective"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "detective-4.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/detective/-/detective-4.0.0.tgz";
        name = "detective-4.0.0.tgz";
        sha1 = "9ffdb5555ddb1571fdbdc6f4ceac08e5e4cf8467";
      })
    ];
    buildInputs =
      (self.nativeDeps."detective" or []);
    deps = {
      "acorn-0.9.0" = self.by-version."acorn"."0.9.0";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "escodegen-1.4.1" = self.by-version."escodegen"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "detective" ];
  };
  by-spec."detective"."~2.1.2" =
    self.by-version."detective"."2.1.2";
  by-version."detective"."2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "detective-2.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/detective/-/detective-2.1.2.tgz";
        name = "detective-2.1.2.tgz";
        sha1 = "d22ad9f18c82efb3f55fee2e244883da6bbb8e37";
      })
    ];
    buildInputs =
      (self.nativeDeps."detective" or []);
    deps = {
      "esprima-1.0.2" = self.by-version."esprima"."1.0.2";
      "escodegen-0.0.15" = self.by-version."escodegen"."0.0.15";
    };
    peerDependencies = [
    ];
    passthru.names = [ "detective" ];
  };
  by-spec."detective"."~3.1.0" =
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
  by-spec."diff"."~1.0.7" =
    self.by-version."diff"."1.0.8";
  by-spec."diff"."~1.0.8" =
    self.by-version."diff"."1.0.8";
  by-spec."diffie-hellman"."2.2.0" =
    self.by-version."diffie-hellman"."2.2.0";
  by-version."diffie-hellman"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "diffie-hellman-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diffie-hellman/-/diffie-hellman-2.2.0.tgz";
        name = "diffie-hellman-2.2.0.tgz";
        sha1 = "8072c466fbfb68e7898a84c56e53bc4e71a4c2e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."diffie-hellman" or []);
    deps = {
      "bn.js-0.15.2" = self.by-version."bn.js"."0.15.2";
      "miller-rabin-1.1.1" = self.by-version."miller-rabin"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "diffie-hellman" ];
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
      "mimelib-0.2.18" = self.by-version."mimelib"."0.2.18";
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
    self.by-version."domelementtype"."1.1.3";
  by-version."domelementtype"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "domelementtype-1.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.3.tgz";
        name = "domelementtype-1.1.3.tgz";
        sha1 = "bd28773e2642881aec51544924299c5cd822185b";
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
  by-spec."domhandler"."2.3" =
    self.by-version."domhandler"."2.3.0";
  by-version."domhandler"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "domhandler-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.3.0.tgz";
        name = "domhandler-2.3.0.tgz";
        sha1 = "2de59a0822d5027fabff6f032c2b25a2a8abe738";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
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
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
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
  by-spec."duplexer"."~0.1.1" =
    self.by-version."duplexer"."0.1.1";
  by-version."duplexer"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "duplexer-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz";
        name = "duplexer-0.1.1.tgz";
        sha1 = "ace6ff808c1ce66b57d1ebf97977acb02334cfc1";
      })
    ];
    buildInputs =
      (self.nativeDeps."duplexer" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "duplexer" ];
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
  by-spec."editor"."0.0.4" =
    self.by-version."editor"."0.0.4";
  by-version."editor"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "editor-0.0.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/editor/-/editor-0.0.4.tgz";
        name = "editor-0.0.4.tgz";
        sha1 = "478920f77bca6c1c1749d5e3edde4bd5966efda8";
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
  by-spec."editor"."0.0.5" =
    self.by-version."editor"."0.0.5";
  by-version."editor"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "editor-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/editor/-/editor-0.0.5.tgz";
        name = "editor-0.0.5.tgz";
        sha1 = "8c38877781f2547011c1aeffdbe50cafcc59794a";
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
  by-spec."ee-first"."1.1.0" =
    self.by-version."ee-first"."1.1.0";
  by-version."ee-first"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ee-first-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ee-first/-/ee-first-1.1.0.tgz";
        name = "ee-first-1.1.0.tgz";
        sha1 = "6a0d7c6221e490feefd92ec3f441c9ce8cd097f4";
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
  by-spec."elementtree"."0.1.5" =
    self.by-version."elementtree"."0.1.5";
  by-version."elementtree"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "elementtree-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/elementtree/-/elementtree-0.1.5.tgz";
        name = "elementtree-0.1.5.tgz";
        sha1 = "8d5fd80440b4be806c4a01b63914b40e0daab9ff";
      })
    ];
    buildInputs =
      (self.nativeDeps."elementtree" or []);
    deps = {
      "sax-0.3.5" = self.by-version."sax"."0.3.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "elementtree" ];
  };
  by-spec."elliptic"."^0.15.14" =
    self.by-version."elliptic"."0.15.15";
  by-version."elliptic"."0.15.15" = lib.makeOverridable self.buildNodePackage {
    name = "elliptic-0.15.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/elliptic/-/elliptic-0.15.15.tgz";
        name = "elliptic-0.15.15.tgz";
        sha1 = "63269184a856d6e00871e84f37a8401ff84e4aea";
      })
    ];
    buildInputs =
      (self.nativeDeps."elliptic" or []);
    deps = {
      "bn.js-0.15.2" = self.by-version."bn.js"."0.15.2";
      "brorand-1.0.5" = self.by-version."brorand"."1.0.5";
      "hash.js-0.2.1" = self.by-version."hash.js"."0.2.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "elliptic" ];
  };
  by-spec."encoding"."~0.1.7" =
    self.by-version."encoding"."0.1.11";
  by-version."encoding"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "encoding-0.1.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/encoding/-/encoding-0.1.11.tgz";
        name = "encoding-0.1.11.tgz";
        sha1 = "52c65ac15aab467f1338451e2615f988eccc0258";
      })
    ];
    buildInputs =
      (self.nativeDeps."encoding" or []);
    deps = {
      "iconv-lite-0.4.5" = self.by-version."iconv-lite"."0.4.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "encoding" ];
  };
  by-spec."end-of-stream"."^0.1.4" =
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
    self.by-version."envify"."3.2.0";
  by-version."envify"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "envify-3.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/envify/-/envify-3.2.0.tgz";
        name = "envify-3.2.0.tgz";
        sha1 = "dda33c49ce4cc20efd1fda60dab9dd317c38ef7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."envify" or []);
    deps = {
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "jstransform-7.0.0" = self.by-version."jstransform"."7.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "envify" ];
  };
  by-spec."errorhandler"."1.0.0" =
    self.by-version."errorhandler"."1.0.0";
  by-version."errorhandler"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "errorhandler-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/errorhandler/-/errorhandler-1.0.0.tgz";
        name = "errorhandler-1.0.0.tgz";
        sha1 = "d74b37e8dc38c99afb3f5a79edcebaea022d042a";
      })
    ];
    buildInputs =
      (self.nativeDeps."errorhandler" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "errorhandler" ];
  };
  by-spec."errorhandler"."~1.2.2" =
    self.by-version."errorhandler"."1.2.3";
  by-version."errorhandler"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "errorhandler-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/errorhandler/-/errorhandler-1.2.3.tgz";
        name = "errorhandler-1.2.3.tgz";
        sha1 = "913bcc8cd1f10b6caeab4b38c1bc71fa3884ea52";
      })
    ];
    buildInputs =
      (self.nativeDeps."errorhandler" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "errorhandler" ];
  };
  by-spec."errorhandler"."~1.2.3" =
    self.by-version."errorhandler"."1.2.3";
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
      "es6-iterator-0.1.2" = self.by-version."es6-iterator"."0.1.2";
      "es6-symbol-0.1.1" = self.by-version."es6-symbol"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "es5-ext" ];
  };
  by-spec."es5-ext"."~0.10.4" =
    self.by-version."es5-ext"."0.10.4";
  by-spec."es6-iterator"."~0.1.1" =
    self.by-version."es6-iterator"."0.1.2";
  by-version."es6-iterator"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "es6-iterator-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es6-iterator/-/es6-iterator-0.1.2.tgz";
        name = "es6-iterator-0.1.2.tgz";
        sha1 = "a37429ead74e5c9ed95068b0dc904c568d9a9b6a";
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
  by-spec."es6-symbol"."~0.1.1" =
    self.by-version."es6-symbol"."0.1.1";
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
      "es6-iterator-0.1.2" = self.by-version."es6-iterator"."0.1.2";
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
  by-spec."escodegen"."0.0.15" =
    self.by-version."escodegen"."0.0.15";
  by-version."escodegen"."0.0.15" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-0.0.15";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-0.0.15.tgz";
        name = "escodegen-0.0.15.tgz";
        sha1 = "ffda9cb26b70b34f7cc19f1d88756539afb543bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "esprima-1.2.2" = self.by-version."esprima"."1.2.2";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escodegen"."0.0.17" =
    self.by-version."escodegen"."0.0.17";
  by-version."escodegen"."0.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-0.0.17";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-0.0.17.tgz";
        name = "escodegen-0.0.17.tgz";
        sha1 = "1e78d17df1004fd7a88f2fed3b8b8592f3217f9c";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "estraverse-0.0.4" = self.by-version."estraverse"."0.0.4";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
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
  by-spec."escodegen"."^1.4.1" =
    self.by-version."escodegen"."1.4.1";
  by-version."escodegen"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-1.4.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.4.1.tgz";
        name = "escodegen-1.4.1.tgz";
        sha1 = "8c2562ff45da348975953e8c0a57f40848962ec7";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "estraverse-1.8.0" = self.by-version."estraverse"."1.8.0";
      "esutils-1.1.6" = self.by-version."esutils"."1.1.6";
      "esprima-1.2.2" = self.by-version."esprima"."1.2.2";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
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
  by-spec."escope"."~0.0.13" =
    self.by-version."escope"."0.0.16";
  by-version."escope"."0.0.16" = lib.makeOverridable self.buildNodePackage {
    name = "escope-0.0.16";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escope/-/escope-0.0.16.tgz";
        name = "escope-0.0.16.tgz";
        sha1 = "418c7a0afca721dafe659193fd986283e746538f";
      })
    ];
    buildInputs =
      (self.nativeDeps."escope" or []);
    deps = {
      "estraverse-1.8.0" = self.by-version."estraverse"."1.8.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escope" ];
  };
  by-spec."esprima"."1.0.2" =
    self.by-version."esprima"."1.0.2";
  by-version."esprima"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.2.tgz";
        name = "esprima-1.0.2.tgz";
        sha1 = "8039bf9ceac4d9d2c15f623264fb292b5502ceaf";
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
  by-spec."esprima".">= 1.0.0" =
    self.by-version."esprima"."1.2.2";
  by-spec."esprima"."^1.2.2" =
    self.by-version."esprima"."1.2.2";
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
  by-spec."esprima"."~0.9.9" =
    self.by-version."esprima"."0.9.9";
  by-version."esprima"."0.9.9" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-0.9.9";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-0.9.9.tgz";
        name = "esprima-0.9.9.tgz";
        sha1 = "1b90925c975d632d7282939c3bb9c3a423c30490";
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
  by-spec."esprima-fb"."^3001.1.0-dev-harmony-fb" =
    self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
  by-spec."esprima-fb"."~7001.0001.0000-dev-harmony-fb" =
    self.by-version."esprima-fb"."7001.1.0-dev-harmony-fb";
  by-version."esprima-fb"."7001.1.0-dev-harmony-fb" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-fb-7001.1.0-dev-harmony-fb";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima-fb/-/esprima-fb-7001.1.0-dev-harmony-fb.tgz";
        name = "esprima-fb-7001.1.0-dev-harmony-fb.tgz";
        sha1 = "907e20919575a667dd1b42335de00cf6646d77b3";
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
  by-spec."esprima-six"."0.0.3" =
    self.by-version."esprima-six"."0.0.3";
  by-version."esprima-six"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-six-0.0.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima-six/-/esprima-six-0.0.3.tgz";
        name = "esprima-six-0.0.3.tgz";
        sha1 = "8eb750435b02d3e50cf09b5736cbce4606a4399f";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima-six" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima-six" ];
  };
  by-spec."esprima-six"."~0.0.3" =
    self.by-version."esprima-six"."0.0.3";
  by-spec."esrefactor"."~0.1.0" =
    self.by-version."esrefactor"."0.1.0";
  by-version."esrefactor"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "esrefactor-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esrefactor/-/esrefactor-0.1.0.tgz";
        name = "esrefactor-0.1.0.tgz";
        sha1 = "d142795a282339ab81e936b5b7a21b11bf197b13";
      })
    ];
    buildInputs =
      (self.nativeDeps."esrefactor" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "estraverse-0.0.4" = self.by-version."estraverse"."0.0.4";
      "escope-0.0.16" = self.by-version."escope"."0.0.16";
    };
    peerDependencies = [
    ];
    passthru.names = [ "esrefactor" ];
  };
  by-spec."estraverse".">= 0.0.2" =
    self.by-version."estraverse"."1.8.0";
  by-version."estraverse"."1.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.8.0.tgz";
        name = "estraverse-1.8.0.tgz";
        sha1 = "3f1264fb62c8500dbae5e4f73705cd576d6af428";
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
  by-spec."estraverse"."^1.5.1" =
    self.by-version."estraverse"."1.8.0";
  by-spec."estraverse"."~0.0.4" =
    self.by-version."estraverse"."0.0.4";
  by-version."estraverse"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-0.0.4.tgz";
        name = "estraverse-0.0.4.tgz";
        sha1 = "01a0932dfee574684a598af5a67c3bf9b6428db2";
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
  by-spec."estraverse"."~1.8.0" =
    self.by-version."estraverse"."1.8.0";
  by-spec."esutils"."^1.1.4" =
    self.by-version."esutils"."1.1.6";
  by-version."esutils"."1.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "esutils-1.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esutils/-/esutils-1.1.6.tgz";
        name = "esutils-1.1.6.tgz";
        sha1 = "c01ccaa9ae4b897c6d0c3e210ae52f3c7a844375";
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
    self.by-version."etag"."1.5.1";
  by-version."etag"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "etag-1.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/etag/-/etag-1.5.1.tgz";
        name = "etag-1.5.1.tgz";
        sha1 = "54c50de04ee42695562925ac566588291be7e9ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."etag" or []);
    deps = {
      "crc-3.2.1" = self.by-version."crc"."3.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "etag" ];
  };
  by-spec."etag"."~1.5.1" =
    self.by-version."etag"."1.5.1";
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
    self.by-version."eventemitter3"."0.1.6";
  by-version."eventemitter3"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter3-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter3/-/eventemitter3-0.1.6.tgz";
        name = "eventemitter3-0.1.6.tgz";
        sha1 = "8c7ac44b87baab55cd50c828dc38778eac052ea5";
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
      "express-3.18.4" = self.by-version."express"."3.18.4";
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
    self.by-version."express"."5.0.0-alpha.1";
  by-version."express"."5.0.0-alpha.1" = lib.makeOverridable self.buildNodePackage {
    name = "express-5.0.0-alpha.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-5.0.0-alpha.1.tgz";
        name = "express-5.0.0-alpha.1.tgz";
        sha1 = "415df02c51ae01c221362fca59b03591d956b2d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "finalhandler-0.3.2" = self.by-version."finalhandler"."0.3.2";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "on-finished-2.1.1" = self.by-version."on-finished"."2.1.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.4" = self.by-version."proxy-addr"."1.0.4";
      "qs-2.3.2" = self.by-version."qs"."2.3.2";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.10.1" = self.by-version."send"."0.10.1";
      "serve-static-1.7.1" = self.by-version."serve-static"."1.7.1";
      "type-is-1.5.3" = self.by-version."type-is"."1.5.3";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  "express" = self.by-version."express"."5.0.0-alpha.1";
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
      "buffer-crc32-0.2.4" = self.by-version."buffer-crc32"."0.2.4";
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
    self.by-version."express"."3.18.4";
  by-version."express"."3.18.4" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.18.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.18.4.tgz";
        name = "express-3.18.4.tgz";
        sha1 = "7b40ad2c10a987692ee97a387c21593011f03712";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "connect-2.27.4" = self.by-version."connect"."2.27.4";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "commander-1.3.2" = self.by-version."commander"."1.3.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "proxy-addr-1.0.4" = self.by-version."proxy-addr"."1.0.4";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.10.1" = self.by-version."send"."0.10.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express".">=3.0.0" =
    self.by-version."express"."5.0.0-alpha.1";
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
      "buffer-crc32-0.2.4" = self.by-version."buffer-crc32"."0.2.4";
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
  by-spec."express"."~3.5.1" =
    self.by-version."express"."3.5.3";
  by-version."express"."3.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.5.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.5.3.tgz";
        name = "express-3.5.3.tgz";
        sha1 = "af440e1ddad078934ec78241420b40bbc56dc2ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "connect-2.14.5" = self.by-version."connect"."2.14.5";
      "commander-1.3.2" = self.by-version."commander"."1.3.2";
      "range-parser-1.0.0" = self.by-version."range-parser"."1.0.0";
      "mkdirp-0.4.0" = self.by-version."mkdirp"."0.4.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "fresh-0.2.2" = self.by-version."fresh"."0.2.2";
      "methods-0.1.0" = self.by-version."methods"."0.1.0";
      "send-0.3.0" = self.by-version."send"."0.3.0";
      "cookie-signature-1.0.3" = self.by-version."cookie-signature"."1.0.3";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
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
  by-spec."express"."~4.10.3" =
    self.by-version."express"."4.10.4";
  by-version."express"."4.10.4" = lib.makeOverridable self.buildNodePackage {
    name = "express-4.10.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.10.4.tgz";
        name = "express-4.10.4.tgz";
        sha1 = "31aa70acdad6b6093945c30523df8537336deb58";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "finalhandler-0.3.2" = self.by-version."finalhandler"."0.3.2";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "on-finished-2.1.1" = self.by-version."on-finished"."2.1.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.4" = self.by-version."proxy-addr"."1.0.4";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.10.1" = self.by-version."send"."0.10.1";
      "serve-static-1.7.1" = self.by-version."serve-static"."1.7.1";
      "type-is-1.5.3" = self.by-version."type-is"."1.5.3";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."express-form"."*" =
    self.by-version."express-form"."0.12.4";
  by-version."express-form"."0.12.4" = lib.makeOverridable self.buildNodePackage {
    name = "express-form-0.12.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-form/-/express-form-0.12.4.tgz";
        name = "express-form-0.12.4.tgz";
        sha1 = "d671fa5887acf32a005618ce8b652f67b30e2cb1";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-form" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "object-additions-0.5.1" = self.by-version."object-additions"."0.5.1";
      "validator-2.1.0" = self.by-version."validator"."2.1.0";
    };
    peerDependencies = [
      self.by-version."express"."5.0.0-alpha.1"
    ];
    passthru.names = [ "express-form" ];
  };
  "express-form" = self.by-version."express-form"."0.12.4";
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
  by-spec."express-session"."1.0.2" =
    self.by-version."express-session"."1.0.2";
  by-version."express-session"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "express-session-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-session/-/express-session-1.0.2.tgz";
        name = "express-session-1.0.2.tgz";
        sha1 = "004478c742561774411ceb79733155a56b6d49eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-session" or []);
    deps = {
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "cookie-0.1.0" = self.by-version."cookie"."0.1.0";
      "cookie-signature-1.0.3" = self.by-version."cookie-signature"."1.0.3";
      "uid2-0.0.3" = self.by-version."uid2"."0.0.3";
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express-session" ];
  };
  by-spec."express-session"."~1.8.2" =
    self.by-version."express-session"."1.8.2";
  by-version."express-session"."1.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "express-session-1.8.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-session/-/express-session-1.8.2.tgz";
        name = "express-session-1.8.2.tgz";
        sha1 = "c4011e728a2349b3c18f117a5409908985e83483";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-session" or []);
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "crc-3.0.0" = self.by-version."crc"."3.0.0";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "depd-0.4.5" = self.by-version."depd"."0.4.5";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "uid-safe-1.0.1" = self.by-version."uid-safe"."1.0.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express-session" ];
  };
  by-spec."express-session"."~1.9.2" =
    self.by-version."express-session"."1.9.2";
  by-version."express-session"."1.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "express-session-1.9.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-session/-/express-session-1.9.2.tgz";
        name = "express-session-1.9.2.tgz";
        sha1 = "cb831ff8d2d9cb6e64c167f678af6f62ae6bb076";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-session" or []);
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "crc-3.2.1" = self.by-version."crc"."3.2.1";
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
  by-spec."extend.js"."0.0.1" =
    self.by-version."extend.js"."0.0.1";
  by-version."extend.js"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "extend.js-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend.js/-/extend.js-0.0.1.tgz";
        name = "extend.js-0.0.1.tgz";
        sha1 = "814c453f41201a11e05ea080a4a71f016994ad0b";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extend.js" ];
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
  by-spec."eyes"."~0.1.6" =
    self.by-version."eyes"."0.1.8";
  by-spec."falafel"."~0.1.6" =
    self.by-version."falafel"."0.1.6";
  by-version."falafel"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "falafel-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/falafel/-/falafel-0.1.6.tgz";
        name = "falafel-0.1.6.tgz";
        sha1 = "3084cf3d41b59d15c813be6f259557fdc82b0660";
      })
    ];
    buildInputs =
      (self.nativeDeps."falafel" or []);
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "falafel" ];
  };
  by-spec."faye-websocket"."*" =
    self.by-version."faye-websocket"."0.8.1";
  by-version."faye-websocket"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.8.1.tgz";
        name = "faye-websocket-0.8.1.tgz";
        sha1 = "c1eb3f3aad85f0eb505057332690163297b0ea26";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket" or []);
    deps = {
      "websocket-driver-0.4.0" = self.by-version."websocket-driver"."0.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  "faye-websocket" = self.by-version."faye-websocket"."0.8.1";
  by-spec."faye-websocket".">= 0.4.1" =
    self.by-version."faye-websocket"."0.8.1";
  by-spec."faye-websocket"."^0.7.3 || ^0.8.0" =
    self.by-version."faye-websocket"."0.8.1";
  by-spec."faye-websocket"."~0.7.0" =
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
      "websocket-driver-0.4.0" = self.by-version."websocket-driver"."0.4.0";
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
    self.by-version."fields"."0.1.23";
  by-version."fields"."0.1.23" = lib.makeOverridable self.buildNodePackage {
    name = "fields-0.1.23";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fields/-/fields-0.1.23.tgz";
        name = "fields-0.1.23.tgz";
        sha1 = "6ad465e4294a78870aaeb4a63517576f704732f3";
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
  by-spec."fifo"."^0.1.4" =
    self.by-version."fifo"."0.1.4";
  by-version."fifo"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "fifo-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fifo/-/fifo-0.1.4.tgz";
        name = "fifo-0.1.4.tgz";
        sha1 = "bf42d87c0ad07b00d0949d12388f6289606ece34";
      })
    ];
    buildInputs =
      (self.nativeDeps."fifo" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fifo" ];
  };
  by-spec."figures"."^1.0.1" =
    self.by-version."figures"."1.3.5";
  by-version."figures"."1.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "figures-1.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/figures/-/figures-1.3.5.tgz";
        name = "figures-1.3.5.tgz";
        sha1 = "d1a31f4e1d2c2938ecde5c06aa16134cf29f4771";
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
    self.by-version."figures"."1.3.5";
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
  by-spec."finalhandler"."0.3.2" =
    self.by-version."finalhandler"."0.3.2";
  by-version."finalhandler"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "finalhandler-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.3.2.tgz";
        name = "finalhandler-0.3.2.tgz";
        sha1 = "7b389b0fd3647a6f90bd564e22624bf8a4a77fb5";
      })
    ];
    buildInputs =
      (self.nativeDeps."finalhandler" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.1.1" = self.by-version."on-finished"."2.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "finalhandler" ];
  };
  by-spec."find-index"."^0.1.1" =
    self.by-version."find-index"."0.1.1";
  by-version."find-index"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "find-index-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/find-index/-/find-index-0.1.1.tgz";
        name = "find-index-0.1.1.tgz";
        sha1 = "675d358b2ca3892d795a1ab47232f8b6e2e0dde4";
      })
    ];
    buildInputs =
      (self.nativeDeps."find-index" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "find-index" ];
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
  by-spec."flatiron"."~0.4.2" =
    self.by-version."flatiron"."0.4.2";
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
    self.by-version."forever"."0.13.0";
  by-version."forever"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-0.13.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever/-/forever-0.13.0.tgz";
        name = "forever-0.13.0.tgz";
        sha1 = "30857921b37994295a23ca1266628fb3aa2c2c00";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cliff-0.1.9" = self.by-version."cliff"."0.1.9";
      "flatiron-0.4.2" = self.by-version."flatiron"."0.4.2";
      "forever-monitor-1.5.2" = self.by-version."forever-monitor"."1.5.2";
      "nconf-0.6.9" = self.by-version."nconf"."0.6.9";
      "nssocket-0.5.2" = self.by-version."nssocket"."0.5.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "timespan-2.3.0" = self.by-version."timespan"."2.3.0";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
      "winston-0.8.3" = self.by-version."winston"."0.8.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever" ];
  };
  "forever" = self.by-version."forever"."0.13.0";
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
    self.by-version."forever-monitor"."1.5.2";
  by-version."forever-monitor"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.5.2.tgz";
        name = "forever-monitor-1.5.2.tgz";
        sha1 = "279388dfa93b085363d6b28a823ef0a6aeeb35d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor" or []);
    deps = {
      "broadway-0.3.6" = self.by-version."broadway"."0.3.6";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "ps-tree-0.0.3" = self.by-version."ps-tree"."0.0.3";
      "watch-0.13.0" = self.by-version."watch"."0.13.0";
      "utile-0.2.1" = self.by-version."utile"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  "forever-monitor" = self.by-version."forever-monitor"."1.5.2";
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
  by-spec."forever-monitor"."~1.5.1" =
    self.by-version."forever-monitor"."1.5.2";
  by-spec."form-data"."0.0.8" =
    self.by-version."form-data"."0.0.8";
  by-version."form-data"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.8.tgz";
        name = "form-data-0.0.8.tgz";
        sha1 = "0890cd1005c5ccecc0b9d24a88052c92442d0db5";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.2.10" = self.by-version."async"."0.2.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
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
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
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
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
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
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."formatio"."~1.1.1" =
    self.by-version."formatio"."1.1.1";
  by-version."formatio"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "formatio-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formatio/-/formatio-1.1.1.tgz";
        name = "formatio-1.1.1.tgz";
        sha1 = "5ed3ccd636551097383465d996199100e86161e9";
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
  by-spec."fs-vacuum"."~1.2.2" =
    self.by-version."fs-vacuum"."1.2.2";
  by-version."fs-vacuum"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "fs-vacuum-1.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-vacuum/-/fs-vacuum-1.2.2.tgz";
        name = "fs-vacuum-1.2.2.tgz";
        sha1 = "0e26ca2b14eb4ceb4b590a92aad585756ed18e40";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-vacuum" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
  by-spec."fsevents"."~0.3.1" =
    self.by-version."fsevents"."0.3.1";
  by-version."fsevents"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "fsevents-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fsevents/-/fsevents-0.3.1.tgz";
        name = "fsevents-0.3.1.tgz";
        sha1 = "47d60e5c28887055d7388833ea5d54d4882c8f6f";
      })
    ];
    buildInputs =
      (self.nativeDeps."fsevents" or []);
    deps = {
      "nan-1.3.0" = self.by-version."nan"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fsevents" ];
  };
  by-spec."fstream"."0" =
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."^1.0.0" =
    self.by-version."fstream"."1.0.3";
  by-version."fstream"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-1.0.3.tgz";
        name = "fstream-1.0.3.tgz";
        sha1 = "5ce69767710d7a39c8cd9232470d9426790195da";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."^1.0.2" =
    self.by-version."fstream"."1.0.3";
  by-spec."fstream"."~0.1.23" =
    self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~0.1.25" =
    self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~0.1.28" =
    self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~0.1.8" =
    self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~1.0.2" =
    self.by-version."fstream"."1.0.3";
  by-spec."fstream"."~1.0.3" =
    self.by-version."fstream"."1.0.3";
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
      "fstream-1.0.3" = self.by-version."fstream"."1.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream-ignore" ];
  };
  by-spec."fstream-ignore"."~1.0.1" =
    self.by-version."fstream-ignore"."1.0.1";
  by-spec."fstream-npm"."~0.1.3" =
    self.by-version."fstream-npm"."0.1.8";
  by-version."fstream-npm"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-npm-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-npm/-/fstream-npm-0.1.8.tgz";
        name = "fstream-npm-0.1.8.tgz";
        sha1 = "38a70fdeb510a443e1a5378d90413403fc724fa8";
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
  by-spec."fstream-npm"."~0.1.6" =
    self.by-version."fstream-npm"."0.1.8";
  by-spec."fstream-npm"."~1.0.1" =
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
  by-spec."get-stdin"."*" =
    self.by-version."get-stdin"."3.0.2";
  by-version."get-stdin"."3.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "get-stdin-3.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/get-stdin/-/get-stdin-3.0.2.tgz";
        name = "get-stdin-3.0.2.tgz";
        sha1 = "c1ced24b9039b38ded85bdf161e57713b6dd4abe";
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
  by-spec."get-stdin"."^3.0.0" =
    self.by-version."get-stdin"."3.0.2";
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
    self.by-version."git-run"."0.3.0";
  by-version."git-run"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "git-run-0.3.0";
    bin = true;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/git-run/-/git-run-0.3.0.tgz";
        name = "git-run-0.3.0.tgz";
        sha1 = "6ac02b93a93e10803ebfec8a5703fb416cafc0b1";
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
  "git-run" = self.by-version."git-run"."0.3.0";
  by-spec."github-url-from-git"."1.1.1" =
    self.by-version."github-url-from-git"."1.1.1";
  by-version."github-url-from-git"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-git-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-git/-/github-url-from-git-1.1.1.tgz";
        name = "github-url-from-git-1.1.1.tgz";
        sha1 = "1f89623453123ef9623956e264c60bf4c3cf5ccf";
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
  by-spec."github-url-from-git"."~1.1.1" =
    self.by-version."github-url-from-git"."1.1.1";
  by-spec."github-url-from-git"."~1.4.0" =
    self.by-version."github-url-from-git"."1.4.0";
  by-spec."github-url-from-username-repo"."0.0.2" =
    self.by-version."github-url-from-username-repo"."0.0.2";
  by-version."github-url-from-username-repo"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-username-repo-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-username-repo/-/github-url-from-username-repo-0.0.2.tgz";
        name = "github-url-from-username-repo-0.0.2.tgz";
        sha1 = "0d9ee8e2bca36d5f065a1bcd23eb3f1fa3d636bd";
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
  by-spec."github-url-from-username-repo"."^0.1.0" =
    self.by-version."github-url-from-username-repo"."0.1.0";
  by-version."github-url-from-username-repo"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-username-repo-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-username-repo/-/github-url-from-username-repo-0.1.0.tgz";
        name = "github-url-from-username-repo-0.1.0.tgz";
        sha1 = "fe398af670692e91af7bcfc5ae1d99ff97b1df89";
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
  by-spec."glob"."3" =
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
  by-spec."glob"."3 || 4" =
    self.by-version."glob"."4.2.2";
  by-version."glob"."4.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "glob-4.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-4.2.2.tgz";
        name = "glob-4.2.2.tgz";
        sha1 = "ad2b047653a58c387e15deb43a19497f83fd2a80";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
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
  by-spec."glob"."3.x" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."4.0.6" =
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."4.x" =
    self.by-version."glob"."4.2.2";
  by-spec."glob".">=3.2.7 <4" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."^4.0.0" =
    self.by-version."glob"."4.2.2";
  by-spec."glob"."^4.0.2" =
    self.by-version."glob"."4.2.2";
  by-spec."glob"."^4.0.5" =
    self.by-version."glob"."4.2.2";
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
  by-spec."glob"."~3.2.3" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.6" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.7" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.8" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.9" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~4.0.2" =
    self.by-version."glob"."4.0.6";
  by-spec."glob"."~4.0.6" =
    self.by-version."glob"."4.0.6";
  by-spec."glob"."~4.2.1" =
    self.by-version."glob"."4.2.2";
  by-spec."glob-stream"."^3.1.5" =
    self.by-version."glob-stream"."3.1.17";
  by-version."glob-stream"."3.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "glob-stream-3.1.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob-stream/-/glob-stream-3.1.17.tgz";
        name = "glob-stream-3.1.17.tgz";
        sha1 = "bc3093856149bf9b7454935abe523ec7ab26ec1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob-stream" or []);
    deps = {
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "ordered-read-streams-0.1.0" = self.by-version."ordered-read-streams"."0.1.0";
      "glob2base-0.0.12" = self.by-version."glob2base"."0.0.12";
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
  by-spec."glob2base"."^0.0.12" =
    self.by-version."glob2base"."0.0.12";
  by-version."glob2base"."0.0.12" = lib.makeOverridable self.buildNodePackage {
    name = "glob2base-0.0.12";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob2base/-/glob2base-0.0.12.tgz";
        name = "glob2base-0.0.12.tgz";
        sha1 = "9d419b3e28f12e83a362164a277055922c9c0d56";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob2base" or []);
    deps = {
      "find-index-0.1.1" = self.by-version."find-index"."0.1.1";
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
  by-spec."graceful-fs"."1.2" =
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
  by-spec."graceful-fs"."2" =
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
  by-spec."graceful-fs"."2 || 3" =
    self.by-version."graceful-fs"."3.0.5";
  by-version."graceful-fs"."3.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-3.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.5.tgz";
        name = "graceful-fs-3.0.5.tgz";
        sha1 = "4a880474bdeb716fe3278cf29792dec38dfac418";
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
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs".">3.0.1 <4.0.0-0" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."^3.0.0" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."^3.0.2" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."^3.0.4" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."~1" =
    self.by-version."graceful-fs"."1.2.3";
  by-spec."graceful-fs"."~1.2.0" =
    self.by-version."graceful-fs"."1.2.3";
  by-spec."graceful-fs"."~2" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~2.0.0" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~2.0.1" =
    self.by-version."graceful-fs"."2.0.3";
  by-spec."graceful-fs"."~3.0.0" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."~3.0.1" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."~3.0.2" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."~3.0.4" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."gridfs-stream"."*" =
    self.by-version."gridfs-stream"."0.5.3";
  by-version."gridfs-stream"."0.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "gridfs-stream-0.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gridfs-stream/-/gridfs-stream-0.5.3.tgz";
        name = "gridfs-stream-0.5.3.tgz";
        sha1 = "c0896728fa3ea83f5fa3c9ced461afb7a036d149";
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
  "gridfs-stream" = self.by-version."gridfs-stream"."0.5.3";
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
      "which-1.0.7" = self.by-version."which"."1.0.7";
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
      "clean-css-2.2.19" = self.by-version."clean-css"."2.2.19";
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
      "jshint-2.5.10" = self.by-version."jshint"."2.5.10";
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"
    ];
    passthru.names = [ "grunt-contrib-jshint" ];
  };
  "grunt-contrib-jshint" = self.by-version."grunt-contrib-jshint"."0.10.0";
  by-spec."grunt-contrib-less"."*" =
    self.by-version."grunt-contrib-less"."0.12.0";
  by-version."grunt-contrib-less"."0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-less-0.12.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-less/-/grunt-contrib-less-0.12.0.tgz";
        name = "grunt-contrib-less-0.12.0.tgz";
        sha1 = "ee6a41b5f94bbe96b5f0d86b16e061c114b954be";
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
  "grunt-contrib-less" = self.by-version."grunt-contrib-less"."0.12.0";
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
      self.by-version."karma"."0.12.28"
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
      "which-1.0.7" = self.by-version."which"."1.0.7";
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
      "jade-1.8.1" = self.by-version."jade"."1.8.1";
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
    self.by-version."gulp"."3.8.10";
  by-version."gulp"."3.8.10" = lib.makeOverridable self.buildNodePackage {
    name = "gulp-3.8.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gulp/-/gulp-3.8.10.tgz";
        name = "gulp-3.8.10.tgz";
        sha1 = "bfb8fc156be97820f02a7f8b3af61a86666f9e31";
      })
    ];
    buildInputs =
      (self.nativeDeps."gulp" or []);
    deps = {
      "archy-1.0.0" = self.by-version."archy"."1.0.0";
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "deprecated-0.0.1" = self.by-version."deprecated"."0.0.1";
      "gulp-util-3.0.1" = self.by-version."gulp-util"."3.0.1";
      "interpret-0.3.8" = self.by-version."interpret"."0.3.8";
      "liftoff-0.13.6" = self.by-version."liftoff"."0.13.6";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "orchestrator-0.3.7" = self.by-version."orchestrator"."0.3.7";
      "pretty-hrtime-0.2.2" = self.by-version."pretty-hrtime"."0.2.2";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "tildify-1.0.0" = self.by-version."tildify"."1.0.0";
      "v8flags-1.0.5" = self.by-version."v8flags"."1.0.5";
      "vinyl-fs-0.3.13" = self.by-version."vinyl-fs"."0.3.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gulp" ];
  };
  "gulp" = self.by-version."gulp"."3.8.10";
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
      "dateformat-1.0.11" = self.by-version."dateformat"."1.0.11";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "lodash._reinterpolate-2.4.1" = self.by-version."lodash._reinterpolate"."2.4.1";
      "lodash.template-2.4.1" = self.by-version."lodash.template"."2.4.1";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "multipipe-0.1.2" = self.by-version."multipipe"."0.1.2";
      "through2-0.6.3" = self.by-version."through2"."0.6.3";
      "vinyl-0.4.5" = self.by-version."vinyl"."0.4.5";
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
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
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
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
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
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
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
      "send-0.10.1" = self.by-version."send"."0.10.1";
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
  by-spec."hash.js"."^0.2.0" =
    self.by-version."hash.js"."0.2.1";
  by-version."hash.js"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "hash.js-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hash.js/-/hash.js-0.2.1.tgz";
        name = "hash.js-0.2.1.tgz";
        sha1 = "30a06810932478e53c0c4509fe7f1db62e38c6ff";
      })
    ];
    buildInputs =
      (self.nativeDeps."hash.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hash.js" ];
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
  by-spec."hat"."0.0.3" =
    self.by-version."hat"."0.0.3";
  by-spec."hat"."^0.0.3" =
    self.by-version."hat"."0.0.3";
  by-spec."hat"."~0.0.3" =
    self.by-version."hat"."0.0.3";
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
  by-spec."hawk"."~0.13.0" =
    self.by-version."hawk"."0.13.1";
  by-version."hawk"."0.13.1" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.13.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.13.1.tgz";
        name = "hawk-0.13.1.tgz";
        sha1 = "3617958821f58311e4d7f6de291fca662b412ef4";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-0.8.5" = self.by-version."hoek"."0.8.5";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
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
  by-spec."hoek"."0.8.x" =
    self.by-version."hoek"."0.8.5";
  by-version."hoek"."0.8.5" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.8.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.8.5.tgz";
        name = "hoek-0.8.5.tgz";
        sha1 = "1e9fd770ef7ebe0274adfcb5b0806a025a5e4e9f";
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
  by-spec."htmlparser2"."3.8.x" =
    self.by-version."htmlparser2"."3.8.2";
  by-version."htmlparser2"."3.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-3.8.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.8.2.tgz";
        name = "htmlparser2-3.8.2.tgz";
        sha1 = "0d6bc3471d01e9766fc2c274cbac1d55b36c009c";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = {
      "domhandler-2.3.0" = self.by-version."domhandler"."2.3.0";
      "domutils-1.5.0" = self.by-version."domutils"."1.5.0";
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
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
  by-spec."http-browserify"."~1.1.0" =
    self.by-version."http-browserify"."1.1.0";
  by-version."http-browserify"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "http-browserify-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-browserify/-/http-browserify-1.1.0.tgz";
        name = "http-browserify-1.1.0.tgz";
        sha1 = "20d0f6fdab370d1fe778d44a7bc48ddb7260206d";
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
  by-spec."http-browserify"."~1.3.1" =
    self.by-version."http-browserify"."1.3.2";
  by-version."http-browserify"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "http-browserify-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-browserify/-/http-browserify-1.3.2.tgz";
        name = "http-browserify-1.3.2.tgz";
        sha1 = "b562c34479349a690d7a6597df495aefa8c604f5";
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
  by-spec."http-errors"."~1.2.7" =
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
      "eventemitter3-0.1.6" = self.by-version."eventemitter3"."0.1.6";
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
  by-spec."http-signature"."~0.9.11" =
    self.by-version."http-signature"."0.9.11";
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
  by-spec."ibrik"."~2.0.0" =
    self.by-version."ibrik"."2.0.0";
  by-version."ibrik"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "ibrik-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ibrik/-/ibrik-2.0.0.tgz";
        name = "ibrik-2.0.0.tgz";
        sha1 = "89a2434f2a5c82b92166c3d97de3b5636eea2e9c";
      })
    ];
    buildInputs =
      (self.nativeDeps."ibrik" or []);
    deps = {
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "coffee-script-1.8.0" = self.by-version."coffee-script"."1.8.0";
      "istanbul-0.3.2" = self.by-version."istanbul"."0.3.2";
      "estraverse-1.8.0" = self.by-version."estraverse"."1.8.0";
      "which-1.0.7" = self.by-version."which"."1.0.7";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "esprima-1.2.2" = self.by-version."esprima"."1.2.2";
      "fileset-0.1.5" = self.by-version."fileset"."0.1.5";
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
  by-spec."iconv-lite"."0.4.5" =
    self.by-version."iconv-lite"."0.4.5";
  by-version."iconv-lite"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.4.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.5.tgz";
        name = "iconv-lite-0.4.5.tgz";
        sha1 = "9c574b70c30d615859f2064d2be4335ad6b1a8d6";
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
    self.by-version."iconv-lite"."0.4.5";
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
  by-spec."ieee754"."~1.1.1" =
    self.by-version."ieee754"."1.1.4";
  by-spec."indent-string"."^1.1.0" =
    self.by-version."indent-string"."1.2.0";
  by-version."indent-string"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "indent-string-1.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/indent-string/-/indent-string-1.2.0.tgz";
        name = "indent-string-1.2.0.tgz";
        sha1 = "4d747797d66745bd54c6a289f5ce19f51750a4b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."indent-string" or []);
    deps = {
      "get-stdin-3.0.2" = self.by-version."get-stdin"."3.0.2";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "repeating-1.1.0" = self.by-version."repeating"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "indent-string" ];
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
  by-spec."inflight"."^1.0.4" =
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
  by-spec."inflight"."~1.0.4" =
    self.by-version."inflight"."1.0.4";
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
    self.by-version."ini"."1.3.2";
  by-version."ini"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.3.2.tgz";
        name = "ini-1.3.2.tgz";
        sha1 = "9ebf4a44daf9d89acd07aab9f89a083d887f6dec";
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
    self.by-version."ini"."1.3.2";
  by-spec."ini"."^1.2.0" =
    self.by-version."ini"."1.3.2";
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
  by-spec."ini"."~1.3.2" =
    self.by-version."ini"."1.3.2";
  by-spec."init-package-json"."0.0.10" =
    self.by-version."init-package-json"."0.0.10";
  by-version."init-package-json"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-0.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-0.0.10.tgz";
        name = "init-package-json-0.0.10.tgz";
        sha1 = "7baf10535227e0878105a04e44b78f132475da6a";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json" or []);
    deps = {
      "promzard-0.2.2" = self.by-version."promzard"."0.2.2";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  by-spec."init-package-json"."0.0.14" =
    self.by-version."init-package-json"."0.0.14";
  by-version."init-package-json"."0.0.14" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-0.0.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-0.0.14.tgz";
        name = "init-package-json-0.0.14.tgz";
        sha1 = "bd5f7b2d73b54957388cca3ce61190340c8a05b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json" or []);
    deps = {
      "promzard-0.2.2" = self.by-version."promzard"."0.2.2";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  by-spec."init-package-json"."~1.1.2" =
    self.by-version."init-package-json"."1.1.2";
  by-version."init-package-json"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-1.1.2.tgz";
        name = "init-package-json-1.1.2.tgz";
        sha1 = "bc6c02d1da87253141600972f0d6bdcdd016990e";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json" or []);
    deps = {
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
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
      "figures-1.3.5" = self.by-version."figures"."1.3.5";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
      "readline2-0.1.0" = self.by-version."readline2"."0.1.0";
      "rx-2.3.18" = self.by-version."rx"."2.3.18";
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
      "rx-2.3.18" = self.by-version."rx"."2.3.18";
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
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "lexical-scope-1.1.0" = self.by-version."lexical-scope"."1.1.0";
      "process-0.6.0" = self.by-version."process"."0.6.0";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insert-module-globals" ];
  };
  by-spec."insert-module-globals"."~2.3.0" =
    self.by-version."insert-module-globals"."2.3.4";
  by-version."insert-module-globals"."2.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "insert-module-globals-2.3.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insert-module-globals/-/insert-module-globals-2.3.4.tgz";
        name = "insert-module-globals-2.3.4.tgz";
        sha1 = "e920cd470bcf1f47713eac6cc5cc13437e1a9e7e";
      })
    ];
    buildInputs =
      (self.nativeDeps."insert-module-globals" or []);
    deps = {
      "commondir-0.0.1" = self.by-version."commondir"."0.0.1";
      "lexical-scope-0.0.15" = self.by-version."lexical-scope"."0.0.15";
      "process-0.5.2" = self.by-version."process"."0.5.2";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "native-buffer-browserify-2.0.17" = self.by-version."native-buffer-browserify"."2.0.17";
      "browserify-3.24.13" = self.by-version."browserify"."3.24.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insert-module-globals" ];
  };
  by-spec."insert-module-globals"."~3.1.2" =
    self.by-version."insert-module-globals"."3.1.3";
  by-version."insert-module-globals"."3.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "insert-module-globals-3.1.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insert-module-globals/-/insert-module-globals-3.1.3.tgz";
        name = "insert-module-globals-3.1.3.tgz";
        sha1 = "d5b80e3a9c86d2bf9a522baee3c14f00d931038a";
      })
    ];
    buildInputs =
      (self.nativeDeps."insert-module-globals" or []);
    deps = {
      "lexical-scope-0.1.0" = self.by-version."lexical-scope"."0.1.0";
      "process-0.5.2" = self.by-version."process"."0.5.2";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insert-module-globals" ];
  };
  by-spec."insert-module-globals"."~5.0.1" =
    self.by-version."insert-module-globals"."5.0.1";
  by-version."insert-module-globals"."5.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "insert-module-globals-5.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insert-module-globals/-/insert-module-globals-5.0.1.tgz";
        name = "insert-module-globals-5.0.1.tgz";
        sha1 = "eec9c0dfad30380e8eda313a094165dc2f2350d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."insert-module-globals" or []);
    deps = {
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "lexical-scope-1.1.0" = self.by-version."lexical-scope"."1.1.0";
      "process-0.6.0" = self.by-version."process"."0.6.0";
      "through-2.3.6" = self.by-version."through"."2.3.6";
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
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insight" ];
  };
  by-spec."interpret"."^0.3.2" =
    self.by-version."interpret"."0.3.8";
  by-version."interpret"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "interpret-0.3.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/interpret/-/interpret-0.3.8.tgz";
        name = "interpret-0.3.8.tgz";
        sha1 = "23c65e60ed18a3e21cddccf96e8a6658548cda8b";
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
  by-spec."ip"."^0.3.0" =
    self.by-version."ip"."0.3.2";
  by-version."ip"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "ip-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ip/-/ip-0.3.2.tgz";
        name = "ip-0.3.2.tgz";
        sha1 = "7d5ed34326688b36b6ab81f1865ea8266c28f0db";
      })
    ];
    buildInputs =
      (self.nativeDeps."ip" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ip" ];
  };
  by-spec."ip-regex"."^1.0.0" =
    self.by-version."ip-regex"."1.0.1";
  by-version."ip-regex"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "ip-regex-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ip-regex/-/ip-regex-1.0.1.tgz";
        name = "ip-regex-1.0.1.tgz";
        sha1 = "3f1da464e47290591023a70617e45361b41123f7";
      })
    ];
    buildInputs =
      (self.nativeDeps."ip-regex" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ip-regex" ];
  };
  by-spec."ip-set"."^1.0.0" =
    self.by-version."ip-set"."1.0.0";
  by-version."ip-set"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "ip-set-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ip-set/-/ip-set-1.0.0.tgz";
        name = "ip-set-1.0.0.tgz";
        sha1 = "54782fb5ae37ab6e697a2b49e07748d9e069dda6";
      })
    ];
    buildInputs =
      (self.nativeDeps."ip-set" or []);
    deps = {
      "ip-0.3.2" = self.by-version."ip"."0.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ip-set" ];
  };
  by-spec."ipaddr.js"."0.1.5" =
    self.by-version."ipaddr.js"."0.1.5";
  by-version."ipaddr.js"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "ipaddr.js-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.5.tgz";
        name = "ipaddr.js-0.1.5.tgz";
        sha1 = "33d2693c95fbd4715165328dbfe25fb4fb5bbed8";
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
  by-spec."ipaddr.js"."^0.1.5" =
    self.by-version."ipaddr.js"."0.1.6";
  by-version."ipaddr.js"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "ipaddr.js-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.6.tgz";
        name = "ipaddr.js-0.1.6.tgz";
        sha1 = "8f0530b217993873025fd4b72bdfd69bc56a9a12";
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
      "winston-0.8.3" = self.by-version."winston"."0.8.3";
      "nconf-0.7.1" = self.by-version."nconf"."0.7.1";
      "fs-walk-0.0.1" = self.by-version."fs-walk"."0.0.1";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "express-5.0.0-alpha.1" = self.by-version."express"."5.0.0-alpha.1";
      "jade-1.8.1" = self.by-version."jade"."1.8.1";
      "passport-0.2.1" = self.by-version."passport"."0.2.1";
      "passport-http-0.2.2" = self.by-version."passport-http"."0.2.2";
      "js-yaml-3.2.3" = self.by-version."js-yaml"."3.2.3";
      "mongoose-3.8.19" = self.by-version."mongoose"."3.8.19";
      "gridfs-stream-0.5.3" = self.by-version."gridfs-stream"."0.5.3";
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
  by-spec."is-finite"."^1.0.0" =
    self.by-version."is-finite"."1.0.0";
  by-version."is-finite"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-finite-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-finite/-/is-finite-1.0.0.tgz";
        name = "is-finite-1.0.0.tgz";
        sha1 = "2b1dbad1162cdca6a4dc89f12b2f3dae12393282";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-finite" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-finite" ];
  };
  by-spec."is-ip"."^1.0.0" =
    self.by-version."is-ip"."1.0.0";
  by-version."is-ip"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-ip-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-ip/-/is-ip-1.0.0.tgz";
        name = "is-ip-1.0.0.tgz";
        sha1 = "2bb6959f797ccd6f9fdc812758bcbc87c4c59074";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-ip" or []);
    deps = {
      "ip-regex-1.0.1" = self.by-version."ip-regex"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-ip" ];
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
  by-spec."isstream"."0.1.x" =
    self.by-version."isstream"."0.1.0";
  by-version."isstream"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "isstream-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isstream/-/isstream-0.1.0.tgz";
        name = "isstream-0.1.0.tgz";
        sha1 = "1fc062509b8c8902ee78d0a8d015ad3251472285";
      })
    ];
    buildInputs =
      (self.nativeDeps."isstream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "isstream" ];
  };
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
      "which-1.0.7" = self.by-version."which"."1.0.7";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "js-yaml-3.2.3" = self.by-version."js-yaml"."3.2.3";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  "istanbul" = self.by-version."istanbul"."0.3.2";
  by-spec."istanbul"."~0.3.0" =
    self.by-version."istanbul"."0.3.2";
  by-spec."istanbul"."~0.3.2" =
    self.by-version."istanbul"."0.3.2";
  by-spec."jade"."*" =
    self.by-version."jade"."1.8.1";
  by-version."jade"."1.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "jade-1.8.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-1.8.1.tgz";
        name = "jade-1.8.1.tgz";
        sha1 = "7f28dfd42832fda613e4a28fd0febb3f423c464f";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "character-parser-1.2.1" = self.by-version."character-parser"."1.2.1";
      "commander-2.5.0" = self.by-version."commander"."2.5.0";
      "constantinople-3.0.1" = self.by-version."constantinople"."3.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "monocle-1.1.51" = self.by-version."monocle"."1.1.51";
      "transformers-2.1.0" = self.by-version."transformers"."2.1.0";
      "void-elements-1.0.0" = self.by-version."void-elements"."1.0.0";
      "with-4.0.0" = self.by-version."with"."4.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  "jade" = self.by-version."jade"."1.8.1";
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
    self.by-version."jade"."1.8.1";
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
  by-spec."jfs"."*" =
    self.by-version."jfs"."0.2.3";
  by-version."jfs"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "jfs-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jfs/-/jfs-0.2.3.tgz";
        name = "jfs-0.2.3.tgz";
        sha1 = "1b87551f83055e69b509fe8c3066d0c702b01574";
      })
    ];
    buildInputs =
      (self.nativeDeps."jfs" or []);
    deps = {
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "clone-0.1.18" = self.by-version."clone"."0.1.18";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jfs" ];
  };
  "jfs" = self.by-version."jfs"."0.2.3";
  by-spec."js-yaml"."*" =
    self.by-version."js-yaml"."3.2.3";
  by-version."js-yaml"."3.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.2.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.2.3.tgz";
        name = "js-yaml-3.2.3.tgz";
        sha1 = "a3af632d13df5bfa95f3b8f3c4b61efe212cd750";
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
  "js-yaml" = self.by-version."js-yaml"."3.2.3";
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
    self.by-version."js-yaml"."3.2.3";
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
    self.by-version."jshint"."2.5.10";
  by-version."jshint"."2.5.10" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.5.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.5.10.tgz";
        name = "jshint-2.5.10.tgz";
        sha1 = "2fef47ee0901914e31832123d5d3f434c28060ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."jshint" or []);
    deps = {
      "cli-0.6.5" = self.by-version."cli"."0.6.5";
      "console-browserify-1.1.0" = self.by-version."console-browserify"."1.1.0";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "htmlparser2-3.8.2" = self.by-version."htmlparser2"."3.8.2";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "shelljs-0.3.0" = self.by-version."shelljs"."0.3.0";
      "strip-json-comments-1.0.2" = self.by-version."strip-json-comments"."1.0.2";
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  "jshint" = self.by-version."jshint"."2.5.10";
  by-spec."jshint"."~2.5.0" =
    self.by-version."jshint"."2.5.10";
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
  by-spec."json-stringify-safe"."~4.0.0" =
    self.by-version."json-stringify-safe"."4.0.0";
  by-version."json-stringify-safe"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-4.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-4.0.0.tgz";
        name = "json-stringify-safe-4.0.0.tgz";
        sha1 = "77c271aaea54302e68efeaccb56abbf06a9b1a54";
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
  by-spec."jstransform"."^7.0.0" =
    self.by-version."jstransform"."7.0.0";
  by-version."jstransform"."7.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "jstransform-7.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jstransform/-/jstransform-7.0.0.tgz";
        name = "jstransform-7.0.0.tgz";
        sha1 = "4f5b7fd0dce2d2ba8b7d0a3190b278ee8bf68a6c";
      })
    ];
    buildInputs =
      (self.nativeDeps."jstransform" or []);
    deps = {
      "base62-0.1.1" = self.by-version."base62"."0.1.1";
      "esprima-fb-7001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."7001.1.0-dev-harmony-fb";
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
  by-spec."k-bucket"."^0.4.2" =
    self.by-version."k-bucket"."0.4.2";
  by-version."k-bucket"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "k-bucket-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/k-bucket/-/k-bucket-0.4.2.tgz";
        name = "k-bucket-0.4.2.tgz";
        sha1 = "150ab92307e9ec818a9c4e39a5f930eb3aaaa23a";
      })
    ];
    buildInputs =
      (self.nativeDeps."k-bucket" or []);
    deps = {
      "buffer-equal-0.0.1" = self.by-version."buffer-equal"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "k-bucket" ];
  };
  by-spec."karma"."*" =
    self.by-version."karma"."0.12.28";
  by-version."karma"."0.12.28" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.12.28";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.12.28.tgz";
        name = "karma-0.12.28.tgz";
        sha1 = "80111f75ae99c9a0b0974ad0c98e6271bc2318fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma" or []);
    deps = {
      "di-0.0.1" = self.by-version."di"."0.0.1";
      "socket.io-0.9.17" = self.by-version."socket.io"."0.9.17";
      "chokidar-0.11.1" = self.by-version."chokidar"."0.11.1";
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
      "connect-2.26.6" = self.by-version."connect"."2.26.6";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "karma" ];
  };
  "karma" = self.by-version."karma"."0.12.28";
  by-spec."karma".">=0.11.11" =
    self.by-version."karma"."0.12.28";
  by-spec."karma".">=0.12.8" =
    self.by-version."karma"."0.12.28";
  by-spec."karma".">=0.9" =
    self.by-version."karma"."0.12.28";
  by-spec."karma".">=0.9.3" =
    self.by-version."karma"."0.12.28";
  by-spec."karma"."~0.12.0" =
    self.by-version."karma"."0.12.28";
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
      self.by-version."karma"."0.12.28"
    ];
    passthru.names = [ "karma-chrome-launcher" ];
  };
  "karma-chrome-launcher" = self.by-version."karma-chrome-launcher"."0.1.5";
  by-spec."karma-coverage"."*" =
    self.by-version."karma-coverage"."0.2.7";
  by-version."karma-coverage"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "karma-coverage-0.2.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coverage/-/karma-coverage-0.2.7.tgz";
        name = "karma-coverage-0.2.7.tgz";
        sha1 = "f76740b275bbf30a0ab9f41d8cf56843a0994576";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-coverage" or []);
    deps = {
      "istanbul-0.3.2" = self.by-version."istanbul"."0.3.2";
      "ibrik-2.0.0" = self.by-version."ibrik"."2.0.0";
      "dateformat-1.0.11" = self.by-version."dateformat"."1.0.11";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    peerDependencies = [
      self.by-version."karma"."0.12.28"
    ];
    passthru.names = [ "karma-coverage" ];
  };
  "karma-coverage" = self.by-version."karma-coverage"."0.2.7";
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
      self.by-version."karma"."0.12.28"
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
      self.by-version."karma"."0.12.28"
      self.by-version."mocha"."2.0.1"
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
      self.by-version."karma"."0.12.28"
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
      "wd-0.3.11" = self.by-version."wd"."0.3.11";
      "sauce-connect-launcher-0.6.1" = self.by-version."sauce-connect-launcher"."0.6.1";
      "q-0.9.7" = self.by-version."q"."0.9.7";
      "saucelabs-0.1.1" = self.by-version."saucelabs"."0.1.1";
    };
    peerDependencies = [
      self.by-version."karma"."0.12.28"
    ];
    passthru.names = [ "karma-sauce-launcher" ];
  };
  "karma-sauce-launcher" = self.by-version."karma-sauce-launcher"."0.2.10";
  by-spec."keen.io"."~0.1.3" =
    self.by-version."keen.io"."0.1.3";
  by-version."keen.io"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "keen.io-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keen.io/-/keen.io-0.1.3.tgz";
        name = "keen.io-0.1.3.tgz";
        sha1 = "5056f5c989ab14ccf62fc20ed7598115ae7d09e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."keen.io" or []);
    deps = {
      "superagent-0.21.0" = self.by-version."superagent"."0.21.0";
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
  by-spec."kerberos"."0.0.4" =
    self.by-version."kerberos"."0.0.4";
  by-version."kerberos"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "kerberos-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kerberos/-/kerberos-0.0.4.tgz";
        name = "kerberos-0.0.4.tgz";
        sha1 = "11836638f729a2f6c5bae056a7d7a15898c9ba7c";
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
  by-spec."keypress"."^0.2.1" =
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
  by-spec."keypress"."~0.2.1" =
    self.by-version."keypress"."0.2.1";
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
    self.by-version."labeled-stream-splicer"."1.0.2";
  by-version."labeled-stream-splicer"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "labeled-stream-splicer-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/labeled-stream-splicer/-/labeled-stream-splicer-1.0.2.tgz";
        name = "labeled-stream-splicer-1.0.2.tgz";
        sha1 = "4615331537784981e8fd264e1f3a434c4e0ddd65";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
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
      "vinyl-fs-0.3.13" = self.by-version."vinyl-fs"."0.3.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lcov-result-merger" ];
  };
  "lcov-result-merger" = self.by-version."lcov-result-merger"."1.0.0";
  by-spec."less"."*" =
    self.by-version."less"."2.1.1";
  by-version."less"."2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "less-2.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-2.1.1.tgz";
        name = "less-2.1.1.tgz";
        sha1 = "7ba1fd7698e7b4eb46286c3954aed43e54da41b6";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
      "promise-6.0.1" = self.by-version."promise"."6.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  "less" = self.by-version."less"."2.1.1";
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "request-2.40.0" = self.by-version."request"."2.40.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "clean-css-2.2.19" = self.by-version."clean-css"."2.2.19";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  by-spec."lexical-scope"."~0.0.14" =
    self.by-version."lexical-scope"."0.0.15";
  by-version."lexical-scope"."0.0.15" = lib.makeOverridable self.buildNodePackage {
    name = "lexical-scope-0.0.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lexical-scope/-/lexical-scope-0.0.15.tgz";
        name = "lexical-scope-0.0.15.tgz";
        sha1 = "ca595997aaed87b155cb041f48dc0438f48a04dc";
      })
    ];
    buildInputs =
      (self.nativeDeps."lexical-scope" or []);
    deps = {
      "astw-0.0.0" = self.by-version."astw"."0.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lexical-scope" ];
  };
  by-spec."lexical-scope"."~0.1.0" =
    self.by-version."lexical-scope"."0.1.0";
  by-version."lexical-scope"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "lexical-scope-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lexical-scope/-/lexical-scope-0.1.0.tgz";
        name = "lexical-scope-0.1.0.tgz";
        sha1 = "8f30004c80234ffac083b990079d7b267e18441b";
      })
    ];
    buildInputs =
      (self.nativeDeps."lexical-scope" or []);
    deps = {
      "astw-0.1.0" = self.by-version."astw"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "lexical-scope" ];
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
    self.by-version."liftoff"."0.13.6";
  by-version."liftoff"."0.13.6" = lib.makeOverridable self.buildNodePackage {
    name = "liftoff-0.13.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/liftoff/-/liftoff-0.13.6.tgz";
        name = "liftoff-0.13.6.tgz";
        sha1 = "600e8966b92d1e0150eab5b577652569f4c7d1d8";
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
  by-spec."lockfile"."~0.4.0" =
    self.by-version."lockfile"."0.4.3";
  by-version."lockfile"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "lockfile-0.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lockfile/-/lockfile-0.4.3.tgz";
        name = "lockfile-0.4.3.tgz";
        sha1 = "79b965ee9b32d9dd24b59cf81205e6dcb6d3b224";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "semver-1.1.4" = self.by-version."semver"."1.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "log4js" ];
  };
  by-spec."lolex"."1.1.0" =
    self.by-version."lolex"."1.1.0";
  by-version."lolex"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "lolex-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lolex/-/lolex-1.1.0.tgz";
        name = "lolex-1.1.0.tgz";
        sha1 = "5dbbbc850395e7523c74b3586f7fbd2626d25b1b";
      })
    ];
    buildInputs =
      (self.nativeDeps."lolex" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lolex" ];
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
  by-spec."ltx"."*" =
    self.by-version."ltx"."0.7.2";
  by-version."ltx"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "ltx-0.7.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ltx/-/ltx-0.7.2.tgz";
        name = "ltx-0.7.2.tgz";
        sha1 = "70a6aa8fa5fd426a422a41ba3d54a15ccdde680c";
      })
    ];
    buildInputs =
      (self.nativeDeps."ltx" or []);
    deps = {
      "sax-0.6.1" = self.by-version."sax"."0.6.1";
      "node-expat-2.3.3" = self.by-version."node-expat"."2.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ltx" ];
  };
  "ltx" = self.by-version."ltx"."0.7.2";
  by-spec."ltx"."0.x" =
    self.by-version."ltx"."0.7.2";
  by-spec."ltx".">= 0.2.0" =
    self.by-version."ltx"."0.7.2";
  by-spec."ltx"."^0.5.2" =
    self.by-version."ltx"."0.5.2";
  by-version."ltx"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "ltx-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ltx/-/ltx-0.5.2.tgz";
        name = "ltx-0.5.2.tgz";
        sha1 = "3a049fc30ab8982c227803a74b26c02fe225cef8";
      })
    ];
    buildInputs =
      (self.nativeDeps."ltx" or []);
    deps = {
      "sax-0.6.1" = self.by-version."sax"."0.6.1";
      "node-expat-2.3.3" = self.by-version."node-expat"."2.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ltx" ];
  };
  by-spec."ltx"."^0.7.2" =
    self.by-version."ltx"."0.7.2";
  by-spec."ltx"."~0.3.2" =
    self.by-version."ltx"."0.3.4";
  by-version."ltx"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "ltx-0.3.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ltx/-/ltx-0.3.4.tgz";
        name = "ltx-0.3.4.tgz";
        sha1 = "3cc8d3af3cf08914383b19e8ab60b1f396e1e984";
      })
    ];
    buildInputs =
      (self.nativeDeps."ltx" or []);
    deps = {
      "sax-0.6.1" = self.by-version."sax"."0.6.1";
      "node-expat-2.1.4" = self.by-version."node-expat"."2.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ltx" ];
  };
  by-spec."ltx"."~0.3.3" =
    self.by-version."ltx"."0.3.4";
  by-spec."ltx"."~0.6.0" =
    self.by-version."ltx"."0.6.0";
  by-version."ltx"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "ltx-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ltx/-/ltx-0.6.0.tgz";
        name = "ltx-0.6.0.tgz";
        sha1 = "16470236570a2c436744a3c4adb8a4b15ea1acc7";
      })
    ];
    buildInputs =
      (self.nativeDeps."ltx" or []);
    deps = {
      "sax-0.6.1" = self.by-version."sax"."0.6.1";
      "node-expat-2.3.3" = self.by-version."node-expat"."2.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ltx" ];
  };
  by-spec."ltx"."~0.x" =
    self.by-version."ltx"."0.7.2";
  by-spec."m8".">= 0.4.3" =
    self.by-version."m8"."0.4.4";
  by-version."m8"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "m8-0.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/m8/-/m8-0.4.4.tgz";
        name = "m8-0.4.4.tgz";
        sha1 = "59df914d9bee2829ceac4346026abe945abed5b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."m8" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "m8" ];
  };
  by-spec."magnet-uri"."^2.0.1" =
    self.by-version."magnet-uri"."2.0.1";
  by-version."magnet-uri"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "magnet-uri-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/magnet-uri/-/magnet-uri-2.0.1.tgz";
        name = "magnet-uri-2.0.1.tgz";
        sha1 = "d331d3dfcd3836565ade0fc3ca315e39217bb209";
      })
    ];
    buildInputs =
      (self.nativeDeps."magnet-uri" or []);
    deps = {
      "thirty-two-0.0.2" = self.by-version."thirty-two"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "magnet-uri" ];
  };
  by-spec."magnet-uri"."~2.0.0" =
    self.by-version."magnet-uri"."2.0.1";
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
      "mimelib-0.2.18" = self.by-version."mimelib"."0.2.18";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "he-0.3.6" = self.by-version."he"."0.3.6";
      "follow-redirects-0.0.3" = self.by-version."follow-redirects"."0.0.3";
      "dkim-signer-0.1.2" = self.by-version."dkim-signer"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mailcomposer" ];
  };
  by-spec."map-obj"."^1.0.0" =
    self.by-version."map-obj"."1.0.0";
  by-version."map-obj"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "map-obj-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/map-obj/-/map-obj-1.0.0.tgz";
        name = "map-obj-1.0.0.tgz";
        sha1 = "bcbdf6756758763c182daf79e18094a2f1c85766";
      })
    ];
    buildInputs =
      (self.nativeDeps."map-obj" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "map-obj" ];
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
      "figures-1.3.5" = self.by-version."figures"."1.3.5";
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
      "figures-1.3.5" = self.by-version."figures"."1.3.5";
      "gzip-size-0.2.0" = self.by-version."gzip-size"."0.2.0";
      "pretty-bytes-0.1.2" = self.by-version."pretty-bytes"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "maxmin" ];
  };
  by-spec."mdns-js"."git+https://github.com/guerrerocarlos/node-mdns-js" =
    self.by-version."mdns-js"."0.2.2";
  by-version."mdns-js"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "mdns-js-0.2.2";
    bin = false;
    src = [
      (fetchgit {
        url = "https://github.com/guerrerocarlos/node-mdns-js";
        rev = "25b81ef88fa2f9ad8ebc875ac3e1d3f36a87ed61";
        sha256 = "1f6fee2a00345e9c82e0d49818f7137cf3288072bddfdc6225b738184804e103";
      })
    ];
    buildInputs =
      (self.nativeDeps."mdns-js" or []);
    deps = {
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
      "mdns-js-packet-0.1.3" = self.by-version."mdns-js-packet"."0.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mdns-js" ];
  };
  by-spec."mdns-js-packet"."0.1.x" =
    self.by-version."mdns-js-packet"."0.1.3";
  by-version."mdns-js-packet"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "mdns-js-packet-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mdns-js-packet/-/mdns-js-packet-0.1.3.tgz";
        name = "mdns-js-packet-0.1.3.tgz";
        sha1 = "a98ad52e1e74e96b00aab239af4354687a16db01";
      })
    ];
    buildInputs =
      (self.nativeDeps."mdns-js-packet" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "qap-3.1.2" = self.by-version."qap"."3.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mdns-js-packet" ];
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
  by-spec."meow"."*" =
    self.by-version."meow"."2.0.0";
  by-version."meow"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "meow-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/meow/-/meow-2.0.0.tgz";
        name = "meow-2.0.0.tgz";
        sha1 = "8f530a8ecf5d40d3f4b4df93c3472900fba2a8f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."meow" or []);
    deps = {
      "camelcase-keys-1.0.0" = self.by-version."camelcase-keys"."1.0.0";
      "indent-string-1.2.0" = self.by-version."indent-string"."1.2.0";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "object-assign-1.0.0" = self.by-version."object-assign"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "meow" ];
  };
  by-spec."meow"."^1.0.0" =
    self.by-version."meow"."1.0.0";
  by-version."meow"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "meow-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/meow/-/meow-1.0.0.tgz";
        name = "meow-1.0.0.tgz";
        sha1 = "d0ac10fe5b7a53796e7101e7068ff02ab698178b";
      })
    ];
    buildInputs =
      (self.nativeDeps."meow" or []);
    deps = {
      "camelcase-keys-1.0.0" = self.by-version."camelcase-keys"."1.0.0";
      "indent-string-1.2.0" = self.by-version."indent-string"."1.2.0";
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
      "object-assign-1.0.0" = self.by-version."object-assign"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "meow" ];
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
  by-spec."method-override"."1.0.0" =
    self.by-version."method-override"."1.0.0";
  by-version."method-override"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "method-override-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/method-override/-/method-override-1.0.0.tgz";
        name = "method-override-1.0.0.tgz";
        sha1 = "9e5bfbd80f3b9e043801dd3fe60bbab0f15b5f61";
      })
    ];
    buildInputs =
      (self.nativeDeps."method-override" or []);
    deps = {
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "method-override" ];
  };
  by-spec."method-override"."~2.2.0" =
    self.by-version."method-override"."2.2.0";
  by-version."method-override"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "method-override-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/method-override/-/method-override-2.2.0.tgz";
        name = "method-override-2.2.0.tgz";
        sha1 = "177e852b6add3b4f9177033a9446b01e7801a0c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."method-override" or []);
    deps = {
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "method-override" ];
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
  by-spec."methods"."*" =
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
  by-spec."methods"."1.x" =
    self.by-version."methods"."1.1.0";
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
  by-spec."miller-rabin"."^1.1.1" =
    self.by-version."miller-rabin"."1.1.1";
  by-version."miller-rabin"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "miller-rabin-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/miller-rabin/-/miller-rabin-1.1.1.tgz";
        name = "miller-rabin-1.1.1.tgz";
        sha1 = "00e5be11698e846d7a5a185c5eced425f4379cd5";
      })
    ];
    buildInputs =
      (self.nativeDeps."miller-rabin" or []);
    deps = {
      "brorand-1.0.5" = self.by-version."brorand"."1.0.5";
    };
    peerDependencies = [
      self.by-version."bn.js"."0.15.2"
    ];
    passthru.names = [ "miller-rabin" ];
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
  by-spec."mime"."^1.2.11" =
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
    self.by-version."mime-db"."1.2.0";
  by-version."mime-db"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "mime-db-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.2.0.tgz";
        name = "mime-db-1.2.0.tgz";
        sha1 = "76b92e7ecac673f5dab066a10b66faea1be2f01f";
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
  by-spec."mime-db"."~1.2.0" =
    self.by-version."mime-db"."1.2.0";
  by-spec."mime-types"."~1.0.1" =
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
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.3";
  by-version."mime-types"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "mime-types-2.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.3.tgz";
        name = "mime-types-2.0.3.tgz";
        sha1 = "70b5cb5165b55dcb4972839f16d6077b0bb506f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = {
      "mime-db-1.2.0" = self.by-version."mime-db"."1.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
  };
  by-spec."mimelib"."~0.2.15" =
    self.by-version."mimelib"."0.2.18";
  by-version."mimelib"."0.2.18" = lib.makeOverridable self.buildNodePackage {
    name = "mimelib-0.2.18";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mimelib/-/mimelib-0.2.18.tgz";
        name = "mimelib-0.2.18.tgz";
        sha1 = "2e631a3db449026fcb85099398b7bd750eac46a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mimelib" or []);
    deps = {
      "encoding-0.1.11" = self.by-version."encoding"."0.1.11";
      "addressparser-0.2.1" = self.by-version."addressparser"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mimelib" ];
  };
  by-spec."mine"."~0.0.1" =
    self.by-version."mine"."0.0.2";
  by-version."mine"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "mine-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mine/-/mine-0.0.2.tgz";
        name = "mine-0.0.2.tgz";
        sha1 = "77c2d327f8357352e69fc3e618f7476539fa0c40";
      })
    ];
    buildInputs =
      (self.nativeDeps."mine" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mine" ];
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
  by-spec."minimatch"."0" =
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
  by-spec."minimatch"."~0.2.11" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.12" =
    self.by-version."minimatch"."0.2.14";
  by-spec."minimatch"."~0.2.14" =
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
  by-spec."minimist"."~0.0.5" =
    self.by-version."minimist"."0.0.10";
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
  by-spec."mkdirp"."0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."0.0.x" =
    self.by-version."mkdirp"."0.0.7";
  by-version."mkdirp"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.0.7.tgz";
        name = "mkdirp-0.0.7.tgz";
        sha1 = "d89b4f0e4c3e5e5ca54235931675e094fe1a5072";
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
  by-spec."mkdirp"."0.4.0" =
    self.by-version."mkdirp"."0.4.0";
  by-version."mkdirp"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.4.0.tgz";
        name = "mkdirp-0.4.0.tgz";
        sha1 = "291ac2a2d43a19c478662577b5be846fe83b5923";
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
  by-spec."mkdirp"."^0.3.5" =
    self.by-version."mkdirp"."0.3.5";
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
    self.by-version."mocha"."2.0.1";
  by-version."mocha"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-2.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-2.0.1.tgz";
        name = "mocha-2.0.1.tgz";
        sha1 = "5a16e88b856d0c4145d8c6888c27ebd4fab13e90";
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
  "mocha" = self.by-version."mocha"."2.0.1";
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
      self.by-version."phantomjs"."1.9.12"
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
    self.by-version."module-deps"."3.5.10";
  by-version."module-deps"."3.5.10" = lib.makeOverridable self.buildNodePackage {
    name = "module-deps-3.5.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/module-deps/-/module-deps-3.5.10.tgz";
        name = "module-deps-3.5.10.tgz";
        sha1 = "2754737d4f9e52b60daa4abb242ade6c85ecde99";
      })
    ];
    buildInputs =
      (self.nativeDeps."module-deps" or []);
    deps = {
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "browser-resolve-1.4.1" = self.by-version."browser-resolve"."1.4.1";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "detective-4.0.0" = self.by-version."detective"."4.0.0";
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
  by-spec."module-deps"."~1.10.0" =
    self.by-version."module-deps"."1.10.0";
  by-version."module-deps"."1.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "module-deps-1.10.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/module-deps/-/module-deps-1.10.0.tgz";
        name = "module-deps-1.10.0.tgz";
        sha1 = "57a9cac9dbd092428ec5249f6cf37fb249d77db6";
      })
    ];
    buildInputs =
      (self.nativeDeps."module-deps" or []);
    deps = {
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "browser-resolve-1.2.4" = self.by-version."browser-resolve"."1.2.4";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "detective-3.1.0" = self.by-version."detective"."3.1.0";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "parents-0.0.2" = self.by-version."parents"."0.0.2";
      "resolve-0.6.3" = self.by-version."resolve"."0.6.3";
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "module-deps" ];
  };
  by-spec."module-deps"."~1.2.2" =
    self.by-version."module-deps"."1.2.2";
  by-version."module-deps"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "module-deps-1.2.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/module-deps/-/module-deps-1.2.2.tgz";
        name = "module-deps-1.2.2.tgz";
        sha1 = "6e73959b7973af964de33a02437b76a8edfb2fc5";
      })
    ];
    buildInputs =
      (self.nativeDeps."module-deps" or []);
    deps = {
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "browser-resolve-1.2.4" = self.by-version."browser-resolve"."1.2.4";
      "resolve-0.6.3" = self.by-version."resolve"."0.6.3";
      "detective-2.1.2" = self.by-version."detective"."2.1.2";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "parents-0.0.2" = self.by-version."parents"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "module-deps" ];
  };
  by-spec."module-deps"."~1.4.0" =
    self.by-version."module-deps"."1.4.2";
  by-version."module-deps"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "module-deps-1.4.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/module-deps/-/module-deps-1.4.2.tgz";
        name = "module-deps-1.4.2.tgz";
        sha1 = "cc48c5f88a087c6d9ec1973167c2c9fee2f80314";
      })
    ];
    buildInputs =
      (self.nativeDeps."module-deps" or []);
    deps = {
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "JSONStream-0.7.4" = self.by-version."JSONStream"."0.7.4";
      "browser-resolve-1.2.4" = self.by-version."browser-resolve"."1.2.4";
      "resolve-0.6.3" = self.by-version."resolve"."0.6.3";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "parents-0.0.2" = self.by-version."parents"."0.0.2";
      "mine-0.0.2" = self.by-version."mine"."0.0.2";
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
  by-spec."moment"."~2.8.4" =
    self.by-version."moment"."2.8.4";
  by-version."moment"."2.8.4" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.8.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.8.4.tgz";
        name = "moment-2.8.4.tgz";
        sha1 = "cc174aabb19223efff5699a9467805a2789838bf";
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
  by-spec."mongodb"."1.4.12" =
    self.by-version."mongodb"."1.4.12";
  by-version."mongodb"."1.4.12" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.4.12";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.4.12.tgz";
        name = "mongodb-1.4.12.tgz";
        sha1 = "65cdd46ec127861e941168fdccf82bf17ad71c4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = {
      "bson-0.2.15" = self.by-version."bson"."0.2.15";
      "kerberos-0.0.4" = self.by-version."kerberos"."0.0.4";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
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
    self.by-version."mongoose"."3.8.19";
  by-version."mongoose"."3.8.19" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.8.19";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.8.19.tgz";
        name = "mongoose-3.8.19.tgz";
        sha1 = "53b82129c895bbb1e91094cb34d4a03920b1dcb4";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose" or []);
    deps = {
      "mongodb-1.4.12" = self.by-version."mongodb"."1.4.12";
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
  by-spec."morgan"."1.0.0" =
    self.by-version."morgan"."1.0.0";
  by-version."morgan"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "morgan-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/morgan/-/morgan-1.0.0.tgz";
        name = "morgan-1.0.0.tgz";
        sha1 = "83cf74b9f2d841901f1a9a6b8fa7a468d2e47a8d";
      })
    ];
    buildInputs =
      (self.nativeDeps."morgan" or []);
    deps = {
      "bytes-0.2.1" = self.by-version."bytes"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "morgan" ];
  };
  by-spec."morgan"."~1.3.2" =
    self.by-version."morgan"."1.3.2";
  by-version."morgan"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "morgan-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/morgan/-/morgan-1.3.2.tgz";
        name = "morgan-1.3.2.tgz";
        sha1 = "ac41aa15221ee4e5f2ac843896b6918139a18efd";
      })
    ];
    buildInputs =
      (self.nativeDeps."morgan" or []);
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "depd-0.4.5" = self.by-version."depd"."0.4.5";
      "on-finished-2.1.0" = self.by-version."on-finished"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "morgan" ];
  };
  by-spec."morgan"."~1.4.1" =
    self.by-version."morgan"."1.4.1";
  by-version."morgan"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "morgan-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/morgan/-/morgan-1.4.1.tgz";
        name = "morgan-1.4.1.tgz";
        sha1 = "cd9600c3fa74e2fdf22ba0f1d026c20cb96f25fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."morgan" or []);
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-finished-2.1.1" = self.by-version."on-finished"."2.1.1";
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
    self.by-version."multipipe"."0.1.2";
  by-version."multipipe"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "multipipe-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/multipipe/-/multipipe-0.1.2.tgz";
        name = "multipipe-0.1.2.tgz";
        sha1 = "2a8f2ddf70eed564dff2d57f1e1a137d9f05078b";
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
    self.by-version."mz"."1.1.0";
  by-version."mz"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "mz-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mz/-/mz-1.1.0.tgz";
        name = "mz-1.1.0.tgz";
        sha1 = "fa63f08f20a1f6985cc1d9a33efa8db608cd6b9c";
      })
    ];
    buildInputs =
      (self.nativeDeps."mz" or []);
    deps = {
      "native-or-bluebird-1.1.2" = self.by-version."native-or-bluebird"."1.1.2";
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
    self.by-version."nan"."1.4.1";
  by-version."nan"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.4.1.tgz";
        name = "nan-1.4.1.tgz";
        sha1 = "0a2bb562c558b440005b1f7eb8b31ccbdb565d5f";
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
  by-spec."nan"."^1.3.0" =
    self.by-version."nan"."1.4.1";
  by-spec."nan"."~0.6.0" =
    self.by-version."nan"."0.6.0";
  by-version."nan"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "nan-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.6.0.tgz";
        name = "nan-0.6.0.tgz";
        sha1 = "a54ebe59717b467c77425302bd7c17574c887aaa";
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
  by-spec."nan"."~0.7.0" =
    self.by-version."nan"."0.7.1";
  by-version."nan"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "nan-0.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.7.1.tgz";
        name = "nan-0.7.1.tgz";
        sha1 = "fc576184a1037b3e5675f2ba3740dee2044ff8f4";
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
  by-spec."nan"."~1.3.0" =
    self.by-version."nan"."1.3.0";
  by-spec."nan"."~1.4.1" =
    self.by-version."nan"."1.4.1";
  by-spec."native-buffer-browserify"."~2.0.0" =
    self.by-version."native-buffer-browserify"."2.0.17";
  by-version."native-buffer-browserify"."2.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "native-buffer-browserify-2.0.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/native-buffer-browserify/-/native-buffer-browserify-2.0.17.tgz";
        name = "native-buffer-browserify-2.0.17.tgz";
        sha1 = "980577018c4884d169da40b47958ffac6c327d15";
      })
    ];
    buildInputs =
      (self.nativeDeps."native-buffer-browserify" or []);
    deps = {
      "base64-js-0.0.7" = self.by-version."base64-js"."0.0.7";
      "ieee754-1.1.4" = self.by-version."ieee754"."1.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "native-buffer-browserify" ];
  };
  by-spec."native-buffer-browserify"."~2.0.15" =
    self.by-version."native-buffer-browserify"."2.0.17";
  by-spec."native-or-bluebird"."1" =
    self.by-version."native-or-bluebird"."1.1.2";
  by-version."native-or-bluebird"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "native-or-bluebird-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/native-or-bluebird/-/native-or-bluebird-1.1.2.tgz";
        name = "native-or-bluebird-1.1.2.tgz";
        sha1 = "3921e110232d1eb790f3dac61bb370531c7d356e";
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
    self.by-version."nconf"."0.7.1";
  by-version."nconf"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "nconf-0.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nconf/-/nconf-0.7.1.tgz";
        name = "nconf-0.7.1.tgz";
        sha1 = "ee4b561dd979a3c58db122e38f196d49d61aeb5b";
      })
    ];
    buildInputs =
      (self.nativeDeps."nconf" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nconf" ];
  };
  "nconf" = self.by-version."nconf"."0.7.1";
  by-spec."nconf"."0.6.9" =
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
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
      "optimist-0.6.0" = self.by-version."optimist"."0.6.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nconf" ];
  };
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
  by-spec."ncp"."~0.4.2" =
    self.by-version."ncp"."0.4.2";
  by-spec."ncp"."~1.0.1" =
    self.by-version."ncp"."1.0.1";
  by-version."ncp"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-1.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-1.0.1.tgz";
        name = "ncp-1.0.1.tgz";
        sha1 = "d15367e5cb87432ba117d2bf80fdf45aecfb4246";
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
  by-spec."negotiator"."0.4.2" =
    self.by-version."negotiator"."0.4.2";
  by-version."negotiator"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.4.2.tgz";
        name = "negotiator-0.4.2.tgz";
        sha1 = "8c43ea7e4c40ddfe40c3c0234c4ef77500b8fd37";
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
  by-spec."network-address"."0.0.5" =
    self.by-version."network-address"."0.0.5";
  by-version."network-address"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "network-address-0.0.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/network-address/-/network-address-0.0.5.tgz";
        name = "network-address-0.0.5.tgz";
        sha1 = "a400225438cacb67cd6108e8e826d5920a705dcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."network-address" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "network-address" ];
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
  by-spec."nib"."*" =
    self.by-version."nib"."1.0.4";
  by-version."nib"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "nib-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nib/-/nib-1.0.4.tgz";
        name = "nib-1.0.4.tgz";
        sha1 = "03d397c27a231f3c9a5a190eaa68e5d79e2f0345";
      })
    ];
    buildInputs =
      (self.nativeDeps."nib" or []);
    deps = {
      "stylus-0.45.1" = self.by-version."stylus"."0.45.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nib" ];
  };
  "nib" = self.by-version."nib"."1.0.4";
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
    self.by-version."nijs"."0.0.22";
  by-version."nijs"."0.0.22" = lib.makeOverridable self.buildNodePackage {
    name = "nijs-0.0.22";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.22.tgz";
        name = "nijs-0.0.22.tgz";
        sha1 = "41f162cfd4b8e99b56da26b3170307381916718a";
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
  "nijs" = self.by-version."nijs"."0.0.22";
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
    self.by-version."node-expat"."2.3.3";
  by-version."node-expat"."2.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-expat-2.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-expat/-/node-expat-2.3.3.tgz";
        name = "node-expat-2.3.3.tgz";
        sha1 = "fd7bfe475c9dd30b634cc1279c7a68aea900ebfa";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-expat" or []);
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "nan-1.4.1" = self.by-version."nan"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-expat" ];
  };
  "node-expat" = self.by-version."node-expat"."2.3.3";
  by-spec."node-expat".">=1.4.1" =
    self.by-version."node-expat"."2.3.3";
  by-spec."node-expat"."~2.1.4" =
    self.by-version."node-expat"."2.1.4";
  by-version."node-expat"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-expat-2.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-expat/-/node-expat-2.1.4.tgz";
        name = "node-expat-2.1.4.tgz";
        sha1 = "e55a82249b71afbce09ffa880705ec37553c5121";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-expat" or []);
    deps = {
      "nan-0.6.0" = self.by-version."nan"."0.6.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-expat" ];
  };
  by-spec."node-expat"."~2.3.0" =
    self.by-version."node-expat"."2.3.3";
  by-spec."node-expat"."~2.3.1" =
    self.by-version."node-expat"."2.3.3";
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
      "fstream-1.0.3" = self.by-version."fstream"."1.0.3";
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "tar-1.0.3" = self.by-version."tar"."1.0.3";
      "which-1.0.7" = self.by-version."which"."1.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  "node-gyp" = self.by-version."node-gyp"."1.0.2";
  by-spec."node-gyp"."~0.10.6" =
    self.by-version."node-gyp"."0.10.10";
  by-version."node-gyp"."0.10.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.10.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.10.10.tgz";
        name = "node-gyp-0.10.10.tgz";
        sha1 = "74290b46b72046d648d301fae3813feb0d07edd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp" or []);
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "minimatch-0.4.0" = self.by-version."minimatch"."0.4.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-2.1.0" = self.by-version."semver"."2.1.0";
      "tar-0.1.20" = self.by-version."tar"."0.1.20";
      "which-1.0.7" = self.by-version."which"."1.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  by-spec."node-gyp"."~0.12.2" =
    self.by-version."node-gyp"."0.12.2";
  by-version."node-gyp"."0.12.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.12.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.12.2.tgz";
        name = "node-gyp-0.12.2.tgz";
        sha1 = "bdca7e7025feb308ddd7fd3434300e47703ec57a";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp" or []);
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "minimatch-0.4.0" = self.by-version."minimatch"."0.4.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-2.2.1" = self.by-version."semver"."2.2.1";
      "tar-0.1.20" = self.by-version."tar"."0.1.20";
      "which-1.0.7" = self.by-version."which"."1.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
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
      "which-1.0.7" = self.by-version."which"."1.0.7";
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
      "nan-1.4.1" = self.by-version."nan"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-protobuf" ];
  };
  "node-protobuf" = self.by-version."node-protobuf"."1.2.2";
  by-spec."node-stringprep"."*" =
    self.by-version."node-stringprep"."0.6.2";
  by-version."node-stringprep"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-stringprep-0.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-stringprep/-/node-stringprep-0.6.2.tgz";
        name = "node-stringprep-0.6.2.tgz";
        sha1 = "c266853e5c22dfb53d99bcc68b02218c889ccdc7";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-stringprep" or []);
    deps = {
      "nan-1.2.0" = self.by-version."nan"."1.2.0";
      "bindings-1.1.1" = self.by-version."bindings"."1.1.1";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-stringprep" ];
  };
  "node-stringprep" = self.by-version."node-stringprep"."0.6.2";
  by-spec."node-stringprep"."^0.5.2" =
    self.by-version."node-stringprep"."0.5.4";
  by-version."node-stringprep"."0.5.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-stringprep-0.5.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-stringprep/-/node-stringprep-0.5.4.tgz";
        name = "node-stringprep-0.5.4.tgz";
        sha1 = "dd03b3d8f6f83137754cc1ea1a55675447b0ab92";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-stringprep" or []);
    deps = {
      "nan-1.2.0" = self.by-version."nan"."1.2.0";
      "bindings-1.1.1" = self.by-version."bindings"."1.1.1";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-stringprep" ];
  };
  by-spec."node-stringprep"."~0.2.0" =
    self.by-version."node-stringprep"."0.2.3";
  by-version."node-stringprep"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-stringprep-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-stringprep/-/node-stringprep-0.2.3.tgz";
        name = "node-stringprep-0.2.3.tgz";
        sha1 = "deab53eacbb2744eb65a3ab76f49a53a6d7f6b1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-stringprep" or []);
    deps = {
      "nan-0.7.1" = self.by-version."nan"."0.7.1";
      "bindings-1.1.1" = self.by-version."bindings"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-stringprep" ];
  };
  by-spec."node-stringprep"."~0.6.0" =
    self.by-version."node-stringprep"."0.6.2";
  by-spec."node-stringprep"."~0.x" =
    self.by-version."node-stringprep"."0.6.2";
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
  by-spec."node-uuid"."^1.4.1" =
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
  by-spec."node-xmpp"."*" =
    self.by-version."node-xmpp"."1.0.0-alpha2";
  by-version."node-xmpp"."1.0.0-alpha2" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-1.0.0-alpha2";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/node-xmpp/-/node-xmpp-1.0.0-alpha2.tgz";
        name = "node-xmpp-1.0.0-alpha2.tgz";
        sha1 = "349041a9041d3bcc608cdbf57e60f5b301e7a8c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp" or []);
    deps = {
      "node-expat-2.3.3" = self.by-version."node-expat"."2.3.3";
      "ltx-0.7.2" = self.by-version."ltx"."0.7.2";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
      "faye-websocket-0.8.1" = self.by-version."faye-websocket"."0.8.1";
      "browserify-3.19.1" = self.by-version."browserify"."3.19.1";
      "brfs-0.0.8" = self.by-version."brfs"."0.0.8";
      "node-xmpp-component-1.0.0-alpha1" = self.by-version."node-xmpp-component"."1.0.0-alpha1";
      "node-xmpp-client-1.0.0-alpha18" = self.by-version."node-xmpp-client"."1.0.0-alpha18";
      "node-xmpp-server-1.0.0-alpha11" = self.by-version."node-xmpp-server"."1.0.0-alpha11";
      "node-xmpp-core-1.0.0-alpha11" = self.by-version."node-xmpp-core"."1.0.0-alpha11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp" ];
  };
  "node-xmpp" = self.by-version."node-xmpp"."1.0.0-alpha2";
  by-spec."node-xmpp"."~0.15.0" =
    self.by-version."node-xmpp"."0.15.0";
  by-version."node-xmpp"."0.15.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-0.15.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp/-/node-xmpp-0.15.0.tgz";
        name = "node-xmpp-0.15.0.tgz";
        sha1 = "b4e1adf6b4ea859f0d06e12daca9f850286cbb14";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp" or []);
    deps = {
      "node-expat-2.3.3" = self.by-version."node-expat"."2.3.3";
      "ltx-0.7.2" = self.by-version."ltx"."0.7.2";
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
      "faye-websocket-0.8.1" = self.by-version."faye-websocket"."0.8.1";
      "browserify-3.19.1" = self.by-version."browserify"."3.19.1";
      "brfs-0.0.8" = self.by-version."brfs"."0.0.8";
      "node-xmpp-component-0.3.0" = self.by-version."node-xmpp-component"."0.3.0";
      "node-xmpp-client-0.4.0" = self.by-version."node-xmpp-client"."0.4.0";
      "node-xmpp-server-0.6.0" = self.by-version."node-xmpp-server"."0.6.0";
      "node-xmpp-core-0.5.0" = self.by-version."node-xmpp-core"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp" ];
  };
  by-spec."node-xmpp-client"."*" =
    self.by-version."node-xmpp-client"."1.0.0-alpha9";
  by-version."node-xmpp-client"."1.0.0-alpha9" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-client-1.0.0-alpha9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-client/-/node-xmpp-client-1.0.0-alpha9.tgz";
        name = "node-xmpp-client-1.0.0-alpha9.tgz";
        sha1 = "5e48ce59f9ea96ff7f80dc4fff2be252ace26f24";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-client" or []);
    deps = {
      "request-2.27.0" = self.by-version."request"."2.27.0";
      "faye-websocket-0.7.3" = self.by-version."faye-websocket"."0.7.3";
      "node-xmpp-core-1.0.0-alpha9" = self.by-version."node-xmpp-core"."1.0.0-alpha9";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-client" ];
  };
  "node-xmpp-client" = self.by-version."node-xmpp-client"."1.0.0-alpha9";
  by-spec."node-xmpp-client"."git+https://github.com/node-xmpp/node-xmpp-client.git" =
    self.by-version."node-xmpp-client"."1.0.0-alpha18";
  by-version."node-xmpp-client"."1.0.0-alpha18" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-client-1.0.0-alpha18";
    bin = false;
    src = [
      (fetchgit {
        url = "https://github.com/node-xmpp/node-xmpp-client.git";
        rev = "7a7b32a65405e087a72e37f534dfb62aa0dc005a";
        sha256 = "5744e791465babfd1c2678304c3ef08a23371f9d1f9b45364d9dfd7e7a62e1c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-client" or []);
    deps = {
      "request-2.48.0" = self.by-version."request"."2.48.0";
      "faye-websocket-0.7.3" = self.by-version."faye-websocket"."0.7.3";
      "node-xmpp-core-1.0.0-alpha9" = self.by-version."node-xmpp-core"."1.0.0-alpha9";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-client" ];
  };
  by-spec."node-xmpp-client"."~0.4.0" =
    self.by-version."node-xmpp-client"."0.4.0";
  by-version."node-xmpp-client"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-client-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-client/-/node-xmpp-client-0.4.0.tgz";
        name = "node-xmpp-client-0.4.0.tgz";
        sha1 = "350def1797eaca28c592321cd16173f93167f90b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-client" or []);
    deps = {
      "request-2.27.0" = self.by-version."request"."2.27.0";
      "ltx-0.3.4" = self.by-version."ltx"."0.3.4";
      "faye-websocket-0.7.3" = self.by-version."faye-websocket"."0.7.3";
      "node-xmpp-core-0.5.0" = self.by-version."node-xmpp-core"."0.5.0";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-client" ];
  };
  by-spec."node-xmpp-component"."*" =
    self.by-version."node-xmpp-component"."1.0.0-alpha1";
  by-version."node-xmpp-component"."1.0.0-alpha1" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-component-1.0.0-alpha1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-component/-/node-xmpp-component-1.0.0-alpha1.tgz";
        name = "node-xmpp-component-1.0.0-alpha1.tgz";
        sha1 = "3f85da00c05240bd48cc6c729d74875e6eb97877";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-component" or []);
    deps = {
      "ltx-0.7.2" = self.by-version."ltx"."0.7.2";
      "node-xmpp-core-1.0.0-alpha1" = self.by-version."node-xmpp-core"."1.0.0-alpha1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-component" ];
  };
  "node-xmpp-component" = self.by-version."node-xmpp-component"."1.0.0-alpha1";
  by-spec."node-xmpp-component"."git+https://github.com/node-xmpp/node-xmpp-component.git" =
    self.by-version."node-xmpp-component"."1.0.0-alpha1";
  by-spec."node-xmpp-component"."~0.3.0" =
    self.by-version."node-xmpp-component"."0.3.0";
  by-version."node-xmpp-component"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-component-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-component/-/node-xmpp-component-0.3.0.tgz";
        name = "node-xmpp-component-0.3.0.tgz";
        sha1 = "353fb4d8250beb7f55df17805d20c81d4ea0d3c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-component" or []);
    deps = {
      "ltx-0.3.4" = self.by-version."ltx"."0.3.4";
      "node-xmpp-core-0.5.0" = self.by-version."node-xmpp-core"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-component" ];
  };
  by-spec."node-xmpp-core"."*" =
    self.by-version."node-xmpp-core"."1.0.0-alpha9";
  by-version."node-xmpp-core"."1.0.0-alpha9" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-core-1.0.0-alpha9";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-core/-/node-xmpp-core-1.0.0-alpha9.tgz";
        name = "node-xmpp-core-1.0.0-alpha9.tgz";
        sha1 = "64b2b41e9f59fc910c71fe648c6be2bc4ecef7f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-core" or []);
    deps = {
      "node-stringprep-0.5.4" = self.by-version."node-stringprep"."0.5.4";
      "reconnect-core-0.0.1" = self.by-version."reconnect-core"."0.0.1";
      "tls-connect-0.2.2" = self.by-version."tls-connect"."0.2.2";
      "ltx-0.5.2" = self.by-version."ltx"."0.5.2";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-core" ];
  };
  "node-xmpp-core" = self.by-version."node-xmpp-core"."1.0.0-alpha9";
  by-spec."node-xmpp-core"."1.0.0-alpha1" =
    self.by-version."node-xmpp-core"."1.0.0-alpha1";
  by-version."node-xmpp-core"."1.0.0-alpha1" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-core-1.0.0-alpha1";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-core/-/node-xmpp-core-1.0.0-alpha1.tgz";
        name = "node-xmpp-core-1.0.0-alpha1.tgz";
        sha1 = "94b1b33a0ccb84427d8b290af80e29b8dec5545f";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-core" or []);
    deps = {
      "node-stringprep-0.6.2" = self.by-version."node-stringprep"."0.6.2";
      "reconnect-core-0.0.1" = self.by-version."reconnect-core"."0.0.1";
      "tls-connect-0.2.2" = self.by-version."tls-connect"."0.2.2";
      "ltx-0.7.2" = self.by-version."ltx"."0.7.2";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-core" ];
  };
  by-spec."node-xmpp-core"."^1.0.0-alpha10" =
    self.by-version."node-xmpp-core"."1.0.0-alpha9";
  by-spec."node-xmpp-core"."^1.0.0-alpha6" =
    self.by-version."node-xmpp-core"."1.0.0-alpha9";
  by-spec."node-xmpp-core"."^1.0.0-alpha9" =
    self.by-version."node-xmpp-core"."1.0.0-alpha9";
  by-spec."node-xmpp-core"."git+https://github.com/node-xmpp/node-xmpp-core.git" =
    self.by-version."node-xmpp-core"."1.0.0-alpha11";
  by-version."node-xmpp-core"."1.0.0-alpha11" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-core-1.0.0-alpha11";
    bin = false;
    src = [
      (self.patchSource fetchgit {
        url = "https://github.com/node-xmpp/node-xmpp-core.git";
        rev = "f10cef6ab105c1542f698c5648c47e685adc38ad";
        sha256 = "734a4681af2078d8f3daf1e8aeb2b4121003115a804e1666e416e87b48720ebc";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-core" or []);
    deps = {
      "node-stringprep-0.5.4" = self.by-version."node-stringprep"."0.5.4";
      "reconnect-core-0.0.1" = self.by-version."reconnect-core"."0.0.1";
      "tls-connect-0.2.2" = self.by-version."tls-connect"."0.2.2";
      "ltx-0.7.2" = self.by-version."ltx"."0.7.2";
      "debug-0.8.1" = self.by-version."debug"."0.8.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-core" ];
  };
  by-spec."node-xmpp-core"."~0.5.0" =
    self.by-version."node-xmpp-core"."0.5.0";
  by-version."node-xmpp-core"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-core-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-core/-/node-xmpp-core-0.5.0.tgz";
        name = "node-xmpp-core-0.5.0.tgz";
        sha1 = "d3a453bf7bc029b7b5f10b1941e8a9e2952cf3db";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-core" or []);
    deps = {
      "node-stringprep-0.2.3" = self.by-version."node-stringprep"."0.2.3";
      "tls-connect-0.2.2" = self.by-version."tls-connect"."0.2.2";
      "ltx-0.3.4" = self.by-version."ltx"."0.3.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-core" ];
  };
  by-spec."node-xmpp-core"."~1.0.0-alpha10" =
    self.by-version."node-xmpp-core"."1.0.0-alpha9";
  by-spec."node-xmpp-joap"."*" =
    self.by-version."node-xmpp-joap"."0.0.17";
  by-version."node-xmpp-joap"."0.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-joap-0.0.17";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-joap/-/node-xmpp-joap-0.0.17.tgz";
        name = "node-xmpp-joap-0.0.17.tgz";
        sha1 = "d6d4fce1148f3fa158ed2a381787c51be3168fff";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-joap" or []);
    deps = {
      "node-expat-2.3.3" = self.by-version."node-expat"."2.3.3";
      "node-xmpp-0.15.0" = self.by-version."node-xmpp"."0.15.0";
      "node-stringprep-0.6.2" = self.by-version."node-stringprep"."0.6.2";
      "ltx-0.6.0" = self.by-version."ltx"."0.6.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "toobusy-0.2.4" = self.by-version."toobusy"."0.2.4";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-joap" ];
  };
  "node-xmpp-joap" = self.by-version."node-xmpp-joap"."0.0.17";
  by-spec."node-xmpp-server"."*" =
    self.by-version."node-xmpp-server"."1.0.0-alpha9";
  by-version."node-xmpp-server"."1.0.0-alpha9" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-server-1.0.0-alpha9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-server/-/node-xmpp-server-1.0.0-alpha9.tgz";
        name = "node-xmpp-server-1.0.0-alpha9.tgz";
        sha1 = "1622aafddf9efde4dd9483c849d56b80e582a745";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-server" or []);
    deps = {
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "node-xmpp-core-1.0.0-alpha9" = self.by-version."node-xmpp-core"."1.0.0-alpha9";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-server" ];
  };
  "node-xmpp-server" = self.by-version."node-xmpp-server"."1.0.0-alpha9";
  by-spec."node-xmpp-server"."git+https://github.com/node-xmpp/node-xmpp-server.git" =
    self.by-version."node-xmpp-server"."1.0.0-alpha11";
  by-version."node-xmpp-server"."1.0.0-alpha11" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-server-1.0.0-alpha11";
    bin = false;
    src = [
      (fetchgit {
        url = "https://github.com/node-xmpp/node-xmpp-server.git";
        rev = "535abf75c95c3e500ebb14a863b81bfa4da529db";
        sha256 = "5abac2a86079c6f4ba1371a6a6455f6ae022e19965151dc0c309c875f2629eb9";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-server" or []);
    deps = {
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "node-xmpp-core-1.0.0-alpha9" = self.by-version."node-xmpp-core"."1.0.0-alpha9";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-server" ];
  };
  by-spec."node-xmpp-server"."~0.6.0" =
    self.by-version."node-xmpp-server"."0.6.0";
  by-version."node-xmpp-server"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-server-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-server/-/node-xmpp-server-0.6.0.tgz";
        name = "node-xmpp-server-0.6.0.tgz";
        sha1 = "66f7102d9b0c9aa34e2d37aa2f78811964f1298e";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-server" or []);
    deps = {
      "ltx-0.3.4" = self.by-version."ltx"."0.3.4";
      "node-xmpp-core-0.5.0" = self.by-version."node-xmpp-core"."0.5.0";
      "node-xmpp-client-0.4.0" = self.by-version."node-xmpp-client"."0.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-server" ];
  };
  by-spec."node-xmpp-serviceadmin"."*" =
    self.by-version."node-xmpp-serviceadmin"."0.1.6";
  by-version."node-xmpp-serviceadmin"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-xmpp-serviceadmin-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-xmpp-serviceadmin/-/node-xmpp-serviceadmin-0.1.6.tgz";
        name = "node-xmpp-serviceadmin-0.1.6.tgz";
        sha1 = "c67be0926b56b12c050d7caf8e2522b36ea84c00";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-xmpp-serviceadmin" or []);
    deps = {
      "node-xmpp-core-0.5.0" = self.by-version."node-xmpp-core"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-xmpp-serviceadmin" ];
  };
  "node-xmpp-serviceadmin" = self.by-version."node-xmpp-serviceadmin"."0.1.6";
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
  by-spec."nopt"."3.0.1" =
    self.by-version."nopt"."3.0.1";
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
  by-spec."nopt"."~2.1.1" =
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
  by-spec."nopt"."~2.1.2" =
    self.by-version."nopt"."2.1.2";
  by-spec."nopt"."~2.2.0" =
    self.by-version."nopt"."2.2.1";
  by-spec."nopt"."~3.0.0" =
    self.by-version."nopt"."3.0.1";
  by-spec."nopt"."~3.0.1" =
    self.by-version."nopt"."3.0.1";
  by-spec."normalize-package-data"."^0.2.13" =
    self.by-version."normalize-package-data"."0.2.13";
  by-version."normalize-package-data"."0.2.13" = lib.makeOverridable self.buildNodePackage {
    name = "normalize-package-data-0.2.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/normalize-package-data/-/normalize-package-data-0.2.13.tgz";
        name = "normalize-package-data-0.2.13.tgz";
        sha1 = "50f9fd9e77b1c8411cd231db2962e73963de774d";
      })
    ];
    buildInputs =
      (self.nativeDeps."normalize-package-data" or []);
    deps = {
      "github-url-from-git-1.1.1" = self.by-version."github-url-from-git"."1.1.1";
      "github-url-from-username-repo-0.1.0" = self.by-version."github-url-from-username-repo"."0.1.0";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "normalize-package-data" ];
  };
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
    self.by-version."npm"."2.1.11";
  by-version."npm"."2.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "npm-2.1.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-2.1.11.tgz";
        name = "npm-2.1.11.tgz";
        sha1 = "1eed4c04e4c8c745bc721baba1b4fe42f2af140c";
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
      "fs-vacuum-1.2.2" = self.by-version."fs-vacuum"."1.2.2";
      "fs-write-stream-atomic-1.0.2" = self.by-version."fs-write-stream-atomic"."1.0.2";
      "fstream-1.0.3" = self.by-version."fstream"."1.0.3";
      "fstream-npm-1.0.1" = self.by-version."fstream-npm"."1.0.1";
      "github-url-from-git-1.4.0" = self.by-version."github-url-from-git"."1.4.0";
      "github-url-from-username-repo-1.0.2" = self.by-version."github-url-from-username-repo"."1.0.2";
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
      "init-package-json-1.1.2" = self.by-version."init-package-json"."1.1.2";
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
      "npm-registry-client-4.0.4" = self.by-version."npm-registry-client"."4.0.4";
      "npm-user-validate-0.1.1" = self.by-version."npm-user-validate"."0.1.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "opener-1.4.0" = self.by-version."opener"."1.4.0";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "path-is-inside-1.0.1" = self.by-version."path-is-inside"."1.0.1";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "read-installed-3.1.3" = self.by-version."read-installed"."3.1.3";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "realize-package-specifier-1.3.0" = self.by-version."realize-package-specifier"."1.3.0";
      "request-2.48.0" = self.by-version."request"."2.48.0";
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "sha-1.3.0" = self.by-version."sha"."1.3.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "sorted-object-1.0.0" = self.by-version."sorted-object"."1.0.0";
      "tar-1.0.3" = self.by-version."tar"."1.0.3";
      "text-table-0.2.0" = self.by-version."text-table"."0.2.0";
      "uid-number-0.0.6" = self.by-version."uid-number"."0.0.6";
      "which-1.0.7" = self.by-version."which"."1.0.7";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
      "write-file-atomic-1.1.0" = self.by-version."write-file-atomic"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  "npm" = self.by-version."npm"."2.1.11";
  by-spec."npm"."1.3.4" =
    self.by-version."npm"."1.3.4";
  by-version."npm"."1.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "npm-1.3.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-1.3.4.tgz";
        name = "npm-1.3.4.tgz";
        sha1 = "1dacc91458f2197c362d774d2cbf111680f86ec2";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm" or []);
    deps = {
      "semver-2.0.11" = self.by-version."semver"."2.0.11";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "nopt-2.1.2" = self.by-version."nopt"."2.1.2";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "request-2.21.0" = self.by-version."request"."2.21.0";
      "which-1.0.7" = self.by-version."which"."1.0.7";
      "tar-0.1.20" = self.by-version."tar"."0.1.20";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "inherits-1.0.0" = self.by-version."inherits"."1.0.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "lru-cache-2.3.1" = self.by-version."lru-cache"."2.3.1";
      "node-gyp-0.10.10" = self.by-version."node-gyp"."0.10.10";
      "fstream-npm-0.1.8" = self.by-version."fstream-npm"."0.1.8";
      "uid-number-0.0.6" = self.by-version."uid-number"."0.0.6";
      "archy-0.0.2" = self.by-version."archy"."0.0.2";
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "npmlog-0.0.4" = self.by-version."npmlog"."0.0.4";
      "ansi-0.1.2" = self.by-version."ansi"."0.1.2";
      "npm-registry-client-0.2.31" = self.by-version."npm-registry-client"."0.2.31";
      "read-package-json-1.1.9" = self.by-version."read-package-json"."1.1.9";
      "read-installed-0.2.5" = self.by-version."read-installed"."0.2.5";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "init-package-json-0.0.10" = self.by-version."init-package-json"."0.0.10";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "lockfile-0.4.3" = self.by-version."lockfile"."0.4.3";
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
      "once-1.1.1" = self.by-version."once"."1.1.1";
      "npmconf-0.1.16" = self.by-version."npmconf"."0.1.16";
      "opener-1.3.0" = self.by-version."opener"."1.3.0";
      "chmodr-0.1.0" = self.by-version."chmodr"."0.1.0";
      "cmd-shim-1.1.2" = self.by-version."cmd-shim"."1.1.2";
      "sha-1.0.1" = self.by-version."sha"."1.0.1";
      "editor-0.0.4" = self.by-version."editor"."0.0.4";
      "child-process-close-0.1.1" = self.by-version."child-process-close"."0.1.1";
      "npm-user-validate-0.0.3" = self.by-version."npm-user-validate"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  by-spec."npm"."1.3.x" =
    self.by-version."npm"."1.3.26";
  by-version."npm"."1.3.26" = lib.makeOverridable self.buildNodePackage {
    name = "npm-1.3.26";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-1.3.26.tgz";
        name = "npm-1.3.26.tgz";
        sha1 = "bc07bf7cb58710078141c885c2d492fd570f606d";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm" or []);
    deps = {
      "semver-2.2.1" = self.by-version."semver"."2.2.1";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "nopt-2.1.2" = self.by-version."nopt"."2.1.2";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "request-2.30.0" = self.by-version."request"."2.30.0";
      "which-1.0.7" = self.by-version."which"."1.0.7";
      "tar-0.1.20" = self.by-version."tar"."0.1.20";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "read-1.0.5" = self.by-version."read"."1.0.5";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "node-gyp-0.12.2" = self.by-version."node-gyp"."0.12.2";
      "fstream-npm-0.1.8" = self.by-version."fstream-npm"."0.1.8";
      "uid-number-0.0.6" = self.by-version."uid-number"."0.0.6";
      "archy-0.0.2" = self.by-version."archy"."0.0.2";
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "npmlog-0.0.6" = self.by-version."npmlog"."0.0.6";
      "ansi-0.2.1" = self.by-version."ansi"."0.2.1";
      "npm-registry-client-0.3.6" = self.by-version."npm-registry-client"."0.3.6";
      "read-package-json-1.1.9" = self.by-version."read-package-json"."1.1.9";
      "read-installed-0.2.5" = self.by-version."read-installed"."0.2.5";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "init-package-json-0.0.14" = self.by-version."init-package-json"."0.0.14";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "lockfile-0.4.3" = self.by-version."lockfile"."0.4.3";
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "npmconf-0.1.16" = self.by-version."npmconf"."0.1.16";
      "opener-1.3.0" = self.by-version."opener"."1.3.0";
      "chmodr-0.1.0" = self.by-version."chmodr"."0.1.0";
      "cmd-shim-1.1.2" = self.by-version."cmd-shim"."1.1.2";
      "sha-1.2.4" = self.by-version."sha"."1.2.4";
      "editor-0.0.5" = self.by-version."editor"."0.0.5";
      "child-process-close-0.1.1" = self.by-version."child-process-close"."0.1.1";
      "npm-user-validate-0.0.3" = self.by-version."npm-user-validate"."0.0.3";
      "github-url-from-git-1.1.1" = self.by-version."github-url-from-git"."1.1.1";
      "github-url-from-username-repo-0.0.2" = self.by-version."github-url-from-username-repo"."0.0.2";
      "text-table-0.2.0" = self.by-version."text-table"."0.2.0";
      "ansicolors-0.3.2" = self.by-version."ansicolors"."0.3.2";
      "ansistyles-0.1.3" = self.by-version."ansistyles"."0.1.3";
      "path-is-inside-1.0.1" = self.by-version."path-is-inside"."1.0.1";
      "columnify-0.1.2" = self.by-version."columnify"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  by-spec."npm-cache-filename"."~1.0.1" =
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
  by-spec."npm-check-updates"."*" =
    self.by-version."npm-check-updates"."1.2.0";
  by-version."npm-check-updates"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "npm-check-updates-1.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-check-updates/-/npm-check-updates-1.2.0.tgz";
        name = "npm-check-updates-1.2.0.tgz";
        sha1 = "9e055cdc4a6fad8043bb95adf23eb74f5718c3ec";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-check-updates" or []);
    deps = {
      "npm-1.3.26" = self.by-version."npm"."1.3.26";
      "commander-2.0.0" = self.by-version."commander"."2.0.0";
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "read-package-json-1.1.9" = self.by-version."read-package-json"."1.1.9";
      "semver-2.2.1" = self.by-version."semver"."2.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-check-updates" ];
  };
  "npm-check-updates" = self.by-version."npm-check-updates"."1.2.0";
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
      "request-2.49.0" = self.by-version."request"."2.49.0";
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
  by-spec."npm-registry-client"."~0.2.27" =
    self.by-version."npm-registry-client"."0.2.31";
  by-version."npm-registry-client"."0.2.31" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.2.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.2.31.tgz";
        name = "npm-registry-client-0.2.31.tgz";
        sha1 = "24a23e24e43246677cb485f8391829e9536563d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = {
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
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
  by-spec."npm-registry-client"."~0.3.5" =
    self.by-version."npm-registry-client"."0.3.6";
  by-version."npm-registry-client"."0.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.3.6.tgz";
        name = "npm-registry-client-0.3.6.tgz";
        sha1 = "c48a2a03643769acc49672860f7920ec6bffac6e";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = {
      "request-2.49.0" = self.by-version."request"."2.49.0";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "retry-0.6.0" = self.by-version."retry"."0.6.0";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-registry-client"."~4.0.4" =
    self.by-version."npm-registry-client"."4.0.4";
  by-version."npm-registry-client"."4.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-4.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-4.0.4.tgz";
        name = "npm-registry-client-4.0.4.tgz";
        sha1 = "6935cde6460a3bf1cb6019d7523196e0fb96fb62";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = {
      "chownr-0.0.1" = self.by-version."chownr"."0.0.1";
      "concat-stream-1.4.7" = self.by-version."concat-stream"."1.4.7";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "normalize-package-data-1.0.3" = self.by-version."normalize-package-data"."1.0.3";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "request-2.49.0" = self.by-version."request"."2.49.0";
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
  by-spec."npm-user-validate"."0.0.3" =
    self.by-version."npm-user-validate"."0.0.3";
  by-version."npm-user-validate"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "npm-user-validate-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-user-validate/-/npm-user-validate-0.0.3.tgz";
        name = "npm-user-validate-0.0.3.tgz";
        sha1 = "818eca4312d13da648f9bc1d7f80bb4f151e0c2e";
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
  by-spec."npmconf"."0.1.16" =
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
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
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
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
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
  by-spec."npmconf"."~0.1.1" =
    self.by-version."npmconf"."0.1.16";
  by-spec."npmconf"."~0.1.12" =
    self.by-version."npmconf"."0.1.16";
  by-spec."npmconf"."~0.1.2" =
    self.by-version."npmconf"."0.1.16";
  by-spec."npmconf"."~2.1.1" =
    self.by-version."npmconf"."2.1.1";
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
  by-spec."npmlog"."0.0.4" =
    self.by-version."npmlog"."0.0.4";
  by-version."npmlog"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.4.tgz";
        name = "npmlog-0.0.4.tgz";
        sha1 = "a12a7418606b7e0183a2851d97a8729b9a0f3837";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog" or []);
    deps = {
      "ansi-0.1.2" = self.by-version."ansi"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  by-spec."npmlog"."0.0.6" =
    self.by-version."npmlog"."0.0.6";
  by-version."npmlog"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.6.tgz";
        name = "npmlog-0.0.6.tgz";
        sha1 = "685043fe71aa1665d6e3b2acef180640caf40873";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog" or []);
    deps = {
      "ansi-0.2.1" = self.by-version."ansi"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  by-spec."npmlog"."0.1" =
    self.by-version."npmlog"."0.1.1";
  by-spec."npmlog"."~0.1.1" =
    self.by-version."npmlog"."0.1.1";
  by-spec."nssocket"."~0.5.1" =
    self.by-version."nssocket"."0.5.2";
  by-version."nssocket"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "nssocket-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nssocket/-/nssocket-0.5.2.tgz";
        name = "nssocket-0.5.2.tgz";
        sha1 = "7ea1d0c3106620f722cdff4ddfd5aac5b2553536";
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
  by-spec."numeral"."^1.5.3" =
    self.by-version."numeral"."1.5.3";
  by-version."numeral"."1.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "numeral-1.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/numeral/-/numeral-1.5.3.tgz";
        name = "numeral-1.5.3.tgz";
        sha1 = "a4c3eba68239580509f818267c77243bce43ff62";
      })
    ];
    buildInputs =
      (self.nativeDeps."numeral" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "numeral" ];
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
  by-spec."oauth-sign"."~0.5.0" =
    self.by-version."oauth-sign"."0.5.0";
  by-version."oauth-sign"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.5.0.tgz";
        name = "oauth-sign-0.5.0.tgz";
        sha1 = "d767f5169325620eab2e087ef0c472e773db6461";
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
  by-spec."object-additions"."^0.5.1" =
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
  by-spec."on-finished"."2.1.1" =
    self.by-version."on-finished"."2.1.1";
  by-version."on-finished"."2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "on-finished-2.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/on-finished/-/on-finished-2.1.1.tgz";
        name = "on-finished-2.1.1.tgz";
        sha1 = "f82ca1c9e3a4f3286b1b9938610e5b8636bd3cb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."on-finished" or []);
    deps = {
      "ee-first-1.1.0" = self.by-version."ee-first"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "on-finished" ];
  };
  by-spec."on-finished"."~2.1.1" =
    self.by-version."on-finished"."2.1.1";
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
  by-spec."once"."^1.1.1" =
    self.by-version."once"."1.3.1";
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.1";
  by-spec."once"."^1.3.1" =
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
  by-spec."optimist"."^0.6.1" =
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
  by-spec."ordered-read-streams"."^0.1.0" =
    self.by-version."ordered-read-streams"."0.1.0";
  by-version."ordered-read-streams"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ordered-read-streams-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ordered-read-streams/-/ordered-read-streams-0.1.0.tgz";
        name = "ordered-read-streams-0.1.0.tgz";
        sha1 = "fd565a9af8eb4473ba69b6ed8a34352cb552f126";
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
  by-spec."parents"."0.0.2" =
    self.by-version."parents"."0.0.2";
  by-version."parents"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "parents-0.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parents/-/parents-0.0.2.tgz";
        name = "parents-0.0.2.tgz";
        sha1 = "67147826e497d40759aaf5ba4c99659b6034d302";
      })
    ];
    buildInputs =
      (self.nativeDeps."parents" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "parents" ];
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
  by-spec."parse-torrent"."^1.4.0" =
    self.by-version."parse-torrent"."1.7.0";
  by-version."parse-torrent"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "parse-torrent-1.7.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parse-torrent/-/parse-torrent-1.7.0.tgz";
        name = "parse-torrent-1.7.0.tgz";
        sha1 = "f64d09d2efa05f7a9e89378d041a63d9ca1e47d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."parse-torrent" or []);
    deps = {
      "bencode-0.6.0" = self.by-version."bencode"."0.6.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "parse-torrent" ];
  };
  by-spec."parse-torrent"."~1.0.0" =
    self.by-version."parse-torrent"."1.0.0";
  by-version."parse-torrent"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "parse-torrent-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parse-torrent/-/parse-torrent-1.0.0.tgz";
        name = "parse-torrent-1.0.0.tgz";
        sha1 = "5a47a038c5db161b7b67b0534636194e1c8907a2";
      })
    ];
    buildInputs =
      (self.nativeDeps."parse-torrent" or []);
    deps = {
      "bncode-0.5.3" = self.by-version."bncode"."0.5.3";
      "rusha-browserify-0.7.3" = self.by-version."rusha-browserify"."0.7.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "parse-torrent" ];
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
  by-spec."passport"."~0.2.1" =
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
  by-spec."peer-wire-protocol"."^0.7.0" =
    self.by-version."peer-wire-protocol"."0.7.0";
  by-version."peer-wire-protocol"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "peer-wire-protocol-0.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/peer-wire-protocol/-/peer-wire-protocol-0.7.0.tgz";
        name = "peer-wire-protocol-0.7.0.tgz";
        sha1 = "6c015abf24b4877ed9eca3822b22d996078011da";
      })
    ];
    buildInputs =
      (self.nativeDeps."peer-wire-protocol" or []);
    deps = {
      "bitfield-0.1.0" = self.by-version."bitfield"."0.1.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "bncode-0.2.3" = self.by-version."bncode"."0.2.3";
      "speedometer-0.1.3" = self.by-version."speedometer"."0.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "peer-wire-protocol" ];
  };
  by-spec."peer-wire-swarm"."^0.9.0" =
    self.by-version."peer-wire-swarm"."0.9.2";
  by-version."peer-wire-swarm"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "peer-wire-swarm-0.9.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/peer-wire-swarm/-/peer-wire-swarm-0.9.2.tgz";
        name = "peer-wire-swarm-0.9.2.tgz";
        sha1 = "092848005607d8ca94e69f9bc9ebe52956ec3048";
      })
    ];
    buildInputs =
      (self.nativeDeps."peer-wire-swarm" or []);
    deps = {
      "peer-wire-protocol-0.7.0" = self.by-version."peer-wire-protocol"."0.7.0";
      "fifo-0.1.4" = self.by-version."fifo"."0.1.4";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "speedometer-0.1.3" = self.by-version."speedometer"."0.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "peer-wire-swarm" ];
  };
  by-spec."peer-wire-swarm"."^0.9.2" =
    self.by-version."peer-wire-swarm"."0.9.2";
  by-spec."peerflix"."*" =
    self.by-version."peerflix"."0.22.2";
  by-version."peerflix"."0.22.2" = lib.makeOverridable self.buildNodePackage {
    name = "peerflix-0.22.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/peerflix/-/peerflix-0.22.2.tgz";
        name = "peerflix-0.22.2.tgz";
        sha1 = "f18fb48d31b65adb29420efa4974a7177e3dd68b";
      })
    ];
    buildInputs =
      (self.nativeDeps."peerflix" or []);
    deps = {
      "clivas-0.1.4" = self.by-version."clivas"."0.1.4";
      "keypress-0.2.1" = self.by-version."keypress"."0.2.1";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "network-address-0.0.5" = self.by-version."network-address"."0.0.5";
      "numeral-1.5.3" = self.by-version."numeral"."1.5.3";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "pump-0.3.5" = self.by-version."pump"."0.3.5";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "rc-0.4.0" = self.by-version."rc"."0.4.0";
      "read-torrent-1.1.0" = self.by-version."read-torrent"."1.1.0";
      "torrent-stream-0.16.2" = self.by-version."torrent-stream"."0.16.2";
      "windows-no-runnable-0.0.6" = self.by-version."windows-no-runnable"."0.0.6";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
      "airplay-js-0.2.6" = self.by-version."airplay-js"."0.2.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "peerflix" ];
  };
  "peerflix" = self.by-version."peerflix"."0.22.2";
  by-spec."peerflix-server"."*" =
    self.by-version."peerflix-server"."0.0.14";
  by-version."peerflix-server"."0.0.14" = lib.makeOverridable self.buildNodePackage {
    name = "peerflix-server-0.0.14";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/peerflix-server/-/peerflix-server-0.0.14.tgz";
        name = "peerflix-server-0.0.14.tgz";
        sha1 = "4f6c29886b6cead1faf8117a3e9c5346ca75b764";
      })
    ];
    buildInputs =
      (self.nativeDeps."peerflix-server" or []);
    deps = {
      "torrent-stream-0.13.5" = self.by-version."torrent-stream"."0.13.5";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "pump-0.3.5" = self.by-version."pump"."0.3.5";
      "express-3.5.3" = self.by-version."express"."3.5.3";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "socket.io-0.9.17" = self.by-version."socket.io"."0.9.17";
      "read-torrent-1.0.0" = self.by-version."read-torrent"."1.0.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "peerflix-server" ];
  };
  "peerflix-server" = self.by-version."peerflix-server"."0.0.14";
  by-spec."pegjs"."0.6.2" =
    self.by-version."pegjs"."0.6.2";
  by-version."pegjs"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "pegjs-0.6.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pegjs/-/pegjs-0.6.2.tgz";
        name = "pegjs-0.6.2.tgz";
        sha1 = "74651f8a800e444db688e4eeae8edb65637a17a5";
      })
    ];
    buildInputs =
      (self.nativeDeps."pegjs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pegjs" ];
  };
  by-spec."pemstrip"."0.0.1" =
    self.by-version."pemstrip"."0.0.1";
  by-version."pemstrip"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "pemstrip-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pemstrip/-/pemstrip-0.0.1.tgz";
        name = "pemstrip-0.0.1.tgz";
        sha1 = "39f7071720cfa13d542c9bde75f1fa5bf9d08806";
      })
    ];
    buildInputs =
      (self.nativeDeps."pemstrip" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pemstrip" ];
  };
  by-spec."phantomjs"."*" =
    self.by-version."phantomjs"."1.9.12";
  by-version."phantomjs"."1.9.12" = lib.makeOverridable self.buildNodePackage {
    name = "phantomjs-1.9.12";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/phantomjs/-/phantomjs-1.9.12.tgz";
        name = "phantomjs-1.9.12.tgz";
        sha1 = "812b137654585413ecb82bf3db9dcd39d8f85f91";
      })
    ];
    buildInputs =
      (self.nativeDeps."phantomjs" or []);
    deps = {
      "adm-zip-0.4.4" = self.by-version."adm-zip"."0.4.4";
      "kew-0.4.0" = self.by-version."kew"."0.4.0";
      "ncp-1.0.1" = self.by-version."ncp"."1.0.1";
      "npmconf-2.0.9" = self.by-version."npmconf"."2.0.9";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "progress-1.1.8" = self.by-version."progress"."1.1.8";
      "request-2.42.0" = self.by-version."request"."2.42.0";
      "request-progress-0.3.1" = self.by-version."request-progress"."0.3.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "which-1.0.7" = self.by-version."which"."1.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "phantomjs" ];
  };
  "phantomjs" = self.by-version."phantomjs"."1.9.12";
  by-spec."phantomjs"."~1.9.1" =
    self.by-version."phantomjs"."1.9.12";
  by-spec."phantomjs"."~1.9.10" =
    self.by-version."phantomjs"."1.9.12";
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
  by-spec."pkginfo"."0.3.x" =
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
  by-spec."pkginfo"."0.x.x" =
    self.by-version."pkginfo"."0.3.0";
  by-spec."plc"."*" =
    self.by-version."plc"."0.1.2";
  by-version."plc"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "plc-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plc/-/plc-0.1.2.tgz";
        name = "plc-0.1.2.tgz";
        sha1 = "a25c5e677261f7912d5d35cedfb2527315b7d329";
      })
    ];
    buildInputs =
      (self.nativeDeps."plc" or []);
    deps = {
      "bits-0.1.1" = self.by-version."bits"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "plc" ];
  };
  "plc" = self.by-version."plc"."0.1.2";
  by-spec."plist"."1.1.0" =
    self.by-version."plist"."1.1.0";
  by-version."plist"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "plist-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plist/-/plist-1.1.0.tgz";
        name = "plist-1.1.0.tgz";
        sha1 = "ff6708590c97cc438e7bc45de5251bd725f3f89d";
      })
    ];
    buildInputs =
      (self.nativeDeps."plist" or []);
    deps = {
      "base64-js-0.0.6" = self.by-version."base64-js"."0.0.6";
      "xmlbuilder-2.2.1" = self.by-version."xmlbuilder"."2.2.1";
      "xmldom-0.1.19" = self.by-version."xmldom"."0.1.19";
      "util-deprecate-1.0.0" = self.by-version."util-deprecate"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "plist" ];
  };
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
  by-spec."plist-with-patches"."0.5.1" =
    self.by-version."plist-with-patches"."0.5.1";
  by-version."plist-with-patches"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "plist-with-patches-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plist-with-patches/-/plist-with-patches-0.5.1.tgz";
        name = "plist-with-patches-0.5.1.tgz";
        sha1 = "868aae2e0df8989b026562b35cbc19cfd8bb780d";
      })
    ];
    buildInputs =
      (self.nativeDeps."plist-with-patches" or []);
    deps = {
      "xmlbuilder-0.4.3" = self.by-version."xmlbuilder"."0.4.3";
      "xmldom-0.1.19" = self.by-version."xmldom"."0.1.19";
    };
    peerDependencies = [
    ];
    passthru.names = [ "plist-with-patches" ];
  };
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
  by-spec."portfinder"."^0.2.1" =
    self.by-version."portfinder"."0.2.1";
  by-version."portfinder"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "portfinder-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/portfinder/-/portfinder-0.2.1.tgz";
        name = "portfinder-0.2.1.tgz";
        sha1 = "b2b9b0164f9e17fa3a9c7db2304d0a75140c71ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."portfinder" or []);
    deps = {
      "mkdirp-0.0.7" = self.by-version."mkdirp"."0.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "portfinder" ];
  };
  by-spec."posix"."*" =
    self.by-version."posix"."1.0.4";
  by-version."posix"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "posix-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/posix/-/posix-1.0.4.tgz";
        name = "posix-1.0.4.tgz";
        sha1 = "628eb17c9c3299a296cf2f9fdc7cbad4fd554a56";
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
  "posix" = self.by-version."posix"."1.0.4";
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
  by-spec."promise"."^6.0.1" =
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
      "winston-0.8.3" = self.by-version."winston"."0.8.3";
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
  by-spec."properties-parser"."0.2.3" =
    self.by-version."properties-parser"."0.2.3";
  by-version."properties-parser"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "properties-parser-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/properties-parser/-/properties-parser-0.2.3.tgz";
        name = "properties-parser-0.2.3.tgz";
        sha1 = "f7591255f707abbff227c7b56b637dbb0373a10f";
      })
    ];
    buildInputs =
      (self.nativeDeps."properties-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "properties-parser" ];
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
  by-spec."proxy-addr"."~1.0.3" =
    self.by-version."proxy-addr"."1.0.4";
  by-version."proxy-addr"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "proxy-addr-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.4.tgz";
        name = "proxy-addr-1.0.4.tgz";
        sha1 = "51dbebbb22cc0eb04b77a76d871b75970f198cdd";
      })
    ];
    buildInputs =
      (self.nativeDeps."proxy-addr" or []);
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-0.1.5" = self.by-version."ipaddr.js"."0.1.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "proxy-addr" ];
  };
  by-spec."proxy-addr"."~1.0.4" =
    self.by-version."proxy-addr"."1.0.4";
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
  by-spec."pump"."^0.3.1" =
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
  by-spec."pump"."^0.3.5" =
    self.by-version."pump"."0.3.5";
  by-spec."pump"."~0.3.2" =
    self.by-version."pump"."0.3.5";
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
  by-spec."punycode".">=1.0.0 <1.1.0" =
    self.by-version."punycode"."1.0.0";
  by-version."punycode"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "punycode-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.0.0.tgz";
        name = "punycode-1.0.0.tgz";
        sha1 = "ce9e6c6e9c1db5827174fceb12ff4938700a1bd3";
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
  by-spec."q"."1.0.1" =
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
  by-spec."q"."~1.0.1" =
    self.by-version."q"."1.0.1";
  by-spec."qap"."^3.1.2" =
    self.by-version."qap"."3.1.2";
  by-version."qap"."3.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "qap-3.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qap/-/qap-3.1.2.tgz";
        name = "qap-3.1.2.tgz";
        sha1 = "3672b8707d0b9b983b18f91fb14237de241bdba8";
      })
    ];
    buildInputs =
      (self.nativeDeps."qap" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qap" ];
  };
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
  by-spec."qs"."2.3.2" =
    self.by-version."qs"."2.3.2";
  by-version."qs"."2.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-2.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.3.2.tgz";
        name = "qs-2.3.2.tgz";
        sha1 = "d45ec249e4b9b029af008829a101d5ff7e972790";
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
  by-spec."qs"."2.3.3" =
    self.by-version."qs"."2.3.3";
  by-version."qs"."2.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "qs-2.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.3.3.tgz";
        name = "qs-2.3.3.tgz";
        sha1 = "e9e85adbe75da0bbe4c8e0476a086290f863b404";
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
    self.by-version."qs"."2.3.3";
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
  by-spec."qs"."~2.3.1" =
    self.by-version."qs"."2.3.3";
  by-spec."querystring".">=0.1.0 <0.2.0" =
    self.by-version."querystring"."0.1.0";
  by-version."querystring"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "querystring-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/querystring/-/querystring-0.1.0.tgz";
        name = "querystring-0.1.0.tgz";
        sha1 = "cb76a26cda0a10a94163fcdb3e132827f04b7b10";
      })
    ];
    buildInputs =
      (self.nativeDeps."querystring" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "querystring" ];
  };
  by-spec."querystring"."https://github.com/substack/querystring/archive/0.2.0-ie8.tar.gz" =
    self.by-version."querystring"."0.2.0";
  by-version."querystring"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "querystring-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "https://github.com/substack/querystring/archive/0.2.0-ie8.tar.gz";
        name = "querystring-0.2.0.tgz";
        sha256 = "9476079402605957bae231ea3ec5ae83b454b2de68ddaa3450096821996be8f5";
      })
    ];
    buildInputs =
      (self.nativeDeps."querystring" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "querystring" ];
  };
  by-spec."querystring-es3"."0.2.0" =
    self.by-version."querystring-es3"."0.2.0";
  by-version."querystring-es3"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "querystring-es3-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.0.tgz";
        name = "querystring-es3-0.2.0.tgz";
        sha1 = "c365a08a69c443accfeb3a9deab35e3f0abaa476";
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
  by-spec."random-access-file"."^0.3.1" =
    self.by-version."random-access-file"."0.3.1";
  by-version."random-access-file"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "random-access-file-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/random-access-file/-/random-access-file-0.3.1.tgz";
        name = "random-access-file-0.3.1.tgz";
        sha1 = "8afffaac665de38feba00f371429648f057d5c16";
      })
    ];
    buildInputs =
      (self.nativeDeps."random-access-file" or []);
    deps = {
      "thunky-0.1.0" = self.by-version."thunky"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "random-access-file" ];
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
  by-spec."range-parser"."^1.0.0" =
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
  by-spec."range-parser"."~1.0.0" =
    self.by-version."range-parser"."1.0.2";
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.2";
  by-spec."raven"."~0.7.2" =
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
  by-spec."raw-body"."1.1.4" =
    self.by-version."raw-body"."1.1.4";
  by-version."raw-body"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "raw-body-1.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.1.4.tgz";
        name = "raw-body-1.1.4.tgz";
        sha1 = "f0b5624388d031f63da07f870c86cb9ccadcb67d";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = {
      "bytes-0.3.0" = self.by-version."bytes"."0.3.0";
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
  by-spec."raw-body"."1.3.1" =
    self.by-version."raw-body"."1.3.1";
  by-version."raw-body"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "raw-body-1.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.3.1.tgz";
        name = "raw-body-1.3.1.tgz";
        sha1 = "26a1491059086fd121942232d16758cd2817f815";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "iconv-lite-0.4.5" = self.by-version."iconv-lite"."0.4.5";
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
  by-spec."rc"."0.5.2" =
    self.by-version."rc"."0.5.2";
  by-version."rc"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.5.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.5.2.tgz";
        name = "rc-0.5.2.tgz";
        sha1 = "6b8e05894a158e3d4a15e7daddb970f4d15a024f";
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
  by-spec."rc"."^0.4.0" =
    self.by-version."rc"."0.4.0";
  by-version."rc"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.4.0.tgz";
        name = "rc-0.4.0.tgz";
        sha1 = "ce24a2029ad94c3a40d09604a87227027d7210d3";
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
  by-spec."rc"."~0.5.4" =
    self.by-version."rc"."0.5.4";
  by-version."rc"."0.5.4" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.5.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.5.4.tgz";
        name = "rc-0.5.4.tgz";
        sha1 = "14169483ccb33b2695a349dbd96ef54e4e92d54f";
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
    self.by-version."react"."0.12.1";
  by-version."react"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "react-0.12.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/react/-/react-0.12.1.tgz";
        name = "react-0.12.1.tgz";
        sha1 = "b73836f4f1888ce79c9372208398a3fb5483bc35";
      })
    ];
    buildInputs =
      (self.nativeDeps."react" or []);
    deps = {
      "envify-3.2.0" = self.by-version."envify"."3.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "react" ];
  };
  "react" = self.by-version."react"."0.12.1";
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
  by-spec."read-installed"."~0.2.2" =
    self.by-version."read-installed"."0.2.5";
  by-version."read-installed"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "read-installed-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-installed/-/read-installed-0.2.5.tgz";
        name = "read-installed-0.2.5.tgz";
        sha1 = "134df8b326d8b54b11e18f7dd8c81bf5e976ef86";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-installed" or []);
    deps = {
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "read-package-json-1.2.7" = self.by-version."read-package-json"."1.2.7";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
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
      "readdir-scoped-modules-1.0.1" = self.by-version."readdir-scoped-modules"."1.0.1";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "util-extend-1.0.1" = self.by-version."util-extend"."1.0.1";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "normalize-package-data-1.0.3" = self.by-version."normalize-package-data"."1.0.3";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  by-spec."read-package-json"."1.1.x" =
    self.by-version."read-package-json"."1.1.9";
  by-version."read-package-json"."1.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "read-package-json-1.1.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.1.9.tgz";
        name = "read-package-json-1.1.9.tgz";
        sha1 = "9c319185e5f8461661c01f8d4e5e80b468aa18ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json" or []);
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "normalize-package-data-0.2.13" = self.by-version."normalize-package-data"."0.2.13";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  by-spec."read-package-json"."~1.1.0" =
    self.by-version."read-package-json"."1.1.9";
  by-spec."read-package-json"."~1.1.6" =
    self.by-version."read-package-json"."1.1.9";
  by-spec."read-package-json"."~1.2.7" =
    self.by-version."read-package-json"."1.2.7";
  by-spec."read-torrent"."^1.1.0" =
    self.by-version."read-torrent"."1.1.0";
  by-version."read-torrent"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "read-torrent-1.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-torrent/-/read-torrent-1.1.0.tgz";
        name = "read-torrent-1.1.0.tgz";
        sha1 = "a34506d88b50682e01cb638576b4fccebfe706ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-torrent" or []);
    deps = {
      "request-2.16.6" = self.by-version."request"."2.16.6";
      "parse-torrent-1.0.0" = self.by-version."parse-torrent"."1.0.0";
      "magnet-uri-2.0.1" = self.by-version."magnet-uri"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-torrent" ];
  };
  by-spec."read-torrent"."~1.0.0" =
    self.by-version."read-torrent"."1.0.0";
  by-version."read-torrent"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "read-torrent-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-torrent/-/read-torrent-1.0.0.tgz";
        name = "read-torrent-1.0.0.tgz";
        sha1 = "d45427a10dbbf21479fdf7e1ce8ce4ad39770966";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-torrent" or []);
    deps = {
      "request-2.16.6" = self.by-version."request"."2.16.6";
      "parse-torrent-1.0.0" = self.by-version."parse-torrent"."1.0.0";
      "magnet-uri-2.0.1" = self.by-version."magnet-uri"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read-torrent" ];
  };
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
  by-spec."readable-stream"."1.0" =
    self.by-version."readable-stream"."1.0.33";
  by-version."readable-stream"."1.0.33" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.33";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.33.tgz";
        name = "readable-stream-1.0.33.tgz";
        sha1 = "3a360dd66c1b1d7fd4705389860eda1d0f61126c";
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
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream".">=1.0.33-1 <1.1.0-0" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream".">=1.1.13-1 <1.2.0-0" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.0.2" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.0.27-1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.0.33" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.0.33-1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."^1.1.13-1" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."~1.0.17" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream"."~1.0.2" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream"."~1.0.24" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream"."~1.0.26-2" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream"."~1.0.33" =
    self.by-version."readable-stream"."1.0.33";
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
    self.by-version."readdir-scoped-modules"."1.0.1";
  by-version."readdir-scoped-modules"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "readdir-scoped-modules-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readdir-scoped-modules/-/readdir-scoped-modules-1.0.1.tgz";
        name = "readdir-scoped-modules-1.0.1.tgz";
        sha1 = "5c2a77f3e08250a8fddf53fa58cdc17900b808b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."readdir-scoped-modules" or []);
    deps = {
      "debuglog-1.0.1" = self.by-version."debuglog"."1.0.1";
      "dezalgo-1.0.1" = self.by-version."dezalgo"."1.0.1";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readdir-scoped-modules" ];
  };
  by-spec."readdirp"."^1.1.0" =
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readdirp" ];
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
  by-spec."realize-package-specifier"."~1.3.0" =
    self.by-version."realize-package-specifier"."1.3.0";
  by-version."realize-package-specifier"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "realize-package-specifier-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/realize-package-specifier/-/realize-package-specifier-1.3.0.tgz";
        name = "realize-package-specifier-1.3.0.tgz";
        sha1 = "23374a84e6a9188483f346cc939eb58eec85efa5";
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
  by-spec."reconnect-core"."https://github.com/dodo/reconnect-core/tarball/merged" =
    self.by-version."reconnect-core"."0.0.1";
  by-version."reconnect-core"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "reconnect-core-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "https://github.com/dodo/reconnect-core/tarball/merged";
        name = "reconnect-core-0.0.1.tgz";
        sha256 = "431dd7a1578061815270e4ad59c6e8b40dff6b308244973e1c11049ccbf1629b";
      })
    ];
    buildInputs =
      (self.nativeDeps."reconnect-core" or []);
    deps = {
      "backoff-2.3.0" = self.by-version."backoff"."2.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "reconnect-core" ];
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
  by-spec."repeating"."^1.1.0" =
    self.by-version."repeating"."1.1.0";
  by-version."repeating"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "repeating-1.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/repeating/-/repeating-1.1.0.tgz";
        name = "repeating-1.1.0.tgz";
        sha1 = "1977511fd1d58075dcb6abbbb2b627edd45e41dc";
      })
    ];
    buildInputs =
      (self.nativeDeps."repeating" or []);
    deps = {
      "is-finite-1.0.0" = self.by-version."is-finite"."1.0.0";
      "meow-1.0.0" = self.by-version."meow"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "repeating" ];
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
    self.by-version."request"."2.49.0";
  by-version."request"."2.49.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.49.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.49.0.tgz";
        name = "request-2.49.0.tgz";
        sha1 = "0d4f6348dc3348059b553e4db60fd2478de662a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "caseless-0.8.0" = self.by-version."caseless"."0.8.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.5.0" = self.by-version."oauth-sign"."0.5.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2 >=2.20.0" =
    self.by-version."request"."2.49.0";
  by-spec."request"."2 >=2.25.0" =
    self.by-version."request"."2.49.0";
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
  by-spec."request"."2.47.0" =
    self.by-version."request"."2.47.0";
  by-version."request"."2.47.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.47.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.47.0.tgz";
        name = "request-2.47.0.tgz";
        sha1 = "09e9fd1a4fed6593a805ef8202b20f0c5ecb485f";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "caseless-0.6.0" = self.by-version."caseless"."0.6.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.4.0" = self.by-version."oauth-sign"."0.4.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
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
  by-spec."request".">= 2.9.153" =
    self.by-version."request"."2.49.0";
  by-spec."request"."^2.36.0" =
    self.by-version."request"."2.49.0";
  by-spec."request"."^2.40.0" =
    self.by-version."request"."2.49.0";
  by-spec."request"."^2.47.0" =
    self.by-version."request"."2.49.0";
  by-spec."request"."^2.48.0" =
    self.by-version."request"."2.49.0";
  by-spec."request"."~2" =
    self.by-version."request"."2.49.0";
  by-spec."request"."~2.16.2" =
    self.by-version."request"."2.16.6";
  by-spec."request"."~2.21.0" =
    self.by-version."request"."2.21.0";
  by-version."request"."2.21.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.21.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.21.0.tgz";
        name = "request-2.21.0.tgz";
        sha1 = "5728ab9c45e5a87c99daccd530298b6673a868d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "json-stringify-safe-4.0.0" = self.by-version."json-stringify-safe"."4.0.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "tunnel-agent-0.3.0" = self.by-version."tunnel-agent"."0.3.0";
      "http-signature-0.9.11" = self.by-version."http-signature"."0.9.11";
      "hawk-0.13.1" = self.by-version."hawk"."0.13.1";
      "aws-sign-0.3.0" = self.by-version."aws-sign"."0.3.0";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "cookie-jar-0.3.0" = self.by-version."cookie-jar"."0.3.0";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "form-data-0.0.8" = self.by-version."form-data"."0.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
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
  by-spec."request"."~2.30.0" =
    self.by-version."request"."2.30.0";
  by-version."request"."2.30.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.30.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.30.0.tgz";
        name = "request-2.30.0.tgz";
        sha1 = "8e0d36f0806e8911524b072b64c5ee535a09d861";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "tough-cookie-0.9.15" = self.by-version."tough-cookie"."0.9.15";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tunnel-agent-0.3.0" = self.by-version."tunnel-agent"."0.3.0";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "hawk-1.0.0" = self.by-version."hawk"."1.0.0";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.40.0" =
    self.by-version."request"."2.40.0";
  by-spec."request"."~2.42.0" =
    self.by-version."request"."2.42.0";
  by-spec."request"."~2.46.0" =
    self.by-version."request"."2.46.0";
  by-version."request"."2.46.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.46.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.46.0.tgz";
        name = "request-2.46.0.tgz";
        sha1 = "359195d52eaf720bc69742579d04ad6d265a8274";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "caseless-0.6.0" = self.by-version."caseless"."0.6.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "qs-1.2.2" = self.by-version."qs"."1.2.2";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
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
  by-spec."request"."~2.48.0" =
    self.by-version."request"."2.48.0";
  by-version."request"."2.48.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.48.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.48.0.tgz";
        name = "request-2.48.0.tgz";
        sha1 = "3ae2e091c9698282d58a0e6989ece2638f0f1f28";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.3" = self.by-version."bl"."0.9.3";
      "caseless-0.7.0" = self.by-version."caseless"."0.7.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.5.0" = self.by-version."oauth-sign"."0.5.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
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
  by-spec."resolve"."0.6.3" =
    self.by-version."resolve"."0.6.3";
  by-version."resolve"."0.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.6.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.6.3.tgz";
        name = "resolve-0.6.3.tgz";
        sha1 = "dd957982e7e736debdf53b58a4dd91754575dd46";
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
  by-spec."resolve"."~0.6.0" =
    self.by-version."resolve"."0.6.3";
  by-spec."resolve"."~0.6.1" =
    self.by-version."resolve"."0.6.3";
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
  by-spec."response-time"."1.0.0" =
    self.by-version."response-time"."1.0.0";
  by-version."response-time"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "response-time-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/response-time/-/response-time-1.0.0.tgz";
        name = "response-time-1.0.0.tgz";
        sha1 = "c2bc8d08f3c359f97eae1d6da86eead175fabdc9";
      })
    ];
    buildInputs =
      (self.nativeDeps."response-time" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "response-time" ];
  };
  by-spec."response-time"."~2.0.1" =
    self.by-version."response-time"."2.0.1";
  by-version."response-time"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "response-time-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/response-time/-/response-time-2.0.1.tgz";
        name = "response-time-2.0.1.tgz";
        sha1 = "c6d2cbadeac4cb251b21016fe182640c02aff343";
      })
    ];
    buildInputs =
      (self.nativeDeps."response-time" or []);
    deps = {
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "response-time" ];
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
      "bluebird-2.3.11" = self.by-version."bluebird"."2.3.11";
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
  by-spec."rimraf"."2.x.x" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."^2.2.5" =
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
  by-spec."run-parallel"."^1.0.0" =
    self.by-version."run-parallel"."1.0.0";
  by-version."run-parallel"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "run-parallel-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/run-parallel/-/run-parallel-1.0.0.tgz";
        name = "run-parallel-1.0.0.tgz";
        sha1 = "1dd0787f994d17f8d1bbe7e910e0cc3036800cbc";
      })
    ];
    buildInputs =
      (self.nativeDeps."run-parallel" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "run-parallel" ];
  };
  by-spec."rusha-browserify"."^0.7.3" =
    self.by-version."rusha-browserify"."0.7.3";
  by-version."rusha-browserify"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "rusha-browserify-0.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rusha-browserify/-/rusha-browserify-0.7.3.tgz";
        name = "rusha-browserify-0.7.3.tgz";
        sha1 = "03b313892e287021cc2fc391e2c154fd7d79aef2";
      })
    ];
    buildInputs =
      (self.nativeDeps."rusha-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rusha-browserify" ];
  };
  by-spec."rx"."^2.2.27" =
    self.by-version."rx"."2.3.18";
  by-version."rx"."2.3.18" = lib.makeOverridable self.buildNodePackage {
    name = "rx-2.3.18";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rx/-/rx-2.3.18.tgz";
        name = "rx-2.3.18.tgz";
        sha1 = "4ae726e3d770db47f070b532f9840c717b2385ba";
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
  by-spec."sax"."0.3.5" =
    self.by-version."sax"."0.3.5";
  by-version."sax"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.3.5.tgz";
        name = "sax-0.3.5.tgz";
        sha1 = "88fcfc1f73c0c8bbd5b7c776b6d3f3501eed073d";
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
  by-spec."sax"."~0.6.0" =
    self.by-version."sax"."0.6.1";
  by-spec."scmp"."1.0.0" =
    self.by-version."scmp"."1.0.0";
  by-version."scmp"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "scmp-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/scmp/-/scmp-1.0.0.tgz";
        name = "scmp-1.0.0.tgz";
        sha1 = "a0b272c3fc7292f77115646f00618b0262514e04";
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
  by-spec."scmp"."~0.0.3" =
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
    self.by-version."selenium-webdriver"."2.44.0";
  by-version."selenium-webdriver"."2.44.0" = lib.makeOverridable self.buildNodePackage {
    name = "selenium-webdriver-2.44.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/selenium-webdriver/-/selenium-webdriver-2.44.0.tgz";
        name = "selenium-webdriver-2.44.0.tgz";
        sha1 = "6cc6257731cd27c6db6471092857755f99d77b57";
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
  "selenium-webdriver" = self.by-version."selenium-webdriver"."2.44.0";
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
  by-spec."semver"."2.0.11" =
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
  by-spec."semver"."2.2.x" =
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
  by-spec."semver"."^4.1.0" =
    self.by-version."semver"."4.1.0";
  by-spec."semver"."~1.1.4" =
    self.by-version."semver"."1.1.4";
  by-spec."semver"."~2.0.5" =
    self.by-version."semver"."2.0.11";
  by-spec."semver"."~2.0.8" =
    self.by-version."semver"."2.0.11";
  by-spec."semver"."~2.1" =
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
  by-spec."semver"."~2.1.0" =
    self.by-version."semver"."2.1.0";
  by-spec."semver"."~2.2.1" =
    self.by-version."semver"."2.2.1";
  by-spec."semver"."~2.3.0" =
    self.by-version."semver"."2.3.2";
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
    self.by-version."send"."0.10.1";
  by-version."send"."0.10.1" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.10.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.10.1.tgz";
        name = "send-0.10.1.tgz";
        sha1 = "7745c50ec72f115115980e8fb179aec01900e08a";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
      "on-finished-2.1.1" = self.by-version."on-finished"."2.1.1";
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
  by-spec."send"."0.10.1" =
    self.by-version."send"."0.10.1";
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
  by-spec."send"."0.3.0" =
    self.by-version."send"."0.3.0";
  by-version."send"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.3.0.tgz";
        name = "send-0.3.0.tgz";
        sha1 = "9718324634806fc75bc4f8f5e51f57d9d66606e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "buffer-crc32-0.2.1" = self.by-version."buffer-crc32"."0.2.1";
      "debug-0.8.0" = self.by-version."debug"."0.8.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
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
  by-spec."serve-favicon"."~2.1.5" =
    self.by-version."serve-favicon"."2.1.7";
  by-version."serve-favicon"."2.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "serve-favicon-2.1.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-favicon/-/serve-favicon-2.1.7.tgz";
        name = "serve-favicon-2.1.7.tgz";
        sha1 = "7b911c0ea4c0f9a2ad686daa5222766f7bc7db79";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-favicon" or []);
    deps = {
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-favicon" ];
  };
  by-spec."serve-favicon"."~2.1.7" =
    self.by-version."serve-favicon"."2.1.7";
  by-spec."serve-index"."1.0.1" =
    self.by-version."serve-index"."1.0.1";
  by-version."serve-index"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "serve-index-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-index/-/serve-index-1.0.1.tgz";
        name = "serve-index-1.0.1.tgz";
        sha1 = "2782ee8ede6cccaae54957962c4715e8ce1921a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-index" or []);
    deps = {
      "batch-0.5.0" = self.by-version."batch"."0.5.0";
      "negotiator-0.4.2" = self.by-version."negotiator"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-index" ];
  };
  by-spec."serve-index"."~1.2.1" =
    self.by-version."serve-index"."1.2.1";
  by-version."serve-index"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "serve-index-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-index/-/serve-index-1.2.1.tgz";
        name = "serve-index-1.2.1.tgz";
        sha1 = "854daef00ac9ff2f5bfda1c019b78fb0ed6d2e6f";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-index" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
      "batch-0.5.1" = self.by-version."batch"."0.5.1";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-index" ];
  };
  by-spec."serve-index"."~1.5.1" =
    self.by-version."serve-index"."1.5.1";
  by-version."serve-index"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "serve-index-1.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-index/-/serve-index-1.5.1.tgz";
        name = "serve-index-1.5.1.tgz";
        sha1 = "11e2cec8b7cdc801a8a766ebf36c1372c956e84a";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-index" or []);
    deps = {
      "accepts-1.1.3" = self.by-version."accepts"."1.1.3";
      "batch-0.5.1" = self.by-version."batch"."0.5.1";
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
      "http-errors-1.2.7" = self.by-version."http-errors"."1.2.7";
      "mime-types-2.0.3" = self.by-version."mime-types"."2.0.3";
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
  by-spec."serve-static"."1.1.0" =
    self.by-version."serve-static"."1.1.0";
  by-version."serve-static"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.1.0.tgz";
        name = "serve-static-1.1.0.tgz";
        sha1 = "454dfa05bb3ddd4e701a8915b83a278aa91c5643";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "parseurl-1.0.1" = self.by-version."parseurl"."1.0.1";
      "send-0.3.0" = self.by-version."send"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
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
  by-spec."serve-static"."~1.7.1" =
    self.by-version."serve-static"."1.7.1";
  by-version."serve-static"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.7.1.tgz";
        name = "serve-static-1.7.1.tgz";
        sha1 = "6ea54d5ba7ef563f00e5fad25d0e4f5307e9809b";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.10.1" = self.by-version."send"."0.10.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
  };
  by-spec."setimmediate"."1.0.1" =
    self.by-version."setimmediate"."1.0.1";
  by-version."setimmediate"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "setimmediate-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/setimmediate/-/setimmediate-1.0.1.tgz";
        name = "setimmediate-1.0.1.tgz";
        sha1 = "a9ca56ccbd6a4c3334855f060abcdece5c42ebb7";
      })
    ];
    buildInputs =
      (self.nativeDeps."setimmediate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "setimmediate" ];
  };
  by-spec."sha"."~1.0.1" =
    self.by-version."sha"."1.0.1";
  by-version."sha"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "sha-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha/-/sha-1.0.1.tgz";
        name = "sha-1.0.1.tgz";
        sha1 = "9b87a92113103e7406f7e7ef00006f3fa1975122";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha" or []);
    deps = {
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
  };
  by-spec."sha"."~1.2.1" =
    self.by-version."sha"."1.2.4";
  by-version."sha"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "sha-1.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha/-/sha-1.2.4.tgz";
        name = "sha-1.2.4.tgz";
        sha1 = "1f9a377f27b6fdee409b9b858e43da702be48a4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
  };
  by-spec."sha.js"."2.3.0" =
    self.by-version."sha.js"."2.3.0";
  by-version."sha.js"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "sha.js-2.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha.js/-/sha.js-2.3.0.tgz";
        name = "sha.js-2.3.0.tgz";
        sha1 = "9fbcbb99583712fd44dedeffebebe5e4617baf71";
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
  by-spec."shelljs"."0.3.0" =
    self.by-version."shelljs"."0.3.0";
  by-spec."shelljs"."0.3.x" =
    self.by-version."shelljs"."0.3.0";
  by-spec."should"."*" =
    self.by-version."should"."4.3.0";
  by-version."should"."4.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "should-4.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should/-/should-4.3.0.tgz";
        name = "should-4.3.0.tgz";
        sha1 = "6fd50fadf9b54134a352f2fd74657b1e97231ad6";
      })
    ];
    buildInputs =
      (self.nativeDeps."should" or []);
    deps = {
      "should-equal-0.1.0" = self.by-version."should-equal"."0.1.0";
      "should-format-0.0.2" = self.by-version."should-format"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should" ];
  };
  "should" = self.by-version."should"."4.3.0";
  by-spec."should-equal"."0.1.0" =
    self.by-version."should-equal"."0.1.0";
  by-version."should-equal"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "should-equal-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-equal/-/should-equal-0.1.0.tgz";
        name = "should-equal-0.1.0.tgz";
        sha1 = "6db4a398a0d5a1a5806350b1de8cb4e964071dab";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-equal" or []);
    deps = {
      "should-type-0.0.1" = self.by-version."should-type"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-equal" ];
  };
  by-spec."should-format"."0.0.2" =
    self.by-version."should-format"."0.0.2";
  by-version."should-format"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "should-format-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-format/-/should-format-0.0.2.tgz";
        name = "should-format-0.0.2.tgz";
        sha1 = "5c058691a1d6177f8b8fa8b8bba0b38cc05d346f";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-format" or []);
    deps = {
      "should-type-0.0.1" = self.by-version."should-type"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-format" ];
  };
  by-spec."should-type"."0.0.1" =
    self.by-version."should-type"."0.0.1";
  by-version."should-type"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "should-type-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-type/-/should-type-0.0.1.tgz";
        name = "should-type-0.0.1.tgz";
        sha1 = "ec62a4eae75cabfab3734cd9925da49773cb9be8";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-type" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-type" ];
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
    self.by-version."sinon"."1.12.1";
  by-version."sinon"."1.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "sinon-1.12.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sinon/-/sinon-1.12.1.tgz";
        name = "sinon-1.12.1.tgz";
        sha1 = "c51a7d083e9992854bb99519faf5c25c9a04009a";
      })
    ];
    buildInputs =
      (self.nativeDeps."sinon" or []);
    deps = {
      "formatio-1.1.1" = self.by-version."formatio"."1.1.1";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "lolex-1.1.0" = self.by-version."lolex"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sinon" ];
  };
  "sinon" = self.by-version."sinon"."1.12.1";
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
  by-spec."slide"."~1.1.4" =
    self.by-version."slide"."1.1.6";
  by-spec."slide"."~1.1.5" =
    self.by-version."slide"."1.1.6";
  by-spec."slide"."~1.1.6" =
    self.by-version."slide"."1.1.6";
  by-spec."sloc"."*" =
    self.by-version."sloc"."0.1.7";
  by-version."sloc"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "sloc-0.1.7";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sloc/-/sloc-0.1.7.tgz";
        name = "sloc-0.1.7.tgz";
        sha1 = "57dee8c946d54cea5188b70cd6549a22e0615679";
      })
    ];
    buildInputs =
      (self.nativeDeps."sloc" or []);
    deps = {
      "commander-2.3.0" = self.by-version."commander"."2.3.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "cli-table-0.3.1" = self.by-version."cli-table"."0.3.1";
      "readdirp-1.1.0" = self.by-version."readdirp"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sloc" ];
  };
  "sloc" = self.by-version."sloc"."0.1.7";
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
  by-spec."socket.io"."~0.9.17" =
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
    self.by-version."sockjs"."0.3.11";
  by-version."sockjs"."0.3.11" = lib.makeOverridable self.buildNodePackage {
    name = "sockjs-0.3.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sockjs/-/sockjs-0.3.11.tgz";
        name = "sockjs-0.3.11.tgz";
        sha1 = "936d84d00f5bfce82f939aec9a7e1c9b8b39fb17";
      })
    ];
    buildInputs =
      (self.nativeDeps."sockjs" or []);
    deps = {
      "faye-websocket-0.8.1" = self.by-version."faye-websocket"."0.8.1";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sockjs" ];
  };
  "sockjs" = self.by-version."sockjs"."0.3.11";
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
  by-spec."source-map"."^0.1.x" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.30" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.31" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.33" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.37" =
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
  by-spec."speedometer"."^0.1.2" =
    self.by-version."speedometer"."0.1.3";
  by-version."speedometer"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "speedometer-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/speedometer/-/speedometer-0.1.3.tgz";
        name = "speedometer-0.1.3.tgz";
        sha1 = "90a4540e5efe50811b43f6308235c23555262047";
      })
    ];
    buildInputs =
      (self.nativeDeps."speedometer" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "speedometer" ];
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
    self.by-version."stackdriver-statsd-backend"."0.2.3";
  by-version."stackdriver-statsd-backend"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "stackdriver-statsd-backend-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stackdriver-statsd-backend/-/stackdriver-statsd-backend-0.2.3.tgz";
        name = "stackdriver-statsd-backend-0.2.3.tgz";
        sha1 = "6ffead71e5655d4d787c39da8d1c9eaaa59c91d7";
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
  "stackdriver-statsd-backend" = self.by-version."stackdriver-statsd-backend"."0.2.3";
  by-spec."static-favicon"."1.0.2" =
    self.by-version."static-favicon"."1.0.2";
  by-version."static-favicon"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "static-favicon-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/static-favicon/-/static-favicon-1.0.2.tgz";
        name = "static-favicon-1.0.2.tgz";
        sha1 = "7c15920dda2bf33f414b0e60aebbd65cdd2a1d2f";
      })
    ];
    buildInputs =
      (self.nativeDeps."static-favicon" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "static-favicon" ];
  };
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
  by-spec."stream-browserify"."~0.1.0" =
    self.by-version."stream-browserify"."0.1.3";
  by-version."stream-browserify"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "stream-browserify-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-browserify/-/stream-browserify-0.1.3.tgz";
        name = "stream-browserify-0.1.3.tgz";
        sha1 = "95cf1b369772e27adaf46352265152689c6c4be9";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-browserify" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "process-0.5.2" = self.by-version."process"."0.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-browserify" ];
  };
  by-spec."stream-combiner"."~0.0.2" =
    self.by-version."stream-combiner"."0.0.4";
  by-version."stream-combiner"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "stream-combiner-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz";
        name = "stream-combiner-0.0.4.tgz";
        sha1 = "4d5e433c185261dde623ca3f44c586bcf5c4ad14";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-combiner" or []);
    deps = {
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-combiner" ];
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
  by-spec."string2compact"."^1.1.1" =
    self.by-version."string2compact"."1.2.0";
  by-version."string2compact"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "string2compact-1.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string2compact/-/string2compact-1.2.0.tgz";
        name = "string2compact-1.2.0.tgz";
        sha1 = "ecf1fcd84c9f8fc0562f818b06422f60f588b01e";
      })
    ];
    buildInputs =
      (self.nativeDeps."string2compact" or []);
    deps = {
      "addr-to-ip-port-1.4.0" = self.by-version."addr-to-ip-port"."1.4.0";
      "ipaddr.js-0.1.6" = self.by-version."ipaddr.js"."0.1.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "string2compact" ];
  };
  by-spec."string_decoder"."~0.0.0" =
    self.by-version."string_decoder"."0.0.1";
  by-version."string_decoder"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "string_decoder-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.0.1.tgz";
        name = "string_decoder-0.0.1.tgz";
        sha1 = "f5472d0a8d1650ec823752d24e6fd627b39bf141";
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
    self.by-version."stylus"."0.49.3";
  by-version."stylus"."0.49.3" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.49.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.49.3.tgz";
        name = "stylus-0.49.3.tgz";
        sha1 = "1fbdabe479ed460872c71a6252a67f95040ba511";
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
  "stylus" = self.by-version."stylus"."0.49.3";
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
  by-spec."stylus"."0.45.x" =
    self.by-version."stylus"."0.45.1";
  by-version."stylus"."0.45.1" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.45.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.45.1.tgz";
        name = "stylus-0.45.1.tgz";
        sha1 = "ef69f62c984a480adc0c9d4aaafb2382a389e453";
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
  by-spec."superagent"."~0.21.0" =
    self.by-version."superagent"."0.21.0";
  by-version."superagent"."0.21.0" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.21.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.21.0.tgz";
        name = "superagent-0.21.0.tgz";
        sha1 = "fb15027984751ee7152200e6cd21cd6e19a5de87";
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
      "debug-2.1.0" = self.by-version."debug"."2.1.0";
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
    self.by-version."supertest"."0.15.0";
  by-version."supertest"."0.15.0" = lib.makeOverridable self.buildNodePackage {
    name = "supertest-0.15.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supertest/-/supertest-0.15.0.tgz";
        name = "supertest-0.15.0.tgz";
        sha1 = "86118695de4be58869b3ee94c45e1d084ca7fac5";
      })
    ];
    buildInputs =
      (self.nativeDeps."supertest" or []);
    deps = {
      "superagent-0.21.0" = self.by-version."superagent"."0.21.0";
      "methods-1.1.0" = self.by-version."methods"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "supertest" ];
  };
  "supertest" = self.by-version."supertest"."0.15.0";
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
    self.by-version."syntax-error"."1.1.2";
  by-version."syntax-error"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "syntax-error-1.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/syntax-error/-/syntax-error-1.1.2.tgz";
        name = "syntax-error-1.1.2.tgz";
        sha1 = "660f025b170b7eb944efc2a889d451312bcef451";
      })
    ];
    buildInputs =
      (self.nativeDeps."syntax-error" or []);
    deps = {
      "acorn-0.9.0" = self.by-version."acorn"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "syntax-error" ];
  };
  by-spec."syntax-error"."~0.0.0" =
    self.by-version."syntax-error"."0.0.1";
  by-version."syntax-error"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "syntax-error-0.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/syntax-error/-/syntax-error-0.0.1.tgz";
        name = "syntax-error-0.0.1.tgz";
        sha1 = "019d075348cd8c5b79f0603c73e53891a7c5235d";
      })
    ];
    buildInputs =
      (self.nativeDeps."syntax-error" or []);
    deps = {
      "esprima-0.9.9" = self.by-version."esprima"."0.9.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "syntax-error" ];
  };
  by-spec."syntax-error"."~0.1.0" =
    self.by-version."syntax-error"."0.1.0";
  by-version."syntax-error"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "syntax-error-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/syntax-error/-/syntax-error-0.1.0.tgz";
        name = "syntax-error-0.1.0.tgz";
        sha1 = "8cb515e730fe4f19d3a887035f8630e6494aac65";
      })
    ];
    buildInputs =
      (self.nativeDeps."syntax-error" or []);
    deps = {
      "esprima-six-0.0.3" = self.by-version."esprima-six"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "syntax-error" ];
  };
  by-spec."syntax-error"."~1.1.0" =
    self.by-version."syntax-error"."1.1.2";
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
    self.by-version."tar"."1.0.3";
  by-version."tar"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "tar-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-1.0.3.tgz";
        name = "tar-1.0.3.tgz";
        sha1 = "15bcdab244fa4add44e4244a0176edb8aa9a2b44";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-1.0.3" = self.by-version."fstream"."1.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  "tar" = self.by-version."tar"."1.0.3";
  by-spec."tar"."0" =
    self.by-version."tar"."0.1.20";
  by-version."tar"."0.1.20" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.20";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.20.tgz";
        name = "tar-0.1.20.tgz";
        sha1 = "42940bae5b5f22c74483699126f9f3f27449cb13";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
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
  by-spec."tar"."1.0.2" =
    self.by-version."tar"."1.0.2";
  by-version."tar"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "tar-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-1.0.2.tgz";
        name = "tar-1.0.2.tgz";
        sha1 = "8b0f6740f9946259de26a3ed9c9a22890dff023f";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-1.0.3" = self.by-version."fstream"."1.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  by-spec."tar"."^1.0.0" =
    self.by-version."tar"."1.0.3";
  by-spec."tar"."~0.1.17" =
    self.by-version."tar"."0.1.20";
  by-spec."tar"."~0.1.19" =
    self.by-version."tar"."0.1.20";
  by-spec."tar"."~1.0.3" =
    self.by-version."tar"."1.0.3";
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
  by-spec."tar-stream"."~1.0.0" =
    self.by-version."tar-stream"."1.0.2";
  by-version."tar-stream"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "tar-stream-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar-stream/-/tar-stream-1.0.2.tgz";
        name = "tar-stream-1.0.2.tgz";
        sha1 = "fd19b4a17900fa704f6a133e3045aead0562ab95";
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
  by-spec."thirty-two"."~0.0.1" =
    self.by-version."thirty-two"."0.0.2";
  by-version."thirty-two"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "thirty-two-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/thirty-two/-/thirty-two-0.0.2.tgz";
        name = "thirty-two-0.0.2.tgz";
        sha1 = "4253e29d8cb058f0480267c5698c0e4927e54b6a";
      })
    ];
    buildInputs =
      (self.nativeDeps."thirty-two" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "thirty-two" ];
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
  by-spec."through"."2.3.4" =
    self.by-version."through"."2.3.4";
  by-version."through"."2.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "through-2.3.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through/-/through-2.3.4.tgz";
        name = "through-2.3.4.tgz";
        sha1 = "495e40e8d8a8eaebc7c275ea88c2b8fc14c56455";
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
  by-spec."through"."~2.2.0" =
    self.by-version."through"."2.2.7";
  by-version."through"."2.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "through-2.2.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through/-/through-2.2.7.tgz";
        name = "through-2.2.7.tgz";
        sha1 = "6e8e21200191d4eb6a99f6f010df46aa1c6eb2bd";
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
  by-spec."through"."~2.2.7" =
    self.by-version."through"."2.2.7";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "xtend-2.1.2" = self.by-version."xtend"."2.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."through2"."~0.5.1" =
    self.by-version."through2"."0.5.1";
  by-spec."thunky"."^0.1.0" =
    self.by-version."thunky"."0.1.0";
  by-version."thunky"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "thunky-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/thunky/-/thunky-0.1.0.tgz";
        name = "thunky-0.1.0.tgz";
        sha1 = "bf30146824e2b6e67b0f2d7a4ac8beb26908684e";
      })
    ];
    buildInputs =
      (self.nativeDeps."thunky" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "thunky" ];
  };
  by-spec."thunky"."~0.1.0" =
    self.by-version."thunky"."0.1.0";
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
  by-spec."timers-browserify"."~1.0.1" =
    self.by-version."timers-browserify"."1.0.3";
  by-version."timers-browserify"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "timers-browserify-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timers-browserify/-/timers-browserify-1.0.3.tgz";
        name = "timers-browserify-1.0.3.tgz";
        sha1 = "ffba70c9c12eed916fd67318e629ac6f32295551";
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
    self.by-version."timezone"."0.0.38";
  by-version."timezone"."0.0.38" = lib.makeOverridable self.buildNodePackage {
    name = "timezone-0.0.38";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timezone/-/timezone-0.0.38.tgz";
        name = "timezone-0.0.38.tgz";
        sha1 = "76edf157e220a685fb9a6284ecdc860fcb9de608";
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
  "timezone" = self.by-version."timezone"."0.0.38";
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
    self.by-version."titanium"."3.4.1";
  by-version."titanium"."3.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "titanium-3.4.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/titanium/-/titanium-3.4.1.tgz";
        name = "titanium-3.4.1.tgz";
        sha1 = "af10520a20dfcacaadfde07a2572b82f2b9d3648";
      })
    ];
    buildInputs =
      (self.nativeDeps."titanium" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "fields-0.1.23" = self.by-version."fields"."0.1.23";
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
  "titanium" = self.by-version."titanium"."3.4.1";
  by-spec."tls-connect"."^0.2.2" =
    self.by-version."tls-connect"."0.2.2";
  by-version."tls-connect"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "tls-connect-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tls-connect/-/tls-connect-0.2.2.tgz";
        name = "tls-connect-0.2.2.tgz";
        sha1 = "1d88d4f4cb829a0741b6acd05d1df73e0d566fd0";
      })
    ];
    buildInputs =
      (self.nativeDeps."tls-connect" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tls-connect" ];
  };
  by-spec."tls-connect"."~0.2.0" =
    self.by-version."tls-connect"."0.2.2";
  by-spec."tls-connect"."~0.x" =
    self.by-version."tls-connect"."0.2.2";
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
  by-spec."toobusy"."*" =
    self.by-version."toobusy"."0.2.4";
  by-version."toobusy"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "toobusy-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/toobusy/-/toobusy-0.2.4.tgz";
        name = "toobusy-0.2.4.tgz";
        sha1 = "d97a3ee760b2462388e15f8526579b4b64bb193d";
      })
    ];
    buildInputs =
      (self.nativeDeps."toobusy" or []);
    deps = {
      "bindings-1.1.0" = self.by-version."bindings"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "toobusy" ];
  };
  "toobusy" = self.by-version."toobusy"."0.2.4";
  by-spec."toobusy"."~0.2.4" =
    self.by-version."toobusy"."0.2.4";
  by-spec."torrent-stream"."^0.16.2" =
    self.by-version."torrent-stream"."0.16.2";
  by-version."torrent-stream"."0.16.2" = lib.makeOverridable self.buildNodePackage {
    name = "torrent-stream-0.16.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/torrent-stream/-/torrent-stream-0.16.2.tgz";
        name = "torrent-stream-0.16.2.tgz";
        sha1 = "f6460d2e1b25371ff82f4d5391450846d78b9164";
      })
    ];
    buildInputs =
      (self.nativeDeps."torrent-stream" or []);
    deps = {
      "bitfield-0.1.0" = self.by-version."bitfield"."0.1.0";
      "bittorrent-dht-2.6.4" = self.by-version."bittorrent-dht"."2.6.4";
      "bittorrent-tracker-2.9.1" = self.by-version."bittorrent-tracker"."2.9.1";
      "bncode-0.5.3" = self.by-version."bncode"."0.5.3";
      "compact2string-1.3.0" = self.by-version."compact2string"."1.3.0";
      "end-of-stream-0.1.5" = self.by-version."end-of-stream"."0.1.5";
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "ip-0.3.2" = self.by-version."ip"."0.3.2";
      "ip-set-1.0.0" = self.by-version."ip-set"."1.0.0";
      "magnet-uri-2.0.1" = self.by-version."magnet-uri"."2.0.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "parse-torrent-1.7.0" = self.by-version."parse-torrent"."1.7.0";
      "peer-wire-swarm-0.9.2" = self.by-version."peer-wire-swarm"."0.9.2";
      "random-access-file-0.3.1" = self.by-version."random-access-file"."0.3.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "thunky-0.1.0" = self.by-version."thunky"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "torrent-stream" ];
  };
  by-spec."torrent-stream"."~0.13.3" =
    self.by-version."torrent-stream"."0.13.5";
  by-version."torrent-stream"."0.13.5" = lib.makeOverridable self.buildNodePackage {
    name = "torrent-stream-0.13.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/torrent-stream/-/torrent-stream-0.13.5.tgz";
        name = "torrent-stream-0.13.5.tgz";
        sha1 = "13127bc81f668ad4dbd26cf3e984c3dd1cd70d40";
      })
    ];
    buildInputs =
      (self.nativeDeps."torrent-stream" or []);
    deps = {
      "bitfield-0.1.0" = self.by-version."bitfield"."0.1.0";
      "bittorrent-dht-1.5.0" = self.by-version."bittorrent-dht"."1.5.0";
      "bittorrent-tracker-2.9.1" = self.by-version."bittorrent-tracker"."2.9.1";
      "bncode-0.5.3" = self.by-version."bncode"."0.5.3";
      "compact2string-1.3.0" = self.by-version."compact2string"."1.3.0";
      "end-of-stream-0.1.5" = self.by-version."end-of-stream"."0.1.5";
      "hat-0.0.3" = self.by-version."hat"."0.0.3";
      "ip-0.3.2" = self.by-version."ip"."0.3.2";
      "magnet-uri-2.0.1" = self.by-version."magnet-uri"."2.0.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "parse-torrent-1.7.0" = self.by-version."parse-torrent"."1.7.0";
      "peer-wire-swarm-0.9.2" = self.by-version."peer-wire-swarm"."0.9.2";
      "random-access-file-0.3.1" = self.by-version."random-access-file"."0.3.1";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "thunky-0.1.0" = self.by-version."thunky"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "torrent-stream" ];
  };
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
  by-spec."tough-cookie"."~0.9.15" =
    self.by-version."tough-cookie"."0.9.15";
  by-version."tough-cookie"."0.9.15" = lib.makeOverridable self.buildNodePackage {
    name = "tough-cookie-0.9.15";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.9.15.tgz";
        name = "tough-cookie-0.9.15.tgz";
        sha1 = "75617ac347e3659052b0350131885829677399f6";
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
      "commander-2.5.0" = self.by-version."commander"."2.5.0";
      "glob-4.2.2" = self.by-version."glob"."4.2.2";
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
  by-spec."type-is"."~1.5.1" =
    self.by-version."type-is"."1.5.3";
  by-version."type-is"."1.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "type-is-1.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.5.3.tgz";
        name = "type-is-1.5.3.tgz";
        sha1 = "b7fb92d0abc628393f10dd260932cca65fe9ff68";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.0.3" = self.by-version."mime-types"."2.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
  };
  by-spec."type-is"."~1.5.2" =
    self.by-version."type-is"."1.5.3";
  by-spec."type-is"."~1.5.3" =
    self.by-version."type-is"."1.5.3";
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
    self.by-version."typescript"."1.3.0";
  by-version."typescript"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "typescript-1.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/typescript/-/typescript-1.3.0.tgz";
        name = "typescript-1.3.0.tgz";
        sha1 = "b48262ac7444971b447ffc6bb56c69854eef02e1";
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
  "typescript" = self.by-version."typescript"."1.3.0";
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
  by-spec."uglify-js"."2.4.15" =
    self.by-version."uglify-js"."2.4.15";
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
  by-spec."uid-number"."0" =
    self.by-version."uid-number"."0.0.6";
  by-version."uid-number"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "uid-number-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.6.tgz";
        name = "uid-number-0.0.6.tgz";
        sha1 = "0ea10e8035e8eb5b8e4449f06da1c730663baa81";
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
  by-spec."uid-number"."0.0.6" =
    self.by-version."uid-number"."0.0.6";
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
      "mz-1.1.0" = self.by-version."mz"."1.1.0";
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
  by-spec."uid2"."~0.0.2" =
    self.by-version."uid2"."0.0.3";
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
  by-spec."umd"."~2.0.0" =
    self.by-version."umd"."2.0.0";
  by-version."umd"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "umd-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/umd/-/umd-2.0.0.tgz";
        name = "umd-2.0.0.tgz";
        sha1 = "749683b0d514728ae0e1b6195f5774afc0ad4f8f";
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
  by-spec."underscore"."1.2.1" =
    self.by-version."underscore"."1.2.1";
  by-version."underscore"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.2.1.tgz";
        name = "underscore-1.2.1.tgz";
        sha1 = "fc5c6b0765673d92a2d4ac8b4dc0aa88702e2bd4";
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
  by-spec."underscore"."1.7.0" =
    self.by-version."underscore"."1.7.0";
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
    self.by-version."ungit"."0.8.4";
  by-version."ungit"."0.8.4" = lib.makeOverridable self.buildNodePackage {
    name = "ungit-0.8.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ungit/-/ungit-0.8.4.tgz";
        name = "ungit-0.8.4.tgz";
        sha1 = "3956812e8f2005415d351a710350f88b38c2d99a";
      })
    ];
    buildInputs =
      (self.nativeDeps."ungit" or []);
    deps = {
      "express-4.10.4" = self.by-version."express"."4.10.4";
      "superagent-0.21.0" = self.by-version."superagent"."0.21.0";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "temp-0.8.1" = self.by-version."temp"."0.8.1";
      "socket.io-0.9.17" = self.by-version."socket.io"."0.9.17";
      "moment-2.8.4" = self.by-version."moment"."2.8.4";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "rc-0.5.4" = self.by-version."rc"."0.5.4";
      "uuid-2.0.1" = self.by-version."uuid"."2.0.1";
      "winston-0.8.3" = self.by-version."winston"."0.8.3";
      "passport-0.2.1" = self.by-version."passport"."0.2.1";
      "passport-local-1.0.0" = self.by-version."passport-local"."1.0.0";
      "semver-4.1.0" = self.by-version."semver"."4.1.0";
      "forever-monitor-1.1.0" = self.by-version."forever-monitor"."1.1.0";
      "open-0.0.5" = self.by-version."open"."0.0.5";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "crossroads-0.12.0" = self.by-version."crossroads"."0.12.0";
      "signals-1.0.0" = self.by-version."signals"."1.0.0";
      "hasher-1.2.0" = self.by-version."hasher"."1.2.0";
      "blueimp-md5-1.1.0" = self.by-version."blueimp-md5"."1.1.0";
      "color-0.7.3" = self.by-version."color"."0.7.3";
      "keen.io-0.1.3" = self.by-version."keen.io"."0.1.3";
      "getmac-1.0.6" = self.by-version."getmac"."1.0.6";
      "deep-extend-0.3.2" = self.by-version."deep-extend"."0.3.2";
      "raven-0.7.2" = self.by-version."raven"."0.7.2";
      "knockout-3.2.0" = self.by-version."knockout"."3.2.0";
      "npm-registry-client-4.0.4" = self.by-version."npm-registry-client"."4.0.4";
      "npmconf-2.1.1" = self.by-version."npmconf"."2.1.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "body-parser-1.9.3" = self.by-version."body-parser"."1.9.3";
      "cookie-parser-1.3.3" = self.by-version."cookie-parser"."1.3.3";
      "express-session-1.9.2" = self.by-version."express-session"."1.9.2";
      "serve-static-1.7.1" = self.by-version."serve-static"."1.7.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ungit" ];
  };
  "ungit" = self.by-version."ungit"."0.8.4";
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
  by-spec."unorm"."1.3.3" =
    self.by-version."unorm"."1.3.3";
  by-version."unorm"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "unorm-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/unorm/-/unorm-1.3.3.tgz";
        name = "unorm-1.3.3.tgz";
        sha1 = "16a8772671ebd6f7cde6f8c5e49bb60ac47dba93";
      })
    ];
    buildInputs =
      (self.nativeDeps."unorm" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "unorm" ];
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
      "request-2.49.0" = self.by-version."request"."2.49.0";
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
  by-spec."url"."~0.7.9" =
    self.by-version."url"."0.7.9";
  by-version."url"."0.7.9" = lib.makeOverridable self.buildNodePackage {
    name = "url-0.7.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/url/-/url-0.7.9.tgz";
        name = "url-0.7.9.tgz";
        sha1 = "1959b1a8b361fc017b59513a7c7fa9827f5e4ed0";
      })
    ];
    buildInputs =
      (self.nativeDeps."url" or []);
    deps = {
      "querystring-0.1.0" = self.by-version."querystring"."0.1.0";
      "punycode-1.0.0" = self.by-version."punycode"."1.0.0";
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
  by-spec."util-deprecate"."1.0.0" =
    self.by-version."util-deprecate"."1.0.0";
  by-version."util-deprecate"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "util-deprecate-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.0.tgz";
        name = "util-deprecate-1.0.0.tgz";
        sha1 = "3007af012c140eae26de05576ec22785cac3abf2";
      })
    ];
    buildInputs =
      (self.nativeDeps."util-deprecate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "util-deprecate" ];
  };
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
  by-spec."uuid"."~2.0.1" =
    self.by-version."uuid"."2.0.1";
  by-version."uuid"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "uuid-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uuid/-/uuid-2.0.1.tgz";
        name = "uuid-2.0.1.tgz";
        sha1 = "c2a30dedb3e535d72ccf82e343941a50ba8533ac";
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
    self.by-version."v8flags"."1.0.5";
  by-version."v8flags"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "v8flags-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/v8flags/-/v8flags-1.0.5.tgz";
        name = "v8flags-1.0.5.tgz";
        sha1 = "d352362031d3286bcd906da45fe27a3b760e38e5";
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
  by-spec."validator"."^2.1.0" =
    self.by-version."validator"."2.1.0";
  by-version."validator"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "validator-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/validator/-/validator-2.1.0.tgz";
        name = "validator-2.1.0.tgz";
        sha1 = "63276570def208adcf1c032c1f4e6a17d2bd8d8b";
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
  by-spec."vhost"."1.0.0" =
    self.by-version."vhost"."1.0.0";
  by-version."vhost"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "vhost-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vhost/-/vhost-1.0.0.tgz";
        name = "vhost-1.0.0.tgz";
        sha1 = "654513f289a4f898aab745bbd633e40180c9c4c0";
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
    self.by-version."vinyl"."0.4.5";
  by-version."vinyl"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "vinyl-0.4.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vinyl/-/vinyl-0.4.5.tgz";
        name = "vinyl-0.4.5.tgz";
        sha1 = "b1015e63bbd350d5f90e6c26b3a2e628294da8e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."vinyl" or []);
    deps = {
      "clone-0.1.18" = self.by-version."clone"."0.1.18";
      "clone-stats-0.0.1" = self.by-version."clone-stats"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vinyl" ];
  };
  by-spec."vinyl-fs"."^0.3.0" =
    self.by-version."vinyl-fs"."0.3.13";
  by-version."vinyl-fs"."0.3.13" = lib.makeOverridable self.buildNodePackage {
    name = "vinyl-fs-0.3.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vinyl-fs/-/vinyl-fs-0.3.13.tgz";
        name = "vinyl-fs-0.3.13.tgz";
        sha1 = "3d384c5b3032e356cd388023e3a085303382ac23";
      })
    ];
    buildInputs =
      (self.nativeDeps."vinyl-fs" or []);
    deps = {
      "defaults-1.0.0" = self.by-version."defaults"."1.0.0";
      "glob-stream-3.1.17" = self.by-version."glob-stream"."3.1.17";
      "glob-watcher-0.0.6" = self.by-version."glob-watcher"."0.0.6";
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "strip-bom-1.0.0" = self.by-version."strip-bom"."1.0.0";
      "through2-0.6.3" = self.by-version."through2"."0.6.3";
      "vinyl-0.4.5" = self.by-version."vinyl"."0.4.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "vinyl-fs" ];
  };
  by-spec."vinyl-fs"."^0.3.3" =
    self.by-version."vinyl-fs"."0.3.13";
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
    self.by-version."vows"."0.8.1";
  by-version."vows"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "vows-0.8.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vows/-/vows-0.8.1.tgz";
        name = "vows-0.8.1.tgz";
        sha1 = "e09e988ce594ca05a08d72abcca34e88db559131";
      })
    ];
    buildInputs =
      (self.nativeDeps."vows" or []);
    deps = {
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "glob-4.0.6" = self.by-version."glob"."4.0.6";
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
  by-spec."watch"."~0.13.0" =
    self.by-version."watch"."0.13.0";
  by-version."watch"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "watch-0.13.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.13.0.tgz";
        name = "watch-0.13.0.tgz";
        sha1 = "fcc6d2b3f0e8c73482eb54239a19fd5bcf9a753c";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch" or []);
    deps = {
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
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
    self.by-version."wd"."0.3.11";
  by-version."wd"."0.3.11" = lib.makeOverridable self.buildNodePackage {
    name = "wd-0.3.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wd/-/wd-0.3.11.tgz";
        name = "wd-0.3.11.tgz";
        sha1 = "522716c79a7a10e781acbb2c6cafe588f701fcc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."wd" or []);
    deps = {
      "archiver-0.12.0" = self.by-version."archiver"."0.12.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "request-2.46.0" = self.by-version."request"."2.46.0";
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
      "phantomjs-1.9.12" = self.by-version."phantomjs"."1.9.12";
      "tmp-0.0.24" = self.by-version."tmp"."0.0.24";
      "follow-redirects-0.0.3" = self.by-version."follow-redirects"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "webdrvr" ];
  };
  "webdrvr" = self.by-version."webdrvr"."2.43.0-0";
  by-spec."websocket-driver".">=0.3.6" =
    self.by-version."websocket-driver"."0.4.0";
  by-version."websocket-driver"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "websocket-driver-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.4.0.tgz";
        name = "websocket-driver-0.4.0.tgz";
        sha1 = "71fa992e5d41c2cc5e290420687d0601efd06b7a";
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
  by-spec."websocket-driver".">=0.4.0" =
    self.by-version."websocket-driver"."0.4.0";
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
    self.by-version."which"."1.0.7";
  by-version."which"."1.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.7";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.7.tgz";
        name = "which-1.0.7.tgz";
        sha1 = "853133f40e5bd2783e51a06774959455cc8ee865";
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
    self.by-version."which"."1.0.7";
  by-spec."which"."~1.0.5" =
    self.by-version."which"."1.0.7";
  by-spec."which"."~1.0.7" =
    self.by-version."which"."1.0.7";
  by-spec."windows-no-runnable"."~0.0.6" =
    self.by-version."windows-no-runnable"."0.0.6";
  by-version."windows-no-runnable"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "windows-no-runnable-0.0.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/windows-no-runnable/-/windows-no-runnable-0.0.6.tgz";
        name = "windows-no-runnable-0.0.6.tgz";
        sha1 = "91e5129088330a0fe248520cee12d1ad6bb4ddfb";
      })
    ];
    buildInputs =
      (self.nativeDeps."windows-no-runnable" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "windows-no-runnable" ];
  };
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
    self.by-version."winston"."0.8.3";
  by-version."winston"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.8.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.8.3.tgz";
        name = "winston-0.8.3.tgz";
        sha1 = "64b6abf4cd01adcaefd5009393b1d8e8bec19db0";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "isstream-0.1.0" = self.by-version."isstream"."0.1.0";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  "winston" = self.by-version."winston"."0.8.3";
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
    self.by-version."winston"."0.8.3";
  by-spec."winston"."~0.8.1" =
    self.by-version."winston"."0.8.3";
  by-spec."winston"."~0.8.3" =
    self.by-version."winston"."0.8.3";
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
  by-spec."with"."~4.0.0" =
    self.by-version."with"."4.0.0";
  by-version."with"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "with-4.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-4.0.0.tgz";
        name = "with-4.0.0.tgz";
        sha1 = "7a78d6642d9b72960a71d1c0c45fd6dd1b878dc7";
      })
    ];
    buildInputs =
      (self.nativeDeps."with" or []);
    deps = {
      "acorn-0.8.0" = self.by-version."acorn"."0.8.0";
      "acorn-globals-1.0.1" = self.by-version."acorn-globals"."1.0.1";
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
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
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
      "nan-1.4.1" = self.by-version."nan"."1.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "x509" ];
  };
  "x509" = self.by-version."x509"."0.1.4";
  by-spec."xcode"."0.6.7" =
    self.by-version."xcode"."0.6.7";
  by-version."xcode"."0.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "xcode-0.6.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xcode/-/xcode-0.6.7.tgz";
        name = "xcode-0.6.7.tgz";
        sha1 = "df11a8615e43dfa397cbf593b0fd14ebeadf4e7a";
      })
    ];
    buildInputs =
      (self.nativeDeps."xcode" or []);
    deps = {
      "pegjs-0.6.2" = self.by-version."pegjs"."0.6.2";
      "node-uuid-1.3.3" = self.by-version."node-uuid"."1.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xcode" ];
  };
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
      "xmlbuilder-2.4.5" = self.by-version."xmlbuilder"."2.4.5";
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
  by-spec."xmlbuilder"."0.4.x" =
    self.by-version."xmlbuilder"."0.4.3";
  by-version."xmlbuilder"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-0.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.3.tgz";
        name = "xmlbuilder-0.4.3.tgz";
        sha1 = "c4614ba74e0ad196e609c9272cd9e1ddb28a8a58";
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
  by-spec."xmlbuilder"."2.2.1" =
    self.by-version."xmlbuilder"."2.2.1";
  by-version."xmlbuilder"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-2.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-2.2.1.tgz";
        name = "xmlbuilder-2.2.1.tgz";
        sha1 = "9326430f130d87435d4c4086643aa2926e105a32";
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
  by-spec."xmlbuilder".">=1.0.0" =
    self.by-version."xmlbuilder"."2.4.5";
  by-version."xmlbuilder"."2.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-2.4.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-2.4.5.tgz";
        name = "xmlbuilder-2.4.5.tgz";
        sha1 = "0c1c27c8904162cc7f2572ab51cc2ac466007102";
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
  by-spec."xmldom"."0.1.x" =
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
  by-spec."xmldom"."~0.1.16" =
    self.by-version."xmldom"."0.1.19";
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
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
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
  by-spec."zlib-browserify"."~0.0.3" =
    self.by-version."zlib-browserify"."0.0.3";
}
