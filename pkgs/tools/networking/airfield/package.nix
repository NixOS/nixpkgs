{ self, fetchurl, fetchgit ? null, lib }:

{
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
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
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
      "readable-stream-1.0.31" = self.by-version."readable-stream"."1.0.31";
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
  by-spec."connect"."2.7.1" =
    self.by-version."connect"."2.7.1";
  by-version."connect"."2.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "connect-2.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect/-/connect-2.7.1.tgz";
        name = "connect-2.7.1.tgz";
        sha1 = "b869df9acf3dd8a0af7523c7c6f1aa8b4b761daa";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect" or []);
    deps = {
      "qs-0.5.1" = self.by-version."qs"."0.5.1";
      "formidable-1.0.11" = self.by-version."formidable"."1.0.11";
      "cookie-signature-0.0.1" = self.by-version."cookie-signature"."0.0.1";
      "crc-0.2.0" = self.by-version."crc"."0.2.0";
      "cookie-0.0.5" = self.by-version."cookie"."0.0.5";
      "bytes-0.1.0" = self.by-version."bytes"."0.1.0";
      "send-0.1.0" = self.by-version."send"."0.1.0";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect" ];
  };
  by-spec."connect-redis"."*" =
    self.by-version."connect-redis"."2.1.0";
  by-version."connect-redis"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "connect-redis-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/connect-redis/-/connect-redis-2.1.0.tgz";
        name = "connect-redis-2.1.0.tgz";
        sha1 = "bc20aab9791288c605f39f572f8cbb1fa8ab7cc4";
      })
    ];
    buildInputs =
      (self.nativeDeps."connect-redis" or []);
    deps = {
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "express-session-1.8.2" = self.by-version."express-session"."1.8.2";
      "redis-0.12.1" = self.by-version."redis"."0.12.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "connect-redis" ];
  };
  "connect-redis" = self.by-version."connect-redis"."2.1.0";
  by-spec."consolidate"."*" =
    self.by-version."consolidate"."0.10.0";
  by-version."consolidate"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "consolidate-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/consolidate/-/consolidate-0.10.0.tgz";
        name = "consolidate-0.10.0.tgz";
        sha1 = "81f1a6ceba1247df9cef7a261ce527c2ce538f7a";
      })
    ];
    buildInputs =
      (self.nativeDeps."consolidate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "consolidate" ];
  };
  "consolidate" = self.by-version."consolidate"."0.10.0";
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
  by-spec."cookie-signature"."0.0.1" =
    self.by-version."cookie-signature"."0.0.1";
  by-version."cookie-signature"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-0.0.1.tgz";
        name = "cookie-signature-0.0.1.tgz";
        sha1 = "13d3603b5cf63befbf85a8801e37aa900db46985";
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
  by-spec."debug"."*" =
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
  by-spec."debug"."^1.0.4" =
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
  by-spec."debug"."~2.0.0" =
    self.by-version."debug"."2.0.0";
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
  by-spec."express"."3.0.5" =
    self.by-version."express"."3.0.5";
  by-version."express"."3.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "express-3.0.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-3.0.5.tgz";
        name = "express-3.0.5.tgz";
        sha1 = "4c6e5850e6b5e8ca2af57f21ed7097de50948b73";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "connect-2.7.1" = self.by-version."connect"."2.7.1";
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
      "mkdirp-0.3.3" = self.by-version."mkdirp"."0.3.3";
      "cookie-0.0.5" = self.by-version."cookie"."0.0.5";
      "buffer-crc32-0.1.1" = self.by-version."buffer-crc32"."0.1.1";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "methods-0.0.1" = self.by-version."methods"."0.0.1";
      "send-0.1.0" = self.by-version."send"."0.1.0";
      "cookie-signature-0.0.1" = self.by-version."cookie-signature"."0.0.1";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  "express" = self.by-version."express"."3.0.5";
  by-spec."express-session"."^1.7.6" =
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
      "combined-stream-0.0.5" = self.by-version."combined-stream"."0.0.5";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
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
  by-spec."inherits"."~2.0.1" =
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
  by-spec."mime"."~1.2.11" =
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
  by-spec."mkdirp"."0.3.3" =
    self.by-version."mkdirp"."0.3.3";
  by-version."mkdirp"."0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.3.tgz";
        name = "mkdirp-0.3.3.tgz";
        sha1 = "595e251c1370c3a68bab2136d0e348b8105adf13";
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
  by-spec."mz"."1" =
    self.by-version."mz"."1.0.1";
  by-version."mz"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "mz-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mz/-/mz-1.0.1.tgz";
        name = "mz-1.0.1.tgz";
        sha1 = "5ce1d3fe5cb3267c9c3141fb6a070f8d17f215d8";
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
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.1";
  by-version."punycode"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "punycode-1.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.3.1.tgz";
        name = "punycode-1.3.1.tgz";
        sha1 = "710afe5123c20a1530b712e3e682b9118fe8058e";
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
  by-spec."readable-stream"."~1.0.26" =
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
  by-spec."redis"."^0.12.1" =
    self.by-version."redis"."0.12.1";
  by-spec."request"."*" =
    self.by-version."request"."2.44.0";
  by-version."request"."2.44.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.44.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.44.0.tgz";
        name = "request-2.44.0.tgz";
        sha1 = "78d62454d68853cadfb07ad31f58b9ec98072ea8";
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
  "request" = self.by-version."request"."2.44.0";
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
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "mime-1.2.6" = self.by-version."mime"."1.2.6";
      "fresh-0.1.0" = self.by-version."fresh"."0.1.0";
      "range-parser-0.0.4" = self.by-version."range-parser"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
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
  by-spec."swig"."0.14.0" =
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
      "punycode-1.3.1" = self.by-version."punycode"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
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
      "mz-1.0.1" = self.by-version."mz"."1.0.1";
      "base64-url-1.0.0" = self.by-version."base64-url"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uid-safe" ];
  };
  by-spec."underscore".">=1.1.7" =
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
}
