{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."addressparser"."^0.3.2" =
    self.by-version."addressparser"."0.3.2";
  by-version."addressparser"."0.3.2" = self.buildNodePackage {
    name = "addressparser-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/addressparser/-/addressparser-0.3.2.tgz";
      name = "addressparser-0.3.2.tgz";
      sha1 = "59873f35e8fcf6c7361c10239261d76e15348bb2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."addressparser"."~0.2.0" =
    self.by-version."addressparser"."0.2.1";
  by-version."addressparser"."0.2.1" = self.buildNodePackage {
    name = "addressparser-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/addressparser/-/addressparser-0.2.1.tgz";
      name = "addressparser-0.2.1.tgz";
      sha1 = "d11a5b2eeda04cfefebdf3196c10ae13db6cd607";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-parallel"."~0.1.0" =
    self.by-version."array-parallel"."0.1.3";
  by-version."array-parallel"."0.1.3" = self.buildNodePackage {
    name = "array-parallel-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/array-parallel/-/array-parallel-0.1.3.tgz";
      name = "array-parallel-0.1.3.tgz";
      sha1 = "8f785308926ed5aa478c47e64d1b334b6c0c947d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-series"."~0.1.0" =
    self.by-version."array-series"."0.1.5";
  by-version."array-series"."0.1.5" = self.buildNodePackage {
    name = "array-series-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/array-series/-/array-series-0.1.5.tgz";
      name = "array-series-0.1.5.tgz";
      sha1 = "df5d37bfc5c2ef0755e2aa4f92feae7d4b5a972f";
    };
    deps = {
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
  by-spec."async"."0.9.x" =
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
  by-spec."bcrypt"."0.8.x" =
    self.by-version."bcrypt"."0.8.5";
  by-version."bcrypt"."0.8.5" = self.buildNodePackage {
    name = "bcrypt-0.8.5";
    version = "0.8.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bcrypt/-/bcrypt-0.8.5.tgz";
      name = "bcrypt-0.8.5.tgz";
      sha1 = "8e5b81b4db80e944f440005979ca8d58a961861d";
    };
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-2.0.5" = self.by-version."nan"."2.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bcrypt" = self.by-version."bcrypt"."0.8.5";
  by-spec."bindings"."1.2.1" =
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
  by-spec."bisection"."*" =
    self.by-version."bisection"."0.0.3";
  by-version."bisection"."0.0.3" = self.buildNodePackage {
    name = "bisection-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bisection/-/bisection-0.0.3.tgz";
      name = "bisection-0.0.3.tgz";
      sha1 = "9891d506d86ec7d50910c5157bb592dbb03f33db";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bson"."~0.2" =
    self.by-version."bson"."0.2.22";
  by-version."bson"."0.2.22" = self.buildNodePackage {
    name = "bson-0.2.22";
    version = "0.2.22";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bson/-/bson-0.2.22.tgz";
      name = "bson-0.2.22.tgz";
      sha1 = "fcda103f26d0c074d5a52d50927db80fd02b4b39";
    };
    deps = {
      "nan-1.8.4" = self.by-version."nan"."1.8.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bufferjs"."=1.1.0" =
    self.by-version."bufferjs"."1.1.0";
  by-version."bufferjs"."1.1.0" = self.buildNodePackage {
    name = "bufferjs-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bufferjs/-/bufferjs-1.1.0.tgz";
      name = "bufferjs-1.1.0.tgz";
      sha1 = "095ffa39c5e6b40a2178a1169c9effc584a73201";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."builtin-modules"."^1.0.0" =
    self.by-version."builtin-modules"."1.1.0";
  by-version."builtin-modules"."1.1.0" = self.buildNodePackage {
    name = "builtin-modules-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/builtin-modules/-/builtin-modules-1.1.0.tgz";
      name = "builtin-modules-1.1.0.tgz";
      sha1 = "1053955fd994a5746e525e4ac717b81caf07491c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bunyan"."0.16.x" =
    self.by-version."bunyan"."0.16.8";
  by-version."bunyan"."0.16.8" = self.buildNodePackage {
    name = "bunyan-0.16.8";
    version = "0.16.8";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/bunyan/-/bunyan-0.16.8.tgz";
      name = "bunyan-0.16.8.tgz";
      sha1 = "3b3f6cdca262fa31aba43eb0eb6fb58e7bdde547";
    };
    deps = {
      "dtrace-provider-0.2.4" = self.by-version."dtrace-provider"."0.2.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bunyan" = self.by-version."bunyan"."0.16.8";
  by-spec."camelcase"."^2.0.0" =
    self.by-version."camelcase"."2.0.1";
  by-version."camelcase"."2.0.1" = self.buildNodePackage {
    name = "camelcase-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/camelcase/-/camelcase-2.0.1.tgz";
      name = "camelcase-2.0.1.tgz";
      sha1 = "57568d687b8da56c4c1d17b4c74a3cee26d73aeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase-keys"."^2.0.0" =
    self.by-version."camelcase-keys"."2.0.0";
  by-version."camelcase-keys"."2.0.0" = self.buildNodePackage {
    name = "camelcase-keys-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/camelcase-keys/-/camelcase-keys-2.0.0.tgz";
      name = "camelcase-keys-2.0.0.tgz";
      sha1 = "ab87e740d72a1ffcb12a43cc04c14b39d549eab9";
    };
    deps = {
      "camelcase-2.0.1" = self.by-version."camelcase"."2.0.1";
      "map-obj-1.0.1" = self.by-version."map-obj"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connect"."1.x" =
    self.by-version."connect"."1.9.2";
  by-version."connect"."1.9.2" = self.buildNodePackage {
    name = "connect-1.9.2";
    version = "1.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect/-/connect-1.9.2.tgz";
      name = "connect-1.9.2.tgz";
      sha1 = "42880a22e9438ae59a8add74e437f58ae8e52807";
    };
    deps = {
      "qs-6.0.1" = self.by-version."qs"."6.0.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "formidable-1.0.17" = self.by-version."formidable"."1.0.17";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "connect" = self.by-version."connect"."1.9.2";
  by-spec."connect"."2.0.0" =
    self.by-version."connect"."2.0.0";
  by-version."connect"."2.0.0" = self.buildNodePackage {
    name = "connect-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect/-/connect-2.0.0.tgz";
      name = "connect-2.0.0.tgz";
      sha1 = "be0f8fcee7c1a0e2caa2e246a278dbbe250b9f27";
    };
    deps = {
      "qs-0.4.2" = self.by-version."qs"."0.4.2";
      "mime-1.2.4" = self.by-version."mime"."1.2.4";
      "formidable-1.0.17" = self.by-version."formidable"."1.0.17";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connect-auth"."0.5.3" =
    self.by-version."connect-auth"."0.5.3";
  by-version."connect-auth"."0.5.3" = self.buildNodePackage {
    name = "connect-auth-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect-auth/-/connect-auth-0.5.3.tgz";
      name = "connect-auth-0.5.3.tgz";
      sha1 = "2af00ac6f67ac1c5f451a0ff841a8d20a725091e";
    };
    deps = {
      "connect-2.0.0" = self.by-version."connect"."2.0.0";
      "oauth-0.9.7" = self.by-version."oauth"."0.9.7";
      "openid-0.4.1" = self.by-version."openid"."0.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "connect-auth" = self.by-version."connect-auth"."0.5.3";
  by-spec."connect-databank"."0.13.x" =
    self.by-version."connect-databank"."0.13.0";
  by-version."connect-databank"."0.13.0" = self.buildNodePackage {
    name = "connect-databank-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect-databank/-/connect-databank-0.13.0.tgz";
      name = "connect-databank-0.13.0.tgz";
      sha1 = "0d5063e9402381073e0242fd7c6ef28b2d61676b";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "databank-0.19.1" = self.by-version."databank"."0.19.1";
      "set-immediate-0.1.1" = self.by-version."set-immediate"."0.1.1";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "connect-databank" = self.by-version."connect-databank"."0.13.0";
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.2";
  by-version."core-util-is"."1.0.2" = self.buildNodePackage {
    name = "core-util-is-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
      name = "core-util-is-1.0.2.tgz";
      sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."crypto-cacerts"."0.1.x" =
    self.by-version."crypto-cacerts"."0.1.0";
  by-version."crypto-cacerts"."0.1.0" = self.buildNodePackage {
    name = "crypto-cacerts-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/crypto-cacerts/-/crypto-cacerts-0.1.0.tgz";
      name = "crypto-cacerts-0.1.0.tgz";
      sha1 = "3499c6dff949ab005d4ad4a3f09c48ced6c88a41";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "crypto-cacerts" = self.by-version."crypto-cacerts"."0.1.0";
  by-spec."databank"."0.18.x" =
    self.by-version."databank"."0.18.2";
  by-version."databank"."0.18.2" = self.buildNodePackage {
    name = "databank-0.18.2";
    version = "0.18.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/databank/-/databank-0.18.2.tgz";
      name = "databank-0.18.2.tgz";
      sha1 = "b1f85bafa329cdb415589c0ee819a04c989a03ed";
    };
    deps = {
      "vows-0.7.0" = self.by-version."vows"."0.7.0";
      "step-0.0.6" = self.by-version."step"."0.0.6";
      "set-immediate-0.1.1" = self.by-version."set-immediate"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."databank"."0.19.x" =
    self.by-version."databank"."0.19.1";
  by-version."databank"."0.19.1" = self.buildNodePackage {
    name = "databank-0.19.1";
    version = "0.19.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/databank/-/databank-0.19.1.tgz";
      name = "databank-0.19.1.tgz";
      sha1 = "95c6f662927b891f62c6f07fefe5e690fbe666e0";
    };
    deps = {
      "vows-0.7.0" = self.by-version."vows"."0.7.0";
      "step-0.0.6" = self.by-version."step"."0.0.6";
      "set-immediate-0.1.1" = self.by-version."set-immediate"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "databank" = self.by-version."databank"."0.19.1";
  by-spec."databank"."~0.19.1" =
    self.by-version."databank"."0.19.1";
  by-spec."databank-lrucache"."^0.1.2" =
    self.by-version."databank-lrucache"."0.1.2";
  by-version."databank-lrucache"."0.1.2" = self.buildNodePackage {
    name = "databank-lrucache-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/databank-lrucache/-/databank-lrucache-0.1.2.tgz";
      name = "databank-lrucache-0.1.2.tgz";
      sha1 = "846d3bbc3d908ea2880baf9a611d86a28697c640";
    };
    deps = {
      "databank-0.19.1" = self.by-version."databank"."0.19.1";
      "underscore-1.5.2" = self.by-version."underscore"."1.5.2";
      "lru-cache-2.3.1" = self.by-version."lru-cache"."2.3.1";
      "set-immediate-0.1.1" = self.by-version."set-immediate"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "databank-lrucache" = self.by-version."databank-lrucache"."0.1.2";
  by-spec."databank-memcached"."^0.15.0" =
    self.by-version."databank-memcached"."0.15.0";
  by-version."databank-memcached"."0.15.0" = self.buildNodePackage {
    name = "databank-memcached-0.15.0";
    version = "0.15.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/databank-memcached/-/databank-memcached-0.15.0.tgz";
      name = "databank-memcached-0.15.0.tgz";
      sha1 = "0817452dfb2b09267cd1c8bbec95363ec14f14f2";
    };
    deps = {
      "memcached-0.2.8" = self.by-version."memcached"."0.2.8";
      "databank-0.18.2" = self.by-version."databank"."0.18.2";
      "step-0.0.6" = self.by-version."step"."0.0.6";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "databank-memcached" = self.by-version."databank-memcached"."0.15.0";
  by-spec."databank-mongodb"."^0.18.10" =
    self.by-version."databank-mongodb"."0.18.10";
  by-version."databank-mongodb"."0.18.10" = self.buildNodePackage {
    name = "databank-mongodb-0.18.10";
    version = "0.18.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/databank-mongodb/-/databank-mongodb-0.18.10.tgz";
      name = "databank-mongodb-0.18.10.tgz";
      sha1 = "5f9d37059d024f1116bdca05459f9c033b0d8ae5";
    };
    deps = {
      "databank-0.19.1" = self.by-version."databank"."0.19.1";
      "mongodb-1.4.39" = self.by-version."mongodb"."1.4.39";
      "step-0.0.6" = self.by-version."step"."0.0.6";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "databank-mongodb" = self.by-version."databank-mongodb"."0.18.10";
  by-spec."databank-redis"."^0.19.6" =
    self.by-version."databank-redis"."0.19.6";
  by-version."databank-redis"."0.19.6" = self.buildNodePackage {
    name = "databank-redis-0.19.6";
    version = "0.19.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/databank-redis/-/databank-redis-0.19.6.tgz";
      name = "databank-redis-0.19.6.tgz";
      sha1 = "dd476b81b8200269ea0cc85f6b6decd05799bce9";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "databank-0.19.1" = self.by-version."databank"."0.19.1";
      "redis-0.10.3" = self.by-version."redis"."0.10.3";
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "databank-redis" = self.by-version."databank-redis"."0.19.6";
  by-spec."dateformat"."1.x" =
    self.by-version."dateformat"."1.0.12";
  by-version."dateformat"."1.0.12" = self.buildNodePackage {
    name = "dateformat-1.0.12";
    version = "1.0.12";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.12.tgz";
      name = "dateformat-1.0.12.tgz";
      sha1 = "9f124b67594c937ff706932e4a642cca8dbbfee9";
    };
    deps = {
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
      "meow-3.6.0" = self.by-version."meow"."3.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "dateformat" = self.by-version."dateformat"."1.0.12";
  by-spec."debug"."*" =
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
  by-spec."debug"."0.7.0" =
    self.by-version."debug"."0.7.0";
  by-version."debug"."0.7.0" = self.buildNodePackage {
    name = "debug-0.7.0";
    version = "0.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-0.7.0.tgz";
      name = "debug-0.7.0.tgz";
      sha1 = "f5be05ec0434c992d79940e50b2695cfb2e01b08";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dialback-client"."~0.1.5" =
    self.by-version."dialback-client"."0.1.5";
  by-version."dialback-client"."0.1.5" = self.buildNodePackage {
    name = "dialback-client-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dialback-client/-/dialback-client-0.1.5.tgz";
      name = "dialback-client-0.1.5.tgz";
      sha1 = "ff37f58554ac7dca79a219ba3e6e7c5ed4cc0745";
    };
    deps = {
      "express-2.5.11" = self.by-version."express"."2.5.11";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "databank-0.18.2" = self.by-version."databank"."0.18.2";
      "step-0.0.6" = self.by-version."step"."0.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "dialback-client" = self.by-version."dialback-client"."0.1.5";
  by-spec."diff"."~1.0.3" =
    self.by-version."diff"."1.0.8";
  by-version."diff"."1.0.8" = self.buildNodePackage {
    name = "diff-1.0.8";
    version = "1.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/diff/-/diff-1.0.8.tgz";
      name = "diff-1.0.8.tgz";
      sha1 = "343276308ec991b7bc82267ed55bc1411f971666";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dtrace-provider"."0.2.4" =
    self.by-version."dtrace-provider"."0.2.4";
  by-version."dtrace-provider"."0.2.4" = self.buildNodePackage {
    name = "dtrace-provider-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dtrace-provider/-/dtrace-provider-0.2.4.tgz";
      name = "dtrace-provider-0.2.4.tgz";
      sha1 = "0719d4449c8994cc89e317cf0d732213f94653d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."emailjs"."0.3.x" =
    self.by-version."emailjs"."0.3.16";
  by-version."emailjs"."0.3.16" = self.buildNodePackage {
    name = "emailjs-0.3.16";
    version = "0.3.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/emailjs/-/emailjs-0.3.16.tgz";
      name = "emailjs-0.3.16.tgz";
      sha1 = "f162735352ce7b6615a5d811714051f90f23331d";
    };
    deps = {
      "addressparser-0.3.2" = self.by-version."addressparser"."0.3.2";
      "mimelib-0.2.14" = self.by-version."mimelib"."0.2.14";
      "moment-1.7.0" = self.by-version."moment"."1.7.0";
      "starttls-0.2.1" = self.by-version."starttls"."0.2.1";
    };
    optionalDependencies = {
      "bufferjs-1.1.0" = self.by-version."bufferjs"."1.1.0";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "emailjs" = self.by-version."emailjs"."0.3.16";
  by-spec."encoding"."~0.1" =
    self.by-version."encoding"."0.1.11";
  by-version."encoding"."0.1.11" = self.buildNodePackage {
    name = "encoding-0.1.11";
    version = "0.1.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/encoding/-/encoding-0.1.11.tgz";
      name = "encoding-0.1.11.tgz";
      sha1 = "52c65ac15aab467f1338451e2615f988eccc0258";
    };
    deps = {
      "iconv-lite-0.4.13" = self.by-version."iconv-lite"."0.4.13";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."error-ex"."^1.2.0" =
    self.by-version."error-ex"."1.3.0";
  by-version."error-ex"."1.3.0" = self.buildNodePackage {
    name = "error-ex-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/error-ex/-/error-ex-1.3.0.tgz";
      name = "error-ex-1.3.0.tgz";
      sha1 = "e67b43f3e82c96ea3a584ffee0b9fc3325d802d9";
    };
    deps = {
      "is-arrayish-0.2.1" = self.by-version."is-arrayish"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."2.5.x" =
    self.by-version."express"."2.5.11";
  by-version."express"."2.5.11" = self.buildNodePackage {
    name = "express-2.5.11";
    version = "2.5.11";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/express/-/express-2.5.11.tgz";
      name = "express-2.5.11.tgz";
      sha1 = "4ce8ea1f3635e69e49f0ebb497b6a4b0a51ce6f0";
    };
    deps = {
      "connect-1.9.2" = self.by-version."connect"."1.9.2";
      "mime-1.2.4" = self.by-version."mime"."1.2.4";
      "qs-0.4.2" = self.by-version."qs"."0.4.2";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."2.5.11";
  by-spec."eyes".">=0.1.6" =
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
  by-spec."faye-websocket"."^0.9.3" =
    self.by-version."faye-websocket"."0.9.4";
  by-version."faye-websocket"."0.9.4" = self.buildNodePackage {
    name = "faye-websocket-0.9.4";
    version = "0.9.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.9.4.tgz";
      name = "faye-websocket-0.9.4.tgz";
      sha1 = "885934c79effb0409549e0c0a3801ed17a40cdad";
    };
    deps = {
      "websocket-driver-0.6.3" = self.by-version."websocket-driver"."0.6.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."find-up"."^1.0.0" =
    self.by-version."find-up"."1.1.0";
  by-version."find-up"."1.1.0" = self.buildNodePackage {
    name = "find-up-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/find-up/-/find-up-1.1.0.tgz";
      name = "find-up-1.1.0.tgz";
      sha1 = "a63b0eec4625a2902534898a5f9eec8aaed046e9";
    };
    deps = {
      "path-exists-2.1.0" = self.by-version."path-exists"."2.1.0";
      "pinkie-promise-2.0.0" = self.by-version."pinkie-promise"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."formidable"."1.0.x" =
    self.by-version."formidable"."1.0.17";
  by-version."formidable"."1.0.17" = self.buildNodePackage {
    name = "formidable-1.0.17";
    version = "1.0.17";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/formidable/-/formidable-1.0.17.tgz";
      name = "formidable-1.0.17.tgz";
      sha1 = "ef5491490f9433b705faa77249c99029ae348559";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."get-stdin"."^4.0.1" =
    self.by-version."get-stdin"."4.0.1";
  by-version."get-stdin"."4.0.1" = self.buildNodePackage {
    name = "get-stdin-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz";
      name = "get-stdin-4.0.1.tgz";
      sha1 = "b968c6b0a04384324902e8bf1a5df32579a450fe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gm"."1.9.x" =
    self.by-version."gm"."1.9.2";
  by-version."gm"."1.9.2" = self.buildNodePackage {
    name = "gm-1.9.2";
    version = "1.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gm/-/gm-1.9.2.tgz";
      name = "gm-1.9.2.tgz";
      sha1 = "00443279fe959a10fa23025e0c8401e710215845";
    };
    deps = {
      "debug-0.7.0" = self.by-version."debug"."0.7.0";
      "array-series-0.1.5" = self.by-version."array-series"."0.1.5";
      "array-parallel-0.1.3" = self.by-version."array-parallel"."0.1.3";
      "through-2.3.8" = self.by-version."through"."2.3.8";
      "stream-to-buffer-0.0.1" = self.by-version."stream-to-buffer"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "gm" = self.by-version."gm"."1.9.2";
  by-spec."graceful-fs"."^4.1.2" =
    self.by-version."graceful-fs"."4.1.2";
  by-version."graceful-fs"."4.1.2" = self.buildNodePackage {
    name = "graceful-fs-4.1.2";
    version = "4.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.2.tgz";
      name = "graceful-fs-4.1.2.tgz";
      sha1 = "fe2239b7574972e67e41f808823f9bfa4a991e37";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hashring"."0.0.x" =
    self.by-version."hashring"."0.0.8";
  by-version."hashring"."0.0.8" = self.buildNodePackage {
    name = "hashring-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hashring/-/hashring-0.0.8.tgz";
      name = "hashring-0.0.8.tgz";
      sha1 = "203ab13c364119f10106526d2eaf7bd42b484c31";
    };
    deps = {
      "bisection-0.0.3" = self.by-version."bisection"."0.0.3";
      "simple-lru-cache-0.0.2" = self.by-version."simple-lru-cache"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hosted-git-info"."^2.1.4" =
    self.by-version."hosted-git-info"."2.1.4";
  by-version."hosted-git-info"."2.1.4" = self.buildNodePackage {
    name = "hosted-git-info-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.1.4.tgz";
      name = "hosted-git-info-2.1.4.tgz";
      sha1 = "d9e953b26988be88096c46e926494d9604c300f8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."~0.4.4" =
    self.by-version."iconv-lite"."0.4.13";
  by-version."iconv-lite"."0.4.13" = self.buildNodePackage {
    name = "iconv-lite-0.4.13";
    version = "0.4.13";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.13.tgz";
      name = "iconv-lite-0.4.13.tgz";
      sha1 = "1f88aba4ab0b1508e8312acc39345f36e992e2f2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."indent-string"."^2.1.0" =
    self.by-version."indent-string"."2.1.0";
  by-version."indent-string"."2.1.0" = self.buildNodePackage {
    name = "indent-string-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/indent-string/-/indent-string-2.1.0.tgz";
      name = "indent-string-2.1.0.tgz";
      sha1 = "8e2d48348742121b4a8218b7a137e9a52049dc80";
    };
    deps = {
      "repeating-2.0.0" = self.by-version."repeating"."2.0.0";
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
  by-spec."is-arrayish"."^0.2.1" =
    self.by-version."is-arrayish"."0.2.1";
  by-version."is-arrayish"."0.2.1" = self.buildNodePackage {
    name = "is-arrayish-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz";
      name = "is-arrayish-0.2.1.tgz";
      sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-builtin-module"."^1.0.0" =
    self.by-version."is-builtin-module"."1.0.0";
  by-version."is-builtin-module"."1.0.0" = self.buildNodePackage {
    name = "is-builtin-module-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-builtin-module/-/is-builtin-module-1.0.0.tgz";
      name = "is-builtin-module-1.0.0.tgz";
      sha1 = "540572d34f7ac3119f8f76c30cbc1b1e037affbe";
    };
    deps = {
      "builtin-modules-1.1.0" = self.by-version."builtin-modules"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-finite"."^1.0.0" =
    self.by-version."is-finite"."1.0.1";
  by-version."is-finite"."1.0.1" = self.buildNodePackage {
    name = "is-finite-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-finite/-/is-finite-1.0.1.tgz";
      name = "is-finite-1.0.1.tgz";
      sha1 = "6438603eaebe2793948ff4a4262ec8db3d62597b";
    };
    deps = {
      "number-is-nan-1.0.0" = self.by-version."number-is-nan"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-utf8"."^0.2.0" =
    self.by-version."is-utf8"."0.2.0";
  by-version."is-utf8"."0.2.0" = self.buildNodePackage {
    name = "is-utf8-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-utf8/-/is-utf8-0.2.0.tgz";
      name = "is-utf8-0.2.0.tgz";
      sha1 = "b8aa54125ae626bfe4e3beb965f16a89c58a1137";
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
  by-spec."jackpot".">=0.0.6" =
    self.by-version."jackpot"."0.0.6";
  by-version."jackpot"."0.0.6" = self.buildNodePackage {
    name = "jackpot-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jackpot/-/jackpot-0.0.6.tgz";
      name = "jackpot-0.0.6.tgz";
      sha1 = "3cff064285cbf66f4eab2593c90bce816a821849";
    };
    deps = {
      "retry-0.6.0" = self.by-version."retry"."0.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jankyqueue"."0.1.x" =
    self.by-version."jankyqueue"."0.1.1";
  by-version."jankyqueue"."0.1.1" = self.buildNodePackage {
    name = "jankyqueue-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jankyqueue/-/jankyqueue-0.1.1.tgz";
      name = "jankyqueue-0.1.1.tgz";
      sha1 = "4181b0318fb32e77aee8c54af73f97660f2e88d2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "jankyqueue" = self.by-version."jankyqueue"."0.1.1";
  by-spec."kerberos"."0.0.11" =
    self.by-version."kerberos"."0.0.11";
  by-version."kerberos"."0.0.11" = self.buildNodePackage {
    name = "kerberos-0.0.11";
    version = "0.0.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/kerberos/-/kerberos-0.0.11.tgz";
      name = "kerberos-0.0.11.tgz";
      sha1 = "cb29891c21c22ac195f3140b97dd12204fea7dc2";
    };
    deps = {
      "nan-1.8.4" = self.by-version."nan"."1.8.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."load-json-file"."^1.0.0" =
    self.by-version."load-json-file"."1.1.0";
  by-version."load-json-file"."1.1.0" = self.buildNodePackage {
    name = "load-json-file-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz";
      name = "load-json-file-1.1.0.tgz";
      sha1 = "956905708d58b4bab4c2261b04f59f31c99374c0";
    };
    deps = {
      "graceful-fs-4.1.2" = self.by-version."graceful-fs"."4.1.2";
      "parse-json-2.2.0" = self.by-version."parse-json"."2.2.0";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.0" = self.by-version."pinkie-promise"."2.0.0";
      "strip-bom-2.0.0" = self.by-version."strip-bom"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."loud-rejection"."^1.0.0" =
    self.by-version."loud-rejection"."1.2.0";
  by-version."loud-rejection"."1.2.0" = self.buildNodePackage {
    name = "loud-rejection-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/loud-rejection/-/loud-rejection-1.2.0.tgz";
      name = "loud-rejection-1.2.0.tgz";
      sha1 = "f4f87db6abec3b7fe47834531ecf6a011143e58d";
    };
    deps = {
      "signal-exit-2.1.2" = self.by-version."signal-exit"."2.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."2.3.x" =
    self.by-version."lru-cache"."2.3.1";
  by-version."lru-cache"."2.3.1" = self.buildNodePackage {
    name = "lru-cache-2.3.1";
    version = "2.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
      name = "lru-cache-2.3.1.tgz";
      sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."map-obj"."^1.0.0" =
    self.by-version."map-obj"."1.0.1";
  by-version."map-obj"."1.0.1" = self.buildNodePackage {
    name = "map-obj-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz";
      name = "map-obj-1.0.1.tgz";
      sha1 = "d933ceb9205d82bdcf4886f6742bdc2b4dea146d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."memcached"."0.2.x" =
    self.by-version."memcached"."0.2.8";
  by-version."memcached"."0.2.8" = self.buildNodePackage {
    name = "memcached-0.2.8";
    version = "0.2.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/memcached/-/memcached-0.2.8.tgz";
      name = "memcached-0.2.8.tgz";
      sha1 = "ffbf9498cbc30779625b77e77770bd50dc525212";
    };
    deps = {
      "hashring-0.0.8" = self.by-version."hashring"."0.0.8";
      "jackpot-0.0.6" = self.by-version."jackpot"."0.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."meow"."^3.3.0" =
    self.by-version."meow"."3.6.0";
  by-version."meow"."3.6.0" = self.buildNodePackage {
    name = "meow-3.6.0";
    version = "3.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/meow/-/meow-3.6.0.tgz";
      name = "meow-3.6.0.tgz";
      sha1 = "e7a535295cb89db0e0782428e55fa8615bf9e150";
    };
    deps = {
      "camelcase-keys-2.0.0" = self.by-version."camelcase-keys"."2.0.0";
      "loud-rejection-1.2.0" = self.by-version."loud-rejection"."1.2.0";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "normalize-package-data-2.3.5" = self.by-version."normalize-package-data"."2.3.5";
      "object-assign-4.0.1" = self.by-version."object-assign"."4.0.1";
      "read-pkg-up-1.0.1" = self.by-version."read-pkg-up"."1.0.1";
      "redent-1.0.0" = self.by-version."redent"."1.0.0";
      "trim-newlines-1.0.0" = self.by-version."trim-newlines"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."1.2.4" =
    self.by-version."mime"."1.2.4";
  by-version."mime"."1.2.4" = self.buildNodePackage {
    name = "mime-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.2.4.tgz";
      name = "mime-1.2.4.tgz";
      sha1 = "11b5fdaf29c2509255176b80ad520294f5de92b7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime".">= 0.0.1" =
    self.by-version."mime"."1.3.4";
  by-version."mime"."1.3.4" = self.buildNodePackage {
    name = "mime-1.3.4";
    version = "1.3.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.3.4.tgz";
      name = "mime-1.3.4.tgz";
      sha1 = "115f9e3b6b3daf2959983cb38f149a2d40eb5d53";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mimelib"."0.2.14" =
    self.by-version."mimelib"."0.2.14";
  by-version."mimelib"."0.2.14" = self.buildNodePackage {
    name = "mimelib-0.2.14";
    version = "0.2.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mimelib/-/mimelib-0.2.14.tgz";
      name = "mimelib-0.2.14.tgz";
      sha1 = "2a1aa724bd190b85bd526e6317ab6106edfd6831";
    };
    deps = {
      "encoding-0.1.11" = self.by-version."encoding"."0.1.11";
      "addressparser-0.2.1" = self.by-version."addressparser"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."^1.1.3" =
    self.by-version."minimist"."1.2.0";
  by-version."minimist"."1.2.0" = self.buildNodePackage {
    name = "minimist-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz";
      name = "minimist-1.2.0.tgz";
      sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.3.0" =
    self.by-version."mkdirp"."0.3.0";
  by-version."mkdirp"."0.3.0" = self.buildNodePackage {
    name = "mkdirp-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
      name = "mkdirp-0.3.0.tgz";
      sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.3.x" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = self.buildNodePackage {
    name = "mkdirp-0.3.5";
    version = "0.3.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
      name = "mkdirp-0.3.5.tgz";
      sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mkdirp" = self.by-version."mkdirp"."0.3.5";
  by-spec."moment"."= 1.7.0" =
    self.by-version."moment"."1.7.0";
  by-version."moment"."1.7.0" = self.buildNodePackage {
    name = "moment-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/moment/-/moment-1.7.0.tgz";
      name = "moment-1.7.0.tgz";
      sha1 = "6f3d73a446c6bd6af1b993801d0b8071efad5e28";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mongodb"."1.4.x" =
    self.by-version."mongodb"."1.4.39";
  by-version."mongodb"."1.4.39" = self.buildNodePackage {
    name = "mongodb-1.4.39";
    version = "1.4.39";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mongodb/-/mongodb-1.4.39.tgz";
      name = "mongodb-1.4.39.tgz";
      sha1 = "f5b25c7f7df06c968cd5d3c68280adc9a6404591";
    };
    deps = {
      "bson-0.2.22" = self.by-version."bson"."0.2.22";
    };
    optionalDependencies = {
      "kerberos-0.0.11" = self.by-version."kerberos"."0.0.11";
      "readable-stream-2.0.4" = self.by-version."readable-stream"."2.0.4";
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
  by-spec."nan"."2.0.5" =
    self.by-version."nan"."2.0.5";
  by-version."nan"."2.0.5" = self.buildNodePackage {
    name = "nan-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-2.0.5.tgz";
      name = "nan-2.0.5.tgz";
      sha1 = "365888014be1fd178db0cbfa258edf7b0cb1c408";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."~1.8" =
    self.by-version."nan"."1.8.4";
  by-version."nan"."1.8.4" = self.buildNodePackage {
    name = "nan-1.8.4";
    version = "1.8.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-1.8.4.tgz";
      name = "nan-1.8.4.tgz";
      sha1 = "3c76b5382eab33e44b758d2813ca9d92e9342f34";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."1.3.x" =
    self.by-version."node-uuid"."1.3.3";
  by-version."node-uuid"."1.3.3" = self.buildNodePackage {
    name = "node-uuid-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.3.3.tgz";
      name = "node-uuid-1.3.3.tgz";
      sha1 = "d3db4d7b56810d9e4032342766282af07391729b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "node-uuid" = self.by-version."node-uuid"."1.3.3";
  by-spec."node-uuid"."1.4.x" =
    self.by-version."node-uuid"."1.4.7";
  by-version."node-uuid"."1.4.7" = self.buildNodePackage {
    name = "node-uuid-1.4.7";
    version = "1.4.7";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.7.tgz";
      name = "node-uuid-1.4.7.tgz";
      sha1 = "6da5a17668c4b3dd59623bda11cf7fa4c1f60a6f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."^1.4.1" =
    self.by-version."node-uuid"."1.4.7";
  by-spec."normalize-package-data"."^2.3.2" =
    self.by-version."normalize-package-data"."2.3.5";
  by-version."normalize-package-data"."2.3.5" = self.buildNodePackage {
    name = "normalize-package-data-2.3.5";
    version = "2.3.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.3.5.tgz";
      name = "normalize-package-data-2.3.5.tgz";
      sha1 = "8d924f142960e1777e7ffe170543631cc7cb02df";
    };
    deps = {
      "hosted-git-info-2.1.4" = self.by-version."hosted-git-info"."2.1.4";
      "is-builtin-module-1.0.0" = self.by-version."is-builtin-module"."1.0.0";
      "semver-5.1.0" = self.by-version."semver"."5.1.0";
      "validate-npm-package-license-3.0.1" = self.by-version."validate-npm-package-license"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."normalize-package-data"."^2.3.4" =
    self.by-version."normalize-package-data"."2.3.5";
  by-spec."number-is-nan"."^1.0.0" =
    self.by-version."number-is-nan"."1.0.0";
  by-version."number-is-nan"."1.0.0" = self.buildNodePackage {
    name = "number-is-nan-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.0.tgz";
      name = "number-is-nan-1.0.0.tgz";
      sha1 = "c020f529c5282adfdd233d91d4b181c3d686dc4b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth"."0.9.7" =
    self.by-version."oauth"."0.9.7";
  by-version."oauth"."0.9.7" = self.buildNodePackage {
    name = "oauth-0.9.7";
    version = "0.9.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth/-/oauth-0.9.7.tgz";
      name = "oauth-0.9.7.tgz";
      sha1 = "c2554d0368c966eb3050bec96584625577ad1ecd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-evanp"."~0.9.10-evanp.2" =
    self.by-version."oauth-evanp"."0.9.10-evanp.2";
  by-version."oauth-evanp"."0.9.10-evanp.2" = self.buildNodePackage {
    name = "oauth-evanp-0.9.10-evanp.2";
    version = "0.9.10-evanp.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-evanp/-/oauth-evanp-0.9.10-evanp.2.tgz";
      name = "oauth-evanp-0.9.10-evanp.2.tgz";
      sha1 = "9b5fb3508cea584420855957d56531405cf53a02";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "oauth-evanp" = self.by-version."oauth-evanp"."0.9.10-evanp.2";
  by-spec."object-assign"."^4.0.1" =
    self.by-version."object-assign"."4.0.1";
  by-version."object-assign"."4.0.1" = self.buildNodePackage {
    name = "object-assign-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-assign/-/object-assign-4.0.1.tgz";
      name = "object-assign-4.0.1.tgz";
      sha1 = "99504456c3598b5cad4fc59c26e8a9bb107fe0bd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."openid"."0.4.1" =
    self.by-version."openid"."0.4.1";
  by-version."openid"."0.4.1" = self.buildNodePackage {
    name = "openid-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/openid/-/openid-0.4.1.tgz";
      name = "openid-0.4.1.tgz";
      sha1 = "de0eb5e381d34dc4aa5a77a98678bedafd11f387";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."0.3.x" =
    self.by-version."optimist"."0.3.7";
  by-version."optimist"."0.3.7" = self.buildNodePackage {
    name = "optimist-0.3.7";
    version = "0.3.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
      name = "optimist-0.3.7.tgz";
      sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
    };
    deps = {
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "optimist" = self.by-version."optimist"."0.3.7";
  by-spec."parse-json"."^2.2.0" =
    self.by-version."parse-json"."2.2.0";
  by-version."parse-json"."2.2.0" = self.buildNodePackage {
    name = "parse-json-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz";
      name = "parse-json-2.2.0.tgz";
      sha1 = "f480f40434ef80741f8469099f8dea18f55a4dc9";
    };
    deps = {
      "error-ex-1.3.0" = self.by-version."error-ex"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-exists"."^2.0.0" =
    self.by-version."path-exists"."2.1.0";
  by-version."path-exists"."2.1.0" = self.buildNodePackage {
    name = "path-exists-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz";
      name = "path-exists-2.1.0.tgz";
      sha1 = "0feb6c64f0fc518d9a754dd5efb62c7022761f4b";
    };
    deps = {
      "pinkie-promise-2.0.0" = self.by-version."pinkie-promise"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-type"."^1.0.0" =
    self.by-version."path-type"."1.1.0";
  by-version."path-type"."1.1.0" = self.buildNodePackage {
    name = "path-type-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz";
      name = "path-type-1.1.0.tgz";
      sha1 = "59c44f7ee491da704da415da5a4070ba4f8fe441";
    };
    deps = {
      "graceful-fs-4.1.2" = self.by-version."graceful-fs"."4.1.2";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.0" = self.by-version."pinkie-promise"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pify"."^2.0.0" =
    self.by-version."pify"."2.3.0";
  by-version."pify"."2.3.0" = self.buildNodePackage {
    name = "pify-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pify/-/pify-2.3.0.tgz";
      name = "pify-2.3.0.tgz";
      sha1 = "ed141a6ac043a849ea588498e7dca8b15330e90c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie"."^2.0.0" =
    self.by-version."pinkie"."2.0.1";
  by-version."pinkie"."2.0.1" = self.buildNodePackage {
    name = "pinkie-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie/-/pinkie-2.0.1.tgz";
      name = "pinkie-2.0.1.tgz";
      sha1 = "4236c86fc29f261c2045bbe81f78cbb2a5e8306c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie-promise"."^2.0.0" =
    self.by-version."pinkie-promise"."2.0.0";
  by-version."pinkie-promise"."2.0.0" = self.buildNodePackage {
    name = "pinkie-promise-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.0.tgz";
      name = "pinkie-promise-2.0.0.tgz";
      sha1 = "4c83538de1f6e660c29e0a13446844f7a7e88259";
    };
    deps = {
      "pinkie-2.0.1" = self.by-version."pinkie"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."process-nextick-args"."~1.0.0" =
    self.by-version."process-nextick-args"."1.0.6";
  by-version."process-nextick-args"."1.0.6" = self.buildNodePackage {
    name = "process-nextick-args-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.6.tgz";
      name = "process-nextick-args-1.0.6.tgz";
      sha1 = "0f96b001cea90b12592ce566edb97ec11e69bd05";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."0.4.x" =
    self.by-version."qs"."0.4.2";
  by-version."qs"."0.4.2" = self.buildNodePackage {
    name = "qs-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-0.4.2.tgz";
      name = "qs-0.4.2.tgz";
      sha1 = "3cac4c861e371a8c9c4770ac23cda8de639b8e5f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs".">= 0.4.0" =
    self.by-version."qs"."6.0.1";
  by-version."qs"."6.0.1" = self.buildNodePackage {
    name = "qs-6.0.1";
    version = "6.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-6.0.1.tgz";
      name = "qs-6.0.1.tgz";
      sha1 = "ee8b7fcd64fcbe6e36c922bd2c464ee7c54766c3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."read-pkg"."^1.0.0" =
    self.by-version."read-pkg"."1.1.0";
  by-version."read-pkg"."1.1.0" = self.buildNodePackage {
    name = "read-pkg-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz";
      name = "read-pkg-1.1.0.tgz";
      sha1 = "f5ffaa5ecd29cb31c0474bca7d756b6bb29e3f28";
    };
    deps = {
      "load-json-file-1.1.0" = self.by-version."load-json-file"."1.1.0";
      "normalize-package-data-2.3.5" = self.by-version."normalize-package-data"."2.3.5";
      "path-type-1.1.0" = self.by-version."path-type"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."read-pkg-up"."^1.0.1" =
    self.by-version."read-pkg-up"."1.0.1";
  by-version."read-pkg-up"."1.0.1" = self.buildNodePackage {
    name = "read-pkg-up-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz";
      name = "read-pkg-up-1.0.1.tgz";
      sha1 = "9d63c13276c065918d57f002a57f40a1b643fb02";
    };
    deps = {
      "find-up-1.1.0" = self.by-version."find-up"."1.1.0";
      "read-pkg-1.1.0" = self.by-version."read-pkg"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."*" =
    self.by-version."readable-stream"."2.0.4";
  by-version."readable-stream"."2.0.4" = self.buildNodePackage {
    name = "readable-stream-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-2.0.4.tgz";
      name = "readable-stream-2.0.4.tgz";
      sha1 = "2523ef27ffa339d7ba9da8603f2d0599d06edbd8";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "process-nextick-args-1.0.6" = self.by-version."process-nextick-args"."1.0.6";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."redent"."^1.0.0" =
    self.by-version."redent"."1.0.0";
  by-version."redent"."1.0.0" = self.buildNodePackage {
    name = "redent-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/redent/-/redent-1.0.0.tgz";
      name = "redent-1.0.0.tgz";
      sha1 = "cf916ab1fd5f1f16dfb20822dd6ec7f730c2afde";
    };
    deps = {
      "indent-string-2.1.0" = self.by-version."indent-string"."2.1.0";
      "strip-indent-1.0.1" = self.by-version."strip-indent"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."redis"."~0.10.3" =
    self.by-version."redis"."0.10.3";
  by-version."redis"."0.10.3" = self.buildNodePackage {
    name = "redis-0.10.3";
    version = "0.10.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/redis/-/redis-0.10.3.tgz";
      name = "redis-0.10.3.tgz";
      sha1 = "8927fe2110ee39617bcf3fd37b89d8e123911bb6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."repeating"."^2.0.0" =
    self.by-version."repeating"."2.0.0";
  by-version."repeating"."2.0.0" = self.buildNodePackage {
    name = "repeating-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/repeating/-/repeating-2.0.0.tgz";
      name = "repeating-2.0.0.tgz";
      sha1 = "fd27d6d264d18fbebfaa56553dd7b82535a5034e";
    };
    deps = {
      "is-finite-1.0.1" = self.by-version."is-finite"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."retry"."0.6.0" =
    self.by-version."retry"."0.6.0";
  by-version."retry"."0.6.0" = self.buildNodePackage {
    name = "retry-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/retry/-/retry-0.6.0.tgz";
      name = "retry-0.6.0.tgz";
      sha1 = "1c010713279a6fd1e8def28af0c3ff1871caa537";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sax".">=0.1.1" =
    self.by-version."sax"."1.1.4";
  by-version."sax"."1.1.4" = self.buildNodePackage {
    name = "sax-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sax/-/sax-1.1.4.tgz";
      name = "sax-1.1.4.tgz";
      sha1 = "74b6d33c9ae1e001510f179a91168588f1aedaa9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."schlock"."~0.2.1" =
    self.by-version."schlock"."0.2.1";
  by-version."schlock"."0.2.1" = self.buildNodePackage {
    name = "schlock-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/schlock/-/schlock-0.2.1.tgz";
      name = "schlock-0.2.1.tgz";
      sha1 = "2a9aaeaa209a5422eadc5dfc005e2c2f15241f99";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "schlock" = self.by-version."schlock"."0.2.1";
  by-spec."semver"."2 || 3 || 4 || 5" =
    self.by-version."semver"."5.1.0";
  by-version."semver"."5.1.0" = self.buildNodePackage {
    name = "semver-5.1.0";
    version = "5.1.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-5.1.0.tgz";
      name = "semver-5.1.0.tgz";
      sha1 = "85f2cf8550465c4df000cf7d86f6b054106ab9e5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."set-immediate"."0.1.x" =
    self.by-version."set-immediate"."0.1.1";
  by-version."set-immediate"."0.1.1" = self.buildNodePackage {
    name = "set-immediate-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/set-immediate/-/set-immediate-0.1.1.tgz";
      name = "set-immediate-0.1.1.tgz";
      sha1 = "8986e4a773bf8ec165f24d579107673bfac141de";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "set-immediate" = self.by-version."set-immediate"."0.1.1";
  by-spec."set-immediate"."~0.1.1" =
    self.by-version."set-immediate"."0.1.1";
  by-spec."showdown"."0.3.x" =
    self.by-version."showdown"."0.3.4";
  by-version."showdown"."0.3.4" = self.buildNodePackage {
    name = "showdown-0.3.4";
    version = "0.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/showdown/-/showdown-0.3.4.tgz";
      name = "showdown-0.3.4.tgz";
      sha1 = "b056fa0209d44ac55c90331b44a934774976ac55";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "showdown" = self.by-version."showdown"."0.3.4";
  by-spec."signal-exit"."^2.1.2" =
    self.by-version."signal-exit"."2.1.2";
  by-version."signal-exit"."2.1.2" = self.buildNodePackage {
    name = "signal-exit-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/signal-exit/-/signal-exit-2.1.2.tgz";
      name = "signal-exit-2.1.2.tgz";
      sha1 = "375879b1f92ebc3b334480d038dc546a6d558564";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."simple-lru-cache"."0.0.x" =
    self.by-version."simple-lru-cache"."0.0.2";
  by-version."simple-lru-cache"."0.0.2" = self.buildNodePackage {
    name = "simple-lru-cache-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/simple-lru-cache/-/simple-lru-cache-0.0.2.tgz";
      name = "simple-lru-cache-0.0.2.tgz";
      sha1 = "d59cc3a193c1a5d0320f84ee732f6e4713e511dd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sockjs"."0.3.x" =
    self.by-version."sockjs"."0.3.15";
  by-version."sockjs"."0.3.15" = self.buildNodePackage {
    name = "sockjs-0.3.15";
    version = "0.3.15";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sockjs/-/sockjs-0.3.15.tgz";
      name = "sockjs-0.3.15.tgz";
      sha1 = "e19b577e59e0fbdb21a0ae4f46203ca24cad8db8";
    };
    deps = {
      "faye-websocket-0.9.4" = self.by-version."faye-websocket"."0.9.4";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "sockjs" = self.by-version."sockjs"."0.3.15";
  by-spec."spdx-correct"."~1.0.0" =
    self.by-version."spdx-correct"."1.0.2";
  by-version."spdx-correct"."1.0.2" = self.buildNodePackage {
    name = "spdx-correct-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/spdx-correct/-/spdx-correct-1.0.2.tgz";
      name = "spdx-correct-1.0.2.tgz";
      sha1 = "4b3073d933ff51f3912f03ac5519498a4150db40";
    };
    deps = {
      "spdx-license-ids-1.1.0" = self.by-version."spdx-license-ids"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-exceptions"."^1.0.4" =
    self.by-version."spdx-exceptions"."1.0.4";
  by-version."spdx-exceptions"."1.0.4" = self.buildNodePackage {
    name = "spdx-exceptions-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/spdx-exceptions/-/spdx-exceptions-1.0.4.tgz";
      name = "spdx-exceptions-1.0.4.tgz";
      sha1 = "220b84239119ae9045a892db81a83f4ce16f80fd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-expression-parse"."~1.0.0" =
    self.by-version."spdx-expression-parse"."1.0.2";
  by-version."spdx-expression-parse"."1.0.2" = self.buildNodePackage {
    name = "spdx-expression-parse-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-1.0.2.tgz";
      name = "spdx-expression-parse-1.0.2.tgz";
      sha1 = "d52b14b5e9670771440af225bcb563122ac452f6";
    };
    deps = {
      "spdx-exceptions-1.0.4" = self.by-version."spdx-exceptions"."1.0.4";
      "spdx-license-ids-1.1.0" = self.by-version."spdx-license-ids"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-license-ids"."^1.0.0" =
    self.by-version."spdx-license-ids"."1.1.0";
  by-version."spdx-license-ids"."1.1.0" = self.buildNodePackage {
    name = "spdx-license-ids-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-1.1.0.tgz";
      name = "spdx-license-ids-1.1.0.tgz";
      sha1 = "28694acdf39fe27de45143fff81f21f6c66d44ac";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-license-ids"."^1.0.2" =
    self.by-version."spdx-license-ids"."1.1.0";
  by-spec."starttls"."0.2.1" =
    self.by-version."starttls"."0.2.1";
  by-version."starttls"."0.2.1" = self.buildNodePackage {
    name = "starttls-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/starttls/-/starttls-0.2.1.tgz";
      name = "starttls-0.2.1.tgz";
      sha1 = "b98d3e5e778d46f199c843a64f889f0347c6d19a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."step"."0.0.x" =
    self.by-version."step"."0.0.6";
  by-version."step"."0.0.6" = self.buildNodePackage {
    name = "step-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/step/-/step-0.0.6.tgz";
      name = "step-0.0.6.tgz";
      sha1 = "143e7849a5d7d3f4a088fe29af94915216eeede2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "step" = self.by-version."step"."0.0.6";
  by-spec."stream-to-buffer"."~0.0.1" =
    self.by-version."stream-to-buffer"."0.0.1";
  by-version."stream-to-buffer"."0.0.1" = self.buildNodePackage {
    name = "stream-to-buffer-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stream-to-buffer/-/stream-to-buffer-0.0.1.tgz";
      name = "stream-to-buffer-0.0.1.tgz";
      sha1 = "ab483d59a1ca71832de379a255f465b665af45c1";
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
  by-spec."strip-bom"."^2.0.0" =
    self.by-version."strip-bom"."2.0.0";
  by-version."strip-bom"."2.0.0" = self.buildNodePackage {
    name = "strip-bom-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz";
      name = "strip-bom-2.0.0.tgz";
      sha1 = "6219a85616520491f35788bdbf1447a99c7e6b0e";
    };
    deps = {
      "is-utf8-0.2.0" = self.by-version."is-utf8"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-indent"."^1.0.1" =
    self.by-version."strip-indent"."1.0.1";
  by-version."strip-indent"."1.0.1" = self.buildNodePackage {
    name = "strip-indent-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-indent/-/strip-indent-1.0.1.tgz";
      name = "strip-indent-1.0.1.tgz";
      sha1 = "0c7962a6adefa7bbd4ac366460a638552ae1a0a2";
    };
    deps = {
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through"."~2.3.1" =
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
  by-spec."trim-newlines"."^1.0.0" =
    self.by-version."trim-newlines"."1.0.0";
  by-version."trim-newlines"."1.0.0" = self.buildNodePackage {
    name = "trim-newlines-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/trim-newlines/-/trim-newlines-1.0.0.tgz";
      name = "trim-newlines-1.0.0.tgz";
      sha1 = "5887966bb582a4503a41eb524f7d35011815a613";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."*" =
    self.by-version."underscore"."1.8.3";
  by-version."underscore"."1.8.3" = self.buildNodePackage {
    name = "underscore-1.8.3";
    version = "1.8.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.8.3.tgz";
      name = "underscore-1.8.3.tgz";
      sha1 = "4f3fb53b106e6097fcf9cb4109f2a5e9bdfa5022";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."1.4.x" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = self.buildNodePackage {
    name = "underscore-1.4.4";
    version = "1.4.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
      name = "underscore-1.4.4.tgz";
      sha1 = "61a6a32010622afa07963bf325203cf12239d604";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "underscore" = self.by-version."underscore"."1.4.4";
  by-spec."underscore"."1.5.x" =
    self.by-version."underscore"."1.5.2";
  by-version."underscore"."1.5.2" = self.buildNodePackage {
    name = "underscore-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
      name = "underscore-1.5.2.tgz";
      sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."1.6.x" =
    self.by-version."underscore"."1.6.0";
  by-version."underscore"."1.6.0" = self.buildNodePackage {
    name = "underscore-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.6.0.tgz";
      name = "underscore-1.6.0.tgz";
      sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore".">=1.1.3" =
    self.by-version."underscore"."1.8.3";
  by-spec."underscore"."^1.8.3" =
    self.by-version."underscore"."1.8.3";
  by-spec."underscore-contrib"."0.1.x" =
    self.by-version."underscore-contrib"."0.1.4";
  by-version."underscore-contrib"."0.1.4" = self.buildNodePackage {
    name = "underscore-contrib-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore-contrib/-/underscore-contrib-0.1.4.tgz";
      name = "underscore-contrib-0.1.4.tgz";
      sha1 = "db40f37f2e66961d2e0326bf65fb76887a1ca1c6";
    };
    deps = {
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "underscore-contrib" = self.by-version."underscore-contrib"."0.1.4";
  by-spec."util-deprecate"."~1.0.1" =
    self.by-version."util-deprecate"."1.0.2";
  by-version."util-deprecate"."1.0.2" = self.buildNodePackage {
    name = "util-deprecate-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
      name = "util-deprecate-1.0.2.tgz";
      sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utml"."0.2.x" =
    self.by-version."utml"."0.2.0";
  by-version."utml"."0.2.0" = self.buildNodePackage {
    name = "utml-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/utml/-/utml-0.2.0.tgz";
      name = "utml-0.2.0.tgz";
      sha1 = "6a546741823b2a9c17598a57e8eb4c08738dee48";
    };
    deps = {
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "utml" = self.by-version."utml"."0.2.0";
  by-spec."validate-npm-package-license"."^3.0.1" =
    self.by-version."validate-npm-package-license"."3.0.1";
  by-version."validate-npm-package-license"."3.0.1" = self.buildNodePackage {
    name = "validate-npm-package-license-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.1.tgz";
      name = "validate-npm-package-license-3.0.1.tgz";
      sha1 = "2804babe712ad3379459acfbe24746ab2c303fbc";
    };
    deps = {
      "spdx-correct-1.0.2" = self.by-version."spdx-correct"."1.0.2";
      "spdx-expression-parse-1.0.2" = self.by-version."spdx-expression-parse"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."validator"."0.4.x" =
    self.by-version."validator"."0.4.28";
  by-version."validator"."0.4.28" = self.buildNodePackage {
    name = "validator-0.4.28";
    version = "0.4.28";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/validator/-/validator-0.4.28.tgz";
      name = "validator-0.4.28.tgz";
      sha1 = "311d439ae6cf3fbe6f85da6ebaccd0c7007986f4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "validator" = self.by-version."validator"."0.4.28";
  by-spec."vows"."0.7.x" =
    self.by-version."vows"."0.7.0";
  by-version."vows"."0.7.0" = self.buildNodePackage {
    name = "vows-0.7.0";
    version = "0.7.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/vows/-/vows-0.7.0.tgz";
      name = "vows-0.7.0.tgz";
      sha1 = "dd0065f110ba0c0a6d63e844851c3208176d5867";
    };
    deps = {
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."webfinger"."~0.4.2" =
    self.by-version."webfinger"."0.4.2";
  by-version."webfinger"."0.4.2" = self.buildNodePackage {
    name = "webfinger-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/webfinger/-/webfinger-0.4.2.tgz";
      name = "webfinger-0.4.2.tgz";
      sha1 = "3477a6d97799461896039fcffc650b73468ee76d";
    };
    deps = {
      "step-0.0.6" = self.by-version."step"."0.0.6";
      "xml2js-0.1.14" = self.by-version."xml2js"."0.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "webfinger" = self.by-version."webfinger"."0.4.2";
  by-spec."websocket-driver".">=0.5.1" =
    self.by-version."websocket-driver"."0.6.3";
  by-version."websocket-driver"."0.6.3" = self.buildNodePackage {
    name = "websocket-driver-0.6.3";
    version = "0.6.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/websocket-driver/-/websocket-driver-0.6.3.tgz";
      name = "websocket-driver-0.6.3.tgz";
      sha1 = "fd21911bb46dee34ad85bdbc5676bf9024ed087b";
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
  by-spec."xml2js"."0.1.x" =
    self.by-version."xml2js"."0.1.14";
  by-version."xml2js"."0.1.14" = self.buildNodePackage {
    name = "xml2js-0.1.14";
    version = "0.1.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xml2js/-/xml2js-0.1.14.tgz";
      name = "xml2js-0.1.14.tgz";
      sha1 = "5274e67f5a64c5f92974cd85139e0332adc6b90c";
    };
    deps = {
      "sax-1.1.4" = self.by-version."sax"."1.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
