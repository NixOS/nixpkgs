{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."accepts"."~1.2.3" =
    self.by-version."accepts"."1.2.13";
  by-version."accepts"."1.2.13" = self.buildNodePackage {
    name = "accepts-1.2.13";
    version = "1.2.13";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/accepts/-/accepts-1.2.13.tgz";
      name = "accepts-1.2.13.tgz";
      sha1 = "e5f1f3928c6d95fd96558c36ec3d9d0de4a6ecea";
    };
    deps = {
      "mime-types-2.1.6" = self.by-version."mime-types"."2.1.6";
      "negotiator-0.5.3" = self.by-version."negotiator"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = self.buildNodePackage {
    name = "async-0.2.10";
    version = "0.2.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
      name = "async-0.2.10.tgz";
      sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.2";
  by-version."async"."0.9.2" = self.buildNodePackage {
    name = "async-0.9.2";
    version = "0.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.9.2.tgz";
      name = "async-0.9.2.tgz";
      sha1 = "aea74d5e61c1f899613bf64bda66d4c78f2fd17d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."better-curry"."1.x.x" =
    self.by-version."better-curry"."1.6.0";
  by-version."better-curry"."1.6.0" = self.buildNodePackage {
    name = "better-curry-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/better-curry/-/better-curry-1.6.0.tgz";
      name = "better-curry-1.6.0.tgz";
      sha1 = "38f716b24c8cee07a262abc41c22c314e20e3869";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."binaryheap".">= 0.0.3" =
    self.by-version."binaryheap"."0.0.3";
  by-version."binaryheap"."0.0.3" = self.buildNodePackage {
    name = "binaryheap-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/binaryheap/-/binaryheap-0.0.3.tgz";
      name = "binaryheap-0.0.3.tgz";
      sha1 = "0d6136c84e9f1a5a90c0b97178c3e00df59820d6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bindings"."*" =
    self.by-version."bindings"."1.2.1";
  by-version."bindings"."1.2.1" = self.buildNodePackage {
    name = "bindings-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bindings/-/bindings-1.2.1.tgz";
      name = "bindings-1.2.1.tgz";
      sha1 = "14ad6113812d2d37d72e67b4cacb4bb726505f11";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."2.9.9" =
    self.by-version."bluebird"."2.9.9";
  by-version."bluebird"."2.9.9" = self.buildNodePackage {
    name = "bluebird-2.9.9";
    version = "2.9.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.9.tgz";
      name = "bluebird-2.9.9.tgz";
      sha1 = "61a26904d43d7f6b19dff7ed917dbc92452ad6d3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bottleneck"."1.5.x" =
    self.by-version."bottleneck"."1.5.3";
  by-version."bottleneck"."1.5.3" = self.buildNodePackage {
    name = "bottleneck-1.5.3";
    version = "1.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bottleneck/-/bottleneck-1.5.3.tgz";
      name = "bottleneck-1.5.3.tgz";
      sha1 = "55fa64920d9670087d44150404525d59f9511c20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffercursor".">= 0.0.12" =
    self.by-version."buffercursor"."0.0.12";
  by-version."buffercursor"."0.0.12" = self.buildNodePackage {
    name = "buffercursor-0.0.12";
    version = "0.0.12";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/buffercursor/-/buffercursor-0.0.12.tgz";
      name = "buffercursor-0.0.12.tgz";
      sha1 = "78a9a7f4343ae7d820a8999acc80de591e25a779";
    };
    deps = {
      "verror-1.6.0" = self.by-version."verror"."1.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffercursor".">= 0.0.5" =
    self.by-version."buffercursor"."0.0.12";
  by-spec."coffee-script"."*" =
    self.by-version."coffee-script"."1.10.0";
  by-version."coffee-script"."1.10.0" = self.buildNodePackage {
    name = "coffee-script-1.10.0";
    version = "1.10.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.10.0.tgz";
      name = "coffee-script-1.10.0.tgz";
      sha1 = "12938bcf9be1948fa006f92e0c4c9e81705108c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "coffee-script" = self.by-version."coffee-script"."1.10.0";
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = self.buildNodePackage {
    name = "colors-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
      name = "colors-0.6.2.tgz";
      sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.7";
  by-version."combined-stream"."0.0.7" = self.buildNodePackage {
    name = "combined-stream-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
      name = "combined-stream-0.0.7.tgz";
      sha1 = "0137e657baa5a7541c57ac37ac5fc07d73b4dc1f";
    };
    deps = {
      "delayed-stream-0.0.5" = self.by-version."delayed-stream"."0.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-emitter"."1.1.2" =
    self.by-version."component-emitter"."1.1.2";
  by-version."component-emitter"."1.1.2" = self.buildNodePackage {
    name = "component-emitter-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-emitter/-/component-emitter-1.1.2.tgz";
      name = "component-emitter-1.1.2.tgz";
      sha1 = "296594f2753daa63996d2af08d15a95116c9aec3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-disposition"."0.5.0" =
    self.by-version."content-disposition"."0.5.0";
  by-version."content-disposition"."0.5.0" = self.buildNodePackage {
    name = "content-disposition-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/content-disposition/-/content-disposition-0.5.0.tgz";
      name = "content-disposition-0.5.0.tgz";
      sha1 = "4284fe6ae0630874639e44e80a418c2934135e9e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie"."0.1.2" =
    self.by-version."cookie"."0.1.2";
  by-version."cookie"."0.1.2" = self.buildNodePackage {
    name = "cookie-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie/-/cookie-0.1.2.tgz";
      name = "cookie-0.1.2.tgz";
      sha1 = "72fec3d24e48a3432073d90c12642005061004b1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-signature"."1.0.5" =
    self.by-version."cookie-signature"."1.0.5";
  by-version."cookie-signature"."1.0.5" = self.buildNodePackage {
    name = "cookie-signature-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.5.tgz";
      name = "cookie-signature-1.0.5.tgz";
      sha1 = "a122e3f1503eca0f5355795b0711bb2368d450f9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookiejar"."2.0.1" =
    self.by-version."cookiejar"."2.0.1";
  by-version."cookiejar"."2.0.1" = self.buildNodePackage {
    name = "cookiejar-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookiejar/-/cookiejar-2.0.1.tgz";
      name = "cookiejar-2.0.1.tgz";
      sha1 = "3d12752f6adf68a892f332433492bd5812bb668f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = self.buildNodePackage {
    name = "core-util-is-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
      name = "core-util-is-1.0.1.tgz";
      sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."crc"."3.2.1" =
    self.by-version."crc"."3.2.1";
  by-version."crc"."3.2.1" = self.buildNodePackage {
    name = "crc-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/crc/-/crc-3.2.1.tgz";
      name = "crc-3.2.1.tgz";
      sha1 = "5d9c8fb77a245cd5eca291e5d2d005334bab0082";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = self.buildNodePackage {
    name = "cycle-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
      name = "cycle-1.0.3.tgz";
      sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."1.x.x" =
    self.by-version."debug"."1.0.4";
  by-version."debug"."1.0.4" = self.buildNodePackage {
    name = "debug-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-1.0.4.tgz";
      name = "debug-1.0.4.tgz";
      sha1 = "5b9c256bd54b6ec02283176fa8a0ede6d154cbf8";
    };
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."2" =
    self.by-version."debug"."2.2.0";
  by-version."debug"."2.2.0" = self.buildNodePackage {
    name = "debug-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-2.2.0.tgz";
      name = "debug-2.2.0.tgz";
      sha1 = "f87057e995b1a1f6ae6a4960664137bc56f039da";
    };
    deps = {
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."~2.1.1" =
    self.by-version."debug"."2.1.3";
  by-version."debug"."2.1.3" = self.buildNodePackage {
    name = "debug-2.1.3";
    version = "2.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-2.1.3.tgz";
      name = "debug-2.1.3.tgz";
      sha1 = "ce8ab1b5ee8fbee2bfa3b633cab93d366b63418e";
    };
    deps = {
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = self.buildNodePackage {
    name = "delayed-stream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
      name = "delayed-stream-0.0.5.tgz";
      sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."depd"."~1.0.0" =
    self.by-version."depd"."1.0.1";
  by-version."depd"."1.0.1" = self.buildNodePackage {
    name = "depd-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/depd/-/depd-1.0.1.tgz";
      name = "depd-1.0.1.tgz";
      sha1 = "80aec64c9d6d97e65cc2a9caa93c0aa6abf73aaa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."destroy"."1.0.3" =
    self.by-version."destroy"."1.0.3";
  by-version."destroy"."1.0.3" = self.buildNodePackage {
    name = "destroy-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
      name = "destroy-1.0.3.tgz";
      sha1 = "b433b4724e71fd8551d9885174851c5fc377e2c9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dnschain"."*" =
    self.by-version."dnschain"."0.5.3";
  by-version."dnschain"."0.5.3" = self.buildNodePackage {
    name = "dnschain-0.5.3";
    version = "0.5.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/dnschain/-/dnschain-0.5.3.tgz";
      name = "dnschain-0.5.3.tgz";
      sha1 = "9b21d9ac5e203295f372ac37df470e9f0854c470";
    };
    deps = {
      "bluebird-2.9.9" = self.by-version."bluebird"."2.9.9";
      "bottleneck-1.5.3" = self.by-version."bottleneck"."1.5.3";
      "event-stream-3.2.2" = self.by-version."event-stream"."3.2.2";
      "express-4.11.2" = self.by-version."express"."4.11.2";
      "hiredis-0.4.1" = self.by-version."hiredis"."0.4.1";
      "json-rpc2-0.8.1" = self.by-version."json-rpc2"."0.8.1";
      "lodash-3.1.0" = self.by-version."lodash"."3.1.0";
      "native-dns-0.6.1" = self.by-version."native-dns"."0.6.1";
      "native-dns-packet-0.1.1" = self.by-version."native-dns-packet"."0.1.1";
      "nconf-0.7.1" = self.by-version."nconf"."0.7.1";
      "properties-1.2.1" = self.by-version."properties"."1.2.1";
      "redis-0.12.1" = self.by-version."redis"."0.12.1";
      "string-2.0.1" = self.by-version."string"."2.0.1";
      "winston-0.8.0" = self.by-version."winston"."0.8.0";
      "superagent-0.21.0" = self.by-version."superagent"."0.21.0";
      "coffee-script-1.10.0" = self.by-version."coffee-script"."1.10.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "dnschain" = self.by-version."dnschain"."0.5.3";
  by-spec."duplexer"."~0.1.1" =
    self.by-version."duplexer"."0.1.1";
  by-version."duplexer"."0.1.1" = self.buildNodePackage {
    name = "duplexer-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz";
      name = "duplexer-0.1.1.tgz";
      sha1 = "ace6ff808c1ce66b57d1ebf97977acb02334cfc1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ee-first"."1.1.0" =
    self.by-version."ee-first"."1.1.0";
  by-version."ee-first"."1.1.0" = self.buildNodePackage {
    name = "ee-first-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ee-first/-/ee-first-1.1.0.tgz";
      name = "ee-first-1.1.0.tgz";
      sha1 = "6a0d7c6221e490feefd92ec3f441c9ce8cd097f4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5class"."2.x.x" =
    self.by-version."es5class"."2.3.1";
  by-version."es5class"."2.3.1" = self.buildNodePackage {
    name = "es5class-2.3.1";
    version = "2.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/es5class/-/es5class-2.3.1.tgz";
      name = "es5class-2.3.1.tgz";
      sha1 = "42c5c18a9016bcb0db28a4d340ebb831f55d1b66";
    };
    deps = {
      "better-curry-1.6.0" = self.by-version."better-curry"."1.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-html"."1.0.1" =
    self.by-version."escape-html"."1.0.1";
  by-version."escape-html"."1.0.1" = self.buildNodePackage {
    name = "escape-html-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
      name = "escape-html-1.0.1.tgz";
      sha1 = "181a286ead397a39a92857cfb1d43052e356bff0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."etag"."~1.5.1" =
    self.by-version."etag"."1.5.1";
  by-version."etag"."1.5.1" = self.buildNodePackage {
    name = "etag-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/etag/-/etag-1.5.1.tgz";
      name = "etag-1.5.1.tgz";
      sha1 = "54c50de04ee42695562925ac566588291be7e9ea";
    };
    deps = {
      "crc-3.2.1" = self.by-version."crc"."3.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."event-stream"."3.2.2" =
    self.by-version."event-stream"."3.2.2";
  by-version."event-stream"."3.2.2" = self.buildNodePackage {
    name = "event-stream-3.2.2";
    version = "3.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/event-stream/-/event-stream-3.2.2.tgz";
      name = "event-stream-3.2.2.tgz";
      sha1 = "f79f9984c07ee3fd9b44ffb3cd0422b13e24084d";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "from-0.1.3" = self.by-version."from"."0.1.3";
      "map-stream-0.1.0" = self.by-version."map-stream"."0.1.0";
      "pause-stream-0.0.11" = self.by-version."pause-stream"."0.0.11";
      "split-0.3.3" = self.by-version."split"."0.3.3";
      "stream-combiner-0.0.4" = self.by-version."stream-combiner"."0.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eventemitter3"."0.x.x" =
    self.by-version."eventemitter3"."0.1.6";
  by-version."eventemitter3"."0.1.6" = self.buildNodePackage {
    name = "eventemitter3-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/eventemitter3/-/eventemitter3-0.1.6.tgz";
      name = "eventemitter3-0.1.6.tgz";
      sha1 = "8c7ac44b87baab55cd50c828dc38778eac052ea5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."4.11.2" =
    self.by-version."express"."4.11.2";
  by-version."express"."4.11.2" = self.buildNodePackage {
    name = "express-4.11.2";
    version = "4.11.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/express/-/express-4.11.2.tgz";
      name = "express-4.11.2.tgz";
      sha1 = "8df3d5a9ac848585f00a0777601823faecd3b148";
    };
    deps = {
      "accepts-1.2.13" = self.by-version."accepts"."1.2.13";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "finalhandler-0.3.3" = self.by-version."finalhandler"."0.3.3";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.8" = self.by-version."proxy-addr"."1.0.8";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.11.1" = self.by-version."send"."0.11.1";
      "serve-static-1.8.1" = self.by-version."serve-static"."1.8.1";
      "type-is-1.5.7" = self.by-version."type-is"."1.5.7";
      "vary-1.0.1" = self.by-version."vary"."1.0.1";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extend"."~1.2.1" =
    self.by-version."extend"."1.2.1";
  by-version."extend"."1.2.1" = self.buildNodePackage {
    name = "extend-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extend/-/extend-1.2.1.tgz";
      name = "extend-1.2.1.tgz";
      sha1 = "a0f5fd6cfc83a5fe49ef698d60ec8a624dd4576c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extsprintf"."1.2.0" =
    self.by-version."extsprintf"."1.2.0";
  by-version."extsprintf"."1.2.0" = self.buildNodePackage {
    name = "extsprintf-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.2.0.tgz";
      name = "extsprintf-1.2.0.tgz";
      sha1 = "5ad946c22f5b32ba7f8cd7426711c6e8a3fc2529";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = self.buildNodePackage {
    name = "eyes-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
      name = "eyes-0.1.8.tgz";
      sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."faye-websocket"."0.x.x" =
    self.by-version."faye-websocket"."0.10.0";
  by-version."faye-websocket"."0.10.0" = self.buildNodePackage {
    name = "faye-websocket-0.10.0";
    version = "0.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.10.0.tgz";
      name = "faye-websocket-0.10.0.tgz";
      sha1 = "4e492f8d04dfb6f89003507f6edbf2d501e7c6f4";
    };
    deps = {
      "websocket-driver-0.6.2" = self.by-version."websocket-driver"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."finalhandler"."0.3.3" =
    self.by-version."finalhandler"."0.3.3";
  by-version."finalhandler"."0.3.3" = self.buildNodePackage {
    name = "finalhandler-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.3.3.tgz";
      name = "finalhandler-0.3.3.tgz";
      sha1 = "b1a09aa1e6a607b3541669b09bcb727f460cd426";
    };
    deps = {
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."0.1.3" =
    self.by-version."form-data"."0.1.3";
  by-version."form-data"."0.1.3" = self.buildNodePackage {
    name = "form-data-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.1.3.tgz";
      name = "form-data-0.1.3.tgz";
      sha1 = "4ee4346e6eb5362e8344a02075bd8dbd8c7373ea";
    };
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.2" = self.by-version."async"."0.9.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."formidable"."1.0.14" =
    self.by-version."formidable"."1.0.14";
  by-version."formidable"."1.0.14" = self.buildNodePackage {
    name = "formidable-1.0.14";
    version = "1.0.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/formidable/-/formidable-1.0.14.tgz";
      name = "formidable-1.0.14.tgz";
      sha1 = "2b3f4c411cbb5fdd695c44843e2a23514a43231a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forwarded"."~0.1.0" =
    self.by-version."forwarded"."0.1.0";
  by-version."forwarded"."0.1.0" = self.buildNodePackage {
    name = "forwarded-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
      name = "forwarded-0.1.0.tgz";
      sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fresh"."0.2.4" =
    self.by-version."fresh"."0.2.4";
  by-version."fresh"."0.2.4" = self.buildNodePackage {
    name = "fresh-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fresh/-/fresh-0.2.4.tgz";
      name = "fresh-0.2.4.tgz";
      sha1 = "3582499206c9723714190edd74b4604feb4a614c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."from"."~0" =
    self.by-version."from"."0.1.3";
  by-version."from"."0.1.3" = self.buildNodePackage {
    name = "from-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/from/-/from-0.1.3.tgz";
      name = "from-0.1.3.tgz";
      sha1 = "ef63ac2062ac32acf7862e0d40b44b896f22f3bc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hiredis"."0.4.1" =
    self.by-version."hiredis"."0.4.1";
  by-version."hiredis"."0.4.1" = self.buildNodePackage {
    name = "hiredis-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hiredis/-/hiredis-0.4.1.tgz";
      name = "hiredis-0.4.1.tgz";
      sha1 = "aab4dcfd0fc4cbdb219d268005f2335a3c639e8f";
    };
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-2.0.8" = self.by-version."nan"."2.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = self.buildNodePackage {
    name = "inherits-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
      name = "inherits-2.0.1.tgz";
      sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ini"."1.x.x" =
    self.by-version."ini"."1.3.4";
  by-version."ini"."1.3.4" = self.buildNodePackage {
    name = "ini-1.3.4";
    version = "1.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ini/-/ini-1.3.4.tgz";
      name = "ini-1.3.4.tgz";
      sha1 = "0537cb79daf59b59a1a517dff706c86ec039162e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ipaddr.js"."1.0.1" =
    self.by-version."ipaddr.js"."1.0.1";
  by-version."ipaddr.js"."1.0.1" = self.buildNodePackage {
    name = "ipaddr.js-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.0.1.tgz";
      name = "ipaddr.js-1.0.1.tgz";
      sha1 = "5f38801dc73e0400fc7076386f6ed5215fbd8f95";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ipaddr.js".">= 0.1.1" =
    self.by-version."ipaddr.js"."1.0.3";
  by-version."ipaddr.js"."1.0.3" = self.buildNodePackage {
    name = "ipaddr.js-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.0.3.tgz";
      name = "ipaddr.js-1.0.3.tgz";
      sha1 = "2a9df7be73ea92aadb0d7f377497decd8e6d01bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = self.buildNodePackage {
    name = "isarray-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
      name = "isarray-0.0.1.tgz";
      sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-rpc2"."0.8.1" =
    self.by-version."json-rpc2"."0.8.1";
  by-version."json-rpc2"."0.8.1" = self.buildNodePackage {
    name = "json-rpc2-0.8.1";
    version = "0.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-rpc2/-/json-rpc2-0.8.1.tgz";
      name = "json-rpc2-0.8.1.tgz";
      sha1 = "efe8c9834605b556c488d1ed7bcf24ee381eeeb2";
    };
    deps = {
      "jsonparse-0.0.6" = self.by-version."jsonparse"."0.0.6";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "es5class-2.3.1" = self.by-version."es5class"."2.3.1";
      "faye-websocket-0.10.0" = self.by-version."faye-websocket"."0.10.0";
      "eventemitter3-0.1.6" = self.by-version."eventemitter3"."0.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonparse"."0.x.x" =
    self.by-version."jsonparse"."0.0.6";
  by-version."jsonparse"."0.0.6" = self.buildNodePackage {
    name = "jsonparse-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonparse/-/jsonparse-0.0.6.tgz";
      name = "jsonparse-0.0.6.tgz";
      sha1 = "ab599f19324d4ae178fa21a930192ab11ab61a4e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."2.x.x" =
    self.by-version."lodash"."2.4.2";
  by-version."lodash"."2.4.2" = self.buildNodePackage {
    name = "lodash-2.4.2";
    version = "2.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-2.4.2.tgz";
      name = "lodash-2.4.2.tgz";
      sha1 = "fadd834b9683073da179b3eae6d9c0d15053f73e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."3.1.0" =
    self.by-version."lodash"."3.1.0";
  by-version."lodash"."3.1.0" = self.buildNodePackage {
    name = "lodash-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-3.1.0.tgz";
      name = "lodash-3.1.0.tgz";
      sha1 = "d41b8b33530cb3be088853208ad30092d2c27961";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."map-stream"."~0.1.0" =
    self.by-version."map-stream"."0.1.0";
  by-version."map-stream"."0.1.0" = self.buildNodePackage {
    name = "map-stream-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/map-stream/-/map-stream-0.1.0.tgz";
      name = "map-stream-0.1.0.tgz";
      sha1 = "e56aa94c4c8055a16404a0674b78f215f7c8e194";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."media-typer"."0.3.0" =
    self.by-version."media-typer"."0.3.0";
  by-version."media-typer"."0.3.0" = self.buildNodePackage {
    name = "media-typer-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
      name = "media-typer-0.3.0.tgz";
      sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."merge-descriptors"."0.0.2" =
    self.by-version."merge-descriptors"."0.0.2";
  by-version."merge-descriptors"."0.0.2" = self.buildNodePackage {
    name = "merge-descriptors-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-0.0.2.tgz";
      name = "merge-descriptors-0.0.2.tgz";
      sha1 = "c36a52a781437513c57275f39dd9d317514ac8c7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."1.0.1" =
    self.by-version."methods"."1.0.1";
  by-version."methods"."1.0.1" = self.buildNodePackage {
    name = "methods-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/methods/-/methods-1.0.1.tgz";
      name = "methods-1.0.1.tgz";
      sha1 = "75bc91943dffd7da037cf3eeb0ed73a0037cd14b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."~1.1.1" =
    self.by-version."methods"."1.1.1";
  by-version."methods"."1.1.1" = self.buildNodePackage {
    name = "methods-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/methods/-/methods-1.1.1.tgz";
      name = "methods-1.1.1.tgz";
      sha1 = "17ea6366066d00c58e375b8ec7dfd0453c89822a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."1.2.11" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = self.buildNodePackage {
    name = "mime-1.2.11";
    version = "1.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
      name = "mime-1.2.11.tgz";
      sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-spec."mime-db"."~1.12.0" =
    self.by-version."mime-db"."1.12.0";
  by-version."mime-db"."1.12.0" = self.buildNodePackage {
    name = "mime-db-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.12.0.tgz";
      name = "mime-db-1.12.0.tgz";
      sha1 = "3d0c63180f458eb10d325aaa37d7c58ae312e9d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.18.0" =
    self.by-version."mime-db"."1.18.0";
  by-version."mime-db"."1.18.0" = self.buildNodePackage {
    name = "mime-db-1.18.0";
    version = "1.18.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.18.0.tgz";
      name = "mime-db-1.18.0.tgz";
      sha1 = "5317e28224c08af1d484f60973dd386ba8f389e0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.9" =
    self.by-version."mime-types"."2.0.14";
  by-version."mime-types"."2.0.14" = self.buildNodePackage {
    name = "mime-types-2.0.14";
    version = "2.0.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.14.tgz";
      name = "mime-types-2.0.14.tgz";
      sha1 = "310e159db23e077f8bb22b748dabfa4957140aa6";
    };
    deps = {
      "mime-db-1.12.0" = self.by-version."mime-db"."1.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.1.6" =
    self.by-version."mime-types"."2.1.6";
  by-version."mime-types"."2.1.6" = self.buildNodePackage {
    name = "mime-types-2.1.6";
    version = "2.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.6.tgz";
      name = "mime-types-2.1.6.tgz";
      sha1 = "949f8788411864ddc70948a0f21c43f29d25667c";
    };
    deps = {
      "mime-db-1.18.0" = self.by-version."mime-db"."1.18.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = self.buildNodePackage {
    name = "minimist-0.0.10";
    version = "0.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
      name = "minimist-0.0.10.tgz";
      sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.6.2" =
    self.by-version."ms"."0.6.2";
  by-version."ms"."0.6.2" = self.buildNodePackage {
    name = "ms-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms/-/ms-0.6.2.tgz";
      name = "ms-0.6.2.tgz";
      sha1 = "d89c2124c6fdc1353d65a8b77bf1aac4b193708c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.7.0" =
    self.by-version."ms"."0.7.0";
  by-version."ms"."0.7.0" = self.buildNodePackage {
    name = "ms-0.7.0";
    version = "0.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms/-/ms-0.7.0.tgz";
      name = "ms-0.7.0.tgz";
      sha1 = "865be94c2e7397ad8a57da6a633a6e2f30798b83";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.7.1" =
    self.by-version."ms"."0.7.1";
  by-version."ms"."0.7.1" = self.buildNodePackage {
    name = "ms-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms/-/ms-0.7.1.tgz";
      name = "ms-0.7.1.tgz";
      sha1 = "9cd13c03adbff25b65effde7ce864ee952017098";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."^2.0.5" =
    self.by-version."nan"."2.0.8";
  by-version."nan"."2.0.8" = self.buildNodePackage {
    name = "nan-2.0.8";
    version = "2.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-2.0.8.tgz";
      name = "nan-2.0.8.tgz";
      sha1 = "c15fd99dd4cc323d1c2f94ac426313680e606392";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."native-dns"."git+https://github.com/okTurtles/node-dns.git#08433ec98f517eed3c6d5e47bdf62603539cd402" =
    self.by-version."native-dns"."0.6.1";
  by-version."native-dns"."0.6.1" = self.buildNodePackage {
    name = "native-dns-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchgit {
      url = "https://github.com/okTurtles/node-dns.git";
      rev = "08433ec98f517eed3c6d5e47bdf62603539cd402";
      sha256 = "9c3faf4d39fda7bb6dd52a82036625f37ed442d5e948d295acb2f055dd367080";
    };
    deps = {
      "ipaddr.js-1.0.3" = self.by-version."ipaddr.js"."1.0.3";
      "native-dns-cache-0.0.2" = self.by-version."native-dns-cache"."0.0.2";
      "native-dns-packet-0.0.4" = self.by-version."native-dns-packet"."0.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."native-dns-cache"."git+https://github.com/okTurtles/native-dns-cache.git#8714196bb9223cc9a4064a4fddf9e82ec50b7d4d" =
    self.by-version."native-dns-cache"."0.0.2";
  by-version."native-dns-cache"."0.0.2" = self.buildNodePackage {
    name = "native-dns-cache-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchgit {
      url = "https://github.com/okTurtles/native-dns-cache.git";
      rev = "8714196bb9223cc9a4064a4fddf9e82ec50b7d4d";
      sha256 = "3f06b2577afc3c1e428533baae3c51bad44a2e1e02fca147a1303943c214f841";
    };
    deps = {
      "binaryheap-0.0.3" = self.by-version."binaryheap"."0.0.3";
      "native-dns-packet-0.0.3" = self.by-version."native-dns-packet"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."native-dns-packet"."0.1.1" =
    self.by-version."native-dns-packet"."0.1.1";
  by-version."native-dns-packet"."0.1.1" = self.buildNodePackage {
    name = "native-dns-packet-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/native-dns-packet/-/native-dns-packet-0.1.1.tgz";
      name = "native-dns-packet-0.1.1.tgz";
      sha1 = "97da90570b8438a00194701ce24d011fd3cc109a";
    };
    deps = {
      "buffercursor-0.0.12" = self.by-version."buffercursor"."0.0.12";
      "ipaddr.js-1.0.3" = self.by-version."ipaddr.js"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."native-dns-packet"."git+https://github.com/okTurtles/native-dns-packet.git#307e77a47ebba57a5ae9118a284e916e5ebb305a" =
    self.by-version."native-dns-packet"."0.0.3";
  by-version."native-dns-packet"."0.0.3" = self.buildNodePackage {
    name = "native-dns-packet-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchgit {
      url = "https://github.com/okTurtles/native-dns-packet.git";
      rev = "307e77a47ebba57a5ae9118a284e916e5ebb305a";
      sha256 = "3ab023906deb8ee86bcb34c3e67e03cebeed1ba2dcb0b1d561c362ca995b0739";
    };
    deps = {
      "buffercursor-0.0.12" = self.by-version."buffercursor"."0.0.12";
      "ipaddr.js-1.0.3" = self.by-version."ipaddr.js"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."native-dns-packet"."git+https://github.com/okTurtles/native-dns-packet.git#8bf2714c318cfe7d31bca2006385882ccbf503e4" =
    self.by-version."native-dns-packet"."0.0.4";
  by-version."native-dns-packet"."0.0.4" = self.buildNodePackage {
    name = "native-dns-packet-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchgit {
      url = "https://github.com/okTurtles/native-dns-packet.git";
      rev = "8bf2714c318cfe7d31bca2006385882ccbf503e4";
      sha256 = "2a5951696b4e514ab5dee36e4e5394781656a8e94c6aacba83b03f7e647f8df3";
    };
    deps = {
      "buffercursor-0.0.12" = self.by-version."buffercursor"."0.0.12";
      "ipaddr.js-1.0.3" = self.by-version."ipaddr.js"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nconf"."0.7.1" =
    self.by-version."nconf"."0.7.1";
  by-version."nconf"."0.7.1" = self.buildNodePackage {
    name = "nconf-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nconf/-/nconf-0.7.1.tgz";
      name = "nconf-0.7.1.tgz";
      sha1 = "ee4b561dd979a3c58db122e38f196d49d61aeb5b";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."negotiator"."0.5.3" =
    self.by-version."negotiator"."0.5.3";
  by-version."negotiator"."0.5.3" = self.buildNodePackage {
    name = "negotiator-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/negotiator/-/negotiator-0.5.3.tgz";
      name = "negotiator-0.5.3.tgz";
      sha1 = "269d5c476810ec92edbe7b6c2f28316384f9a7e8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.2.0" =
    self.by-version."on-finished"."2.2.1";
  by-version."on-finished"."2.2.1" = self.buildNodePackage {
    name = "on-finished-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/on-finished/-/on-finished-2.2.1.tgz";
      name = "on-finished-2.2.1.tgz";
      sha1 = "5c85c1cc36299f78029653f667f27b6b99ebc029";
    };
    deps = {
      "ee-first-1.1.0" = self.by-version."ee-first"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."~0.6.0" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = self.buildNodePackage {
    name = "optimist-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
      name = "optimist-0.6.1.tgz";
      sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
    };
    deps = {
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseurl"."~1.3.0" =
    self.by-version."parseurl"."1.3.0";
  by-version."parseurl"."1.3.0" = self.buildNodePackage {
    name = "parseurl-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parseurl/-/parseurl-1.3.0.tgz";
      name = "parseurl-1.3.0.tgz";
      sha1 = "b58046db4223e145afa76009e61bac87cc2281b3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-to-regexp"."0.1.3" =
    self.by-version."path-to-regexp"."0.1.3";
  by-version."path-to-regexp"."0.1.3" = self.buildNodePackage {
    name = "path-to-regexp-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.3.tgz";
      name = "path-to-regexp-0.1.3.tgz";
      sha1 = "21b9ab82274279de25b156ea08fd12ca51b8aecb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pause-stream"."0.0.11" =
    self.by-version."pause-stream"."0.0.11";
  by-version."pause-stream"."0.0.11" = self.buildNodePackage {
    name = "pause-stream-0.0.11";
    version = "0.0.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz";
      name = "pause-stream-0.0.11.tgz";
      sha1 = "fe5a34b0cbce12b5aa6a2b403ee2e73b602f1445";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = self.buildNodePackage {
    name = "pkginfo-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
      name = "pkginfo-0.3.0.tgz";
      sha1 = "726411401039fe9b009eea86614295d5f3a54276";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."properties"."1.2.1" =
    self.by-version."properties"."1.2.1";
  by-version."properties"."1.2.1" = self.buildNodePackage {
    name = "properties-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/properties/-/properties-1.2.1.tgz";
      name = "properties-1.2.1.tgz";
      sha1 = "0ee97a7fc020b1a2a55b8659eda4aa8d869094bd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."proxy-addr"."~1.0.6" =
    self.by-version."proxy-addr"."1.0.8";
  by-version."proxy-addr"."1.0.8" = self.buildNodePackage {
    name = "proxy-addr-1.0.8";
    version = "1.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.8.tgz";
      name = "proxy-addr-1.0.8.tgz";
      sha1 = "db54ec878bcc1053d57646609219b3715678bafe";
    };
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-1.0.1" = self.by-version."ipaddr.js"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."1.2.0" =
    self.by-version."qs"."1.2.0";
  by-version."qs"."1.2.0" = self.buildNodePackage {
    name = "qs-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-1.2.0.tgz";
      name = "qs-1.2.0.tgz";
      sha1 = "ed079be28682147e6fd9a34cc2b0c1e0ec6453ee";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."2.3.3" =
    self.by-version."qs"."2.3.3";
  by-version."qs"."2.3.3" = self.buildNodePackage {
    name = "qs-2.3.3";
    version = "2.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-2.3.3.tgz";
      name = "qs-2.3.3.tgz";
      sha1 = "e9e85adbe75da0bbe4c8e0476a086290f863b404";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.2";
  by-version."range-parser"."1.0.2" = self.buildNodePackage {
    name = "range-parser-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.2.tgz";
      name = "range-parser-1.0.2.tgz";
      sha1 = "06a12a42e5131ba8e457cd892044867f2344e549";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."1.0.27-1" =
    self.by-version."readable-stream"."1.0.27-1";
  by-version."readable-stream"."1.0.27-1" = self.buildNodePackage {
    name = "readable-stream-1.0.27-1";
    version = "1.0.27-1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.27-1.tgz";
      name = "readable-stream-1.0.27-1.tgz";
      sha1 = "6b67983c20357cefd07f0165001a16d710d91078";
    };
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."redis"."0.12.x" =
    self.by-version."redis"."0.12.1";
  by-version."redis"."0.12.1" = self.buildNodePackage {
    name = "redis-0.12.1";
    version = "0.12.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/redis/-/redis-0.12.1.tgz";
      name = "redis-0.12.1.tgz";
      sha1 = "64df76ad0fc8acebaebd2a0645e8a48fac49185e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."reduce-component"."1.0.1" =
    self.by-version."reduce-component"."1.0.1";
  by-version."reduce-component"."1.0.1" = self.buildNodePackage {
    name = "reduce-component-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/reduce-component/-/reduce-component-1.0.1.tgz";
      name = "reduce-component-1.0.1.tgz";
      sha1 = "e0c93542c574521bea13df0f9488ed82ab77c5da";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."send"."0.11.1" =
    self.by-version."send"."0.11.1";
  by-version."send"."0.11.1" = self.buildNodePackage {
    name = "send-0.11.1";
    version = "0.11.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/send/-/send-0.11.1.tgz";
      name = "send-0.11.1.tgz";
      sha1 = "1beabfd42f9e2709f99028af3078ac12b47092d5";
    };
    deps = {
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.8.1" =
    self.by-version."serve-static"."1.8.1";
  by-version."serve-static"."1.8.1" = self.buildNodePackage {
    name = "serve-static-1.8.1";
    version = "1.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/serve-static/-/serve-static-1.8.1.tgz";
      name = "serve-static-1.8.1.tgz";
      sha1 = "08fabd39999f050fc311443f46d5888a77ecfc7c";
    };
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.11.1" = self.by-version."send"."0.11.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."split"."0.3" =
    self.by-version."split"."0.3.3";
  by-version."split"."0.3.3" = self.buildNodePackage {
    name = "split-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/split/-/split-0.3.3.tgz";
      name = "split-0.3.3.tgz";
      sha1 = "cd0eea5e63a211dfff7eb0f091c4133e2d0dd28f";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = self.buildNodePackage {
    name = "stack-trace-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
      name = "stack-trace-0.0.9.tgz";
      sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-combiner"."~0.0.4" =
    self.by-version."stream-combiner"."0.0.4";
  by-version."stream-combiner"."0.0.4" = self.buildNodePackage {
    name = "stream-combiner-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz";
      name = "stream-combiner-0.0.4.tgz";
      sha1 = "4d5e433c185261dde623ca3f44c586bcf5c4ad14";
    };
    deps = {
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string"."2.0.1" =
    self.by-version."string"."2.0.1";
  by-version."string"."2.0.1" = self.buildNodePackage {
    name = "string-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/string/-/string-2.0.1.tgz";
      name = "string-2.0.1.tgz";
      sha1 = "ef1473b3e11cb8158671856556959b9aff5fd759";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = self.buildNodePackage {
    name = "string_decoder-0.10.31";
    version = "0.10.31";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
      name = "string_decoder-0.10.31.tgz";
      sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."superagent"."0.21.0" =
    self.by-version."superagent"."0.21.0";
  by-version."superagent"."0.21.0" = self.buildNodePackage {
    name = "superagent-0.21.0";
    version = "0.21.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/superagent/-/superagent-0.21.0.tgz";
      name = "superagent-0.21.0.tgz";
      sha1 = "fb15027984751ee7152200e6cd21cd6e19a5de87";
    };
    deps = {
      "qs-1.2.0" = self.by-version."qs"."1.2.0";
      "formidable-1.0.14" = self.by-version."formidable"."1.0.14";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "methods-1.0.1" = self.by-version."methods"."1.0.1";
      "cookiejar-2.0.1" = self.by-version."cookiejar"."2.0.1";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "reduce-component-1.0.1" = self.by-version."reduce-component"."1.0.1";
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "form-data-0.1.3" = self.by-version."form-data"."0.1.3";
      "readable-stream-1.0.27-1" = self.by-version."readable-stream"."1.0.27-1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through"."2" =
    self.by-version."through"."2.3.8";
  by-version."through"."2.3.8" = self.buildNodePackage {
    name = "through-2.3.8";
    version = "2.3.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/through/-/through-2.3.8.tgz";
      name = "through-2.3.8.tgz";
      sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through"."~2.3" =
    self.by-version."through"."2.3.8";
  by-spec."through"."~2.3.1" =
    self.by-version."through"."2.3.8";
  by-spec."type-is"."~1.5.6" =
    self.by-version."type-is"."1.5.7";
  by-version."type-is"."1.5.7" = self.buildNodePackage {
    name = "type-is-1.5.7";
    version = "1.5.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/type-is/-/type-is-1.5.7.tgz";
      name = "type-is-1.5.7.tgz";
      sha1 = "b9368a593cc6ef7d0645e78b2f4c64cbecd05e90";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = self.buildNodePackage {
    name = "utils-merge-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
      name = "utils-merge-1.0.0.tgz";
      sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vary"."~1.0.0" =
    self.by-version."vary"."1.0.1";
  by-version."vary"."1.0.1" = self.buildNodePackage {
    name = "vary-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/vary/-/vary-1.0.1.tgz";
      name = "vary-1.0.1.tgz";
      sha1 = "99e4981566a286118dfb2b817357df7993376d10";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."verror"."^1.4.0" =
    self.by-version."verror"."1.6.0";
  by-version."verror"."1.6.0" = self.buildNodePackage {
    name = "verror-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/verror/-/verror-1.6.0.tgz";
      name = "verror-1.6.0.tgz";
      sha1 = "7d13b27b1facc2e2da90405eb5ea6e5bdd252ea5";
    };
    deps = {
      "extsprintf-1.2.0" = self.by-version."extsprintf"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."websocket-driver".">=0.5.1" =
    self.by-version."websocket-driver"."0.6.2";
  by-version."websocket-driver"."0.6.2" = self.buildNodePackage {
    name = "websocket-driver-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.6.2.tgz";
      name = "websocket-driver-0.6.2.tgz";
      sha1 = "8281dba3e299e5bd7a42b65d4577a8928c26f898";
    };
    deps = {
      "websocket-extensions-0.1.1" = self.by-version."websocket-extensions"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."websocket-extensions".">=0.1.1" =
    self.by-version."websocket-extensions"."0.1.1";
  by-version."websocket-extensions"."0.1.1" = self.buildNodePackage {
    name = "websocket-extensions-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/websocket-extensions/-/websocket-extensions-0.1.1.tgz";
      name = "websocket-extensions-0.1.1.tgz";
      sha1 = "76899499c184b6ef754377c2dbb0cd6cb55d29e7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."winston"."0.8.0" =
    self.by-version."winston"."0.8.0";
  by-version."winston"."0.8.0" = self.buildNodePackage {
    name = "winston-0.8.0";
    version = "0.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/winston/-/winston-0.8.0.tgz";
      name = "winston-0.8.0.tgz";
      sha1 = "61d0830fa699706212206b0a2b5ca69a93043668";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.3";
  by-version."wordwrap"."0.0.3" = self.buildNodePackage {
    name = "wordwrap-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz";
      name = "wordwrap-0.0.3.tgz";
      sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
