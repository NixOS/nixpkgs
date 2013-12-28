{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."CSSselect"."0.x" =
    self.by-version."CSSselect"."0.4.0";
  by-version."CSSselect"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "CSSselect-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.4.0.tgz";
        name = "CSSselect-0.4.0.tgz";
        sha1 = "0ddaecd7d157f482d101dfbe154d3accd9166331";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSselect" or []);
    deps = [
      self.by-version."CSSwhat"."0.4.1"
      self.by-version."domutils"."1.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSselect" ];
  };
  by-spec."CSSwhat"."0.4" =
    self.by-version."CSSwhat"."0.4.1";
  by-version."CSSwhat"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "CSSwhat-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.1.tgz";
        name = "CSSwhat-0.4.1.tgz";
        sha1 = "fe6580461b2a3ad550d2a7785a051234974dfca7";
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
  by-spec."StringScanner"."~0.0.3" =
    self.by-version."StringScanner"."0.0.3";
  by-version."StringScanner"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "StringScanner-0.0.3";
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
    name = "abbrev-1.0.4";
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
  by-spec."active-x-obfuscator"."0.0.1" =
    self.by-version."active-x-obfuscator"."0.0.1";
  by-version."active-x-obfuscator"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "active-x-obfuscator-0.0.1";
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
    self.by-version."addressparser"."0.2.0";
  by-version."addressparser"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "addressparser-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/addressparser/-/addressparser-0.2.0.tgz";
        name = "addressparser-0.2.0.tgz";
        sha1 = "853383313b7b60259ba4558ef1c0bc30efac08fc";
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
    name = "adm-zip-0.2.1";
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
    self.by-version."adm-zip"."0.4.3";
  by-version."adm-zip"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "adm-zip-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.4.3.tgz";
        name = "adm-zip-0.4.3.tgz";
        sha1 = "28d6a3809abb7845a0ffa38f9fff455c2c6f6f6c";
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
    self.by-version."almond"."0.2.7";
  by-version."almond"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "almond-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/almond/-/almond-0.2.7.tgz";
        name = "almond-0.2.7.tgz";
        sha1 = "9cda2385a3198cbd8fea8e0c6edc79d5a2c354c2";
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
  "almond" = self.by-version."almond"."0.2.7";
  by-spec."amdefine"."*" =
    self.by-version."amdefine"."0.1.0";
  by-version."amdefine"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "amdefine-0.1.0";
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
    name = "ansi-remover-0.0.2";
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
    name = "ansi-styles-0.1.2";
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
    name = "ansi-styles-0.2.0";
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
    name = "ansi-styles-1.0.0";
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
    name = "ansicolors-0.2.1";
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
    name = "ansicolors-0.3.2";
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
    name = "ansistyles-0.1.3";
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
  by-spec."apparatus".">= 0.0.4" =
    self.by-version."apparatus"."0.0.8";
  by-version."apparatus"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "apparatus-0.0.8";
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
  by-spec."archiver"."~0.4.10" =
    self.by-version."archiver"."0.4.10";
  by-version."archiver"."0.4.10" = lib.makeOverridable self.buildNodePackage {
    name = "archiver-0.4.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archiver/-/archiver-0.4.10.tgz";
        name = "archiver-0.4.10.tgz";
        sha1 = "df0feac8f1d1295e5eceb3a205559072d21f4747";
      })
    ];
    buildInputs =
      (self.nativeDeps."archiver" or []);
    deps = [
      self.by-version."readable-stream"."1.0.17"
      self.by-version."iconv-lite"."0.2.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "archiver" ];
  };
  by-spec."archy"."0" =
    self.by-version."archy"."0.0.2";
  by-version."archy"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "archy-0.0.2";
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
    name = "argparse-0.1.15";
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
  by-spec."ascli"."*" =
    self.by-version."ascli"."0.3.0";
  by-version."ascli"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "ascli-0.3.0";
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
    name = "asn1-0.1.11";
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
    self.by-version."assert"."1.0.3";
  by-version."assert"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "assert-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert/-/assert-1.0.3.tgz";
        name = "assert-1.0.3.tgz";
        sha1 = "b4876fe43cd32fa93679f49e082e5c47e0e42db1";
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
  "assert" = self.by-version."assert"."1.0.3";
  by-spec."assert-plus"."0.1.2" =
    self.by-version."assert-plus"."0.1.2";
  by-version."assert-plus"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "assert-plus-0.1.2";
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
    name = "assertion-error-1.0.0";
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
  by-spec."async"."*" =
    self.by-version."async"."0.2.9";
  by-version."async"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
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
  "async" = self.by-version."async"."0.2.9";
  by-spec."async"."0.1.15" =
    self.by-version."async"."0.1.15";
  by-version."async"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.1.15";
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
    name = "async-0.1.22";
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
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.9";
  by-spec."async"."~0.1.22" =
    self.by-version."async"."0.1.22";
  by-spec."async"."~0.2.6" =
    self.by-version."async"."0.2.9";
  by-spec."async"."~0.2.7" =
    self.by-version."async"."0.2.9";
  by-spec."async"."~0.2.8" =
    self.by-version."async"."0.2.9";
  by-spec."async"."~0.2.9" =
    self.by-version."async"."0.2.9";
  by-spec."aws-sdk"."*" =
    self.by-version."aws-sdk"."2.0.0-rc4";
  by-version."aws-sdk"."2.0.0-rc4" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-2.0.0-rc4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-2.0.0-rc4.tgz";
        name = "aws-sdk-2.0.0-rc4.tgz";
        sha1 = "21c23ef7c162f7ec8eed36cef57e3425b0814e8d";
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
  "aws-sdk" = self.by-version."aws-sdk"."2.0.0-rc4";
  by-spec."aws-sdk".">=1.2.0 <2" =
    self.by-version."aws-sdk"."1.16.0";
  by-version."aws-sdk"."1.16.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-1.16.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-1.16.0.tgz";
        name = "aws-sdk-1.16.0.tgz";
        sha1 = "07a150d6009c2681d67b10faf9b356ddb70da952";
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
    name = "aws-sign-0.2.0";
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
    name = "aws-sign-0.3.0";
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
    name = "aws-sign2-0.5.0";
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
    self.by-version."backbone"."1.1.0";
  by-version."backbone"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "backbone-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backbone/-/backbone-1.1.0.tgz";
        name = "backbone-1.1.0.tgz";
        sha1 = "a3c845ea707dc210aa12b0dc16fceca4bbc18a3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."backbone" or []);
    deps = [
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "backbone" ];
  };
  "backbone" = self.by-version."backbone"."1.1.0";
  by-spec."backoff"."2.1.0" =
    self.by-version."backoff"."2.1.0";
  by-version."backoff"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "backoff-2.1.0";
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
  by-spec."base64id"."0.1.0" =
    self.by-version."base64id"."0.1.0";
  by-version."base64id"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "base64id-0.1.0";
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
  by-spec."batch"."0.5.0" =
    self.by-version."batch"."0.5.0";
  by-version."batch"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "batch-0.5.0";
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
    name = "bcrypt-0.7.7";
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
    name = "binary-0.3.0";
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
    name = "bindings-1.1.1";
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
    name = "bindings-1.0.0";
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
    name = "block-stream-0.0.7";
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
    name = "blueimp-md5-1.1.0";
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
  by-spec."boom"."0.3.x" =
    self.by-version."boom"."0.3.8";
  by-version."boom"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.3.8";
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
    name = "boom-0.4.2";
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
      self.by-version."bower-logger"."0.2.1"
      self.by-version."bower-registry-client"."0.1.6"
      self.by-version."cardinal"."0.4.3"
      self.by-version."chalk"."0.2.1"
      self.by-version."chmodr"."0.1.0"
      self.by-version."decompress-zip"."0.0.3"
      self.by-version."fstream"."0.1.25"
      self.by-version."fstream-ignore"."0.0.7"
      self.by-version."glob"."3.2.7"
      self.by-version."graceful-fs"."2.0.1"
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
      self.by-version."rimraf"."2.2.5"
      self.by-version."semver"."2.1.0"
      self.by-version."stringify-object"."0.1.7"
      self.by-version."sudo-block"."0.2.1"
      self.by-version."tar"."0.1.19"
      self.by-version."tmp"."0.0.23"
      self.by-version."update-notifier"."0.1.7"
      self.by-version."which"."1.0.5"
      self.by-version."p-throttler"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower" ];
  };
  "bower" = self.by-version."bower"."1.2.8";
  by-spec."bower".">=0.9.0" =
    self.by-version."bower"."1.2.8";
  by-spec."bower"."~1.2.0" =
    self.by-version."bower"."1.2.8";
  by-spec."bower-config"."~0.4.3" =
    self.by-version."bower-config"."0.4.5";
  by-version."bower-config"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "bower-config-0.4.5";
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
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."mout"."0.6.0"
      self.by-version."optimist"."0.6.0"
      self.by-version."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  by-spec."bower-config"."~0.5.0" =
    self.by-version."bower-config"."0.5.0";
  by-version."bower-config"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-config-0.5.0";
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
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."mout"."0.6.0"
      self.by-version."optimist"."0.6.0"
      self.by-version."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  by-spec."bower-endpoint-parser"."~0.2.0" =
    self.by-version."bower-endpoint-parser"."0.2.1";
  by-version."bower-endpoint-parser"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-endpoint-parser-0.2.1";
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
  by-spec."bower-json"."~0.4.0" =
    self.by-version."bower-json"."0.4.0";
  by-version."bower-json"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-json-0.4.0";
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
      self.by-version."deep-extend"."0.2.6"
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."intersect"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-json" ];
  };
  by-spec."bower-logger"."~0.2.1" =
    self.by-version."bower-logger"."0.2.1";
  by-version."bower-logger"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-logger-0.2.1";
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
  by-spec."bower-registry-client"."~0.1.4" =
    self.by-version."bower-registry-client"."0.1.6";
  by-version."bower-registry-client"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "bower-registry-client-0.1.6";
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
      self.by-version."async"."0.2.9"
      self.by-version."bower-config"."0.4.5"
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."lru-cache"."2.3.1"
      self.by-version."request"."2.27.0"
      self.by-version."request-replay"."0.2.0"
      self.by-version."rimraf"."2.2.5"
      self.by-version."mkdirp"."0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-registry-client" ];
  };
  by-spec."broadway"."0.2.9" =
    self.by-version."broadway"."0.2.9";
  by-version."broadway"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "broadway-0.2.9";
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
  by-spec."browserchannel"."*" =
    self.by-version."browserchannel"."1.0.8";
  by-version."browserchannel"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "browserchannel-1.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserchannel/-/browserchannel-1.0.8.tgz";
        name = "browserchannel-1.0.8.tgz";
        sha1 = "96da83d139d8943f5bd616c334f148bd008dbac4";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserchannel" or []);
    deps = [
      self.by-version."hat"."0.0.3"
      self.by-version."connect"."2.12.0"
      self.by-version."request"."2.30.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "browserchannel" ];
  };
  "browserchannel" = self.by-version."browserchannel"."1.0.8";
  by-spec."bson"."0.1.8" =
    self.by-version."bson"."0.1.8";
  by-version."bson"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.1.8";
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
    name = "bson-0.2.2";
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
  by-spec."bson"."0.2.3" =
    self.by-version."bson"."0.2.3";
  by-version."bson"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.3.tgz";
        name = "bson-0.2.3.tgz";
        sha1 = "7651d2c4ec7cb90d10b5de0ef61663273b784839";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson" or []);
    deps = [
      self.by-version."nan"."0.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  by-spec."bson"."0.2.5" =
    self.by-version."bson"."0.2.5";
  by-version."bson"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.5.tgz";
        name = "bson-0.2.5.tgz";
        sha1 = "835b266883fc91e00e440efa2a905e9ac8c6c9f9";
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
  by-spec."buffer-crc32"."0.1.1" =
    self.by-version."buffer-crc32"."0.1.1";
  by-version."buffer-crc32"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.1.1";
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
    name = "buffer-crc32-0.2.1";
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
    name = "buffers-0.1.1";
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
    self.by-version."buffertools"."2.0.0";
  by-version."buffertools"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "buffertools-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-2.0.0.tgz";
        name = "buffertools-2.0.0.tgz";
        sha1 = "925a0333a6b089e86a58c0c25c9dda8d515b25e8";
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
  "buffertools" = self.by-version."buffertools"."2.0.0";
  by-spec."buffertools".">=1.1.1 <2.0.0" =
    self.by-version."buffertools"."1.1.1";
  by-version."buffertools"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffertools-1.1.1";
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
  by-spec."bytebuffer".">=2.1 && <3" =
    self.by-version."bytebuffer"."2.1.0";
  by-version."bytebuffer"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "bytebuffer-2.1.0";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/bytebuffer/-/bytebuffer-2.1.0.tgz";
        name = "bytebuffer-2.1.0.tgz";
        sha1 = "931ae9a46fcb3868614ad3368a569dc7ce4e9ab9";
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
    name = "bytes-0.1.0";
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
    name = "bytes-0.2.0";
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
    name = "bytes-0.2.1";
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
  by-spec."bytes"."~0.2.1" =
    self.by-version."bytes"."0.2.1";
  by-spec."cardinal"."~0.4.0" =
    self.by-version."cardinal"."0.4.3";
  by-version."cardinal"."0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "cardinal-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cardinal/-/cardinal-0.4.3.tgz";
        name = "cardinal-0.4.3.tgz";
        sha1 = "7b74c3d1541002bd3d5b555048206719af91d313";
      })
    ];
    buildInputs =
      (self.nativeDeps."cardinal" or []);
    deps = [
      self.by-version."redeyed"."0.4.2"
      self.by-version."ansicolors"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cardinal" ];
  };
  by-spec."chai"."*" =
    self.by-version."chai"."1.8.1";
  by-version."chai"."1.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "chai-1.8.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chai/-/chai-1.8.1.tgz";
        name = "chai-1.8.1.tgz";
        sha1 = "cc77866d5e7ebca2bd75144b1edc370a88785f72";
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
  "chai" = self.by-version."chai"."1.8.1";
  by-spec."chainsaw"."~0.1.0" =
    self.by-version."chainsaw"."0.1.0";
  by-version."chainsaw"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "chainsaw-0.1.0";
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
  by-spec."chalk"."~0.1.1" =
    self.by-version."chalk"."0.1.1";
  by-version."chalk"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.1.1";
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
      self.by-version."has-color"."0.1.1"
      self.by-version."ansi-styles"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.2.0" =
    self.by-version."chalk"."0.2.1";
  by-version."chalk"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.2.1";
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
      self.by-version."has-color"."0.1.1"
      self.by-version."ansi-styles"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.2.1" =
    self.by-version."chalk"."0.2.1";
  by-spec."chalk"."~0.3.0" =
    self.by-version."chalk"."0.3.0";
  by-version."chalk"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.3.0";
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
      self.by-version."has-color"."0.1.1"
      self.by-version."ansi-styles"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chalk"."~0.4.0" =
    self.by-version."chalk"."0.4.0";
  by-version."chalk"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.4.0";
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
      self.by-version."has-color"."0.1.1"
      self.by-version."ansi-styles"."1.0.0"
      self.by-version."strip-ansi"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."character-parser"."1.2.0" =
    self.by-version."character-parser"."1.2.0";
  by-version."character-parser"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "character-parser-1.2.0";
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
    name = "cheerio-0.12.4";
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
      self.by-version."entities"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  by-spec."cheerio"."~0.12.1" =
    self.by-version."cheerio"."0.12.4";
  by-spec."cheerio-select"."*" =
    self.by-version."cheerio-select"."0.0.3";
  by-version."cheerio-select"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "cheerio-select-0.0.3";
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
      self.by-version."CSSselect"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio-select" ];
  };
  by-spec."child-process-close"."~0.1.1" =
    self.by-version."child-process-close"."0.1.1";
  by-version."child-process-close"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "child-process-close-0.1.1";
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
    name = "chmodr-0.1.0";
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
    self.by-version."chokidar"."0.8.1";
  by-version."chokidar"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "chokidar-0.8.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chokidar/-/chokidar-0.8.1.tgz";
        name = "chokidar-0.8.1.tgz";
        sha1 = "8ee0c99ef48420902fded73b862eac2dd75da4a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."chokidar" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chokidar" ];
  };
  by-spec."chownr"."0" =
    self.by-version."chownr"."0.0.1";
  by-version."chownr"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "chownr-0.0.1";
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
  by-spec."clean-css"."2.0.x" =
    self.by-version."clean-css"."2.0.4";
  by-version."clean-css"."2.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-2.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-2.0.4.tgz";
        name = "clean-css-2.0.4.tgz";
        sha1 = "1447e54e14d4bd0fa801f507bb32938cebe77627";
      })
    ];
    buildInputs =
      (self.nativeDeps."clean-css" or []);
    deps = [
      self.by-version."commander"."2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clean-css" ];
  };
  by-spec."clean-css"."~2.0.0" =
    self.by-version."clean-css"."2.0.4";
  by-spec."cli"."0.4.x" =
    self.by-version."cli"."0.4.5";
  by-version."cli"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "cli-0.4.5";
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
      self.by-version."glob"."3.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli" ];
  };
  by-spec."cli-color"."~0.2.2" =
    self.by-version."cli-color"."0.2.3";
  by-version."cli-color"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "cli-color-0.2.3";
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
  by-spec."cliff"."0.1.8" =
    self.by-version."cliff"."0.1.8";
  by-version."cliff"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "cliff-0.1.8";
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
  by-spec."clone"."0.1.5" =
    self.by-version."clone"."0.1.5";
  by-version."clone"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.5";
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
    name = "clone-0.1.6";
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
    name = "cmd-shim-1.1.1";
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
      self.by-version."graceful-fs"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cmd-shim" ];
  };
  by-spec."coffee-script"."*" =
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
  "coffee-script" = self.by-version."coffee-script"."1.6.3";
  by-spec."coffee-script"."1.6.3" =
    self.by-version."coffee-script"."1.6.3";
  by-spec."coffee-script".">= 0.0.1" =
    self.by-version."coffee-script"."1.6.3";
  by-spec."coffee-script".">=1.2.0" =
    self.by-version."coffee-script"."1.6.3";
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
  by-spec."coffee-script"."~1.6" =
    self.by-version."coffee-script"."1.6.3";
  by-spec."coffee-script-redux"."git+https://github.com/michaelficarra/CoffeeScriptRedux.git#9895cd1641fdf3a2424e662ab7583726bb0e35b3" =
    self.by-version."coffee-script-redux"."2.0.0-beta4";
  by-version."coffee-script-redux"."2.0.0-beta4" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-redux-2.0.0-beta4";
    src = [
      (fetchgit {
        url = "https://github.com/michaelficarra/CoffeeScriptRedux.git";
        rev = "9895cd1641fdf3a2424e662ab7583726bb0e35b3";
        sha256 = "d70e659aa7cdb50a98959dec0e2a8c916200e31cb770f04faa2ae92a55d1e66d";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script-redux" or []);
    deps = [
      self.by-version."StringScanner"."0.0.3"
      self.by-version."jedediah"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script-redux" ];
  };
  by-spec."color"."~0.4.4" =
    self.by-version."color"."0.4.4";
  by-version."color"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "color-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color/-/color-0.4.4.tgz";
        name = "color-0.4.4.tgz";
        sha1 = "f8bae8a848854616328704e64ce4a94ab336b7b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."color" or []);
    deps = [
      self.by-version."color-convert"."0.2.1"
      self.by-version."color-string"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color" ];
  };
  by-spec."color-convert"."0.2.x" =
    self.by-version."color-convert"."0.2.1";
  by-version."color-convert"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "color-convert-0.2.1";
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
    self.by-version."color-string"."0.1.2";
  by-version."color-string"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "color-string-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-string/-/color-string-0.1.2.tgz";
        name = "color-string-0.1.2.tgz";
        sha1 = "a413fb7dd137162d5d4ea784cbeb36d931ad9b4a";
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
    name = "colors-0.5.1";
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
  by-spec."colors"."0.6.0-1" =
    self.by-version."colors"."0.6.0-1";
  by-version."colors"."0.6.0-1" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.0-1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.0-1.tgz";
        name = "colors-0.6.0-1.tgz";
        sha1 = "6dbb68ceb8bc60f2b313dcc5ce1599f06d19e67a";
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
    name = "colors-0.6.2";
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
    name = "colour-0.7.1";
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
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.4";
  by-version."combined-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "combined-stream-0.0.4";
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
  by-spec."commander"."*" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.1.0";
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
  by-spec."commander"."0.6.1" =
    self.by-version."commander"."0.6.1";
  by-version."commander"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-0.6.1";
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
  by-spec."commander"."1.3.2" =
    self.by-version."commander"."1.3.2";
  by-version."commander"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "commander-1.3.2";
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
    name = "commander-2.0.0";
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
  by-spec."commander"."2.0.x" =
    self.by-version."commander"."2.0.0";
  by-spec."commander"."~0.6.1" =
    self.by-version."commander"."0.6.1";
  by-spec."config"."0.4.15" =
    self.by-version."config"."0.4.15";
  by-version."config"."0.4.15" = lib.makeOverridable self.buildNodePackage {
    name = "config-0.4.15";
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
      self.by-version."coffee-script"."1.6.3"
      self.by-version."vows"."0.7.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "config" ];
  };
  by-spec."config-chain"."~1.1.1" =
    self.by-version."config-chain"."1.1.8";
  by-version."config-chain"."1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "config-chain-1.1.8";
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
  by-spec."configstore"."~0.1.0" =
    self.by-version."configstore"."0.1.7";
  by-version."configstore"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "configstore-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/configstore/-/configstore-0.1.7.tgz";
        name = "configstore-0.1.7.tgz";
        sha1 = "57dc701bc2a51eb804d6e1733c8abb9d82a5cede";
      })
    ];
    buildInputs =
      (self.nativeDeps."configstore" or []);
    deps = [
      self.by-version."lodash"."2.4.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."js-yaml"."2.1.3"
      self.by-version."osenv"."0.0.3"
      self.by-version."graceful-fs"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "configstore" ];
  };
  by-spec."connect"."1.x" =
    self.by-version."connect"."1.9.2";
  by-version."connect"."1.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "connect-1.9.2";
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
    name = "connect-2.11.0";
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
    name = "connect-2.12.0";
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
  by-spec."connect"."2.3.x" =
    self.by-version."connect"."2.3.9";
  by-version."connect"."2.3.9" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.3.9";
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
    name = "connect-2.7.5";
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
    name = "connect-2.7.6";
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
    self.by-version."connect"."2.12.0";
  by-spec."connect"."~2.8.4" =
    self.by-version."connect"."2.8.8";
  by-version."connect"."2.8.8" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.8.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.8.8.tgz";
        name = "connect-2.8.8.tgz";
        sha1 = "b9abf8caf0bd9773cb3dea29344119872582446d";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = [
      self.by-version."qs"."0.6.5"
      self.by-version."formidable"."1.0.14"
      self.by-version."cookie-signature"."1.0.1"
      self.by-version."buffer-crc32"."0.2.1"
      self.by-version."cookie"."0.1.0"
      self.by-version."send"."0.1.4"
      self.by-version."bytes"."0.2.0"
      self.by-version."fresh"."0.2.0"
      self.by-version."pause"."0.0.1"
      self.by-version."uid2"."0.0.2"
      self.by-version."debug"."0.7.4"
      self.by-version."methods"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect-flash"."*" =
    self.by-version."connect-flash"."0.1.1";
  by-version."connect-flash"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "connect-flash-0.1.1";
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
    name = "connect-flash-0.1.0";
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
    name = "connect-jade-static-0.1.3";
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
      self.by-version."jade"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-jade-static" ];
  };
  "connect-jade-static" = self.by-version."connect-jade-static"."0.1.3";
  by-spec."connect-mongo"."*" =
    self.by-version."connect-mongo"."0.4.0";
  by-version."connect-mongo"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-mongo-0.4.0";
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
  by-spec."connection-parse"."0.0.x" =
    self.by-version."connection-parse"."0.0.7";
  by-version."connection-parse"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "connection-parse-0.0.7";
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
    name = "console-browserify-0.1.6";
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
  by-spec."constantinople"."~1.0.2" =
    self.by-version."constantinople"."1.0.2";
  by-version."constantinople"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "constantinople-1.0.2";
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
      self.by-version."uglify-js"."2.4.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "constantinople" ];
  };
  by-spec."cookie"."0.0.4" =
    self.by-version."cookie"."0.0.4";
  by-version."cookie"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.0.4";
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
    name = "cookie-0.0.5";
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
    name = "cookie-0.1.0";
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
  by-spec."cookie-jar"."~0.2.0" =
    self.by-version."cookie-jar"."0.2.0";
  by-version."cookie-jar"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-jar-0.2.0";
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
    name = "cookie-jar-0.3.0";
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
  by-spec."cookie-signature"."1.0.0" =
    self.by-version."cookie-signature"."1.0.0";
  by-version."cookie-signature"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.0";
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
    name = "cookie-signature-1.0.1";
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
  by-spec."cookiejar"."1.3.0" =
    self.by-version."cookiejar"."1.3.0";
  by-version."cookiejar"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookiejar-1.3.0";
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
    self.by-version."cookies"."0.3.8";
  by-version."cookies"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "cookies-0.3.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookies/-/cookies-0.3.8.tgz";
        name = "cookies-0.3.8.tgz";
        sha1 = "92fe50918f3d55aec4ae9d978bcddda2ada28ce9";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookies" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookies" ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.0";
  by-version."core-util-is"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "core-util-is-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.0.tgz";
        name = "core-util-is-1.0.0.tgz";
        sha1 = "740c74c400e72707b95cc75d509543f8ad7f83de";
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
    self.by-version."couch-login"."0.1.19";
  by-version."couch-login"."0.1.19" = lib.makeOverridable self.buildNodePackage {
    name = "couch-login-0.1.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/couch-login/-/couch-login-0.1.19.tgz";
        name = "couch-login-0.1.19.tgz";
        sha1 = "5c472f64670dfb43fc381d290629b223edb64afa";
      })
    ];
    buildInputs =
      (self.nativeDeps."couch-login" or []);
    deps = [
      self.by-version."request"."2.30.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "couch-login" ];
  };
  by-spec."couch-login"."~0.1.18" =
    self.by-version."couch-login"."0.1.19";
  by-spec."coveralls"."*" =
    self.by-version."coveralls"."2.6.1";
  by-version."coveralls"."2.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "coveralls-2.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coveralls/-/coveralls-2.6.1.tgz";
        name = "coveralls-2.6.1.tgz";
        sha1 = "0de635bba15fd48f4fc557ae9ac21309c013d2de";
      })
    ];
    buildInputs =
      (self.nativeDeps."coveralls" or []);
    deps = [
      self.by-version."yaml"."0.2.3"
      self.by-version."request"."2.16.2"
      self.by-version."lcov-parse"."0.0.4"
      self.by-version."log-driver"."1.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coveralls" ];
  };
  "coveralls" = self.by-version."coveralls"."2.6.1";
  by-spec."crc"."0.2.0" =
    self.by-version."crc"."0.2.0";
  by-version."crc"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "crc-0.2.0";
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
    name = "crossroads-0.12.0";
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
    name = "cryptiles-0.1.3";
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
    name = "cryptiles-0.2.2";
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
    name = "crypto-0.0.3";
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
  by-spec."css"."~1.0.8" =
    self.by-version."css"."1.0.8";
  by-version."css"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "css-1.0.8";
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
    name = "css-parse-1.0.4";
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
  by-spec."css-stringify"."1.0.5" =
    self.by-version."css-stringify"."1.0.5";
  by-version."css-stringify"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "css-stringify-1.0.5";
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
  by-spec."cssom"."0.2.x" =
    self.by-version."cssom"."0.2.5";
  by-version."cssom"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "cssom-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cssom/-/cssom-0.2.5.tgz";
        name = "cssom-0.2.5.tgz";
        sha1 = "2682709b5902e7212df529116ff788cd5b254894";
      })
    ];
    buildInputs =
      (self.nativeDeps."cssom" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cssom" ];
  };
  by-spec."ctype"."0.5.0" =
    self.by-version."ctype"."0.5.0";
  by-version."ctype"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.0";
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
    name = "ctype-0.5.2";
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
    name = "cycle-1.0.3";
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
    name = "dargs-0.1.0";
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
    name = "dateformat-1.0.2-1.2.3";
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
    name = "dateformat-1.0.7-1.2.3";
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
    name = "debug-0.7.4";
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
    name = "debug-0.5.0";
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
  by-spec."debug"."0.7.0" =
    self.by-version."debug"."0.7.0";
  by-version."debug"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.0.tgz";
        name = "debug-0.7.0.tgz";
        sha1 = "f5be05ec0434c992d79940e50b2695cfb2e01b08";
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
    name = "debuglog-0.0.2";
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
  by-spec."decompress"."~0.1.0" =
    self.by-version."decompress"."0.1.5";
  by-version."decompress"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "decompress-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decompress/-/decompress-0.1.5.tgz";
        name = "decompress-0.1.5.tgz";
        sha1 = "0925d42a2164bead83f0822a7a2b4ad02e99c76c";
      })
    ];
    buildInputs =
      (self.nativeDeps."decompress" or []);
    deps = [
      self.by-version."adm-zip"."0.4.3"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."mout"."0.6.0"
      self.by-version."rimraf"."2.2.5"
      self.by-version."stream-combiner"."0.0.4"
      self.by-version."tar"."0.1.19"
      self.by-version."temp"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "decompress" ];
  };
  by-spec."decompress-zip"."~0.0.3" =
    self.by-version."decompress-zip"."0.0.3";
  by-version."decompress-zip"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "decompress-zip-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decompress-zip/-/decompress-zip-0.0.3.tgz";
        name = "decompress-zip-0.0.3.tgz";
        sha1 = "14b174e5b6a528f0aa6c2e2157b7aa0152e7915a";
      })
    ];
    buildInputs =
      (self.nativeDeps."decompress-zip" or []);
    deps = [
      self.by-version."q"."0.9.7"
      self.by-version."mkpath"."0.1.0"
      self.by-version."binary"."0.3.0"
      self.by-version."touch"."0.0.2"
      self.by-version."readable-stream"."1.1.9"
      self.by-version."nopt"."2.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "decompress-zip" ];
  };
  by-spec."deep-eql"."0.1.3" =
    self.by-version."deep-eql"."0.1.3";
  by-version."deep-eql"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "deep-eql-0.1.3";
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
    self.by-version."deep-equal"."0.1.2";
  by-version."deep-equal"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.1.2";
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
  by-spec."deep-equal"."0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-version."deep-equal"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.0.0";
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
  by-spec."deep-extend"."~0.2.5" =
    self.by-version."deep-extend"."0.2.6";
  by-version."deep-extend"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "deep-extend-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.6.tgz";
        name = "deep-extend-0.2.6.tgz";
        sha1 = "1f767e02b46d88d0a4087affa4b11b1b0b804250";
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
  by-spec."deep-extend"."~0.2.6" =
    self.by-version."deep-extend"."0.2.6";
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "delayed-stream-0.0.5";
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
  by-spec."di"."~0.0.1" =
    self.by-version."di"."0.0.1";
  by-version."di"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "di-0.0.1";
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
    name = "diff-1.0.7";
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
    name = "diff-1.0.8";
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
    name = "director-1.1.10";
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
    name = "dkim-signer-0.1.0";
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
      self.by-version."punycode"."1.2.3"
      self.by-version."mimelib"."0.2.14"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dkim-signer" ];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.1.1";
  by-version."domelementtype"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "domelementtype-1.1.1";
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
    name = "domhandler-2.0.3";
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
    name = "domhandler-2.1.0";
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
  by-spec."domutils"."1.1" =
    self.by-version."domutils"."1.1.6";
  by-version."domutils"."1.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.1.6";
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
    name = "domutils-1.3.0";
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
  by-spec."download"."~0.1.6" =
    self.by-version."download"."0.1.7";
  by-version."download"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "download-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/download/-/download-0.1.7.tgz";
        name = "download-0.1.7.tgz";
        sha1 = "d2a941a878a6d2fdaba60588ffffadab32b788b4";
      })
    ];
    buildInputs =
      (self.nativeDeps."download" or []);
    deps = [
      self.by-version."decompress"."0.1.5"
      self.by-version."each-async"."0.1.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."request"."2.25.0"
      self.by-version."through2"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "download" ];
  };
  by-spec."dtrace-provider"."0.2.8" =
    self.by-version."dtrace-provider"."0.2.8";
  by-version."dtrace-provider"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "dtrace-provider-0.2.8";
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
    name = "duplexer-0.1.1";
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
    self.by-version."each-async"."0.1.1";
  by-version."each-async"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "each-async-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/each-async/-/each-async-0.1.1.tgz";
        name = "each-async-0.1.1.tgz";
        sha1 = "32bcef7e3cdc741d630e29846348be4ecca624ff";
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
    name = "editor-0.0.5";
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
    name = "ejs-0.8.3";
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
    name = "emitter-component-0.0.6";
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
    name = "emitter-component-1.0.0";
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
    name = "encoding-0.1.7";
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
    self.by-version."entities"."0.3.0";
  by-version."entities"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "entities-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-0.3.0.tgz";
        name = "entities-0.3.0.tgz";
        sha1 = "6ccead6010fee0c5a06f538d242792485cbfa256";
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
  by-spec."es5-ext"."~0.9.2" =
    self.by-version."es5-ext"."0.9.2";
  by-version."es5-ext"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "es5-ext-0.9.2";
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
    name = "escape-html-1.0.1";
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
  by-spec."escodegen"."*" =
    self.by-version."escodegen"."1.0.1";
  by-version."escodegen"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.0.1.tgz";
        name = "escodegen-1.0.1.tgz";
        sha1 = "84c92c4a07440271b90e6b78e620973bf721226e";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."estraverse"."1.5.0"
      self.by-version."esutils"."1.0.0"
      self.by-version."source-map"."0.1.31"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."escodegen"."0.0.23" =
    self.by-version."escodegen"."0.0.23";
  by-version."escodegen"."0.0.23" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-0.0.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-0.0.23.tgz";
        name = "escodegen-0.0.23.tgz";
        sha1 = "9acf978164368e42276571f18839c823b3a844df";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."estraverse"."0.0.4"
      self.by-version."source-map"."0.1.31"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
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
  by-spec."esprima"."~1.0.0" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima"."~1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-spec."esprima"."~1.0.4" =
    self.by-version."esprima"."1.0.4";
  by-spec."estraverse"."*" =
    self.by-version."estraverse"."1.5.0";
  by-version."estraverse"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.5.0";
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
  by-spec."estraverse"."~0.0.4" =
    self.by-version."estraverse"."0.0.4";
  by-version."estraverse"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-0.0.4";
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
  by-spec."estraverse"."~1.5.0" =
    self.by-version."estraverse"."1.5.0";
  by-spec."esutils"."~1.0.0" =
    self.by-version."esutils"."1.0.0";
  by-version."esutils"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "esutils-1.0.0";
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
    name = "event-emitter-0.2.2";
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
    name = "event-stream-0.5.3";
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
    name = "eventemitter2-0.4.12";
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
    name = "eventemitter2-0.4.13";
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
  by-spec."events.node".">= 0.4.0" =
    self.by-version."events.node"."0.4.9";
  by-version."events.node"."0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "events.node-0.4.9";
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
    name = "everyauth-0.4.5";
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
      self.by-version."oauth"."0.9.10"
      self.by-version."request"."2.9.203"
      self.by-version."connect"."2.3.9"
      self.by-version."openid"."0.5.5"
      self.by-version."xml2js"."0.4.0"
      self.by-version."node-swt"."0.1.1"
      self.by-version."node-wsfederation"."0.1.1"
      self.by-version."debug"."0.5.0"
      self.by-version."express"."3.4.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "everyauth" ];
  };
  by-spec."exit"."~0.1.1" =
    self.by-version."exit"."0.1.2";
  by-version."exit"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "exit-0.1.2";
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
  by-spec."express"."*" =
    self.by-version."express"."3.4.7";
  by-version."express"."3.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.7.tgz";
        name = "express-3.4.7.tgz";
        sha1 = "3b939c47d2aa44dfecf77d50da2123c5bd313366";
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
  "express" = self.by-version."express"."3.4.7";
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
    self.by-version."express"."3.4.7";
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
    self.by-version."express"."3.4.7";
  by-spec."express"."~3.4.4" =
    self.by-version."express"."3.4.7";
  by-spec."express-form"."*" =
    self.by-version."express-form"."0.10.1";
  by-version."express-form"."0.10.1" = lib.makeOverridable self.buildNodePackage {
    name = "express-form-0.10.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-form/-/express-form-0.10.1.tgz";
        name = "express-form-0.10.1.tgz";
        sha1 = "542f43cf276c33f8ec8836b571aa3365505609a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-form" or []);
    deps = [
      self.by-version."validator"."0.4.28"
      self.by-version."object-additions"."0.5.1"
      self.by-version."async"."0.2.9"
    ];
    peerDependencies = [
      self.by-version."express"."3.4.7"
    ];
    passthru.names = [ "express-form" ];
  };
  "express-form" = self.by-version."express-form"."0.10.1";
  by-spec."express-partials"."0.0.6" =
    self.by-version."express-partials"."0.0.6";
  by-version."express-partials"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "express-partials-0.0.6";
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
  by-spec."extend"."*" =
    self.by-version."extend"."1.2.1";
  by-version."extend"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "extend-1.2.1";
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
  by-spec."extract-opts"."~2.2.0" =
    self.by-version."extract-opts"."2.2.0";
  by-version."extract-opts"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "extract-opts-2.2.0";
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
    name = "extsprintf-1.0.0";
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
    name = "extsprintf-1.0.2";
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
    name = "eyes-0.1.8";
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
    self.by-version."faye-websocket"."0.7.1";
  by-version."faye-websocket"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.7.1.tgz";
        name = "faye-websocket-0.7.1.tgz";
        sha1 = "72fe630d122333e0f36ac453f593ed70e1cb6baa";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket" or []);
    deps = [
      self.by-version."websocket-driver"."0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  "faye-websocket" = self.by-version."faye-websocket"."0.7.1";
  by-spec."faye-websocket"."0.7.0" =
    self.by-version."faye-websocket"."0.7.0";
  by-version."faye-websocket"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.7.0";
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
      self.by-version."websocket-driver"."0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  by-spec."file-utils"."~0.1.1" =
    self.by-version."file-utils"."0.1.5";
  by-version."file-utils"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "file-utils-0.1.5";
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
      self.by-version."rimraf"."2.2.5"
      self.by-version."glob"."3.2.7"
      self.by-version."minimatch"."0.2.14"
      self.by-version."findup-sync"."0.1.2"
      self.by-version."isbinaryfile"."0.1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "file-utils" ];
  };
  by-spec."fileset"."0.1.x" =
    self.by-version."fileset"."0.1.5";
  by-version."fileset"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "fileset-0.1.5";
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
      self.by-version."glob"."3.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fileset" ];
  };
  by-spec."findit".">=1.1.0 <2.0.0" =
    self.by-version."findit"."1.1.0";
  by-version."findit"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "findit-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findit/-/findit-1.1.0.tgz";
        name = "findit-1.1.0.tgz";
        sha1 = "7104c60060f838d2298bd526b16add6ce733f9ac";
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
    self.by-version."findup"."0.1.3";
  by-version."findup"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "findup-0.1.3";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/findup/-/findup-0.1.3.tgz";
        name = "findup-0.1.3.tgz";
        sha1 = "df2b8ecf06fdaa9cc13dc4ba58bf950e3a176941";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup" or []);
    deps = [
      self.by-version."nopt"."1.0.10"
      self.by-version."colors"."0.6.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findup" ];
  };
  by-spec."findup-sync"."~0.1.0" =
    self.by-version."findup-sync"."0.1.2";
  by-version."findup-sync"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "findup-sync-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.2.tgz";
        name = "findup-sync-0.1.2.tgz";
        sha1 = "da2b96ca9f800e5a13d0a11110f490b65f62e96d";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup-sync" or []);
    deps = [
      self.by-version."glob"."3.1.21"
      self.by-version."lodash"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findup-sync" ];
  };
  by-spec."findup-sync"."~0.1.2" =
    self.by-version."findup-sync"."0.1.2";
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
    name = "follow-redirects-0.0.3";
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
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "follow-redirects" ];
  };
  by-spec."forEachAsync"."~2.2" =
    self.by-version."forEachAsync"."2.2.0";
  by-version."forEachAsync"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "forEachAsync-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forEachAsync/-/forEachAsync-2.2.0.tgz";
        name = "forEachAsync-2.2.0.tgz";
        sha1 = "093b32ce868cb69f5166dcf331fae074adc71cee";
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
  by-spec."foreach"."~2.0.1" =
    self.by-version."foreach"."2.0.4";
  by-version."foreach"."2.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "foreach-2.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/foreach/-/foreach-2.0.4.tgz";
        name = "foreach-2.0.4.tgz";
        sha1 = "cc5d0d8ae1d46cc9a555c2682f910977859935df";
      })
    ];
    buildInputs =
      (self.nativeDeps."foreach" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "foreach" ];
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
      self.by-version."optimist"."0.6.0"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."timespan"."2.3.0"
      self.by-version."watch"."0.8.0"
      self.by-version."utile"."0.2.1"
      self.by-version."winston"."0.7.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever" ];
  };
  "forever" = self.by-version."forever"."0.10.11";
  by-spec."forever-agent"."~0.2.0" =
    self.by-version."forever-agent"."0.2.0";
  by-version."forever-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.2.0";
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
    self.by-version."forever-agent"."0.5.0";
  by-version."forever-agent"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.0.tgz";
        name = "forever-agent-0.5.0.tgz";
        sha1 = "0c1647a74f3af12d76a07a99490ade7c7249c8f0";
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
    name = "forever-monitor-1.2.3";
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
    name = "forever-monitor-1.1.0";
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
  by-spec."form-data"."0.0.8" =
    self.by-version."form-data"."0.0.8";
  by-version."form-data"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.8.tgz";
        name = "form-data-0.0.8.tgz";
        sha1 = "0890cd1005c5ccecc0b9d24a88052c92442d0db5";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = [
      self.by-version."combined-stream"."0.0.4"
      self.by-version."mime"."1.2.11"
      self.by-version."async"."0.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."form-data"."~0.0.3" =
    self.by-version."form-data"."0.0.10";
  by-version."form-data"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.10";
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
      self.by-version."async"."0.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.2";
  by-version."form-data"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.1.2";
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
      self.by-version."async"."0.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."formidable"."1.0.11" =
    self.by-version."formidable"."1.0.11";
  by-version."formidable"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.11";
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
    name = "formidable-1.0.13";
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
    name = "formidable-1.0.14";
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
    name = "formidable-1.0.9";
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
    name = "fresh-0.1.0";
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
    name = "fresh-0.2.0";
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
  by-spec."fs-extra"."~0.6.1" =
    self.by-version."fs-extra"."0.6.4";
  by-version."fs-extra"."0.6.4" = lib.makeOverridable self.buildNodePackage {
    name = "fs-extra-0.6.4";
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
      self.by-version."rimraf"."2.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-extra" ];
  };
  by-spec."fs-walk"."*" =
    self.by-version."fs-walk"."0.0.1";
  by-version."fs-walk"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "fs-walk-0.0.1";
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
      self.by-version."async"."0.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-walk" ];
  };
  "fs-walk" = self.by-version."fs-walk"."0.0.1";
  by-spec."fs.extra".">=1.2.0 <2.0.0" =
    self.by-version."fs.extra"."1.2.1";
  by-version."fs.extra"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "fs.extra-1.2.1";
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
  by-spec."fstream"."0" =
    self.by-version."fstream"."0.1.25";
  by-version."fstream"."0.1.25" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.25";
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
      self.by-version."rimraf"."2.2.5"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."graceful-fs"."2.0.1"
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
    name = "fstream-ignore-0.0.7";
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
    name = "fstream-npm-0.1.6";
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
    self.by-version."generator-angular"."0.7.1";
  by-version."generator-angular"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "generator-angular-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-angular/-/generator-angular-0.7.1.tgz";
        name = "generator-angular-0.7.1.tgz";
        sha1 = "51f9faed8d7c0e9d972004101cc1c16ecd1ebf65";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-angular" or []);
    deps = [
      self.by-version."yeoman-generator"."0.13.4"
      self.by-version."chalk"."0.3.0"
      self.by-version."wiredep"."0.4.2"
    ];
    peerDependencies = [
      self.by-version."generator-karma"."0.6.0"
      self.by-version."yo"."1.0.7-pre.2"
    ];
    passthru.names = [ "generator-angular" ];
  };
  "generator-angular" = self.by-version."generator-angular"."0.7.1";
  by-spec."generator-karma"."~0.6.0" =
    self.by-version."generator-karma"."0.6.0";
  by-version."generator-karma"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "generator-karma-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-karma/-/generator-karma-0.6.0.tgz";
        name = "generator-karma-0.6.0.tgz";
        sha1 = "e89b6195c186771e8bdddde37441abb6ce07e1a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-karma" or []);
    deps = [
      self.by-version."yeoman-generator"."0.13.4"
    ];
    peerDependencies = [
      self.by-version."yo"."1.0.7-pre.2"
    ];
    passthru.names = [ "generator-karma" ];
  };
  by-spec."generator-mocha"."~0.1.1" =
    self.by-version."generator-mocha"."0.1.3";
  by-version."generator-mocha"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "generator-mocha-0.1.3";
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
      self.by-version."yo"."1.0.7-pre.2"
    ];
    passthru.names = [ "generator-mocha" ];
  };
  by-spec."generator-webapp"."*" =
    self.by-version."generator-webapp"."0.4.6";
  by-version."generator-webapp"."0.4.6" = lib.makeOverridable self.buildNodePackage {
    name = "generator-webapp-0.4.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-webapp/-/generator-webapp-0.4.6.tgz";
        name = "generator-webapp-0.4.6.tgz";
        sha1 = "6f51516b615aaf807e221a8ac713845fd680648f";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-webapp" or []);
    deps = [
      self.by-version."yeoman-generator"."0.14.2"
      self.by-version."cheerio"."0.12.4"
    ];
    peerDependencies = [
      self.by-version."yo"."1.0.7-pre.2"
      self.by-version."generator-mocha"."0.1.3"
    ];
    passthru.names = [ "generator-webapp" ];
  };
  "generator-webapp" = self.by-version."generator-webapp"."0.4.6";
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
    name = "getobject-0.1.0";
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
  by-spec."github-url-from-git"."1.1.1" =
    self.by-version."github-url-from-git"."1.1.1";
  by-version."github-url-from-git"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-git-1.1.1";
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
    name = "github-url-from-username-repo-0.0.2";
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
    self.by-version."glob"."3.2.7";
  by-version."glob"."3.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.7.tgz";
        name = "glob-3.2.7.tgz";
        sha1 = "275f39a0eee805694790924f36eac38e1db6d802";
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
    name = "glob-3.2.3";
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
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.x" =
    self.by-version."glob"."3.2.7";
  by-spec."glob".">= 3.1.4" =
    self.by-version."glob"."3.2.7";
  by-spec."glob"."~3.1.21" =
    self.by-version."glob"."3.1.21";
  by-version."glob"."3.1.21" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.1.21";
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
    self.by-version."glob"."3.2.7";
  by-spec."glob"."~3.2.1" =
    self.by-version."glob"."3.2.7";
  by-spec."glob"."~3.2.6" =
    self.by-version."glob"."3.2.7";
  by-spec."glob"."~3.2.7" =
    self.by-version."glob"."3.2.7";
  by-spec."graceful-fs"."2" =
    self.by-version."graceful-fs"."2.0.1";
  by-version."graceful-fs"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.1.tgz";
        name = "graceful-fs-2.0.1.tgz";
        sha1 = "7fd6e0a4837c35d0cc15330294d9584a3898cf84";
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
    name = "graceful-fs-1.2.3";
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
    name = "graceful-fs-1.1.14";
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
  by-spec."graceful-fs"."~1.2.1" =
    self.by-version."graceful-fs"."1.2.3";
  by-spec."graceful-fs"."~2" =
    self.by-version."graceful-fs"."2.0.1";
  by-spec."graceful-fs"."~2.0.0" =
    self.by-version."graceful-fs"."2.0.1";
  by-spec."graceful-fs"."~2.0.1" =
    self.by-version."graceful-fs"."2.0.1";
  by-spec."gridfs-stream"."*" =
    self.by-version."gridfs-stream"."0.4.0";
  by-version."gridfs-stream"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "gridfs-stream-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gridfs-stream/-/gridfs-stream-0.4.0.tgz";
        name = "gridfs-stream-0.4.0.tgz";
        sha1 = "f76f791e0d1b22649e11beeacddf8e62bd89ca2a";
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
  "gridfs-stream" = self.by-version."gridfs-stream"."0.4.0";
  by-spec."growl"."1.7.x" =
    self.by-version."growl"."1.7.0";
  by-version."growl"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "growl-1.7.0";
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
    self.by-version."grunt"."0.4.2";
  by-version."grunt"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt/-/grunt-0.4.2.tgz";
        name = "grunt-0.4.2.tgz";
        sha1 = "895b4f28a6102bffd41d365a65e8be2d6a293d93";
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
      self.by-version."findup-sync"."0.1.2"
      self.by-version."glob"."3.1.21"
      self.by-version."hooker"."0.2.3"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."minimatch"."0.2.14"
      self.by-version."nopt"."1.0.10"
      self.by-version."rimraf"."2.0.3"
      self.by-version."lodash"."0.9.2"
      self.by-version."underscore.string"."2.2.1"
      self.by-version."which"."1.0.5"
      self.by-version."js-yaml"."2.0.5"
      self.by-version."exit"."0.1.2"
      self.by-version."getobject"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt" ];
  };
  by-spec."grunt"."~0.4" =
    self.by-version."grunt"."0.4.2";
  by-spec."grunt"."~0.4.0" =
    self.by-version."grunt"."0.4.2";
  by-spec."grunt"."~0.4.1" =
    self.by-version."grunt"."0.4.2";
  by-spec."grunt-bower-task"."*" =
    self.by-version."grunt-bower-task"."0.3.4";
  by-version."grunt-bower-task"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-bower-task-0.3.4";
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
    self.by-version."grunt-cli"."0.1.11";
  by-version."grunt-cli"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-cli-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-cli/-/grunt-cli-0.1.11.tgz";
        name = "grunt-cli-0.1.11.tgz";
        sha1 = "a0d785b7f8633983ecb5e6af8397feb6e39dd0a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-cli" or []);
    deps = [
      self.by-version."nopt"."1.0.10"
      self.by-version."findup-sync"."0.1.2"
      self.by-version."resolve"."0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-cli" ];
  };
  "grunt-cli" = self.by-version."grunt-cli"."0.1.11";
  by-spec."grunt-cli"."~0.1.7" =
    self.by-version."grunt-cli"."0.1.11";
  by-spec."grunt-contrib-cssmin"."*" =
    self.by-version."grunt-contrib-cssmin"."0.7.0";
  by-version."grunt-contrib-cssmin"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-cssmin-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-cssmin/-/grunt-contrib-cssmin-0.7.0.tgz";
        name = "grunt-contrib-cssmin-0.7.0.tgz";
        sha1 = "a5735e9f1d263149e49fe035294e429d8c670bab";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-cssmin" or []);
    deps = [
      self.by-version."clean-css"."2.0.4"
      self.by-version."grunt-lib-contrib"."0.6.1"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
    ];
    passthru.names = [ "grunt-contrib-cssmin" ];
  };
  "grunt-contrib-cssmin" = self.by-version."grunt-contrib-cssmin"."0.7.0";
  by-spec."grunt-contrib-jshint"."*" =
    self.by-version."grunt-contrib-jshint"."0.8.0";
  by-version."grunt-contrib-jshint"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-jshint-0.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-jshint/-/grunt-contrib-jshint-0.8.0.tgz";
        name = "grunt-contrib-jshint-0.8.0.tgz";
        sha1 = "6bd52325dcce1d995dbbf648030c59e1a606acda";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-jshint" or []);
    deps = [
      self.by-version."jshint"."2.4.0"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
    ];
    passthru.names = [ "grunt-contrib-jshint" ];
  };
  "grunt-contrib-jshint" = self.by-version."grunt-contrib-jshint"."0.8.0";
  by-spec."grunt-contrib-less"."*" =
    self.by-version."grunt-contrib-less"."0.8.3";
  by-version."grunt-contrib-less"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-less-0.8.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-less/-/grunt-contrib-less-0.8.3.tgz";
        name = "grunt-contrib-less-0.8.3.tgz";
        sha1 = "8a0e9183577339ad08729f57a9a4adeff6c41410";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-less" or []);
    deps = [
      self.by-version."less"."1.5.1"
      self.by-version."grunt-lib-contrib"."0.6.1"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
    ];
    passthru.names = [ "grunt-contrib-less" ];
  };
  "grunt-contrib-less" = self.by-version."grunt-contrib-less"."0.8.3";
  by-spec."grunt-contrib-requirejs"."*" =
    self.by-version."grunt-contrib-requirejs"."0.4.1";
  by-version."grunt-contrib-requirejs"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-requirejs-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-requirejs/-/grunt-contrib-requirejs-0.4.1.tgz";
        name = "grunt-contrib-requirejs-0.4.1.tgz";
        sha1 = "862ba167141b8a8f36af5444feab3272bb8cf4bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-requirejs" or []);
    deps = [
      self.by-version."requirejs"."2.1.9"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
    ];
    passthru.names = [ "grunt-contrib-requirejs" ];
  };
  "grunt-contrib-requirejs" = self.by-version."grunt-contrib-requirejs"."0.4.1";
  by-spec."grunt-contrib-uglify"."*" =
    self.by-version."grunt-contrib-uglify"."0.2.7";
  by-version."grunt-contrib-uglify"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-uglify-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-0.2.7.tgz";
        name = "grunt-contrib-uglify-0.2.7.tgz";
        sha1 = "e6bda51e0c40a1459f6cead423c65efd725a1bf7";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-uglify" or []);
    deps = [
      self.by-version."uglify-js"."2.4.8"
      self.by-version."grunt-lib-contrib"."0.6.1"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
    ];
    passthru.names = [ "grunt-contrib-uglify" ];
  };
  "grunt-contrib-uglify" = self.by-version."grunt-contrib-uglify"."0.2.7";
  by-spec."grunt-karma"."*" =
    self.by-version."grunt-karma"."0.7.2";
  by-version."grunt-karma"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-karma-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-karma/-/grunt-karma-0.7.2.tgz";
        name = "grunt-karma-0.7.2.tgz";
        sha1 = "1d041d9833671c2bca671cd66bd874c96b2a631e";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-karma" or []);
    deps = [
      self.by-version."optimist"."0.6.0"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
      self.by-version."karma"."0.11.11"
    ];
    passthru.names = [ "grunt-karma" ];
  };
  "grunt-karma" = self.by-version."grunt-karma"."0.7.2";
  by-spec."grunt-lib-contrib"."~0.6.0" =
    self.by-version."grunt-lib-contrib"."0.6.1";
  by-version."grunt-lib-contrib"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-lib-contrib-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-lib-contrib/-/grunt-lib-contrib-0.6.1.tgz";
        name = "grunt-lib-contrib-0.6.1.tgz";
        sha1 = "3f56adb7da06e814795ee2415b0ebe5fb8903ebb";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-lib-contrib" or []);
    deps = [
      self.by-version."zlib-browserify"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-lib-contrib" ];
  };
  by-spec."grunt-lib-contrib"."~0.6.1" =
    self.by-version."grunt-lib-contrib"."0.6.1";
  by-spec."grunt-sed"."*" =
    self.by-version."grunt-sed"."0.1.1";
  by-version."grunt-sed"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-sed-0.1.1";
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
      self.by-version."replace"."0.2.7"
    ];
    peerDependencies = [
      self.by-version."grunt"."0.4.2"
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
      self.by-version."coffee-script"."1.6.3"
      self.by-version."jade"."1.0.0"
      self.by-version."q"."0.9.7"
      self.by-version."xml2js"."0.4.0"
      self.by-version."msgpack"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "guifi-earth" ];
  };
  "guifi-earth" = self.by-version."guifi-earth"."0.2.1";
  by-spec."gzippo"."*" =
    self.by-version."gzippo"."0.2.0";
  by-version."gzippo"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "gzippo-0.2.0";
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
      self.by-version."send"."0.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gzippo" ];
  };
  "gzippo" = self.by-version."gzippo"."0.2.0";
  by-spec."handlebars"."1.0.x" =
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
  by-spec."handlebars"."~1.0.11" =
    self.by-version."handlebars"."1.0.12";
  by-spec."has-color"."~0.1.0" =
    self.by-version."has-color"."0.1.1";
  by-version."has-color"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "has-color-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-color/-/has-color-0.1.1.tgz";
        name = "has-color-0.1.1.tgz";
        sha1 = "28cc90127bc5448f99e76096dc97470a94a66720";
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
    name = "hasher-1.2.0";
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
    name = "hashring-1.0.1";
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
    name = "hat-0.0.3";
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
    name = "hawk-0.10.2";
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
  by-spec."hawk"."~0.13.0" =
    self.by-version."hawk"."0.13.1";
  by-version."hawk"."0.13.1" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.13.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.13.1.tgz";
        name = "hawk-0.13.1.tgz";
        sha1 = "3617958821f58311e4d7f6de291fca662b412ef4";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = [
      self.by-version."hoek"."0.8.5"
      self.by-version."boom"."0.4.2"
      self.by-version."cryptiles"."0.2.2"
      self.by-version."sntp"."0.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."hawk"."~1.0.0" =
    self.by-version."hawk"."1.0.0";
  by-version."hawk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-1.0.0";
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
    name = "hiredis-0.1.16";
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
    name = "hoek-0.7.6";
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
  by-spec."hoek"."0.8.x" =
    self.by-version."hoek"."0.8.5";
  by-version."hoek"."0.8.5" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.8.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.8.5.tgz";
        name = "hoek-0.8.5.tgz";
        sha1 = "1e9fd770ef7ebe0274adfcb5b0806a025a5e4e9f";
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
    name = "hoek-0.9.1";
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
    name = "hooker-0.2.3";
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
    name = "hooks-0.2.1";
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
    name = "htmlparser2-3.1.4";
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
      self.by-version."readable-stream"."1.0.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."htmlparser2"."3.3.x" =
    self.by-version."htmlparser2"."3.3.0";
  by-version."htmlparser2"."3.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-3.3.0";
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
      self.by-version."readable-stream"."1.0.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."http-auth"."2.0.7" =
    self.by-version."http-auth"."2.0.7";
  by-version."http-auth"."2.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "http-auth-2.0.7";
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
    self.by-version."http-proxy"."0.10.3";
  by-spec."http-signature"."0.9.11" =
    self.by-version."http-signature"."0.9.11";
  by-version."http-signature"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.9.11";
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
    name = "http-signature-0.10.0";
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
  by-spec."http-signature"."~0.9.11" =
    self.by-version."http-signature"."0.9.11";
  by-spec."i"."0.3.x" =
    self.by-version."i"."0.3.2";
  by-version."i"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "i-0.3.2";
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
    name = "i18next-1.7.1";
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
      self.by-version."cookies"."0.3.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "i18next" ];
  };
  "i18next" = self.by-version."i18next"."1.7.1";
  by-spec."ibrik"."~1.0.1" =
    self.by-version."ibrik"."1.0.1";
  by-version."ibrik"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "ibrik-1.0.1";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/ibrik/-/ibrik-1.0.1.tgz";
        name = "ibrik-1.0.1.tgz";
        sha1 = "ba9c0cf9302c51a812dc4a92038b3de579c0aefb";
      })
    ];
    buildInputs =
      (self.nativeDeps."ibrik" or []);
    deps = [
      self.by-version."coffee-script-redux"."2.0.0-beta4"
      self.by-version."istanbul"."0.2.1"
      self.by-version."optimist"."0.6.0"
      self.by-version."escodegen"."1.0.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."which"."1.0.5"
      self.by-version."estraverse"."1.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ibrik" ];
  };
  by-spec."iconv-lite"."~0.2.10" =
    self.by-version."iconv-lite"."0.2.11";
  by-version."iconv-lite"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.2.11";
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
  by-spec."indexof"."~0.0.1" =
    self.by-version."indexof"."0.0.1";
  by-version."indexof"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "indexof-0.0.1";
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
    name = "inherits-1.0.0";
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
    name = "inherits-2.0.1";
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
  by-spec."ini"."1" =
    self.by-version."ini"."1.1.0";
  by-version."ini"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.1.0";
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
  by-spec."init-package-json"."0.0.14" =
    self.by-version."init-package-json"."0.0.14";
  by-version."init-package-json"."0.0.14" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-0.0.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-0.0.14.tgz";
        name = "init-package-json-0.0.14.tgz";
        sha1 = "bd5f7b2d73b54957388cca3ce61190340c8a05b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json" or []);
    deps = [
      self.by-version."promzard"."0.2.0"
      self.by-version."read"."1.0.5"
      self.by-version."read-package-json"."1.1.4"
      self.by-version."semver"."2.2.1"
      self.by-version."glob"."3.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  by-spec."inquirer"."~0.2.4" =
    self.by-version."inquirer"."0.2.5";
  by-version."inquirer"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.2.5.tgz";
        name = "inquirer-0.2.5.tgz";
        sha1 = "6b49a9cbe03de776122211f174ef9fe2822c08f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer" or []);
    deps = [
      self.by-version."lodash"."1.2.1"
      self.by-version."async"."0.2.9"
      self.by-version."cli-color"."0.2.3"
      self.by-version."mute-stream"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  by-spec."inquirer"."~0.3.0" =
    self.by-version."inquirer"."0.3.5";
  by-version."inquirer"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.3.5";
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
      self.by-version."async"."0.2.9"
      self.by-version."cli-color"."0.2.3"
      self.by-version."mute-stream"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  by-spec."inquirer"."~0.3.1" =
    self.by-version."inquirer"."0.3.5";
  by-spec."insight"."~0.3.0" =
    self.by-version."insight"."0.3.0";
  by-version."insight"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "insight-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insight/-/insight-0.3.0.tgz";
        name = "insight-0.3.0.tgz";
        sha1 = "9d922133f560f7633abfc8f91451bda5e2cf2f71";
      })
    ];
    buildInputs =
      (self.nativeDeps."insight" or []);
    deps = [
      self.by-version."chalk"."0.2.1"
      self.by-version."request"."2.27.0"
      self.by-version."configstore"."0.1.7"
      self.by-version."async"."0.2.9"
      self.by-version."lodash"."1.3.1"
      self.by-version."inquirer"."0.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "insight" ];
  };
  by-spec."intersect"."~0.0.3" =
    self.by-version."intersect"."0.0.3";
  by-version."intersect"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "intersect-0.0.3";
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
    name = "ironhorse-0.0.9";
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
      self.by-version."winston"."0.7.2"
      self.by-version."nconf"."0.6.9"
      self.by-version."fs-walk"."0.0.1"
      self.by-version."async"."0.2.9"
      self.by-version."express"."3.4.7"
      self.by-version."jade"."1.0.0"
      self.by-version."passport"."0.1.17"
      self.by-version."passport-http"."0.2.2"
      self.by-version."js-yaml"."3.0.1"
      self.by-version."mongoose"."3.8.3"
      self.by-version."gridfs-stream"."0.4.0"
      self.by-version."temp"."0.6.0"
      self.by-version."kue"."0.6.2"
      self.by-version."redis"."0.10.0"
      self.by-version."hiredis"."0.1.16"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ironhorse" ];
  };
  "ironhorse" = self.by-version."ironhorse"."0.0.9";
  by-spec."is"."~0.2.6" =
    self.by-version."is"."0.2.6";
  by-version."is"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "is-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is/-/is-0.2.6.tgz";
        name = "is-0.2.6.tgz";
        sha1 = "36681b7c4328a75a6dd4b6d8f7131e4f81de55c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."is" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "is" ];
  };
  by-spec."is-object"."~0.1.2" =
    self.by-version."is-object"."0.1.2";
  by-version."is-object"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "is-object-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-object/-/is-object-0.1.2.tgz";
        name = "is-object-0.1.2.tgz";
        sha1 = "00efbc08816c33cfc4ac8251d132e10dc65098d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-object" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "is-object" ];
  };
  by-spec."is-promise"."~1" =
    self.by-version."is-promise"."1.0.0";
  by-version."is-promise"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-promise-1.0.0";
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
  by-spec."isbinaryfile"."~0.1.8" =
    self.by-version."isbinaryfile"."0.1.9";
  by-version."isbinaryfile"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "isbinaryfile-0.1.9";
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
    self.by-version."isbinaryfile"."2.0.0";
  by-version."isbinaryfile"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "isbinaryfile-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isbinaryfile/-/isbinaryfile-2.0.0.tgz";
        name = "isbinaryfile-2.0.0.tgz";
        sha1 = "309c09010811d04ebed7c8d026df443d565e9f26";
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
    self.by-version."istanbul"."0.2.1";
  by-version."istanbul"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.2.1.tgz";
        name = "istanbul-0.2.1.tgz";
        sha1 = "21755f7ff0d7627a0747e571ffcea7f2ee9627d8";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."escodegen"."0.0.23"
      self.by-version."handlebars"."1.0.12"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."nopt"."2.1.2"
      self.by-version."fileset"."0.1.5"
      self.by-version."which"."1.0.5"
      self.by-version."async"."0.2.9"
      self.by-version."abbrev"."1.0.4"
      self.by-version."wordwrap"."0.0.2"
      self.by-version."resolve"."0.5.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  "istanbul" = self.by-version."istanbul"."0.2.1";
  by-spec."istanbul"."~0.1.45" =
    self.by-version."istanbul"."0.1.46";
  by-version."istanbul"."0.1.46" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.1.46";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.1.46.tgz";
        name = "istanbul-0.1.46.tgz";
        sha1 = "cefeb1c787d125a6db23bd0f63b0eb9390b0b40d";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul" or []);
    deps = [
      self.by-version."esprima"."1.0.4"
      self.by-version."escodegen"."0.0.23"
      self.by-version."handlebars"."1.0.12"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."nopt"."2.1.2"
      self.by-version."fileset"."0.1.5"
      self.by-version."which"."1.0.5"
      self.by-version."async"."0.2.9"
      self.by-version."abbrev"."1.0.4"
      self.by-version."wordwrap"."0.0.2"
      self.by-version."resolve"."0.5.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  by-spec."jade"."*" =
    self.by-version."jade"."1.0.0";
  by-version."jade"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "jade-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-1.0.0.tgz";
        name = "jade-1.0.0.tgz";
        sha1 = "388fab59603843eb4836211a3684f5206cb93b66";
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
      self.by-version."with"."2.0.0"
      self.by-version."constantinople"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  "jade" = self.by-version."jade"."1.0.0";
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
  by-spec."jade".">= 0.0.1" =
    self.by-version."jade"."1.0.0";
  by-spec."jayschema"."*" =
    self.by-version."jayschema"."0.2.1";
  by-version."jayschema"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "jayschema-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jayschema/-/jayschema-0.2.1.tgz";
        name = "jayschema-0.2.1.tgz";
        sha1 = "b951c66c9cf48c510d5b920198c2755590f3b691";
      })
    ];
    buildInputs =
      (self.nativeDeps."jayschema" or []);
    deps = [
      self.by-version."when"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jayschema" ];
  };
  "jayschema" = self.by-version."jayschema"."0.2.1";
  by-spec."jedediah"."~0.1.0" =
    self.by-version."jedediah"."0.1.1";
  by-version."jedediah"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "jedediah-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jedediah/-/jedediah-0.1.1.tgz";
        name = "jedediah-0.1.1.tgz";
        sha1 = "51f33021ebec6847d844cb53bbc086ee38877f84";
      })
    ];
    buildInputs =
      (self.nativeDeps."jedediah" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jedediah" ];
  };
  by-spec."js-yaml"."*" =
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
  "js-yaml" = self.by-version."js-yaml"."3.0.1";
  by-spec."js-yaml"."0.3.x" =
    self.by-version."js-yaml"."0.3.7";
  by-version."js-yaml"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-0.3.7";
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
  by-spec."js-yaml"."~2.1.0" =
    self.by-version."js-yaml"."2.1.3";
  by-version."js-yaml"."2.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.3.tgz";
        name = "js-yaml-2.1.3.tgz";
        sha1 = "0ffb5617be55525878063d7a16aee7fdd282e84c";
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
    self.by-version."jshint"."2.4.0";
  by-version."jshint"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.4.0.tgz";
        name = "jshint-2.4.0.tgz";
        sha1 = "31717646cee2137cdd7f1b773c3fce58f4d99fc5";
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
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  "jshint" = self.by-version."jshint"."2.4.0";
  by-spec."jshint"."~2.4.0" =
    self.by-version."jshint"."2.4.0";
  by-spec."json-schema"."0.2.2" =
    self.by-version."json-schema"."0.2.2";
  by-version."json-schema"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "json-schema-0.2.2";
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
    name = "json-stringify-safe-3.0.0";
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
  by-spec."json-stringify-safe"."~4.0.0" =
    self.by-version."json-stringify-safe"."4.0.0";
  by-version."json-stringify-safe"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-4.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-4.0.0.tgz";
        name = "json-stringify-safe-4.0.0.tgz";
        sha1 = "77c271aaea54302e68efeaccb56abbf06a9b1a54";
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
    name = "json-stringify-safe-5.0.0";
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
    name = "jsonfile-1.0.1";
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
    name = "jsprim-0.3.0";
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
    name = "junk-0.2.2";
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
    self.by-version."karma"."0.11.11";
  by-version."karma"."0.11.11" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.11.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.11.11.tgz";
        name = "karma-0.11.11.tgz";
        sha1 = "c5e0fa2220dfee7bb08a3bb085895b40e82197a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma" or []);
    deps = [
      self.by-version."di"."0.0.1"
      self.by-version."socket.io"."0.9.16"
      self.by-version."chokidar"."0.8.1"
      self.by-version."glob"."3.1.21"
      self.by-version."minimatch"."0.2.14"
      self.by-version."http-proxy"."0.10.3"
      self.by-version."optimist"."0.3.7"
      self.by-version."coffee-script"."1.6.3"
      self.by-version."rimraf"."2.1.4"
      self.by-version."q"."0.9.7"
      self.by-version."colors"."0.6.0-1"
      self.by-version."lodash"."1.1.1"
      self.by-version."mime"."1.2.11"
      self.by-version."log4js"."0.6.9"
      self.by-version."useragent"."2.0.7"
      self.by-version."graceful-fs"."1.2.3"
      self.by-version."connect"."2.8.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "karma" ];
  };
  "karma" = self.by-version."karma"."0.11.11";
  by-spec."karma".">=0.11.11" =
    self.by-version."karma"."0.11.11";
  by-spec."karma".">=0.9" =
    self.by-version."karma"."0.11.11";
  by-spec."karma".">=0.9.3" =
    self.by-version."karma"."0.11.11";
  by-spec."karma"."~0.11.0" =
    self.by-version."karma"."0.11.11";
  by-spec."karma-chrome-launcher"."*" =
    self.by-version."karma-chrome-launcher"."0.1.2";
  by-version."karma-chrome-launcher"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "karma-chrome-launcher-0.1.2";
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
      self.by-version."karma"."0.11.11"
    ];
    passthru.names = [ "karma-chrome-launcher" ];
  };
  "karma-chrome-launcher" = self.by-version."karma-chrome-launcher"."0.1.2";
  by-spec."karma-coverage"."*" =
    self.by-version."karma-coverage"."0.1.4";
  by-version."karma-coverage"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "karma-coverage-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coverage/-/karma-coverage-0.1.4.tgz";
        name = "karma-coverage-0.1.4.tgz";
        sha1 = "53766bad4dc2aa26dcc1be95ded7809be8032d8e";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-coverage" or []);
    deps = [
      self.by-version."istanbul"."0.1.46"
      self.by-version."ibrik"."1.0.1"
      self.by-version."dateformat"."1.0.7-1.2.3"
    ];
    peerDependencies = [
      self.by-version."karma"."0.11.11"
    ];
    passthru.names = [ "karma-coverage" ];
  };
  "karma-coverage" = self.by-version."karma-coverage"."0.1.4";
  by-spec."karma-junit-reporter"."*" =
    self.by-version."karma-junit-reporter"."0.2.1";
  by-version."karma-junit-reporter"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "karma-junit-reporter-0.2.1";
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
      self.by-version."karma"."0.11.11"
    ];
    passthru.names = [ "karma-junit-reporter" ];
  };
  "karma-junit-reporter" = self.by-version."karma-junit-reporter"."0.2.1";
  by-spec."karma-mocha"."*" =
    self.by-version."karma-mocha"."0.1.1";
  by-version."karma-mocha"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "karma-mocha-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-mocha/-/karma-mocha-0.1.1.tgz";
        name = "karma-mocha-0.1.1.tgz";
        sha1 = "5edddb3e2d2c6fd47e9ad26f0af1595fe852c756";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-mocha" or []);
    deps = [
    ];
    peerDependencies = [
      self.by-version."karma"."0.11.11"
      self.by-version."mocha"."1.16.2"
    ];
    passthru.names = [ "karma-mocha" ];
  };
  "karma-mocha" = self.by-version."karma-mocha"."0.1.1";
  by-spec."karma-requirejs"."*" =
    self.by-version."karma-requirejs"."0.2.1";
  by-version."karma-requirejs"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "karma-requirejs-0.2.1";
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
      self.by-version."karma"."0.11.11"
      self.by-version."requirejs"."2.1.9"
    ];
    passthru.names = [ "karma-requirejs" ];
  };
  "karma-requirejs" = self.by-version."karma-requirejs"."0.2.1";
  by-spec."karma-sauce-launcher"."*" =
    self.by-version."karma-sauce-launcher"."0.2.0";
  by-version."karma-sauce-launcher"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "karma-sauce-launcher-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-sauce-launcher/-/karma-sauce-launcher-0.2.0.tgz";
        name = "karma-sauce-launcher-0.2.0.tgz";
        sha1 = "0994da49a1774be876ff1b107fd47e8768e3ead0";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-sauce-launcher" or []);
    deps = [
      self.by-version."wd"."0.2.8"
      self.by-version."sauce-connect-launcher"."0.2.2"
      self.by-version."q"."0.9.7"
      self.by-version."saucelabs"."0.1.1"
    ];
    peerDependencies = [
      self.by-version."karma"."0.11.11"
    ];
    passthru.names = [ "karma-sauce-launcher" ];
  };
  "karma-sauce-launcher" = self.by-version."karma-sauce-launcher"."0.2.0";
  by-spec."keen.io"."0.0.3" =
    self.by-version."keen.io"."0.0.3";
  by-version."keen.io"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "keen.io-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keen.io/-/keen.io-0.0.3.tgz";
        name = "keen.io-0.0.3.tgz";
        sha1 = "2d6ae2baa6d24b618f378b2a44413e1283fbcb63";
      })
    ];
    buildInputs =
      (self.nativeDeps."keen.io" or []);
    deps = [
      self.by-version."superagent"."0.13.0"
      self.by-version."underscore"."1.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keen.io" ];
  };
  by-spec."keep-alive-agent"."0.0.1" =
    self.by-version."keep-alive-agent"."0.0.1";
  by-version."keep-alive-agent"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "keep-alive-agent-0.0.1";
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
    name = "kerberos-0.0.3";
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
    name = "kew-0.1.7";
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
  by-spec."keypress"."0.1.x" =
    self.by-version."keypress"."0.1.0";
  by-version."keypress"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "keypress-0.1.0";
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
  by-spec."knox"."*" =
    self.by-version."knox"."0.8.8";
  by-version."knox"."0.8.8" = lib.makeOverridable self.buildNodePackage {
    name = "knox-0.8.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knox/-/knox-0.8.8.tgz";
        name = "knox-0.8.8.tgz";
        sha1 = "aeeadd22b0a4b1e4d858a15174af2da060ab6774";
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
  "knox" = self.by-version."knox"."0.8.8";
  by-spec."kue"."*" =
    self.by-version."kue"."0.6.2";
  by-version."kue"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "kue-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kue/-/kue-0.6.2.tgz";
        name = "kue-0.6.2.tgz";
        sha1 = "9a6a95081842cf4ee3da5c61770bc23616a943f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."kue" or []);
    deps = [
      self.by-version."redis"."0.7.2"
      self.by-version."express"."3.1.2"
      self.by-version."jade"."0.26.3"
      self.by-version."stylus"."0.27.2"
      self.by-version."nib"."0.5.0"
      self.by-version."reds"."0.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kue" ];
  };
  "kue" = self.by-version."kue"."0.6.2";
  by-spec."lazy"."~1.0.11" =
    self.by-version."lazy"."1.0.11";
  by-version."lazy"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "lazy-1.0.11";
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
  by-spec."lcov-parse"."0.0.4" =
    self.by-version."lcov-parse"."0.0.4";
  by-version."lcov-parse"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "lcov-parse-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-parse/-/lcov-parse-0.0.4.tgz";
        name = "lcov-parse-0.0.4.tgz";
        sha1 = "3853a4f132f04581db0e74c180542d90f0d1c66b";
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
      self.by-version."glob"."3.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lcov-result-merger" ];
  };
  "lcov-result-merger" = self.by-version."lcov-result-merger"."0.0.2";
  by-spec."less"."~1.5.1" =
    self.by-version."less"."1.5.1";
  by-version."less"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "less-1.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-1.5.1.tgz";
        name = "less-1.5.1.tgz";
        sha1 = "633313130efd12a3b78c56aa799dab3eeffffff4";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = [
      self.by-version."mime"."1.2.11"
      self.by-version."request"."2.30.0"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."clean-css"."2.0.4"
      self.by-version."source-map"."0.1.31"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  by-spec."libxmljs"."~0.8.1" =
    self.by-version."libxmljs"."0.8.1";
  by-version."libxmljs"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "libxmljs-0.8.1";
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
    self.by-version."libyaml"."0.2.2";
  by-version."libyaml"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "libyaml-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libyaml/-/libyaml-0.2.2.tgz";
        name = "libyaml-0.2.2.tgz";
        sha1 = "a22d5f699911b6b622d6dc323fb62320c877c9c8";
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
  "libyaml" = self.by-version."libyaml"."0.2.2";
  by-spec."lockfile"."~0.4.0" =
    self.by-version."lockfile"."0.4.2";
  by-version."lockfile"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "lockfile-0.4.2";
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
  by-spec."lodash"."~0.10.0" =
    self.by-version."lodash"."0.10.0";
  by-version."lodash"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-0.10.0";
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
    name = "lodash-0.9.2";
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
  by-spec."lodash"."~1.0.1" =
    self.by-version."lodash"."1.0.1";
  by-version."lodash"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.0.1.tgz";
        name = "lodash-1.0.1.tgz";
        sha1 = "57945732498d92310e5bd4b1ff4f273a79e6c9fc";
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
  by-spec."lodash"."~1.1" =
    self.by-version."lodash"."1.1.1";
  by-version."lodash"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.1.1.tgz";
        name = "lodash-1.1.1.tgz";
        sha1 = "41a2b2e9a00e64d6d1999f143ff6b0755f6bbb24";
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
    name = "lodash-1.2.1";
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
    name = "lodash-1.3.1";
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
    name = "lodash-2.1.0";
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
    name = "lodash-2.2.1";
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
  by-spec."lodash"."~2.3.0" =
    self.by-version."lodash"."2.3.0";
  by-version."lodash"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-2.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.3.0.tgz";
        name = "lodash-2.3.0.tgz";
        sha1 = "dfbdac99cf87a59a022c474730570d8716c267dd";
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
  by-version."lodash"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-2.4.1";
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
  by-spec."log-driver"."1.2.1" =
    self.by-version."log-driver"."1.2.1";
  by-version."log-driver"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "log-driver-1.2.1";
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
    self.by-version."log4js"."0.6.9";
  by-version."log4js"."0.6.9" = lib.makeOverridable self.buildNodePackage {
    name = "log4js-0.6.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log4js/-/log4js-0.6.9.tgz";
        name = "log4js-0.6.9.tgz";
        sha1 = "2e327189c1c0dec17448ec5255f58cd0fddf4596";
      })
    ];
    buildInputs =
      (self.nativeDeps."log4js" or []);
    deps = [
      self.by-version."async"."0.1.15"
      self.by-version."semver"."1.1.4"
      self.by-version."readable-stream"."1.0.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "log4js" ];
  };
  by-spec."long"."*" =
    self.by-version."long"."1.1.2";
  by-version."long"."1.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "long-1.1.2";
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
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.5.0";
  by-version."lru-cache"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.5.0";
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
    name = "lru-cache-2.2.0";
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
    name = "lru-cache-2.2.4";
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
    name = "lru-cache-2.3.0";
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
    name = "lru-cache-1.0.6";
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
    name = "lru-cache-2.3.1";
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
  by-spec."mailcomposer".">= 0.1.27" =
    self.by-version."mailcomposer"."0.2.6";
  by-version."mailcomposer"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "mailcomposer-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mailcomposer/-/mailcomposer-0.2.6.tgz";
        name = "mailcomposer-0.2.6.tgz";
        sha1 = "fa785ae7505daeb7a11f7cecf2b374d7801d1b87";
      })
    ];
    buildInputs =
      (self.nativeDeps."mailcomposer" or []);
    deps = [
      self.by-version."mimelib"."0.2.14"
      self.by-version."mime"."1.2.9"
      self.by-version."he"."0.3.6"
      self.by-version."punycode"."1.2.3"
      self.by-version."dkim-signer"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mailcomposer" ];
  };
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
    name = "memoizee-0.2.6";
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
    name = "merge-descriptors-0.0.1";
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
  by-spec."methods"."0.0.1" =
    self.by-version."methods"."0.0.1";
  by-version."methods"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "methods-0.0.1";
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
  by-version."methods"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "methods-0.1.0";
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
  by-spec."mime"."*" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
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
    name = "mime-1.2.4";
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
    name = "mime-1.2.5";
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
    name = "mime-1.2.6";
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
    name = "mime-1.2.9";
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
  by-spec."mime"."~1.2" =
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
    name = "mimelib-0.2.14";
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
      self.by-version."addressparser"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mimelib" ];
  };
  by-spec."minimatch"."0" =
    self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.14";
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
    name = "minimatch-0.0.5";
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
    self.by-version."minimist"."0.0.5";
  by-version."minimist"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.5.tgz";
        name = "minimist-0.0.5.tgz";
        sha1 = "d7aa327bcecf518f9106ac6b8f003fa3bcea8566";
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
  by-spec."ministyle"."~0.1.3" =
    self.by-version."ministyle"."0.1.3";
  by-version."ministyle"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "ministyle-0.1.3";
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
    name = "miniwrite-0.1.3";
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
    name = "mkdirp-0.3.5";
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
    name = "mkdirp-0.3.0";
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
    name = "mkpath-0.1.0";
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
    self.by-version."mocha"."1.16.2";
  by-version."mocha"."1.16.2" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-1.16.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-1.16.2.tgz";
        name = "mocha-1.16.2.tgz";
        sha1 = "57766843f016a1308fe9fddb22f74676d6721ace";
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
  "mocha" = self.by-version."mocha"."1.16.2";
  by-spec."mocha-unfunk-reporter"."*" =
    self.by-version."mocha-unfunk-reporter"."0.4.0";
  by-version."mocha-unfunk-reporter"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-unfunk-reporter-0.4.0";
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
      self.by-version."unfunk-diff"."0.0.1"
      self.by-version."miniwrite"."0.1.3"
      self.by-version."ministyle"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mocha-unfunk-reporter" ];
  };
  "mocha-unfunk-reporter" = self.by-version."mocha-unfunk-reporter"."0.4.0";
  by-spec."moment"."2.1.0" =
    self.by-version."moment"."2.1.0";
  by-version."moment"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.1.0";
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
    name = "moment-2.4.0";
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
  by-spec."mongodb"."*" =
    self.by-version."mongodb"."1.4.0-rc3";
  by-version."mongodb"."1.4.0-rc3" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.4.0-rc3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.4.0-rc3.tgz";
        name = "mongodb-1.4.0-rc3.tgz";
        sha1 = "e605a2c85a337f85d766e2ed221a4caa201c0b4f";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb" or []);
    deps = [
      self.by-version."bson"."0.2.3"
      self.by-version."kerberos"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  "mongodb" = self.by-version."mongodb"."1.4.0-rc3";
  by-spec."mongodb"."1.2.14" =
    self.by-version."mongodb"."1.2.14";
  by-version."mongodb"."1.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.2.14";
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
    name = "mongodb-1.3.19";
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
  by-spec."mongodb"."1.3.x" =
    self.by-version."mongodb"."1.3.23";
  by-version."mongodb"."1.3.23" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.3.23";
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
  by-spec."mongoose"."*" =
    self.by-version."mongoose"."3.8.3";
  by-version."mongoose"."3.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.8.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.8.3.tgz";
        name = "mongoose-3.8.3.tgz";
        sha1 = "74425eb9ee9ca4a34c87b4624dc055131e0c7d0c";
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
      self.by-version."mpromise"."0.3.0"
      self.by-version."mpath"."0.1.1"
      self.by-version."regexp-clone"."0.0.1"
      self.by-version."mquery"."0.3.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  by-spec."mongoose"."3.6.7" =
    self.by-version."mongoose"."3.6.7";
  by-version."mongoose"."3.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.6.7";
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
    name = "mongoose-3.6.20";
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
    name = "mongoose-lifecycle-1.0.0";
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
    name = "mongoose-schema-extend-0.1.7";
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
    name = "monocle-1.1.50";
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
  by-spec."mout"."~0.6.0" =
    self.by-version."mout"."0.6.0";
  by-version."mout"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "mout-0.6.0";
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
    name = "mout-0.7.1";
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
  by-spec."mpath"."0.1.1" =
    self.by-version."mpath"."0.1.1";
  by-version."mpath"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "mpath-0.1.1";
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
    name = "mpromise-0.2.1";
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
  by-spec."mpromise"."0.3.0" =
    self.by-version."mpromise"."0.3.0";
  by-version."mpromise"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "mpromise-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.3.0.tgz";
        name = "mpromise-0.3.0.tgz";
        sha1 = "cb864c2f642eb2192765087e3692e1dc152afe4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise" or []);
    deps = [
      self.by-version."sliced"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  by-spec."mquery"."0.3.2" =
    self.by-version."mquery"."0.3.2";
  by-version."mquery"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "mquery-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mquery/-/mquery-0.3.2.tgz";
        name = "mquery-0.3.2.tgz";
        sha1 = "074cb82c51ec1b15897d8afb80a7b3567a2f8eca";
      })
    ];
    buildInputs =
      (self.nativeDeps."mquery" or []);
    deps = [
      self.by-version."sliced"."0.0.5"
      self.by-version."debug"."0.7.0"
      self.by-version."regexp-clone"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mquery" ];
  };
  by-spec."ms"."0.1.0" =
    self.by-version."ms"."0.1.0";
  by-version."ms"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ms-0.1.0";
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
    self.by-version."msgpack"."0.2.1";
  by-version."msgpack"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "msgpack-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/msgpack/-/msgpack-0.2.1.tgz";
        name = "msgpack-0.2.1.tgz";
        sha1 = "5da246daa2138b4163640e486c00c4f3961e92ac";
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
    name = "multiparty-2.2.0";
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
      self.by-version."readable-stream"."1.1.9"
      self.by-version."stream-counter"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "multiparty" ];
  };
  by-spec."muri"."0.3.1" =
    self.by-version."muri"."0.3.1";
  by-version."muri"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "muri-0.3.1";
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
    name = "mute-stream-0.0.3";
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
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "mute-stream-0.0.4";
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
  by-spec."mv"."0.0.5" =
    self.by-version."mv"."0.0.5";
  by-version."mv"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "mv-0.0.5";
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
    name = "nan-0.3.2";
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
  by-spec."nan"."~0.4.1" =
    self.by-version."nan"."0.4.4";
  by-version."nan"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "nan-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.4.4.tgz";
        name = "nan-0.4.4.tgz";
        sha1 = "9db58eae63cee119807a0d01afd0655d956bea75";
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
    name = "nan-0.6.0";
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
  by-spec."natural"."0.0.69" =
    self.by-version."natural"."0.0.69";
  by-version."natural"."0.0.69" = lib.makeOverridable self.buildNodePackage {
    name = "natural-0.0.69";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/natural/-/natural-0.0.69.tgz";
        name = "natural-0.0.69.tgz";
        sha1 = "60d9ce23797a54ec211600eb721cc66779b954d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."natural" or []);
    deps = [
      self.by-version."sylvester"."0.0.21"
      self.by-version."apparatus"."0.0.8"
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "natural" ];
  };
  by-spec."nconf"."*" =
    self.by-version."nconf"."0.6.9";
  by-version."nconf"."0.6.9" = lib.makeOverridable self.buildNodePackage {
    name = "nconf-0.6.9";
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
    name = "negotiator-0.2.5";
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
    name = "negotiator-0.3.0";
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
  by-spec."net-ping"."1.1.7" =
    self.by-version."net-ping"."1.1.7";
  by-version."net-ping"."1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "net-ping-1.1.7";
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
    name = "next-tick-0.1.0";
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
    name = "nib-0.5.0";
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
    self.by-version."nijs"."0.0.12";
  by-version."nijs"."0.0.12" = lib.makeOverridable self.buildNodePackage {
    name = "nijs-0.0.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.12.tgz";
        name = "nijs-0.0.12.tgz";
        sha1 = "23bb40746b409e8556f9a4fe97ca314410a685df";
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
  "nijs" = self.by-version."nijs"."0.0.12";
  by-spec."node-expat"."*" =
    self.by-version."node-expat"."2.1.4";
  by-version."node-expat"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-expat-2.1.4";
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
    self.by-version."node-gyp"."0.12.2";
  by-version."node-gyp"."0.12.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.12.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.12.2.tgz";
        name = "node-gyp-0.12.2.tgz";
        sha1 = "bdca7e7025feb308ddd7fd3434300e47703ec57a";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp" or []);
    deps = [
      self.by-version."glob"."3.2.7"
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."fstream"."0.1.25"
      self.by-version."minimatch"."0.2.14"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."nopt"."2.1.2"
      self.by-version."npmlog"."0.0.6"
      self.by-version."osenv"."0.0.3"
      self.by-version."request"."2.30.0"
      self.by-version."rimraf"."2.2.5"
      self.by-version."semver"."2.2.1"
      self.by-version."tar"."0.1.19"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  "node-gyp" = self.by-version."node-gyp"."0.12.2";
  by-spec."node-gyp"."~0.12.0" =
    self.by-version."node-gyp"."0.12.2";
  by-spec."node-inspector"."*" =
    self.by-version."node-inspector"."0.7.0-1";
  by-version."node-inspector"."0.7.0-1" = lib.makeOverridable self.buildNodePackage {
    name = "node-inspector-0.7.0-1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-inspector/-/node-inspector-0.7.0-1.tgz";
        name = "node-inspector-0.7.0-1.tgz";
        sha1 = "13964415403ee7642fd7554f87c2c7a51af64090";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-inspector" or []);
    deps = [
      self.by-version."socket.io"."0.9.16"
      self.by-version."express"."3.4.7"
      self.by-version."async"."0.2.9"
      self.by-version."glob"."3.2.7"
      self.by-version."rc"."0.3.2"
      self.by-version."strong-data-uri"."0.1.0"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-inspector" ];
  };
  "node-inspector" = self.by-version."node-inspector"."0.7.0-1";
  by-spec."node-protobuf"."*" =
    self.by-version."node-protobuf"."1.0.9";
  by-version."node-protobuf"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-protobuf-1.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-protobuf/-/node-protobuf-1.0.9.tgz";
        name = "node-protobuf-1.0.9.tgz";
        sha1 = "6b2e7682bb65e01a10e19179f8e162ac9a66a6e6";
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
  "node-protobuf" = self.by-version."node-protobuf"."1.0.9";
  by-spec."node-swt".">=0.1.1" =
    self.by-version."node-swt"."0.1.1";
  by-version."node-swt"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-swt-0.1.1";
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
    name = "node-syslog-1.1.7";
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
    name = "node-uptime-3.2.0";
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
    name = "node-uuid-1.4.1";
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
    name = "node-uuid-1.3.3";
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
    name = "node-uuid-1.4.0";
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
  by-spec."node-wsfederation".">=0.1.1" =
    self.by-version."node-wsfederation"."0.1.1";
  by-version."node-wsfederation"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-wsfederation-0.1.1";
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
      self.by-version."xml2js"."0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-wsfederation" ];
  };
  by-spec."node.extend"."1.0.0" =
    self.by-version."node.extend"."1.0.0";
  by-version."node.extend"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node.extend-1.0.0";
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
      self.by-version."mailcomposer"."0.2.6"
      self.by-version."simplesmtp"."0.3.16"
      self.by-version."optimist"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nodemailer" ];
  };
  by-spec."nodemon"."*" =
    self.by-version."nodemon"."0.9.17";
  by-version."nodemon"."0.9.17" = lib.makeOverridable self.buildNodePackage {
    name = "nodemon-0.9.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemon/-/nodemon-0.9.17.tgz";
        name = "nodemon-0.9.17.tgz";
        sha1 = "31fbc65cbda162ebff4d9ff5f774fdd3006bb50b";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemon" or []);
    deps = [
      self.by-version."update-notifier"."0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nodemon" ];
  };
  "nodemon" = self.by-version."nodemon"."0.9.17";
  by-spec."nomnom"."1.6.x" =
    self.by-version."nomnom"."1.6.2";
  by-version."nomnom"."1.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "nomnom-1.6.2";
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
  by-spec."nopt"."2.1.x" =
    self.by-version."nopt"."2.1.2";
  by-spec."nopt"."https://github.com/Filirom1/nopt/tarball/master#pull-request-in-progress" =
    self.by-version."nopt"."1.0.10";
  by-version."nopt"."1.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-1.0.10";
    src = [
      (fetchurl {
        url = "https://github.com/Filirom1/nopt/tarball/master#pull-request-in-progress";
        name = "nopt-1.0.10.tgz";
        sha256 = "94daa53a0ab7668be12931b7b551c924c913d1efef7f2a05e60704c9b90a7bad";
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
  by-spec."nopt"."~1.0.10" =
    self.by-version."nopt"."1.0.10";
  by-spec."nopt"."~2.1.1" =
    self.by-version."nopt"."2.1.2";
  by-spec."nopt"."~2.1.2" =
    self.by-version."nopt"."2.1.2";
  by-spec."normalize-package-data"."~0.2.7" =
    self.by-version."normalize-package-data"."0.2.8";
  by-version."normalize-package-data"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "normalize-package-data-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/normalize-package-data/-/normalize-package-data-0.2.8.tgz";
        name = "normalize-package-data-0.2.8.tgz";
        sha1 = "95dc1bcb54c8d46b3be345c05afbab27e48e2f69";
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
    self.by-version."npm"."1.3.22";
  by-version."npm"."1.3.22" = lib.makeOverridable self.buildNodePackage {
    name = "npm-1.3.22";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-1.3.22.tgz";
        name = "npm-1.3.22.tgz";
        sha1 = "6ebc09f97f83ed3fd524b85faea5e30574e08c99";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm" or []);
    deps = [
      self.by-version."semver"."2.2.1"
      self.by-version."ini"."1.1.0"
      self.by-version."slide"."1.1.5"
      self.by-version."abbrev"."1.0.4"
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."minimatch"."0.2.14"
      self.by-version."nopt"."2.1.2"
      self.by-version."rimraf"."2.2.5"
      self.by-version."request"."2.30.0"
      self.by-version."which"."1.0.5"
      self.by-version."tar"."0.1.19"
      self.by-version."fstream"."0.1.25"
      self.by-version."block-stream"."0.0.7"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."read"."1.0.5"
      self.by-version."lru-cache"."2.5.0"
      self.by-version."node-gyp"."0.12.2"
      self.by-version."fstream-npm"."0.1.6"
      self.by-version."uid-number"."0.0.3"
      self.by-version."archy"."0.0.2"
      self.by-version."chownr"."0.0.1"
      self.by-version."npmlog"."0.0.6"
      self.by-version."ansi"."0.2.1"
      self.by-version."npm-registry-client"."0.3.3"
      self.by-version."read-package-json"."1.1.4"
      self.by-version."read-installed"."0.2.5"
      self.by-version."glob"."3.2.7"
      self.by-version."init-package-json"."0.0.14"
      self.by-version."osenv"."0.0.3"
      self.by-version."lockfile"."0.4.2"
      self.by-version."retry"."0.6.0"
      self.by-version."once"."1.3.0"
      self.by-version."npmconf"."0.1.9"
      self.by-version."opener"."1.3.0"
      self.by-version."chmodr"."0.1.0"
      self.by-version."cmd-shim"."1.1.1"
      self.by-version."sha"."1.2.3"
      self.by-version."editor"."0.0.5"
      self.by-version."child-process-close"."0.1.1"
      self.by-version."npm-user-validate"."0.0.3"
      self.by-version."github-url-from-git"."1.1.1"
      self.by-version."github-url-from-username-repo"."0.0.2"
      self.by-version."text-table"."0.2.0"
      self.by-version."ansicolors"."0.3.2"
      self.by-version."ansistyles"."0.1.3"
      self.by-version."path-is-inside"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  "npm" = self.by-version."npm"."1.3.22";
  by-spec."npm"."~1.3.14" =
    self.by-version."npm"."1.3.22";
  by-spec."npm-registry-client"."0.2.27" =
    self.by-version."npm-registry-client"."0.2.27";
  by-version."npm-registry-client"."0.2.27" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.2.27";
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
      self.by-version."request"."2.30.0"
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."semver"."2.0.11"
      self.by-version."slide"."1.1.5"
      self.by-version."chownr"."0.0.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."rimraf"."2.2.5"
      self.by-version."retry"."0.6.0"
      self.by-version."couch-login"."0.1.19"
      self.by-version."npmlog"."0.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-registry-client"."~0.3.2" =
    self.by-version."npm-registry-client"."0.3.3";
  by-version."npm-registry-client"."0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.3.3.tgz";
        name = "npm-registry-client-0.3.3.tgz";
        sha1 = "da08bb681fb24aa5c988ca71f8c10f27f09daf4a";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client" or []);
    deps = [
      self.by-version."request"."2.30.0"
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."semver"."2.2.1"
      self.by-version."slide"."1.1.5"
      self.by-version."chownr"."0.0.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."rimraf"."2.2.5"
      self.by-version."retry"."0.6.0"
      self.by-version."couch-login"."0.1.19"
      self.by-version."npmlog"."0.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  by-spec."npm-user-validate"."0.0.3" =
    self.by-version."npm-user-validate"."0.0.3";
  by-version."npm-user-validate"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "npm-user-validate-0.0.3";
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
    self.by-version."npm2nix"."5.4.2";
  by-version."npm2nix"."5.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "npm2nix-5.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm2nix/-/npm2nix-5.4.2.tgz";
        name = "npm2nix-5.4.2.tgz";
        sha1 = "03184775d310c75117c82303eecb50f6b26f93d0";
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
      self.by-version."findit"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm2nix" ];
  };
  "npm2nix" = self.by-version."npm2nix"."5.4.2";
  by-spec."npmconf"."0.0.24" =
    self.by-version."npmconf"."0.0.24";
  by-version."npmconf"."0.0.24" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.0.24";
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
      self.by-version."nopt"."2.1.2"
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
    name = "npmconf-0.1.1";
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
      self.by-version."nopt"."2.1.2"
      self.by-version."semver"."2.2.1"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."~0.1.2" =
    self.by-version."npmconf"."0.1.9";
  by-version."npmconf"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.9.tgz";
        name = "npmconf-0.1.9.tgz";
        sha1 = "a6b256fdd23e347ef2465a2e6d57a9be4deb898f";
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
      self.by-version."nopt"."2.1.2"
      self.by-version."semver"."2.2.1"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  by-spec."npmconf"."~0.1.7" =
    self.by-version."npmconf"."0.1.9";
  by-spec."npmlog"."*" =
    self.by-version."npmlog"."0.0.6";
  by-version."npmlog"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.6";
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
    name = "nssocket-0.5.1";
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
  by-spec."oauth"."https://github.com/ciaranj/node-oauth/tarball/master" =
    self.by-version."oauth"."0.9.10";
  by-version."oauth"."0.9.10" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-0.9.10";
    src = [
      (fetchurl {
        url = "https://github.com/ciaranj/node-oauth/tarball/master";
        name = "oauth-0.9.10.tgz";
        sha256 = "c0c59efccbd34819ed51e912bc74b872e812a0157784dc8604434378a14cf64a";
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
    name = "oauth-sign-0.2.0";
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
    name = "oauth-sign-0.3.0";
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
    name = "object-additions-0.5.1";
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
  by-spec."object-keys"."~0.2.0" =
    self.by-version."object-keys"."0.2.0";
  by-version."object-keys"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-keys-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-keys/-/object-keys-0.2.0.tgz";
        name = "object-keys-0.2.0.tgz";
        sha1 = "cddec02998b091be42bf1035ae32e49f1cb6ea67";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-keys" or []);
    deps = [
      self.by-version."foreach"."2.0.4"
      self.by-version."indexof"."0.0.1"
      self.by-version."is"."0.2.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "object-keys" ];
  };
  by-spec."once"."1.1.1" =
    self.by-version."once"."1.1.1";
  by-version."once"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.1.1";
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
    name = "once-1.3.0";
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
    name = "open-0.0.2";
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
    name = "open-0.0.4";
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
    name = "openid-0.5.5";
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
    self.by-version."optimist"."0.6.0";
  by-version."optimist"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.6.0";
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
      self.by-version."minimist"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  "optimist" = self.by-version."optimist"."0.6.0";
  by-spec."optimist"."0.2" =
    self.by-version."optimist"."0.2.8";
  by-version."optimist"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.2.8";
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
    name = "optimist-0.3.7";
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
  by-spec."optimist"."~0.3" =
    self.by-version."optimist"."0.3.7";
  by-spec."optimist"."~0.3.4" =
    self.by-version."optimist"."0.3.7";
  by-spec."optimist"."~0.3.5" =
    self.by-version."optimist"."0.3.7";
  by-spec."optimist"."~0.6.0" =
    self.by-version."optimist"."0.6.0";
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.5";
  by-version."options"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "options-0.0.5";
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
    name = "optjs-3.2.1-boom";
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
    name = "optparse-1.0.5";
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
  by-spec."osenv"."0" =
    self.by-version."osenv"."0.0.3";
  by-version."osenv"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.0.3";
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
  by-spec."owl-deepcopy"."*" =
    self.by-version."owl-deepcopy"."0.0.2";
  by-version."owl-deepcopy"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "owl-deepcopy-0.0.2";
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
    name = "p-throttler-0.0.1";
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
  by-spec."passport"."*" =
    self.by-version."passport"."0.1.17";
  by-version."passport"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.17.tgz";
        name = "passport-0.1.17.tgz";
        sha1 = "2cd503be0d35f33a9726d00ad2654786643a23fc";
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
  "passport" = self.by-version."passport"."0.1.17";
  by-spec."passport"."0.1.17" =
    self.by-version."passport"."0.1.17";
  by-spec."passport"."~0.1.1" =
    self.by-version."passport"."0.1.17";
  by-spec."passport"."~0.1.3" =
    self.by-version."passport"."0.1.17";
  by-spec."passport-http"."*" =
    self.by-version."passport-http"."0.2.2";
  by-version."passport-http"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "passport-http-0.2.2";
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
      self.by-version."passport"."0.1.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-http" ];
  };
  "passport-http" = self.by-version."passport-http"."0.2.2";
  by-spec."passport-local"."*" =
    self.by-version."passport-local"."0.1.6";
  by-version."passport-local"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "passport-local-0.1.6";
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
      self.by-version."passport"."0.1.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-local" ];
  };
  "passport-local" = self.by-version."passport-local"."0.1.6";
  by-spec."passport-local"."0.1.6" =
    self.by-version."passport-local"."0.1.6";
  by-spec."path-is-inside"."~1.0.0" =
    self.by-version."path-is-inside"."1.0.0";
  by-version."path-is-inside"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "path-is-inside-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.0.tgz";
        name = "path-is-inside-1.0.0.tgz";
        sha1 = "8ec1c42a4c1a039e3e75f6e9e6029bd0c699016e";
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
  by-spec."pause"."0.0.1" =
    self.by-version."pause"."0.0.1";
  by-version."pause"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "pause-0.0.1";
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
    self.by-version."phantomjs"."1.9.2-6";
  by-version."phantomjs"."1.9.2-6" = lib.makeOverridable self.buildNodePackage {
    name = "phantomjs-1.9.2-6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/phantomjs/-/phantomjs-1.9.2-6.tgz";
        name = "phantomjs-1.9.2-6.tgz";
        sha1 = "71db87e5275489570560a744dbaa649c2f9da0a0";
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
      self.by-version."rimraf"."2.2.5"
      self.by-version."which"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "phantomjs" ];
  };
  by-spec."pkginfo"."0.2.x" =
    self.by-version."pkginfo"."0.2.3";
  by-version."pkginfo"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.2.3";
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
    name = "pkginfo-0.3.0";
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
    self.by-version."plist-native"."0.2.2";
  by-version."plist-native"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "plist-native-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plist-native/-/plist-native-0.2.2.tgz";
        name = "plist-native-0.2.2.tgz";
        sha1 = "6abde856b07a52f0d6bc027f7750f4d97ff93858";
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
  "plist-native" = self.by-version."plist-native"."0.2.2";
  by-spec."policyfile"."0.0.4" =
    self.by-version."policyfile"."0.0.4";
  by-version."policyfile"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "policyfile-0.0.4";
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
    name = "posix-1.0.3";
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
    name = "posix-getopt-1.0.0";
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
  by-spec."promise"."~2.0" =
    self.by-version."promise"."2.0.0";
  by-version."promise"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "promise-2.0.0";
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
    name = "prompt-0.2.11";
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
    name = "promptly-0.2.0";
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
    self.by-version."promzard"."0.2.0";
  by-version."promzard"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "promzard-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promzard/-/promzard-0.2.0.tgz";
        name = "promzard-0.2.0.tgz";
        sha1 = "766f33807faadeeecacf8057024fe5f753cfa3c1";
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
    name = "proto-list-1.2.2";
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
    self.by-version."protobufjs"."2.0.1";
  by-version."protobufjs"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "protobufjs-2.0.1";
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/protobufjs/-/protobufjs-2.0.1.tgz";
        name = "protobufjs-2.0.1.tgz";
        sha1 = "636e8c4a9e0488fbc9c8898c044d844884f8fd96";
      })
    ];
    buildInputs =
      (self.nativeDeps."protobufjs" or []);
    deps = [
      self.by-version."bytebuffer"."2.1.0"
      self.by-version."ascli"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "protobufjs" ];
  };
  by-spec."ps-tree"."0.0.x" =
    self.by-version."ps-tree"."0.0.3";
  by-version."ps-tree"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "ps-tree-0.0.3";
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
    self.by-version."punycode"."1.2.3";
  by-version."punycode"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "punycode-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.2.3.tgz";
        name = "punycode-1.2.3.tgz";
        sha1 = "b4e304471082d783c73b3bafabf2fd9b6a486266";
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
    self.by-version."punycode"."1.2.3";
  by-spec."q".">= 0.0.1" =
    self.by-version."q"."0.9.7";
  by-version."q"."0.9.7" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
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
  by-spec."q"."~0.9" =
    self.by-version."q"."0.9.7";
  by-spec."q"."~0.9.2" =
    self.by-version."q"."0.9.7";
  by-spec."q"."~0.9.6" =
    self.by-version."q"."0.9.7";
  by-spec."q"."~0.9.7" =
    self.by-version."q"."0.9.7";
  by-spec."qs"."0.4.2" =
    self.by-version."qs"."0.4.2";
  by-version."qs"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.4.2";
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
    name = "qs-0.5.1";
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
    name = "qs-0.5.2";
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
    name = "qs-0.5.5";
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
    name = "qs-0.6.5";
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
    name = "qs-0.6.6";
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
    name = "qs-0.5.6";
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
  by-spec."rai"."~0.1" =
    self.by-version."rai"."0.1.9";
  by-version."rai"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "rai-0.1.9";
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
    name = "range-parser-0.0.4";
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
  by-spec."raven"."~0.6.0" =
    self.by-version."raven"."0.6.0";
  by-version."raven"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "raven-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raven/-/raven-0.6.0.tgz";
        name = "raven-0.6.0.tgz";
        sha1 = "440aa58143e95760cb7b73b7b23b3429ca9b5576";
      })
    ];
    buildInputs =
      (self.nativeDeps."raven" or []);
    deps = [
      self.by-version."node-uuid"."1.4.0"
      self.by-version."raw-stacktrace"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raven" ];
  };
  by-spec."raw-body"."0.0.3" =
    self.by-version."raw-body"."0.0.3";
  by-version."raw-body"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "raw-body-0.0.3";
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
    name = "raw-body-1.1.2";
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
  by-spec."raw-socket"."*" =
    self.by-version."raw-socket"."1.2.2";
  by-version."raw-socket"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "raw-socket-1.2.2";
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
  by-spec."raw-stacktrace"."1.0.0" =
    self.by-version."raw-stacktrace"."1.0.0";
  by-version."raw-stacktrace"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "raw-stacktrace-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-stacktrace/-/raw-stacktrace-1.0.0.tgz";
        name = "raw-stacktrace-1.0.0.tgz";
        sha1 = "f308881f17667785a9acd7c8fbd442e1b2acf1db";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-stacktrace" or []);
    deps = [
      self.by-version."traceback"."0.3.0"
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-stacktrace" ];
  };
  by-spec."rbytes"."*" =
    self.by-version."rbytes"."1.0.0";
  by-version."rbytes"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "rbytes-1.0.0";
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
    self.by-version."rc"."0.3.2";
  by-version."rc"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.3.2.tgz";
        name = "rc-0.3.2.tgz";
        sha1 = "cd8f895690f764621ccec110516b225286e8f69f";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc" or []);
    deps = [
      self.by-version."optimist"."0.3.7"
      self.by-version."deep-extend"."0.2.6"
      self.by-version."ini"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  by-spec."rc"."~0.3.1" =
    self.by-version."rc"."0.3.2";
  by-spec."read"."1" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
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
    name = "read-installed-0.2.2";
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
      self.by-version."read-package-json"."1.1.4"
      self.by-version."graceful-fs"."1.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
  by-spec."read-installed"."~0.2.2" =
    self.by-version."read-installed"."0.2.5";
  by-version."read-installed"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "read-installed-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-installed/-/read-installed-0.2.5.tgz";
        name = "read-installed-0.2.5.tgz";
        sha1 = "134df8b326d8b54b11e18f7dd8c81bf5e976ef86";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-installed" or []);
    deps = [
      self.by-version."semver"."2.2.1"
      self.by-version."slide"."1.1.5"
      self.by-version."read-package-json"."1.1.4"
      self.by-version."graceful-fs"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
  by-spec."read-package-json"."1" =
    self.by-version."read-package-json"."1.1.4";
  by-version."read-package-json"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "read-package-json-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.1.4.tgz";
        name = "read-package-json-1.1.4.tgz";
        sha1 = "c4effa9fac527deaee1cd84659c419693aa5294a";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json" or []);
    deps = [
      self.by-version."glob"."3.2.7"
      self.by-version."lru-cache"."2.5.0"
      self.by-version."normalize-package-data"."0.2.8"
      self.by-version."graceful-fs"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  by-spec."read-package-json"."~1.1.4" =
    self.by-version."read-package-json"."1.1.4";
  by-spec."readable-stream"."1.0" =
    self.by-version."readable-stream"."1.0.17";
  by-version."readable-stream"."1.0.17" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.17.tgz";
        name = "readable-stream-1.0.17.tgz";
        sha1 = "cbc295fdf394dfa1225d225d02e6b6d0f409fd4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."~1.0.2" =
    self.by-version."readable-stream"."1.0.17";
  by-spec."readable-stream"."~1.1.8" =
    self.by-version."readable-stream"."1.1.9";
  by-version."readable-stream"."1.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.9.tgz";
        name = "readable-stream-1.1.9.tgz";
        sha1 = "d87130fbf8f9ee9c3b4058b3c58a3e30db2fcfdd";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = [
      self.by-version."core-util-is"."1.0.0"
      self.by-version."debuglog"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.9";
  by-spec."readdirp"."~0.2.3" =
    self.by-version."readdirp"."0.2.5";
  by-version."readdirp"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "readdirp-0.2.5";
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
  by-spec."redeyed"."~0.4.0" =
    self.by-version."redeyed"."0.4.2";
  by-version."redeyed"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "redeyed-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redeyed/-/redeyed-0.4.2.tgz";
        name = "redeyed-0.4.2.tgz";
        sha1 = "f0133b990cb972bdbcf2d2dce0aec36595f419bc";
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
    self.by-version."redis"."0.10.0";
  by-version."redis"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.10.0.tgz";
        name = "redis-0.10.0.tgz";
        sha1 = "76864475f71a745cbc3bbb27d794a6d01a96505c";
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
  "redis" = self.by-version."redis"."0.10.0";
  by-spec."redis"."0.7.2" =
    self.by-version."redis"."0.7.2";
  by-version."redis"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.7.2";
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
    name = "redis-0.7.3";
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
    name = "redis-0.8.6";
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
  by-spec."redis".">= 0.6.6" =
    self.by-version."redis"."0.10.0";
  by-spec."reds"."0.1.4" =
    self.by-version."reds"."0.1.4";
  by-version."reds"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "reds-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/reds/-/reds-0.1.4.tgz";
        name = "reds-0.1.4.tgz";
        sha1 = "a97819180c30f6ecd01cad03cecb574eaabb4bee";
      })
    ];
    buildInputs =
      (self.nativeDeps."reds" or []);
    deps = [
      self.by-version."natural"."0.0.69"
      self.by-version."redis"."0.10.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "reds" ];
  };
  by-spec."reduce-component"."1.0.1" =
    self.by-version."reduce-component"."1.0.1";
  by-version."reduce-component"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "reduce-component-1.0.1";
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
    name = "regexp-clone-0.0.1";
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
    self.by-version."replace"."0.2.7";
  by-version."replace"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "replace-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/replace/-/replace-0.2.7.tgz";
        name = "replace-0.2.7.tgz";
        sha1 = "e22d08a9e2e6764337bb530166a4dd89c2558fda";
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
    self.by-version."request"."2.30.0";
  by-version."request"."2.30.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.30.0";
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
      self.by-version."forever-agent"."0.5.0"
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
  by-spec."request"."2 >=2.20.0" =
    self.by-version."request"."2.30.0";
  by-spec."request"."2 >=2.25.0" =
    self.by-version."request"."2.30.0";
  by-spec."request"."2.16.2" =
    self.by-version."request"."2.16.2";
  by-version."request"."2.16.2" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.16.2";
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
    name = "request-2.16.6";
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
    name = "request-2.9.203";
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
  by-spec."request".">=2.12.0" =
    self.by-version."request"."2.30.0";
  by-spec."request"."~2" =
    self.by-version."request"."2.30.0";
  by-spec."request"."~2.21.0" =
    self.by-version."request"."2.21.0";
  by-version."request"."2.21.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.21.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.21.0.tgz";
        name = "request-2.21.0.tgz";
        sha1 = "5728ab9c45e5a87c99daccd530298b6673a868d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."4.0.0"
      self.by-version."forever-agent"."0.5.0"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.9.11"
      self.by-version."hawk"."0.13.1"
      self.by-version."aws-sign"."0.3.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."cookie-jar"."0.3.0"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."form-data"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.25.0" =
    self.by-version."request"."2.25.0";
  by-version."request"."2.25.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.25.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.25.0.tgz";
        name = "request-2.25.0.tgz";
        sha1 = "dac1673181887fe0b2ce6bd7e12f46d554a02ce9";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.0"
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
  by-spec."request"."~2.27.0" =
    self.by-version."request"."2.27.0";
  by-version."request"."2.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
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
      self.by-version."forever-agent"."0.5.0"
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
  by-spec."request"."~2.29.0" =
    self.by-version."request"."2.29.0";
  by-version."request"."2.29.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.29.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.29.0.tgz";
        name = "request-2.29.0.tgz";
        sha1 = "0d4b8de70d26a9911a8344af9a0e8edab81ff1c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.0"
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
  by-spec."request"."~2.30.0" =
    self.by-version."request"."2.30.0";
  by-spec."request-progress"."~0.3.0" =
    self.by-version."request-progress"."0.3.1";
  by-version."request-progress"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "request-progress-0.3.1";
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
    name = "request-replay-0.2.0";
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
    self.by-version."requirejs"."2.1.9";
  by-version."requirejs"."2.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "requirejs-2.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/requirejs/-/requirejs-2.1.9.tgz";
        name = "requirejs-2.1.9.tgz";
        sha1 = "624e10d22863e8db9aebfb8f21809ca59da42344";
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
    self.by-version."requirejs"."2.1.9";
  by-spec."resolve"."0.5.x" =
    self.by-version."resolve"."0.5.1";
  by-version."resolve"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.5.1.tgz";
        name = "resolve-0.5.1.tgz";
        sha1 = "15e4a222c4236bcd4cf85454412c2d0fb6524576";
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
  by-version."resolve"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.3.1";
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
    self.by-version."rethinkdb"."1.11.0-1";
  by-version."rethinkdb"."1.11.0-1" = lib.makeOverridable self.buildNodePackage {
    name = "rethinkdb-1.11.0-1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rethinkdb/-/rethinkdb-1.11.0-1.tgz";
        name = "rethinkdb-1.11.0-1.tgz";
        sha1 = "beab3376b9efa9ecf7f2fbf39c58ce80c8bd5dfd";
      })
    ];
    buildInputs =
      (self.nativeDeps."rethinkdb" or []);
    deps = [
      self.by-version."protobufjs"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rethinkdb" ];
  };
  "rethinkdb" = self.by-version."rethinkdb"."1.11.0-1";
  by-spec."retry"."0.6.0" =
    self.by-version."retry"."0.6.0";
  by-version."retry"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "retry-0.6.0";
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
    name = "revalidator-0.1.6";
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
  by-spec."rimraf"."1.x.x" =
    self.by-version."rimraf"."1.0.9";
  by-version."rimraf"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-1.0.9";
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
    self.by-version."rimraf"."2.2.5";
  by-version."rimraf"."2.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.5.tgz";
        name = "rimraf-2.2.5.tgz";
        sha1 = "4e5c4f667b121afa806d0c5b58920996f9478aa0";
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
    self.by-version."rimraf"."2.2.5";
  by-spec."rimraf"."~2" =
    self.by-version."rimraf"."2.2.5";
  by-spec."rimraf"."~2.0.2" =
    self.by-version."rimraf"."2.0.3";
  by-version."rimraf"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.0.3";
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
  by-spec."rimraf"."~2.0.3" =
    self.by-version."rimraf"."2.0.3";
  by-spec."rimraf"."~2.1" =
    self.by-version."rimraf"."2.1.4";
  by-version."rimraf"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.1.4";
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
  by-spec."rimraf"."~2.1.4" =
    self.by-version."rimraf"."2.1.4";
  by-spec."rimraf"."~2.2.0" =
    self.by-version."rimraf"."2.2.5";
  by-spec."rimraf"."~2.2.2" =
    self.by-version."rimraf"."2.2.5";
  by-spec."rimraf"."~2.2.5" =
    self.by-version."rimraf"."2.2.5";
  by-spec."s3http"."*" =
    self.by-version."s3http"."0.0.3";
  by-version."s3http"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "s3http-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/s3http/-/s3http-0.0.3.tgz";
        name = "s3http-0.0.3.tgz";
        sha1 = "4d8965ae1c62c7fc2bbdc3fb6b95067429aac87a";
      })
    ];
    buildInputs =
      (self.nativeDeps."s3http" or []);
    deps = [
      self.by-version."aws-sdk"."1.16.0"
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
  "s3http" = self.by-version."s3http"."0.0.3";
  by-spec."sauce-connect-launcher"."~0.2.2" =
    self.by-version."sauce-connect-launcher"."0.2.2";
  by-version."sauce-connect-launcher"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "sauce-connect-launcher-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sauce-connect-launcher/-/sauce-connect-launcher-0.2.2.tgz";
        name = "sauce-connect-launcher-0.2.2.tgz";
        sha1 = "cfd951c8b488af38d384aef14920261482e2e05a";
      })
    ];
    buildInputs =
      (self.nativeDeps."sauce-connect-launcher" or []);
    deps = [
      self.by-version."lodash"."1.3.1"
      self.by-version."async"."0.2.9"
      self.by-version."adm-zip"."0.4.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sauce-connect-launcher" ];
  };
  by-spec."saucelabs"."~0.1.0" =
    self.by-version."saucelabs"."0.1.1";
  by-version."saucelabs"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "saucelabs-0.1.1";
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
    name = "sax-0.5.8";
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
    self.by-version."sax"."0.5.8";
  by-spec."selenium-webdriver"."*" =
    self.by-version."selenium-webdriver"."2.39.0";
  by-version."selenium-webdriver"."2.39.0" = lib.makeOverridable self.buildNodePackage {
    name = "selenium-webdriver-2.39.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/selenium-webdriver/-/selenium-webdriver-2.39.0.tgz";
        name = "selenium-webdriver-2.39.0.tgz";
        sha1 = "546225f2f4f53f1f490a3077e5f14092fad3d205";
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
  "selenium-webdriver" = self.by-version."selenium-webdriver"."2.39.0";
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
    self.by-version."send"."0.1.4";
  by-version."send"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.4";
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
  by-spec."send"."0.0.3" =
    self.by-version."send"."0.0.3";
  by-version."send"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.0.3";
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
    name = "send-0.1.0";
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
  by-spec."sequence"."*" =
    self.by-version."sequence"."2.2.1";
  by-version."sequence"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "sequence-2.2.1";
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
  by-spec."sequence".">= 2.2.1" =
    self.by-version."sequence"."2.2.1";
  by-spec."sha"."~1.2.1" =
    self.by-version."sha"."1.2.3";
  by-version."sha"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "sha-1.2.3";
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
      self.by-version."graceful-fs"."2.0.1"
      self.by-version."readable-stream"."1.0.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
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
  by-spec."shelljs"."~0.1.4" =
    self.by-version."shelljs"."0.1.4";
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
    self.by-version."should"."2.1.1";
  by-version."should"."2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "should-2.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should/-/should-2.1.1.tgz";
        name = "should-2.1.1.tgz";
        sha1 = "c648b13a8b464465c2f838ea0c93f12e4ae06c6b";
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
  "should" = self.by-version."should"."2.1.1";
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.0";
  by-version."sigmund"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "sigmund-1.0.0";
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
    name = "signals-1.0.0";
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
    name = "simple-lru-cache-0.0.1";
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
    self.by-version."simplesmtp"."0.3.16";
  by-version."simplesmtp"."0.3.16" = lib.makeOverridable self.buildNodePackage {
    name = "simplesmtp-0.3.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/simplesmtp/-/simplesmtp-0.3.16.tgz";
        name = "simplesmtp-0.3.16.tgz";
        sha1 = "c82ab64b957a5f979b10b96787094e3612877814";
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
    name = "sliced-0.0.3";
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
    name = "sliced-0.0.4";
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
    name = "sliced-0.0.5";
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
    name = "slide-1.1.5";
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
    self.by-version."smartdc"."7.1.2";
  by-version."smartdc"."7.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-7.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc/-/smartdc-7.1.2.tgz";
        name = "smartdc-7.1.2.tgz";
        sha1 = "11228af972ed5014d3798202ecc370e02f007872";
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
  "smartdc" = self.by-version."smartdc"."7.1.2";
  by-spec."smartdc-auth"."1.0.1" =
    self.by-version."smartdc-auth"."1.0.1";
  by-version."smartdc-auth"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-auth-1.0.1";
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
    name = "sntp-0.1.4";
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
    name = "sntp-0.2.4";
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
    name = "socket.io-0.9.14";
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
    name = "socket.io-0.9.16";
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
  by-spec."socket.io"."~0.9.14" =
    self.by-version."socket.io"."0.9.16";
  by-spec."socket.io-client"."0.9.11" =
    self.by-version."socket.io-client"."0.9.11";
  by-version."socket.io-client"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-client-0.9.11";
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
    name = "socket.io-client-0.9.16";
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
    name = "sockjs-0.3.8";
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
  by-spec."source-map"."*" =
    self.by-version."source-map"."0.1.31";
  by-version."source-map"."0.1.31" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.31";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.31.tgz";
        name = "source-map-0.1.31.tgz";
        sha1 = "9f704d0d69d9e138a81badf6ebb4fde33d151c61";
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
  "source-map" = self.by-version."source-map"."0.1.31";
  by-spec."source-map"."0.1.x" =
    self.by-version."source-map"."0.1.31";
  by-spec."source-map".">= 0.1.2" =
    self.by-version."source-map"."0.1.31";
  by-spec."source-map"."~0.1.30" =
    self.by-version."source-map"."0.1.31";
  by-spec."source-map"."~0.1.7" =
    self.by-version."source-map"."0.1.31";
  by-spec."spdy"."1.7.1" =
    self.by-version."spdy"."1.7.1";
  by-version."spdy"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "spdy-1.7.1";
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
  by-spec."ssh2"."~0.2.14" =
    self.by-version."ssh2"."0.2.14";
  by-version."ssh2"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "ssh2-0.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ssh2/-/ssh2-0.2.14.tgz";
        name = "ssh2-0.2.14.tgz";
        sha1 = "6f93df62f1475cbe5b45924da568643b9ac7388a";
      })
    ];
    buildInputs =
      (self.nativeDeps."ssh2" or []);
    deps = [
      self.by-version."streamsearch"."0.1.2"
      self.by-version."asn1"."0.1.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ssh2" ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.7";
  by-version."stack-trace"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "stack-trace-0.0.7";
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
  by-spec."statsd"."*" =
    self.by-version."statsd"."0.7.0";
  by-version."statsd"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "statsd-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd/-/statsd-0.7.0.tgz";
        name = "statsd-0.7.0.tgz";
        sha1 = "13354345392c50a30221d3ab524bffcdda90272e";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd" or []);
    deps = [
      self.by-version."node-syslog"."1.1.7"
      self.by-version."hashring"."1.0.1"
      self.by-version."winser"."0.0.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "statsd" ];
  };
  "statsd" = self.by-version."statsd"."0.7.0";
  by-spec."stream-combiner"."~0.0.2" =
    self.by-version."stream-combiner"."0.0.4";
  by-version."stream-combiner"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "stream-combiner-0.0.4";
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
    name = "stream-counter-0.1.0";
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
      self.by-version."readable-stream"."1.0.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."stream-counter"."~0.2.0" =
    self.by-version."stream-counter"."0.2.0";
  by-version."stream-counter"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-counter-0.2.0";
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
      self.by-version."readable-stream"."1.1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."stream-splitter-transform"."*" =
    self.by-version."stream-splitter-transform"."0.0.4";
  by-version."stream-splitter-transform"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "stream-splitter-transform-0.0.4";
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
  by-spec."streamsearch"."0.1.2" =
    self.by-version."streamsearch"."0.1.2";
  by-version."streamsearch"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "streamsearch-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/streamsearch/-/streamsearch-0.1.2.tgz";
        name = "streamsearch-0.1.2.tgz";
        sha1 = "808b9d0e56fc273d809ba57338e929919a1a9f1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."streamsearch" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "streamsearch" ];
  };
  by-spec."string"."1.6.1" =
    self.by-version."string"."1.6.1";
  by-version."string"."1.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "string-1.6.1";
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
  by-spec."stringify-object"."~0.1.4" =
    self.by-version."stringify-object"."0.1.7";
  by-version."stringify-object"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "stringify-object-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringify-object/-/stringify-object-0.1.7.tgz";
        name = "stringify-object-0.1.7.tgz";
        sha1 = "bb54d1ceed118b428c1256742b40a53f03599581";
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
    self.by-version."strong-data-uri"."0.1.0";
  by-version."strong-data-uri"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "strong-data-uri-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strong-data-uri/-/strong-data-uri-0.1.0.tgz";
        name = "strong-data-uri-0.1.0.tgz";
        sha1 = "a41235806b8c3bf0f6f324dc57dfe85bbab681a0";
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
    self.by-version."stylus"."0.41.3";
  by-version."stylus"."0.41.3" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.41.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.41.3.tgz";
        name = "stylus-0.41.3.tgz";
        sha1 = "0a49c3f2f4f6b6719e7cca823052b9df87acaeb7";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus" or []);
    deps = [
      self.by-version."cssom"."0.2.5"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."debug"."0.7.4"
      self.by-version."sax"."0.5.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  "stylus" = self.by-version."stylus"."0.41.3";
  by-spec."stylus"."0.27.2" =
    self.by-version."stylus"."0.27.2";
  by-version."stylus"."0.27.2" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.27.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.27.2.tgz";
        name = "stylus-0.27.2.tgz";
        sha1 = "1121f7f8cd152b0f8a4aa6a24a9adea10c825117";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus" or []);
    deps = [
      self.by-version."cssom"."0.2.5"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."debug"."0.7.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  by-spec."sudo-block"."~0.2.0" =
    self.by-version."sudo-block"."0.2.1";
  by-version."sudo-block"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "sudo-block-0.2.1";
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
    name = "sudo-block-0.3.0";
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
  by-spec."superagent"."0.15.7" =
    self.by-version."superagent"."0.15.7";
  by-version."superagent"."0.15.7" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.15.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.15.7.tgz";
        name = "superagent-0.15.7.tgz";
        sha1 = "095c70b8afffbc072f1458f39684d4854d6333a3";
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
  by-spec."superagent"."~0.13.0" =
    self.by-version."superagent"."0.13.0";
  by-version."superagent"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.13.0";
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
  by-spec."superagent"."~0.15.7" =
    self.by-version."superagent"."0.15.7";
  by-spec."supertest"."*" =
    self.by-version."supertest"."0.8.2";
  by-version."supertest"."0.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "supertest-0.8.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supertest/-/supertest-0.8.2.tgz";
        name = "supertest-0.8.2.tgz";
        sha1 = "2da3519f7c9dcfa8759e2de9c794f1d4acc0333b";
      })
    ];
    buildInputs =
      (self.nativeDeps."supertest" or []);
    deps = [
      self.by-version."superagent"."0.15.7"
      self.by-version."methods"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "supertest" ];
  };
  "supertest" = self.by-version."supertest"."0.8.2";
  by-spec."swig"."0.14.x" =
    self.by-version."swig"."0.14.0";
  by-version."swig"."0.14.0" = lib.makeOverridable self.buildNodePackage {
    name = "swig-0.14.0";
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
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "swig" ];
  };
  "swig" = self.by-version."swig"."0.14.0";
  by-spec."sylvester".">= 0.0.12" =
    self.by-version."sylvester"."0.0.21";
  by-version."sylvester"."0.0.21" = lib.makeOverridable self.buildNodePackage {
    name = "sylvester-0.0.21";
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
  by-spec."tar"."*" =
    self.by-version."tar"."0.1.19";
  by-version."tar"."0.1.19" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.19";
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
    name = "tar-0.1.17";
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
    self.by-version."temp"."0.6.0";
  by-version."temp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.6.0";
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
  "temp" = self.by-version."temp"."0.6.0";
  by-spec."temp"."0.6.0" =
    self.by-version."temp"."0.6.0";
  by-spec."temp"."~0.6.0" =
    self.by-version."temp"."0.6.0";
  by-spec."text-table"."~0.1.1" =
    self.by-version."text-table"."0.1.1";
  by-version."text-table"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "text-table-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/text-table/-/text-table-0.1.1.tgz";
        name = "text-table-0.1.1.tgz";
        sha1 = "9aa4347a39b6950cd24190264576f62db6e52d93";
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
  by-spec."text-table"."~0.2.0" =
    self.by-version."text-table"."0.2.0";
  by-version."text-table"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "text-table-0.2.0";
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
    name = "throttleit-0.0.2";
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
  by-spec."through2"."~0.1.0" =
    self.by-version."through2"."0.1.0";
  by-version."through2"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "through2-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through2/-/through2-0.1.0.tgz";
        name = "through2-0.1.0.tgz";
        sha1 = "54e756cc6a543c72bb5adf55e8a248686b84c9cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."through2" or []);
    deps = [
      self.by-version."readable-stream"."1.0.17"
      self.by-version."xtend"."2.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "through2" ];
  };
  by-spec."timespan"."~2.3.0" =
    self.by-version."timespan"."2.3.0";
  by-version."timespan"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "timespan-2.3.0";
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
    self.by-version."timezone"."0.0.23";
  by-version."timezone"."0.0.23" = lib.makeOverridable self.buildNodePackage {
    name = "timezone-0.0.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timezone/-/timezone-0.0.23.tgz";
        name = "timezone-0.0.23.tgz";
        sha1 = "5e89359e0c01c92b495c725e81ecce6ddbdb9bac";
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
  "timezone" = self.by-version."timezone"."0.0.23";
  by-spec."tinycolor"."0.x" =
    self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "tinycolor-0.0.1";
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
  by-spec."tmp"."~0.0.20" =
    self.by-version."tmp"."0.0.23";
  by-version."tmp"."0.0.23" = lib.makeOverridable self.buildNodePackage {
    name = "tmp-0.0.23";
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
    name = "touch-0.0.2";
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
  by-spec."tough-cookie"."~0.9.15" =
    self.by-version."tough-cookie"."0.9.15";
  by-version."tough-cookie"."0.9.15" = lib.makeOverridable self.buildNodePackage {
    name = "tough-cookie-0.9.15";
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
      self.by-version."punycode"."1.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
  };
  by-spec."traceback".">=0.3.0 && < 0.4" =
    self.by-version."traceback"."0.3.0";
  by-version."traceback"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "traceback-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traceback/-/traceback-0.3.0.tgz";
        name = "traceback-0.3.0.tgz";
        sha1 = "4e147f07cd332fbd0330ba510b942a5c9256a0ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."traceback" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "traceback" ];
  };
  by-spec."transformers"."2.1.0" =
    self.by-version."transformers"."2.1.0";
  by-version."transformers"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "transformers-2.1.0";
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
    name = "traverse-0.3.9";
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
    name = "truncate-1.0.2";
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
  by-spec."tunnel-agent"."~0.2.0" =
    self.by-version."tunnel-agent"."0.2.0";
  by-version."tunnel-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.2.0";
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
    name = "tunnel-agent-0.3.0";
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
    name = "type-detect-0.1.1";
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
  by-spec."typechecker"."~2.0.1" =
    self.by-version."typechecker"."2.0.8";
  by-version."typechecker"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "typechecker-2.0.8";
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
      self.by-version."async"."0.2.9"
      self.by-version."source-map"."0.1.31"
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-to-browserify"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.2.5" =
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
      self.by-version."source-map"."0.1.31"
      self.by-version."optimist"."0.3.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
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
      self.by-version."async"."0.2.9"
      self.by-version."source-map"."0.1.31"
      self.by-version."optimist"."0.3.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.4.0" =
    self.by-version."uglify-js"."2.4.8";
  by-version."uglify-js"."2.4.8" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.8.tgz";
        name = "uglify-js-2.4.8.tgz";
        sha1 = "70e33bd9bce9a27b896fd4fead4c7da434fcca09";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = [
      self.by-version."async"."0.2.9"
      self.by-version."source-map"."0.1.31"
      self.by-version."optimist"."0.3.7"
      self.by-version."uglify-to-browserify"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-to-browserify"."~1.0.0" =
    self.by-version."uglify-to-browserify"."1.0.1";
  by-version."uglify-to-browserify"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-to-browserify-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.1.tgz";
        name = "uglify-to-browserify-1.0.1.tgz";
        sha1 = "0e9ada5d4ca358a59a00bb33c8061e2f40ef97d2";
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
  by-spec."uid-number"."0" =
    self.by-version."uid-number"."0.0.3";
  by-version."uid-number"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "uid-number-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.3.tgz";
        name = "uid-number-0.0.3.tgz";
        sha1 = "cefb0fa138d8d8098da71a40a0d04a8327d6e1cc";
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
  by-spec."uid2"."0.0.2" =
    self.by-version."uid2"."0.0.2";
  by-version."uid2"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "uid2-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid2/-/uid2-0.0.2.tgz";
        name = "uid2-0.0.2.tgz";
        sha1 = "107fb155c82c1136620797ed4c88cf2b08f6aab8";
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
  by-spec."uid2"."0.0.3" =
    self.by-version."uid2"."0.0.3";
  by-version."uid2"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "uid2-0.0.3";
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
  by-spec."underscore"."*" =
    self.by-version."underscore"."1.5.2";
  by-version."underscore"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
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
  "underscore" = self.by-version."underscore"."1.5.2";
  by-spec."underscore"."1.4.x" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
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
    self.by-version."underscore"."1.5.2";
  by-spec."underscore".">=1.4.3" =
    self.by-version."underscore"."1.5.2";
  by-spec."underscore".">=1.5.x" =
    self.by-version."underscore"."1.5.2";
  by-spec."underscore"."~1.4" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.4.3" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.4.4" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore"."~1.5.2" =
    self.by-version."underscore"."1.5.2";
  by-spec."underscore.string"."~2.2.1" =
    self.by-version."underscore.string"."2.2.1";
  by-version."underscore.string"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "underscore.string-2.2.1";
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
    name = "underscore.string-2.3.3";
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
    self.by-version."unfunk-diff"."0.0.1";
  by-version."unfunk-diff"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "unfunk-diff-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/unfunk-diff/-/unfunk-diff-0.0.1.tgz";
        name = "unfunk-diff-0.0.1.tgz";
        sha1 = "fd01490b7e53bc268f069f222fda10704c8f1265";
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
    self.by-version."ungit"."0.6.0";
  by-version."ungit"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "ungit-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ungit/-/ungit-0.6.0.tgz";
        name = "ungit-0.6.0.tgz";
        sha1 = "fffc26cafc5d138bc6b3585fef3f15744f5f3d31";
      })
    ];
    buildInputs =
      (self.nativeDeps."ungit" or []);
    deps = [
      self.by-version."express"."3.4.7"
      self.by-version."superagent"."0.15.7"
      self.by-version."lodash"."2.3.0"
      self.by-version."temp"."0.6.0"
      self.by-version."socket.io"."0.9.16"
      self.by-version."moment"."2.4.0"
      self.by-version."async"."0.2.9"
      self.by-version."ssh2"."0.2.14"
      self.by-version."rc"."0.3.2"
      self.by-version."uuid"."1.4.1"
      self.by-version."winston"."0.7.2"
      self.by-version."passport"."0.1.17"
      self.by-version."passport-local"."0.1.6"
      self.by-version."npm"."1.3.22"
      self.by-version."semver"."2.2.1"
      self.by-version."forever-monitor"."1.1.0"
      self.by-version."open"."0.0.4"
      self.by-version."optimist"."0.6.0"
      self.by-version."crossroads"."0.12.0"
      self.by-version."signals"."1.0.0"
      self.by-version."hasher"."1.2.0"
      self.by-version."blueimp-md5"."1.1.0"
      self.by-version."color"."0.4.4"
      self.by-version."keen.io"."0.0.3"
      self.by-version."getmac"."1.0.6"
      self.by-version."deep-extend"."0.2.6"
      self.by-version."raven"."0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ungit" ];
  };
  "ungit" = self.by-version."ungit"."0.6.0";
  by-spec."update-notifier"."~0.1.3" =
    self.by-version."update-notifier"."0.1.7";
  by-version."update-notifier"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "update-notifier-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.1.7.tgz";
        name = "update-notifier-0.1.7.tgz";
        sha1 = "b37fb55004835240fd2e7e360c52ccffde5219c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier" or []);
    deps = [
      self.by-version."request"."2.27.0"
      self.by-version."configstore"."0.1.7"
      self.by-version."semver"."2.1.0"
      self.by-version."chalk"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  by-spec."update-notifier"."~0.1.5" =
    self.by-version."update-notifier"."0.1.7";
  by-spec."useragent"."~2.0.4" =
    self.by-version."useragent"."2.0.7";
  by-version."useragent"."2.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "useragent-2.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/useragent/-/useragent-2.0.7.tgz";
        name = "useragent-2.0.7.tgz";
        sha1 = "a44c07d157a15e13d73d4af4ece6aab70f298224";
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
  by-spec."util"."0.10.2" =
    self.by-version."util"."0.10.2";
  by-version."util"."0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "util-0.10.2";
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
    name = "util-0.4.9";
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
  by-spec."utile"."0.1.x" =
    self.by-version."utile"."0.1.7";
  by-version."utile"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.1.7";
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
      self.by-version."deep-equal"."0.1.2"
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
    name = "utile-0.2.1";
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
      self.by-version."async"."0.2.9"
      self.by-version."deep-equal"."0.1.2"
      self.by-version."i"."0.3.2"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."ncp"."0.4.2"
      self.by-version."rimraf"."2.2.5"
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
  by-spec."uuid"."1.4.1" =
    self.by-version."uuid"."1.4.1";
  by-version."uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "uuid-1.4.1";
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
  by-spec."validator"."0.4.x" =
    self.by-version."validator"."0.4.28";
  by-version."validator"."0.4.28" = lib.makeOverridable self.buildNodePackage {
    name = "validator-0.4.28";
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
    name = "vargs-0.1.0";
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
    name = "vasync-1.3.3";
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
    name = "verror-1.1.0";
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
    name = "verror-1.3.3";
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
    name = "verror-1.3.6";
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
  by-spec."view-helpers"."*" =
    self.by-version."view-helpers"."0.1.3";
  by-version."view-helpers"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "view-helpers-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/view-helpers/-/view-helpers-0.1.3.tgz";
        name = "view-helpers-0.1.3.tgz";
        sha1 = "97b061548a753eff5b432e6c1598cb10417bff02";
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
  "view-helpers" = self.by-version."view-helpers"."0.1.3";
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
    self.by-version."walk"."2.2.1";
  by-version."walk"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "walk-2.2.1";
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
      self.by-version."forEachAsync"."2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
  };
  "walk" = self.by-version."walk"."2.2.1";
  by-spec."walk"."~2.2.1" =
    self.by-version."walk"."2.2.1";
  by-spec."watch"."0.5.x" =
    self.by-version."watch"."0.5.1";
  by-version."watch"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "watch-0.5.1";
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
    name = "watch-0.8.0";
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
  by-spec."wd"."~0.2.8" =
    self.by-version."wd"."0.2.8";
  by-version."wd"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "wd-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wd/-/wd-0.2.8.tgz";
        name = "wd-0.2.8.tgz";
        sha1 = "397ccb8058e72af3ae6e7c485f4368f4fb514631";
      })
    ];
    buildInputs =
      (self.nativeDeps."wd" or []);
    deps = [
      self.by-version."async"."0.2.9"
      self.by-version."vargs"."0.1.0"
      self.by-version."q"."0.9.7"
      self.by-version."request"."2.21.0"
      self.by-version."archiver"."0.4.10"
      self.by-version."lodash"."1.3.1"
      self.by-version."underscore.string"."2.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wd" ];
  };
  by-spec."webdrvr"."*" =
    self.by-version."webdrvr"."2.38.0-0";
  by-version."webdrvr"."2.38.0-0" = lib.makeOverridable self.buildNodePackage {
    name = "webdrvr-2.38.0-0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/webdrvr/-/webdrvr-2.38.0-0.tgz";
        name = "webdrvr-2.38.0-0.tgz";
        sha1 = "b5388a672ac512e09df24d00f80b3d619dc15e5c";
      })
    ];
    buildInputs =
      (self.nativeDeps."webdrvr" or []);
    deps = [
      self.by-version."adm-zip"."0.4.3"
      self.by-version."kew"."0.1.7"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."npmconf"."0.1.9"
      self.by-version."phantomjs"."1.9.2-6"
      self.by-version."tmp"."0.0.23"
      self.by-version."follow-redirects"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "webdrvr" ];
  };
  "webdrvr" = self.by-version."webdrvr"."2.38.0-0";
  by-spec."websocket-driver".">=0.3.0" =
    self.by-version."websocket-driver"."0.3.1";
  by-version."websocket-driver"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "websocket-driver-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.3.1.tgz";
        name = "websocket-driver-0.3.1.tgz";
        sha1 = "25f86b4e7ca9d8f8136cd225ffcee71a3d2869cf";
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
    self.by-version."websocket-driver"."0.3.1";
  by-spec."when"."~2.2.1" =
    self.by-version."when"."2.2.1";
  by-version."when"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "when-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/when/-/when-2.2.1.tgz";
        name = "when-2.2.1.tgz";
        sha1 = "b1def994017350b8087f6e9a7596ab2833bdc712";
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
  by-spec."which"."*" =
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
  by-spec."which"."1" =
    self.by-version."which"."1.0.5";
  by-spec."which"."1.0.x" =
    self.by-version."which"."1.0.5";
  by-spec."which"."~1.0.5" =
    self.by-version."which"."1.0.5";
  by-spec."winser"."=0.0.11" =
    self.by-version."winser"."0.0.11";
  by-version."winser"."0.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "winser-0.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winser/-/winser-0.0.11.tgz";
        name = "winser-0.0.11.tgz";
        sha1 = "38474086a89ac72f90f9c6762e23375d12046c7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."winser" or []);
    deps = [
      self.by-version."sequence"."2.2.1"
      self.by-version."commander"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winser" ];
  };
  by-spec."winston"."*" =
    self.by-version."winston"."0.7.2";
  by-version."winston"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.7.2";
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
      self.by-version."async"."0.2.9"
      self.by-version."colors"."0.6.2"
      self.by-version."cycle"."1.0.3"
      self.by-version."eyes"."0.1.8"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."request"."2.16.6"
      self.by-version."stack-trace"."0.0.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  "winston" = self.by-version."winston"."0.7.2";
  by-spec."winston"."0.6.2" =
    self.by-version."winston"."0.6.2";
  by-version."winston"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.6.2";
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
      self.by-version."stack-trace"."0.0.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."winston"."0.6.x" =
    self.by-version."winston"."0.6.2";
  by-spec."winston"."0.7.2" =
    self.by-version."winston"."0.7.2";
  by-spec."winston"."~0.7.2" =
    self.by-version."winston"."0.7.2";
  by-spec."wiredep"."~0.4.2" =
    self.by-version."wiredep"."0.4.2";
  by-version."wiredep"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "wiredep-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wiredep/-/wiredep-0.4.2.tgz";
        name = "wiredep-0.4.2.tgz";
        sha1 = "42d4cf07422576f26e3a04045edc163da101a66f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wiredep" or []);
    deps = [
      self.by-version."lodash"."1.3.1"
      self.by-version."chalk"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wiredep" ];
  };
  by-spec."with"."~2.0.0" =
    self.by-version."with"."2.0.0";
  by-version."with"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "with-2.0.0";
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
  by-spec."wordwrap"."0.0.x" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "wordwrap-0.0.2";
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
    name = "wrench-1.4.4";
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
  by-spec."wu"."*" =
    self.by-version."wu"."0.1.8";
  by-version."wu"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "wu-0.1.8";
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
    self.by-version."x509"."0.0.6";
  by-version."x509"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "x509-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/x509/-/x509-0.0.6.tgz";
        name = "x509-0.0.6.tgz";
        sha1 = "b58747854ff33df7ff8f1653756bff6a32a8c838";
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
  "x509" = self.by-version."x509"."0.0.6";
  by-spec."xml2js"."0.2.4" =
    self.by-version."xml2js"."0.2.4";
  by-version."xml2js"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.4";
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
      self.by-version."sax"."0.5.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js"."0.2.x" =
    self.by-version."xml2js"."0.2.8";
  by-version."xml2js"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.8";
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
    self.by-version."xml2js"."0.4.0";
  by-version."xml2js"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.4.0.tgz";
        name = "xml2js-0.4.0.tgz";
        sha1 = "124fc4114b4129c810800ecb2ac86cf25462cb9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = [
      self.by-version."sax"."0.5.8"
      self.by-version."xmlbuilder"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xml2js".">=0.1.7" =
    self.by-version."xml2js"."0.4.0";
  by-spec."xmlbuilder"."0.4.2" =
    self.by-version."xmlbuilder"."0.4.2";
  by-version."xmlbuilder"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-0.4.2";
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
    self.by-version."xmlbuilder"."2.0.1";
  by-version."xmlbuilder"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-2.0.1.tgz";
        name = "xmlbuilder-2.0.1.tgz";
        sha1 = "b0f9b16bd2a260e734f5f8e30d9bf1db217fe79b";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder" or []);
    deps = [
      self.by-version."underscore"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  by-spec."xmlhttprequest"."1.4.2" =
    self.by-version."xmlhttprequest"."1.4.2";
  by-version."xmlhttprequest"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "xmlhttprequest-1.4.2";
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
    name = "xoauth2-0.1.8";
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
  by-spec."xtend"."~2.0.6" =
    self.by-version."xtend"."2.0.6";
  by-version."xtend"."2.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "xtend-2.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-2.0.6.tgz";
        name = "xtend-2.0.6.tgz";
        sha1 = "5ea657a6dba447069c2e59c58a1138cb0c5e6cee";
      })
    ];
    buildInputs =
      (self.nativeDeps."xtend" or []);
    deps = [
      self.by-version."is-object"."0.1.2"
      self.by-version."object-keys"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xtend" ];
  };
  by-spec."yaml"."0.2.3" =
    self.by-version."yaml"."0.2.3";
  by-version."yaml"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "yaml-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yaml/-/yaml-0.2.3.tgz";
        name = "yaml-0.2.3.tgz";
        sha1 = "b5450e92e76ef36b5dd24e3660091ebaeef3e5c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."yaml" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yaml" ];
  };
  by-spec."yeoman-generator"."~0.13.0" =
    self.by-version."yeoman-generator"."0.13.4";
  by-version."yeoman-generator"."0.13.4" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.13.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.13.4.tgz";
        name = "yeoman-generator-0.13.4.tgz";
        sha1 = "066798dd978026d37be6657b2672a17bc4f4ce34";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator" or []);
    deps = [
      self.by-version."cheerio"."0.12.4"
      self.by-version."request"."2.25.0"
      self.by-version."rimraf"."2.2.5"
      self.by-version."tar"."0.1.19"
      self.by-version."diff"."1.0.8"
      self.by-version."mime"."1.2.11"
      self.by-version."underscore.string"."2.3.3"
      self.by-version."lodash"."1.3.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."glob"."3.2.7"
      self.by-version."debug"."0.7.4"
      self.by-version."isbinaryfile"."0.1.9"
      self.by-version."dargs"."0.1.0"
      self.by-version."async"."0.2.9"
      self.by-version."inquirer"."0.3.5"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."shelljs"."0.1.4"
      self.by-version."findup-sync"."0.1.2"
      self.by-version."chalk"."0.2.1"
      self.by-version."text-table"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  by-spec."yeoman-generator"."~0.14.0" =
    self.by-version."yeoman-generator"."0.14.2";
  by-version."yeoman-generator"."0.14.2" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.14.2";
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
      self.by-version."rimraf"."2.2.5"
      self.by-version."diff"."1.0.8"
      self.by-version."mime"."1.2.11"
      self.by-version."underscore.string"."2.3.3"
      self.by-version."lodash"."2.2.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."glob"."3.2.7"
      self.by-version."debug"."0.7.4"
      self.by-version."isbinaryfile"."0.1.9"
      self.by-version."dargs"."0.1.0"
      self.by-version."async"."0.2.9"
      self.by-version."inquirer"."0.3.5"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."shelljs"."0.2.6"
      self.by-version."findup-sync"."0.1.2"
      self.by-version."chalk"."0.3.0"
      self.by-version."text-table"."0.2.0"
      self.by-version."download"."0.1.7"
      self.by-version."request"."2.27.0"
      self.by-version."file-utils"."0.1.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  by-spec."yeoman-generator"."~0.15.0" =
    self.by-version."yeoman-generator"."0.15.0-pre.3";
  by-version."yeoman-generator"."0.15.0-pre.3" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.15.0-pre.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.15.0-pre.3.tgz";
        name = "yeoman-generator-0.15.0-pre.3.tgz";
        sha1 = "49ded1ed00a2f27fe101ec11f2bf797c6ba9d81f";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator" or []);
    deps = [
      self.by-version."cheerio"."0.12.4"
      self.by-version."rimraf"."2.2.5"
      self.by-version."diff"."1.0.8"
      self.by-version."mime"."1.2.11"
      self.by-version."underscore.string"."2.3.3"
      self.by-version."lodash"."2.4.1"
      self.by-version."mkdirp"."0.3.5"
      self.by-version."glob"."3.2.7"
      self.by-version."debug"."0.7.4"
      self.by-version."isbinaryfile"."2.0.0"
      self.by-version."dargs"."0.1.0"
      self.by-version."async"."0.2.9"
      self.by-version."inquirer"."0.3.5"
      self.by-version."iconv-lite"."0.2.11"
      self.by-version."shelljs"."0.2.6"
      self.by-version."findup-sync"."0.1.2"
      self.by-version."chalk"."0.3.0"
      self.by-version."text-table"."0.2.0"
      self.by-version."download"."0.1.7"
      self.by-version."request"."2.29.0"
      self.by-version."file-utils"."0.1.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  by-spec."yo"."*" =
    self.by-version."yo"."1.0.7-pre.2";
  by-version."yo"."1.0.7-pre.2" = lib.makeOverridable self.buildNodePackage {
    name = "yo-1.0.7-pre.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yo/-/yo-1.0.7-pre.2.tgz";
        name = "yo-1.0.7-pre.2.tgz";
        sha1 = "0301500c8b92e81409a7a68459501e8dece0609f";
      })
    ];
    buildInputs =
      (self.nativeDeps."yo" or []);
    deps = [
      self.by-version."yeoman-generator"."0.15.0-pre.3"
      self.by-version."nopt"."2.1.2"
      self.by-version."lodash"."2.4.1"
      self.by-version."update-notifier"."0.1.7"
      self.by-version."insight"."0.3.0"
      self.by-version."sudo-block"."0.3.0"
      self.by-version."async"."0.2.9"
      self.by-version."open"."0.0.4"
      self.by-version."chalk"."0.4.0"
      self.by-version."findup"."0.1.3"
    ];
    peerDependencies = [
      self.by-version."grunt-cli"."0.1.11"
      self.by-version."bower"."1.2.8"
    ];
    passthru.names = [ "yo" ];
  };
  "yo" = self.by-version."yo"."1.0.7-pre.2";
  by-spec."yo".">=1.0.0" =
    self.by-version."yo"."1.0.7-pre.2";
  by-spec."yo".">=1.0.0-rc.1.1" =
    self.by-version."yo"."1.0.7-pre.2";
  by-spec."zeparser"."0.0.5" =
    self.by-version."zeparser"."0.0.5";
  by-version."zeparser"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "zeparser-0.0.5";
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
  by-spec."zlib-browserify"."0.0.1" =
    self.by-version."zlib-browserify"."0.0.1";
  by-version."zlib-browserify"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "zlib-browserify-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zlib-browserify/-/zlib-browserify-0.0.1.tgz";
        name = "zlib-browserify-0.0.1.tgz";
        sha1 = "4fa6a45d00dbc15f318a4afa1d9afc0258e176cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."zlib-browserify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "zlib-browserify" ];
  };
}
