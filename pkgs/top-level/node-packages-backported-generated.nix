{ self, fetchurl, lib }:

{
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
  full."amdefine".">=0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "amdefine-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-0.1.0.tgz";
        sha1 = "3ca9735cf1dde0edf7a4bf6641709c8024f9b227";
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
  full."bower".">=1.2.8 <2" = lib.makeOverridable self.buildNodePackage {
    name = "bower-1.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower/-/bower-1.2.8.tgz";
        sha1 = "f63c0804a267d5ffaf2fd3fd488367e73dce202f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower".">=1.2.8 <2" or []);
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
      self.full."decompress-zip"."~0.0.3"
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
      self.full."update-notifier"."~0.1.3"
      self.full."which"."~1.0.5"
      self.full."p-throttler"."~0.0.1"
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
  full."bower-endpoint-parser"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-endpoint-parser-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-endpoint-parser/-/bower-endpoint-parser-0.2.1.tgz";
        sha1 = "8c4010a2900cdab07ea5d38f0bd03e9bbccef90f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-endpoint-parser"."0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-endpoint-parser" ];
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
  full."bower-json"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "bower-json-0.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-json/-/bower-json-0.4.0.tgz";
        sha1 = "a99c3ccf416ef0590ed0ded252c760f1c6d93766";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-json"."0.4.0" or []);
    deps = [
      self.full."deep-extend"."~0.2.5"
      self.full."graceful-fs"."~2.0.0"
      self.full."intersect"."~0.0.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-json" ];
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
  full."bower-logger"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bower-logger-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.1.tgz";
        sha1 = "0c1817c48063a88d96cc3d516c55e57fff5d9ecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower-logger"."0.2.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower-logger" ];
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
    name = "bower-registry-client-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower-registry-client/-/bower-registry-client-0.1.6.tgz";
        sha1 = "c3ae74a98f24f50a373bbcb0ef443558be01d4b7";
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
  full."bower2nix".">=2 <3" = lib.makeOverridable self.buildNodePackage {
    name = "bower2nix-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bower2nix/-/bower2nix-2.0.0.tgz";
        sha1 = "27aaeb3681e2707327a7fcfef985faf19b7f7a5e";
      })
    ];
    buildInputs =
      (self.nativeDeps."bower2nix".">=2 <3" or []);
    deps = [
      self.full."temp"."0.6.0"
      self.full."fs.extra".">=1.2.1 <2"
      self.full."bower-json"."0.4.0"
      self.full."bower-endpoint-parser"."0.2.1"
      self.full."bower-logger"."0.2.1"
      self.full."bower".">=1.2.8 <2"
      self.full."argparse"."0.1.15"
      self.full."clone"."0.1.11"
      self.full."semver".">=2.2.1 <3"
      self.full."fetch-bower".">=2 <3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bower2nix" ];
  };
  "bower2nix" = self.full."bower2nix".">=2 <3";
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
  full."cardinal"."~0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "cardinal-0.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cardinal/-/cardinal-0.4.3.tgz";
        sha1 = "7b74c3d1541002bd3d5b555048206719af91d313";
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
  full."chalk"."~0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.2.1.tgz";
        sha1 = "7613e1575145b21386483f7f485aa5ffa8cbd10c";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk"."~0.2.1" or []);
    deps = [
      self.full."has-color"."~0.1.0"
      self.full."ansi-styles"."~0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
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
  full."clone"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "clone-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clone/-/clone-0.1.11.tgz";
        sha1 = "408b7d1773eb0dfbf2ddb156c1c47170c17e3a96";
      })
    ];
    buildInputs =
      (self.nativeDeps."clone"."0.1.11" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "clone" ];
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
  full."configstore"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "configstore-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/configstore/-/configstore-0.1.7.tgz";
        sha1 = "57dc701bc2a51eb804d6e1733c8abb9d82a5cede";
      })
    ];
    buildInputs =
      (self.nativeDeps."configstore"."~0.1.0" or []);
    deps = [
      self.full."lodash"."~2.4.1"
      self.full."mkdirp"."~0.3.5"
      self.full."js-yaml"."~2.1.0"
      self.full."osenv"."0.0.3"
      self.full."graceful-fs"."~2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "configstore" ];
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
  full."core-util-is"."~1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "core-util-is-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.0.tgz";
        sha1 = "740c74c400e72707b95cc75d509543f8ad7f83de";
      })
    ];
    buildInputs =
      (self.nativeDeps."core-util-is"."~1.0.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "core-util-is" ];
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
  full."debuglog"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "debuglog-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debuglog/-/debuglog-0.0.2.tgz";
        sha1 = "6c0dcf07e2c3f74524629b741668bd46c7b362eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."debuglog"."0.0.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debuglog" ];
  };
  full."decompress-zip"."~0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "decompress-zip-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decompress-zip/-/decompress-zip-0.0.3.tgz";
        sha1 = "14b174e5b6a528f0aa6c2e2157b7aa0152e7915a";
      })
    ];
    buildInputs =
      (self.nativeDeps."decompress-zip"."~0.0.3" or []);
    deps = [
      self.full."q"."~0.9.6"
      self.full."mkpath"."~0.1.0"
      self.full."binary"."~0.3.0"
      self.full."touch"."0.0.2"
      self.full."readable-stream"."~1.1.8"
      self.full."nopt"."~2.1.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "decompress-zip" ];
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
  full."fetch-bower".">=2 <3" = lib.makeOverridable self.buildNodePackage {
    name = "fetch-bower-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fetch-bower/-/fetch-bower-2.0.0.tgz";
        sha1 = "c027feb75a512001d1287bbfb3ffaafba67eb92f";
      })
    ];
    buildInputs =
      (self.nativeDeps."fetch-bower".">=2 <3" or []);
    deps = [
      self.full."bower-endpoint-parser"."0.2.1"
      self.full."bower-logger"."0.2.1"
      self.full."bower".">=1.2.8 <2"
      self.full."glob".">=3.2.7 <4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fetch-bower" ];
  };
  "fetch-bower" = self.full."fetch-bower".">=2 <3";
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
  full."fs-extra"."~0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "fs-extra-0.6.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.6.4.tgz";
        sha1 = "f46f0c75b7841f8d200b3348cd4d691d5a099d15";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-extra"."~0.6.1" or []);
    deps = [
      self.full."ncp"."~0.4.2"
      self.full."mkdirp"."0.3.x"
      self.full."jsonfile"."~1.0.1"
      self.full."rimraf"."~2.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-extra" ];
  };
  full."fs.extra".">=1.2.1 <2" = lib.makeOverridable self.buildNodePackage {
    name = "fs.extra-1.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs.extra/-/fs.extra-1.2.1.tgz";
        sha1 = "060bf20264f35e39ad247e5e9d2121a2a75a1733";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs.extra".">=1.2.1 <2" or []);
    deps = [
      self.full."mkdirp"."~0.3.5"
      self.full."fs-extra"."~0.6.1"
      self.full."walk"."~2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs.extra" ];
  };
  full."fstream"."~0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.25";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.25.tgz";
        sha1 = "deef2db7c7898357c2b37202212a9e5b36abc732";
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
  full."fstream"."~0.1.22" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.25";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.25.tgz";
        sha1 = "deef2db7c7898357c2b37202212a9e5b36abc732";
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
  full."fstream"."~0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.25";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.25.tgz";
        sha1 = "deef2db7c7898357c2b37202212a9e5b36abc732";
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
  full."glob".">=3.2.7 <4" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.7.tgz";
        sha1 = "275f39a0eee805694790924f36eac38e1db6d802";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob".">=3.2.7 <4" or []);
    deps = [
      self.full."minimatch"."~0.2.11"
      self.full."inherits"."2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  full."glob"."~3.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.7.tgz";
        sha1 = "275f39a0eee805694790924f36eac38e1db6d802";
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
  full."graceful-fs"."~2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.1.tgz";
        sha1 = "7fd6e0a4837c35d0cc15330294d9584a3898cf84";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs"."~2.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
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
    name = "has-color-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-color/-/has-color-0.1.2.tgz";
        sha1 = "c4a523038912451262c745e0a663c38d948098b4";
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
  full."inquirer"."~0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "inquirer-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inquirer/-/inquirer-0.3.5.tgz";
        sha1 = "a78be064ac9abf168147c02169a931d9a483a9f6";
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
  full."js-yaml"."~2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-2.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.1.3.tgz";
        sha1 = "0ffb5617be55525878063d7a16aee7fdd282e84c";
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
  full."jsonfile"."~1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "jsonfile-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonfile/-/jsonfile-1.0.1.tgz";
        sha1 = "ea5efe40b83690b98667614a7392fc60e842c0dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonfile"."~1.0.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsonfile" ];
  };
  full."junk"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "junk-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/junk/-/junk-0.2.2.tgz";
        sha1 = "d595eb199b37930cecd1f2c52820847e80e48ae7";
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
  full."lodash"."~2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-2.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.4.1.tgz";
        sha1 = "5b7723034dda4d262e5a46fb2c58d7cc22f71420";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash"."~2.4.1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  full."lru-cache"."2" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.0.tgz";
        sha1 = "d82388ae9c960becbea0c73bb9eb79b6c6ce9aeb";
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
  full."memoizee"."~0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "memoizee-0.2.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/memoizee/-/memoizee-0.2.6.tgz";
        sha1 = "bb45a7ad02530082f1612671dab35219cd2e0741";
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
  full."minimatch"."~0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
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
    name = "minimatch-0.2.14";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
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
  full."mkpath"."~0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkpath-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkpath/-/mkpath-0.1.0.tgz";
        sha1 = "7554a6f8d871834cc97b5462b122c4c124d6de91";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkpath"."~0.1.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkpath" ];
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
  full."ncp"."~0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.4.2.tgz";
        sha1 = "abcc6cbd3ec2ed2a729ff6e7c1fa8f01784a8574";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp"."~0.4.2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
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
  full."p-throttler"."~0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "p-throttler-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/p-throttler/-/p-throttler-0.0.1.tgz";
        sha1 = "c341e3589ec843852a035e6f88e6c1e96150029b";
      })
    ];
    buildInputs =
      (self.nativeDeps."p-throttler"."~0.0.1" or []);
    deps = [
      self.full."q"."~0.9.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "p-throttler" ];
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
  full."qs"."~0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.6.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
        sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
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
  full."readable-stream"."~1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.9.tgz";
        sha1 = "d87130fbf8f9ee9c3b4058b3c58a3e30db2fcfdd";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream"."~1.1.8" or []);
    deps = [
      self.full."core-util-is"."~1.0.0"
      self.full."debuglog"."0.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
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
  full."rimraf"."2" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.5.tgz";
        sha1 = "4e5c4f667b121afa806d0c5b58920996f9478aa0";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."2" or []);
    deps = [
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
    name = "rimraf-2.2.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.5.tgz";
        sha1 = "4e5c4f667b121afa806d0c5b58920996f9478aa0";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf"."~2.2.0" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  full."semver".">=2.2.1 <3" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.2.1.tgz";
        sha1 = "7941182b3ffcc580bff1c17942acdf7951c0d213";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver".">=2.2.1 <3" or []);
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
  full."source-map"."~0.1.7" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.31";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.31.tgz";
        sha1 = "9f704d0d69d9e138a81badf6ebb4fde33d151c61";
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
  full."tar"."~0.1.17" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.19.tgz";
        sha1 = "fe45941799e660ce1ea52d875d37481b4bf13eac";
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
  full."tmp"."~0.0.20" = lib.makeOverridable self.buildNodePackage {
    name = "tmp-0.0.23";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tmp/-/tmp-0.0.23.tgz";
        sha1 = "de874aa5e974a85f0a32cdfdbd74663cb3bd9c74";
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
  full."touch"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "touch-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/touch/-/touch-0.0.2.tgz";
        sha1 = "a65a777795e5cbbe1299499bdc42281ffb21b5f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."touch"."0.0.2" or []);
    deps = [
      self.full."nopt"."~1.0.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "touch" ];
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
  full."update-notifier"."~0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "update-notifier-0.1.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.1.7.tgz";
        sha1 = "b37fb55004835240fd2e7e360c52ccffde5219c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier"."~0.1.3" or []);
    deps = [
      self.full."request"."~2.27.0"
      self.full."configstore"."~0.1.0"
      self.full."semver"."~2.1.0"
      self.full."chalk"."~0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  full."walk"."~2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "walk-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/walk/-/walk-2.2.1.tgz";
        sha1 = "5ada1f8e49e47d4b7445d8be7a2e1e631ab43016";
      })
    ];
    buildInputs =
      (self.nativeDeps."walk"."~2.2.1" or []);
    deps = [
      self.full."forEachAsync"."~2.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "walk" ];
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
}
