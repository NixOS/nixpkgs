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
  by-spec."amdefine".">=0.0.4" =
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
  by-spec."assert"."~1.1.0" =
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
  by-spec."async"."~0.2.6" =
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
  by-spec."async"."~0.9.0" =
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
  by-spec."base64-js"."~0.0.4" =
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
  by-spec."bl"."~0.9.0" =
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
  by-spec."browserify"."3.24.13" =
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
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
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
  "browserify" = self.by-version."browserify"."3.24.13";
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
  by-spec."clean-css"."2.0.x" =
    self.by-version."clean-css"."2.0.8";
  by-version."clean-css"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-2.0.8";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-2.0.8.tgz";
        name = "clean-css-2.0.8.tgz";
        sha1 = "e937cdfdcc5781a00817aec4079e85b3ec157a20";
      })
    ];
    buildInputs =
      (self.nativeDeps."clean-css" or []);
    deps = {
      "commander-2.0.0" = self.by-version."commander"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "clean-css" ];
  };
  by-spec."coffee-script"."1.7.1" =
    self.by-version."coffee-script"."1.7.1";
  by-version."coffee-script"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.7.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.7.1.tgz";
        name = "coffee-script-1.7.1.tgz";
        sha1 = "62996a861780c75e6d5069d13822723b73404bfc";
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
  "coffee-script" = self.by-version."coffee-script"."1.7.1";
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
  by-spec."commander"."2.0.x" =
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
  by-spec."concat-stream"."~1.4.1" =
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
  by-spec."deep-equal"."~0.0.0" =
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
      "estraverse-1.7.0" = self.by-version."estraverse"."1.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escope" ];
  };
  by-spec."esprima"."~1.0.2" =
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
  by-spec."ieee754"."~1.1.1" =
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
  by-spec."inherits"."2.0.1" =
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
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
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
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "insert-module-globals" ];
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
  by-spec."less"."1.6.2" =
    self.by-version."less"."1.6.2";
  by-version."less"."1.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "less-1.6.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-1.6.2.tgz";
        name = "less-1.6.2.tgz";
        sha1 = "86556e6ab8f9af4d8b853db16c5f262e94fc98a0";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = {
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "request-2.47.0" = self.by-version."request"."2.47.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "clean-css-2.0.8" = self.by-version."clean-css"."2.0.8";
      "source-map-0.1.40" = self.by-version."source-map"."0.1.40";
    };
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  "less" = self.by-version."less"."1.6.2";
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
  by-spec."mime"."1.2.x" =
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
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
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
  by-spec."mkdirp"."~0.3.5" =
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
      "concat-stream-1.4.6" = self.by-version."concat-stream"."1.4.6";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "parents-0.0.2" = self.by-version."parents"."0.0.2";
      "mine-0.0.2" = self.by-version."mine"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "module-deps" ];
  };
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
  by-spec."node-uuid"."~1.4.0" =
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
  by-spec."optimist"."~0.3.5" =
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
  by-spec."qs"."~2.3.1" =
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
  by-spec."readable-stream"."~1.0.26" =
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
  by-spec."readable-stream"."~1.1.9" =
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
  by-spec."request".">=2.12.0" =
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
      "qs-2.3.2" = self.by-version."qs"."2.3.2";
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
  by-spec."resolve"."~0.6.0" =
    self.by-version."resolve"."0.6.3";
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
  by-spec."source-map"."~0.1.31" =
    self.by-version."source-map"."0.1.40";
  by-spec."source-map"."~0.1.7" =
    self.by-version."source-map"."0.1.40";
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
  by-spec."string_decoder"."~0.10.x" =
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
  by-spec."through"."~2.2.7" =
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
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.6";
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
  by-spec."uglify-js"."~2.4.0" =
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
  by-spec."util"."~0.10.1" =
    self.by-version."util"."0.10.3";
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
  by-spec."wordwrap"."~0.0.2" =
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
  by-spec."zlib-browserify"."~0.0.3" =
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
