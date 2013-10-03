{ self, fetchurl, lib }:

{
  full."CSSselect"."0.x" = lib.makeOverridable self.buildNodePackage {
    name = "CSSselect-0.3.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.3.11.tgz";
        sha1 = "0779a069d12da9ff5875dd125a0287599c05b6a5";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSselect"."0.x" or []);
    deps = [
      self.full."CSSwhat"."0.4"
      self.full."domutils"."1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSselect" ];
  };
  full."CSSwhat"."0.4" = lib.makeOverridable self.buildNodePackage {
    name = "CSSwhat-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.1.tgz";
        sha1 = "fe6580461b2a3ad550d2a7785a051234974dfca7";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSwhat"."0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSwhat" ];
  };
  full."abbrev"."1" = lib.makeOverridable self.buildNodePackage {
    name = "abbrev-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.4.tgz";
        sha1 = "bd55ae5e413ba1722ee4caba1f6ea10414a59ecd";
      })
    ];
    buildInputs =
      (self.nativeDeps."abbrev"."1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "abbrev" ];
  };
  full."abbrev"."1.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "abbrev-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.4.tgz";
        sha1 = "bd55ae5e413ba1722ee4caba1f6ea10414a59ecd";
      })
    ];
    buildInputs =
      (self.nativeDeps."abbrev"."1.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "abbrev" ];
  };
  full."abbrev"."~1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "abbrev-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.4.tgz";
        sha1 = "bd55ae5e413ba1722ee4caba1f6ea10414a59ecd";
      })
    ];
    buildInputs =
      (self.nativeDeps."abbrev"."~1.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "abbrev" ];
  };
  full."active-x-obfuscator"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "active-x-obfuscator-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/active-x-obfuscator/-/active-x-obfuscator-0.0.1.tgz";
        sha1 = "089b89b37145ff1d9ec74af6530be5526cae1f1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."active-x-obfuscator"."0.0.1" or []);
    deps = [
      self.full."zeparser"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "active-x-obfuscator" ];
  };
  full."addressparser"."~0.1" = lib.makeOverridable self.buildNodePackage {
    name = "addressparser-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/addressparser/-/addressparser-0.1.3.tgz";
        sha1 = "9e9ab43d257e1ae784e1df5f580c9f5240f58874";
      })
    ];
    buildInputs =
      (self.nativeDeps."addressparser"."~0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "addressparser" ];
  };
  full."adm-zip"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "adm-zip-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.2.1.tgz";
        sha1 = "e801cedeb5bd9a4e98d699c5c0f4239e2731dcbf";
      })
    ];
    buildInputs =
      (self.nativeDeps."adm-zip"."0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "adm-zip" ];
  };
  full."adm-zip"."~0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "adm-zip-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/adm-zip/-/adm-zip-0.4.3.tgz";
        sha1 = "28d6a3809abb7845a0ffa38f9fff455c2c6f6f6c";
      })
    ];
    buildInputs =
      (self.nativeDeps."adm-zip"."~0.4.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "adm-zip" ];
  };
  full."almond"."*" = lib.makeOverridable self.buildNodePackage {
    name = "almond-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/almond/-/almond-0.2.6.tgz";
        sha1 = "7165a9246894239efe74ec4a41d6c97898eafc05";
      })
    ];
    buildInputs =
      (self.nativeDeps."almond"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "almond" ];
  };
  "almond" = self.full."almond"."*";
  full."amdefine"."*" = lib.makeOverridable self.buildNodePackage {
    name = "amdefine-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-0.0.8.tgz";
        sha1 = "34dc8c981e6acb3be1853bef8f0ec94a39d55ba0";
      })
    ];
    buildInputs =
      (self.nativeDeps."amdefine"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "amdefine" ];
  };
  "amdefine" = self.full."amdefine"."*";
  full."amdefine".">=0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "amdefine-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-0.0.8.tgz";
        sha1 = "34dc8c981e6acb3be1853bef8f0ec94a39d55ba0";
      })
    ];
    buildInputs =
      (self.nativeDeps."amdefine".">=0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "amdefine" ];
  };
  full."ansi"."~0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.1.2.tgz";
        sha1 = "2627e29498f06e2a1c2ece9c21e28fd494430827";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi"."~0.1.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi" ];
  };
  full."ansi-remover"."*" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-remover-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-remover/-/ansi-remover-0.0.2.tgz";
        sha1 = "7020086289f10e195d85d828de065ccdd50e6e66";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-remover"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-remover" ];
  };
  "ansi-remover" = self.full."ansi-remover"."*";
  full."ansi-styles"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-styles-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-0.1.2.tgz";
        sha1 = "5bab27c2e0bbe944ee42057cf23adee970abc7c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles"."~0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  full."ansi-styles"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-styles-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-0.2.0.tgz";
        sha1 = "359ab4b15dcd64ba6d74734b72c36360a9af2c19";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  full."ansicolors"."~0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansicolors-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansicolors/-/ansicolors-0.2.1.tgz";
        sha1 = "be089599097b74a5c9c4a84a0cdbcdb62bd87aef";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansicolors"."~0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ansicolors" ];
  };
  full."apparatus".">= 0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "apparatus-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/apparatus/-/apparatus-0.0.7.tgz";
        sha1 = "033f355507b6851ebeb1bd9475ede23c802327fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."apparatus".">= 0.0.4" or []);
    deps = [
      self.full."sylvester".">= 0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "apparatus" ];
  };
  full."archiver"."~0.4.6" = lib.makeOverridable self.buildNodePackage {
    name = "archiver-0.4.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archiver/-/archiver-0.4.10.tgz";
        sha1 = "df0feac8f1d1295e5eceb3a205559072d21f4747";
      })
    ];
    buildInputs =
      (self.nativeDeps."archiver"."~0.4.6" or []);
    deps = [
      self.full."readable-stream"."~1.0.2"
      self.full."iconv-lite"."~0.2.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "archiver" ];
  };
  full."archy"."0" = lib.makeOverridable self.buildNodePackage {
    name = "archy-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archy/-/archy-0.0.2.tgz";
        sha1 = "910f43bf66141fc335564597abc189df44b3d35e";
      })
    ];
    buildInputs =
      (self.nativeDeps."archy"."0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "archy" ];
  };
  full."archy"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "archy-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/archy/-/archy-0.0.2.tgz";
        sha1 = "910f43bf66141fc335564597abc189df44b3d35e";
      })
    ];
    buildInputs =
      (self.nativeDeps."archy"."0.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "archy" ];
  };
  full."argparse"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "argparse-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/argparse/-/argparse-0.1.15.tgz";
        sha1 = "28a1f72c43113e763220e5708414301c8840f0a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."argparse"."0.1.15" or []);
    deps = [
      self.full."underscore"."~1.4.3"
      self.full."underscore.string"."~2.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "argparse" ];
  };
  full."argparse"."~ 0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "argparse-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/argparse/-/argparse-0.1.15.tgz";
        sha1 = "28a1f72c43113e763220e5708414301c8840f0a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."argparse"."~ 0.1.11" or []);
    deps = [
      self.full."underscore"."~1.4.3"
      self.full."underscore.string"."~2.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "argparse" ];
  };
  full."asn1"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "asn1-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1"."0.1.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "asn1" ];
  };
  full."assert"."*" = lib.makeOverridable self.buildNodePackage {
    name = "assert-0.4.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert/-/assert-0.4.9.tgz";
        sha1 = "45faff1a58f718508118873dead940c8b51db939";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert"."*" or []);
    deps = [
      self.full."util".">= 0.4.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assert" ];
  };
  "assert" = self.full."assert"."*";
  full."assert-plus"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "assert-plus-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.2.tgz";
        sha1 = "d93ffdbb67ac5507779be316a7d65146417beef8";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert-plus"."0.1.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assert-plus" ];
  };
  full."assertion-error"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "assertion-error-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assertion-error/-/assertion-error-1.0.0.tgz";
        sha1 = "c7f85438fdd466bc7ca16ab90c81513797a5d23b";
      })
    ];
    buildInputs =
      (self.nativeDeps."assertion-error"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assertion-error" ];
  };
  full."async"."*" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  "async" = self.full."async"."*";
  full."async"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.15.tgz";
        sha1 = "2180eaca2cf2a6ca5280d41c0585bec9b3e49bd3";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."0.1.15" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.1.22";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
        sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."0.1.22" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.1.22";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
        sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."0.2.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."0.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."~0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.1.22";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
        sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."~0.1.22" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."~0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."~0.2.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."~0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."~0.2.7" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."~0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."~0.2.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."async"."~0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
        sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
      })
    ];
    buildInputs =
      (self.nativeDeps."async"."~0.2.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  full."aws-sdk"."*" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-1.7.0";
    src = [
      (self.patchLatest {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-1.7.0.tgz";
        sha1 = "d30b478b04d5faf15c02d17faa9968ec1b5b1149";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sdk"."*" or []);
    deps = [
      self.full."xml2js"."0.2.4"
      self.full."xmlbuilder"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sdk" ];
  };
  "aws-sdk" = self.full."aws-sdk"."*";
  full."aws-sdk".">=1.2.0 <2" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sdk-1.7.0";
    src = [
      (self.patchLatest {
        url = "http://registry.npmjs.org/aws-sdk/-/aws-sdk-1.7.0.tgz";
        sha1 = "d30b478b04d5faf15c02d17faa9968ec1b5b1149";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sdk".">=1.2.0 <2" or []);
    deps = [
      self.full."xml2js"."0.2.4"
      self.full."xmlbuilder"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sdk" ];
  };
  full."aws-sign"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.2.0.tgz";
        sha1 = "c55013856c8194ec854a0cbec90aab5a04ce3ac5";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
  full."aws-sign"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.3.0.tgz";
        sha1 = "3d81ca69b474b1e16518728b51c24ff0bbedc6e9";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign"."~0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
  full."backbone"."*" = lib.makeOverridable self.buildNodePackage {
    name = "backbone-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backbone/-/backbone-1.0.0.tgz";
        sha1 = "5e146e1efa8a5361462e578377c39ed0f16b0b4c";
      })
    ];
    buildInputs =
      (self.nativeDeps."backbone"."*" or []);
    deps = [
      self.full."underscore".">=1.4.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "backbone" ];
  };
  "backbone" = self.full."backbone"."*";
  full."backoff"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "backoff-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/backoff/-/backoff-2.1.0.tgz";
        sha1 = "19b4e9f9fb75c122ad7bb1c6c376d6085d43ea09";
      })
    ];
    buildInputs =
      (self.nativeDeps."backoff"."2.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "backoff" ];
  };
  full."base64id"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "base64id-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/base64id/-/base64id-0.1.0.tgz";
        sha1 = "02ce0fdeee0cef4f40080e1e73e834f0b1bfce3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."base64id"."0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "base64id" ];
  };
  full."bcrypt"."*" = lib.makeOverridable self.buildNodePackage {
    name = "bcrypt-0.7.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bcrypt/-/bcrypt-0.7.7.tgz";
        sha1 = "966a2e709b8cf62c2e05408baf7c5ed663b3c868";
      })
    ];
    buildInputs =
      (self.nativeDeps."bcrypt"."*" or []);
    deps = [
      self.full."bindings"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bcrypt" ];
  };
  "bcrypt" = self.full."bcrypt"."*";
  full."binary"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "binary-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/binary/-/binary-0.3.0.tgz";
        sha1 = "9f60553bc5ce8c3386f3b553cff47462adecaa79";
      })
    ];
    buildInputs =
      (self.nativeDeps."binary"."~0.3.0" or []);
    deps = [
      self.full."chainsaw"."~0.1.0"
      self.full."buffers"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "binary" ];
  };
  full."bindings"."*" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.1.1.tgz";
        sha1 = "951f7ae010302ffc50b265b124032017ed2bf6f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  full."bindings"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.0.0.tgz";
        sha1 = "c3ccde60e9de6807c6f1aa4ef4843af29191c828";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  full."block-stream"."*" = lib.makeOverridable self.buildNodePackage {
    name = "block-stream-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
      })
    ];
    buildInputs =
      (self.nativeDeps."block-stream"."*" or []);
    deps = [
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "block-stream" ];
  };
  full."block-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "block-stream-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
      })
    ];
    buildInputs =
      (self.nativeDeps."block-stream"."0.0.7" or []);
    deps = [
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "block-stream" ];
  };
  full."blueimp-md5"."~1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "blueimp-md5-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/blueimp-md5/-/blueimp-md5-1.0.3.tgz";
        sha1 = "932f8fa56652701823cee46cecc0477c88333ab2";
      })
    ];
    buildInputs =
      (self.nativeDeps."blueimp-md5"."~1.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "blueimp-md5" ];
  };
  full."boom"."0.3.x" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.3.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.3.8.tgz";
        sha1 = "c8cdb041435912741628c044ecc732d1d17c09ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom"."0.3.x" or []);
    deps = [
      self.full."hoek"."0.7.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  full."boom"."0.4.x" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
        sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom"."0.4.x" or []);
    deps = [
      self.full."hoek"."0.9.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  full."bower"."*" = lib.makeOverridable self.buildNodePackage {
    name = "bower-1.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower/-/bower-1.2.7.tgz";
        sha1 = "5b0505c8192bd61a752a7cf8b718d1b3054cd554";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower"."*" or []);
    deps = [
      self.full."abbrev"."~1.0.4"
      self.full."archy"."0.0.2"
      self.full."bower-config"."~0.5.0"
      self.full."bower-endpoint-parser"."~0.2.0"
      self.full."bower-json"."~0.4.0"
      self.full."bower-logger"."~0.2.1"
      self.full."bower-registry-client"."~0.1.4"
      self.full."cardinal"."~0.4.0"
      self.full."chalk"."~0.2.0"
      self.full."chmodr"."~0.1.0"
      self.full."fstream"."~0.1.22"
      self.full."fstream-ignore"."~0.0.6"
      self.full."glob"."~3.2.1"
      self.full."graceful-fs"."~2.0.0"
      self.full."handlebars"."~1.0.11"
      self.full."inquirer"."~0.3.0"
      self.full."junk"."~0.2.0"
      self.full."mkdirp"."~0.3.5"
      self.full."mout"."~0.7.0"
      self.full."nopt"."~2.1.1"
      self.full."lru-cache"."~2.3.0"
      self.full."open"."~0.0.3"
      self.full."osenv"."0.0.3"
      self.full."promptly"."~0.2.0"
      self.full."q"."~0.9.2"
      self.full."request"."~2.27.0"
      self.full."request-progress"."~0.3.0"
      self.full."retry"."~0.6.0"
      self.full."rimraf"."~2.2.0"
      self.full."semver"."~2.1.0"
      self.full."stringify-object"."~0.1.4"
      self.full."sudo-block"."~0.2.0"
      self.full."tar"."~0.1.17"
      self.full."tmp"."~0.0.20"
      self.full."unzip"."~0.1.7"
      self.full."update-notifier"."~0.1.3"
      self.full."which"."~1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower" ];
  };
  "bower" = self.full."bower"."*";
  full."bower".">=0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-1.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower/-/bower-1.2.7.tgz";
        sha1 = "5b0505c8192bd61a752a7cf8b718d1b3054cd554";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower".">=0.9.0" or []);
    deps = [
      self.full."abbrev"."~1.0.4"
      self.full."archy"."0.0.2"
      self.full."bower-config"."~0.5.0"
      self.full."bower-endpoint-parser"."~0.2.0"
      self.full."bower-json"."~0.4.0"
      self.full."bower-logger"."~0.2.1"
      self.full."bower-registry-client"."~0.1.4"
      self.full."cardinal"."~0.4.0"
      self.full."chalk"."~0.2.0"
      self.full."chmodr"."~0.1.0"
      self.full."fstream"."~0.1.22"
      self.full."fstream-ignore"."~0.0.6"
      self.full."glob"."~3.2.1"
      self.full."graceful-fs"."~2.0.0"
      self.full."handlebars"."~1.0.11"
      self.full."inquirer"."~0.3.0"
      self.full."junk"."~0.2.0"
      self.full."mkdirp"."~0.3.5"
      self.full."mout"."~0.7.0"
      self.full."nopt"."~2.1.1"
      self.full."lru-cache"."~2.3.0"
      self.full."open"."~0.0.3"
      self.full."osenv"."0.0.3"
      self.full."promptly"."~0.2.0"
      self.full."q"."~0.9.2"
      self.full."request"."~2.27.0"
      self.full."request-progress"."~0.3.0"
      self.full."retry"."~0.6.0"
      self.full."rimraf"."~2.2.0"
      self.full."semver"."~2.1.0"
      self.full."stringify-object"."~0.1.4"
      self.full."sudo-block"."~0.2.0"
      self.full."tar"."~0.1.17"
      self.full."tmp"."~0.0.20"
      self.full."unzip"."~0.1.7"
      self.full."update-notifier"."~0.1.3"
      self.full."which"."~1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower" ];
  };
  full."bower-config"."~0.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "bower-config-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-config/-/bower-config-0.4.5.tgz";
        sha1 = "baa7cee382f53b13bb62a4afaee7c05f20143c13";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-config"."~0.4.3" or []);
    deps = [
      self.full."graceful-fs"."~2.0.0"
      self.full."mout"."~0.6.0"
      self.full."optimist"."~0.6.0"
      self.full."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  full."bower-config"."~0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-config-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-config/-/bower-config-0.5.0.tgz";
        sha1 = "d081d43008816b1beb876dee272219851dd4c89c";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-config"."~0.5.0" or []);
    deps = [
      self.full."graceful-fs"."~2.0.0"
      self.full."mout"."~0.6.0"
      self.full."optimist"."~0.6.0"
      self.full."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-config" ];
  };
  full."bower-endpoint-parser"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-endpoint-parser-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-endpoint-parser/-/bower-endpoint-parser-0.2.1.tgz";
        sha1 = "8c4010a2900cdab07ea5d38f0bd03e9bbccef90f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-endpoint-parser"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-endpoint-parser" ];
  };
  full."bower-json"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-json-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-json/-/bower-json-0.4.0.tgz";
        sha1 = "a99c3ccf416ef0590ed0ded252c760f1c6d93766";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-json"."~0.4.0" or []);
    deps = [
      self.full."deep-extend"."~0.2.5"
      self.full."graceful-fs"."~2.0.0"
      self.full."intersect"."~0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-json" ];
  };
  full."bower-logger"."~0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-logger-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.1.tgz";
        sha1 = "0c1817c48063a88d96cc3d516c55e57fff5d9ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-logger"."~0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-logger" ];
  };
  full."bower-registry-client"."~0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "bower-registry-client-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-registry-client/-/bower-registry-client-0.1.5.tgz";
        sha1 = "1c64d70bfca833c95121ffc23da48a54527912d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-registry-client"."~0.1.4" or []);
    deps = [
      self.full."async"."~0.2.8"
      self.full."bower-config"."~0.4.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."lru-cache"."~2.3.0"
      self.full."request"."~2.27.0"
      self.full."request-replay"."~0.2.0"
      self.full."rimraf"."~2.2.0"
      self.full."mkdirp"."~0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-registry-client" ];
  };
  full."broadway"."0.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "broadway-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/broadway/-/broadway-0.2.7.tgz";
        sha1 = "3ba2f4b3de163e95e38a4950b61fd5f882a90762";
      })
    ];
    buildInputs =
      (self.nativeDeps."broadway"."0.2.7" or []);
    deps = [
      self.full."cliff"."0.1.8"
      self.full."eventemitter2"."0.4.11"
      self.full."nconf"."0.6.7"
      self.full."winston"."0.6.2"
      self.full."utile"."0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "broadway" ];
  };
  full."broadway"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "broadway-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/broadway/-/broadway-0.2.7.tgz";
        sha1 = "3ba2f4b3de163e95e38a4950b61fd5f882a90762";
      })
    ];
    buildInputs =
      (self.nativeDeps."broadway"."0.2.x" or []);
    deps = [
      self.full."cliff"."0.1.8"
      self.full."eventemitter2"."0.4.11"
      self.full."nconf"."0.6.7"
      self.full."winston"."0.6.2"
      self.full."utile"."0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "broadway" ];
  };
  full."browserchannel"."*" = lib.makeOverridable self.buildNodePackage {
    name = "browserchannel-1.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browserchannel/-/browserchannel-1.0.7.tgz";
        sha1 = "0966d021d6001011f3fae3377db4bd2992458b57";
      })
    ];
    buildInputs =
      (self.nativeDeps."browserchannel"."*" or []);
    deps = [
      self.full."hat"."*"
      self.full."connect"."~2"
      self.full."request"."~2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "browserchannel" ];
  };
  "browserchannel" = self.full."browserchannel"."*";
  full."bson"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.1.8.tgz";
        sha1 = "cf34fdcff081a189b589b4b3e5e9309cd6506c81";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson"."0.1.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  full."bson"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "bson-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bson/-/bson-0.2.2.tgz";
        sha1 = "3dbf984acb9d33a6878b46e6fb7afbd611856a60";
      })
    ];
    buildInputs =
      (self.nativeDeps."bson"."0.2.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bson" ];
  };
  full."buffer-crc32"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.1.1.tgz";
        sha1 = "7e110dc9953908ab7c32acdc70c9f945b1cbc526";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32"."0.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  full."buffer-crc32"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.1.tgz";
        sha1 = "be3e5382fc02b6d6324956ac1af98aa98b08534c";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32"."0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  full."buffer-crc32"."~0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-crc32-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.1.tgz";
        sha1 = "be3e5382fc02b6d6324956ac1af98aa98b08534c";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-crc32"."~0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffer-crc32" ];
  };
  full."buffers"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffers-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffers/-/buffers-0.1.1.tgz";
        sha1 = "b24579c3bed4d6d396aeee6d9a8ae7f5482ab7bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffers"."~0.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffers" ];
  };
  full."buffertools"."*" = lib.makeOverridable self.buildNodePackage {
    name = "buffertools-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-1.1.1.tgz";
        sha1 = "1071a5f40fe76c39d7a4fe2ea030324d09d6ec9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffertools"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffertools" ];
  };
  "buffertools" = self.full."buffertools"."*";
  full."buffertools".">=1.1.1 <2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "buffertools-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffertools/-/buffertools-1.1.1.tgz";
        sha1 = "1071a5f40fe76c39d7a4fe2ea030324d09d6ec9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffertools".">=1.1.1 <2.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "buffertools" ];
  };
  full."bunyan"."0.21.1" = lib.makeOverridable self.buildNodePackage {
    name = "bunyan-0.21.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bunyan/-/bunyan-0.21.1.tgz";
        sha1 = "ea00a0d5223572e31e1e71efba2237cb1915942a";
      })
    ];
    buildInputs =
      (self.nativeDeps."bunyan"."0.21.1" or []);
    deps = [
      self.full."mv"."0.0.5"
      self.full."dtrace-provider"."0.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bunyan" ];
  };
  full."bytes"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "bytes-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-0.2.0.tgz";
        sha1 = "aad33ec14e3dc2ca74e8e7d451f9ba053ad4f7a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes"."0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  full."cardinal"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "cardinal-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cardinal/-/cardinal-0.4.2.tgz";
        sha1 = "b6563a882f58a56c1abd574baec64b5d0b7ef942";
      })
    ];
    buildInputs =
      (self.nativeDeps."cardinal"."~0.4.0" or []);
    deps = [
      self.full."redeyed"."~0.4.0"
      self.full."ansicolors"."~0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cardinal" ];
  };
  full."chai"."*" = lib.makeOverridable self.buildNodePackage {
    name = "chai-1.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chai/-/chai-1.8.0.tgz";
        sha1 = "1f7accbe91e2e71a08d8208b31bbbdc6862699ac";
      })
    ];
    buildInputs =
      (self.nativeDeps."chai"."*" or []);
    deps = [
      self.full."assertion-error"."1.0.0"
      self.full."deep-eql"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chai" ];
  };
  "chai" = self.full."chai"."*";
  full."chainsaw"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "chainsaw-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chainsaw/-/chainsaw-0.1.0.tgz";
        sha1 = "5eab50b28afe58074d0d58291388828b5e5fbc98";
      })
    ];
    buildInputs =
      (self.nativeDeps."chainsaw"."~0.1.0" or []);
    deps = [
      self.full."traverse".">=0.3.0 <0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chainsaw" ];
  };
  full."chalk"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.1.1.tgz";
        sha1 = "fe6d90ae2c270424720c87ed92d36490b7d36ea0";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk"."~0.1.0" or []);
    deps = [
      self.full."has-color"."~0.1.0"
      self.full."ansi-styles"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  full."chalk"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.1.1.tgz";
        sha1 = "fe6d90ae2c270424720c87ed92d36490b7d36ea0";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk"."~0.1.1" or []);
    deps = [
      self.full."has-color"."~0.1.0"
      self.full."ansi-styles"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  full."chalk"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.2.1.tgz";
        sha1 = "7613e1575145b21386483f7f485aa5ffa8cbd10c";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk"."~0.2.0" or []);
    deps = [
      self.full."has-color"."~0.1.0"
      self.full."ansi-styles"."~0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  full."character-parser"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "character-parser-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/character-parser/-/character-parser-1.2.0.tgz";
        sha1 = "94134d6e5d870a39be359f7d22460935184ddef6";
      })
    ];
    buildInputs =
      (self.nativeDeps."character-parser"."1.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "character-parser" ];
  };
  full."cheerio"."~0.10.8" = lib.makeOverridable self.buildNodePackage {
    name = "cheerio-0.10.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.10.8.tgz";
        sha1 = "ece5ad0c8baa9b9adc87394bbdb1c68bc4552ba0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio"."~0.10.8" or []);
    deps = [
      self.full."cheerio-select"."*"
      self.full."htmlparser2"."2.x"
      self.full."underscore"."~1.4"
      self.full."entities"."0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  full."cheerio"."~0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "cheerio-0.12.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.12.2.tgz";
        sha1 = "d9908e29679e6d1b501c2cfe0e4ada330ea278c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio"."~0.12.0" or []);
    deps = [
      self.full."cheerio-select"."*"
      self.full."htmlparser2"."3.1.4"
      self.full."underscore"."~1.4"
      self.full."entities"."0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  full."cheerio"."~0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "cheerio-0.12.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.12.2.tgz";
        sha1 = "d9908e29679e6d1b501c2cfe0e4ada330ea278c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio"."~0.12.1" or []);
    deps = [
      self.full."cheerio-select"."*"
      self.full."htmlparser2"."3.1.4"
      self.full."underscore"."~1.4"
      self.full."entities"."0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  full."cheerio-select"."*" = lib.makeOverridable self.buildNodePackage {
    name = "cheerio-select-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio-select/-/cheerio-select-0.0.3.tgz";
        sha1 = "3f2420114f3ccb0b1b075c245ccfaae5d617a388";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio-select"."*" or []);
    deps = [
      self.full."CSSselect"."0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio-select" ];
  };
  full."child-process-close"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "child-process-close-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/child-process-close/-/child-process-close-0.1.1.tgz";
        sha1 = "c153ede7a5eb65ac69e78a38973b1a286377f75f";
      })
    ];
    buildInputs =
      (self.nativeDeps."child-process-close"."~0.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "child-process-close" ];
  };
  full."chmodr"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "chmodr-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chmodr/-/chmodr-0.1.0.tgz";
        sha1 = "e09215a1d51542db2a2576969765bcf6125583eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."chmodr"."~0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chmodr" ];
  };
  full."chokidar"."~0.6" = lib.makeOverridable self.buildNodePackage {
    name = "chokidar-0.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chokidar/-/chokidar-0.6.3.tgz";
        sha1 = "e85968fa235f21773d388c617af085bf2104425a";
      })
    ];
    buildInputs =
      (self.nativeDeps."chokidar"."~0.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chokidar" ];
  };
  full."chownr"."0" = lib.makeOverridable self.buildNodePackage {
    name = "chownr-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chownr/-/chownr-0.0.1.tgz";
        sha1 = "51d18189d9092d5f8afd623f3288bfd1c6bf1a62";
      })
    ];
    buildInputs =
      (self.nativeDeps."chownr"."0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chownr" ];
  };
  full."clean-css"."~1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-1.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-1.1.2.tgz";
        sha1 = "ea0c50151c559956c2364d86077eb30d28ff4e9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."clean-css"."~1.1.1" or []);
    deps = [
      self.full."commander"."2.0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clean-css" ];
  };
  full."cli"."0.4.x" = lib.makeOverridable self.buildNodePackage {
    name = "cli-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli/-/cli-0.4.5.tgz";
        sha1 = "78f9485cd161b566e9a6c72d7170c4270e81db61";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli"."0.4.x" or []);
    deps = [
      self.full."glob".">= 3.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli" ];
  };
  full."cli-color"."~0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "cli-color-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli-color/-/cli-color-0.2.3.tgz";
        sha1 = "0a25ceae5a6a1602be7f77d28563c36700274e88";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli-color"."~0.2.2" or []);
    deps = [
      self.full."es5-ext"."~0.9.2"
      self.full."memoizee"."~0.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli-color" ];
  };
  full."cli-table"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "cli-table-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli-table/-/cli-table-0.2.0.tgz";
        sha1 = "34c63eb532c206e9e5e4ae0cb0104bd1fd27317c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli-table"."~0.2.0" or []);
    deps = [
      self.full."colors"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli-table" ];
  };
  full."cliff"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "cliff-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cliff/-/cliff-0.1.8.tgz";
        sha1 = "43ca8ad9fe3943489693ab62dce0cae22509d272";
      })
    ];
    buildInputs =
      (self.nativeDeps."cliff"."0.1.8" or []);
    deps = [
      self.full."colors"."0.x.x"
      self.full."eyes"."0.1.x"
      self.full."winston"."0.6.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cliff" ];
  };
  full."clone"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.5.tgz";
        sha1 = "46f29143d0766d663dbd7f80b7520a15783d2042";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone"."0.1.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  full."clone"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.6.tgz";
        sha1 = "4af2296d4a23a64168c2f5fb0a2aa65e80517000";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone"."0.1.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
  };
  full."cmd-shim"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cmd-shim-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cmd-shim/-/cmd-shim-1.0.1.tgz";
        sha1 = "75e917c2185240854718c686346770640083d7bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."cmd-shim"."~1.0.1" or []);
    deps = [
      self.full."mkdirp"."~0.3.3"
      self.full."graceful-fs"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cmd-shim" ];
  };
  full."cmd-shim"."~1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "cmd-shim-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cmd-shim/-/cmd-shim-1.1.1.tgz";
        sha1 = "348b292db32ed74c8283fcf6c48549b84c6658a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."cmd-shim"."~1.1.0" or []);
    deps = [
      self.full."mkdirp"."~0.3.3"
      self.full."graceful-fs"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cmd-shim" ];
  };
  full."coffee-script"."*" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  "coffee-script" = self.full."coffee-script"."*";
  full."coffee-script"."1.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script"."1.6.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  full."coffee-script".">= 0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script".">= 0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  full."coffee-script".">=1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script".">=1.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  full."coffee-script"."~1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.3.3.tgz";
        sha1 = "150d6b4cb522894369efed6a2101c20bc7f4a4f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script"."~1.3.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  full."coffee-script"."~1.6" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.6.3.tgz";
        sha1 = "6355d32cf1b04cdff6b484e5e711782b2f0c39be";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script"."~1.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  full."color"."~0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "color-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color/-/color-0.4.4.tgz";
        sha1 = "f8bae8a848854616328704e64ce4a94ab336b7b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."color"."~0.4.4" or []);
    deps = [
      self.full."color-convert"."0.2.x"
      self.full."color-string"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color" ];
  };
  full."color-convert"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "color-convert-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-convert/-/color-convert-0.2.1.tgz";
        sha1 = "363cab23c94b31a0d64db71048b8c6a940f8c68c";
      })
    ];
    buildInputs =
      (self.nativeDeps."color-convert"."0.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color-convert" ];
  };
  full."color-string"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "color-string-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/color-string/-/color-string-0.1.2.tgz";
        sha1 = "a413fb7dd137162d5d4ea784cbeb36d931ad9b4a";
      })
    ];
    buildInputs =
      (self.nativeDeps."color-string"."0.1.x" or []);
    deps = [
      self.full."color-convert"."0.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "color-string" ];
  };
  full."colors"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.3.0.tgz";
        sha1 = "c247d64d34db0ca4dc8e43f3ecd6da98d0af94e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors"."0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  full."colors"."0.5.x" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.5.1.tgz";
        sha1 = "7d0023eaeb154e8ee9fce75dcb923d0ed1667774";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors"."0.5.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  full."colors"."0.6.0-1" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.0-1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.0-1.tgz";
        sha1 = "6dbb68ceb8bc60f2b313dcc5ce1599f06d19e67a";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors"."0.6.0-1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  full."colors"."0.6.x" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors"."0.6.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  full."colors"."0.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors"."0.x.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  full."colors"."~0.6.0-1" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors"."~0.6.0-1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  full."combined-stream"."~0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "combined-stream-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.4.tgz";
        sha1 = "2d1a43347dbe9515a4a2796732e5b88473840b22";
      })
    ];
    buildInputs =
      (self.nativeDeps."combined-stream"."~0.0.4" or []);
    deps = [
      self.full."delayed-stream"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "combined-stream" ];
  };
  full."commander"."*" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.0.0.tgz";
        sha1 = "d1b86f901f8b64bd941bdeadaf924530393be928";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."commander"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-0.5.1.tgz";
        sha1 = "08477afb326d1adf9d4ee73af7170c70caa14f95";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."0.5.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."commander"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
        sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."0.6.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."commander"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-1.2.0.tgz";
        sha1 = "fd5713bfa153c7d6cc599378a5ab4c45c535029e";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."1.2.0" or []);
    deps = [
      self.full."keypress"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."commander"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.0.0.tgz";
        sha1 = "d1b86f901f8b64bd941bdeadaf924530393be928";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."2.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."commander"."2.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.0.0.tgz";
        sha1 = "d1b86f901f8b64bd941bdeadaf924530393be928";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."2.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."commander"."~0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
        sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander"."~0.6.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  full."config"."0.4.15" = lib.makeOverridable self.buildNodePackage {
    name = "config-0.4.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/config/-/config-0.4.15.tgz";
        sha1 = "d43ddf58b8df5637fdd1314fc816ccae7bfbcd18";
      })
    ];
    buildInputs =
      (self.nativeDeps."config"."0.4.15" or []);
    deps = [
      self.full."js-yaml"."0.3.x"
      self.full."coffee-script".">=1.2.0"
      self.full."vows".">=0.5.13"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "config" ];
  };
  full."config-chain"."~1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "config-chain-1.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/config-chain/-/config-chain-1.1.8.tgz";
        sha1 = "0943d0b7227213a20d4eaff4434f4a1c0a052cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."config-chain"."~1.1.1" or []);
    deps = [
      self.full."proto-list"."~1.2.1"
      self.full."ini"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "config-chain" ];
  };
  full."configstore"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "configstore-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/configstore/-/configstore-0.1.5.tgz";
        sha1 = "807cfd60ef69c87f4a7b60561d940190a438503e";
      })
    ];
    buildInputs =
      (self.nativeDeps."configstore"."~0.1.0" or []);
    deps = [
      self.full."lodash"."~1.3.0"
      self.full."mkdirp"."~0.3.5"
      self.full."js-yaml"."~2.1.0"
      self.full."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "configstore" ];
  };
  full."connect"."2.7.11" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.7.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.11.tgz";
        sha1 = "f561d5eef70b8d719c397f724d34ba4065c77a3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect"."2.7.11" or []);
    deps = [
      self.full."qs"."0.6.5"
      self.full."formidable"."1.0.14"
      self.full."cookie-signature"."1.0.1"
      self.full."buffer-crc32"."0.2.1"
      self.full."cookie"."0.0.5"
      self.full."send"."0.1.1"
      self.full."bytes"."0.2.0"
      self.full."fresh"."0.1.0"
      self.full."pause"."0.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  full."connect"."2.7.5" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.7.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.5.tgz";
        sha1 = "139111b4b03f0533a524927a88a646ae467b2c02";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect"."2.7.5" or []);
    deps = [
      self.full."qs"."0.5.1"
      self.full."formidable"."1.0.11"
      self.full."cookie-signature"."1.0.0"
      self.full."buffer-crc32"."0.1.1"
      self.full."cookie"."0.0.5"
      self.full."send"."0.1.0"
      self.full."bytes"."0.2.0"
      self.full."fresh"."0.1.0"
      self.full."pause"."0.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  full."connect"."2.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.7.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.6.tgz";
        sha1 = "b83b68fa6f245c5020e2395472cc8322b0060738";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect"."2.7.6" or []);
    deps = [
      self.full."qs"."0.5.1"
      self.full."formidable"."1.0.11"
      self.full."cookie-signature"."1.0.1"
      self.full."buffer-crc32"."0.1.1"
      self.full."cookie"."0.0.5"
      self.full."send"."0.1.0"
      self.full."bytes"."0.2.0"
      self.full."fresh"."0.1.0"
      self.full."pause"."0.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  full."connect"."2.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.9.0.tgz";
        sha1 = "ecf478b6f2723e72cf9a19d1c7d19d0b37b53746";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect"."2.9.0" or []);
    deps = [
      self.full."qs"."0.6.5"
      self.full."cookie-signature"."1.0.1"
      self.full."buffer-crc32"."0.2.1"
      self.full."cookie"."0.1.0"
      self.full."send"."0.1.4"
      self.full."bytes"."0.2.0"
      self.full."fresh"."0.2.0"
      self.full."pause"."0.0.1"
      self.full."uid2"."0.0.2"
      self.full."debug"."*"
      self.full."methods"."0.0.1"
      self.full."multiparty"."2.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  full."connect"."~2" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.9.0.tgz";
        sha1 = "ecf478b6f2723e72cf9a19d1c7d19d0b37b53746";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect"."~2" or []);
    deps = [
      self.full."qs"."0.6.5"
      self.full."cookie-signature"."1.0.1"
      self.full."buffer-crc32"."0.2.1"
      self.full."cookie"."0.1.0"
      self.full."send"."0.1.4"
      self.full."bytes"."0.2.0"
      self.full."fresh"."0.2.0"
      self.full."pause"."0.0.1"
      self.full."uid2"."0.0.2"
      self.full."debug"."*"
      self.full."methods"."0.0.1"
      self.full."multiparty"."2.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  full."connect"."~2.8.4" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.8.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.8.8.tgz";
        sha1 = "b9abf8caf0bd9773cb3dea29344119872582446d";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect"."~2.8.4" or []);
    deps = [
      self.full."qs"."0.6.5"
      self.full."formidable"."1.0.14"
      self.full."cookie-signature"."1.0.1"
      self.full."buffer-crc32"."0.2.1"
      self.full."cookie"."0.1.0"
      self.full."send"."0.1.4"
      self.full."bytes"."0.2.0"
      self.full."fresh"."0.2.0"
      self.full."pause"."0.0.1"
      self.full."uid2"."0.0.2"
      self.full."debug"."*"
      self.full."methods"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  full."connect-flash"."*" = lib.makeOverridable self.buildNodePackage {
    name = "connect-flash-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-flash/-/connect-flash-0.1.1.tgz";
        sha1 = "d8630f26d95a7f851f9956b1e8cc6732f3b6aa30";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-flash"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-flash" ];
  };
  "connect-flash" = self.full."connect-flash"."*";
  full."connect-flash"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-flash-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-flash/-/connect-flash-0.1.0.tgz";
        sha1 = "82b381d61a12b651437df1c259c1f1c841239b88";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-flash"."0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-flash" ];
  };
  full."connect-jade-static"."*" = lib.makeOverridable self.buildNodePackage {
    name = "connect-jade-static-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-jade-static/-/connect-jade-static-0.1.1.tgz";
        sha1 = "11d16fa00aca28cb004e89cd0a7d6b0fa0342cdb";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-jade-static"."*" or []);
    deps = [
      self.full."jade"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-jade-static" ];
  };
  "connect-jade-static" = self.full."connect-jade-static"."*";
  full."connect-mongo"."*" = lib.makeOverridable self.buildNodePackage {
    name = "connect-mongo-0.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-mongo/-/connect-mongo-0.3.3.tgz";
        sha1 = "aeaa1ca8c947599131bd90e1a024cdb789fe0100";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-mongo"."*" or []);
    deps = [
      self.full."mongodb"."1.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "connect-mongo" ];
  };
  "connect-mongo" = self.full."connect-mongo"."*";
  full."console-browserify"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "console-browserify-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/console-browserify/-/console-browserify-0.1.6.tgz";
        sha1 = "d128a3c0bb88350eb5626c6e7c71a6f0fd48983c";
      })
    ];
    buildInputs =
      (self.nativeDeps."console-browserify"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "console-browserify" ];
  };
  full."constantinople"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "constantinople-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/constantinople/-/constantinople-1.0.2.tgz";
        sha1 = "0e64747dc836644d3f659247efd95231b48c3e71";
      })
    ];
    buildInputs =
      (self.nativeDeps."constantinople"."~1.0.1" or []);
    deps = [
      self.full."uglify-js"."~2.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "constantinople" ];
  };
  full."cookie"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.0.5.tgz";
        sha1 = "f9acf9db57eb7568c9fcc596256b7bb22e307c81";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie"."0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  full."cookie"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.0.tgz";
        sha1 = "90eb469ddce905c866de687efc43131d8801f9d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie"."0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  full."cookie-jar"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-jar-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.2.0.tgz";
        sha1 = "64ecc06ac978db795e4b5290cbe48ba3781400fa";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  full."cookie-jar"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-jar-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.3.0.tgz";
        sha1 = "bc9a27d4e2b97e186cd57c9e2063cb99fa68cccc";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar"."~0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  full."cookie-signature"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.0.tgz";
        sha1 = "0044f332ac623df851c914e88eacc57f0c9704fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  full."cookie-signature"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.1.tgz";
        sha1 = "44e072148af01e6e8e24afbf12690d68ae698ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature"."1.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  full."cookiejar"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookiejar-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookiejar/-/cookiejar-1.3.0.tgz";
        sha1 = "dd00b35679021e99cbd4e855b9ad041913474765";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookiejar"."1.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookiejar" ];
  };
  full."cookies".">= 0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "cookies-0.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookies/-/cookies-0.3.6.tgz";
        sha1 = "1b5e4bd66fc732ea2e8b5087a8fb3718b4ec8597";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookies".">= 0.2.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookies" ];
  };
  full."couch-login"."~0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "couch-login-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/couch-login/-/couch-login-0.1.18.tgz";
        sha1 = "a69fa40dd43d1f98d97e560f18187a578a116056";
      })
    ];
    buildInputs =
      (self.nativeDeps."couch-login"."~0.1.15" or []);
    deps = [
      self.full."request"."2 >=2.25.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "couch-login" ];
  };
  full."couch-login"."~0.1.18" = lib.makeOverridable self.buildNodePackage {
    name = "couch-login-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/couch-login/-/couch-login-0.1.18.tgz";
        sha1 = "a69fa40dd43d1f98d97e560f18187a578a116056";
      })
    ];
    buildInputs =
      (self.nativeDeps."couch-login"."~0.1.18" or []);
    deps = [
      self.full."request"."2 >=2.25.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "couch-login" ];
  };
  full."coveralls"."*" = lib.makeOverridable self.buildNodePackage {
    name = "coveralls-2.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coveralls/-/coveralls-2.3.0.tgz";
        sha1 = "9eda569c115214acb7f58ca3a28401e866485144";
      })
    ];
    buildInputs =
      (self.nativeDeps."coveralls"."*" or []);
    deps = [
      self.full."yaml"."0.2.3"
      self.full."request"."2.16.2"
      self.full."lcov-parse"."0.0.4"
      self.full."log-driver"."1.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "coveralls" ];
  };
  "coveralls" = self.full."coveralls"."*";
  full."crossroads"."~0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "crossroads-0.12.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crossroads/-/crossroads-0.12.0.tgz";
        sha1 = "24114f9de3abfa0271df66b4ec56c3b984b7f56e";
      })
    ];
    buildInputs =
      (self.nativeDeps."crossroads"."~0.12.0" or []);
    deps = [
      self.full."signals"."<2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "crossroads" ];
  };
  full."cryptiles"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.1.3.tgz";
        sha1 = "1a556734f06d24ba34862ae9cb9e709a3afbff1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles"."0.1.x" or []);
    deps = [
      self.full."boom"."0.3.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  full."cryptiles"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
        sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles"."0.2.x" or []);
    deps = [
      self.full."boom"."0.4.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  full."css"."~1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "css-1.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css/-/css-1.0.8.tgz";
        sha1 = "9386811ca82bccc9ee7fb5a732b1e2a317c8a3e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."css"."~1.0.8" or []);
    deps = [
      self.full."css-parse"."1.0.4"
      self.full."css-stringify"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css" ];
  };
  full."css-parse"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "css-parse-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-parse/-/css-parse-1.0.4.tgz";
        sha1 = "38b0503fbf9da9f54e9c1dbda60e145c77117bdd";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-parse"."1.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css-parse" ];
  };
  full."css-stringify"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "css-stringify-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/css-stringify/-/css-stringify-1.0.5.tgz";
        sha1 = "b0d042946db2953bb9d292900a6cb5f6d0122031";
      })
    ];
    buildInputs =
      (self.nativeDeps."css-stringify"."1.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "css-stringify" ];
  };
  full."cssom"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "cssom-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cssom/-/cssom-0.2.5.tgz";
        sha1 = "2682709b5902e7212df529116ff788cd5b254894";
      })
    ];
    buildInputs =
      (self.nativeDeps."cssom"."0.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cssom" ];
  };
  full."ctype"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.0.tgz";
        sha1 = "672673ec67587eb495c1ed694da1abb964ff65e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype"."0.5.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  full."ctype"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
        sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype"."0.5.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  full."cycle"."1.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "cycle-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cycle/-/cycle-1.0.2.tgz";
        sha1 = "269aca6f1b8d2baeefc8ccbc888b459f322c4e60";
      })
    ];
    buildInputs =
      (self.nativeDeps."cycle"."1.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cycle" ];
  };
  full."dargs"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "dargs-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dargs/-/dargs-0.1.0.tgz";
        sha1 = "2364ad9f441f976dcd5fe9961e21715665a5e3c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."dargs"."~0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dargs" ];
  };
  full."dateformat"."1.0.2-1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "dateformat-1.0.2-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.2-1.2.3.tgz";
        sha1 = "b0220c02de98617433b72851cf47de3df2cdbee9";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat"."1.0.2-1.2.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  full."dateformat"."~1.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "dateformat-1.0.6-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.6-1.2.3.tgz";
        sha1 = "6b3de9f974f698d8b2d3ff9094bbaac8d696c16b";
      })
    ];
    buildInputs =
      (self.nativeDeps."dateformat"."~1.0.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dateformat" ];
  };
  full."debug"."*" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.2.tgz";
        sha1 = "056692c86670977f115de82917918b8e8b9a10f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  full."debug"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.0.tgz";
        sha1 = "f5be05ec0434c992d79940e50b2695cfb2e01b08";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug"."0.7.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  full."debug"."~0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.2.tgz";
        sha1 = "056692c86670977f115de82917918b8e8b9a10f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug"."~0.7.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  full."debug"."~0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.2.tgz";
        sha1 = "056692c86670977f115de82917918b8e8b9a10f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug"."~0.7.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  full."deep-eql"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "deep-eql-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-eql/-/deep-eql-0.1.2.tgz";
        sha1 = "b54feed3473a6448fbc198be6a6eca9b95d9c58a";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-eql"."0.1.2" or []);
    deps = [
      self.full."type-detect"."0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-eql" ];
  };
  full."deep-equal"."*" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.0.0.tgz";
        sha1 = "99679d3bbd047156fcd450d3d01eeb9068691e83";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  full."deep-equal"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.0.0.tgz";
        sha1 = "99679d3bbd047156fcd450d3d01eeb9068691e83";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal"."0.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  full."deep-extend"."~0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "deep-extend-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.6.tgz";
        sha1 = "1f767e02b46d88d0a4087affa4b11b1b0b804250";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-extend"."~0.2.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-extend" ];
  };
  full."delayed-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "delayed-stream-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
        sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
      })
    ];
    buildInputs =
      (self.nativeDeps."delayed-stream"."0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "delayed-stream" ];
  };
  full."di"."~0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "di-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/di/-/di-0.0.1.tgz";
        sha1 = "806649326ceaa7caa3306d75d985ea2748ba913c";
      })
    ];
    buildInputs =
      (self.nativeDeps."di"."~0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "di" ];
  };
  full."diff"."1.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "diff-1.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.7.tgz";
        sha1 = "24bbb001c4a7d5522169e7cabdb2c2814ed91cf4";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff"."1.0.7" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  full."diff"."~1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "diff-1.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.7.tgz";
        sha1 = "24bbb001c4a7d5522169e7cabdb2c2814ed91cf4";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff"."~1.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  full."diff"."~1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "diff-1.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.7.tgz";
        sha1 = "24bbb001c4a7d5522169e7cabdb2c2814ed91cf4";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff"."~1.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  full."director"."1.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "director-1.1.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/director/-/director-1.1.10.tgz";
        sha1 = "e6c1d64f2f079216f19ea83b566035dde9901179";
      })
    ];
    buildInputs =
      (self.nativeDeps."director"."1.1.10" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "director" ];
  };
  full."domelementtype"."1" = lib.makeOverridable self.buildNodePackage {
    name = "domelementtype-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.1.tgz";
        sha1 = "7887acbda7614bb0a3dbe1b5e394f77a8ed297cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."domelementtype"."1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domelementtype" ];
  };
  full."domhandler"."2.0" = lib.makeOverridable self.buildNodePackage {
    name = "domhandler-2.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.0.3.tgz";
        sha1 = "889f8df626403af0788e29d66d5d5c6f7ebf0fd6";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler"."2.0" or []);
    deps = [
      self.full."domelementtype"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  full."domutils"."1.0" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.0.1.tgz";
        sha1 = "58b58d774774911556c16b8b02d99c609d987869";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils"."1.0" or []);
    deps = [
      self.full."domelementtype"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  full."domutils"."1.1" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.1.6.tgz";
        sha1 = "bddc3de099b9a2efacc51c623f28f416ecc57485";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils"."1.1" or []);
    deps = [
      self.full."domelementtype"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  full."domutils"."1.2" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.2.1.tgz";
        sha1 = "6ced9837e63d2c3a06eb46d1150f0058a13178d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils"."1.2" or []);
    deps = [
      self.full."domelementtype"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  full."dtrace-provider"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "dtrace-provider-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dtrace-provider/-/dtrace-provider-0.2.8.tgz";
        sha1 = "e243f19219aa95fbf0d8f2ffb07f5bd64e94fe20";
      })
    ];
    buildInputs =
      (self.nativeDeps."dtrace-provider"."0.2.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "dtrace-provider" ];
  };
  full."editor"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "editor-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/editor/-/editor-0.0.4.tgz";
        sha1 = "478920f77bca6c1c1749d5e3edde4bd5966efda8";
      })
    ];
    buildInputs =
      (self.nativeDeps."editor"."0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "editor" ];
  };
  full."ejs"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "ejs-0.8.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ejs/-/ejs-0.8.3.tgz";
        sha1 = "db8aac47ff80a7df82b4c82c126fe8970870626f";
      })
    ];
    buildInputs =
      (self.nativeDeps."ejs"."0.8.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ejs" ];
  };
  full."emitter-component"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "emitter-component-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/emitter-component/-/emitter-component-0.0.6.tgz";
        sha1 = "c155d82f6d0c01b5bee856d58074a4cc59795bca";
      })
    ];
    buildInputs =
      (self.nativeDeps."emitter-component"."0.0.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "emitter-component" ];
  };
  full."emitter-component"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "emitter-component-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/emitter-component/-/emitter-component-1.0.0.tgz";
        sha1 = "f04dd18fc3dc3e9a74cbc0f310b088666e4c016f";
      })
    ];
    buildInputs =
      (self.nativeDeps."emitter-component"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "emitter-component" ];
  };
  full."encoding"."~0.1" = lib.makeOverridable self.buildNodePackage {
    name = "encoding-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/encoding/-/encoding-0.1.7.tgz";
        sha1 = "25cc19b34e9225d120c2ea769f9136c91cecc908";
      })
    ];
    buildInputs =
      (self.nativeDeps."encoding"."~0.1" or []);
    deps = [
      self.full."iconv-lite"."~0.2.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "encoding" ];
  };
  full."entities"."0.x" = lib.makeOverridable self.buildNodePackage {
    name = "entities-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-0.3.0.tgz";
        sha1 = "6ccead6010fee0c5a06f538d242792485cbfa256";
      })
    ];
    buildInputs =
      (self.nativeDeps."entities"."0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "entities" ];
  };
  full."es5-ext"."~0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "es5-ext-0.9.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es5-ext/-/es5-ext-0.9.2.tgz";
        sha1 = "d2e309d1f223b0718648835acf5b8823a8061f8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."es5-ext"."~0.9.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "es5-ext" ];
  };
  full."escape-html"."*" = lib.makeOverridable self.buildNodePackage {
    name = "escape-html-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.0.tgz";
        sha1 = "fedcd79564444ddaf2bd85b22c9961b3a3a38bf5";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-html"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escape-html" ];
  };
  "escape-html" = self.full."escape-html"."*";
  full."escodegen"."0.0.23" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-0.0.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-0.0.23.tgz";
        sha1 = "9acf978164368e42276571f18839c823b3a844df";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen"."0.0.23" or []);
    deps = [
      self.full."esprima"."~1.0.2"
      self.full."estraverse"."~0.0.4"
      self.full."source-map".">= 0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  full."esprima"."1.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima"."1.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  full."esprima"."~ 1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima"."~ 1.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  full."esprima"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  full."esprima"."~1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima"."~1.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  full."estraverse"."~0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-0.0.4.tgz";
        sha1 = "01a0932dfee574684a598af5a67c3bf9b6428db2";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse"."~0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  full."event-emitter"."~0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "event-emitter-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-emitter/-/event-emitter-0.2.2.tgz";
        sha1 = "c81e3724eb55407c5a0d5ee3299411f700f54291";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-emitter"."~0.2.2" or []);
    deps = [
      self.full."es5-ext"."~0.9.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "event-emitter" ];
  };
  full."event-stream"."~0.5" = lib.makeOverridable self.buildNodePackage {
    name = "event-stream-0.5.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-stream/-/event-stream-0.5.3.tgz";
        sha1 = "b77b9309f7107addfeab63f0c0eafd8db0bd8c1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-stream"."~0.5" or []);
    deps = [
      self.full."optimist"."0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "event-stream" ];
  };
  full."eventemitter2"."0.4.11" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter2-0.4.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.11.tgz";
        sha1 = "8bbf2b6ac7b31e2eea0c8d8f533ef41f849a9e2c";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2"."0.4.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  full."eventemitter2"."~0.4.11" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter2-0.4.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.13.tgz";
        sha1 = "0a8ab97f9c1b563361b8927f9e80606277509153";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2"."~0.4.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  full."eventemitter2"."~0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter2-0.4.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.13.tgz";
        sha1 = "0a8ab97f9c1b563361b8927f9e80606277509153";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter2"."~0.4.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter2" ];
  };
  full."events.node".">= 0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "events.node-0.4.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/events.node/-/events.node-0.4.9.tgz";
        sha1 = "82998ea749501145fd2da7cf8ecbe6420fac02a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."events.node".">= 0.4.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "events.node" ];
  };
  full."express"."*" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.0.tgz";
        sha1 = "6ed289da0d5f55ac30997cf832e5fc36f784071e";
      })
    ];
    buildInputs =
      (self.nativeDeps."express"."*" or []);
    deps = [
      self.full."connect"."2.9.0"
      self.full."commander"."1.2.0"
      self.full."range-parser"."0.0.4"
      self.full."mkdirp"."0.3.5"
      self.full."cookie"."0.1.0"
      self.full."buffer-crc32"."0.2.1"
      self.full."fresh"."0.2.0"
      self.full."methods"."0.0.1"
      self.full."send"."0.1.4"
      self.full."cookie-signature"."1.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  "express" = self.full."express"."*";
  full."express"."3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.2.0.tgz";
        sha1 = "7b66d6c66b038038eedf452804222b3077374ae0";
      })
    ];
    buildInputs =
      (self.nativeDeps."express"."3.2.0" or []);
    deps = [
      self.full."connect"."2.7.6"
      self.full."commander"."0.6.1"
      self.full."range-parser"."0.0.4"
      self.full."mkdirp"."~0.3.4"
      self.full."cookie"."0.0.5"
      self.full."buffer-crc32"."~0.2.1"
      self.full."fresh"."0.1.0"
      self.full."methods"."0.0.1"
      self.full."send"."0.1.0"
      self.full."cookie-signature"."1.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  full."express"."3.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.2.6.tgz";
        sha1 = "d8a9fe065adc23c5b41ec2c689c672b261430ffc";
      })
    ];
    buildInputs =
      (self.nativeDeps."express"."3.2.6" or []);
    deps = [
      self.full."connect"."2.7.11"
      self.full."commander"."0.6.1"
      self.full."range-parser"."0.0.4"
      self.full."mkdirp"."0.3.4"
      self.full."cookie"."0.1.0"
      self.full."buffer-crc32"."0.2.1"
      self.full."fresh"."0.1.0"
      self.full."methods"."0.0.1"
      self.full."send"."0.1.0"
      self.full."cookie-signature"."1.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  full."express"."3.x" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.0.tgz";
        sha1 = "6ed289da0d5f55ac30997cf832e5fc36f784071e";
      })
    ];
    buildInputs =
      (self.nativeDeps."express"."3.x" or []);
    deps = [
      self.full."connect"."2.9.0"
      self.full."commander"."1.2.0"
      self.full."range-parser"."0.0.4"
      self.full."mkdirp"."0.3.5"
      self.full."cookie"."0.1.0"
      self.full."buffer-crc32"."0.2.1"
      self.full."fresh"."0.2.0"
      self.full."methods"."0.0.1"
      self.full."send"."0.1.4"
      self.full."cookie-signature"."1.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  full."express"."~3.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.1.2.tgz";
        sha1 = "52a02c8db8f22bbfa0d7478d847cd45161f985f7";
      })
    ];
    buildInputs =
      (self.nativeDeps."express"."~3.1.1" or []);
    deps = [
      self.full."connect"."2.7.5"
      self.full."commander"."0.6.1"
      self.full."range-parser"."0.0.4"
      self.full."mkdirp"."~0.3.4"
      self.full."cookie"."0.0.5"
      self.full."buffer-crc32"."~0.2.1"
      self.full."fresh"."0.1.0"
      self.full."methods"."0.0.1"
      self.full."send"."0.1.0"
      self.full."cookie-signature"."1.0.0"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  full."express"."~3.4" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.4.0.tgz";
        sha1 = "6ed289da0d5f55ac30997cf832e5fc36f784071e";
      })
    ];
    buildInputs =
      (self.nativeDeps."express"."~3.4" or []);
    deps = [
      self.full."connect"."2.9.0"
      self.full."commander"."1.2.0"
      self.full."range-parser"."0.0.4"
      self.full."mkdirp"."0.3.5"
      self.full."cookie"."0.1.0"
      self.full."buffer-crc32"."0.2.1"
      self.full."fresh"."0.2.0"
      self.full."methods"."0.0.1"
      self.full."send"."0.1.4"
      self.full."cookie-signature"."1.0.1"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  full."express-form"."*" = lib.makeOverridable self.buildNodePackage {
    name = "express-form-0.8.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-form/-/express-form-0.8.1.tgz";
        sha1 = "14299158646a796fac584cb5980d63e587c02019";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-form"."*" or []);
    deps = [
      self.full."validator"."0.4.x"
      self.full."object-additions".">= 0.5.0"
    ];
    peerDependencies = [
      self.full."express"."3.x"
    ];
    passthru.names = [ "express-form" ];
  };
  "express-form" = self.full."express-form"."*";
  full."express-partials"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "express-partials-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express-partials/-/express-partials-0.0.6.tgz";
        sha1 = "b2664f15c636d5248e60fdbe29131c4440552eda";
      })
    ];
    buildInputs =
      (self.nativeDeps."express-partials"."0.0.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express-partials" ];
  };
  full."extend"."*" = lib.makeOverridable self.buildNodePackage {
    name = "extend-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-1.2.1.tgz";
        sha1 = "a0f5fd6cfc83a5fe49ef698d60ec8a624dd4576c";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extend" ];
  };
  "extend" = self.full."extend"."*";
  full."extsprintf"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "extsprintf-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.0.tgz";
        sha1 = "4d58b815ace5bebfc4ebf03cf98b0a7604a99b86";
      })
    ];
    buildInputs =
      (self.nativeDeps."extsprintf"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extsprintf" ];
  };
  full."extsprintf"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "extsprintf-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
        sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
      })
    ];
    buildInputs =
      (self.nativeDeps."extsprintf"."1.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "extsprintf" ];
  };
  full."eyes"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "eyes-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eyes"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eyes" ];
  };
  full."eyes".">=0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "eyes-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eyes".">=0.1.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eyes" ];
  };
  full."faye-websocket"."*" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.7.0.tgz";
        sha1 = "c16c50ec0d483357a8eafd1ec6fcc313d027f5be";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket"."*" or []);
    deps = [
      self.full."websocket-driver".">=0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  "faye-websocket" = self.full."faye-websocket"."*";
  full."faye-websocket"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "faye-websocket-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.4.4.tgz";
        sha1 = "c14c5b3bf14d7417ffbfd990c0a7495cd9f337bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."faye-websocket"."0.4.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "faye-websocket" ];
  };
  full."fileset"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "fileset-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fileset/-/fileset-0.1.5.tgz";
        sha1 = "acc423bfaf92843385c66bf75822264d11b7bd94";
      })
    ];
    buildInputs =
      (self.nativeDeps."fileset"."0.1.x" or []);
    deps = [
      self.full."minimatch"."0.x"
      self.full."glob"."3.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fileset" ];
  };
  full."findup-sync"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "findup-sync-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.2.tgz";
        sha1 = "da2b96ca9f800e5a13d0a11110f490b65f62e96d";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup-sync"."~0.1.0" or []);
    deps = [
      self.full."glob"."~3.1.21"
      self.full."lodash"."~1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findup-sync" ];
  };
  full."findup-sync"."~0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "findup-sync-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.2.tgz";
        sha1 = "da2b96ca9f800e5a13d0a11110f490b65f62e96d";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup-sync"."~0.1.2" or []);
    deps = [
      self.full."glob"."~3.1.21"
      self.full."lodash"."~1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "findup-sync" ];
  };
  full."flatiron"."*" = lib.makeOverridable self.buildNodePackage {
    name = "flatiron-0.3.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flatiron/-/flatiron-0.3.8.tgz";
        sha1 = "235d691f19154eff033610c12bcd51f304ff09c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."flatiron"."*" or []);
    deps = [
      self.full."broadway"."0.2.7"
      self.full."optimist"."0.3.5"
      self.full."prompt"."0.2.11"
      self.full."director"."1.1.10"
      self.full."pkginfo"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "flatiron" ];
  };
  "flatiron" = self.full."flatiron"."*";
  full."flatiron"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "flatiron-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flatiron/-/flatiron-0.3.5.tgz";
        sha1 = "a91fe730f6a7fc1ea655a0ca48eaa977bef64625";
      })
    ];
    buildInputs =
      (self.nativeDeps."flatiron"."0.3.5" or []);
    deps = [
      self.full."broadway"."0.2.7"
      self.full."optimist"."0.3.5"
      self.full."prompt"."0.2.9"
      self.full."director"."1.1.10"
      self.full."pkginfo"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "flatiron" ];
  };
  full."follow-redirects"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "follow-redirects-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/follow-redirects/-/follow-redirects-0.0.3.tgz";
        sha1 = "6ce67a24db1fe13f226c1171a72a7ef2b17b8f65";
      })
    ];
    buildInputs =
      (self.nativeDeps."follow-redirects"."0.0.3" or []);
    deps = [
      self.full."underscore"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "follow-redirects" ];
  };
  full."forEachAsync"."~2.2" = lib.makeOverridable self.buildNodePackage {
    name = "forEachAsync-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forEachAsync/-/forEachAsync-2.2.0.tgz";
        sha1 = "093b32ce868cb69f5166dcf331fae074adc71cee";
      })
    ];
    buildInputs =
      (self.nativeDeps."forEachAsync"."~2.2" or []);
    deps = [
      self.full."sequence".">= 2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forEachAsync" ];
  };
  full."forever"."*" = lib.makeOverridable self.buildNodePackage {
    name = "forever-0.10.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever/-/forever-0.10.8.tgz";
        sha1 = "a78137a46fb8ca4adbf2f497d98816a526bb1f82";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever"."*" or []);
    deps = [
      self.full."colors"."0.6.0-1"
      self.full."cliff"."0.1.8"
      self.full."flatiron"."0.3.5"
      self.full."forever-monitor"."1.2.2"
      self.full."nconf"."0.6.7"
      self.full."nssocket"."~0.5.1"
      self.full."optimist"."0.4.0"
      self.full."pkginfo"."0.3.0"
      self.full."timespan"."2.0.1"
      self.full."watch"."0.7.0"
      self.full."utile"."0.1.7"
      self.full."winston"."0.7.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever" ];
  };
  "forever" = self.full."forever"."*";
  full."forever-agent"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.2.0.tgz";
        sha1 = "e1c25c7ad44e09c38f233876c76fcc24ff843b1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  full."forever-agent"."~0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.0.tgz";
        sha1 = "0c1647a74f3af12d76a07a99490ade7c7249c8f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent"."~0.5.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  full."forever-monitor"."*" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.2.3.tgz";
        sha1 = "b27ac3acb6fdcc7315d6cd85830f2d004733028b";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor"."*" or []);
    deps = [
      self.full."broadway"."0.2.x"
      self.full."minimatch"."0.2.x"
      self.full."pkginfo"."0.x.x"
      self.full."ps-tree"."0.0.x"
      self.full."watch"."0.5.x"
      self.full."utile"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  "forever-monitor" = self.full."forever-monitor"."*";
  full."forever-monitor"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.1.0.tgz";
        sha1 = "439ce036f999601cff551aea7f5151001a869ef9";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor"."1.1.0" or []);
    deps = [
      self.full."broadway"."0.2.x"
      self.full."minimatch"."0.0.x"
      self.full."pkginfo"."0.x.x"
      self.full."ps-tree"."0.0.x"
      self.full."watch"."0.5.x"
      self.full."utile"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  full."forever-monitor"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "forever-monitor-1.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-monitor/-/forever-monitor-1.2.2.tgz";
        sha1 = "c1ad6c6ab837a89fa2d47bb439727ca968235684";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-monitor"."1.2.2" or []);
    deps = [
      self.full."broadway"."0.2.x"
      self.full."minimatch"."0.0.x"
      self.full."pkginfo"."0.x.x"
      self.full."ps-tree"."0.0.x"
      self.full."watch"."0.5.x"
      self.full."utile"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-monitor" ];
  };
  full."form-data"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.8.tgz";
        sha1 = "0890cd1005c5ccecc0b9d24a88052c92442d0db5";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data"."0.0.8" or []);
    deps = [
      self.full."combined-stream"."~0.0.4"
      self.full."mime"."~1.2.2"
      self.full."async"."~0.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  full."form-data"."~0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.10.tgz";
        sha1 = "db345a5378d86aeeb1ed5d553b869ac192d2f5ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data"."~0.0.3" or []);
    deps = [
      self.full."combined-stream"."~0.0.4"
      self.full."mime"."~1.2.2"
      self.full."async"."~0.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  full."form-data"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.2.tgz";
        sha1 = "1143c21357911a78dd7913b189b4bab5d5d57445";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data"."~0.1.0" or []);
    deps = [
      self.full."combined-stream"."~0.0.4"
      self.full."mime"."~1.2.11"
      self.full."async"."~0.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  full."formidable"."1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.11.tgz";
        sha1 = "68f63325a035e644b6f7bb3d11243b9761de1b30";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable"."1.0.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  full."formidable"."1.0.13" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.13.tgz";
        sha1 = "70caf0f9d69692a77e04021ddab4f46b01c82aea";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable"."1.0.13" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  full."formidable"."1.0.14" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.14.tgz";
        sha1 = "2b3f4c411cbb5fdd695c44843e2a23514a43231a";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable"."1.0.14" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  full."formidable"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "formidable-1.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/formidable/-/formidable-1.0.9.tgz";
        sha1 = "419e3bccead3e8874d539f5b3e72a4c503b31a98";
      })
    ];
    buildInputs =
      (self.nativeDeps."formidable"."1.0.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "formidable" ];
  };
  full."fresh"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.1.0.tgz";
        sha1 = "03e4b0178424e4c2d5d19a54d8814cdc97934850";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh"."0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  full."fresh"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.0.tgz";
        sha1 = "bfd9402cf3df12c4a4c310c79f99a3dde13d34a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh"."0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  full."fs-walk"."*" = lib.makeOverridable self.buildNodePackage {
    name = "fs-walk-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-walk/-/fs-walk-0.0.1.tgz";
        sha1 = "f7fc91c3ae1eead07c998bc5d0dd41f2dbebd335";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-walk"."*" or []);
    deps = [
      self.full."async"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-walk" ];
  };
  "fs-walk" = self.full."fs-walk"."*";
  full."fstream"."0" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.24.tgz";
        sha1 = "267fe9d034f46bc99f824789d38b987ad01be884";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream"."0" or []);
    deps = [
      self.full."rimraf"."2"
      self.full."mkdirp"."0.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  full."fstream"."~0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.24.tgz";
        sha1 = "267fe9d034f46bc99f824789d38b987ad01be884";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream"."~0.1.17" or []);
    deps = [
      self.full."rimraf"."2"
      self.full."mkdirp"."0.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  full."fstream"."~0.1.21" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.24.tgz";
        sha1 = "267fe9d034f46bc99f824789d38b987ad01be884";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream"."~0.1.21" or []);
    deps = [
      self.full."rimraf"."2"
      self.full."mkdirp"."0.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  full."fstream"."~0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.24.tgz";
        sha1 = "267fe9d034f46bc99f824789d38b987ad01be884";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream"."~0.1.22" or []);
    deps = [
      self.full."rimraf"."2"
      self.full."mkdirp"."0.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  full."fstream"."~0.1.23" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.24.tgz";
        sha1 = "267fe9d034f46bc99f824789d38b987ad01be884";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream"."~0.1.23" or []);
    deps = [
      self.full."rimraf"."2"
      self.full."mkdirp"."0.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  full."fstream"."~0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.24.tgz";
        sha1 = "267fe9d034f46bc99f824789d38b987ad01be884";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream"."~0.1.8" or []);
    deps = [
      self.full."rimraf"."2"
      self.full."mkdirp"."0.3"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."~2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  full."fstream-ignore"."~0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-ignore-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-0.0.7.tgz";
        sha1 = "eea3033f0c3728139de7b57ab1b0d6d89c353c63";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-ignore"."~0.0.5" or []);
    deps = [
      self.full."minimatch"."~0.2.0"
      self.full."fstream"."~0.1.17"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream-ignore" ];
  };
  full."fstream-ignore"."~0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-ignore-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-0.0.7.tgz";
        sha1 = "eea3033f0c3728139de7b57ab1b0d6d89c353c63";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-ignore"."~0.0.6" or []);
    deps = [
      self.full."minimatch"."~0.2.0"
      self.full."fstream"."~0.1.17"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream-ignore" ];
  };
  full."fstream-npm"."~0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-npm-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-npm/-/fstream-npm-0.1.5.tgz";
        sha1 = "8f9fdd38c0940f91f7b6ebda4b6611be88f97ec9";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-npm"."~0.1.3" or []);
    deps = [
      self.full."fstream-ignore"."~0.0.5"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream-npm" ];
  };
  full."generator-angular"."*" = lib.makeOverridable self.buildNodePackage {
    name = "generator-angular-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-angular/-/generator-angular-0.4.0.tgz";
        sha1 = "4fbaaa87b829f3f2fc72fac3da1fa47ff801ca1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-angular"."*" or []);
    deps = [
      self.full."yeoman-generator"."~0.13.0"
    ];
    peerDependencies = [
      self.full."generator-karma"."~0.5.0"
      self.full."yo".">=1.0.0-rc.1.1"
    ];
    passthru.names = [ "generator-angular" ];
  };
  "generator-angular" = self.full."generator-angular"."*";
  full."generator-karma"."~0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "generator-karma-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-karma/-/generator-karma-0.5.0.tgz";
        sha1 = "3b9dc1154e232a135c0e4598834540977038617d";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-karma"."~0.5.0" or []);
    deps = [
      self.full."yeoman-generator"."~0.13.0"
    ];
    peerDependencies = [
      self.full."yo".">=1.0.0-rc.1.1"
    ];
    passthru.names = [ "generator-karma" ];
  };
  full."generator-mocha"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "generator-mocha-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-mocha/-/generator-mocha-0.1.1.tgz";
        sha1 = "818f7028a1c149774a882a0e3c7c04ba9852d7d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-mocha"."~0.1.1" or []);
    deps = [
      self.full."yeoman-generator"."~0.10.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "generator-mocha" ];
  };
  full."generator-webapp"."*" = lib.makeOverridable self.buildNodePackage {
    name = "generator-webapp-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generator-webapp/-/generator-webapp-0.4.3.tgz";
        sha1 = "c0ad11753e0f4403d1d7fad1b298e52bfa5e231b";
      })
    ];
    buildInputs =
      (self.nativeDeps."generator-webapp"."*" or []);
    deps = [
      self.full."yeoman-generator"."~0.13.1"
      self.full."cheerio"."~0.12.1"
    ];
    peerDependencies = [
      self.full."yo".">=1.0.0-rc.1.1"
      self.full."generator-mocha"."~0.1.1"
    ];
    passthru.names = [ "generator-webapp" ];
  };
  "generator-webapp" = self.full."generator-webapp"."*";
  full."github-url-from-git"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-git-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-git/-/github-url-from-git-1.1.1.tgz";
        sha1 = "1f89623453123ef9623956e264c60bf4c3cf5ccf";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-url-from-git"."1.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "github-url-from-git" ];
  };
  full."github-url-from-git"."~1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "github-url-from-git-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/github-url-from-git/-/github-url-from-git-1.1.1.tgz";
        sha1 = "1f89623453123ef9623956e264c60bf4c3cf5ccf";
      })
    ];
    buildInputs =
      (self.nativeDeps."github-url-from-git"."~1.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "github-url-from-git" ];
  };
  full."glob"."3" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.6.tgz";
        sha1 = "28c805b47bc6c19ba3059cbdf079b98ff62442f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."3" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."3.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.3.tgz";
        sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."3.2.3" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."graceful-fs"."~2.0.0"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."3.x" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.6.tgz";
        sha1 = "28c805b47bc6c19ba3059cbdf079b98ff62442f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."3.x" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob".">= 3.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.6.tgz";
        sha1 = "28c805b47bc6c19ba3059cbdf079b98ff62442f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob".">= 3.1.4" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."~3.1.21" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.1.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.1.21.tgz";
        sha1 = "d29e0a055dea5138f4d07ed40e8982e83c2066cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."~3.1.21" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."graceful-fs"."~1.2.0"
      self.full."inherits"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."~3.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.6.tgz";
        sha1 = "28c805b47bc6c19ba3059cbdf079b98ff62442f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."~3.2.0" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."~3.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.6.tgz";
        sha1 = "28c805b47bc6c19ba3059cbdf079b98ff62442f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."~3.2.1" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."~3.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.6.tgz";
        sha1 = "28c805b47bc6c19ba3059cbdf079b98ff62442f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob"."~3.2.6" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."graceful-fs"."1.2" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."1.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."2" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.1.tgz";
        sha1 = "7fd6e0a4837c35d0cc15330294d9584a3898cf84";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~1" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~1.1" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.1.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.1.14.tgz";
        sha1 = "07078db5f6377f6321fceaaedf497de124dc9465";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~1.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~1.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~1.2.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~2" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.1.tgz";
        sha1 = "7fd6e0a4837c35d0cc15330294d9584a3898cf84";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."graceful-fs"."~2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.1.tgz";
        sha1 = "7fd6e0a4837c35d0cc15330294d9584a3898cf84";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~2.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  full."gridfs-stream"."*" = lib.makeOverridable self.buildNodePackage {
    name = "gridfs-stream-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gridfs-stream/-/gridfs-stream-0.4.0.tgz";
        sha1 = "f76f791e0d1b22649e11beeacddf8e62bd89ca2a";
      })
    ];
    buildInputs =
      (self.nativeDeps."gridfs-stream"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gridfs-stream" ];
  };
  "gridfs-stream" = self.full."gridfs-stream"."*";
  full."growl"."1.7.x" = lib.makeOverridable self.buildNodePackage {
    name = "growl-1.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/growl/-/growl-1.7.0.tgz";
        sha1 = "de2d66136d002e112ba70f3f10c31cf7c350b2da";
      })
    ];
    buildInputs =
      (self.nativeDeps."growl"."1.7.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "growl" ];
  };
  full."grunt"."0.4.x" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt/-/grunt-0.4.1.tgz";
        sha1 = "d5892e5680add9ed1befde9aa635cf46b8f49729";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt"."0.4.x" or []);
    deps = [
      self.full."async"."~0.1.22"
      self.full."coffee-script"."~1.3.3"
      self.full."colors"."~0.6.0-1"
      self.full."dateformat"."1.0.2-1.2.3"
      self.full."eventemitter2"."~0.4.9"
      self.full."findup-sync"."~0.1.0"
      self.full."glob"."~3.1.21"
      self.full."hooker"."~0.2.3"
      self.full."iconv-lite"."~0.2.5"
      self.full."minimatch"."~0.2.6"
      self.full."nopt"."~1.0.10"
      self.full."rimraf"."~2.0.2"
      self.full."lodash"."~0.9.0"
      self.full."underscore.string"."~2.2.0rc"
      self.full."which"."~1.0.5"
      self.full."js-yaml"."~2.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt" ];
  };
  full."grunt"."~0.4" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt/-/grunt-0.4.1.tgz";
        sha1 = "d5892e5680add9ed1befde9aa635cf46b8f49729";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt"."~0.4" or []);
    deps = [
      self.full."async"."~0.1.22"
      self.full."coffee-script"."~1.3.3"
      self.full."colors"."~0.6.0-1"
      self.full."dateformat"."1.0.2-1.2.3"
      self.full."eventemitter2"."~0.4.9"
      self.full."findup-sync"."~0.1.0"
      self.full."glob"."~3.1.21"
      self.full."hooker"."~0.2.3"
      self.full."iconv-lite"."~0.2.5"
      self.full."minimatch"."~0.2.6"
      self.full."nopt"."~1.0.10"
      self.full."rimraf"."~2.0.2"
      self.full."lodash"."~0.9.0"
      self.full."underscore.string"."~2.2.0rc"
      self.full."which"."~1.0.5"
      self.full."js-yaml"."~2.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt" ];
  };
  full."grunt"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt/-/grunt-0.4.1.tgz";
        sha1 = "d5892e5680add9ed1befde9aa635cf46b8f49729";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt"."~0.4.0" or []);
    deps = [
      self.full."async"."~0.1.22"
      self.full."coffee-script"."~1.3.3"
      self.full."colors"."~0.6.0-1"
      self.full."dateformat"."1.0.2-1.2.3"
      self.full."eventemitter2"."~0.4.9"
      self.full."findup-sync"."~0.1.0"
      self.full."glob"."~3.1.21"
      self.full."hooker"."~0.2.3"
      self.full."iconv-lite"."~0.2.5"
      self.full."minimatch"."~0.2.6"
      self.full."nopt"."~1.0.10"
      self.full."rimraf"."~2.0.2"
      self.full."lodash"."~0.9.0"
      self.full."underscore.string"."~2.2.0rc"
      self.full."which"."~1.0.5"
      self.full."js-yaml"."~2.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt" ];
  };
  full."grunt-cli"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-cli-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-cli/-/grunt-cli-0.1.9.tgz";
        sha1 = "3f08bfb0bef30ba33083defe53efe0575cbe4e14";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-cli"."*" or []);
    deps = [
      self.full."nopt"."~1.0.10"
      self.full."findup-sync"."~0.1.0"
      self.full."resolve"."~0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-cli" ];
  };
  "grunt-cli" = self.full."grunt-cli"."*";
  full."grunt-cli"."~0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-cli-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-cli/-/grunt-cli-0.1.9.tgz";
        sha1 = "3f08bfb0bef30ba33083defe53efe0575cbe4e14";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-cli"."~0.1.7" or []);
    deps = [
      self.full."nopt"."~1.0.10"
      self.full."findup-sync"."~0.1.0"
      self.full."resolve"."~0.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-cli" ];
  };
  full."grunt-contrib-cssmin"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-cssmin-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-cssmin/-/grunt-contrib-cssmin-0.6.2.tgz";
        sha1 = "2804dc0e81f98e8a54d61eee84a1d3fe1a3af8e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-cssmin"."*" or []);
    deps = [
      self.full."clean-css"."~1.1.1"
      self.full."grunt-lib-contrib"."~0.6.0"
    ];
    peerDependencies = [
      self.full."grunt"."~0.4.0"
    ];
    passthru.names = [ "grunt-contrib-cssmin" ];
  };
  "grunt-contrib-cssmin" = self.full."grunt-contrib-cssmin"."*";
  full."grunt-contrib-jshint"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-jshint-0.6.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-jshint/-/grunt-contrib-jshint-0.6.4.tgz";
        sha1 = "c5a0e56c13d3f758cf1b5d0786dcb4a7d4b4d748";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-jshint"."*" or []);
    deps = [
      self.full."jshint"."~2.1.10"
    ];
    peerDependencies = [
      self.full."grunt"."~0.4.0"
    ];
    passthru.names = [ "grunt-contrib-jshint" ];
  };
  "grunt-contrib-jshint" = self.full."grunt-contrib-jshint"."*";
  full."grunt-contrib-less"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-less-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-less/-/grunt-contrib-less-0.7.0.tgz";
        sha1 = "35f6513e47ec5f3c99188d46efa9dcf378207be8";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-less"."*" or []);
    deps = [
      self.full."less"."~1.4.0"
      self.full."grunt-lib-contrib"."~0.6.1"
    ];
    peerDependencies = [
      self.full."grunt"."~0.4.0"
    ];
    passthru.names = [ "grunt-contrib-less" ];
  };
  "grunt-contrib-less" = self.full."grunt-contrib-less"."*";
  full."grunt-contrib-requirejs"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-requirejs-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-requirejs/-/grunt-contrib-requirejs-0.4.1.tgz";
        sha1 = "862ba167141b8a8f36af5444feab3272bb8cf4bd";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-requirejs"."*" or []);
    deps = [
      self.full."requirejs"."~2.1.0"
    ];
    peerDependencies = [
      self.full."grunt"."~0.4.0"
    ];
    passthru.names = [ "grunt-contrib-requirejs" ];
  };
  "grunt-contrib-requirejs" = self.full."grunt-contrib-requirejs"."*";
  full."grunt-contrib-uglify"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-contrib-uglify-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-0.2.4.tgz";
        sha1 = "51113f28a72432521e35e63f7f18a251fda2fd49";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-contrib-uglify"."*" or []);
    deps = [
      self.full."uglify-js"."~2.4.0"
      self.full."grunt-lib-contrib"."~0.6.1"
    ];
    peerDependencies = [
      self.full."grunt"."~0.4.0"
    ];
    passthru.names = [ "grunt-contrib-uglify" ];
  };
  "grunt-contrib-uglify" = self.full."grunt-contrib-uglify"."*";
  full."grunt-karma"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-karma-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-karma/-/grunt-karma-0.7.1.tgz";
        sha1 = "7fb8c40988b8e88da454afb821a7a925ed05ff81";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-karma"."*" or []);
    deps = [
      self.full."optimist"."~0.6.0"
    ];
    peerDependencies = [
      self.full."grunt"."0.4.x"
      self.full."karma"."~0.10.0"
    ];
    passthru.names = [ "grunt-karma" ];
  };
  "grunt-karma" = self.full."grunt-karma"."*";
  full."grunt-lib-contrib"."~0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-lib-contrib-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-lib-contrib/-/grunt-lib-contrib-0.6.1.tgz";
        sha1 = "3f56adb7da06e814795ee2415b0ebe5fb8903ebb";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-lib-contrib"."~0.6.0" or []);
    deps = [
      self.full."zlib-browserify"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-lib-contrib" ];
  };
  full."grunt-lib-contrib"."~0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-lib-contrib-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-lib-contrib/-/grunt-lib-contrib-0.6.1.tgz";
        sha1 = "3f56adb7da06e814795ee2415b0ebe5fb8903ebb";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-lib-contrib"."~0.6.1" or []);
    deps = [
      self.full."zlib-browserify"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "grunt-lib-contrib" ];
  };
  full."grunt-sed"."*" = lib.makeOverridable self.buildNodePackage {
    name = "grunt-sed-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grunt-sed/-/grunt-sed-0.1.1.tgz";
        sha1 = "2613d486909319b3f8f4bd75dafb46a642ec3f82";
      })
    ];
    buildInputs =
      (self.nativeDeps."grunt-sed"."*" or []);
    deps = [
      self.full."replace"."~0.2.4"
    ];
    peerDependencies = [
      self.full."grunt"."~0.4"
    ];
    passthru.names = [ "grunt-sed" ];
  };
  "grunt-sed" = self.full."grunt-sed"."*";
  full."guifi-earth"."https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854 " = lib.makeOverridable self.buildNodePackage {
    name = "guifi-earth-0.2.1";
    src = [
      (fetchurl {
        url = "https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854";
        sha256 = "a51a5beef55c14c68630275d51cf66c44a4462d1b20c0f08aef6d88a62ca077c";
      })
    ];
    buildInputs =
      (self.nativeDeps."guifi-earth"."https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854 " or []);
    deps = [
      self.full."coffee-script".">= 0.0.1"
      self.full."jade".">= 0.0.1"
      self.full."q".">= 0.0.1"
      self.full."xml2js".">= 0.0.1"
      self.full."msgpack".">= 0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "guifi-earth" ];
  };
  "guifi-earth" = self.full."guifi-earth"."https://github.com/jmendeth/guifi-earth/tarball/f3ee96835fd4fb0e3e12fadbd2cb782770d64854 ";
  full."gzippo"."*" = lib.makeOverridable self.buildNodePackage {
    name = "gzippo-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gzippo/-/gzippo-0.2.0.tgz";
        sha1 = "ffc594c482190c56531ed2d4a5864d0b0b7d2733";
      })
    ];
    buildInputs =
      (self.nativeDeps."gzippo"."*" or []);
    deps = [
      self.full."send"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gzippo" ];
  };
  "gzippo" = self.full."gzippo"."*";
  full."handlebars"."1.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.0.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.0.12.tgz";
        sha1 = "18c6d3440c35e91b19b3ff582b9151ab4985d4fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars"."1.0.x" or []);
    deps = [
      self.full."optimist"."~0.3"
      self.full."uglify-js"."~2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  full."handlebars"."~1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.0.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.0.12.tgz";
        sha1 = "18c6d3440c35e91b19b3ff582b9151ab4985d4fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars"."~1.0.11" or []);
    deps = [
      self.full."optimist"."~0.3"
      self.full."uglify-js"."~2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  full."has-color"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "has-color-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-color/-/has-color-0.1.1.tgz";
        sha1 = "28cc90127bc5448f99e76096dc97470a94a66720";
      })
    ];
    buildInputs =
      (self.nativeDeps."has-color"."~0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "has-color" ];
  };
  full."hasher"."~1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "hasher-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hasher/-/hasher-1.1.4.tgz";
        sha1 = "cb0a6c480bfa402adfbd4208452c64c684da9490";
      })
    ];
    buildInputs =
      (self.nativeDeps."hasher"."~1.1.4" or []);
    deps = [
      self.full."signals".">0.7 <2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hasher" ];
  };
  full."hat"."*" = lib.makeOverridable self.buildNodePackage {
    name = "hat-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hat/-/hat-0.0.3.tgz";
        sha1 = "bb014a9e64b3788aed8005917413d4ff3d502d8a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hat"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hat" ];
  };
  full."hawk"."~0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.10.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.10.2.tgz";
        sha1 = "9b361dee95a931640e6d504e05609a8fc3ac45d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk"."~0.10.0" or []);
    deps = [
      self.full."hoek"."0.7.x"
      self.full."boom"."0.3.x"
      self.full."cryptiles"."0.1.x"
      self.full."sntp"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  full."hawk"."~0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.10.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.10.2.tgz";
        sha1 = "9b361dee95a931640e6d504e05609a8fc3ac45d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk"."~0.10.2" or []);
    deps = [
      self.full."hoek"."0.7.x"
      self.full."boom"."0.3.x"
      self.full."cryptiles"."0.1.x"
      self.full."sntp"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  full."hawk"."~0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.13.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.13.1.tgz";
        sha1 = "3617958821f58311e4d7f6de291fca662b412ef4";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk"."~0.13.0" or []);
    deps = [
      self.full."hoek"."0.8.x"
      self.full."boom"."0.4.x"
      self.full."cryptiles"."0.2.x"
      self.full."sntp"."0.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  full."hawk"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.0.0.tgz";
        sha1 = "b90bb169807285411da7ffcb8dd2598502d3b52d";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk"."~1.0.0" or []);
    deps = [
      self.full."hoek"."0.9.x"
      self.full."boom"."0.4.x"
      self.full."cryptiles"."0.2.x"
      self.full."sntp"."0.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  full."hiredis"."*" = lib.makeOverridable self.buildNodePackage {
    name = "hiredis-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hiredis/-/hiredis-0.1.15.tgz";
        sha1 = "00eb2205c85dcf50de838203e513896dc304dd49";
      })
    ];
    buildInputs =
      (self.nativeDeps."hiredis"."*" or []);
    deps = [
      self.full."bindings"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hiredis" ];
  };
  full."hoek"."0.7.x" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.7.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.7.6.tgz";
        sha1 = "60fbd904557541cd2b8795abf308a1b3770e155a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek"."0.7.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  full."hoek"."0.8.x" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.8.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.8.5.tgz";
        sha1 = "1e9fd770ef7ebe0274adfcb5b0806a025a5e4e9f";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek"."0.8.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  full."hoek"."0.9.x" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.9.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
        sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek"."0.9.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  full."hooker"."~0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "hooker-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hooker/-/hooker-0.2.3.tgz";
        sha1 = "b834f723cc4a242aa65963459df6d984c5d3d959";
      })
    ];
    buildInputs =
      (self.nativeDeps."hooker"."~0.2.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hooker" ];
  };
  full."hooks"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "hooks-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hooks/-/hooks-0.2.1.tgz";
        sha1 = "0f591b1b344bdcb3df59773f62fbbaf85bf4028b";
      })
    ];
    buildInputs =
      (self.nativeDeps."hooks"."0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hooks" ];
  };
  full."htdigest"."1.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "htdigest-1.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htdigest/-/htdigest-1.0.7.tgz";
        sha1 = "0c55ba3a018855e134fd82f7a4aa6235167181b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."htdigest"."1.0.7" or []);
    deps = [
      self.full."commander"."0.5.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htdigest" ];
  };
  full."htmlparser2"."2.x" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-2.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-2.6.0.tgz";
        sha1 = "b28564ea9d1ba56a104ace6a7b0fdda2f315836f";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2"."2.x" or []);
    deps = [
      self.full."domhandler"."2.0"
      self.full."domutils"."1.0"
      self.full."domelementtype"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  full."htmlparser2"."3.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-3.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.1.4.tgz";
        sha1 = "72cbe7d5d56c01acf61fcf7b933331f4e45b36f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2"."3.1.4" or []);
    deps = [
      self.full."domhandler"."2.0"
      self.full."domutils"."1.1"
      self.full."domelementtype"."1"
      self.full."readable-stream"."1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  full."htpasswd"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "htpasswd-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htpasswd/-/htpasswd-1.1.0.tgz";
        sha1 = "4e9e6a2203405005aa1ae7dee80d3b6d6a8d93d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."htpasswd"."1.1.0" or []);
    deps = [
      self.full."commander"."0.5.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htpasswd" ];
  };
  full."http-auth"."1.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "http-auth-1.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-auth/-/http-auth-1.2.7.tgz";
        sha1 = "d15b9c08646c9fdcc4f92edb9888f57cb6cf9ca7";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-auth"."1.2.7" or []);
    deps = [
      self.full."node-uuid"."1.2.0"
      self.full."htpasswd"."1.1.0"
      self.full."htdigest"."1.0.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-auth" ];
  };
  full."http-proxy"."~0.10" = lib.makeOverridable self.buildNodePackage {
    name = "http-proxy-0.10.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-proxy/-/http-proxy-0.10.3.tgz";
        sha1 = "72ca9d503a75e064650084c58ca11b82e4b0196d";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-proxy"."~0.10" or []);
    deps = [
      self.full."colors"."0.x.x"
      self.full."optimist"."0.3.x"
      self.full."pkginfo"."0.2.x"
      self.full."utile"."~0.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-proxy" ];
  };
  full."http-signature"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.9.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.9.11.tgz";
        sha1 = "9e882714572315e6790a5d0a7955efff1f19e653";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature"."0.9.11" or []);
    deps = [
      self.full."assert-plus"."0.1.2"
      self.full."asn1"."0.1.11"
      self.full."ctype"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  full."http-signature"."~0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.0.tgz";
        sha1 = "1494e4f5000a83c0f11bcc12d6007c530cb99582";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature"."~0.10.0" or []);
    deps = [
      self.full."assert-plus"."0.1.2"
      self.full."asn1"."0.1.11"
      self.full."ctype"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  full."http-signature"."~0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.9.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.9.11.tgz";
        sha1 = "9e882714572315e6790a5d0a7955efff1f19e653";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature"."~0.9.11" or []);
    deps = [
      self.full."assert-plus"."0.1.2"
      self.full."asn1"."0.1.11"
      self.full."ctype"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  full."i"."0.3.x" = lib.makeOverridable self.buildNodePackage {
    name = "i-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/i/-/i-0.3.2.tgz";
        sha1 = "b2e2d6ef47900bd924e281231ff4c5cc798d9ea8";
      })
    ];
    buildInputs =
      (self.nativeDeps."i"."0.3.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "i" ];
  };
  full."i18next"."*" = lib.makeOverridable self.buildNodePackage {
    name = "i18next-1.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/i18next/-/i18next-1.7.1.tgz";
        sha1 = "39616a1fe88258edbdd0da918b9ee49a1bd1e124";
      })
    ];
    buildInputs =
      (self.nativeDeps."i18next"."*" or []);
    deps = [
      self.full."cookies".">= 0.2.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "i18next" ];
  };
  "i18next" = self.full."i18next"."*";
  full."iconv-lite"."~0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.2.11.tgz";
        sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite"."~0.2.10" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  full."iconv-lite"."~0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.2.11.tgz";
        sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite"."~0.2.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  full."iconv-lite"."~0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.2.11.tgz";
        sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite"."~0.2.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  full."inherits"."1" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
        sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits"."1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  full."inherits"."1.x" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
        sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits"."1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  full."inherits"."2" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits"."2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  full."inherits"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
        sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  full."inherits"."~2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits"."~2.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  full."ini"."1" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.1.0.tgz";
        sha1 = "4e808c2ce144c6c1788918e034d6797bc6cf6281";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini"."1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  full."ini"."1.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.1.0.tgz";
        sha1 = "4e808c2ce144c6c1788918e034d6797bc6cf6281";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini"."1.x.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  full."ini"."~1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.1.0.tgz";
        sha1 = "4e808c2ce144c6c1788918e034d6797bc6cf6281";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini"."~1.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  full."init-package-json"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-0.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-0.0.10.tgz";
        sha1 = "7baf10535227e0878105a04e44b78f132475da6a";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json"."0.0.10" or []);
    deps = [
      self.full."promzard"."~0.2.0"
      self.full."read"."~1.0.1"
      self.full."read-package-json"."1"
      self.full."semver"."2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  full."init-package-json"."0.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "init-package-json-0.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/init-package-json/-/init-package-json-0.0.11.tgz";
        sha1 = "71914631d091bb1f73a4bddbe6d7985e929859ce";
      })
    ];
    buildInputs =
      (self.nativeDeps."init-package-json"."0.0.11" or []);
    deps = [
      self.full."promzard"."~0.2.0"
      self.full."read"."~1.0.1"
      self.full."read-package-json"."1"
      self.full."semver"."2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "init-package-json" ];
  };
  full."inquirer"."~0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.2.5.tgz";
        sha1 = "6b49a9cbe03de776122211f174ef9fe2822c08f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer"."~0.2.4" or []);
    deps = [
      self.full."lodash"."~1.2.1"
      self.full."async"."~0.2.8"
      self.full."cli-color"."~0.2.2"
      self.full."mute-stream"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  full."inquirer"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.3.4.tgz";
        sha1 = "af4673b3e1cb746b74d5dafe14ef55c3c1bf7222";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer"."~0.3.0" or []);
    deps = [
      self.full."lodash"."~1.2.1"
      self.full."async"."~0.2.8"
      self.full."cli-color"."~0.2.2"
      self.full."mute-stream"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  full."inquirer"."~0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.3.4.tgz";
        sha1 = "af4673b3e1cb746b74d5dafe14ef55c3c1bf7222";
      })
    ];
    buildInputs =
      (self.nativeDeps."inquirer"."~0.3.1" or []);
    deps = [
      self.full."lodash"."~1.2.1"
      self.full."async"."~0.2.8"
      self.full."cli-color"."~0.2.2"
      self.full."mute-stream"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inquirer" ];
  };
  full."insight"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "insight-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/insight/-/insight-0.2.0.tgz";
        sha1 = "3b430f3c903558d690d1b96c7479b6f1b9186a5e";
      })
    ];
    buildInputs =
      (self.nativeDeps."insight"."~0.2.0" or []);
    deps = [
      self.full."chalk"."~0.2.0"
      self.full."request"."~2.27.0"
      self.full."configstore"."~0.1.0"
      self.full."async"."~0.2.9"
      self.full."lodash"."~1.3.1"
      self.full."inquirer"."~0.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "insight" ];
  };
  full."intersect"."~0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "intersect-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/intersect/-/intersect-0.0.3.tgz";
        sha1 = "c1a4a5e5eac6ede4af7504cc07e0ada7bc9f4920";
      })
    ];
    buildInputs =
      (self.nativeDeps."intersect"."~0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "intersect" ];
  };
  full."ironhorse"."*" = lib.makeOverridable self.buildNodePackage {
    name = "ironhorse-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ironhorse/-/ironhorse-0.0.9.tgz";
        sha1 = "9cfaf75e464a0bf394d511a05c0a8b8de080a1d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."ironhorse"."*" or []);
    deps = [
      self.full."underscore"."~1.5.2"
      self.full."winston"."*"
      self.full."nconf"."*"
      self.full."fs-walk"."*"
      self.full."async"."*"
      self.full."express"."*"
      self.full."jade"."*"
      self.full."passport"."*"
      self.full."passport-http"."*"
      self.full."js-yaml"."*"
      self.full."mongoose"."3.6.x"
      self.full."gridfs-stream"."*"
      self.full."temp"."*"
      self.full."kue"."*"
      self.full."redis"."*"
      self.full."hiredis"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ironhorse" ];
  };
  "ironhorse" = self.full."ironhorse"."*";
  full."is-promise"."~1" = lib.makeOverridable self.buildNodePackage {
    name = "is-promise-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-promise/-/is-promise-1.0.0.tgz";
        sha1 = "b998d17551f16f69f7bd4828f58f018cc81e064f";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-promise"."~1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "is-promise" ];
  };
  full."isbinaryfile"."~0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "isbinaryfile-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isbinaryfile/-/isbinaryfile-0.1.9.tgz";
        sha1 = "15eece35c4ab708d8924da99fb874f2b5cc0b6c4";
      })
    ];
    buildInputs =
      (self.nativeDeps."isbinaryfile"."~0.1.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "isbinaryfile" ];
  };
  full."istanbul"."*" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.1.44";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.1.44.tgz";
        sha1 = "7ea1d55e34234e7b7d8f2f61cceb29b59439d983";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul"."*" or []);
    deps = [
      self.full."esprima"."1.0.x"
      self.full."escodegen"."0.0.23"
      self.full."handlebars"."1.0.x"
      self.full."mkdirp"."0.3.x"
      self.full."nopt"."2.1.x"
      self.full."fileset"."0.1.x"
      self.full."which"."1.0.x"
      self.full."async"."0.2.x"
      self.full."abbrev"."1.0.x"
      self.full."wordwrap"."0.0.x"
      self.full."resolve"."0.5.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  "istanbul" = self.full."istanbul"."*";
  full."istanbul"."~0.1.41" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.1.44";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.1.44.tgz";
        sha1 = "7ea1d55e34234e7b7d8f2f61cceb29b59439d983";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul"."~0.1.41" or []);
    deps = [
      self.full."esprima"."1.0.x"
      self.full."escodegen"."0.0.23"
      self.full."handlebars"."1.0.x"
      self.full."mkdirp"."0.3.x"
      self.full."nopt"."2.1.x"
      self.full."fileset"."0.1.x"
      self.full."which"."1.0.x"
      self.full."async"."0.2.x"
      self.full."abbrev"."1.0.x"
      self.full."wordwrap"."0.0.x"
      self.full."resolve"."0.5.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  full."jade"."*" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.35.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.35.0.tgz";
        sha1 = "75ec1d966a1203733613e8c180e2aa8685c16da9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade"."*" or []);
    deps = [
      self.full."commander"."2.0.0"
      self.full."mkdirp"."0.3.x"
      self.full."transformers"."2.1.0"
      self.full."character-parser"."1.2.0"
      self.full."monocle"."1.1.50"
      self.full."with"."~1.1.0"
      self.full."constantinople"."~1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  "jade" = self.full."jade"."*";
  full."jade"."0.26.3" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.26.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.26.3.tgz";
        sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade"."0.26.3" or []);
    deps = [
      self.full."commander"."0.6.1"
      self.full."mkdirp"."0.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  full."jade".">= 0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.35.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.35.0.tgz";
        sha1 = "75ec1d966a1203733613e8c180e2aa8685c16da9";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade".">= 0.0.1" or []);
    deps = [
      self.full."commander"."2.0.0"
      self.full."mkdirp"."0.3.x"
      self.full."transformers"."2.1.0"
      self.full."character-parser"."1.2.0"
      self.full."monocle"."1.1.50"
      self.full."with"."~1.1.0"
      self.full."constantinople"."~1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  full."jayschema"."*" = lib.makeOverridable self.buildNodePackage {
    name = "jayschema-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jayschema/-/jayschema-0.2.0.tgz";
        sha1 = "ab250dd51224ef36ac8119ce143e0525300d99d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."jayschema"."*" or []);
    deps = [
      self.full."when"."~2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jayschema" ];
  };
  "jayschema" = self.full."jayschema"."*";
  full."js-yaml"."*" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.1.tgz";
        sha1 = "574095ef2253694313a6c2b261c7b6929a9603b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml"."*" or []);
    deps = [
      self.full."argparse"."~ 0.1.11"
      self.full."esprima"."~ 1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  "js-yaml" = self.full."js-yaml"."*";
  full."js-yaml"."0.3.x" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-0.3.7.tgz";
        sha1 = "d739d8ee86461e54b354d6a7d7d1f2ad9a167f62";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml"."0.3.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  full."js-yaml"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.0.tgz";
        sha1 = "a55a6e4706b01d06326259a6f4bfc42e6ae38b1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml"."2.1.0" or []);
    deps = [
      self.full."argparse"."~ 0.1.11"
      self.full."esprima"."~ 1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  full."js-yaml"."~2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.0.5.tgz";
        sha1 = "a25ae6509999e97df278c6719da11bd0687743a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml"."~2.0.2" or []);
    deps = [
      self.full."argparse"."~ 0.1.11"
      self.full."esprima"."~ 1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  full."js-yaml"."~2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.1.tgz";
        sha1 = "574095ef2253694313a6c2b261c7b6929a9603b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml"."~2.1.0" or []);
    deps = [
      self.full."argparse"."~ 0.1.11"
      self.full."esprima"."~ 1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  full."jshint"."*" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.1.11.tgz";
        sha1 = "eb5108fef9ba5ddebb830983f572d242e49e3f96";
      })
    ];
    buildInputs =
      (self.nativeDeps."jshint"."*" or []);
    deps = [
      self.full."shelljs"."0.1.x"
      self.full."underscore"."1.4.x"
      self.full."cli"."0.4.x"
      self.full."minimatch"."0.x.x"
      self.full."console-browserify"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  "jshint" = self.full."jshint"."*";
  full."jshint"."~2.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.1.11.tgz";
        sha1 = "eb5108fef9ba5ddebb830983f572d242e49e3f96";
      })
    ];
    buildInputs =
      (self.nativeDeps."jshint"."~2.1.10" or []);
    deps = [
      self.full."shelljs"."0.1.x"
      self.full."underscore"."1.4.x"
      self.full."cli"."0.4.x"
      self.full."minimatch"."0.x.x"
      self.full."console-browserify"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  full."json-schema"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "json-schema-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
        sha1 = "50354f19f603917c695f70b85afa77c3b0f23506";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-schema"."0.2.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-schema" ];
  };
  full."json-stringify-safe"."~3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-3.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-3.0.0.tgz";
        sha1 = "9db7b0e530c7f289c5e8c8432af191c2ff75a5b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe"."~3.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  full."json-stringify-safe"."~4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-4.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-4.0.0.tgz";
        sha1 = "77c271aaea54302e68efeaccb56abbf06a9b1a54";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe"."~4.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  full."json-stringify-safe"."~5.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-5.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
        sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe"."~5.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  full."jsontool"."*" = lib.makeOverridable self.buildNodePackage {
    name = "jsontool-6.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsontool/-/jsontool-6.0.0.tgz";
        sha1 = "dc2a535b2aa8a10b0b7359c76fa8920cdb92ce6d";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsontool"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsontool" ];
  };
  "jsontool" = self.full."jsontool"."*";
  full."jsprim"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "jsprim-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsprim/-/jsprim-0.3.0.tgz";
        sha1 = "cd13466ea2480dbd8396a570d47d31dda476f8b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsprim"."0.3.0" or []);
    deps = [
      self.full."extsprintf"."1.0.0"
      self.full."json-schema"."0.2.2"
      self.full."verror"."1.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsprim" ];
  };
  full."junk"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "junk-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/junk/-/junk-0.2.1.tgz";
        sha1 = "e8a4c42c421746da34b354d0510507cb79f3c583";
      })
    ];
    buildInputs =
      (self.nativeDeps."junk"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "junk" ];
  };
  full."karma"."*" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.11.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.11.0.tgz";
        sha1 = "554ff769ad9b5f3c78f051ad7e607c529b6c825e";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-jasmine/-/karma-jasmine-0.1.3.tgz";
        sha1 = "b7f3b87973ea8e9e1ebfa721188876c31c5fa3be";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-requirejs/-/karma-requirejs-0.1.0.tgz";
        sha1 = "d9554aa0f11f2c0ff2e933ab5043a633b1305622";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coffee-preprocessor/-/karma-coffee-preprocessor-0.1.0.tgz";
        sha1 = "713affc9990707e43eb6f64afdaf312072b73aab";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-html2js-preprocessor/-/karma-html2js-preprocessor-0.1.0.tgz";
        sha1 = "2f7cf881f54a5d0b72154cc6ee1241c44292c7fe";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-0.1.0.tgz";
        sha1 = "d29f42911358a640ba4a13f1d2110819ae2e5cea";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-firefox-launcher/-/karma-firefox-launcher-0.1.0.tgz";
        sha1 = "e5517590eea029d10d500b5f82ae423aafe069d4";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-phantomjs-launcher/-/karma-phantomjs-launcher-0.1.0.tgz";
        sha1 = "9ef8243751524e32e67b97e3f8a321ee68a3fa2f";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-script-launcher/-/karma-script-launcher-0.1.0.tgz";
        sha1 = "b643e7c2faead1a52cdb2eeaadcf7a245f0d772a";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma"."*" or [])
      ++ (self.nativeDeps."karma-jasmine"."*" or [])
      ++ (self.nativeDeps."karma-requirejs"."*" or [])
      ++ (self.nativeDeps."karma-coffee-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-html2js-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-chrome-launcher"."*" or [])
      ++ (self.nativeDeps."karma-firefox-launcher"."*" or [])
      ++ (self.nativeDeps."karma-phantomjs-launcher"."*" or [])
      ++ (self.nativeDeps."karma-script-launcher"."*" or []);
    deps = [
      self.full."di"."~0.0.1"
      self.full."socket.io"."~0.9.13"
      self.full."chokidar"."~0.6"
      self.full."glob"."~3.1.21"
      self.full."minimatch"."~0.2"
      self.full."http-proxy"."~0.10"
      self.full."optimist"."~0.3"
      self.full."coffee-script"."~1.6"
      self.full."rimraf"."~2.1"
      self.full."q"."~0.9"
      self.full."colors"."0.6.0-1"
      self.full."lodash"."~1.1"
      self.full."mime"."~1.2"
      self.full."log4js"."~0.6.3"
      self.full."useragent"."~2.0.4"
      self.full."graceful-fs"."~1.2.1"
      self.full."connect"."~2.8.4"
      self.full."phantomjs"."~1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "karma" "karma-jasmine" "karma-requirejs" "karma-coffee-preprocessor" "karma-html2js-preprocessor" "karma-chrome-launcher" "karma-firefox-launcher" "karma-phantomjs-launcher" "karma-script-launcher" ];
  };
  "karma" = self.full."karma"."*";
  full."karma".">=0.9" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.11.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.11.0.tgz";
        sha1 = "554ff769ad9b5f3c78f051ad7e607c529b6c825e";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-jasmine/-/karma-jasmine-0.1.3.tgz";
        sha1 = "b7f3b87973ea8e9e1ebfa721188876c31c5fa3be";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-requirejs/-/karma-requirejs-0.1.0.tgz";
        sha1 = "d9554aa0f11f2c0ff2e933ab5043a633b1305622";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coffee-preprocessor/-/karma-coffee-preprocessor-0.1.0.tgz";
        sha1 = "713affc9990707e43eb6f64afdaf312072b73aab";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-html2js-preprocessor/-/karma-html2js-preprocessor-0.1.0.tgz";
        sha1 = "2f7cf881f54a5d0b72154cc6ee1241c44292c7fe";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-0.1.0.tgz";
        sha1 = "d29f42911358a640ba4a13f1d2110819ae2e5cea";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-firefox-launcher/-/karma-firefox-launcher-0.1.0.tgz";
        sha1 = "e5517590eea029d10d500b5f82ae423aafe069d4";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-phantomjs-launcher/-/karma-phantomjs-launcher-0.1.0.tgz";
        sha1 = "9ef8243751524e32e67b97e3f8a321ee68a3fa2f";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-script-launcher/-/karma-script-launcher-0.1.0.tgz";
        sha1 = "b643e7c2faead1a52cdb2eeaadcf7a245f0d772a";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma".">=0.9" or [])
      ++ (self.nativeDeps."karma-jasmine"."*" or [])
      ++ (self.nativeDeps."karma-requirejs"."*" or [])
      ++ (self.nativeDeps."karma-coffee-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-html2js-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-chrome-launcher"."*" or [])
      ++ (self.nativeDeps."karma-firefox-launcher"."*" or [])
      ++ (self.nativeDeps."karma-phantomjs-launcher"."*" or [])
      ++ (self.nativeDeps."karma-script-launcher"."*" or []);
    deps = [
      self.full."di"."~0.0.1"
      self.full."socket.io"."~0.9.13"
      self.full."chokidar"."~0.6"
      self.full."glob"."~3.1.21"
      self.full."minimatch"."~0.2"
      self.full."http-proxy"."~0.10"
      self.full."optimist"."~0.3"
      self.full."coffee-script"."~1.6"
      self.full."rimraf"."~2.1"
      self.full."q"."~0.9"
      self.full."colors"."0.6.0-1"
      self.full."lodash"."~1.1"
      self.full."mime"."~1.2"
      self.full."log4js"."~0.6.3"
      self.full."useragent"."~2.0.4"
      self.full."graceful-fs"."~1.2.1"
      self.full."connect"."~2.8.4"
      self.full."phantomjs"."~1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "karma" "karma-jasmine" "karma-requirejs" "karma-coffee-preprocessor" "karma-html2js-preprocessor" "karma-chrome-launcher" "karma-firefox-launcher" "karma-phantomjs-launcher" "karma-script-launcher" ];
  };
  full."karma".">=0.9.3" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.11.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.11.0.tgz";
        sha1 = "554ff769ad9b5f3c78f051ad7e607c529b6c825e";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-jasmine/-/karma-jasmine-0.1.3.tgz";
        sha1 = "b7f3b87973ea8e9e1ebfa721188876c31c5fa3be";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-requirejs/-/karma-requirejs-0.1.0.tgz";
        sha1 = "d9554aa0f11f2c0ff2e933ab5043a633b1305622";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coffee-preprocessor/-/karma-coffee-preprocessor-0.1.0.tgz";
        sha1 = "713affc9990707e43eb6f64afdaf312072b73aab";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-html2js-preprocessor/-/karma-html2js-preprocessor-0.1.0.tgz";
        sha1 = "2f7cf881f54a5d0b72154cc6ee1241c44292c7fe";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-0.1.0.tgz";
        sha1 = "d29f42911358a640ba4a13f1d2110819ae2e5cea";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-firefox-launcher/-/karma-firefox-launcher-0.1.0.tgz";
        sha1 = "e5517590eea029d10d500b5f82ae423aafe069d4";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-phantomjs-launcher/-/karma-phantomjs-launcher-0.1.0.tgz";
        sha1 = "9ef8243751524e32e67b97e3f8a321ee68a3fa2f";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-script-launcher/-/karma-script-launcher-0.1.0.tgz";
        sha1 = "b643e7c2faead1a52cdb2eeaadcf7a245f0d772a";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma".">=0.9.3" or [])
      ++ (self.nativeDeps."karma-jasmine"."*" or [])
      ++ (self.nativeDeps."karma-requirejs"."*" or [])
      ++ (self.nativeDeps."karma-coffee-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-html2js-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-chrome-launcher"."*" or [])
      ++ (self.nativeDeps."karma-firefox-launcher"."*" or [])
      ++ (self.nativeDeps."karma-phantomjs-launcher"."*" or [])
      ++ (self.nativeDeps."karma-script-launcher"."*" or []);
    deps = [
      self.full."di"."~0.0.1"
      self.full."socket.io"."~0.9.13"
      self.full."chokidar"."~0.6"
      self.full."glob"."~3.1.21"
      self.full."minimatch"."~0.2"
      self.full."http-proxy"."~0.10"
      self.full."optimist"."~0.3"
      self.full."coffee-script"."~1.6"
      self.full."rimraf"."~2.1"
      self.full."q"."~0.9"
      self.full."colors"."0.6.0-1"
      self.full."lodash"."~1.1"
      self.full."mime"."~1.2"
      self.full."log4js"."~0.6.3"
      self.full."useragent"."~2.0.4"
      self.full."graceful-fs"."~1.2.1"
      self.full."connect"."~2.8.4"
      self.full."phantomjs"."~1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "karma" "karma-jasmine" "karma-requirejs" "karma-coffee-preprocessor" "karma-html2js-preprocessor" "karma-chrome-launcher" "karma-firefox-launcher" "karma-phantomjs-launcher" "karma-script-launcher" ];
  };
  full."karma"."~0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "karma-0.10.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma/-/karma-0.10.2.tgz";
        sha1 = "4e100bd346bb24a1260dcd34b5b3d2d4a9b27b17";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-jasmine/-/karma-jasmine-0.1.3.tgz";
        sha1 = "b7f3b87973ea8e9e1ebfa721188876c31c5fa3be";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-requirejs/-/karma-requirejs-0.1.0.tgz";
        sha1 = "d9554aa0f11f2c0ff2e933ab5043a633b1305622";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coffee-preprocessor/-/karma-coffee-preprocessor-0.1.0.tgz";
        sha1 = "713affc9990707e43eb6f64afdaf312072b73aab";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-html2js-preprocessor/-/karma-html2js-preprocessor-0.1.0.tgz";
        sha1 = "2f7cf881f54a5d0b72154cc6ee1241c44292c7fe";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-chrome-launcher/-/karma-chrome-launcher-0.1.0.tgz";
        sha1 = "d29f42911358a640ba4a13f1d2110819ae2e5cea";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-firefox-launcher/-/karma-firefox-launcher-0.1.0.tgz";
        sha1 = "e5517590eea029d10d500b5f82ae423aafe069d4";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-phantomjs-launcher/-/karma-phantomjs-launcher-0.1.0.tgz";
        sha1 = "9ef8243751524e32e67b97e3f8a321ee68a3fa2f";
      })
      (fetchurl {
        url = "http://registry.npmjs.org/karma-script-launcher/-/karma-script-launcher-0.1.0.tgz";
        sha1 = "b643e7c2faead1a52cdb2eeaadcf7a245f0d772a";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma"."~0.10.0" or [])
      ++ (self.nativeDeps."karma-jasmine"."*" or [])
      ++ (self.nativeDeps."karma-requirejs"."*" or [])
      ++ (self.nativeDeps."karma-coffee-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-html2js-preprocessor"."*" or [])
      ++ (self.nativeDeps."karma-chrome-launcher"."*" or [])
      ++ (self.nativeDeps."karma-firefox-launcher"."*" or [])
      ++ (self.nativeDeps."karma-phantomjs-launcher"."*" or [])
      ++ (self.nativeDeps."karma-script-launcher"."*" or []);
    deps = [
      self.full."di"."~0.0.1"
      self.full."socket.io"."~0.9.13"
      self.full."chokidar"."~0.6"
      self.full."glob"."~3.1.21"
      self.full."minimatch"."~0.2"
      self.full."http-proxy"."~0.10"
      self.full."optimist"."~0.3"
      self.full."coffee-script"."~1.6"
      self.full."rimraf"."~2.1"
      self.full."q"."~0.9"
      self.full."colors"."0.6.0-1"
      self.full."lodash"."~1.1"
      self.full."mime"."~1.2"
      self.full."log4js"."~0.6.3"
      self.full."useragent"."~2.0.4"
      self.full."graceful-fs"."~1.2.1"
      self.full."connect"."~2.8.4"
      self.full."phantomjs"."~1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "karma" "karma-jasmine" "karma-requirejs" "karma-coffee-preprocessor" "karma-html2js-preprocessor" "karma-chrome-launcher" "karma-firefox-launcher" "karma-phantomjs-launcher" "karma-script-launcher" ];
  };
  full."karma-chrome-launcher"."*" = self.full."karma"."~0.10.0";
  "karma-chrome-launcher" = self.full."karma-chrome-launcher"."*";
  full."karma-coffee-preprocessor"."*" = self.full."karma"."~0.10.0";
  full."karma-coverage"."*" = lib.makeOverridable self.buildNodePackage {
    name = "karma-coverage-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-coverage/-/karma-coverage-0.1.0.tgz";
        sha1 = "6d5d03352cbe2d529807e558688dceea55f9dbb0";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-coverage"."*" or []);
    deps = [
      self.full."istanbul"."~0.1.41"
      self.full."dateformat"."~1.0.6"
    ];
    peerDependencies = [
      self.full."karma".">=0.9"
    ];
    passthru.names = [ "karma-coverage" ];
  };
  "karma-coverage" = self.full."karma-coverage"."*";
  full."karma-firefox-launcher"."*" = self.full."karma"."~0.10.0";
  full."karma-html2js-preprocessor"."*" = self.full."karma"."~0.10.0";
  full."karma-jasmine"."*" = self.full."karma"."~0.10.0";
  full."karma-junit-reporter"."*" = lib.makeOverridable self.buildNodePackage {
    name = "karma-junit-reporter-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-junit-reporter/-/karma-junit-reporter-0.1.0.tgz";
        sha1 = "7af72b64d7e9f192d1a40f4ef063ffbcf9e7bba5";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-junit-reporter"."*" or []);
    deps = [
      self.full."xmlbuilder"."0.4.2"
    ];
    peerDependencies = [
      self.full."karma".">=0.9"
    ];
    passthru.names = [ "karma-junit-reporter" ];
  };
  "karma-junit-reporter" = self.full."karma-junit-reporter"."*";
  full."karma-mocha"."*" = lib.makeOverridable self.buildNodePackage {
    name = "karma-mocha-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-mocha/-/karma-mocha-0.1.0.tgz";
        sha1 = "451cfef48c51850e45db9d119927502e6a2feb40";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-mocha"."*" or []);
    deps = [
    ];
    peerDependencies = [
      self.full."karma".">=0.9"
      self.full."mocha"."*"
    ];
    passthru.names = [ "karma-mocha" ];
  };
  "karma-mocha" = self.full."karma-mocha"."*";
  full."karma-phantomjs-launcher"."*" = self.full."karma"."~0.10.0";
  full."karma-requirejs"."*" = self.full."karma"."~0.10.0";
  "karma-requirejs" = self.full."karma-requirejs"."*";
  full."karma-sauce-launcher"."*" = lib.makeOverridable self.buildNodePackage {
    name = "karma-sauce-launcher-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/karma-sauce-launcher/-/karma-sauce-launcher-0.1.0.tgz";
        sha1 = "46be4b9888fda09e6512516cd5dc6ab8b114d392";
      })
    ];
    buildInputs =
      (self.nativeDeps."karma-sauce-launcher"."*" or []);
    deps = [
      self.full."wd"."~0.0.32"
      self.full."sauce-connect-launcher"."~0.1.10"
      self.full."q"."~0.9.6"
    ];
    peerDependencies = [
      self.full."karma".">=0.9"
    ];
    passthru.names = [ "karma-sauce-launcher" ];
  };
  "karma-sauce-launcher" = self.full."karma-sauce-launcher"."*";
  full."karma-script-launcher"."*" = self.full."karma"."~0.10.0";
  full."keen.io"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "keen.io-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keen.io/-/keen.io-0.0.3.tgz";
        sha1 = "2d6ae2baa6d24b618f378b2a44413e1283fbcb63";
      })
    ];
    buildInputs =
      (self.nativeDeps."keen.io"."0.0.3" or []);
    deps = [
      self.full."superagent"."~0.13.0"
      self.full."underscore"."~1.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keen.io" ];
  };
  full."keep-alive-agent"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "keep-alive-agent-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keep-alive-agent/-/keep-alive-agent-0.0.1.tgz";
        sha1 = "44847ca394ce8d6b521ae85816bd64509942b385";
      })
    ];
    buildInputs =
      (self.nativeDeps."keep-alive-agent"."0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keep-alive-agent" ];
  };
  full."kerberos"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "kerberos-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kerberos/-/kerberos-0.0.3.tgz";
        sha1 = "4285d92a0748db2784062f5adcec9f5956cb818a";
      })
    ];
    buildInputs =
      (self.nativeDeps."kerberos"."0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kerberos" ];
  };
  full."kew"."~0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "kew-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kew/-/kew-0.1.7.tgz";
        sha1 = "0a32a817ff1a9b3b12b8c9bacf4bc4d679af8e72";
      })
    ];
    buildInputs =
      (self.nativeDeps."kew"."~0.1.7" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kew" ];
  };
  full."keypress"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "keypress-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keypress/-/keypress-0.1.0.tgz";
        sha1 = "4a3188d4291b66b4f65edb99f806aa9ae293592a";
      })
    ];
    buildInputs =
      (self.nativeDeps."keypress"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keypress" ];
  };
  full."knox"."*" = lib.makeOverridable self.buildNodePackage {
    name = "knox-0.8.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knox/-/knox-0.8.6.tgz";
        sha1 = "244e7c643c4c9ea2eb37e215dd02b07c8e138e3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."knox"."*" or []);
    deps = [
      self.full."mime"."*"
      self.full."xml2js"."0.2.x"
      self.full."debug"."~0.7.0"
      self.full."stream-counter"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "knox" ];
  };
  "knox" = self.full."knox"."*";
  full."kue"."*" = lib.makeOverridable self.buildNodePackage {
    name = "kue-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kue/-/kue-0.6.2.tgz";
        sha1 = "9a6a95081842cf4ee3da5c61770bc23616a943f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."kue"."*" or []);
    deps = [
      self.full."redis"."0.7.2"
      self.full."express"."~3.1.1"
      self.full."jade"."0.26.3"
      self.full."stylus"."0.27.2"
      self.full."nib"."0.5.0"
      self.full."reds"."0.1.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kue" ];
  };
  "kue" = self.full."kue"."*";
  full."lazy"."~1.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "lazy-1.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lazy/-/lazy-1.0.11.tgz";
        sha1 = "daa068206282542c088288e975c297c1ae77b690";
      })
    ];
    buildInputs =
      (self.nativeDeps."lazy"."~1.0.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lazy" ];
  };
  full."lcov-parse"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "lcov-parse-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-parse/-/lcov-parse-0.0.4.tgz";
        sha1 = "3853a4f132f04581db0e74c180542d90f0d1c66b";
      })
    ];
    buildInputs =
      (self.nativeDeps."lcov-parse"."0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lcov-parse" ];
  };
  full."lcov-result-merger"."*" = lib.makeOverridable self.buildNodePackage {
    name = "lcov-result-merger-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lcov-result-merger/-/lcov-result-merger-0.0.1.tgz";
        sha1 = "8b0e68a7f9136de084f62d92ecafcfa41ce9e4d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."lcov-result-merger"."*" or []);
    deps = [
      self.full."glob"."~3.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lcov-result-merger" ];
  };
  "lcov-result-merger" = self.full."lcov-result-merger"."*";
  full."less"."~1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "less-1.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-1.4.2.tgz";
        sha1 = "b7deefe98a3a87bee364411b3df2d1efe5a412d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."less"."~1.4.0" or []);
    deps = [
      self.full."mime"."1.2.x"
      self.full."request".">=2.12.0"
      self.full."mkdirp"."~0.3.4"
      self.full."ycssmin".">=1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  full."libxmljs"."~0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "libxmljs-0.8.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libxmljs/-/libxmljs-0.8.1.tgz";
        sha1 = "b8b1d3962a92dbc5be9dc798bac028e09db8d630";
      })
    ];
    buildInputs =
      (self.nativeDeps."libxmljs"."~0.8.1" or []);
    deps = [
      self.full."bindings"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "libxmljs" ];
  };
  full."libyaml"."*" = lib.makeOverridable self.buildNodePackage {
    name = "libyaml-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libyaml/-/libyaml-0.2.2.tgz";
        sha1 = "a22d5f699911b6b622d6dc323fb62320c877c9c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."libyaml"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "libyaml" ];
  };
  "libyaml" = self.full."libyaml"."*";
  full."lockfile"."~0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "lockfile-0.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lockfile/-/lockfile-0.3.4.tgz";
        sha1 = "932b63546e4915f81b71924b36187740358eda03";
      })
    ];
    buildInputs =
      (self.nativeDeps."lockfile"."~0.3.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lockfile" ];
  };
  full."lockfile"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "lockfile-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lockfile/-/lockfile-0.4.2.tgz";
        sha1 = "ab91f5d3745bc005ae4fa34d078910d1f2b9612d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lockfile"."~0.4.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lockfile" ];
  };
  full."lodash"."~0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-0.9.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-0.9.2.tgz";
        sha1 = "8f3499c5245d346d682e5b0d3b40767e09f1a92c";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~0.9.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lodash"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.0.1.tgz";
        sha1 = "57945732498d92310e5bd4b1ff4f273a79e6c9fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~1.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lodash"."~1.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.1.1.tgz";
        sha1 = "41a2b2e9a00e64d6d1999f143ff6b0755f6bbb24";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lodash"."~1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.1.1.tgz";
        sha1 = "41a2b2e9a00e64d6d1999f143ff6b0755f6bbb24";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~1.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lodash"."~1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.2.1.tgz";
        sha1 = "ed47b16e46f06b2b40309b68e9163c17e93ea304";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~1.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lodash"."~1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.3.1.tgz";
        sha1 = "a4663b53686b895ff074e2ba504dfb76a8e2b770";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~1.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lodash"."~1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-1.3.1.tgz";
        sha1 = "a4663b53686b895ff074e2ba504dfb76a8e2b770";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~1.3.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."log-driver"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "log-driver-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log-driver/-/log-driver-1.2.1.tgz";
        sha1 = "ada8202a133e99764306652e195e28268b0bea5b";
      })
    ];
    buildInputs =
      (self.nativeDeps."log-driver"."1.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "log-driver" ];
  };
  full."log4js"."~0.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "log4js-0.6.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/log4js/-/log4js-0.6.9.tgz";
        sha1 = "2e327189c1c0dec17448ec5255f58cd0fddf4596";
      })
    ];
    buildInputs =
      (self.nativeDeps."log4js"."~0.6.3" or []);
    deps = [
      self.full."async"."0.1.15"
      self.full."semver"."~1.1.4"
      self.full."readable-stream"."~1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "log4js" ];
  };
  full."lru-cache"."2" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
        sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."lru-cache"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.2.0.tgz";
        sha1 = "ec2bba603f4c5bb3e7a1bf62ce1c1dbc1d474e08";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."2.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."lru-cache"."2.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.2.4.tgz";
        sha1 = "6c658619becf14031d0d0b594b16042ce4dc063d";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."2.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."lru-cache"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.0.tgz";
        sha1 = "1cee12d5a9f28ed1ee37e9c332b8888e6b85412a";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."2.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."lru-cache"."~1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-1.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-1.0.6.tgz";
        sha1 = "aa50f97047422ac72543bda177a9c9d018d98452";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."~1.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."lru-cache"."~2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
        sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."~2.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."lru-cache"."~2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
        sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache"."~2.3.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  full."mailcomposer".">= 0.1.27" = lib.makeOverridable self.buildNodePackage {
    name = "mailcomposer-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mailcomposer/-/mailcomposer-0.2.2.tgz";
        sha1 = "ce93bdea7cb51e60eb76491b6a64c39f382c20e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."mailcomposer".">= 0.1.27" or []);
    deps = [
      self.full."mimelib"."~0.2"
      self.full."mime"."1.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mailcomposer" ];
  };
  full."match-stream"."~0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "match-stream-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/match-stream/-/match-stream-0.0.2.tgz";
        sha1 = "99eb050093b34dffade421b9ac0b410a9cfa17cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."match-stream"."~0.0.2" or []);
    deps = [
      self.full."buffers"."~0.1.1"
      self.full."readable-stream"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "match-stream" ];
  };
  full."memoizee"."~0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "memoizee-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/memoizee/-/memoizee-0.2.5.tgz";
        sha1 = "44ad0ce73439705f3954a58dbf5f792cd496c01c";
      })
    ];
    buildInputs =
      (self.nativeDeps."memoizee"."~0.2.5" or []);
    deps = [
      self.full."es5-ext"."~0.9.2"
      self.full."event-emitter"."~0.2.2"
      self.full."next-tick"."0.1.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "memoizee" ];
  };
  full."methods"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "methods-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-0.0.1.tgz";
        sha1 = "277c90f8bef39709645a8371c51c3b6c648e068c";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods"."0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  full."mime"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."1.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.5.tgz";
        sha1 = "9eed073022a8bf5e16c8566c6867b8832bfbfa13";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."1.2.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."1.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.6.tgz";
        sha1 = "b1f86c768c025fa87b48075f1709f28aeaf20365";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."1.2.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."1.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.9.tgz";
        sha1 = "009cd40867bd35de521b3b966f04e2f8d4d13d09";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."1.2.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."1.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."1.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."~1.2" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."~1.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."~1.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."~1.2.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."~1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."~1.2.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."~1.2.7" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."~1.2.7" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mime"."~1.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime"."~1.2.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  full."mimelib"."~0.2" = lib.makeOverridable self.buildNodePackage {
    name = "mimelib-0.2.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mimelib/-/mimelib-0.2.13.tgz";
        sha1 = "0668eb85e870c510be747a67ece43b9bbf8e20b0";
      })
    ];
    buildInputs =
      (self.nativeDeps."mimelib"."~0.2" or []);
    deps = [
      self.full."encoding"."~0.1"
      self.full."addressparser"."~0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mimelib" ];
  };
  full."minimatch"."0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."0" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."0.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.0.5.tgz";
        sha1 = "96bb490bbd3ba6836bbfac111adf75301b1584de";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."0.0.x" or []);
    deps = [
      self.full."lru-cache"."~1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."0.2.x" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."0.x" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."0.x" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."0.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."0.x.x" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch".">=0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch".">=0.2.4" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."~0.2" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."~0.2" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."~0.2.0" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."~0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."~0.2.11" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."~0.2.12" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."~0.2.12" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."~0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."~0.2.6" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimatch"."~0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.12.tgz";
        sha1 = "ea82a012ac662c7ddfaa144f1c147e6946f5dafb";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch"."~0.2.9" or []);
    deps = [
      self.full."lru-cache"."2"
      self.full."sigmund"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  full."minimist"."~0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.5.tgz";
        sha1 = "d7aa327bcecf518f9106ac6b8f003fa3bcea8566";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist"."~0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  full."mkdirp"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  "mkdirp" = self.full."mkdirp"."*";
  full."mkdirp"."0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."0.3" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
        sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.4.tgz";
        sha1 = "f8c81d213b7299a031f193a57d752a17d2f6c7d8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0.3.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0.3.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."0.3.x" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0.3.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."0.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."0.x.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."~0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."~0.3.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."~0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."~0.3.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mkdirp"."~0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp"."~0.3.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  full."mocha"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-1.13.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-1.13.0.tgz";
        sha1 = "8d8fa4e310b94cc6efeb3ed26aeca96dea93307c";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha"."*" or []);
    deps = [
      self.full."commander"."0.6.1"
      self.full."growl"."1.7.x"
      self.full."jade"."0.26.3"
      self.full."diff"."1.0.7"
      self.full."debug"."*"
      self.full."mkdirp"."0.3.5"
      self.full."glob"."3.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mocha" ];
  };
  "mocha" = self.full."mocha"."*";
  full."mocha-unfunk-reporter"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-unfunk-reporter-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha-unfunk-reporter/-/mocha-unfunk-reporter-0.2.3.tgz";
        sha1 = "41c2aa001dc44eef80d073404728d2e4d4a09c90";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha-unfunk-reporter"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mocha-unfunk-reporter" ];
  };
  "mocha-unfunk-reporter" = self.full."mocha-unfunk-reporter"."*";
  full."moment"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.0.0.tgz";
        sha1 = "2bbc5b44c321837693ab6efcadbd46ed946211fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment"."2.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  full."moment"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "moment-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/moment/-/moment-2.1.0.tgz";
        sha1 = "1fd7b1134029a953c6ea371dbaee37598ac03567";
      })
    ];
    buildInputs =
      (self.nativeDeps."moment"."2.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "moment" ];
  };
  full."mongodb"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.3.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.3.19.tgz";
        sha1 = "f229db24098f019d86d135aaf8a1ab5f2658b1d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb"."*" or []);
    deps = [
      self.full."bson"."0.2.2"
      self.full."kerberos"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  "mongodb" = self.full."mongodb"."*";
  full."mongodb"."1.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.2.14.tgz";
        sha1 = "269665552066437308d0942036646e6795c3a9a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb"."1.2.14" or []);
    deps = [
      self.full."bson"."0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  full."mongodb"."1.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.2.14.tgz";
        sha1 = "269665552066437308d0942036646e6795c3a9a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb"."1.2.x" or []);
    deps = [
      self.full."bson"."0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  full."mongodb"."1.3.19" = lib.makeOverridable self.buildNodePackage {
    name = "mongodb-1.3.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongodb/-/mongodb-1.3.19.tgz";
        sha1 = "f229db24098f019d86d135aaf8a1ab5f2658b1d4";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongodb"."1.3.19" or []);
    deps = [
      self.full."bson"."0.2.2"
      self.full."kerberos"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongodb" ];
  };
  full."mongoose"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.7.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.7.4.tgz";
        sha1 = "5ed8cdbc91c92b18ab49ac3526c7ac5264c7b292";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose"."*" or []);
    deps = [
      self.full."hooks"."0.2.1"
      self.full."mongodb"."1.3.19"
      self.full."ms"."0.1.0"
      self.full."sliced"."0.0.5"
      self.full."muri"."0.3.1"
      self.full."mpromise"."0.3.0"
      self.full."mpath"."0.1.1"
      self.full."regexp-clone"."0.0.1"
      self.full."mquery"."0.3.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  full."mongoose"."3.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.6.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.6.7.tgz";
        sha1 = "aa6c9f4dfb740c7721dbe734fbb97714e5ab0ebc";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose"."3.6.7" or []);
    deps = [
      self.full."hooks"."0.2.1"
      self.full."mongodb"."1.2.14"
      self.full."ms"."0.1.0"
      self.full."sliced"."0.0.3"
      self.full."muri"."0.3.1"
      self.full."mpromise"."0.2.1"
      self.full."mpath"."0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  full."mongoose"."3.6.x" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-3.6.20";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose/-/mongoose-3.6.20.tgz";
        sha1 = "47263843e6b812ea207eec104c40a36c8d215f53";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose"."3.6.x" or []);
    deps = [
      self.full."hooks"."0.2.1"
      self.full."mongodb"."1.3.19"
      self.full."ms"."0.1.0"
      self.full."sliced"."0.0.5"
      self.full."muri"."0.3.1"
      self.full."mpromise"."0.2.1"
      self.full."mpath"."0.1.1"
      self.full."regexp-clone"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose" ];
  };
  "mongoose" = self.full."mongoose"."3.6.x";
  full."mongoose-lifecycle"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-lifecycle-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose-lifecycle/-/mongoose-lifecycle-1.0.0.tgz";
        sha1 = "3bac3f3924a845d147784fc6558dee900b0151e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose-lifecycle"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose-lifecycle" ];
  };
  full."mongoose-schema-extend"."*" = lib.makeOverridable self.buildNodePackage {
    name = "mongoose-schema-extend-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mongoose-schema-extend/-/mongoose-schema-extend-0.1.5.tgz";
        sha1 = "d2ab3d2005033daaa215a806bbd3f6637c9c96c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."mongoose-schema-extend"."*" or []);
    deps = [
      self.full."owl-deepcopy"."~0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mongoose-schema-extend" ];
  };
  "mongoose-schema-extend" = self.full."mongoose-schema-extend"."*";
  full."monocle"."1.1.50" = lib.makeOverridable self.buildNodePackage {
    name = "monocle-1.1.50";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/monocle/-/monocle-1.1.50.tgz";
        sha1 = "e21b059d99726d958371f36240c106b8a067fa7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."monocle"."1.1.50" or []);
    deps = [
      self.full."readdirp"."~0.2.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "monocle" ];
  };
  full."mout"."~0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "mout-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mout/-/mout-0.6.0.tgz";
        sha1 = "ce7abad8130d796b09d7fb509bcc73b09be024a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."mout"."~0.6.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mout" ];
  };
  full."mout"."~0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "mout-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mout/-/mout-0.7.1.tgz";
        sha1 = "218de2b0880b220d99f4fbaee3fc0c3a5310bda8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mout"."~0.7.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mout" ];
  };
  full."mpath"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "mpath-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpath/-/mpath-0.1.1.tgz";
        sha1 = "23da852b7c232ee097f4759d29c0ee9cd22d5e46";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpath"."0.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpath" ];
  };
  full."mpromise"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "mpromise-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.2.1.tgz";
        sha1 = "fbbdc28cb0207e49b8a4eb1a4c0cea6c2de794c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise"."0.2.1" or []);
    deps = [
      self.full."sliced"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  full."mpromise"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "mpromise-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mpromise/-/mpromise-0.3.0.tgz";
        sha1 = "cb864c2f642eb2192765087e3692e1dc152afe4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."mpromise"."0.3.0" or []);
    deps = [
      self.full."sliced"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mpromise" ];
  };
  full."mquery"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "mquery-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mquery/-/mquery-0.3.2.tgz";
        sha1 = "074cb82c51ec1b15897d8afb80a7b3567a2f8eca";
      })
    ];
    buildInputs =
      (self.nativeDeps."mquery"."0.3.2" or []);
    deps = [
      self.full."sliced"."0.0.5"
      self.full."debug"."0.7.0"
      self.full."regexp-clone"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mquery" ];
  };
  full."ms"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ms-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.1.0.tgz";
        sha1 = "f21fac490daf1d7667fd180fe9077389cc9442b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."ms"."0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ms" ];
  };
  full."msgpack".">= 0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "msgpack-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/msgpack/-/msgpack-0.2.1.tgz";
        sha1 = "5da246daa2138b4163640e486c00c4f3961e92ac";
      })
    ];
    buildInputs =
      (self.nativeDeps."msgpack".">= 0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "msgpack" ];
  };
  full."multiparty"."2.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "multiparty-2.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/multiparty/-/multiparty-2.1.8.tgz";
        sha1 = "35a31834323578ee65f5d870568097914739cf4e";
      })
    ];
    buildInputs =
      (self.nativeDeps."multiparty"."2.1.8" or []);
    deps = [
      self.full."readable-stream"."~1.0.2"
      self.full."stream-counter"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "multiparty" ];
  };
  full."muri"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "muri-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/muri/-/muri-0.3.1.tgz";
        sha1 = "861889c5c857f1a43700bee85d50731f61727c9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."muri"."0.3.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "muri" ];
  };
  full."mute-stream"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "mute-stream-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.3.tgz";
        sha1 = "f09c090d333b3063f615cbbcca71b349893f0152";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream"."0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  full."mute-stream"."~0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "mute-stream-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
        sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream"."~0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  full."mv"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "mv-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mv/-/mv-0.0.5.tgz";
        sha1 = "15eac759479884df1131d6de56bce20b654f5391";
      })
    ];
    buildInputs =
      (self.nativeDeps."mv"."0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mv" ];
  };
  full."nan"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "nan-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-0.3.2.tgz";
        sha1 = "0df1935cab15369075ef160ad2894107aa14dc2d";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan"."~0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  full."natural"."0.0.69" = lib.makeOverridable self.buildNodePackage {
    name = "natural-0.0.69";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/natural/-/natural-0.0.69.tgz";
        sha1 = "60d9ce23797a54ec211600eb721cc66779b954d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."natural"."0.0.69" or []);
    deps = [
      self.full."sylvester".">= 0.0.12"
      self.full."apparatus".">= 0.0.4"
      self.full."underscore"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "natural" ];
  };
  full."nconf"."*" = lib.makeOverridable self.buildNodePackage {
    name = "nconf-0.6.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nconf/-/nconf-0.6.7.tgz";
        sha1 = "f2ffce75f4573857429c719d9f6ed0a9a231a47c";
      })
    ];
    buildInputs =
      (self.nativeDeps."nconf"."*" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."ini"."1.x.x"
      self.full."optimist"."0.3.x"
      self.full."pkginfo"."0.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nconf" ];
  };
  "nconf" = self.full."nconf"."*";
  full."nconf"."0.6.7" = lib.makeOverridable self.buildNodePackage {
    name = "nconf-0.6.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nconf/-/nconf-0.6.7.tgz";
        sha1 = "f2ffce75f4573857429c719d9f6ed0a9a231a47c";
      })
    ];
    buildInputs =
      (self.nativeDeps."nconf"."0.6.7" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."ini"."1.x.x"
      self.full."optimist"."0.3.x"
      self.full."pkginfo"."0.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nconf" ];
  };
  full."ncp"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.2.7.tgz";
        sha1 = "46fac2b7dda2560a4cb7e628677bd5f64eac5be1";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp"."0.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  full."ncp"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.4.2.tgz";
        sha1 = "abcc6cbd3ec2ed2a729ff6e7c1fa8f01784a8574";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp"."0.4.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  full."negotiator"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.2.5.tgz";
        sha1 = "12ec7b4a9f3b4c894c31d8c4ec015925ba547eec";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator"."0.2.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  full."net-ping"."1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "net-ping-1.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/net-ping/-/net-ping-1.1.7.tgz";
        sha1 = "49f5bca55a30a3726d69253557f231135a637075";
      })
    ];
    buildInputs =
      (self.nativeDeps."net-ping"."1.1.7" or []);
    deps = [
      self.full."raw-socket"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "net-ping" ];
  };
  full."next-tick"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "next-tick-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/next-tick/-/next-tick-0.1.0.tgz";
        sha1 = "1912cce8eb9b697d640fbba94f8f00dec3b94259";
      })
    ];
    buildInputs =
      (self.nativeDeps."next-tick"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "next-tick" ];
  };
  full."nib"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "nib-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nib/-/nib-0.5.0.tgz";
        sha1 = "ad0a7dfa2bca8680c8cb8adaa6ab68c80e5221e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."nib"."0.5.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nib" ];
  };
  full."nijs"."*" = lib.makeOverridable self.buildNodePackage {
    name = "nijs-0.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nijs/-/nijs-0.0.11.tgz";
        sha1 = "386894330e53135a84e1c42c317b0384c0f48b7a";
      })
    ];
    buildInputs =
      (self.nativeDeps."nijs"."*" or []);
    deps = [
      self.full."optparse".">= 1.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nijs" ];
  };
  "nijs" = self.full."nijs"."*";
  full."node-expat"."*" = lib.makeOverridable self.buildNodePackage {
    name = "node-expat-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-expat/-/node-expat-2.0.0.tgz";
        sha1 = "a10271b3463484fa4b59895df61693a1de4ac735";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-expat"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-expat" ];
  };
  "node-expat" = self.full."node-expat"."*";
  full."node-gyp"."*" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.10.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.10.10.tgz";
        sha1 = "74290b46b72046d648d301fae3813feb0d07edd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp"."*" or []);
    deps = [
      self.full."glob"."3"
      self.full."graceful-fs"."2"
      self.full."fstream"."0"
      self.full."minimatch"."0"
      self.full."mkdirp"."0"
      self.full."nopt"."2"
      self.full."npmlog"."0"
      self.full."osenv"."0"
      self.full."request"."2"
      self.full."rimraf"."2"
      self.full."semver"."~2.1"
      self.full."tar"."0"
      self.full."which"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  "node-gyp" = self.full."node-gyp"."*";
  full."node-gyp"."~0.10.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.10.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.10.10.tgz";
        sha1 = "74290b46b72046d648d301fae3813feb0d07edd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp"."~0.10.10" or []);
    deps = [
      self.full."glob"."3"
      self.full."graceful-fs"."2"
      self.full."fstream"."0"
      self.full."minimatch"."0"
      self.full."mkdirp"."0"
      self.full."nopt"."2"
      self.full."npmlog"."0"
      self.full."osenv"."0"
      self.full."request"."2"
      self.full."rimraf"."2"
      self.full."semver"."~2.1"
      self.full."tar"."0"
      self.full."which"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  full."node-gyp"."~0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-gyp-0.10.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-gyp/-/node-gyp-0.10.10.tgz";
        sha1 = "74290b46b72046d648d301fae3813feb0d07edd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-gyp"."~0.10.2" or []);
    deps = [
      self.full."glob"."3"
      self.full."graceful-fs"."2"
      self.full."fstream"."0"
      self.full."minimatch"."0"
      self.full."mkdirp"."0"
      self.full."nopt"."2"
      self.full."npmlog"."0"
      self.full."osenv"."0"
      self.full."request"."2"
      self.full."rimraf"."2"
      self.full."semver"."~2.1"
      self.full."tar"."0"
      self.full."which"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-gyp" ];
  };
  full."node-inspector"."*" = lib.makeOverridable self.buildNodePackage {
    name = "node-inspector-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-inspector/-/node-inspector-0.5.0.tgz";
        sha1 = "3104821cb4d6436212331ef3f3539943fd370603";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-inspector"."*" or []);
    deps = [
      self.full."socket.io"."~0.9.14"
      self.full."express"."~3.4"
      self.full."async"."~0.2.8"
      self.full."glob"."~3.2.1"
      self.full."rc"."~0.3.0"
      self.full."strong-data-uri"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-inspector" ];
  };
  "node-inspector" = self.full."node-inspector"."*";
  full."node-syslog"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-syslog-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-syslog/-/node-syslog-1.1.3.tgz";
        sha1 = "dce11e3091d39889a2af166501e67e0098a0bb64";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-syslog"."1.1.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-syslog" ];
  };
  full."node-uptime"."https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7" = lib.makeOverridable self.buildNodePackage {
    name = "node-uptime-3.2.0";
    src = [
      (fetchurl {
        url = "https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7";
        sha256 = "46424d7f9553ce7313cc09995ab11d237dd02257c29f260cfb38d2799e7c7746";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uptime"."https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7" or []);
    deps = [
      self.full."mongoose"."3.6.7"
      self.full."mongoose-lifecycle"."1.0.0"
      self.full."express"."3.2.0"
      self.full."express-partials"."0.0.6"
      self.full."connect-flash"."0.1.0"
      self.full."ejs"."0.8.3"
      self.full."config"."0.4.15"
      self.full."async"."0.1.22"
      self.full."socket.io"."0.9.14"
      self.full."semver"."1.1.0"
      self.full."moment"."2.1.0"
      self.full."nodemailer"."0.3.35"
      self.full."net-ping"."1.1.7"
      self.full."js-yaml"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uptime" ];
  };
  "node-uptime" = self.full."node-uptime"."https://github.com/fzaninotto/uptime/tarball/1c65756575f90f563a752e2a22892ba2981c79b7";
  full."node-uuid"."*" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  "node-uuid" = self.full."node-uuid"."*";
  full."node-uuid"."1.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.2.0.tgz";
        sha1 = "81a9fe32934719852499b58b2523d2cd5fdfd65b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid"."1.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  full."node-uuid"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.3.3.tgz";
        sha1 = "d3db4d7b56810d9e4032342766282af07391729b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid"."1.3.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  full."node-uuid"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.0.tgz";
        sha1 = "07f9b2337572ff6275c775e1d48513f3a45d7a65";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid"."1.4.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  full."node-uuid"."~1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid"."~1.4.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  full."nodemailer"."0.3.35" = lib.makeOverridable self.buildNodePackage {
    name = "nodemailer-0.3.35";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemailer/-/nodemailer-0.3.35.tgz";
        sha1 = "4d38cdc0ad230bdf88cc27d1256ef49fcb422e19";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemailer"."0.3.35" or []);
    deps = [
      self.full."mailcomposer".">= 0.1.27"
      self.full."simplesmtp".">= 0.1.22"
      self.full."optimist"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nodemailer" ];
  };
  full."nodemon"."*" = lib.makeOverridable self.buildNodePackage {
    name = "nodemon-0.7.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nodemon/-/nodemon-0.7.10.tgz";
        sha1 = "695a01b9458b115b03bbe01696d361bd50b4fb9b";
      })
    ];
    buildInputs =
      (self.nativeDeps."nodemon"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nodemon" ];
  };
  "nodemon" = self.full."nodemon"."*";
  full."nomnom"."1.6.x" = lib.makeOverridable self.buildNodePackage {
    name = "nomnom-1.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nomnom/-/nomnom-1.6.1.tgz";
        sha1 = "bfed4506642d81278738e891c557e80694c1e0c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."nomnom"."1.6.x" or []);
    deps = [
      self.full."colors"."0.5.x"
      self.full."underscore"."~1.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nomnom" ];
  };
  full."nopt"."2" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.1.2.tgz";
        sha1 = "6cccd977b80132a07731d6e8ce58c2c8303cf9af";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt"."2" or []);
    deps = [
      self.full."abbrev"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  full."nopt"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.0.0.tgz";
        sha1 = "ca7416f20a5e3f9c3b86180f96295fa3d0b52e0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt"."2.0.0" or []);
    deps = [
      self.full."abbrev"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  full."nopt"."2.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.1.2.tgz";
        sha1 = "6cccd977b80132a07731d6e8ce58c2c8303cf9af";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt"."2.1.x" or []);
    deps = [
      self.full."abbrev"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  full."nopt"."~1.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-1.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-1.0.10.tgz";
        sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt"."~1.0.10" or []);
    deps = [
      self.full."abbrev"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  full."nopt"."~2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.1.2.tgz";
        sha1 = "6cccd977b80132a07731d6e8ce58c2c8303cf9af";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt"."~2.1.1" or []);
    deps = [
      self.full."abbrev"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  full."nopt"."~2.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.1.2.tgz";
        sha1 = "6cccd977b80132a07731d6e8ce58c2c8303cf9af";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt"."~2.1.2" or []);
    deps = [
      self.full."abbrev"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  full."normalize-package-data"."~0.2" = lib.makeOverridable self.buildNodePackage {
    name = "normalize-package-data-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/normalize-package-data/-/normalize-package-data-0.2.6.tgz";
        sha1 = "830bda1412f7ccae09b903fc080edbcdbb0947c0";
      })
    ];
    buildInputs =
      (self.nativeDeps."normalize-package-data"."~0.2" or []);
    deps = [
      self.full."semver"."2"
      self.full."github-url-from-git"."~1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "normalize-package-data" ];
  };
  full."npm"."*" = lib.makeOverridable self.buildNodePackage {
    name = "npm-1.3.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-1.3.11.tgz";
        sha1 = "4bf7f005fe1038c4fe9207603b961c97bd0ba5a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm"."*" or []);
    deps = [
      self.full."semver"."~2.1.0"
      self.full."ini"."~1.1.0"
      self.full."slide"."~1.1.5"
      self.full."abbrev"."~1.0.4"
      self.full."graceful-fs"."~2.0.0"
      self.full."minimatch"."~0.2.12"
      self.full."nopt"."~2.1.2"
      self.full."rimraf"."~2.2.0"
      self.full."request"."~2.27.0"
      self.full."which"."1"
      self.full."tar"."~0.1.18"
      self.full."fstream"."~0.1.23"
      self.full."block-stream"."0.0.7"
      self.full."mkdirp"."~0.3.3"
      self.full."read"."~1.0.4"
      self.full."lru-cache"."~2.3.1"
      self.full."node-gyp"."~0.10.10"
      self.full."fstream-npm"."~0.1.3"
      self.full."uid-number"."0"
      self.full."archy"."0"
      self.full."chownr"."0"
      self.full."npmlog"."0.0.4"
      self.full."ansi"."~0.1.2"
      self.full."npm-registry-client"."~0.2.28"
      self.full."read-package-json"."~1.1.3"
      self.full."read-installed"."~0.2.2"
      self.full."glob"."~3.2.6"
      self.full."init-package-json"."0.0.11"
      self.full."osenv"."0"
      self.full."lockfile"."~0.4.0"
      self.full."retry"."~0.6.0"
      self.full."once"."~1.1.1"
      self.full."npmconf"."~0.1.2"
      self.full."opener"."~1.3.0"
      self.full."chmodr"."~0.1.0"
      self.full."cmd-shim"."~1.0.1"
      self.full."sha"."~1.2.1"
      self.full."editor"."0.0.4"
      self.full."child-process-close"."~0.1.1"
      self.full."npm-user-validate"."0.0.3"
      self.full."github-url-from-git"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  "npm" = self.full."npm"."*";
  full."npm"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "npm-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm/-/npm-1.3.1.tgz";
        sha1 = "c64f1c82362254cd4804a3dea5efbe6ec396460c";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm"."1.3.1" or []);
    deps = [
      self.full."semver"."~2.0.8"
      self.full."ini"."~1.1.0"
      self.full."slide"."~1.1.4"
      self.full."abbrev"."~1.0.4"
      self.full."graceful-fs"."~1.2.2"
      self.full."minimatch"."~0.2.12"
      self.full."nopt"."~2.1.1"
      self.full."rimraf"."~2.2.0"
      self.full."request"."~2.21.0"
      self.full."which"."1"
      self.full."tar"."~0.1.17"
      self.full."fstream"."~0.1.22"
      self.full."block-stream"."*"
      self.full."inherits"."1"
      self.full."mkdirp"."~0.3.3"
      self.full."read"."~1.0.4"
      self.full."lru-cache"."~2.3.0"
      self.full."node-gyp"."~0.10.2"
      self.full."fstream-npm"."~0.1.3"
      self.full."uid-number"."0"
      self.full."archy"."0"
      self.full."chownr"."0"
      self.full."npmlog"."0.0.3"
      self.full."ansi"."~0.1.2"
      self.full."npm-registry-client"."~0.2.25"
      self.full."read-package-json"."~1.1.0"
      self.full."read-installed"."~0.2.2"
      self.full."glob"."~3.2.1"
      self.full."init-package-json"."0.0.10"
      self.full."osenv"."0"
      self.full."lockfile"."~0.3.2"
      self.full."retry"."~0.6.0"
      self.full."once"."~1.1.1"
      self.full."npmconf"."~0.1.1"
      self.full."opener"."~1.3.0"
      self.full."chmodr"."~0.1.0"
      self.full."cmd-shim"."~1.1.0"
      self.full."sha"."~1.0.1"
      self.full."editor"."0.0.4"
      self.full."child-process-close"."~0.1.1"
      self.full."npm-user-validate"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm" ];
  };
  full."npm-registry-client"."0.2.27" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.2.27";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.2.27.tgz";
        sha1 = "8f338189d32769267886a07ad7b7fd2267446adf";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client"."0.2.27" or []);
    deps = [
      self.full."request"."2 >=2.20.0"
      self.full."graceful-fs"."~2.0.0"
      self.full."semver"."~2.0.5"
      self.full."slide"."~1.1.3"
      self.full."chownr"."0"
      self.full."mkdirp"."~0.3.3"
      self.full."rimraf"."~2"
      self.full."retry"."0.6.0"
      self.full."couch-login"."~0.1.15"
      self.full."npmlog"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  full."npm-registry-client"."~0.2.25" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.2.28";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.2.28.tgz";
        sha1 = "959141fc0180d7b1ad089e87015a8a2142a8bffc";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client"."~0.2.25" or []);
    deps = [
      self.full."request"."2 >=2.25.0"
      self.full."graceful-fs"."~2.0.0"
      self.full."semver"."~2.1.0"
      self.full."slide"."~1.1.3"
      self.full."chownr"."0"
      self.full."mkdirp"."~0.3.3"
      self.full."rimraf"."~2"
      self.full."retry"."0.6.0"
      self.full."couch-login"."~0.1.18"
      self.full."npmlog"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  full."npm-registry-client"."~0.2.28" = lib.makeOverridable self.buildNodePackage {
    name = "npm-registry-client-0.2.28";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-registry-client/-/npm-registry-client-0.2.28.tgz";
        sha1 = "959141fc0180d7b1ad089e87015a8a2142a8bffc";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-registry-client"."~0.2.28" or []);
    deps = [
      self.full."request"."2 >=2.25.0"
      self.full."graceful-fs"."~2.0.0"
      self.full."semver"."~2.1.0"
      self.full."slide"."~1.1.3"
      self.full."chownr"."0"
      self.full."mkdirp"."~0.3.3"
      self.full."rimraf"."~2"
      self.full."retry"."0.6.0"
      self.full."couch-login"."~0.1.18"
      self.full."npmlog"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-registry-client" ];
  };
  full."npm-user-validate"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "npm-user-validate-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm-user-validate/-/npm-user-validate-0.0.3.tgz";
        sha1 = "818eca4312d13da648f9bc1d7f80bb4f151e0c2e";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm-user-validate"."0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm-user-validate" ];
  };
  full."npm2nix"."*" = lib.makeOverridable self.buildNodePackage {
    name = "npm2nix-5.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npm2nix/-/npm2nix-5.1.0.tgz";
        sha1 = "a6b21174d57fdc31cf67849ffc72083bcae0e2ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."npm2nix"."*" or []);
    deps = [
      self.full."semver".">=2.0.10 <3.0.0"
      self.full."argparse"."0.1.15"
      self.full."npm-registry-client"."0.2.27"
      self.full."npmconf"."0.1.1"
      self.full."tar"."0.1.17"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npm2nix" ];
  };
  "npm2nix" = self.full."npm2nix"."*";
  full."npmconf"."0.0.24" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.0.24";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.0.24.tgz";
        sha1 = "b78875b088ccc3c0afa3eceb3ce3244b1b52390c";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf"."0.0.24" or []);
    deps = [
      self.full."config-chain"."~1.1.1"
      self.full."inherits"."~1.0.0"
      self.full."once"."~1.1.1"
      self.full."mkdirp"."~0.3.3"
      self.full."osenv"."0.0.3"
      self.full."nopt"."2"
      self.full."semver"."~1.1.0"
      self.full."ini"."~1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  full."npmconf"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.1.tgz";
        sha1 = "7a254182591ca22d77b2faecc0d17e0f9bdf25a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf"."0.1.1" or []);
    deps = [
      self.full."config-chain"."~1.1.1"
      self.full."inherits"."~1.0.0"
      self.full."once"."~1.1.1"
      self.full."mkdirp"."~0.3.3"
      self.full."osenv"."0.0.3"
      self.full."nopt"."2"
      self.full."semver"."2"
      self.full."ini"."~1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  full."npmconf"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.3.tgz";
        sha1 = "e17832649a36785f086dac3d50705508e4f996e6";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf"."~0.1.1" or []);
    deps = [
      self.full."config-chain"."~1.1.1"
      self.full."inherits"."~2.0.0"
      self.full."once"."~1.1.1"
      self.full."mkdirp"."~0.3.3"
      self.full."osenv"."0.0.3"
      self.full."nopt"."2"
      self.full."semver"."2"
      self.full."ini"."~1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  full."npmconf"."~0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "npmconf-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmconf/-/npmconf-0.1.3.tgz";
        sha1 = "e17832649a36785f086dac3d50705508e4f996e6";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmconf"."~0.1.2" or []);
    deps = [
      self.full."config-chain"."~1.1.1"
      self.full."inherits"."~2.0.0"
      self.full."once"."~1.1.1"
      self.full."mkdirp"."~0.3.3"
      self.full."osenv"."0.0.3"
      self.full."nopt"."2"
      self.full."semver"."2"
      self.full."ini"."~1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmconf" ];
  };
  full."npmlog"."*" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.4.tgz";
        sha1 = "a12a7418606b7e0183a2851d97a8729b9a0f3837";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog"."*" or []);
    deps = [
      self.full."ansi"."~0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  full."npmlog"."0" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.4.tgz";
        sha1 = "a12a7418606b7e0183a2851d97a8729b9a0f3837";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog"."0" or []);
    deps = [
      self.full."ansi"."~0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  full."npmlog"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.3.tgz";
        sha1 = "c424ad1531af402eef8da201fc3d63bdbd37dacb";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog"."0.0.3" or []);
    deps = [
      self.full."ansi"."~0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  full."npmlog"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.0.4.tgz";
        sha1 = "a12a7418606b7e0183a2851d97a8729b9a0f3837";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog"."0.0.4" or []);
    deps = [
      self.full."ansi"."~0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  full."nssocket"."~0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "nssocket-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nssocket/-/nssocket-0.5.1.tgz";
        sha1 = "11f0428335ad8d89ff9cf96ab2852a23b1b33b71";
      })
    ];
    buildInputs =
      (self.nativeDeps."nssocket"."~0.5.1" or []);
    deps = [
      self.full."eventemitter2"."~0.4.11"
      self.full."lazy"."~1.0.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nssocket" ];
  };
  full."oauth-sign"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.2.0.tgz";
        sha1 = "a0e6a1715daed062f322b622b7fe5afd1035b6e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  full."oauth-sign"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
        sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign"."~0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  full."object-additions".">= 0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-additions-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-additions/-/object-additions-0.5.1.tgz";
        sha1 = "ac624e0995e696c94cc69b41f316462b16a3bda4";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-additions".">= 0.5.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "object-additions" ];
  };
  full."once"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.1.1.tgz";
        sha1 = "9db574933ccb08c3a7614d154032c09ea6f339e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."once"."1.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  full."once"."~1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.1.1.tgz";
        sha1 = "9db574933ccb08c3a7614d154032c09ea6f339e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."once"."~1.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  full."open"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "open-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/open/-/open-0.0.4.tgz";
        sha1 = "5de46a0858b9f49f9f211aa8f26628550657f262";
      })
    ];
    buildInputs =
      (self.nativeDeps."open"."0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "open" ];
  };
  full."open"."~0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "open-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/open/-/open-0.0.4.tgz";
        sha1 = "5de46a0858b9f49f9f211aa8f26628550657f262";
      })
    ];
    buildInputs =
      (self.nativeDeps."open"."~0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "open" ];
  };
  full."opener"."~1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "opener-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/opener/-/opener-1.3.0.tgz";
        sha1 = "130ba662213fa842edb4cd0361d31a15301a43e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."opener"."~1.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "opener" ];
  };
  full."optimist"."*" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.0.tgz";
        sha1 = "69424826f3405f79f142e6fc3d9ae58d4dbb9200";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."*" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
      self.full."minimist"."~0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  "optimist" = self.full."optimist"."*";
  full."optimist"."0.2" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.2.8.tgz";
        sha1 = "e981ab7e268b457948593b55674c099a815cac31";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."0.2" or []);
    deps = [
      self.full."wordwrap".">=0.0.1 <0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.5.tgz";
        sha1 = "03654b52417030312d109f39b159825b60309304";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."0.3.5" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."0.3.x" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."0.3.x" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.4.0.tgz";
        sha1 = "cb8ec37f2fe3aa9864cb67a275250e7e19620a25";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."0.4.0" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.0.tgz";
        sha1 = "69424826f3405f79f142e6fc3d9ae58d4dbb9200";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."0.6.0" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
      self.full."minimist"."~0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."~0.3" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."~0.3" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."~0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."~0.3.4" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."~0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."~0.3.5" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."optimist"."~0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.0.tgz";
        sha1 = "69424826f3405f79f142e6fc3d9ae58d4dbb9200";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist"."~0.6.0" or []);
    deps = [
      self.full."wordwrap"."~0.0.2"
      self.full."minimist"."~0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  full."options".">=0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "options-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/options/-/options-0.0.5.tgz";
        sha1 = "9a3806378f316536d79038038ba90ccb724816c3";
      })
    ];
    buildInputs =
      (self.nativeDeps."options".">=0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "options" ];
  };
  full."optparse"."*" = lib.makeOverridable self.buildNodePackage {
    name = "optparse-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optparse/-/optparse-1.0.4.tgz";
        sha1 = "c062579d2d05d243c221a304a71e0c979623ccf1";
      })
    ];
    buildInputs =
      (self.nativeDeps."optparse"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optparse" ];
  };
  "optparse" = self.full."optparse"."*";
  full."optparse".">= 1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "optparse-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optparse/-/optparse-1.0.4.tgz";
        sha1 = "c062579d2d05d243c221a304a71e0c979623ccf1";
      })
    ];
    buildInputs =
      (self.nativeDeps."optparse".">= 1.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optparse" ];
  };
  full."osenv"."0" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.0.3.tgz";
        sha1 = "cd6ad8ddb290915ad9e22765576025d411f29cb6";
      })
    ];
    buildInputs =
      (self.nativeDeps."osenv"."0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "osenv" ];
  };
  full."osenv"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.0.3.tgz";
        sha1 = "cd6ad8ddb290915ad9e22765576025d411f29cb6";
      })
    ];
    buildInputs =
      (self.nativeDeps."osenv"."0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "osenv" ];
  };
  full."over"."~0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "over-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/over/-/over-0.0.5.tgz";
        sha1 = "f29852e70fd7e25f360e013a8ec44c82aedb5708";
      })
    ];
    buildInputs =
      (self.nativeDeps."over"."~0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "over" ];
  };
  full."owl-deepcopy"."~0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "owl-deepcopy-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/owl-deepcopy/-/owl-deepcopy-0.0.2.tgz";
        sha1 = "056c40e1af73dff6e2c7afae983d2a7760fdff88";
      })
    ];
    buildInputs =
      (self.nativeDeps."owl-deepcopy"."~0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "owl-deepcopy" ];
  };
  full."passport"."*" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.17.tgz";
        sha1 = "2cd503be0d35f33a9726d00ad2654786643a23fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport"."*" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."pause"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  "passport" = self.full."passport"."*";
  full."passport"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.17.tgz";
        sha1 = "2cd503be0d35f33a9726d00ad2654786643a23fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport"."0.1.17" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."pause"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  full."passport"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.17.tgz";
        sha1 = "2cd503be0d35f33a9726d00ad2654786643a23fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport"."~0.1.1" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."pause"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  full."passport"."~0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "passport-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport/-/passport-0.1.17.tgz";
        sha1 = "2cd503be0d35f33a9726d00ad2654786643a23fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport"."~0.1.3" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."pause"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport" ];
  };
  full."passport-http"."*" = lib.makeOverridable self.buildNodePackage {
    name = "passport-http-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-http/-/passport-http-0.2.2.tgz";
        sha1 = "2501314c0ff4a831e8a51ccfdb1b68f5c7cbc9f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-http"."*" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."passport"."~0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-http" ];
  };
  "passport-http" = self.full."passport-http"."*";
  full."passport-local"."*" = lib.makeOverridable self.buildNodePackage {
    name = "passport-local-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-local/-/passport-local-0.1.6.tgz";
        sha1 = "fb0cf828048db931b67d19985c7aa06dd377a9db";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-local"."*" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."passport"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-local" ];
  };
  "passport-local" = self.full."passport-local"."*";
  full."passport-local"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "passport-local-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/passport-local/-/passport-local-0.1.6.tgz";
        sha1 = "fb0cf828048db931b67d19985c7aa06dd377a9db";
      })
    ];
    buildInputs =
      (self.nativeDeps."passport-local"."0.1.6" or []);
    deps = [
      self.full."pkginfo"."0.2.x"
      self.full."passport"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "passport-local" ];
  };
  full."pause"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "pause-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pause/-/pause-0.0.1.tgz";
        sha1 = "1d408b3fdb76923b9543d96fb4c9dfd535d9cb5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."pause"."0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pause" ];
  };
  full."phantomjs"."~1.9" = lib.makeOverridable self.buildNodePackage {
    name = "phantomjs-1.9.2-2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/phantomjs/-/phantomjs-1.9.2-2.tgz";
        sha1 = "256228800bc18292395eb0f54b14cd42c8093889";
      })
    ];
    buildInputs =
      (self.nativeDeps."phantomjs"."~1.9" or []);
    deps = [
      self.full."adm-zip"."0.2.1"
      self.full."kew"."~0.1.7"
      self.full."ncp"."0.4.2"
      self.full."npmconf"."0.0.24"
      self.full."mkdirp"."0.3.5"
      self.full."rimraf"."~2.0.2"
      self.full."which"."~1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "phantomjs" ];
  };
  full."phantomjs"."~1.9.1-2" = lib.makeOverridable self.buildNodePackage {
    name = "phantomjs-1.9.2-2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/phantomjs/-/phantomjs-1.9.2-2.tgz";
        sha1 = "256228800bc18292395eb0f54b14cd42c8093889";
      })
    ];
    buildInputs =
      (self.nativeDeps."phantomjs"."~1.9.1-2" or []);
    deps = [
      self.full."adm-zip"."0.2.1"
      self.full."kew"."~0.1.7"
      self.full."ncp"."0.4.2"
      self.full."npmconf"."0.0.24"
      self.full."mkdirp"."0.3.5"
      self.full."rimraf"."~2.0.2"
      self.full."which"."~1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "phantomjs" ];
  };
  full."pkginfo"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.2.3.tgz";
        sha1 = "7239c42a5ef6c30b8f328439d9b9ff71042490f8";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo"."0.2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  full."pkginfo"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo"."0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  full."pkginfo"."0.3.x" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo"."0.3.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  full."pkginfo"."0.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo"."0.x.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  full."plist-native"."*" = lib.makeOverridable self.buildNodePackage {
    name = "plist-native-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/plist-native/-/plist-native-0.2.2.tgz";
        sha1 = "6abde856b07a52f0d6bc027f7750f4d97ff93858";
      })
    ];
    buildInputs =
      (self.nativeDeps."plist-native"."*" or []);
    deps = [
      self.full."libxmljs"."~0.8.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "plist-native" ];
  };
  "plist-native" = self.full."plist-native"."*";
  full."policyfile"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "policyfile-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/policyfile/-/policyfile-0.0.4.tgz";
        sha1 = "d6b82ead98ae79ebe228e2daf5903311ec982e4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."policyfile"."0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "policyfile" ];
  };
  full."posix-getopt"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "posix-getopt-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/posix-getopt/-/posix-getopt-1.0.0.tgz";
        sha1 = "42a90eca6119014c78bc4b9b70463d294db1aa87";
      })
    ];
    buildInputs =
      (self.nativeDeps."posix-getopt"."1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "posix-getopt" ];
  };
  full."promise"."~2.0" = lib.makeOverridable self.buildNodePackage {
    name = "promise-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promise/-/promise-2.0.0.tgz";
        sha1 = "46648aa9d605af5d2e70c3024bf59436da02b80e";
      })
    ];
    buildInputs =
      (self.nativeDeps."promise"."~2.0" or []);
    deps = [
      self.full."is-promise"."~1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "promise" ];
  };
  full."prompt"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "prompt-0.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/prompt/-/prompt-0.2.11.tgz";
        sha1 = "26d455af4b7fac15291dfcdddf2400328c1fa446";
      })
    ];
    buildInputs =
      (self.nativeDeps."prompt"."0.2.11" or []);
    deps = [
      self.full."pkginfo"."0.x.x"
      self.full."read"."1.0.x"
      self.full."revalidator"."0.1.x"
      self.full."utile"."0.2.x"
      self.full."winston"."0.6.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "prompt" ];
  };
  full."prompt"."0.2.9" = lib.makeOverridable self.buildNodePackage {
    name = "prompt-0.2.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/prompt/-/prompt-0.2.9.tgz";
        sha1 = "fdd01e3f9654d0c44fbb8671f8d3f6ca009e3c16";
      })
    ];
    buildInputs =
      (self.nativeDeps."prompt"."0.2.9" or []);
    deps = [
      self.full."pkginfo"."0.x.x"
      self.full."read"."1.0.x"
      self.full."revalidator"."0.1.x"
      self.full."utile"."0.1.x"
      self.full."winston"."0.6.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "prompt" ];
  };
  full."promptly"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "promptly-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promptly/-/promptly-0.2.0.tgz";
        sha1 = "73ef200fa8329d5d3a8df41798950b8646ca46d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."promptly"."~0.2.0" or []);
    deps = [
      self.full."read"."~1.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "promptly" ];
  };
  full."promzard"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "promzard-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/promzard/-/promzard-0.2.0.tgz";
        sha1 = "766f33807faadeeecacf8057024fe5f753cfa3c1";
      })
    ];
    buildInputs =
      (self.nativeDeps."promzard"."~0.2.0" or []);
    deps = [
      self.full."read"."1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "promzard" ];
  };
  full."proto-list"."~1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "proto-list-1.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proto-list/-/proto-list-1.2.2.tgz";
        sha1 = "48b88798261ec2c4a785720cdfec6200d57d3326";
      })
    ];
    buildInputs =
      (self.nativeDeps."proto-list"."~1.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "proto-list" ];
  };
  full."ps-tree"."0.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "ps-tree-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ps-tree/-/ps-tree-0.0.3.tgz";
        sha1 = "dbf8d752a7fe22fa7d58635689499610e9276ddc";
      })
    ];
    buildInputs =
      (self.nativeDeps."ps-tree"."0.0.x" or []);
    deps = [
      self.full."event-stream"."~0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ps-tree" ];
  };
  full."pullstream"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "pullstream-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pullstream/-/pullstream-0.4.0.tgz";
        sha1 = "919f15ef376433b331351f116565dc17c6fcda77";
      })
    ];
    buildInputs =
      (self.nativeDeps."pullstream"."~0.4.0" or []);
    deps = [
      self.full."over"."~0.0.5"
      self.full."readable-stream"."~1.0.0"
      self.full."setimmediate"."~1.0.1"
      self.full."slice-stream"."0.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pullstream" ];
  };
  full."q"."0.9.x" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q"."0.9.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  full."q".">= 0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q".">= 0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  full."q"."~0.9" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q"."~0.9" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  full."q"."~0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q"."~0.9.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  full."q"."~0.9.6" = lib.makeOverridable self.buildNodePackage {
    name = "q-0.9.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
        sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
      })
    ];
    buildInputs =
      (self.nativeDeps."q"."~0.9.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  full."qs"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.1.tgz";
        sha1 = "9f6bf5d9ac6c76384e95d36d15b48980e5e4add0";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."0.5.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."qs"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.2.tgz";
        sha1 = "e5734acb7009fb918e800fd5c60c2f5b94a7ff43";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."0.5.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."qs"."0.5.5" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.5.tgz";
        sha1 = "b07f0d7ffe3efc6fc2fcde6c66a20775641423f3";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."0.5.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."qs"."0.6.5" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.6.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.5.tgz";
        sha1 = "294b268e4b0d4250f6dde19b3b8b34935dff14ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."0.6.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."qs"."~0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
        sha1 = "31b1ad058567651c526921506b9a8793911a0384";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."~0.5.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."qs"."~0.5.4" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
        sha1 = "31b1ad058567651c526921506b9a8793911a0384";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."~0.5.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."qs"."~0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.6.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.5.tgz";
        sha1 = "294b268e4b0d4250f6dde19b3b8b34935dff14ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs"."~0.6.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  full."rai"."~0.1" = lib.makeOverridable self.buildNodePackage {
    name = "rai-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rai/-/rai-0.1.7.tgz";
        sha1 = "1b50f1dcb4a493a67ef7a0a8c72167d789df52a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."rai"."~0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rai" ];
  };
  full."range-parser"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "range-parser-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-0.0.4.tgz";
        sha1 = "c0427ffef51c10acba0782a46c9602e744ff620b";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser"."0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  full."raw-socket"."*" = lib.makeOverridable self.buildNodePackage {
    name = "raw-socket-1.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-socket/-/raw-socket-1.2.2.tgz";
        sha1 = "c9be873878a1ef70497a27e40b6e55b563d8f886";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-socket"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-socket" ];
  };
  full."rbytes"."*" = lib.makeOverridable self.buildNodePackage {
    name = "rbytes-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rbytes/-/rbytes-1.0.0.tgz";
        sha1 = "4eeb85c457f710d8147329d5eed5cd02c798fa4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."rbytes"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rbytes" ];
  };
  "rbytes" = self.full."rbytes"."*";
  full."rc"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.3.0.tgz";
        sha1 = "caffdaafc17e8608e50db0c6ee63f1c344d9ac58";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc"."0.3.0" or []);
    deps = [
      self.full."optimist"."~0.3.4"
      self.full."deep-extend"."~0.2.5"
      self.full."ini"."~1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  full."rc"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.3.1.tgz";
        sha1 = "1da1bef8cf8201cafd3725bd82b31d1cf7321248";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc"."~0.3.0" or []);
    deps = [
      self.full."optimist"."~0.3.4"
      self.full."deep-extend"."~0.2.5"
      self.full."ini"."~1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  full."read"."1" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read"."1" or []);
    deps = [
      self.full."mute-stream"."~0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  full."read"."1.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read"."1.0.x" or []);
    deps = [
      self.full."mute-stream"."~0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  full."read"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read"."~1.0.1" or []);
    deps = [
      self.full."mute-stream"."~0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  full."read"."~1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read"."~1.0.4" or []);
    deps = [
      self.full."mute-stream"."~0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  full."read-installed"."~0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "read-installed-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-installed/-/read-installed-0.2.4.tgz";
        sha1 = "9a45ca0a8ae1ecdb05972f362b63bc59450b572d";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-installed"."~0.2.2" or []);
    deps = [
      self.full."semver"."2"
      self.full."slide"."~1.1.3"
      self.full."read-package-json"."1"
      self.full."graceful-fs"."~2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-installed" ];
  };
  full."read-package-json"."1" = lib.makeOverridable self.buildNodePackage {
    name = "read-package-json-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.1.3.tgz";
        sha1 = "a361ab3da88f6f78998df223ad8186a4b7e1f391";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json"."1" or []);
    deps = [
      self.full."glob"."~3.2.1"
      self.full."lru-cache"."2"
      self.full."normalize-package-data"."~0.2"
      self.full."graceful-fs"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  full."read-package-json"."~1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "read-package-json-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.1.3.tgz";
        sha1 = "a361ab3da88f6f78998df223ad8186a4b7e1f391";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json"."~1.1.0" or []);
    deps = [
      self.full."glob"."~3.2.1"
      self.full."lru-cache"."2"
      self.full."normalize-package-data"."~0.2"
      self.full."graceful-fs"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  full."read-package-json"."~1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "read-package-json-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read-package-json/-/read-package-json-1.1.3.tgz";
        sha1 = "a361ab3da88f6f78998df223ad8186a4b7e1f391";
      })
    ];
    buildInputs =
      (self.nativeDeps."read-package-json"."~1.1.3" or []);
    deps = [
      self.full."glob"."~3.2.1"
      self.full."lru-cache"."2"
      self.full."normalize-package-data"."~0.2"
      self.full."graceful-fs"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read-package-json" ];
  };
  full."readable-stream"."1.0" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.17.tgz";
        sha1 = "cbc295fdf394dfa1225d225d02e6b6d0f409fd4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream"."1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  full."readable-stream"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.17.tgz";
        sha1 = "cbc295fdf394dfa1225d225d02e6b6d0f409fd4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  full."readable-stream"."~1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.17.tgz";
        sha1 = "cbc295fdf394dfa1225d225d02e6b6d0f409fd4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream"."~1.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  full."readdirp"."~0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "readdirp-0.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readdirp/-/readdirp-0.2.5.tgz";
        sha1 = "c4c276e52977ae25db5191fe51d008550f15d9bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."readdirp"."~0.2.3" or []);
    deps = [
      self.full."minimatch".">=0.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readdirp" ];
  };
  full."redeyed"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "redeyed-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redeyed/-/redeyed-0.4.2.tgz";
        sha1 = "f0133b990cb972bdbcf2d2dce0aec36595f419bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."redeyed"."~0.4.0" or []);
    deps = [
      self.full."esprima"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redeyed" ];
  };
  full."redis"."*" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.8.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.8.6.tgz";
        sha1 = "a7ae8f0d6fad24bdeaffe28158d6cd1f1c9d30b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  "redis" = self.full."redis"."*";
  full."redis"."0.7.2" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.7.2.tgz";
        sha1 = "fa557fef4985ab3e3384fdc5be6e2541a0bb49af";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis"."0.7.2" or []);
    deps = [
      self.full."hiredis"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  full."redis"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.7.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.7.3.tgz";
        sha1 = "ee57b7a44d25ec1594e44365d8165fa7d1d4811a";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis"."0.7.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  full."redis".">= 0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "redis-0.8.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/redis/-/redis-0.8.6.tgz";
        sha1 = "a7ae8f0d6fad24bdeaffe28158d6cd1f1c9d30b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."redis".">= 0.6.6" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "redis" ];
  };
  full."reds"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "reds-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/reds/-/reds-0.1.4.tgz";
        sha1 = "a97819180c30f6ecd01cad03cecb574eaabb4bee";
      })
    ];
    buildInputs =
      (self.nativeDeps."reds"."0.1.4" or []);
    deps = [
      self.full."natural"."0.0.69"
      self.full."redis".">= 0.6.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "reds" ];
  };
  full."regexp-clone"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "regexp-clone-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/regexp-clone/-/regexp-clone-0.0.1.tgz";
        sha1 = "a7c2e09891fdbf38fbb10d376fb73003e68ac589";
      })
    ];
    buildInputs =
      (self.nativeDeps."regexp-clone"."0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "regexp-clone" ];
  };
  full."replace"."~0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "replace-0.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/replace/-/replace-0.2.7.tgz";
        sha1 = "e22d08a9e2e6764337bb530166a4dd89c2558fda";
      })
    ];
    buildInputs =
      (self.nativeDeps."replace"."~0.2.4" or []);
    deps = [
      self.full."nomnom"."1.6.x"
      self.full."colors"."0.5.x"
      self.full."minimatch"."~0.2.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "replace" ];
  };
  full."request"."2" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."2" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."2 >=2.20.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."2 >=2.20.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."2 >=2.25.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."2 >=2.25.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."2.16.2" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.16.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.2.tgz";
        sha1 = "83a028be61be4a05163e7e2e7a4b40e35df1bcb9";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."2.16.2" or []);
    deps = [
      self.full."form-data"."~0.0.3"
      self.full."mime"."~1.2.7"
      self.full."hawk"."~0.10.0"
      self.full."node-uuid"."~1.4.0"
      self.full."cookie-jar"."~0.2.0"
      self.full."aws-sign"."~0.2.0"
      self.full."oauth-sign"."~0.2.0"
      self.full."forever-agent"."~0.2.0"
      self.full."tunnel-agent"."~0.2.0"
      self.full."json-stringify-safe"."~3.0.0"
      self.full."qs"."~0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."2.16.x" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.16.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.6.tgz";
        sha1 = "872fe445ae72de266b37879d6ad7dc948fa01cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."2.16.x" or []);
    deps = [
      self.full."form-data"."~0.0.3"
      self.full."mime"."~1.2.7"
      self.full."hawk"."~0.10.2"
      self.full."node-uuid"."~1.4.0"
      self.full."cookie-jar"."~0.2.0"
      self.full."aws-sign"."~0.2.0"
      self.full."oauth-sign"."~0.2.0"
      self.full."forever-agent"."~0.2.0"
      self.full."tunnel-agent"."~0.2.0"
      self.full."json-stringify-safe"."~3.0.0"
      self.full."qs"."~0.5.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."2.9.x" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.9.203";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.9.203.tgz";
        sha1 = "6c1711a5407fb94a114219563e44145bcbf4723a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."2.9.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request".">=2.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request".">=2.12.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."~2" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."~2" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."~2.16.6" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.16.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.6.tgz";
        sha1 = "872fe445ae72de266b37879d6ad7dc948fa01cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."~2.16.6" or []);
    deps = [
      self.full."form-data"."~0.0.3"
      self.full."mime"."~1.2.7"
      self.full."hawk"."~0.10.2"
      self.full."node-uuid"."~1.4.0"
      self.full."cookie-jar"."~0.2.0"
      self.full."aws-sign"."~0.2.0"
      self.full."oauth-sign"."~0.2.0"
      self.full."forever-agent"."~0.2.0"
      self.full."tunnel-agent"."~0.2.0"
      self.full."json-stringify-safe"."~3.0.0"
      self.full."qs"."~0.5.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."~2.21.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.21.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.21.0.tgz";
        sha1 = "5728ab9c45e5a87c99daccd530298b6673a868d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."~2.21.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~4.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.9.11"
      self.full."hawk"."~0.13.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."~2.22.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.22.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.22.0.tgz";
        sha1 = "b883a769cc4a909571eb5004b344c43cf7e51592";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."~2.22.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~4.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~0.13.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."~2.25.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.25.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.25.0.tgz";
        sha1 = "dac1673181887fe0b2ce6bd7e12f46d554a02ce9";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."~2.25.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request"."~2.27.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.27.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.27.0.tgz";
        sha1 = "dfb1a224dd3a5a9bade4337012503d710e538668";
      })
    ];
    buildInputs =
      (self.nativeDeps."request"."~2.27.0" or []);
    deps = [
      self.full."qs"."~0.6.0"
      self.full."json-stringify-safe"."~5.0.0"
      self.full."forever-agent"."~0.5.0"
      self.full."tunnel-agent"."~0.3.0"
      self.full."http-signature"."~0.10.0"
      self.full."hawk"."~1.0.0"
      self.full."aws-sign"."~0.3.0"
      self.full."oauth-sign"."~0.3.0"
      self.full."cookie-jar"."~0.3.0"
      self.full."node-uuid"."~1.4.0"
      self.full."mime"."~1.2.9"
      self.full."form-data"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  full."request-progress"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-progress-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-progress/-/request-progress-0.3.1.tgz";
        sha1 = "0721c105d8a96ac6b2ce8b2c89ae2d5ecfcf6b3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-progress"."~0.3.0" or []);
    deps = [
      self.full."throttleit"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request-progress" ];
  };
  full."request-replay"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-replay-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request-replay/-/request-replay-0.2.0.tgz";
        sha1 = "9b693a5d118b39f5c596ead5ed91a26444057f60";
      })
    ];
    buildInputs =
      (self.nativeDeps."request-replay"."~0.2.0" or []);
    deps = [
      self.full."retry"."~0.6.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request-replay" ];
  };
  full."requirejs"."~2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "requirejs-2.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/requirejs/-/requirejs-2.1.8.tgz";
        sha1 = "f0dfa656d60d404947da796f9c661d92c1b0257a";
      })
    ];
    buildInputs =
      (self.nativeDeps."requirejs"."~2.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "requirejs" ];
  };
  full."resolve"."0.5.x" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.5.1.tgz";
        sha1 = "15e4a222c4236bcd4cf85454412c2d0fb6524576";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve"."0.5.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  full."resolve"."~0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.3.1.tgz";
        sha1 = "34c63447c664c70598d1c9b126fc43b2a24310a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve"."~0.3.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  full."restify"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "restify-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/restify/-/restify-2.4.1.tgz";
        sha1 = "35790a052bd0927e7f6a06cc3d079e56fabc9371";
      })
    ];
    buildInputs =
      (self.nativeDeps."restify"."2.4.1" or []);
    deps = [
      self.full."assert-plus"."0.1.2"
      self.full."backoff"."2.1.0"
      self.full."bunyan"."0.21.1"
      self.full."deep-equal"."0.0.0"
      self.full."formidable"."1.0.13"
      self.full."http-signature"."0.9.11"
      self.full."keep-alive-agent"."0.0.1"
      self.full."lru-cache"."2.3.0"
      self.full."mime"."1.2.9"
      self.full."negotiator"."0.2.5"
      self.full."node-uuid"."1.4.0"
      self.full."once"."1.1.1"
      self.full."qs"."0.5.5"
      self.full."semver"."1.1.4"
      self.full."spdy"."1.7.1"
      self.full."verror"."1.3.6"
      self.full."dtrace-provider"."0.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "restify" ];
  };
  full."retry"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "retry-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/retry/-/retry-0.6.0.tgz";
        sha1 = "1c010713279a6fd1e8def28af0c3ff1871caa537";
      })
    ];
    buildInputs =
      (self.nativeDeps."retry"."0.6.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "retry" ];
  };
  full."retry"."~0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "retry-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/retry/-/retry-0.6.0.tgz";
        sha1 = "1c010713279a6fd1e8def28af0c3ff1871caa537";
      })
    ];
    buildInputs =
      (self.nativeDeps."retry"."~0.6.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "retry" ];
  };
  full."revalidator"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "revalidator-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/revalidator/-/revalidator-0.1.5.tgz";
        sha1 = "205bc02e4186e63e82a0837498f29ba287be3861";
      })
    ];
    buildInputs =
      (self.nativeDeps."revalidator"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "revalidator" ];
  };
  full."rimraf"."1.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-1.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-1.0.9.tgz";
        sha1 = "be4801ff76c2ba6f1c50c78e9700eb1d21f239f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."1.x.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."2" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.2.tgz";
        sha1 = "d99ec41dc646e55bf7a7a44a255c28bef33a8abf";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."2" or []);
    deps = [
      self.full."graceful-fs"."~2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."2.x.x" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.2.tgz";
        sha1 = "d99ec41dc646e55bf7a7a44a255c28bef33a8abf";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."2.x.x" or []);
    deps = [
      self.full."graceful-fs"."~2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."~2" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.2.tgz";
        sha1 = "d99ec41dc646e55bf7a7a44a255c28bef33a8abf";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."~2" or []);
    deps = [
      self.full."graceful-fs"."~2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."~2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.0.3.tgz";
        sha1 = "f50a2965e7144e9afd998982f15df706730f56a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."~2.0.2" or []);
    deps = [
      self.full."graceful-fs"."~1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."~2.1" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.1.4.tgz";
        sha1 = "5a6eb62eeda068f51ede50f29b3e5cd22f3d9bb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."~2.1" or []);
    deps = [
      self.full."graceful-fs"."~1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."~2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.1.4.tgz";
        sha1 = "5a6eb62eeda068f51ede50f29b3e5cd22f3d9bb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."~2.1.4" or []);
    deps = [
      self.full."graceful-fs"."~1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."rimraf"."~2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.2.tgz";
        sha1 = "d99ec41dc646e55bf7a7a44a255c28bef33a8abf";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."~2.2.0" or []);
    deps = [
      self.full."graceful-fs"."~2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."s3http"."*" = lib.makeOverridable self.buildNodePackage {
    name = "s3http-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/s3http/-/s3http-0.0.2.tgz";
        sha1 = "e0c8bdee66981c6ddef2dfc41bb1fe51765984e5";
      })
    ];
    buildInputs =
      (self.nativeDeps."s3http"."*" or []);
    deps = [
      self.full."aws-sdk".">=1.2.0 <2"
      self.full."commander"."0.5.1"
      self.full."http-auth"."1.2.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "s3http" ];
  };
  "s3http" = self.full."s3http"."*";
  full."sauce-connect-launcher"."~0.1.10" = lib.makeOverridable self.buildNodePackage {
    name = "sauce-connect-launcher-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sauce-connect-launcher/-/sauce-connect-launcher-0.1.11.tgz";
        sha1 = "71ac88bdab7bd8396a3f7d9feb165a4e457c3ecd";
      })
    ];
    buildInputs =
      (self.nativeDeps."sauce-connect-launcher"."~0.1.10" or []);
    deps = [
      self.full."lodash"."~1.3.1"
      self.full."async"."~0.2.9"
      self.full."adm-zip"."~0.4.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sauce-connect-launcher" ];
  };
  full."sax"."0.5.x" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.5.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.5.5.tgz";
        sha1 = "b1ec13d77397248d059bcc18bb9530d8210bb5d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax"."0.5.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  full."sax".">=0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.5.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.5.5.tgz";
        sha1 = "b1ec13d77397248d059bcc18bb9530d8210bb5d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax".">=0.4.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  full."selenium-webdriver"."*" = lib.makeOverridable self.buildNodePackage {
    name = "selenium-webdriver-2.35.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/selenium-webdriver/-/selenium-webdriver-2.35.2.tgz";
        sha1 = "e6bbb6ff26ea61224173caa006a8eb87d6a94c2d";
      })
    ];
    buildInputs =
      (self.nativeDeps."selenium-webdriver"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "selenium-webdriver" ];
  };
  "selenium-webdriver" = self.full."selenium-webdriver"."*";
  full."semver"."*" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  "semver" = self.full."semver"."*";
  full."semver"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.0.tgz";
        sha1 = "da9b9c837e31550a7c928622bc2381de7dd7a53e";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."1.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.4.tgz";
        sha1 = "2e5a4e72bab03472cc97f72753b4508912ef5540";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."1.1.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."2" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.0.8.tgz";
        sha1 = "f5c28ba4a6d56bd1d9dbe34aed288d69366a73c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."2.0.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."2.x" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."2.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver".">=2.0.10 <3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver".">=2.0.10 <3.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.4.tgz";
        sha1 = "2e5a4e72bab03472cc97f72753b4508912ef5540";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~1.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "semver-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-1.1.4.tgz";
        sha1 = "2e5a4e72bab03472cc97f72753b4508912ef5540";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~1.1.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.0.11.tgz";
        sha1 = "f51f07d03fa5af79beb537fc067a7e141786cced";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~2.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~2.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.0.11.tgz";
        sha1 = "f51f07d03fa5af79beb537fc067a7e141786cced";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~2.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.0.11.tgz";
        sha1 = "f51f07d03fa5af79beb537fc067a7e141786cced";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~2.0.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~2.1" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."semver"."~2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.1.0.tgz";
        sha1 = "356294a90690b698774d62cf35d7c91f983e728a";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver"."~2.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  full."send"."*" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.4.tgz";
        sha1 = "be70d8d1be01de61821af13780b50345a4f71abd";
      })
    ];
    buildInputs =
      (self.nativeDeps."send"."*" or []);
    deps = [
      self.full."debug"."*"
      self.full."mime"."~1.2.9"
      self.full."fresh"."0.2.0"
      self.full."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  full."send"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.0.tgz";
        sha1 = "cfb08ebd3cec9b7fc1a37d9ff9e875a971cf4640";
      })
    ];
    buildInputs =
      (self.nativeDeps."send"."0.1.0" or []);
    deps = [
      self.full."debug"."*"
      self.full."mime"."1.2.6"
      self.full."fresh"."0.1.0"
      self.full."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  full."send"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.1.tgz";
        sha1 = "0bcfcbd03def6e2d8612e1abf8f4895b450c60c8";
      })
    ];
    buildInputs =
      (self.nativeDeps."send"."0.1.1" or []);
    deps = [
      self.full."debug"."*"
      self.full."mime"."~1.2.9"
      self.full."fresh"."0.1.0"
      self.full."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  full."send"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.1.4.tgz";
        sha1 = "be70d8d1be01de61821af13780b50345a4f71abd";
      })
    ];
    buildInputs =
      (self.nativeDeps."send"."0.1.4" or []);
    deps = [
      self.full."debug"."*"
      self.full."mime"."~1.2.9"
      self.full."fresh"."0.2.0"
      self.full."range-parser"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  full."sequence"."*" = lib.makeOverridable self.buildNodePackage {
    name = "sequence-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
        sha1 = "7f5617895d44351c0a047e764467690490a16b03";
      })
    ];
    buildInputs =
      (self.nativeDeps."sequence"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sequence" ];
  };
  full."sequence".">= 2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "sequence-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
        sha1 = "7f5617895d44351c0a047e764467690490a16b03";
      })
    ];
    buildInputs =
      (self.nativeDeps."sequence".">= 2.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sequence" ];
  };
  full."setimmediate"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "setimmediate-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/setimmediate/-/setimmediate-1.0.1.tgz";
        sha1 = "a9ca56ccbd6a4c3334855f060abcdece5c42ebb7";
      })
    ];
    buildInputs =
      (self.nativeDeps."setimmediate"."~1.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "setimmediate" ];
  };
  full."sha"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "sha-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha/-/sha-1.0.1.tgz";
        sha1 = "9b87a92113103e7406f7e7ef00006f3fa1975122";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha"."~1.0.1" or []);
    deps = [
      self.full."graceful-fs"."1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
  };
  full."sha"."~1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "sha-1.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sha/-/sha-1.2.3.tgz";
        sha1 = "3a96ef3054a0fe0b87c9aa985824a6a736fc0329";
      })
    ];
    buildInputs =
      (self.nativeDeps."sha"."~1.2.1" or []);
    deps = [
      self.full."graceful-fs"."2"
      self.full."readable-stream"."1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sha" ];
  };
  full."shelljs"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "shelljs-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shelljs/-/shelljs-0.1.4.tgz";
        sha1 = "dfbbe78d56c3c0168d2fb79e10ecd1dbcb07ec0e";
      })
    ];
    buildInputs =
      (self.nativeDeps."shelljs"."0.1.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shelljs" ];
  };
  full."shelljs"."~0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "shelljs-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shelljs/-/shelljs-0.1.4.tgz";
        sha1 = "dfbbe78d56c3c0168d2fb79e10ecd1dbcb07ec0e";
      })
    ];
    buildInputs =
      (self.nativeDeps."shelljs"."~0.1.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "shelljs" ];
  };
  full."should"."*" = lib.makeOverridable self.buildNodePackage {
    name = "should-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should/-/should-1.3.0.tgz";
        sha1 = "20b71a09b5ed16146b903022bd306ef332efe873";
      })
    ];
    buildInputs =
      (self.nativeDeps."should"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "should" ];
  };
  "should" = self.full."should"."*";
  full."sigmund"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "sigmund-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.0.tgz";
        sha1 = "66a2b3a749ae8b5fb89efd4fcc01dc94fbe02296";
      })
    ];
    buildInputs =
      (self.nativeDeps."sigmund"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sigmund" ];
  };
  full."signals"."<2.0" = lib.makeOverridable self.buildNodePackage {
    name = "signals-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/signals/-/signals-1.0.0.tgz";
        sha1 = "65f0c1599352b35372ecaae5a250e6107376ed69";
      })
    ];
    buildInputs =
      (self.nativeDeps."signals"."<2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "signals" ];
  };
  full."signals".">0.7 <2.0" = lib.makeOverridable self.buildNodePackage {
    name = "signals-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/signals/-/signals-1.0.0.tgz";
        sha1 = "65f0c1599352b35372ecaae5a250e6107376ed69";
      })
    ];
    buildInputs =
      (self.nativeDeps."signals".">0.7 <2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "signals" ];
  };
  full."signals"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "signals-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/signals/-/signals-1.0.0.tgz";
        sha1 = "65f0c1599352b35372ecaae5a250e6107376ed69";
      })
    ];
    buildInputs =
      (self.nativeDeps."signals"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "signals" ];
  };
  full."simplesmtp".">= 0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "simplesmtp-0.3.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/simplesmtp/-/simplesmtp-0.3.10.tgz";
        sha1 = "f395f4b118de45f82ac4fdae4bd88f12dc326f5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."simplesmtp".">= 0.1.22" or []);
    deps = [
      self.full."rai"."~0.1"
      self.full."xoauth2"."~0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "simplesmtp" ];
  };
  full."slice-stream"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "slice-stream-0.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slice-stream/-/slice-stream-0.0.0.tgz";
        sha1 = "8183df87ad44ae0b48c0625134eac6e349747860";
      })
    ];
    buildInputs =
      (self.nativeDeps."slice-stream"."0.0.0" or []);
    deps = [
      self.full."readable-stream"."~1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "slice-stream" ];
  };
  full."sliced"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "sliced-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.3.tgz";
        sha1 = "4f0bac2171eb17162c3ba6df81f5cf040f7c7e50";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced"."0.0.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  full."sliced"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "sliced-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.4.tgz";
        sha1 = "34f89a6db1f31fa525f5a570f5bcf877cf0955ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced"."0.0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  full."sliced"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "sliced-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sliced/-/sliced-0.0.5.tgz";
        sha1 = "5edc044ca4eb6f7816d50ba2fc63e25d8fe4707f";
      })
    ];
    buildInputs =
      (self.nativeDeps."sliced"."0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sliced" ];
  };
  full."slide"."~1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "slide-1.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.5.tgz";
        sha1 = "31732adeae78f1d2d60a29b63baf6a032df7c25d";
      })
    ];
    buildInputs =
      (self.nativeDeps."slide"."~1.1.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "slide" ];
  };
  full."slide"."~1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "slide-1.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.5.tgz";
        sha1 = "31732adeae78f1d2d60a29b63baf6a032df7c25d";
      })
    ];
    buildInputs =
      (self.nativeDeps."slide"."~1.1.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "slide" ];
  };
  full."slide"."~1.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "slide-1.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.5.tgz";
        sha1 = "31732adeae78f1d2d60a29b63baf6a032df7c25d";
      })
    ];
    buildInputs =
      (self.nativeDeps."slide"."~1.1.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "slide" ];
  };
  full."smartdc"."*" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-7.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc/-/smartdc-7.1.0.tgz";
        sha1 = "8c6e5ac34501d6997dcf0e1c49aff4655053ad0f";
      })
    ];
    buildInputs =
      (self.nativeDeps."smartdc"."*" or []);
    deps = [
      self.full."assert-plus"."0.1.2"
      self.full."lru-cache"."2.2.0"
      self.full."nopt"."2.0.0"
      self.full."restify"."2.4.1"
      self.full."bunyan"."0.21.1"
      self.full."clone"."0.1.6"
      self.full."smartdc-auth"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "smartdc" ];
  };
  "smartdc" = self.full."smartdc"."*";
  full."smartdc-auth"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "smartdc-auth-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/smartdc-auth/-/smartdc-auth-1.0.0.tgz";
        sha1 = "9b8569b914f25da53816fe158f80b6571470f270";
      })
    ];
    buildInputs =
      (self.nativeDeps."smartdc-auth"."1.0.0" or []);
    deps = [
      self.full."assert-plus"."0.1.2"
      self.full."clone"."0.1.5"
      self.full."ssh-agent"."0.2.1"
      self.full."once"."1.1.1"
      self.full."vasync"."1.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "smartdc-auth" ];
  };
  full."sntp"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.1.4.tgz";
        sha1 = "5ef481b951a7b29affdf4afd7f26838fc1120f84";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp"."0.1.x" or []);
    deps = [
      self.full."hoek"."0.7.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  full."sntp"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
        sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp"."0.2.x" or []);
    deps = [
      self.full."hoek"."0.9.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  full."socket.io"."0.9.14" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-0.9.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.14.tgz";
        sha1 = "81af80ebf3ee8f7f6e71b1495db91f8fa53ff667";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io"."0.9.14" or []);
    deps = [
      self.full."socket.io-client"."0.9.11"
      self.full."policyfile"."0.0.4"
      self.full."base64id"."0.1.0"
      self.full."redis"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  full."socket.io"."0.9.16" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-0.9.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.16.tgz";
        sha1 = "3bab0444e49b55fbbc157424dbd41aa375a51a76";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io"."0.9.16" or []);
    deps = [
      self.full."socket.io-client"."0.9.16"
      self.full."policyfile"."0.0.4"
      self.full."base64id"."0.1.0"
      self.full."redis"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  full."socket.io"."~0.9.13" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-0.9.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.16.tgz";
        sha1 = "3bab0444e49b55fbbc157424dbd41aa375a51a76";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io"."~0.9.13" or []);
    deps = [
      self.full."socket.io-client"."0.9.16"
      self.full."policyfile"."0.0.4"
      self.full."base64id"."0.1.0"
      self.full."redis"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  full."socket.io"."~0.9.14" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-0.9.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io/-/socket.io-0.9.16.tgz";
        sha1 = "3bab0444e49b55fbbc157424dbd41aa375a51a76";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io"."~0.9.14" or []);
    deps = [
      self.full."socket.io-client"."0.9.16"
      self.full."policyfile"."0.0.4"
      self.full."base64id"."0.1.0"
      self.full."redis"."0.7.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io" ];
  };
  full."socket.io-client"."0.9.11" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-client-0.9.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-0.9.11.tgz";
        sha1 = "94defc1b29e0d8a8fe958c1cf33300f68d8a19c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io-client"."0.9.11" or []);
    deps = [
      self.full."uglify-js"."1.2.5"
      self.full."ws"."0.4.x"
      self.full."xmlhttprequest"."1.4.2"
      self.full."active-x-obfuscator"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io-client" ];
  };
  full."socket.io-client"."0.9.16" = lib.makeOverridable self.buildNodePackage {
    name = "socket.io-client-0.9.16";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-0.9.16.tgz";
        sha1 = "4da7515c5e773041d1b423970415bcc430f35fc6";
      })
    ];
    buildInputs =
      (self.nativeDeps."socket.io-client"."0.9.16" or []);
    deps = [
      self.full."uglify-js"."1.2.5"
      self.full."ws"."0.4.x"
      self.full."xmlhttprequest"."1.4.2"
      self.full."active-x-obfuscator"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socket.io-client" ];
  };
  full."sockjs"."*" = lib.makeOverridable self.buildNodePackage {
    name = "sockjs-0.3.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sockjs/-/sockjs-0.3.7.tgz";
        sha1 = "2950e0586d8a9d3044958a831ade68db197749cb";
      })
    ];
    buildInputs =
      (self.nativeDeps."sockjs"."*" or []);
    deps = [
      self.full."node-uuid"."1.3.3"
      self.full."faye-websocket"."0.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sockjs" ];
  };
  "sockjs" = self.full."sockjs"."*";
  full."source-map"."*" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.30";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.30.tgz";
        sha1 = "182726b50671d8fccaefc5ec35bf2a65c1956afb";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map"."*" or []);
    deps = [
      self.full."amdefine".">=0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  "source-map" = self.full."source-map"."*";
  full."source-map".">= 0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.30";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.30.tgz";
        sha1 = "182726b50671d8fccaefc5ec35bf2a65c1956afb";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map".">= 0.1.2" or []);
    deps = [
      self.full."amdefine".">=0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  full."source-map"."~0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.30";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.30.tgz";
        sha1 = "182726b50671d8fccaefc5ec35bf2a65c1956afb";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map"."~0.1.7" or []);
    deps = [
      self.full."amdefine".">=0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  full."spdy"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "spdy-1.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/spdy/-/spdy-1.7.1.tgz";
        sha1 = "4fde77e602b20c4ecc39ee8619373dd9bf669152";
      })
    ];
    buildInputs =
      (self.nativeDeps."spdy"."1.7.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "spdy" ];
  };
  full."ssh-agent"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ssh-agent-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ssh-agent/-/ssh-agent-0.2.1.tgz";
        sha1 = "3044e9eaeca88a9e6971dd7deb19bdcc20012929";
      })
    ];
    buildInputs =
      (self.nativeDeps."ssh-agent"."0.2.1" or []);
    deps = [
      self.full."ctype"."0.5.0"
      self.full."posix-getopt"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ssh-agent" ];
  };
  full."ssh2"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "ssh2-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ssh2/-/ssh2-0.2.8.tgz";
        sha1 = "50acd6d7a7fb4da18ef4364737bb9a5066bf689d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ssh2"."0.2.8" or []);
    deps = [
      self.full."streamsearch"."0.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ssh2" ];
  };
  full."stack-trace"."0.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "stack-trace-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.7.tgz";
        sha1 = "c72e089744fc3659f508cdce3621af5634ec0fff";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace"."0.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  full."statsd"."*" = lib.makeOverridable self.buildNodePackage {
    name = "statsd-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/statsd/-/statsd-0.6.0.tgz";
        sha1 = "9902dba319c46726f0348ced9b7b3e20184de1c4";
      })
    ];
    buildInputs =
      (self.nativeDeps."statsd"."*" or []);
    deps = [
      self.full."node-syslog"."1.1.3"
      self.full."winser"."=0.0.11"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "statsd" ];
  };
  "statsd" = self.full."statsd"."*";
  full."stream-counter"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-counter-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-counter/-/stream-counter-0.1.0.tgz";
        sha1 = "a035e429361fb57f361606e17fcd8a8b9677327b";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-counter"."~0.1.0" or []);
    deps = [
      self.full."readable-stream"."~1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  full."stream-splitter-transform"."*" = lib.makeOverridable self.buildNodePackage {
    name = "stream-splitter-transform-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-splitter-transform/-/stream-splitter-transform-0.0.3.tgz";
        sha1 = "5ccd3bd497ffee4c2fc7c1cc9d7b697b54c42eef";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-splitter-transform"."*" or []);
    deps = [
      self.full."buffertools".">=1.1.1 <2.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stream-splitter-transform" ];
  };
  "stream-splitter-transform" = self.full."stream-splitter-transform"."*";
  full."streamsearch"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "streamsearch-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/streamsearch/-/streamsearch-0.1.2.tgz";
        sha1 = "808b9d0e56fc273d809ba57338e929919a1a9f1a";
      })
    ];
    buildInputs =
      (self.nativeDeps."streamsearch"."0.1.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "streamsearch" ];
  };
  full."stringify-object"."~0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "stringify-object-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringify-object/-/stringify-object-0.1.7.tgz";
        sha1 = "bb54d1ceed118b428c1256742b40a53f03599581";
      })
    ];
    buildInputs =
      (self.nativeDeps."stringify-object"."~0.1.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stringify-object" ];
  };
  full."strong-data-uri"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "strong-data-uri-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strong-data-uri/-/strong-data-uri-0.1.0.tgz";
        sha1 = "a41235806b8c3bf0f6f324dc57dfe85bbab681a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."strong-data-uri"."~0.1.0" or []);
    deps = [
      self.full."truncate"."~1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "strong-data-uri" ];
  };
  full."stylus"."*" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.38.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.38.0.tgz";
        sha1 = "6bd0581db0ee0491251639d338685f7232ca0610";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus"."*" or []);
    deps = [
      self.full."cssom"."0.2.x"
      self.full."mkdirp"."0.3.x"
      self.full."debug"."*"
      self.full."sax"."0.5.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  "stylus" = self.full."stylus"."*";
  full."stylus"."0.27.2" = lib.makeOverridable self.buildNodePackage {
    name = "stylus-0.27.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stylus/-/stylus-0.27.2.tgz";
        sha1 = "1121f7f8cd152b0f8a4aa6a24a9adea10c825117";
      })
    ];
    buildInputs =
      (self.nativeDeps."stylus"."0.27.2" or []);
    deps = [
      self.full."cssom"."0.2.x"
      self.full."mkdirp"."0.3.x"
      self.full."debug"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stylus" ];
  };
  full."sudo-block"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "sudo-block-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sudo-block/-/sudo-block-0.2.1.tgz";
        sha1 = "b394820741b66c0fe06f97b334f0674036837ba5";
      })
    ];
    buildInputs =
      (self.nativeDeps."sudo-block"."~0.2.0" or []);
    deps = [
      self.full."chalk"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sudo-block" ];
  };
  full."superagent"."0.14.7" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.14.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.14.7.tgz";
        sha1 = "5740625d9c6343381b03b2ff95a3c988415fc406";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent"."0.14.7" or []);
    deps = [
      self.full."qs"."0.6.5"
      self.full."formidable"."1.0.9"
      self.full."mime"."1.2.5"
      self.full."emitter-component"."1.0.0"
      self.full."methods"."0.0.1"
      self.full."cookiejar"."1.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  full."superagent"."0.15.1" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.15.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.15.1.tgz";
        sha1 = "f0df9954c2b90f29e4ae54ad308e4a2b432cc56a";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent"."0.15.1" or []);
    deps = [
      self.full."qs"."0.6.5"
      self.full."formidable"."1.0.9"
      self.full."mime"."1.2.5"
      self.full."emitter-component"."1.0.0"
      self.full."methods"."0.0.1"
      self.full."cookiejar"."1.3.0"
      self.full."debug"."~0.7.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  full."superagent"."~0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "superagent-0.13.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/superagent/-/superagent-0.13.0.tgz";
        sha1 = "ddfbfa5c26f16790f9c5bce42815ccbde2ca36f2";
      })
    ];
    buildInputs =
      (self.nativeDeps."superagent"."~0.13.0" or []);
    deps = [
      self.full."qs"."0.5.2"
      self.full."formidable"."1.0.9"
      self.full."mime"."1.2.5"
      self.full."emitter-component"."0.0.6"
      self.full."methods"."0.0.1"
      self.full."cookiejar"."1.3.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "superagent" ];
  };
  full."supertest"."*" = lib.makeOverridable self.buildNodePackage {
    name = "supertest-0.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supertest/-/supertest-0.8.0.tgz";
        sha1 = "c8dd008358ed60175cfd4dfab0ab1af81d0dc55b";
      })
    ];
    buildInputs =
      (self.nativeDeps."supertest"."*" or []);
    deps = [
      self.full."superagent"."0.15.1"
      self.full."methods"."0.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "supertest" ];
  };
  "supertest" = self.full."supertest"."*";
  full."swig"."0.14.x" = lib.makeOverridable self.buildNodePackage {
    name = "swig-0.14.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/swig/-/swig-0.14.0.tgz";
        sha1 = "544bfb3bd837608873eed6a72c672a28cb1f1b3f";
      })
    ];
    buildInputs =
      (self.nativeDeps."swig"."0.14.x" or []);
    deps = [
      self.full."underscore".">=1.1.7"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "swig" ];
  };
  "swig" = self.full."swig"."0.14.x";
  full."sylvester".">= 0.0.12" = lib.makeOverridable self.buildNodePackage {
    name = "sylvester-0.0.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sylvester/-/sylvester-0.0.21.tgz";
        sha1 = "2987b1ce2bd2f38b0dce2a34388884bfa4400ea7";
      })
    ];
    buildInputs =
      (self.nativeDeps."sylvester".">= 0.0.12" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sylvester" ];
  };
  full."sylvester".">= 0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "sylvester-0.0.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sylvester/-/sylvester-0.0.21.tgz";
        sha1 = "2987b1ce2bd2f38b0dce2a34388884bfa4400ea7";
      })
    ];
    buildInputs =
      (self.nativeDeps."sylvester".">= 0.0.8" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sylvester" ];
  };
  full."tar"."*" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.18.tgz";
        sha1 = "b76c3b23c5e90f9e3e344462f537047c695ba635";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar"."*" or []);
    deps = [
      self.full."inherits"."2"
      self.full."block-stream"."*"
      self.full."fstream"."~0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  "tar" = self.full."tar"."*";
  full."tar"."0" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.18.tgz";
        sha1 = "b76c3b23c5e90f9e3e344462f537047c695ba635";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar"."0" or []);
    deps = [
      self.full."inherits"."2"
      self.full."block-stream"."*"
      self.full."fstream"."~0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  full."tar"."0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.17";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.17.tgz";
        sha1 = "408c8a95deb8e78a65b59b1a51a333183a32badc";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar"."0.1.17" or []);
    deps = [
      self.full."inherits"."1.x"
      self.full."block-stream"."*"
      self.full."fstream"."~0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  full."tar"."~0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.18.tgz";
        sha1 = "b76c3b23c5e90f9e3e344462f537047c695ba635";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar"."~0.1.17" or []);
    deps = [
      self.full."inherits"."2"
      self.full."block-stream"."*"
      self.full."fstream"."~0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  full."tar"."~0.1.18" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.18";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.18.tgz";
        sha1 = "b76c3b23c5e90f9e3e344462f537047c695ba635";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar"."~0.1.18" or []);
    deps = [
      self.full."inherits"."2"
      self.full."block-stream"."*"
      self.full."fstream"."~0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  full."temp"."*" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.6.0.tgz";
        sha1 = "6b13df5cddf370f2e3a606ca40f202c419173f07";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp"."*" or []);
    deps = [
      self.full."rimraf"."~2.1.4"
      self.full."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  "temp" = self.full."temp"."*";
  full."temp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.6.0.tgz";
        sha1 = "6b13df5cddf370f2e3a606ca40f202c419173f07";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp"."0.6.0" or []);
    deps = [
      self.full."rimraf"."~2.1.4"
      self.full."osenv"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  full."text-table"."~0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "text-table-0.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/text-table/-/text-table-0.1.1.tgz";
        sha1 = "9aa4347a39b6950cd24190264576f62db6e52d93";
      })
    ];
    buildInputs =
      (self.nativeDeps."text-table"."~0.1.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "text-table" ];
  };
  full."throttleit"."~0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "throttleit-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/throttleit/-/throttleit-0.0.2.tgz";
        sha1 = "cfedf88e60c00dd9697b61fdd2a8343a9b680eaf";
      })
    ];
    buildInputs =
      (self.nativeDeps."throttleit"."~0.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "throttleit" ];
  };
  full."timespan"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "timespan-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timespan/-/timespan-2.0.1.tgz";
        sha1 = "479b45875937e14d0f4be1625f2abd08d801f68a";
      })
    ];
    buildInputs =
      (self.nativeDeps."timespan"."2.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "timespan" ];
  };
  full."timezone"."*" = lib.makeOverridable self.buildNodePackage {
    name = "timezone-0.0.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timezone/-/timezone-0.0.23.tgz";
        sha1 = "5e89359e0c01c92b495c725e81ecce6ddbdb9bac";
      })
    ];
    buildInputs =
      (self.nativeDeps."timezone"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "timezone" ];
  };
  "timezone" = self.full."timezone"."*";
  full."tinycolor"."0.x" = lib.makeOverridable self.buildNodePackage {
    name = "tinycolor-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
        sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
      })
    ];
    buildInputs =
      (self.nativeDeps."tinycolor"."0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tinycolor" ];
  };
  full."tmp"."~0.0.20" = lib.makeOverridable self.buildNodePackage {
    name = "tmp-0.0.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tmp/-/tmp-0.0.21.tgz";
        sha1 = "6d263fede6570dc4d4510ffcc2efc640223b1153";
      })
    ];
    buildInputs =
      (self.nativeDeps."tmp"."~0.0.20" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tmp" ];
  };
  full."transformers"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "transformers-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/transformers/-/transformers-2.1.0.tgz";
        sha1 = "5d23cb35561dd85dc67fb8482309b47d53cce9a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."transformers"."2.1.0" or []);
    deps = [
      self.full."promise"."~2.0"
      self.full."css"."~1.0.8"
      self.full."uglify-js"."~2.2.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "transformers" ];
  };
  full."traverse".">=0.3.0 <0.4" = lib.makeOverridable self.buildNodePackage {
    name = "traverse-0.3.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traverse/-/traverse-0.3.9.tgz";
        sha1 = "717b8f220cc0bb7b44e40514c22b2e8bbc70d8b9";
      })
    ];
    buildInputs =
      (self.nativeDeps."traverse".">=0.3.0 <0.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "traverse" ];
  };
  full."truncate"."~1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "truncate-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/truncate/-/truncate-1.0.2.tgz";
        sha1 = "3221c41f6e747f83e8613f5466c8bfb596226a66";
      })
    ];
    buildInputs =
      (self.nativeDeps."truncate"."~1.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "truncate" ];
  };
  full."tunnel-agent"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.2.0.tgz";
        sha1 = "6853c2afb1b2109e45629e492bde35f459ea69e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent"."~0.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  full."tunnel-agent"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.3.0.tgz";
        sha1 = "ad681b68f5321ad2827c4cfb1b7d5df2cfe942ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent"."~0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  full."type-detect"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "type-detect-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-detect/-/type-detect-0.1.0.tgz";
        sha1 = "81ed3ab764cd5139388b67d052eb01610edc1a57";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-detect"."0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "type-detect" ];
  };
  full."uglify-js"."1.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-1.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.2.5.tgz";
        sha1 = "b542c2c76f78efb34b200b20177634330ff702b6";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js"."1.2.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  full."uglify-js"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.0.tgz";
        sha1 = "a5f2b6b1b817fb34c16a04234328c89ba1e77137";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js"."2.4.0" or []);
    deps = [
      self.full."async"."~0.2.6"
      self.full."source-map"."~0.1.7"
      self.full."optimist"."~0.3.5"
      self.full."uglify-to-browserify"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  full."uglify-js"."~2.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.2.5.tgz";
        sha1 = "a6e02a70d839792b9780488b7b8b184c095c99c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js"."~2.2.5" or []);
    deps = [
      self.full."source-map"."~0.1.7"
      self.full."optimist"."~0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  full."uglify-js"."~2.3" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.3.6.tgz";
        sha1 = "fa0984770b428b7a9b2a8058f46355d14fef211a";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js"."~2.3" or []);
    deps = [
      self.full."async"."~0.2.6"
      self.full."source-map"."~0.1.7"
      self.full."optimist"."~0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  full."uglify-js"."~2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.0.tgz";
        sha1 = "a5f2b6b1b817fb34c16a04234328c89ba1e77137";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js"."~2.4.0" or []);
    deps = [
      self.full."async"."~0.2.6"
      self.full."source-map"."~0.1.7"
      self.full."optimist"."~0.3.5"
      self.full."uglify-to-browserify"."~1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  full."uglify-to-browserify"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-to-browserify-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.1.tgz";
        sha1 = "0e9ada5d4ca358a59a00bb33c8061e2f40ef97d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-to-browserify"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uglify-to-browserify" ];
  };
  full."uid-number"."0" = lib.makeOverridable self.buildNodePackage {
    name = "uid-number-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.3.tgz";
        sha1 = "cefb0fa138d8d8098da71a40a0d04a8327d6e1cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid-number"."0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uid-number" ];
  };
  full."uid2"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "uid2-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid2/-/uid2-0.0.2.tgz";
        sha1 = "107fb155c82c1136620797ed4c88cf2b08f6aab8";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid2"."0.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uid2" ];
  };
  full."underscore"."*" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  "underscore" = self.full."underscore"."*";
  full."underscore"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."1.4.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore"."1.4.x" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."1.4.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore".">=1.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore".">=1.1.7" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore".">=1.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore".">=1.4.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore"."~1.4" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."~1.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore"."~1.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."~1.4.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore"."~1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."~1.4.4" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore"."~1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore"."~1.5.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  full."underscore.string"."~2.2.0rc" = lib.makeOverridable self.buildNodePackage {
    name = "underscore.string-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.2.1.tgz";
        sha1 = "d7c0fa2af5d5a1a67f4253daee98132e733f0f19";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string"."~2.2.0rc" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  full."underscore.string"."~2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "underscore.string-2.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz";
        sha1 = "71c08bf6b428b1133f37e78fa3a21c82f7329b0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string"."~2.3.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  full."ungit"."*" = lib.makeOverridable self.buildNodePackage {
    name = "ungit-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ungit/-/ungit-0.2.1.tgz";
        sha1 = "1aa4af1cbe881e6200fbd1726fc66341c3595f01";
      })
    ];
    buildInputs =
      (self.nativeDeps."ungit"."*" or []);
    deps = [
      self.full."express"."3.2.6"
      self.full."superagent"."0.14.7"
      self.full."underscore"."1.4.4"
      self.full."temp"."0.6.0"
      self.full."socket.io"."0.9.16"
      self.full."moment"."2.0.0"
      self.full."async"."0.2.9"
      self.full."ssh2"."0.2.8"
      self.full."rc"."0.3.0"
      self.full."uuid"."1.4.1"
      self.full."winston"."0.7.1"
      self.full."passport"."0.1.17"
      self.full."passport-local"."0.1.6"
      self.full."npm"."1.3.1"
      self.full."semver"."2.0.8"
      self.full."forever-monitor"."1.1.0"
      self.full."open"."0.0.4"
      self.full."optimist"."0.6.0"
      self.full."crossroads"."~0.12.0"
      self.full."signals"."~1.0.0"
      self.full."hasher"."~1.1.4"
      self.full."blueimp-md5"."~1.0.3"
      self.full."color"."~0.4.4"
      self.full."keen.io"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ungit" ];
  };
  "ungit" = self.full."ungit"."*";
  full."unzip"."~0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "unzip-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/unzip/-/unzip-0.1.9.tgz";
        sha1 = "12ac4d05c0a19fc4546df4c50ae0a7f4706a9424";
      })
    ];
    buildInputs =
      (self.nativeDeps."unzip"."~0.1.7" or []);
    deps = [
      self.full."fstream"."~0.1.21"
      self.full."pullstream"."~0.4.0"
      self.full."binary"."~0.3.0"
      self.full."readable-stream"."~1.0.0"
      self.full."setimmediate"."~1.0.1"
      self.full."match-stream"."~0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "unzip" ];
  };
  full."update-notifier"."~0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "update-notifier-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.1.6.tgz";
        sha1 = "c814e7eabaadaba789f75c3f652366db8efec471";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier"."~0.1.3" or []);
    deps = [
      self.full."request"."~2.22.0"
      self.full."configstore"."~0.1.0"
      self.full."semver"."~2.0.0"
      self.full."chalk"."~0.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  full."useragent"."~2.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "useragent-2.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/useragent/-/useragent-2.0.7.tgz";
        sha1 = "a44c07d157a15e13d73d4af4ece6aab70f298224";
      })
    ];
    buildInputs =
      (self.nativeDeps."useragent"."~2.0.4" or []);
    deps = [
      self.full."lru-cache"."2.2.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "useragent" ];
  };
  full."util".">= 0.4.9" = lib.makeOverridable self.buildNodePackage {
    name = "util-0.4.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/util/-/util-0.4.9.tgz";
        sha1 = "d95d5830d2328ec17dee3c80bfc50c33562b75a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."util".">= 0.4.9" or []);
    deps = [
      self.full."events.node".">= 0.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "util" ];
  };
  full."utile"."0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.1.7.tgz";
        sha1 = "55db180d54475339fd6dd9e2d14a4c0b52624b69";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile"."0.1.7" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."deep-equal"."*"
      self.full."i"."0.3.x"
      self.full."mkdirp"."0.x.x"
      self.full."ncp"."0.2.x"
      self.full."rimraf"."1.x.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  full."utile"."0.1.x" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.1.7.tgz";
        sha1 = "55db180d54475339fd6dd9e2d14a4c0b52624b69";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile"."0.1.x" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."deep-equal"."*"
      self.full."i"."0.3.x"
      self.full."mkdirp"."0.x.x"
      self.full."ncp"."0.2.x"
      self.full."rimraf"."1.x.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  full."utile"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.2.0.tgz";
        sha1 = "91a2423ca2eb3322390e211ee3d71cf4fa193aea";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile"."0.2.x" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."deep-equal"."*"
      self.full."i"."0.3.x"
      self.full."mkdirp"."0.x.x"
      self.full."ncp"."0.2.x"
      self.full."rimraf"."2.x.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  full."utile"."~0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "utile-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utile/-/utile-0.1.7.tgz";
        sha1 = "55db180d54475339fd6dd9e2d14a4c0b52624b69";
      })
    ];
    buildInputs =
      (self.nativeDeps."utile"."~0.1.7" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."deep-equal"."*"
      self.full."i"."0.3.x"
      self.full."mkdirp"."0.x.x"
      self.full."ncp"."0.2.x"
      self.full."rimraf"."1.x.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utile" ];
  };
  full."uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "uuid-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uuid/-/uuid-1.4.1.tgz";
        sha1 = "a337828580d426e375b8ee11bd2bf901a596e0b8";
      })
    ];
    buildInputs =
      (self.nativeDeps."uuid"."1.4.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "uuid" ];
  };
  full."validator"."0.4.x" = lib.makeOverridable self.buildNodePackage {
    name = "validator-0.4.28";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/validator/-/validator-0.4.28.tgz";
        sha1 = "311d439ae6cf3fbe6f85da6ebaccd0c7007986f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."validator"."0.4.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "validator" ];
  };
  full."vargs"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "vargs-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vargs/-/vargs-0.1.0.tgz";
        sha1 = "6b6184da6520cc3204ce1b407cac26d92609ebff";
      })
    ];
    buildInputs =
      (self.nativeDeps."vargs"."~0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vargs" ];
  };
  full."vasync"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "vasync-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vasync/-/vasync-1.3.3.tgz";
        sha1 = "84917680717020b67e043902e63bc143174c8728";
      })
    ];
    buildInputs =
      (self.nativeDeps."vasync"."1.3.3" or []);
    deps = [
      self.full."jsprim"."0.3.0"
      self.full."verror"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vasync" ];
  };
  full."verror"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "verror-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.1.0.tgz";
        sha1 = "2a4b4eb14a207051e75a6f94ee51315bf173a1b0";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror"."1.1.0" or []);
    deps = [
      self.full."extsprintf"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  full."verror"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "verror-1.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.3.3.tgz";
        sha1 = "8a6a4ac3a8c774b6f687fece49bdffd78552e2cd";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror"."1.3.3" or []);
    deps = [
      self.full."extsprintf"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  full."verror"."1.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "verror-1.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
        sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
      })
    ];
    buildInputs =
      (self.nativeDeps."verror"."1.3.6" or []);
    deps = [
      self.full."extsprintf"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "verror" ];
  };
  full."view-helpers"."*" = lib.makeOverridable self.buildNodePackage {
    name = "view-helpers-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/view-helpers/-/view-helpers-0.1.3.tgz";
        sha1 = "97b061548a753eff5b432e6c1598cb10417bff02";
      })
    ];
    buildInputs =
      (self.nativeDeps."view-helpers"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "view-helpers" ];
  };
  "view-helpers" = self.full."view-helpers"."*";
  full."vows".">=0.5.13" = lib.makeOverridable self.buildNodePackage {
    name = "vows-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vows/-/vows-0.7.0.tgz";
        sha1 = "dd0065f110ba0c0a6d63e844851c3208176d5867";
      })
    ];
    buildInputs =
      (self.nativeDeps."vows".">=0.5.13" or []);
    deps = [
      self.full."eyes".">=0.1.6"
      self.full."diff"."~1.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vows" ];
  };
  full."walk"."*" = lib.makeOverridable self.buildNodePackage {
    name = "walk-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.2.1.tgz";
        sha1 = "5ada1f8e49e47d4b7445d8be7a2e1e631ab43016";
      })
    ];
    buildInputs =
      (self.nativeDeps."walk"."*" or []);
    deps = [
      self.full."forEachAsync"."~2.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
  };
  "walk" = self.full."walk"."*";
  full."watch"."0.5.x" = lib.makeOverridable self.buildNodePackage {
    name = "watch-0.5.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.5.1.tgz";
        sha1 = "50ea3a056358c98073e0bca59956de4afd20b213";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch"."0.5.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "watch" ];
  };
  full."watch"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "watch-0.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/watch/-/watch-0.7.0.tgz";
        sha1 = "3d6e715648af867ec7f1149302b526479e726856";
      })
    ];
    buildInputs =
      (self.nativeDeps."watch"."0.7.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "watch" ];
  };
  full."wd"."~0.0.32" = lib.makeOverridable self.buildNodePackage {
    name = "wd-0.0.34";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wd/-/wd-0.0.34.tgz";
        sha1 = "c8d00ccdbb2862f914b7bd5935330a53cfa88562";
      })
    ];
    buildInputs =
      (self.nativeDeps."wd"."~0.0.32" or []);
    deps = [
      self.full."async"."0.2.x"
      self.full."underscore"."1.4.x"
      self.full."vargs"."~0.1.0"
      self.full."q"."0.9.x"
      self.full."request"."~2.21.0"
      self.full."archiver"."~0.4.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wd" ];
  };
  full."webdrvr"."*" = lib.makeOverridable self.buildNodePackage {
    name = "webdrvr-2.35.0-6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/webdrvr/-/webdrvr-2.35.0-6.tgz";
        sha1 = "1dffadb2960c82c7b9baba6512cd6f35f6e8d706";
      })
    ];
    buildInputs =
      (self.nativeDeps."webdrvr"."*" or []);
    deps = [
      self.full."adm-zip"."~0.4.3"
      self.full."kew"."~0.1.7"
      self.full."mkdirp"."~0.3.5"
      self.full."npmconf"."~0.1.2"
      self.full."phantomjs"."~1.9.1-2"
      self.full."tmp"."~0.0.20"
      self.full."follow-redirects"."0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "webdrvr" ];
  };
  "webdrvr" = self.full."webdrvr"."*";
  full."websocket-driver".">=0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "websocket-driver-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.3.0.tgz";
        sha1 = "497b258c508b987249ab9b6f79f0c21dd3467c64";
      })
    ];
    buildInputs =
      (self.nativeDeps."websocket-driver".">=0.3.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "websocket-driver" ];
  };
  full."when"."~2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "when-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/when/-/when-2.2.1.tgz";
        sha1 = "b1def994017350b8087f6e9a7596ab2833bdc712";
      })
    ];
    buildInputs =
      (self.nativeDeps."when"."~2.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "when" ];
  };
  full."which"."1" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.5.tgz";
        sha1 = "5630d6819dda692f1464462e7956cb42c0842739";
      })
    ];
    buildInputs =
      (self.nativeDeps."which"."1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "which" ];
  };
  full."which"."1.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.5.tgz";
        sha1 = "5630d6819dda692f1464462e7956cb42c0842739";
      })
    ];
    buildInputs =
      (self.nativeDeps."which"."1.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "which" ];
  };
  full."which"."~1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.5.tgz";
        sha1 = "5630d6819dda692f1464462e7956cb42c0842739";
      })
    ];
    buildInputs =
      (self.nativeDeps."which"."~1.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "which" ];
  };
  full."winser"."=0.0.11" = lib.makeOverridable self.buildNodePackage {
    name = "winser-0.0.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winser/-/winser-0.0.11.tgz";
        sha1 = "38474086a89ac72f90f9c6762e23375d12046c7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."winser"."=0.0.11" or []);
    deps = [
      self.full."sequence"."*"
      self.full."commander"."*"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winser" ];
  };
  full."winston"."*" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.7.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.2.tgz";
        sha1 = "2570ae1aa1d8a9401e8d5a88362e1cf936550ceb";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston"."*" or []);
    deps = [
      self.full."async"."0.2.x"
      self.full."colors"."0.6.x"
      self.full."cycle"."1.0.x"
      self.full."eyes"."0.1.x"
      self.full."pkginfo"."0.3.x"
      self.full."request"."2.16.x"
      self.full."stack-trace"."0.0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  "winston" = self.full."winston"."*";
  full."winston"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.6.2.tgz";
        sha1 = "4144fe2586cdc19a612bf8c035590132c9064bd2";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston"."0.6.2" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."colors"."0.x.x"
      self.full."cycle"."1.0.x"
      self.full."eyes"."0.1.x"
      self.full."pkginfo"."0.2.x"
      self.full."request"."2.9.x"
      self.full."stack-trace"."0.0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  full."winston"."0.6.x" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.6.2.tgz";
        sha1 = "4144fe2586cdc19a612bf8c035590132c9064bd2";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston"."0.6.x" or []);
    deps = [
      self.full."async"."0.1.x"
      self.full."colors"."0.x.x"
      self.full."cycle"."1.0.x"
      self.full."eyes"."0.1.x"
      self.full."pkginfo"."0.2.x"
      self.full."request"."2.9.x"
      self.full."stack-trace"."0.0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  full."winston"."0.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.7.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.1.tgz";
        sha1 = "e291ab24eddbf79ea40ff532619277a0d30b0eb3";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston"."0.7.1" or []);
    deps = [
      self.full."async"."0.2.x"
      self.full."colors"."0.6.x"
      self.full."cycle"."1.0.x"
      self.full."eyes"."0.1.x"
      self.full."pkginfo"."0.3.x"
      self.full."request"."2.16.x"
      self.full."stack-trace"."0.0.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  full."with"."~1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "with-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/with/-/with-1.1.1.tgz";
        sha1 = "66bd6664deb318b2482dd0424ccdebe822434ac0";
      })
    ];
    buildInputs =
      (self.nativeDeps."with"."~1.1.0" or []);
    deps = [
      self.full."uglify-js"."2.4.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "with" ];
  };
  full."wordwrap"."0.0.x" = lib.makeOverridable self.buildNodePackage {
    name = "wordwrap-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap"."0.0.x" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  full."wordwrap".">=0.0.1 <0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "wordwrap-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap".">=0.0.1 <0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  full."wordwrap"."~0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "wordwrap-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap"."~0.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  full."ws"."0.4.x" = lib.makeOverridable self.buildNodePackage {
    name = "ws-0.4.31";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ws/-/ws-0.4.31.tgz";
        sha1 = "5a4849e7a9ccd1ed5a81aeb4847c9fedf3122927";
      })
    ];
    buildInputs =
      (self.nativeDeps."ws"."0.4.x" or []);
    deps = [
      self.full."commander"."~0.6.1"
      self.full."nan"."~0.3.0"
      self.full."tinycolor"."0.x"
      self.full."options".">=0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ws" ];
  };
  full."wu"."*" = lib.makeOverridable self.buildNodePackage {
    name = "wu-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wu/-/wu-0.1.8.tgz";
        sha1 = "619bcdf64974a487894a25755ae095c5208b4a22";
      })
    ];
    buildInputs =
      (self.nativeDeps."wu"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wu" ];
  };
  "wu" = self.full."wu"."*";
  full."x509"."*" = lib.makeOverridable self.buildNodePackage {
    name = "x509-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/x509/-/x509-0.0.6.tgz";
        sha1 = "b58747854ff33df7ff8f1653756bff6a32a8c838";
      })
    ];
    buildInputs =
      (self.nativeDeps."x509"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "x509" ];
  };
  "x509" = self.full."x509"."*";
  full."xml2js"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.4.tgz";
        sha1 = "9a5b577fa1e6cdf8923d5e1372f7a3188436e44d";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js"."0.2.4" or []);
    deps = [
      self.full."sax".">=0.4.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  full."xml2js"."0.2.x" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.8.tgz";
        sha1 = "9b81690931631ff09d1957549faf54f4f980b3c2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js"."0.2.x" or []);
    deps = [
      self.full."sax"."0.5.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  full."xml2js".">= 0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.8.tgz";
        sha1 = "9b81690931631ff09d1957549faf54f4f980b3c2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js".">= 0.0.1" or []);
    deps = [
      self.full."sax"."0.5.x"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  full."xmlbuilder"."*" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.2.tgz";
        sha1 = "1776d65f3fdbad470a08d8604cdeb1c4e540ff83";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder"."*" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  full."xmlbuilder"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "xmlbuilder-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.2.tgz";
        sha1 = "1776d65f3fdbad470a08d8604cdeb1c4e540ff83";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlbuilder"."0.4.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlbuilder" ];
  };
  full."xmlhttprequest"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "xmlhttprequest-1.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlhttprequest/-/xmlhttprequest-1.4.2.tgz";
        sha1 = "01453a1d9bed1e8f172f6495bbf4c8c426321500";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlhttprequest"."1.4.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xmlhttprequest" ];
  };
  full."xoauth2"."~0.1" = lib.makeOverridable self.buildNodePackage {
    name = "xoauth2-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xoauth2/-/xoauth2-0.1.8.tgz";
        sha1 = "b916ff10ecfb54320f16f24a3e975120653ab0d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xoauth2"."~0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "xoauth2" ];
  };
  full."yaml"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "yaml-0.2.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yaml/-/yaml-0.2.3.tgz";
        sha1 = "b5450e92e76ef36b5dd24e3660091ebaeef3e5c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."yaml"."0.2.3" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yaml" ];
  };
  full."ycssmin".">=1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "ycssmin-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ycssmin/-/ycssmin-1.0.1.tgz";
        sha1 = "7cdde8db78cfab00d2901c3b2301e304faf4df16";
      })
    ];
    buildInputs =
      (self.nativeDeps."ycssmin".">=1.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ycssmin" ];
  };
  full."yeoman-generator"."~0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.10.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.10.5.tgz";
        sha1 = "67b28a6c453addc785e43180236df65e2f93554a";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator"."~0.10.0" or []);
    deps = [
      self.full."cheerio"."~0.10.8"
      self.full."request"."~2.16.6"
      self.full."rimraf"."~2.1.4"
      self.full."tar"."~0.1.17"
      self.full."diff"."~1.0.4"
      self.full."mime"."~1.2.9"
      self.full."underscore.string"."~2.3.1"
      self.full."lodash"."~1.1.1"
      self.full."mkdirp"."~0.3.5"
      self.full."read"."~1.0.4"
      self.full."glob"."~3.1.21"
      self.full."nopt"."~2.1.1"
      self.full."cli-table"."~0.2.0"
      self.full."debug"."~0.7.2"
      self.full."isbinaryfile"."~0.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  full."yeoman-generator"."~0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.13.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.13.4.tgz";
        sha1 = "066798dd978026d37be6657b2672a17bc4f4ce34";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator"."~0.13.0" or []);
    deps = [
      self.full."cheerio"."~0.12.0"
      self.full."request"."~2.25.0"
      self.full."rimraf"."~2.2.0"
      self.full."tar"."~0.1.17"
      self.full."diff"."~1.0.4"
      self.full."mime"."~1.2.9"
      self.full."underscore.string"."~2.3.1"
      self.full."lodash"."~1.3.0"
      self.full."mkdirp"."~0.3.5"
      self.full."glob"."~3.2.0"
      self.full."debug"."~0.7.2"
      self.full."isbinaryfile"."~0.1.8"
      self.full."dargs"."~0.1.0"
      self.full."async"."~0.2.8"
      self.full."inquirer"."~0.3.1"
      self.full."iconv-lite"."~0.2.10"
      self.full."shelljs"."~0.1.4"
      self.full."findup-sync"."~0.1.2"
      self.full."chalk"."~0.2.0"
      self.full."text-table"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  full."yeoman-generator"."~0.13.1" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.13.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.13.4.tgz";
        sha1 = "066798dd978026d37be6657b2672a17bc4f4ce34";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator"."~0.13.1" or []);
    deps = [
      self.full."cheerio"."~0.12.0"
      self.full."request"."~2.25.0"
      self.full."rimraf"."~2.2.0"
      self.full."tar"."~0.1.17"
      self.full."diff"."~1.0.4"
      self.full."mime"."~1.2.9"
      self.full."underscore.string"."~2.3.1"
      self.full."lodash"."~1.3.0"
      self.full."mkdirp"."~0.3.5"
      self.full."glob"."~3.2.0"
      self.full."debug"."~0.7.2"
      self.full."isbinaryfile"."~0.1.8"
      self.full."dargs"."~0.1.0"
      self.full."async"."~0.2.8"
      self.full."inquirer"."~0.3.1"
      self.full."iconv-lite"."~0.2.10"
      self.full."shelljs"."~0.1.4"
      self.full."findup-sync"."~0.1.2"
      self.full."chalk"."~0.2.0"
      self.full."text-table"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  full."yeoman-generator"."~0.13.2" = lib.makeOverridable self.buildNodePackage {
    name = "yeoman-generator-0.13.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yeoman-generator/-/yeoman-generator-0.13.4.tgz";
        sha1 = "066798dd978026d37be6657b2672a17bc4f4ce34";
      })
    ];
    buildInputs =
      (self.nativeDeps."yeoman-generator"."~0.13.2" or []);
    deps = [
      self.full."cheerio"."~0.12.0"
      self.full."request"."~2.25.0"
      self.full."rimraf"."~2.2.0"
      self.full."tar"."~0.1.17"
      self.full."diff"."~1.0.4"
      self.full."mime"."~1.2.9"
      self.full."underscore.string"."~2.3.1"
      self.full."lodash"."~1.3.0"
      self.full."mkdirp"."~0.3.5"
      self.full."glob"."~3.2.0"
      self.full."debug"."~0.7.2"
      self.full."isbinaryfile"."~0.1.8"
      self.full."dargs"."~0.1.0"
      self.full."async"."~0.2.8"
      self.full."inquirer"."~0.3.1"
      self.full."iconv-lite"."~0.2.10"
      self.full."shelljs"."~0.1.4"
      self.full."findup-sync"."~0.1.2"
      self.full."chalk"."~0.2.0"
      self.full."text-table"."~0.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "yeoman-generator" ];
  };
  full."yo"."*" = lib.makeOverridable self.buildNodePackage {
    name = "yo-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yo/-/yo-1.0.4.tgz";
        sha1 = "666b5965a8e920df877d351da793f89bd1c8707a";
      })
    ];
    buildInputs =
      (self.nativeDeps."yo"."*" or []);
    deps = [
      self.full."yeoman-generator"."~0.13.2"
      self.full."nopt"."~2.1.1"
      self.full."lodash"."~1.3.1"
      self.full."update-notifier"."~0.1.3"
      self.full."insight"."~0.2.0"
      self.full."sudo-block"."~0.2.0"
      self.full."async"."~0.2.9"
      self.full."open"."0.0.4"
      self.full."chalk"."~0.2.0"
    ];
    peerDependencies = [
      self.full."grunt-cli"."~0.1.7"
      self.full."bower".">=0.9.0"
    ];
    passthru.names = [ "yo" ];
  };
  "yo" = self.full."yo"."*";
  full."yo".">=1.0.0-rc.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "yo-1.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yo/-/yo-1.0.4.tgz";
        sha1 = "666b5965a8e920df877d351da793f89bd1c8707a";
      })
    ];
    buildInputs =
      (self.nativeDeps."yo".">=1.0.0-rc.1.1" or []);
    deps = [
      self.full."yeoman-generator"."~0.13.2"
      self.full."nopt"."~2.1.1"
      self.full."lodash"."~1.3.1"
      self.full."update-notifier"."~0.1.3"
      self.full."insight"."~0.2.0"
      self.full."sudo-block"."~0.2.0"
      self.full."async"."~0.2.9"
      self.full."open"."0.0.4"
      self.full."chalk"."~0.2.0"
    ];
    peerDependencies = [
      self.full."grunt-cli"."~0.1.7"
      self.full."bower".">=0.9.0"
    ];
    passthru.names = [ "yo" ];
  };
  full."zeparser"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "zeparser-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zeparser/-/zeparser-0.0.5.tgz";
        sha1 = "03726561bc268f2e5444f54c665b7fd4a8c029e2";
      })
    ];
    buildInputs =
      (self.nativeDeps."zeparser"."0.0.5" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "zeparser" ];
  };
  full."zlib-browserify"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "zlib-browserify-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/zlib-browserify/-/zlib-browserify-0.0.1.tgz";
        sha1 = "4fa6a45d00dbc15f318a4afa1d9afc0258e176cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."zlib-browserify"."0.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "zlib-browserify" ];
  };
}
