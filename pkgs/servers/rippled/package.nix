{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."accepts"."~1.2.5" =
    self.by-version."accepts"."1.2.5";
  by-version."accepts"."1.2.5" = self.buildNodePackage {
    name = "accepts-1.2.5";
    version = "1.2.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/accepts/-/accepts-1.2.5.tgz";
      name = "accepts-1.2.5.tgz";
      sha1 = "bb07dc52c141ae562611a836ff433bcec8871ce9";
    };
    deps = {
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
      "negotiator-0.5.1" = self.by-version."negotiator"."0.5.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = self.buildNodePackage {
    name = "asn1-0.1.11";
    version = "0.1.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
      name = "asn1-0.1.11.tgz";
      sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."^0.1.5" =
    self.by-version."assert-plus"."0.1.5";
  by-version."assert-plus"."0.1.5" = self.buildNodePackage {
    name = "assert-plus-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
      name = "assert-plus-0.1.5.tgz";
      sha1 = "ee74009413002d84cec7219c6ac811812e723160";
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
  by-spec."async"."^0.2.10" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.7" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.9" =
    self.by-version."async"."0.2.10";
  "async" = self.by-version."async"."0.2.10";
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-version."async"."0.9.0" = self.buildNodePackage {
    name = "async-0.9.0";
    version = "0.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
      name = "async-0.9.0.tgz";
      sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sign"."~0.2.0" =
    self.by-version."aws-sign"."0.2.0";
  by-version."aws-sign"."0.2.0" = self.buildNodePackage {
    name = "aws-sign-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.2.0.tgz";
      name = "aws-sign-0.2.0.tgz";
      sha1 = "c55013856c8194ec854a0cbec90aab5a04ce3ac5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = self.buildNodePackage {
    name = "aws-sign2-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
      name = "aws-sign2-0.5.0.tgz";
      sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64-url"."1.2.1" =
    self.by-version."base64-url"."1.2.1";
  by-version."base64-url"."1.2.1" = self.buildNodePackage {
    name = "base64-url-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64-url/-/base64-url-1.2.1.tgz";
      name = "base64-url-1.2.1.tgz";
      sha1 = "199fd661702a0e7b7dcae6e0698bb089c52f6d78";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."basic-auth"."1.0.0" =
    self.by-version."basic-auth"."1.0.0";
  by-version."basic-auth"."1.0.0" = self.buildNodePackage {
    name = "basic-auth-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/basic-auth/-/basic-auth-1.0.0.tgz";
      name = "basic-auth-1.0.0.tgz";
      sha1 = "111b2d9ff8e4e6d136b8c84ea5e096cb87351637";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."basic-auth-connect"."1.0.0" =
    self.by-version."basic-auth-connect"."1.0.0";
  by-version."basic-auth-connect"."1.0.0" = self.buildNodePackage {
    name = "basic-auth-connect-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/basic-auth-connect/-/basic-auth-connect-1.0.0.tgz";
      name = "basic-auth-connect-1.0.0.tgz";
      sha1 = "fdb0b43962ca7b40456a7c2bb48fe173da2d2122";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."batch"."0.5.2" =
    self.by-version."batch"."0.5.2";
  by-version."batch"."0.5.2" = self.buildNodePackage {
    name = "batch-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/batch/-/batch-0.5.2.tgz";
      name = "batch-0.5.2.tgz";
      sha1 = "546543dbe32118c83c7c7ca33a1f5c5d5ea963e9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bignumber.js"."^2.0.0" =
    self.by-version."bignumber.js"."2.0.3";
  by-version."bignumber.js"."2.0.3" = self.buildNodePackage {
    name = "bignumber.js-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bignumber.js/-/bignumber.js-2.0.3.tgz";
      name = "bignumber.js-2.0.3.tgz";
      sha1 = "1328f1d618f4bfe23587af73577a5a1e4f3cf105";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bindings"."1.2.x" =
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
  by-spec."bl"."~0.9.0" =
    self.by-version."bl"."0.9.4";
  by-version."bl"."0.9.4" = self.buildNodePackage {
    name = "bl-0.9.4";
    version = "0.9.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bl/-/bl-0.9.4.tgz";
      name = "bl-0.9.4.tgz";
      sha1 = "4702ddf72fbe0ecd82787c00c113aea1935ad0e7";
    };
    deps = {
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."body-parser"."~1.12.2" =
    self.by-version."body-parser"."1.12.2";
  by-version."body-parser"."1.12.2" = self.buildNodePackage {
    name = "body-parser-1.12.2";
    version = "1.12.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/body-parser/-/body-parser-1.12.2.tgz";
      name = "body-parser-1.12.2.tgz";
      sha1 = "698368fb4dfc57a05bff1ddb1bebeba3bd2c0e87";
    };
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "iconv-lite-0.4.7" = self.by-version."iconv-lite"."0.4.7";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
      "qs-2.4.1" = self.by-version."qs"."2.4.1";
      "raw-body-1.3.3" = self.by-version."raw-body"."1.3.3";
      "type-is-1.6.1" = self.by-version."type-is"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."0.3.x" =
    self.by-version."boom"."0.3.8";
  by-version."boom"."0.3.8" = self.buildNodePackage {
    name = "boom-0.3.8";
    version = "0.3.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-0.3.8.tgz";
      name = "boom-0.3.8.tgz";
      sha1 = "c8cdb041435912741628c044ecc732d1d17c09ea";
    };
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = self.buildNodePackage {
    name = "boom-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
      name = "boom-0.4.2.tgz";
      sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.6.1";
  by-version."boom"."2.6.1" = self.buildNodePackage {
    name = "boom-2.6.1";
    version = "2.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-2.6.1.tgz";
      name = "boom-2.6.1.tgz";
      sha1 = "4dc8ef9b6dfad9c43bbbfbe71fa4c21419f22753";
    };
    deps = {
      "hoek-2.11.1" = self.by-version."hoek"."2.11.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browser-request"."~0.3.0" =
    self.by-version."browser-request"."0.3.3";
  by-version."browser-request"."0.3.3" = self.buildNodePackage {
    name = "browser-request-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/browser-request/-/browser-request-0.3.3.tgz";
      name = "browser-request-0.3.3.tgz";
      sha1 = "9ece5b5aca89a29932242e18bf933def9876cc17";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bufferutil"."1.0.x" =
    self.by-version."bufferutil"."1.0.1";
  by-version."bufferutil"."1.0.1" = self.buildNodePackage {
    name = "bufferutil-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bufferutil/-/bufferutil-1.0.1.tgz";
      name = "bufferutil-1.0.1.tgz";
      sha1 = "0c53a9ffe8d616c4e2df27d00b808f7a25501e3b";
    };
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.6.2" = self.by-version."nan"."1.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytes"."1.0.0" =
    self.by-version."bytes"."1.0.0";
  by-version."bytes"."1.0.0" = self.buildNodePackage {
    name = "bytes-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bytes/-/bytes-1.0.0.tgz";
      name = "bytes-1.0.0.tgz";
      sha1 = "3569ede8ba34315fab99c3e92cb04c7220de1fa8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.6.0" =
    self.by-version."caseless"."0.6.0";
  by-version."caseless"."0.6.0" = self.buildNodePackage {
    name = "caseless-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.6.0.tgz";
      name = "caseless-0.6.0.tgz";
      sha1 = "8167c1ab8397fb5bb95f96d28e5a81c50f247ac4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.9.0" =
    self.by-version."caseless"."0.9.0";
  by-version."caseless"."0.9.0" = self.buildNodePackage {
    name = "caseless-0.9.0";
    version = "0.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.9.0.tgz";
      name = "caseless-0.9.0.tgz";
      sha1 = "b7b65ce6bf1413886539cfd533f0b30effa9cf88";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."clone"."~0.1.11" =
    self.by-version."clone"."0.1.19";
  by-version."clone"."0.1.19" = self.buildNodePackage {
    name = "clone-0.1.19";
    version = "0.1.19";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/clone/-/clone-0.1.19.tgz";
      name = "clone-0.1.19.tgz";
      sha1 = "613fb68639b26a494ac53253e15b1a6bd88ada85";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "clone" = self.by-version."clone"."0.1.19";
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
  by-spec."combined-stream"."~0.0.5" =
    self.by-version."combined-stream"."0.0.7";
  by-spec."commander"."2.6.0" =
    self.by-version."commander"."2.6.0";
  by-version."commander"."2.6.0" = self.buildNodePackage {
    name = "commander-2.6.0";
    version = "2.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.6.0.tgz";
      name = "commander-2.6.0.tgz";
      sha1 = "9df7e52fb2a0cb0fb89058ee80c3104225f37e1d";
    };
    deps = {
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
  by-spec."compressible"."~2.0.2" =
    self.by-version."compressible"."2.0.2";
  by-version."compressible"."2.0.2" = self.buildNodePackage {
    name = "compressible-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/compressible/-/compressible-2.0.2.tgz";
      name = "compressible-2.0.2.tgz";
      sha1 = "d0474a6ba6590a43d39c2ce9a6cfbb6479be76a5";
    };
    deps = {
      "mime-db-1.8.0" = self.by-version."mime-db"."1.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."compression"."~1.4.3" =
    self.by-version."compression"."1.4.3";
  by-version."compression"."1.4.3" = self.buildNodePackage {
    name = "compression-1.4.3";
    version = "1.4.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/compression/-/compression-1.4.3.tgz";
      name = "compression-1.4.3.tgz";
      sha1 = "7161bc0441df629273e5c31dd631b8e41e886b4d";
    };
    deps = {
      "accepts-1.2.5" = self.by-version."accepts"."1.2.5";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "compressible-2.0.2" = self.by-version."compressible"."2.0.2";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connect"."2.29.1" =
    self.by-version."connect"."2.29.1";
  by-version."connect"."2.29.1" = self.buildNodePackage {
    name = "connect-2.29.1";
    version = "2.29.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect/-/connect-2.29.1.tgz";
      name = "connect-2.29.1.tgz";
      sha1 = "e0456742d25ed232b573ce156883dd4e6f208538";
    };
    deps = {
      "basic-auth-connect-1.0.0" = self.by-version."basic-auth-connect"."1.0.0";
      "body-parser-1.12.2" = self.by-version."body-parser"."1.12.2";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-parser-1.3.4" = self.by-version."cookie-parser"."1.3.4";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "compression-1.4.3" = self.by-version."compression"."1.4.3";
      "connect-timeout-1.6.1" = self.by-version."connect-timeout"."1.6.1";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "csurf-1.7.0" = self.by-version."csurf"."1.7.0";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "errorhandler-1.3.5" = self.by-version."errorhandler"."1.3.5";
      "express-session-1.10.4" = self.by-version."express-session"."1.10.4";
      "finalhandler-0.3.4" = self.by-version."finalhandler"."0.3.4";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "http-errors-1.3.1" = self.by-version."http-errors"."1.3.1";
      "method-override-2.3.2" = self.by-version."method-override"."2.3.2";
      "morgan-1.5.2" = self.by-version."morgan"."1.5.2";
      "multiparty-3.3.2" = self.by-version."multiparty"."3.3.2";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "qs-2.4.1" = self.by-version."qs"."2.4.1";
      "response-time-2.3.0" = self.by-version."response-time"."2.3.0";
      "serve-favicon-2.2.0" = self.by-version."serve-favicon"."2.2.0";
      "serve-index-1.6.3" = self.by-version."serve-index"."1.6.3";
      "serve-static-1.9.2" = self.by-version."serve-static"."1.9.2";
      "type-is-1.6.1" = self.by-version."type-is"."1.6.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vhost-3.0.0" = self.by-version."vhost"."3.0.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connect-timeout"."~1.6.1" =
    self.by-version."connect-timeout"."1.6.1";
  by-version."connect-timeout"."1.6.1" = self.buildNodePackage {
    name = "connect-timeout-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect-timeout/-/connect-timeout-1.6.1.tgz";
      name = "connect-timeout-1.6.1.tgz";
      sha1 = "1de3a2b853734820a232080b95742494ba4cd067";
    };
    deps = {
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "http-errors-1.3.1" = self.by-version."http-errors"."1.3.1";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
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
  by-spec."content-type"."~1.0.1" =
    self.by-version."content-type"."1.0.1";
  by-version."content-type"."1.0.1" = self.buildNodePackage {
    name = "content-type-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/content-type/-/content-type-1.0.1.tgz";
      name = "content-type-1.0.1.tgz";
      sha1 = "a19d2247327dc038050ce622b7a154ec59c5e600";
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
  by-spec."cookie-jar"."~0.2.0" =
    self.by-version."cookie-jar"."0.2.0";
  by-version."cookie-jar"."0.2.0" = self.buildNodePackage {
    name = "cookie-jar-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.2.0.tgz";
      name = "cookie-jar-0.2.0.tgz";
      sha1 = "64ecc06ac978db795e4b5290cbe48ba3781400fa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-parser"."~1.3.4" =
    self.by-version."cookie-parser"."1.3.4";
  by-version."cookie-parser"."1.3.4" = self.buildNodePackage {
    name = "cookie-parser-1.3.4";
    version = "1.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie-parser/-/cookie-parser-1.3.4.tgz";
      name = "cookie-parser-1.3.4.tgz";
      sha1 = "193035a5be97117a21709b3aa737f6132717bda6";
    };
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-signature"."1.0.6" =
    self.by-version."cookie-signature"."1.0.6";
  by-version."cookie-signature"."1.0.6" = self.buildNodePackage {
    name = "cookie-signature-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz";
      name = "cookie-signature-1.0.6.tgz";
      sha1 = "e303a882b342cc3ee8ca513a79999734dab3ae2c";
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
  by-spec."couch-compile"."^1.0.1" =
    self.by-version."couch-compile"."1.2.0";
  by-version."couch-compile"."1.2.0" = self.buildNodePackage {
    name = "couch-compile-1.2.0";
    version = "1.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/couch-compile/-/couch-compile-1.2.0.tgz";
      name = "couch-compile-1.2.0.tgz";
      sha1 = "c4f7396f3dea38516b4e51d3edc3196de4f2d69c";
    };
    deps = {
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "couch-compile" = self.by-version."couch-compile"."1.2.0";
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
  by-spec."cron-parser"."~0.3.0" =
    self.by-version."cron-parser"."0.3.6";
  by-version."cron-parser"."0.3.6" = self.buildNodePackage {
    name = "cron-parser-0.3.6";
    version = "0.3.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cron-parser/-/cron-parser-0.3.6.tgz";
      name = "cron-parser-0.3.6.tgz";
      sha1 = "1e4734ebd5fa054f5766693c52468b17df9681c9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."0.1.x" =
    self.by-version."cryptiles"."0.1.3";
  by-version."cryptiles"."0.1.3" = self.buildNodePackage {
    name = "cryptiles-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.1.3.tgz";
      name = "cryptiles-0.1.3.tgz";
      sha1 = "1a556734f06d24ba34862ae9cb9e709a3afbff1c";
    };
    deps = {
      "boom-0.3.8" = self.by-version."boom"."0.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = self.buildNodePackage {
    name = "cryptiles-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
      name = "cryptiles-0.2.2.tgz";
      sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
    };
    deps = {
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."2.x.x" =
    self.by-version."cryptiles"."2.0.4";
  by-version."cryptiles"."2.0.4" = self.buildNodePackage {
    name = "cryptiles-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.4.tgz";
      name = "cryptiles-2.0.4.tgz";
      sha1 = "09ea1775b9e1c7de7e60a99d42ab6f08ce1a1285";
    };
    deps = {
      "boom-2.6.1" = self.by-version."boom"."2.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."csrf"."~2.0.6" =
    self.by-version."csrf"."2.0.6";
  by-version."csrf"."2.0.6" = self.buildNodePackage {
    name = "csrf-2.0.6";
    version = "2.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/csrf/-/csrf-2.0.6.tgz";
      name = "csrf-2.0.6.tgz";
      sha1 = "a90a9d88fc7411423cb0c5c13e901a8cc588132e";
    };
    deps = {
      "base64-url-1.2.1" = self.by-version."base64-url"."1.2.1";
      "rndm-1.1.0" = self.by-version."rndm"."1.1.0";
      "scmp-1.0.0" = self.by-version."scmp"."1.0.0";
      "uid-safe-1.1.0" = self.by-version."uid-safe"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."csurf"."~1.7.0" =
    self.by-version."csurf"."1.7.0";
  by-version."csurf"."1.7.0" = self.buildNodePackage {
    name = "csurf-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/csurf/-/csurf-1.7.0.tgz";
      name = "csurf-1.7.0.tgz";
      sha1 = "f24dc53753fccbdce0505f2abc5b57167b65ff18";
    };
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "csrf-2.0.6" = self.by-version."csrf"."2.0.6";
      "http-errors-1.3.1" = self.by-version."http-errors"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ctype"."0.5.3" =
    self.by-version."ctype"."0.5.3";
  by-version."ctype"."0.5.3" = self.buildNodePackage {
    name = "ctype-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
      name = "ctype-0.5.3.tgz";
      sha1 = "82c18c2461f74114ef16c135224ad0b9144ca12f";
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
  by-spec."debug"."~0.7.2" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = self.buildNodePackage {
    name = "debug-0.7.4";
    version = "0.7.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
      name = "debug-0.7.4.tgz";
      sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."~1.0.1" =
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
  by-spec."debug"."~2.1.3" =
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
  by-spec."deep-diff"."^0.1.4" =
    self.by-version."deep-diff"."0.1.7";
  by-version."deep-diff"."0.1.7" = self.buildNodePackage {
    name = "deep-diff-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-diff/-/deep-diff-0.1.7.tgz";
      name = "deep-diff-0.1.7.tgz";
      sha1 = "d36da978b64429c268116cea941f490e7949cd3d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "deep-diff" = self.by-version."deep-diff"."0.1.7";
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
    self.by-version."depd"."1.0.0";
  by-version."depd"."1.0.0" = self.buildNodePackage {
    name = "depd-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/depd/-/depd-1.0.0.tgz";
      name = "depd-1.0.0.tgz";
      sha1 = "2fda0d00e98aae2845d4991ab1bf1f2a199073d5";
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
  by-spec."errorhandler"."~1.3.5" =
    self.by-version."errorhandler"."1.3.5";
  by-version."errorhandler"."1.3.5" = self.buildNodePackage {
    name = "errorhandler-1.3.5";
    version = "1.3.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/errorhandler/-/errorhandler-1.3.5.tgz";
      name = "errorhandler-1.3.5.tgz";
      sha1 = "4ef655dd2c30e1fc1bf9c24805fa34ba20d4f69a";
    };
    deps = {
      "accepts-1.2.5" = self.by-version."accepts"."1.2.5";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."errs"."~0.3.0" =
    self.by-version."errs"."0.3.2";
  by-version."errs"."0.3.2" = self.buildNodePackage {
    name = "errs-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/errs/-/errs-0.3.2.tgz";
      name = "errs-0.3.2.tgz";
      sha1 = "798099b2dbd37ca2bc749e538a7c1307d0b50499";
    };
    deps = {
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
  by-spec."express"."^3.4.8" =
    self.by-version."express"."3.20.2";
  by-version."express"."3.20.2" = self.buildNodePackage {
    name = "express-3.20.2";
    version = "3.20.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/express/-/express-3.20.2.tgz";
      name = "express-3.20.2.tgz";
      sha1 = "c604027746e60f3da0a4b43063375d21c3235858";
    };
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "connect-2.29.1" = self.by-version."connect"."2.29.1";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "commander-2.6.0" = self.by-version."commander"."2.6.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "merge-descriptors-1.0.0" = self.by-version."merge-descriptors"."1.0.0";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "proxy-addr-1.0.7" = self.by-version."proxy-addr"."1.0.7";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.12.2" = self.by-version."send"."0.12.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."3.20.2";
  by-spec."express-session"."~1.10.4" =
    self.by-version."express-session"."1.10.4";
  by-version."express-session"."1.10.4" = self.buildNodePackage {
    name = "express-session-1.10.4";
    version = "1.10.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/express-session/-/express-session-1.10.4.tgz";
      name = "express-session-1.10.4.tgz";
      sha1 = "04e1d92e00593893e1f76569eb3ad63113daf94c";
    };
    deps = {
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "crc-3.2.1" = self.by-version."crc"."3.2.1";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "uid-safe-1.1.0" = self.by-version."uid-safe"."1.1.0";
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
  by-spec."finalhandler"."0.3.4" =
    self.by-version."finalhandler"."0.3.4";
  by-version."finalhandler"."0.3.4" = self.buildNodePackage {
    name = "finalhandler-0.3.4";
    version = "0.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.3.4.tgz";
      name = "finalhandler-0.3.4.tgz";
      sha1 = "4787d3573d079ae8b07536f26b0b911ebaf2a2ac";
    };
    deps = {
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."follow"."~0.11.2" =
    self.by-version."follow"."0.11.4";
  by-version."follow"."0.11.4" = self.buildNodePackage {
    name = "follow-0.11.4";
    version = "0.11.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/follow/-/follow-0.11.4.tgz";
      name = "follow-0.11.4.tgz";
      sha1 = "87e9a50d443f921d05704ebac412a14ab9d9232f";
    };
    deps = {
      "request-2.53.0" = self.by-version."request"."2.53.0";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.2.0" =
    self.by-version."forever-agent"."0.2.0";
  by-version."forever-agent"."0.2.0" = self.buildNodePackage {
    name = "forever-agent-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.2.0.tgz";
      name = "forever-agent-0.2.0.tgz";
      sha1 = "e1c25c7ad44e09c38f233876c76fcc24ff843b1f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = self.buildNodePackage {
    name = "forever-agent-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
      name = "forever-agent-0.5.2.tgz";
      sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
    };
    deps = {
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
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~0.0.3" =
    self.by-version."form-data"."0.0.10";
  by-version."form-data"."0.0.10" = self.buildNodePackage {
    name = "form-data-0.0.10";
    version = "0.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.0.10.tgz";
      name = "form-data-0.0.10.tgz";
      sha1 = "db345a5378d86aeeb1ed5d553b869ac192d2f5ed";
    };
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.2.10" = self.by-version."async"."0.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.4";
  by-version."form-data"."0.1.4" = self.buildNodePackage {
    name = "form-data-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.1.4.tgz";
      name = "form-data-0.1.4.tgz";
      sha1 = "91abd788aba9702b1aabfa8bc01031a2ac9e3b12";
    };
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~0.2.0" =
    self.by-version."form-data"."0.2.0";
  by-version."form-data"."0.2.0" = self.buildNodePackage {
    name = "form-data-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.2.0.tgz";
      name = "form-data-0.2.0.tgz";
      sha1 = "26f8bc26da6440e299cbdcfb69035c4f77a6e466";
    };
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
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
  by-spec."glob"."^3.2.11" =
    self.by-version."glob"."3.2.11";
  by-version."glob"."3.2.11" = self.buildNodePackage {
    name = "glob-3.2.11";
    version = "3.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-3.2.11.tgz";
      name = "glob-3.2.11.tgz";
      sha1 = "4a973f635b9190f715d10987d5c00fd2815ebe3d";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."1.1.1" =
    self.by-version."hawk"."1.1.1";
  by-version."hawk"."1.1.1" = self.buildNodePackage {
    name = "hawk-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-1.1.1.tgz";
      name = "hawk-1.1.1.tgz";
      sha1 = "87cd491f9b46e4e2aeaca335416766885d2d1ed9";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~0.10.2" =
    self.by-version."hawk"."0.10.2";
  by-version."hawk"."0.10.2" = self.buildNodePackage {
    name = "hawk-0.10.2";
    version = "0.10.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-0.10.2.tgz";
      name = "hawk-0.10.2.tgz";
      sha1 = "9b361dee95a931640e6d504e05609a8fc3ac45d2";
    };
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
      "boom-0.3.8" = self.by-version."boom"."0.3.8";
      "cryptiles-0.1.3" = self.by-version."cryptiles"."0.1.3";
      "sntp-0.1.4" = self.by-version."sntp"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~2.3.0" =
    self.by-version."hawk"."2.3.1";
  by-version."hawk"."2.3.1" = self.buildNodePackage {
    name = "hawk-2.3.1";
    version = "2.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-2.3.1.tgz";
      name = "hawk-2.3.1.tgz";
      sha1 = "1e731ce39447fa1d0f6d707f7bceebec0fd1ec1f";
    };
    deps = {
      "hoek-2.11.1" = self.by-version."hoek"."2.11.1";
      "boom-2.6.1" = self.by-version."boom"."2.6.1";
      "cryptiles-2.0.4" = self.by-version."cryptiles"."2.0.4";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."0.7.x" =
    self.by-version."hoek"."0.7.6";
  by-version."hoek"."0.7.6" = self.buildNodePackage {
    name = "hoek-0.7.6";
    version = "0.7.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-0.7.6.tgz";
      name = "hoek-0.7.6.tgz";
      sha1 = "60fbd904557541cd2b8795abf308a1b3770e155a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = self.buildNodePackage {
    name = "hoek-0.9.1";
    version = "0.9.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
      name = "hoek-0.9.1.tgz";
      sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."2.x.x" =
    self.by-version."hoek"."2.11.1";
  by-version."hoek"."2.11.1" = self.buildNodePackage {
    name = "hoek-2.11.1";
    version = "2.11.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-2.11.1.tgz";
      name = "hoek-2.11.1.tgz";
      sha1 = "3839a8b72f86aade3312100afaf80648af155b38";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-errors"."~1.3.1" =
    self.by-version."http-errors"."1.3.1";
  by-version."http-errors"."1.3.1" = self.buildNodePackage {
    name = "http-errors-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-errors/-/http-errors-1.3.1.tgz";
      name = "http-errors-1.3.1.tgz";
      sha1 = "197e22cdebd4198585e8694ef6786197b91ed942";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "statuses-1.2.1" = self.by-version."statuses"."1.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.1";
  by-version."http-signature"."0.10.1" = self.buildNodePackage {
    name = "http-signature-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.1.tgz";
      name = "http-signature-0.10.1.tgz";
      sha1 = "4fbdac132559aa8323121e540779c0a012b27e66";
    };
    deps = {
      "assert-plus-0.1.5" = self.by-version."assert-plus"."0.1.5";
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.3" = self.by-version."ctype"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."0.4.7" =
    self.by-version."iconv-lite"."0.4.7";
  by-version."iconv-lite"."0.4.7" = self.buildNodePackage {
    name = "iconv-lite-0.4.7";
    version = "0.4.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.7.tgz";
      name = "iconv-lite-0.4.7.tgz";
      sha1 = "89d32fec821bf8597f44609b4bc09bed5c209a23";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2" =
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
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ipaddr.js"."0.1.9" =
    self.by-version."ipaddr.js"."0.1.9";
  by-version."ipaddr.js"."0.1.9" = self.buildNodePackage {
    name = "ipaddr.js-0.1.9";
    version = "0.1.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.9.tgz";
      name = "ipaddr.js-0.1.9.tgz";
      sha1 = "a9c78ccc12dc9010f296ab9aef2f61f432d69efa";
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
  by-spec."isstream"."~0.1.1" =
    self.by-version."isstream"."0.1.2";
  by-version."isstream"."0.1.2" = self.buildNodePackage {
    name = "isstream-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
      name = "isstream-0.1.2.tgz";
      sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."~3.0.0" =
    self.by-version."json-stringify-safe"."3.0.0";
  by-version."json-stringify-safe"."3.0.0" = self.buildNodePackage {
    name = "json-stringify-safe-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-3.0.0.tgz";
      name = "json-stringify-safe-3.0.0.tgz";
      sha1 = "9db7b0e530c7f289c5e8c8432af191c2ff75a5b3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.0";
    version = "5.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
      name = "json-stringify-safe-5.0.0.tgz";
      sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."^3.1.0" =
    self.by-version."lodash"."3.5.0";
  by-version."lodash"."3.5.0" = self.buildNodePackage {
    name = "lodash-3.5.0";
    version = "3.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-3.5.0.tgz";
      name = "lodash-3.5.0.tgz";
      sha1 = "19bb3f4d51278f0b8c818ed145c74ecf9fe40e6d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."~1.3.1" =
    self.by-version."lodash"."1.3.1";
  by-version."lodash"."1.3.1" = self.buildNodePackage {
    name = "lodash-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-1.3.1.tgz";
      name = "lodash-1.3.1.tgz";
      sha1 = "a4663b53686b895ff074e2ba504dfb76a8e2b770";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "lodash" = self.by-version."lodash"."1.3.1";
  by-spec."long-timeout"."~0.0.1" =
    self.by-version."long-timeout"."0.0.2";
  by-version."long-timeout"."0.0.2" = self.buildNodePackage {
    name = "long-timeout-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/long-timeout/-/long-timeout-0.0.2.tgz";
      name = "long-timeout-0.0.2.tgz";
      sha1 = "f36449ba89629d13a7a2b2523a4db9dd66e3ff68";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.5.0";
  by-version."lru-cache"."2.5.0" = self.buildNodePackage {
    name = "lru-cache-2.5.0";
    version = "2.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.0.tgz";
      name = "lru-cache-2.5.0.tgz";
      sha1 = "d82388ae9c960becbea0c73bb9eb79b6c6ce9aeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."~2.5.0" =
    self.by-version."lru-cache"."2.5.0";
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
  by-spec."merge-descriptors"."1.0.0" =
    self.by-version."merge-descriptors"."1.0.0";
  by-version."merge-descriptors"."1.0.0" = self.buildNodePackage {
    name = "merge-descriptors-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.0.tgz";
      name = "merge-descriptors-1.0.0.tgz";
      sha1 = "2169cf7538e1b0cc87fb88e1502d8474bbf79864";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."method-override"."~2.3.2" =
    self.by-version."method-override"."2.3.2";
  by-version."method-override"."2.3.2" = self.buildNodePackage {
    name = "method-override-2.3.2";
    version = "2.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/method-override/-/method-override-2.3.2.tgz";
      name = "method-override-2.3.2.tgz";
      sha1 = "f2433fb27b6c087efb8812628727fb8cfd93a793";
    };
    deps = {
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
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
  by-spec."mime"."1.3.4" =
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
  by-spec."mime"."^1.2.11" =
    self.by-version."mime"."1.3.4";
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.2" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.7" =
    self.by-version."mime"."1.2.11";
  by-spec."mime-db".">= 1.1.2 < 2" =
    self.by-version."mime-db"."1.8.0";
  by-version."mime-db"."1.8.0" = self.buildNodePackage {
    name = "mime-db-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.8.0.tgz";
      name = "mime-db-1.8.0.tgz";
      sha1 = "82a9b385f22b0f5954dec4d445faba0722c4ad25";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.8.0" =
    self.by-version."mime-db"."1.8.0";
  by-spec."mime-types"."~1.0.1" =
    self.by-version."mime-types"."1.0.2";
  by-version."mime-types"."1.0.2" = self.buildNodePackage {
    name = "mime-types-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-1.0.2.tgz";
      name = "mime-types-1.0.2.tgz";
      sha1 = "995ae1392ab8affcbfcb2641dd054e943c0d5dce";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.1" =
    self.by-version."mime-types"."2.0.10";
  by-version."mime-types"."2.0.10" = self.buildNodePackage {
    name = "mime-types-2.0.10";
    version = "2.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.10.tgz";
      name = "mime-types-2.0.10.tgz";
      sha1 = "eacd81bb73cab2a77447549a078d4f2018c67b4d";
    };
    deps = {
      "mime-db-1.8.0" = self.by-version."mime-db"."1.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.10" =
    self.by-version."mime-types"."2.0.10";
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.10";
  by-spec."minimatch"."0.3" =
    self.by-version."minimatch"."0.3.0";
  by-version."minimatch"."0.3.0" = self.buildNodePackage {
    name = "minimatch-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz";
      name = "minimatch-0.3.0.tgz";
      sha1 = "275d8edaac4f1bb3326472089e7949c8394699dd";
    };
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = self.buildNodePackage {
    name = "minimist-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
      name = "minimist-0.0.8.tgz";
      sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-version."mkdirp"."0.5.0" = self.buildNodePackage {
    name = "mkdirp-0.5.0";
    version = "0.5.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
      name = "mkdirp-0.5.0.tgz";
      sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
    };
    deps = {
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."~0.3.5" =
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
  by-spec."moment"."~2.1.0" =
    self.by-version."moment"."2.1.0";
  by-version."moment"."2.1.0" = self.buildNodePackage {
    name = "moment-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/moment/-/moment-2.1.0.tgz";
      name = "moment-2.1.0.tgz";
      sha1 = "1fd7b1134029a953c6ea371dbaee37598ac03567";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "moment" = self.by-version."moment"."2.1.0";
  by-spec."morgan"."~1.5.2" =
    self.by-version."morgan"."1.5.2";
  by-version."morgan"."1.5.2" = self.buildNodePackage {
    name = "morgan-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/morgan/-/morgan-1.5.2.tgz";
      name = "morgan-1.5.2.tgz";
      sha1 = "34c1a0e7c2d5ad3ed78f0ef3257b8ac7c35d7cff";
    };
    deps = {
      "basic-auth-1.0.0" = self.by-version."basic-auth"."1.0.0";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
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
  by-spec."multiparty"."3.3.2" =
    self.by-version."multiparty"."3.3.2";
  by-version."multiparty"."3.3.2" = self.buildNodePackage {
    name = "multiparty-3.3.2";
    version = "3.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/multiparty/-/multiparty-3.3.2.tgz";
      name = "multiparty-3.3.2.tgz";
      sha1 = "35de6804dc19643e5249f3d3e3bdc6c8ce301d3f";
    };
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "stream-counter-0.2.0" = self.by-version."stream-counter"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."1.6.x" =
    self.by-version."nan"."1.6.2";
  by-version."nan"."1.6.2" = self.buildNodePackage {
    name = "nan-1.6.2";
    version = "1.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-1.6.2.tgz";
      name = "nan-1.6.2.tgz";
      sha1 = "2657d1c43b00f1e847e083832285b7d8f5ba8ec8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."~1.6.2" =
    self.by-version."nan"."1.6.2";
  by-spec."nano"."^5.8.0" =
    self.by-version."nano"."5.12.2";
  by-version."nano"."5.12.2" = self.buildNodePackage {
    name = "nano-5.12.2";
    version = "5.12.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nano/-/nano-5.12.2.tgz";
      name = "nano-5.12.2.tgz";
      sha1 = "b51c9c5e4045c4a71fe3bf6a1f46f0ac2426a17c";
    };
    deps = {
      "request-2.42.0" = self.by-version."request"."2.42.0";
      "follow-0.11.4" = self.by-version."follow"."0.11.4";
      "errs-0.3.2" = self.by-version."errs"."0.3.2";
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "nano" = self.by-version."nano"."5.12.2";
  by-spec."native-or-bluebird"."~1.1.2" =
    self.by-version."native-or-bluebird"."1.1.2";
  by-version."native-or-bluebird"."1.1.2" = self.buildNodePackage {
    name = "native-or-bluebird-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/native-or-bluebird/-/native-or-bluebird-1.1.2.tgz";
      name = "native-or-bluebird-1.1.2.tgz";
      sha1 = "3921e110232d1eb790f3dac61bb370531c7d356e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."negotiator"."0.5.1" =
    self.by-version."negotiator"."0.5.1";
  by-version."negotiator"."0.5.1" = self.buildNodePackage {
    name = "negotiator-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/negotiator/-/negotiator-0.5.1.tgz";
      name = "negotiator-0.5.1.tgz";
      sha1 = "498f661c522470153c6086ac83019cb3eb66f61c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-dogstatsd"."0.0.5" =
    self.by-version."node-dogstatsd"."0.0.5";
  by-version."node-dogstatsd"."0.0.5" = self.buildNodePackage {
    name = "node-dogstatsd-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-dogstatsd/-/node-dogstatsd-0.0.5.tgz";
      name = "node-dogstatsd-0.0.5.tgz";
      sha1 = "5b1bc12e7c2f1cab65c6081f43cee27eb359316e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ "linux" "darwin" "freebsd" ];
    cpu = [ ];
  };
  "node-dogstatsd" = self.by-version."node-dogstatsd"."0.0.5";
  by-spec."node-persist"."0.0.2" =
    self.by-version."node-persist"."0.0.2";
  by-version."node-persist"."0.0.2" = self.buildNodePackage {
    name = "node-persist-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-persist/-/node-persist-0.0.2.tgz";
      name = "node-persist-0.0.2.tgz";
      sha1 = "a4999e81d5f3f605df267abf314b7f03b8e6823b";
    };
    deps = {
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "sugar-1.3.9" = self.by-version."sugar"."1.3.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "node-persist" = self.by-version."node-persist"."0.0.2";
  by-spec."node-schedule"."^0.1.13" =
    self.by-version."node-schedule"."0.1.16";
  by-version."node-schedule"."0.1.16" = self.buildNodePackage {
    name = "node-schedule-0.1.16";
    version = "0.1.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-schedule/-/node-schedule-0.1.16.tgz";
      name = "node-schedule-0.1.16.tgz";
      sha1 = "1bbc74bd03141b9bb8c1135978d3b63995ddbf94";
    };
    deps = {
      "cron-parser-0.3.6" = self.by-version."cron-parser"."0.3.6";
      "long-timeout-0.0.2" = self.by-version."long-timeout"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "node-schedule" = self.by-version."node-schedule"."0.1.16";
  by-spec."node-statsd"."^0.1.0" =
    self.by-version."node-statsd"."0.1.1";
  by-version."node-statsd"."0.1.1" = self.buildNodePackage {
    name = "node-statsd-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-statsd/-/node-statsd-0.1.1.tgz";
      name = "node-statsd-0.1.1.tgz";
      sha1 = "27a59348763d0af7a037ac2a031fef3f051013d3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "node-statsd" = self.by-version."node-statsd"."0.1.1";
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.3";
  by-version."node-uuid"."1.4.3" = self.buildNodePackage {
    name = "node-uuid-1.4.3";
    version = "1.4.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.3.tgz";
      name = "node-uuid-1.4.3.tgz";
      sha1 = "319bb7a56e7cb63f00b5c0cd7851cd4b4ddf1df9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.2.0" =
    self.by-version."oauth-sign"."0.2.0";
  by-version."oauth-sign"."0.2.0" = self.buildNodePackage {
    name = "oauth-sign-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.2.0.tgz";
      name = "oauth-sign-0.2.0.tgz";
      sha1 = "a0e6a1715daed062f322b622b7fe5afd1035b6e2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.4.0" =
    self.by-version."oauth-sign"."0.4.0";
  by-version."oauth-sign"."0.4.0" = self.buildNodePackage {
    name = "oauth-sign-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.4.0.tgz";
      name = "oauth-sign-0.4.0.tgz";
      sha1 = "f22956f31ea7151a821e5f2fb32c113cad8b9f69";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.6.0" =
    self.by-version."oauth-sign"."0.6.0";
  by-version."oauth-sign"."0.6.0" = self.buildNodePackage {
    name = "oauth-sign-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.6.0.tgz";
      name = "oauth-sign-0.6.0.tgz";
      sha1 = "7dbeae44f6ca454e1f168451d630746735813ce3";
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
    self.by-version."on-finished"."2.2.0";
  by-version."on-finished"."2.2.0" = self.buildNodePackage {
    name = "on-finished-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/on-finished/-/on-finished-2.2.0.tgz";
      name = "on-finished-2.2.0.tgz";
      sha1 = "e6ba6a09a3482d6b7969bc3da92c86f0a967605e";
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
  by-spec."on-headers"."~1.0.0" =
    self.by-version."on-headers"."1.0.0";
  by-version."on-headers"."1.0.0" = self.buildNodePackage {
    name = "on-headers-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/on-headers/-/on-headers-1.0.0.tgz";
      name = "on-headers-1.0.0.tgz";
      sha1 = "2c75b5da4375513d0161c6052e7fcbe4953fca5d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = self.buildNodePackage {
    name = "options-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/options/-/options-0.0.6.tgz";
      name = "options-0.0.6.tgz";
      sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
    };
    deps = {
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
  by-spec."pause"."0.0.1" =
    self.by-version."pause"."0.0.1";
  by-version."pause"."0.0.1" = self.buildNodePackage {
    name = "pause-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pause/-/pause-0.0.1.tgz";
      name = "pause-0.0.1.tgz";
      sha1 = "1d408b3fdb76923b9543d96fb4c9dfd535d9cb5d";
    };
    deps = {
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
  by-spec."posix"."^2.0.0" =
    self.by-version."posix"."2.0.0";
  by-version."posix"."2.0.0" = self.buildNodePackage {
    name = "posix-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/posix/-/posix-2.0.0.tgz";
      name = "posix-2.0.0.tgz";
      sha1 = "90fd0ec73968d805c890b61ae6cc95ae5803a87d";
    };
    deps = {
      "nan-1.6.2" = self.by-version."nan"."1.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "posix" = self.by-version."posix"."2.0.0";
  by-spec."proxy-addr"."~1.0.7" =
    self.by-version."proxy-addr"."1.0.7";
  by-version."proxy-addr"."1.0.7" = self.buildNodePackage {
    name = "proxy-addr-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.7.tgz";
      name = "proxy-addr-1.0.7.tgz";
      sha1 = "6e2655aa9c56b014f09734a7e6d558cc77751939";
    };
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-0.1.9" = self.by-version."ipaddr.js"."0.1.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = self.buildNodePackage {
    name = "punycode-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
      name = "punycode-1.3.2.tgz";
      sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."q"."~1.0.0" =
    self.by-version."q"."1.0.1";
  by-version."q"."1.0.1" = self.buildNodePackage {
    name = "q-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/q/-/q-1.0.1.tgz";
      name = "q-1.0.1.tgz";
      sha1 = "11872aeedee89268110b10a718448ffb10112a14";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "q" = self.by-version."q"."1.0.1";
  by-spec."qs"."0.6.6" =
    self.by-version."qs"."0.6.6";
  by-version."qs"."0.6.6" = self.buildNodePackage {
    name = "qs-0.6.6";
    version = "0.6.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
      name = "qs-0.6.6.tgz";
      sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."2.4.1" =
    self.by-version."qs"."2.4.1";
  by-version."qs"."2.4.1" = self.buildNodePackage {
    name = "qs-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-2.4.1.tgz";
      name = "qs-2.4.1.tgz";
      sha1 = "68cbaea971013426a80c1404fad6b1a6b1175245";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~0.5.4" =
    self.by-version."qs"."0.5.6";
  by-version."qs"."0.5.6" = self.buildNodePackage {
    name = "qs-0.5.6";
    version = "0.5.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
      name = "qs-0.5.6.tgz";
      sha1 = "31b1ad058567651c526921506b9a8793911a0384";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~1.2.0" =
    self.by-version."qs"."1.2.2";
  by-version."qs"."1.2.2" = self.buildNodePackage {
    name = "qs-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-1.2.2.tgz";
      name = "qs-1.2.2.tgz";
      sha1 = "19b57ff24dc2a99ce1f8bdf6afcda59f8ef61f88";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~2.3.1" =
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
  by-spec."raw-body"."1.3.3" =
    self.by-version."raw-body"."1.3.3";
  by-version."raw-body"."1.3.3" = self.buildNodePackage {
    name = "raw-body-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/raw-body/-/raw-body-1.3.3.tgz";
      name = "raw-body-1.3.3.tgz";
      sha1 = "8841af3f64ad50a351dc77f229118b40c28fa58c";
    };
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "iconv-lite-0.4.7" = self.by-version."iconv-lite"."0.4.7";
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
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.33";
  by-version."readable-stream"."1.0.33" = self.buildNodePackage {
    name = "readable-stream-1.0.33";
    version = "1.0.33";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.33.tgz";
      name = "readable-stream-1.0.33.tgz";
      sha1 = "3a360dd66c1b1d7fd4705389860eda1d0f61126c";
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
  by-spec."readable-stream"."~1.1.8" =
    self.by-version."readable-stream"."1.1.13";
  by-version."readable-stream"."1.1.13" = self.buildNodePackage {
    name = "readable-stream-1.1.13";
    version = "1.1.13";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.13.tgz";
      name = "readable-stream-1.1.13.tgz";
      sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
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
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."redis"."^0.10.1" =
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
  "redis" = self.by-version."redis"."0.10.3";
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
  by-spec."request"."2.16.x" =
    self.by-version."request"."2.16.6";
  by-version."request"."2.16.6" = self.buildNodePackage {
    name = "request-2.16.6";
    version = "2.16.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.16.6.tgz";
      name = "request-2.16.6.tgz";
      sha1 = "872fe445ae72de266b37879d6ad7dc948fa01cad";
    };
    deps = {
      "form-data-0.0.10" = self.by-version."form-data"."0.0.10";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "hawk-0.10.2" = self.by-version."hawk"."0.10.2";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "cookie-jar-0.2.0" = self.by-version."cookie-jar"."0.2.0";
      "aws-sign-0.2.0" = self.by-version."aws-sign"."0.2.0";
      "oauth-sign-0.2.0" = self.by-version."oauth-sign"."0.2.0";
      "forever-agent-0.2.0" = self.by-version."forever-agent"."0.2.0";
      "tunnel-agent-0.2.0" = self.by-version."tunnel-agent"."0.2.0";
      "json-stringify-safe-3.0.0" = self.by-version."json-stringify-safe"."3.0.0";
      "qs-0.5.6" = self.by-version."qs"."0.5.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.34.0" =
    self.by-version."request"."2.53.0";
  by-version."request"."2.53.0" = self.buildNodePackage {
    name = "request-2.53.0";
    version = "2.53.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.53.0.tgz";
      name = "request-2.53.0.tgz";
      sha1 = "180a3ae92b7b639802e4f9545dd8fcdeb71d760c";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "request" = self.by-version."request"."2.53.0";
  by-spec."request"."^2.44.0" =
    self.by-version."request"."2.53.0";
  by-spec."request"."~2.42.0" =
    self.by-version."request"."2.42.0";
  by-version."request"."2.42.0" = self.buildNodePackage {
    name = "request-2.42.0";
    version = "2.42.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.42.0.tgz";
      name = "request-2.42.0.tgz";
      sha1 = "572bd0148938564040ac7ab148b96423a063304a";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.6.0" = self.by-version."caseless"."0.6.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "qs-1.2.2" = self.by-version."qs"."1.2.2";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
    };
    optionalDependencies = {
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.4.0" = self.by-version."oauth-sign"."0.4.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."response-time"."~2.3.0" =
    self.by-version."response-time"."2.3.0";
  by-version."response-time"."2.3.0" = self.buildNodePackage {
    name = "response-time-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/response-time/-/response-time-2.3.0.tgz";
      name = "response-time-2.3.0.tgz";
      sha1 = "27cf2194fa373ef02c04781287416a3138060b68";
    };
    deps = {
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ripple-lib"."0.12.0" =
    self.by-version."ripple-lib"."0.12.0";
  by-version."ripple-lib"."0.12.0" = self.buildNodePackage {
    name = "ripple-lib-0.12.0";
    version = "0.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ripple-lib/-/ripple-lib-0.12.0.tgz";
      name = "ripple-lib-0.12.0.tgz";
      sha1 = "8bbefa8250bf09e148c4997c27bbca70c7030b55";
    };
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "bignumber.js-2.0.3" = self.by-version."bignumber.js"."2.0.3";
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "lodash-3.5.0" = self.by-version."lodash"."3.5.0";
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "ripple-wallet-generator-1.0.1" = self.by-version."ripple-wallet-generator"."1.0.1";
      "ws-0.7.1" = self.by-version."ws"."0.7.1";
      "superagent-0.18.2" = self.by-version."superagent"."0.18.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ripple-lib" = self.by-version."ripple-lib"."0.12.0";
  by-spec."ripple-wallet-generator"."1.0.1" =
    self.by-version."ripple-wallet-generator"."1.0.1";
  by-version."ripple-wallet-generator"."1.0.1" = self.buildNodePackage {
    name = "ripple-wallet-generator-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ripple-wallet-generator/-/ripple-wallet-generator-1.0.1.tgz";
      name = "ripple-wallet-generator-1.0.1.tgz";
      sha1 = "fd9311c0c620c1bd51808a76a3f2a946293d459a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rndm"."~1.1.0" =
    self.by-version."rndm"."1.1.0";
  by-version."rndm"."1.1.0" = self.buildNodePackage {
    name = "rndm-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/rndm/-/rndm-1.1.0.tgz";
      name = "rndm-1.1.0.tgz";
      sha1 = "01d1a8f1fb9b471181925b627b9049bf33074574";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."scmp"."1.0.0" =
    self.by-version."scmp"."1.0.0";
  by-version."scmp"."1.0.0" = self.buildNodePackage {
    name = "scmp-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/scmp/-/scmp-1.0.0.tgz";
      name = "scmp-1.0.0.tgz";
      sha1 = "a0b272c3fc7292f77115646f00618b0262514e04";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."send"."0.12.2" =
    self.by-version."send"."0.12.2";
  by-version."send"."0.12.2" = self.buildNodePackage {
    name = "send-0.12.2";
    version = "0.12.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/send/-/send-0.12.2.tgz";
      name = "send-0.12.2.tgz";
      sha1 = "ba6785e47ab41aa0358b9da401ab22ff0f58eab6";
    };
    deps = {
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-favicon"."~2.2.0" =
    self.by-version."serve-favicon"."2.2.0";
  by-version."serve-favicon"."2.2.0" = self.buildNodePackage {
    name = "serve-favicon-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/serve-favicon/-/serve-favicon-2.2.0.tgz";
      name = "serve-favicon-2.2.0.tgz";
      sha1 = "a0c25ee8a652e1a638a67db46269cd52a8705858";
    };
    deps = {
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-index"."~1.6.3" =
    self.by-version."serve-index"."1.6.3";
  by-version."serve-index"."1.6.3" = self.buildNodePackage {
    name = "serve-index-1.6.3";
    version = "1.6.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/serve-index/-/serve-index-1.6.3.tgz";
      name = "serve-index-1.6.3.tgz";
      sha1 = "639056494ea59470a2c9518c28e7f225a342fd79";
    };
    deps = {
      "accepts-1.2.5" = self.by-version."accepts"."1.2.5";
      "batch-0.5.2" = self.by-version."batch"."0.5.2";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "http-errors-1.3.1" = self.by-version."http-errors"."1.3.1";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.9.2" =
    self.by-version."serve-static"."1.9.2";
  by-version."serve-static"."1.9.2" = self.buildNodePackage {
    name = "serve-static-1.9.2";
    version = "1.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/serve-static/-/serve-static-1.9.2.tgz";
      name = "serve-static-1.9.2.tgz";
      sha1 = "069fa32453557b218ec2e39140c82d8905d5672c";
    };
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.12.2" = self.by-version."send"."0.12.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.0";
  by-version."sigmund"."1.0.0" = self.buildNodePackage {
    name = "sigmund-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.0.tgz";
      name = "sigmund-1.0.0.tgz";
      sha1 = "66a2b3a749ae8b5fb89efd4fcc01dc94fbe02296";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sntp"."0.1.x" =
    self.by-version."sntp"."0.1.4";
  by-version."sntp"."0.1.4" = self.buildNodePackage {
    name = "sntp-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sntp/-/sntp-0.1.4.tgz";
      name = "sntp-0.1.4.tgz";
      sha1 = "5ef481b951a7b29affdf4afd7f26838fc1120f84";
    };
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = self.buildNodePackage {
    name = "sntp-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
      name = "sntp-0.2.4.tgz";
      sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sntp"."1.x.x" =
    self.by-version."sntp"."1.0.9";
  by-version."sntp"."1.0.9" = self.buildNodePackage {
    name = "sntp-1.0.9";
    version = "1.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
      name = "sntp-1.0.9.tgz";
      sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
    };
    deps = {
      "hoek-2.11.1" = self.by-version."hoek"."2.11.1";
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
  by-spec."statuses"."1" =
    self.by-version."statuses"."1.2.1";
  by-version."statuses"."1.2.1" = self.buildNodePackage {
    name = "statuses-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/statuses/-/statuses-1.2.1.tgz";
      name = "statuses-1.2.1.tgz";
      sha1 = "dded45cc18256d51ed40aec142489d5c61026d28";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-counter"."~0.2.0" =
    self.by-version."stream-counter"."0.2.0";
  by-version."stream-counter"."0.2.0" = self.buildNodePackage {
    name = "stream-counter-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stream-counter/-/stream-counter-0.2.0.tgz";
      name = "stream-counter-0.2.0.tgz";
      sha1 = "ded266556319c8b0e222812b9cf3b26fa7d947de";
    };
    deps = {
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
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
  by-spec."stringstream"."~0.0.4" =
    self.by-version."stringstream"."0.0.4";
  by-version."stringstream"."0.0.4" = self.buildNodePackage {
    name = "stringstream-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.4.tgz";
      name = "stringstream-0.0.4.tgz";
      sha1 = "0f0e3423f942960b5692ac324a57dd093bc41a92";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sugar"."~1.3.8" =
    self.by-version."sugar"."1.3.9";
  by-version."sugar"."1.3.9" = self.buildNodePackage {
    name = "sugar-1.3.9";
    version = "1.3.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sugar/-/sugar-1.3.9.tgz";
      name = "sugar-1.3.9.tgz";
      sha1 = "f879c6c87721252b51fd0b6520412d98d83cb179";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."superagent"."^0.18.0" =
    self.by-version."superagent"."0.18.2";
  by-version."superagent"."0.18.2" = self.buildNodePackage {
    name = "superagent-0.18.2";
    version = "0.18.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/superagent/-/superagent-0.18.2.tgz";
      name = "superagent-0.18.2.tgz";
      sha1 = "9afc6276a9475f4bdcd535ac6a0685ebc4b560eb";
    };
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
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."0.12.1";
  by-version."tough-cookie"."0.12.1" = self.buildNodePackage {
    name = "tough-cookie-0.12.1";
    version = "0.12.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
      name = "tough-cookie-0.12.1.tgz";
      sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
    };
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel-agent"."~0.2.0" =
    self.by-version."tunnel-agent"."0.2.0";
  by-version."tunnel-agent"."0.2.0" = self.buildNodePackage {
    name = "tunnel-agent-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.2.0.tgz";
      name = "tunnel-agent-0.2.0.tgz";
      sha1 = "6853c2afb1b2109e45629e492bde35f459ea69e8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel-agent"."~0.4.0" =
    self.by-version."tunnel-agent"."0.4.0";
  by-version."tunnel-agent"."0.4.0" = self.buildNodePackage {
    name = "tunnel-agent-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.0.tgz";
      name = "tunnel-agent-0.4.0.tgz";
      sha1 = "b1184e312ffbcf70b3b4c78e8c219de7ebb1c550";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."~1.6.1" =
    self.by-version."type-is"."1.6.1";
  by-version."type-is"."1.6.1" = self.buildNodePackage {
    name = "type-is-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/type-is/-/type-is-1.6.1.tgz";
      name = "type-is-1.6.1.tgz";
      sha1 = "49addecb0f6831cbc1d34ba929f0f3a4f21b0f2e";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uid-safe"."1.1.0" =
    self.by-version."uid-safe"."1.1.0";
  by-version."uid-safe"."1.1.0" = self.buildNodePackage {
    name = "uid-safe-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/uid-safe/-/uid-safe-1.1.0.tgz";
      name = "uid-safe-1.1.0.tgz";
      sha1 = "58d6c5dabf8dfbd8d52834839806c03fd6143232";
    };
    deps = {
      "base64-url-1.2.1" = self.by-version."base64-url"."1.2.1";
      "native-or-bluebird-1.1.2" = self.by-version."native-or-bluebird"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uid-safe"."~1.1.0" =
    self.by-version."uid-safe"."1.1.0";
  by-spec."ultron"."1.0.x" =
    self.by-version."ultron"."1.0.1";
  by-version."ultron"."1.0.1" = self.buildNodePackage {
    name = "ultron-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ultron/-/ultron-1.0.1.tgz";
      name = "ultron-1.0.1.tgz";
      sha1 = "c9d8d86c9cf2823028eb45629ab725897dd65dc5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."~1.4.4" =
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
  by-spec."underscore"."~1.7.0" =
    self.by-version."underscore"."1.7.0";
  by-version."underscore"."1.7.0" = self.buildNodePackage {
    name = "underscore-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.7.0.tgz";
      name = "underscore-1.7.0.tgz";
      sha1 = "6bbaf0877500d36be34ecaa584e0db9fef035209";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utf-8-validate"."1.0.x" =
    self.by-version."utf-8-validate"."1.0.1";
  by-version."utf-8-validate"."1.0.1" = self.buildNodePackage {
    name = "utf-8-validate-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/utf-8-validate/-/utf-8-validate-1.0.1.tgz";
      name = "utf-8-validate-1.0.1.tgz";
      sha1 = "d15eb67e28f6bb93c9401eeb7eac7030a183e8d1";
    };
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.6.2" = self.by-version."nan"."1.6.2";
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
    self.by-version."vary"."1.0.0";
  by-version."vary"."1.0.0" = self.buildNodePackage {
    name = "vary-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/vary/-/vary-1.0.0.tgz";
      name = "vary-1.0.0.tgz";
      sha1 = "c5e76cec20d3820d8f2a96e7bee38731c34da1e7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vhost"."~3.0.0" =
    self.by-version."vhost"."3.0.0";
  by-version."vhost"."3.0.0" = self.buildNodePackage {
    name = "vhost-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/vhost/-/vhost-3.0.0.tgz";
      name = "vhost-3.0.0.tgz";
      sha1 = "2d0ec59a3e012278b65adbe17c1717a5a5023045";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."winston"."~0.7.2" =
    self.by-version."winston"."0.7.3";
  by-version."winston"."0.7.3" = self.buildNodePackage {
    name = "winston-0.7.3";
    version = "0.7.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/winston/-/winston-0.7.3.tgz";
      name = "winston-0.7.3.tgz";
      sha1 = "7ae313ba73fcdc2ecb4aa2f9cd446e8298677266";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "request-2.16.6" = self.by-version."request"."2.16.6";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "winston" = self.by-version."winston"."0.7.3";
  by-spec."ws"."~0.7.1" =
    self.by-version."ws"."0.7.1";
  by-version."ws"."0.7.1" = self.buildNodePackage {
    name = "ws-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ws/-/ws-0.7.1.tgz";
      name = "ws-0.7.1.tgz";
      sha1 = "8f1c7864ca08081be3cd0ac330df0d29c5fcd0da";
    };
    deps = {
      "options-0.0.6" = self.by-version."options"."0.0.6";
      "ultron-1.0.1" = self.by-version."ultron"."1.0.1";
    };
    optionalDependencies = {
      "bufferutil-1.0.1" = self.by-version."bufferutil"."1.0.1";
      "utf-8-validate-1.0.1" = self.by-version."utf-8-validate"."1.0.1";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
