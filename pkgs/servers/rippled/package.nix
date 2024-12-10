{
  self,
  fetchurl ? null,
}:

{
  by-spec."abbrev"."1" = self.by-version."abbrev"."1.0.5";
  by-version."abbrev"."1.0.5" = self.buildNodePackage {
    name = "abbrev-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.5.tgz";
      name = "abbrev-1.0.5.tgz";
      sha1 = "5d8257bd9ebe435e698b2fa431afde4fe7b10b03";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abbrev"."1.0.x" = self.by-version."abbrev"."1.0.5";
  by-spec."accepts"."~1.2.5" = self.by-version."accepts"."1.2.7";
  by-version."accepts"."1.2.7" = self.buildNodePackage {
    name = "accepts-1.2.7";
    version = "1.2.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/accepts/-/accepts-1.2.7.tgz";
      name = "accepts-1.2.7.tgz";
      sha1 = "efea24e36e0b5b93d001a7598ac441c32ef56003";
    };
    deps = {
      "mime-types-2.0.11" = self.by-version."mime-types"."2.0.11";
      "negotiator-0.5.3" = self.by-version."negotiator"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."accepts"."~1.2.7" = self.by-version."accepts"."1.2.7";
  by-spec."amdefine".">=0.0.4" = self.by-version."amdefine"."0.1.0";
  by-version."amdefine"."0.1.0" = self.buildNodePackage {
    name = "amdefine-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/amdefine/-/amdefine-0.1.0.tgz";
      name = "amdefine-0.1.0.tgz";
      sha1 = "3ca9735cf1dde0edf7a4bf6641709c8024f9b227";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi"."^0.3.0" = self.by-version."ansi"."0.3.0";
  by-version."ansi"."0.3.0" = self.buildNodePackage {
    name = "ansi-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi/-/ansi-0.3.0.tgz";
      name = "ansi-0.3.0.tgz";
      sha1 = "74b2f1f187c8553c7f95015bcb76009fb43d38e0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi"."~0.3.0" = self.by-version."ansi"."0.3.0";
  by-spec."ansi-regex"."^0.2.0" = self.by-version."ansi-regex"."0.2.1";
  by-version."ansi-regex"."0.2.1" = self.buildNodePackage {
    name = "ansi-regex-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-0.2.1.tgz";
      name = "ansi-regex-0.2.1.tgz";
      sha1 = "0d8e946967a3d8143f93e24e298525fc1b2235f9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^0.2.1" = self.by-version."ansi-regex"."0.2.1";
  by-spec."ansi-regex"."^1.0.0" = self.by-version."ansi-regex"."1.1.1";
  by-version."ansi-regex"."1.1.1" = self.buildNodePackage {
    name = "ansi-regex-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-1.1.1.tgz";
      name = "ansi-regex-1.1.1.tgz";
      sha1 = "41c847194646375e6a1a5d10c3ca054ef9fc980d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^1.1.0" = self.by-version."ansi-regex"."1.1.1";
  by-spec."ansi-styles"."^1.1.0" = self.by-version."ansi-styles"."1.1.0";
  by-version."ansi-styles"."1.1.0" = self.buildNodePackage {
    name = "ansi-styles-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-1.1.0.tgz";
      name = "ansi-styles-1.1.0.tgz";
      sha1 = "eaecbf66cd706882760b2f4691582b8f55d7a7de";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-styles"."^2.0.1" = self.by-version."ansi-styles"."2.0.1";
  by-version."ansi-styles"."2.0.1" = self.buildNodePackage {
    name = "ansi-styles-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.0.1.tgz";
      name = "ansi-styles-2.0.1.tgz";
      sha1 = "b033f57f93e2d28adeb8bc11138fa13da0fd20a3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."are-we-there-yet"."~1.0.0" = self.by-version."are-we-there-yet"."1.0.4";
  by-version."are-we-there-yet"."1.0.4" = self.buildNodePackage {
    name = "are-we-there-yet-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.0.4.tgz";
      name = "are-we-there-yet-1.0.4.tgz";
      sha1 = "527fe389f7bcba90806106b99244eaa07e886f85";
    };
    deps = {
      "delegates-0.1.0" = self.by-version."delegates"."0.1.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."argparse"."~ 0.1.11" = self.by-version."argparse"."0.1.16";
  by-version."argparse"."0.1.16" = self.buildNodePackage {
    name = "argparse-0.1.16";
    version = "0.1.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/argparse/-/argparse-0.1.16.tgz";
      name = "argparse-0.1.16.tgz";
      sha1 = "cfd01e0fbba3d6caed049fbd758d40f65196f57c";
    };
    deps = {
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
      "underscore.string-2.4.0" = self.by-version."underscore.string"."2.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."argparse"."~1.0.2" = self.by-version."argparse"."1.0.2";
  by-version."argparse"."1.0.2" = self.buildNodePackage {
    name = "argparse-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/argparse/-/argparse-1.0.2.tgz";
      name = "argparse-1.0.2.tgz";
      sha1 = "bcfae39059656d1973d0b9e6a1a74154b5a9a136";
    };
    deps = {
      "lodash-3.8.0" = self.by-version."lodash"."3.8.0";
      "sprintf-js-1.0.2" = self.by-version."sprintf-js"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asn1"."0.1.11" = self.by-version."asn1"."0.1.11";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-diff"."^0.0.4" = self.by-version."assert-diff"."0.0.4";
  by-version."assert-diff"."0.0.4" = self.buildNodePackage {
    name = "assert-diff-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-diff/-/assert-diff-0.0.4.tgz";
      name = "assert-diff-0.0.4.tgz";
      sha1 = "bf181c1575d5ad7c73df8076a689f4ae19951608";
    };
    deps = {
      "assert-plus-0.1.4" = self.by-version."assert-plus"."0.1.4";
      "json-diff-0.3.1" = self.by-version."json-diff"."0.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "assert-diff" = self.by-version."assert-diff"."0.0.4";
  by-spec."assert-plus"."0.1.4" = self.by-version."assert-plus"."0.1.4";
  by-version."assert-plus"."0.1.4" = self.buildNodePackage {
    name = "assert-plus-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.4.tgz";
      name = "assert-plus-0.1.4.tgz";
      sha1 = "283eff8b140ecd768529fbf3730a4c09ebec61f7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."^0.1.5" = self.by-version."assert-plus"."0.1.5";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assertion-error"."1.0.0" = self.by-version."assertion-error"."1.0.0";
  by-version."assertion-error"."1.0.0" = self.buildNodePackage {
    name = "assertion-error-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assertion-error/-/assertion-error-1.0.0.tgz";
      name = "assertion-error-1.0.0.tgz";
      sha1 = "c7f85438fdd466bc7ca16ab90c81513797a5d23b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."0.2.9" = self.by-version."async"."0.2.9";
  by-version."async"."0.2.9" = self.buildNodePackage {
    name = "async-0.2.9";
    version = "0.2.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.2.9.tgz";
      name = "async-0.2.9.tgz";
      sha1 = "df63060fbf3d33286a76aaf6d55a2986d9ff8619";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."0.9.x" = self.by-version."async"."0.9.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."^0.2.9" = self.by-version."async"."0.2.10";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "async" = self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.6" = self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.9" = self.by-version."async"."0.2.10";
  by-spec."async"."~0.9.0" = self.by-version."async"."0.9.0";
  by-spec."aws-sign2"."~0.5.0" = self.by-version."aws-sign2"."0.5.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."balanced-match"."^0.2.0" = self.by-version."balanced-match"."0.2.0";
  by-version."balanced-match"."0.2.0" = self.buildNodePackage {
    name = "balanced-match-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.2.0.tgz";
      name = "balanced-match-0.2.0.tgz";
      sha1 = "38f6730c03aab6d5edbb52bd934885e756d71674";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."basic-auth"."~1.0.1" = self.by-version."basic-auth"."1.0.1";
  by-version."basic-auth"."1.0.1" = self.buildNodePackage {
    name = "basic-auth-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/basic-auth/-/basic-auth-1.0.1.tgz";
      name = "basic-auth-1.0.1.tgz";
      sha1 = "4bae1dbfbf0aec4dc5dc47a8d3675b50140f3bf8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bignumber.js"."^1.4.0" = self.by-version."bignumber.js"."1.5.0";
  by-version."bignumber.js"."1.5.0" = self.buildNodePackage {
    name = "bignumber.js-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bignumber.js/-/bignumber.js-1.5.0.tgz";
      name = "bignumber.js-1.5.0.tgz";
      sha1 = "ff41453ac7b19ee15cda7977e179ff1b0d11956d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "bignumber.js" = self.by-version."bignumber.js"."1.5.0";
  by-spec."bignumber.js"."^2.0.3" = self.by-version."bignumber.js"."2.0.7";
  by-version."bignumber.js"."2.0.7" = self.buildNodePackage {
    name = "bignumber.js-2.0.7";
    version = "2.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bignumber.js/-/bignumber.js-2.0.7.tgz";
      name = "bignumber.js-2.0.7.tgz";
      sha1 = "86eb0707cf6a5110909d23e6ea7434c14f500f1c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bignumber.js"."~1.4.0" = self.by-version."bignumber.js"."1.4.1";
  by-version."bignumber.js"."1.4.1" = self.buildNodePackage {
    name = "bignumber.js-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bignumber.js/-/bignumber.js-1.4.1.tgz";
      name = "bignumber.js-1.4.1.tgz";
      sha1 = "3d19ac321f8db4ba07aace23ebd4ac976fae6bfa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bindings"."1.2.x" = self.by-version."bindings"."1.2.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."~0.9.0" = self.by-version."bl"."0.9.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."block-stream"."*" = self.by-version."block-stream"."0.0.7";
  by-version."block-stream"."0.0.7" = self.buildNodePackage {
    name = "block-stream-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
      name = "block-stream-0.0.7.tgz";
      sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."^2.0.0" = self.by-version."bluebird"."2.9.25";
  by-version."bluebird"."2.9.25" = self.buildNodePackage {
    name = "bluebird-2.9.25";
    version = "2.9.25";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.25.tgz";
      name = "bluebird-2.9.25.tgz";
      sha1 = "6e36bd04064d9534c07160b9f7f26c5a738fe16a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."^2.3.4" = self.by-version."bluebird"."2.9.25";
  "bluebird" = self.by-version."bluebird"."2.9.25";
  by-spec."bluebird"."^2.9.25" = self.by-version."bluebird"."2.9.25";
  by-spec."body-parser"."^1.7.0" = self.by-version."body-parser"."1.12.4";
  by-version."body-parser"."1.12.4" = self.buildNodePackage {
    name = "body-parser-1.12.4";
    version = "1.12.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/body-parser/-/body-parser-1.12.4.tgz";
      name = "body-parser-1.12.4.tgz";
      sha1 = "090700c4ba28862a8520ef378395fdee5f61c229";
    };
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "iconv-lite-0.4.8" = self.by-version."iconv-lite"."0.4.8";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "qs-2.4.2" = self.by-version."qs"."2.4.2";
      "raw-body-2.0.1" = self.by-version."raw-body"."2.0.1";
      "type-is-1.6.2" = self.by-version."type-is"."1.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "body-parser" = self.by-version."body-parser"."1.12.4";
  by-spec."boom"."0.4.x" = self.by-version."boom"."0.4.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."2.x.x" = self.by-version."boom"."2.7.1";
  by-version."boom"."2.7.1" = self.buildNodePackage {
    name = "boom-2.7.1";
    version = "2.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-2.7.1.tgz";
      name = "boom-2.7.1.tgz";
      sha1 = "fb165c348d337977c61d4363c21e9e1abf526705";
    };
    deps = {
      "hoek-2.13.0" = self.by-version."hoek"."2.13.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.0.0" = self.by-version."brace-expansion"."1.1.0";
  by-version."brace-expansion"."1.1.0" = self.buildNodePackage {
    name = "brace-expansion-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.0.tgz";
      name = "brace-expansion-1.1.0.tgz";
      sha1 = "c9b7d03c03f37bc704be100e522b40db8f6cfcd9";
    };
    deps = {
      "balanced-match-0.2.0" = self.by-version."balanced-match"."0.2.0";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bufferutil"."1.0.x" = self.by-version."bufferutil"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytes"."1.0.0" = self.by-version."bytes"."1.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytes"."2.0.1" = self.by-version."bytes"."2.0.1";
  by-version."bytes"."2.0.1" = self.buildNodePackage {
    name = "bytes-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bytes/-/bytes-2.0.1.tgz";
      name = "bytes-2.0.1.tgz";
      sha1 = "673743059be43d929f9c225dd7363ee0f8b15d97";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.9.0" = self.by-version."caseless"."0.9.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chai".">=1.9.2 <3" = self.by-version."chai"."2.3.0";
  by-version."chai"."2.3.0" = self.buildNodePackage {
    name = "chai-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chai/-/chai-2.3.0.tgz";
      name = "chai-2.3.0.tgz";
      sha1 = "8a2f6a34748da801090fd73287b2aa739a4e909a";
    };
    deps = {
      "assertion-error-1.0.0" = self.by-version."assertion-error"."1.0.0";
      "deep-eql-0.1.3" = self.by-version."deep-eql"."0.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chai"."^1.10.0" = self.by-version."chai"."1.10.0";
  by-version."chai"."1.10.0" = self.buildNodePackage {
    name = "chai-1.10.0";
    version = "1.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chai/-/chai-1.10.0.tgz";
      name = "chai-1.10.0.tgz";
      sha1 = "e4031cc87654461a75943e5a35ab46eaf39c1eb9";
    };
    deps = {
      "assertion-error-1.0.0" = self.by-version."assertion-error"."1.0.0";
      "deep-eql-0.1.3" = self.by-version."deep-eql"."0.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "chai" = self.by-version."chai"."1.10.0";
  by-spec."chalk"."^1.0.0" = self.by-version."chalk"."1.0.0";
  by-version."chalk"."1.0.0" = self.buildNodePackage {
    name = "chalk-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-1.0.0.tgz";
      name = "chalk-1.0.0.tgz";
      sha1 = "b3cf4ed0ff5397c99c75b8f679db2f52831f96dc";
    };
    deps = {
      "ansi-styles-2.0.1" = self.by-version."ansi-styles"."2.0.1";
      "escape-string-regexp-1.0.3" = self.by-version."escape-string-regexp"."1.0.3";
      "has-ansi-1.0.3" = self.by-version."has-ansi"."1.0.3";
      "strip-ansi-2.0.1" = self.by-version."strip-ansi"."2.0.1";
      "supports-color-1.3.1" = self.by-version."supports-color"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."~0.5.1" = self.by-version."chalk"."0.5.1";
  by-version."chalk"."0.5.1" = self.buildNodePackage {
    name = "chalk-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-0.5.1.tgz";
      name = "chalk-0.5.1.tgz";
      sha1 = "663b3a648b68b55d04690d49167aa837858f2174";
    };
    deps = {
      "ansi-styles-1.1.0" = self.by-version."ansi-styles"."1.1.0";
      "escape-string-regexp-1.0.3" = self.by-version."escape-string-regexp"."1.0.3";
      "has-ansi-0.1.0" = self.by-version."has-ansi"."0.1.0";
      "strip-ansi-0.3.0" = self.by-version."strip-ansi"."0.3.0";
      "supports-color-0.2.0" = self.by-version."supports-color"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cli-color"."~0.1.6" = self.by-version."cli-color"."0.1.7";
  by-version."cli-color"."0.1.7" = self.buildNodePackage {
    name = "cli-color-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cli-color/-/cli-color-0.1.7.tgz";
      name = "cli-color-0.1.7.tgz";
      sha1 = "adc3200fa471cc211b0da7f566b71e98b9d67347";
    };
    deps = {
      "es5-ext-0.8.2" = self.by-version."es5-ext"."0.8.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."colors"."1.0.x" = self.by-version."colors"."1.0.3";
  by-version."colors"."1.0.3" = self.buildNodePackage {
    name = "colors-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
      name = "colors-1.0.3.tgz";
      sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."~0.0.4" = self.by-version."combined-stream"."0.0.7";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."~0.0.5" = self.by-version."combined-stream"."0.0.7";
  by-spec."commander"."0.6.1" = self.by-version."commander"."0.6.1";
  by-version."commander"."0.6.1" = self.buildNodePackage {
    name = "commander-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
      name = "commander-0.6.1.tgz";
      sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."2.3.0" = self.by-version."commander"."2.3.0";
  by-version."commander"."2.3.0" = self.buildNodePackage {
    name = "commander-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.3.0.tgz";
      name = "commander-2.3.0.tgz";
      sha1 = "fd430e889832ec353b9acd1de217c11cb3eef873";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."^2.2.0" = self.by-version."commander"."2.8.1";
  by-version."commander"."2.8.1" = self.buildNodePackage {
    name = "commander-2.8.1";
    version = "2.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.8.1.tgz";
      name = "commander-2.8.1.tgz";
      sha1 = "06be367febfda0c330aa1e2a072d3dc9762425d4";
    };
    deps = {
      "graceful-readlink-1.0.1" = self.by-version."graceful-readlink"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."^2.8.1" = self.by-version."commander"."2.8.1";
  by-spec."commander"."~2.1.0" = self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = self.buildNodePackage {
    name = "commander-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
      name = "commander-2.1.0.tgz";
      sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-emitter"."1.1.2" = self.by-version."component-emitter"."1.1.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."compressible"."~2.0.2" = self.by-version."compressible"."2.0.2";
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
      "mime-db-1.9.1" = self.by-version."mime-db"."1.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."compression"."^1.3.0" = self.by-version."compression"."1.4.4";
  by-version."compression"."1.4.4" = self.buildNodePackage {
    name = "compression-1.4.4";
    version = "1.4.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/compression/-/compression-1.4.4.tgz";
      name = "compression-1.4.4.tgz";
      sha1 = "2f9994ca476e4d9ba5fdc67ac929942837d0b6a4";
    };
    deps = {
      "accepts-1.2.7" = self.by-version."accepts"."1.2.7";
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "compressible-2.0.2" = self.by-version."compressible"."2.0.2";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "on-headers-1.0.0" = self.by-version."on-headers"."1.0.0";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "compression" = self.by-version."compression"."1.4.4";
  by-spec."concat-map"."0.0.1" = self.by-version."concat-map"."0.0.1";
  by-version."concat-map"."0.0.1" = self.buildNodePackage {
    name = "concat-map-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
      name = "concat-map-0.0.1.tgz";
      sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-disposition"."0.5.0" = self.by-version."content-disposition"."0.5.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-type"."~1.0.1" = self.by-version."content-type"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie"."0.1.2" = self.by-version."cookie"."0.1.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-signature"."1.0.6" = self.by-version."cookie-signature"."1.0.6";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookiejar"."1.3.2" = self.by-version."cookiejar"."1.3.2";
  by-version."cookiejar"."1.3.2" = self.buildNodePackage {
    name = "cookiejar-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookiejar/-/cookiejar-1.3.2.tgz";
      name = "cookiejar-1.3.2.tgz";
      sha1 = "61d3229e2da20c859032233502958a9b7df58249";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."core-util-is"."~1.0.0" = self.by-version."core-util-is"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."coveralls"."^2.10.0" = self.by-version."coveralls"."2.11.2";
  by-version."coveralls"."2.11.2" = self.buildNodePackage {
    name = "coveralls-2.11.2";
    version = "2.11.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/coveralls/-/coveralls-2.11.2.tgz";
      name = "coveralls-2.11.2.tgz";
      sha1 = "d4d982016cb2f9da89d77ab204d86a8537e6a12d";
    };
    deps = {
      "js-yaml-3.0.1" = self.by-version."js-yaml"."3.0.1";
      "lcov-parse-0.0.6" = self.by-version."lcov-parse"."0.0.6";
      "log-driver-1.2.4" = self.by-version."log-driver"."1.2.4";
      "request-2.40.0" = self.by-version."request"."2.40.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "coveralls" = self.by-version."coveralls"."2.11.2";
  by-spec."crc"."3.2.1" = self.by-version."crc"."3.2.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."0.2.x" = self.by-version."cryptiles"."0.2.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."2.x.x" = self.by-version."cryptiles"."2.0.4";
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
      "boom-2.7.1" = self.by-version."boom"."2.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ctype"."0.5.3" = self.by-version."ctype"."0.5.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cycle"."1.0.x" = self.by-version."cycle"."1.0.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."2.0.0" = self.by-version."debug"."2.0.0";
  by-version."debug"."2.0.0" = self.buildNodePackage {
    name = "debug-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-2.0.0.tgz";
      name = "debug-2.0.0.tgz";
      sha1 = "89bd9df6732b51256bc6705342bba02ed12131ef";
    };
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."~0.7.2" = self.by-version."debug"."0.7.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."~2.1.3" = self.by-version."debug"."2.1.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."~2.2.0" = self.by-version."debug"."2.2.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-eql"."0.1.3" = self.by-version."deep-eql"."0.1.3";
  by-version."deep-eql"."0.1.3" = self.buildNodePackage {
    name = "deep-eql-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-eql/-/deep-eql-0.1.3.tgz";
      name = "deep-eql-0.1.3.tgz";
      sha1 = "ef558acab8de25206cd713906d74e56930eb69f2";
    };
    deps = {
      "type-detect-0.1.1" = self.by-version."type-detect"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-extend"."~0.2.5" = self.by-version."deep-extend"."0.2.11";
  by-version."deep-extend"."0.2.11" = self.buildNodePackage {
    name = "deep-extend-0.2.11";
    version = "0.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.11.tgz";
      name = "deep-extend-0.2.11.tgz";
      sha1 = "7a16ba69729132340506170494bc83f7076fe08f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."delayed-stream"."0.0.5" = self.by-version."delayed-stream"."0.0.5";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."delegates"."^0.1.0" = self.by-version."delegates"."0.1.0";
  by-version."delegates"."0.1.0" = self.buildNodePackage {
    name = "delegates-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/delegates/-/delegates-0.1.0.tgz";
      name = "delegates-0.1.0.tgz";
      sha1 = "b4b57be11a1653517a04b27f0949bdc327dfe390";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."depd"."~1.0.0" = self.by-version."depd"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."depd"."~1.0.1" = self.by-version."depd"."1.0.1";
  by-spec."destroy"."1.0.3" = self.by-version."destroy"."1.0.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."diff"."1.0.8" = self.by-version."diff"."1.0.8";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."difflib"."~0.2.1" = self.by-version."difflib"."0.2.4";
  by-version."difflib"."0.2.4" = self.buildNodePackage {
    name = "difflib-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/difflib/-/difflib-0.2.4.tgz";
      name = "difflib-0.2.4.tgz";
      sha1 = "b5e30361a6db023176d562892db85940a718f47e";
    };
    deps = {
      "heap-0.2.6" = self.by-version."heap"."0.2.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dreamopt"."~0.6.0" = self.by-version."dreamopt"."0.6.0";
  by-version."dreamopt"."0.6.0" = self.buildNodePackage {
    name = "dreamopt-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dreamopt/-/dreamopt-0.6.0.tgz";
      name = "dreamopt-0.6.0.tgz";
      sha1 = "d813ccdac8d39d8ad526775514a13dda664d6b4b";
    };
    deps = {
      "wordwrap-1.0.0" = self.by-version."wordwrap"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ee-first"."1.1.0" = self.by-version."ee-first"."1.1.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."0.8.x" = self.by-version."es5-ext"."0.8.2";
  by-version."es5-ext"."0.8.2" = self.buildNodePackage {
    name = "es5-ext-0.8.2";
    version = "0.8.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/es5-ext/-/es5-ext-0.8.2.tgz";
      name = "es5-ext-0.8.2.tgz";
      sha1 = "aba8d9e1943a895ac96837a62a39b3f55ecd94ab";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-html"."1.0.1" = self.by-version."escape-html"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
  by-version."escape-string-regexp"."1.0.2" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.2.tgz";
      name = "escape-string-regexp-1.0.2.tgz";
      sha1 = "4dbc2fe674e71949caf3fb2695ce7f2dc1d9a8d1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."^1.0.0" = self.by-version."escape-string-regexp"."1.0.3";
  by-version."escape-string-regexp"."1.0.3" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.3.tgz";
      name = "escape-string-regexp-1.0.3.tgz";
      sha1 = "9e2d8b25bc2555c3336723750e03f099c2735bb5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."^1.0.2" = self.by-version."escape-string-regexp"."1.0.3";
  by-spec."escodegen"."1.3.x" = self.by-version."escodegen"."1.3.3";
  by-version."escodegen"."1.3.3" = self.buildNodePackage {
    name = "escodegen-1.3.3";
    version = "1.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/escodegen/-/escodegen-1.3.3.tgz";
      name = "escodegen-1.3.3.tgz";
      sha1 = "f024016f5a88e046fd12005055e939802e6c5f23";
    };
    deps = {
      "esutils-1.0.0" = self.by-version."esutils"."1.0.0";
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "esprima-1.1.1" = self.by-version."esprima"."1.1.1";
    };
    optionalDependencies = {
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."1.2.x" = self.by-version."esprima"."1.2.5";
  by-version."esprima"."1.2.5" = self.buildNodePackage {
    name = "esprima-1.2.5";
    version = "1.2.5";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/esprima/-/esprima-1.2.5.tgz";
      name = "esprima-1.2.5.tgz";
      sha1 = "0993502feaf668138325756f30f9a51feeec11e9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."~ 1.0.2" = self.by-version."esprima"."1.0.4";
  by-version."esprima"."1.0.4" = self.buildNodePackage {
    name = "esprima-1.0.4";
    version = "1.0.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
      name = "esprima-1.0.4.tgz";
      sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."~1.1.1" = self.by-version."esprima"."1.1.1";
  by-version."esprima"."1.1.1" = self.buildNodePackage {
    name = "esprima-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/esprima/-/esprima-1.1.1.tgz";
      name = "esprima-1.1.1.tgz";
      sha1 = "5b6f1547f4d102e670e140c509be6771d6aeb549";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."~2.2.0" = self.by-version."esprima"."2.2.0";
  by-version."esprima"."2.2.0" = self.buildNodePackage {
    name = "esprima-2.2.0";
    version = "2.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/esprima/-/esprima-2.2.0.tgz";
      name = "esprima-2.2.0.tgz";
      sha1 = "4292c1d68e4173d815fa2290dc7afc96d81fcd83";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."estraverse"."~1.5.0" = self.by-version."estraverse"."1.5.1";
  by-version."estraverse"."1.5.1" = self.buildNodePackage {
    name = "estraverse-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/estraverse/-/estraverse-1.5.1.tgz";
      name = "estraverse-1.5.1.tgz";
      sha1 = "867a3e8e58a9f84618afb6c2ddbcd916b7cbaf71";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esutils"."~1.0.0" = self.by-version."esutils"."1.0.0";
  by-version."esutils"."1.0.0" = self.buildNodePackage {
    name = "esutils-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/esutils/-/esutils-1.0.0.tgz";
      name = "esutils-1.0.0.tgz";
      sha1 = "8151d358e20c8acc7fb745e7472c0025fe496570";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."etag"."~1.5.1" = self.by-version."etag"."1.5.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."^4.8.7" = self.by-version."express"."4.12.3";
  by-version."express"."4.12.3" = self.buildNodePackage {
    name = "express-4.12.3";
    version = "4.12.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/express/-/express-4.12.3.tgz";
      name = "express-4.12.3.tgz";
      sha1 = "6b9d94aec5ae03270d86d390c277a8c5a5ad0ee2";
    };
    deps = {
      "accepts-1.2.7" = self.by-version."accepts"."1.2.7";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.1.3" = self.by-version."debug"."2.1.3";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "finalhandler-0.3.4" = self.by-version."finalhandler"."0.3.4";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "merge-descriptors-1.0.0" = self.by-version."merge-descriptors"."1.0.0";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.8" = self.by-version."proxy-addr"."1.0.8";
      "qs-2.4.1" = self.by-version."qs"."2.4.1";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.12.2" = self.by-version."send"."0.12.2";
      "serve-static-1.9.2" = self.by-version."serve-static"."1.9.2";
      "type-is-1.6.2" = self.by-version."type-is"."1.6.2";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."4.12.3";
  by-spec."extend"."~1.2.1" = self.by-version."extend"."1.2.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extend"."~1.3.0" = self.by-version."extend"."1.3.0";
  by-version."extend"."1.3.0" = self.buildNodePackage {
    name = "extend-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extend/-/extend-1.3.0.tgz";
      name = "extend-1.3.0.tgz";
      sha1 = "d1516fb0ff5624d2ebf9123ea1dac5a1994004f8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eyes"."0.1.x" = self.by-version."eyes"."0.1.8";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fileset"."0.1.x" = self.by-version."fileset"."0.1.5";
  by-version."fileset"."0.1.5" = self.buildNodePackage {
    name = "fileset-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fileset/-/fileset-0.1.5.tgz";
      name = "fileset-0.1.5.tgz";
      sha1 = "acc423bfaf92843385c66bf75822264d11b7bd94";
    };
    deps = {
      "minimatch-0.4.0" = self.by-version."minimatch"."0.4.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."finalhandler"."0.3.4" = self.by-version."finalhandler"."0.3.4";
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
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."findup-sync"."~0.1.2" = self.by-version."findup-sync"."0.1.3";
  by-version."findup-sync"."0.1.3" = self.buildNodePackage {
    name = "findup-sync-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.3.tgz";
      name = "findup-sync-0.1.3.tgz";
      sha1 = "7f3e7a97b82392c653bf06589bd85190e93c3683";
    };
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."flagged-respawn"."~0.3.0" = self.by-version."flagged-respawn"."0.3.1";
  by-version."flagged-respawn"."0.3.1" = self.buildNodePackage {
    name = "flagged-respawn-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/flagged-respawn/-/flagged-respawn-0.3.1.tgz";
      name = "flagged-respawn-0.3.1.tgz";
      sha1 = "397700925df6e12452202a71e89d89545fbbbe9d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.5.0" = self.by-version."forever-agent"."0.5.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.6.0" = self.by-version."forever-agent"."0.6.1";
  by-version."forever-agent"."0.6.1" = self.buildNodePackage {
    name = "forever-agent-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
      name = "forever-agent-0.6.1.tgz";
      sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."0.1.2" = self.by-version."form-data"."0.1.2";
  by-version."form-data"."0.1.2" = self.buildNodePackage {
    name = "form-data-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.1.2.tgz";
      name = "form-data-0.1.2.tgz";
      sha1 = "1143c21357911a78dd7913b189b4bab5d5d57445";
    };
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.2.10" = self.by-version."async"."0.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~0.1.0" = self.by-version."form-data"."0.1.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~0.2.0" = self.by-version."form-data"."0.2.0";
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
      "mime-types-2.0.11" = self.by-version."mime-types"."2.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."formatio"."1.1.1" = self.by-version."formatio"."1.1.1";
  by-version."formatio"."1.1.1" = self.buildNodePackage {
    name = "formatio-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/formatio/-/formatio-1.1.1.tgz";
      name = "formatio-1.1.1.tgz";
      sha1 = "5ed3ccd636551097383465d996199100e86161e9";
    };
    deps = {
      "samsam-1.1.2" = self.by-version."samsam"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."formatio"."~1.0" = self.by-version."formatio"."1.0.2";
  by-version."formatio"."1.0.2" = self.buildNodePackage {
    name = "formatio-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/formatio/-/formatio-1.0.2.tgz";
      name = "formatio-1.0.2.tgz";
      sha1 = "e7991ca144ff7d8cff07bb9ac86a9b79c6ba47ef";
    };
    deps = {
      "samsam-1.1.2" = self.by-version."samsam"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."formidable"."1.0.14" = self.by-version."formidable"."1.0.14";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forwarded"."~0.1.0" = self.by-version."forwarded"."0.1.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fresh"."0.2.4" = self.by-version."fresh"."0.2.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.2" = self.by-version."fstream"."1.0.6";
  by-version."fstream"."1.0.6" = self.buildNodePackage {
    name = "fstream-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fstream/-/fstream-1.0.6.tgz";
      name = "fstream-1.0.6.tgz";
      sha1 = "817e50312fb4ed90da865c8eb5ecd1d1d7aed0ec";
    };
    deps = {
      "graceful-fs-3.0.6" = self.by-version."graceful-fs"."3.0.6";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "rimraf-2.3.3" = self.by-version."rimraf"."2.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."~0.1.17" = self.by-version."fstream"."0.1.31";
  by-version."fstream"."0.1.31" = self.buildNodePackage {
    name = "fstream-0.1.31";
    version = "0.1.31";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fstream/-/fstream-0.1.31.tgz";
      name = "fstream-0.1.31.tgz";
      sha1 = "7337f058fbbbbefa8c9f561a28cab0849202c988";
    };
    deps = {
      "graceful-fs-3.0.6" = self.by-version."graceful-fs"."3.0.6";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "rimraf-2.3.3" = self.by-version."rimraf"."2.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."~0.1.22" = self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~0.1.28" = self.by-version."fstream"."0.1.31";
  by-spec."fstream-ignore"."0.0.7" = self.by-version."fstream-ignore"."0.0.7";
  by-version."fstream-ignore"."0.0.7" = self.buildNodePackage {
    name = "fstream-ignore-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-0.0.7.tgz";
      name = "fstream-ignore-0.0.7.tgz";
      sha1 = "eea3033f0c3728139de7b57ab1b0d6d89c353c63";
    };
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gauge"."~1.2.0" = self.by-version."gauge"."1.2.0";
  by-version."gauge"."1.2.0" = self.buildNodePackage {
    name = "gauge-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gauge/-/gauge-1.2.0.tgz";
      name = "gauge-1.2.0.tgz";
      sha1 = "3094ab1285633f799814388fc8f2de67b4c012c5";
    };
    deps = {
      "ansi-0.3.0" = self.by-version."ansi"."0.3.0";
      "has-unicode-1.0.0" = self.by-version."has-unicode"."1.0.0";
      "lodash.pad-3.1.0" = self.by-version."lodash.pad"."3.1.0";
      "lodash.padleft-3.1.1" = self.by-version."lodash.padleft"."3.1.1";
      "lodash.padright-3.1.1" = self.by-version."lodash.padright"."3.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-function"."^2.0.0" = self.by-version."generate-function"."2.0.0";
  by-version."generate-function"."2.0.0" = self.buildNodePackage {
    name = "generate-function-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
      name = "generate-function-2.0.0.tgz";
      sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-object-property"."^1.1.0" = self.by-version."generate-object-property"."1.1.1";
  by-version."generate-object-property"."1.1.1" = self.buildNodePackage {
    name = "generate-object-property-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.1.1.tgz";
      name = "generate-object-property-1.1.1.tgz";
      sha1 = "8fda6b4cb69b34a189a6cebee7c4c268af47cc93";
    };
    deps = {
      "is-property-1.0.2" = self.by-version."is-property"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generic-pool-redux"."~0.1.0" = self.by-version."generic-pool-redux"."0.1.0";
  by-version."generic-pool-redux"."0.1.0" = self.buildNodePackage {
    name = "generic-pool-redux-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/generic-pool-redux/-/generic-pool-redux-0.1.0.tgz";
      name = "generic-pool-redux-0.1.0.tgz";
      sha1 = "326c2594e17fba4d4f0622cfe09acc3c84cb3a82";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."get-stdin"."^4.0.1" = self.by-version."get-stdin"."4.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."3.2.3" = self.by-version."glob"."3.2.3";
  by-version."glob"."3.2.3" = self.buildNodePackage {
    name = "glob-3.2.3";
    version = "3.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-3.2.3.tgz";
      name = "glob-3.2.3.tgz";
      sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
    };
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."3.x" = self.by-version."glob"."3.2.11";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^4.4.2" = self.by-version."glob"."4.5.3";
  by-version."glob"."4.5.3" = self.buildNodePackage {
    name = "glob-4.5.3";
    version = "4.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-4.5.3.tgz";
      name = "glob-4.5.3.tgz";
      sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.7" = self.by-version."minimatch"."2.0.7";
      "once-1.3.2" = self.by-version."once"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."~3.2.9" = self.by-version."glob"."3.2.11";
  by-spec."graceful-fs"."1.2" = self.by-version."graceful-fs"."1.2.3";
  by-version."graceful-fs"."1.2.3" = self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    version = "1.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
      name = "graceful-fs-1.2.3.tgz";
      sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."3" = self.by-version."graceful-fs"."3.0.6";
  by-version."graceful-fs"."3.0.6" = self.buildNodePackage {
    name = "graceful-fs-3.0.6";
    version = "3.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.6.tgz";
      name = "graceful-fs-3.0.6.tgz";
      sha1 = "dce3a18351cb94cdc82e688b2e3dd2842d1b09bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."~2.0.0" = self.by-version."graceful-fs"."2.0.3";
  by-version."graceful-fs"."2.0.3" = self.buildNodePackage {
    name = "graceful-fs-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.3.tgz";
      name = "graceful-fs-2.0.3.tgz";
      sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."~3.0.2" = self.by-version."graceful-fs"."3.0.6";
  by-spec."graceful-readlink".">= 1.0.0" = self.by-version."graceful-readlink"."1.0.1";
  by-version."graceful-readlink"."1.0.1" = self.buildNodePackage {
    name = "graceful-readlink-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
      name = "graceful-readlink-1.0.1.tgz";
      sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."growl"."1.8.1" = self.by-version."growl"."1.8.1";
  by-version."growl"."1.8.1" = self.buildNodePackage {
    name = "growl-1.8.1";
    version = "1.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/growl/-/growl-1.8.1.tgz";
      name = "growl-1.8.1.tgz";
      sha1 = "4b2dec8d907e93db336624dcec0183502f8c9428";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."handlebars"."1.3.x" = self.by-version."handlebars"."1.3.0";
  by-version."handlebars"."1.3.0" = self.buildNodePackage {
    name = "handlebars-1.3.0";
    version = "1.3.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/handlebars/-/handlebars-1.3.0.tgz";
      name = "handlebars-1.3.0.tgz";
      sha1 = "9e9b130a93e389491322d975cf3ec1818c37ce34";
    };
    deps = {
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
    optionalDependencies = {
      "uglify-js-2.3.6" = self.by-version."uglify-js"."2.3.6";
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."^1.4.0" = self.by-version."har-validator"."1.7.0";
  by-version."har-validator"."1.7.0" = self.buildNodePackage {
    name = "har-validator-1.7.0";
    version = "1.7.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/har-validator/-/har-validator-1.7.0.tgz";
      name = "har-validator-1.7.0.tgz";
      sha1 = "563f8c58edca6410e2e408b0e540161da580dc46";
    };
    deps = {
      "bluebird-2.9.25" = self.by-version."bluebird"."2.9.25";
      "chalk-1.0.0" = self.by-version."chalk"."1.0.0";
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "is-my-json-valid-2.11.0" = self.by-version."is-my-json-valid"."2.11.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-ansi"."^0.1.0" = self.by-version."has-ansi"."0.1.0";
  by-version."has-ansi"."0.1.0" = self.buildNodePackage {
    name = "has-ansi-0.1.0";
    version = "0.1.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-ansi/-/has-ansi-0.1.0.tgz";
      name = "has-ansi-0.1.0.tgz";
      sha1 = "84f265aae8c0e6a88a12d7022894b7568894c62e";
    };
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-ansi"."^1.0.3" = self.by-version."has-ansi"."1.0.3";
  by-version."has-ansi"."1.0.3" = self.buildNodePackage {
    name = "has-ansi-1.0.3";
    version = "1.0.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-ansi/-/has-ansi-1.0.3.tgz";
      name = "has-ansi-1.0.3.tgz";
      sha1 = "c0b5b1615d9e382b0ff67169d967b425e48ca538";
    };
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-unicode"."^1.0.0" = self.by-version."has-unicode"."1.0.0";
  by-version."has-unicode"."1.0.0" = self.buildNodePackage {
    name = "has-unicode-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-unicode/-/has-unicode-1.0.0.tgz";
      name = "has-unicode-1.0.0.tgz";
      sha1 = "bac5c44e064c2ffc3b8fcbd8c71afe08f9afc8cc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."1.1.1" = self.by-version."hawk"."1.1.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~2.3.0" = self.by-version."hawk"."2.3.1";
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
      "hoek-2.13.0" = self.by-version."hoek"."2.13.0";
      "boom-2.7.1" = self.by-version."boom"."2.7.1";
      "cryptiles-2.0.4" = self.by-version."cryptiles"."2.0.4";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."heap".">= 0.2.0" = self.by-version."heap"."0.2.6";
  by-version."heap"."0.2.6" = self.buildNodePackage {
    name = "heap-0.2.6";
    version = "0.2.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/heap/-/heap-0.2.6.tgz";
      name = "heap-0.2.6.tgz";
      sha1 = "087e1f10b046932fc8594dd9e6d378afc9d1e5ac";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."0.9.x" = self.by-version."hoek"."0.9.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."2.x.x" = self.by-version."hoek"."2.13.0";
  by-version."hoek"."2.13.0" = self.buildNodePackage {
    name = "hoek-2.13.0";
    version = "2.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-2.13.0.tgz";
      name = "hoek-2.13.0.tgz";
      sha1 = "cc86b5c1c344b41a7271be449e232fac8d6f450c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-signature"."~0.10.0" = self.by-version."http-signature"."0.10.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."0.4.8" = self.by-version."iconv-lite"."0.4.8";
  by-version."iconv-lite"."0.4.8" = self.buildNodePackage {
    name = "iconv-lite-0.4.8";
    version = "0.4.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.8.tgz";
      name = "iconv-lite-0.4.8.tgz";
      sha1 = "c6019a7595f2cefca702eab694a010bcd9298d20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inflight"."^1.0.4" = self.by-version."inflight"."1.0.4";
  by-version."inflight"."1.0.4" = self.buildNodePackage {
    name = "inflight-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
      name = "inflight-1.0.4.tgz";
      sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
    };
    deps = {
      "once-1.3.2" = self.by-version."once"."1.3.2";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2" = self.by-version."inherits"."2.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2.0.1" = self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.0" = self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" = self.by-version."inherits"."2.0.1";
  by-spec."ini"."1.x.x" = self.by-version."ini"."1.3.3";
  by-version."ini"."1.3.3" = self.buildNodePackage {
    name = "ini-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ini/-/ini-1.3.3.tgz";
      name = "ini-1.3.3.tgz";
      sha1 = "c07e34aef1de06aff21d413b458e52b21533a11e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ini"."~1.3.0" = self.by-version."ini"."1.3.3";
  by-spec."interpret"."^0.3.2" = self.by-version."interpret"."0.3.10";
  by-version."interpret"."0.3.10" = self.buildNodePackage {
    name = "interpret-0.3.10";
    version = "0.3.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/interpret/-/interpret-0.3.10.tgz";
      name = "interpret-0.3.10.tgz";
      sha1 = "088c25de731c6c5b112a90f0071cfaf459e5a7bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ipaddr.js"."1.0.1" = self.by-version."ipaddr.js"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.10.1" = self.by-version."is-my-json-valid"."2.11.0";
  by-version."is-my-json-valid"."2.11.0" = self.buildNodePackage {
    name = "is-my-json-valid-2.11.0";
    version = "2.11.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.11.0.tgz";
      name = "is-my-json-valid-2.11.0.tgz";
      sha1 = "11f130d52c6c0b2ee132a72feb8e3e4c61a2c54f";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.1.1" = self.by-version."generate-object-property"."1.1.1";
      "jsonpointer-1.1.0" = self.by-version."jsonpointer"."1.1.0";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-property"."^1.0.0" = self.by-version."is-property"."1.0.2";
  by-version."is-property"."1.0.2" = self.buildNodePackage {
    name = "is-property-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
      name = "is-property-1.0.2.tgz";
      sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isarray"."0.0.1" = self.by-version."isarray"."0.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isstream"."0.1.x" = self.by-version."isstream"."0.1.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isstream"."~0.1.1" = self.by-version."isstream"."0.1.2";
  by-spec."istanbul"."^0.2.10" = self.by-version."istanbul"."0.2.16";
  by-version."istanbul"."0.2.16" = self.buildNodePackage {
    name = "istanbul-0.2.16";
    version = "0.2.16";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/istanbul/-/istanbul-0.2.16.tgz";
      name = "istanbul-0.2.16.tgz";
      sha1 = "870545a0d4f4b4ce161039e9e805a98c2c700bd9";
    };
    deps = {
      "esprima-1.2.5" = self.by-version."esprima"."1.2.5";
      "escodegen-1.3.3" = self.by-version."escodegen"."1.3.3";
      "handlebars-1.3.0" = self.by-version."handlebars"."1.3.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "fileset-0.1.5" = self.by-version."fileset"."0.1.5";
      "which-1.0.9" = self.by-version."which"."1.0.9";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "js-yaml-3.3.1" = self.by-version."js-yaml"."3.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "istanbul" = self.by-version."istanbul"."0.2.16";
  by-spec."jade"."0.26.3" = self.by-version."jade"."0.26.3";
  by-version."jade"."0.26.3" = self.buildNodePackage {
    name = "jade-0.26.3";
    version = "0.26.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/jade/-/jade-0.26.3.tgz";
      name = "jade-0.26.3.tgz";
      sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
    };
    deps = {
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jayschema"."^0.3.1" = self.by-version."jayschema"."0.3.1";
  by-version."jayschema"."0.3.1" = self.buildNodePackage {
    name = "jayschema-0.3.1";
    version = "0.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/jayschema/-/jayschema-0.3.1.tgz";
      name = "jayschema-0.3.1.tgz";
      sha1 = "76f4769f9b172ef7d5dcde4875b49cb736179b58";
    };
    deps = {
      "when-3.4.6" = self.by-version."when"."3.4.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "jayschema" = self.by-version."jayschema"."0.3.1";
  by-spec."jayschema-error-messages"."^1.0.2" = self.by-version."jayschema-error-messages"."1.0.3";
  by-version."jayschema-error-messages"."1.0.3" = self.buildNodePackage {
    name = "jayschema-error-messages-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jayschema-error-messages/-/jayschema-error-messages-1.0.3.tgz";
      name = "jayschema-error-messages-1.0.3.tgz";
      sha1 = "8bac6e52ae89d406fbe1a7db4ae44debfd289066";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "jayschema-error-messages" = self.by-version."jayschema-error-messages"."1.0.3";
  by-spec."js-yaml"."3.0.1" = self.by-version."js-yaml"."3.0.1";
  by-version."js-yaml"."3.0.1" = self.buildNodePackage {
    name = "js-yaml-3.0.1";
    version = "3.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.0.1.tgz";
      name = "js-yaml-3.0.1.tgz";
      sha1 = "76405fea5bce30fc8f405d48c6dca7f0a32c6afe";
    };
    deps = {
      "argparse-0.1.16" = self.by-version."argparse"."0.1.16";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-yaml"."3.x" = self.by-version."js-yaml"."3.3.1";
  by-version."js-yaml"."3.3.1" = self.buildNodePackage {
    name = "js-yaml-3.3.1";
    version = "3.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.3.1.tgz";
      name = "js-yaml-3.3.1.tgz";
      sha1 = "ca1acd3423ec275d12140a7bab51db015ba0b3c0";
    };
    deps = {
      "argparse-1.0.2" = self.by-version."argparse"."1.0.2";
      "esprima-2.2.0" = self.by-version."esprima"."2.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-diff"."0.3.1" = self.by-version."json-diff"."0.3.1";
  by-version."json-diff"."0.3.1" = self.buildNodePackage {
    name = "json-diff-0.3.1";
    version = "0.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-diff/-/json-diff-0.3.1.tgz";
      name = "json-diff-0.3.1.tgz";
      sha1 = "6dbc3ae2d25e075a7fd71bcd9874458666fb681b";
    };
    deps = {
      "dreamopt-0.6.0" = self.by-version."dreamopt"."0.6.0";
      "difflib-0.2.4" = self.by-version."difflib"."0.2.4";
      "cli-color-0.1.7" = self.by-version."cli-color"."0.1.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."~5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonpointer"."^1.1.0" = self.by-version."jsonpointer"."1.1.0";
  by-version."jsonpointer"."1.1.0" = self.buildNodePackage {
    name = "jsonpointer-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-1.1.0.tgz";
      name = "jsonpointer-1.1.0.tgz";
      sha1 = "c3c72efaed3b97154163dc01dd349e1cfe0f80fc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."knex"."^0.7.6" = self.by-version."knex"."0.7.6";
  by-version."knex"."0.7.6" = self.buildNodePackage {
    name = "knex-0.7.6";
    version = "0.7.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/knex/-/knex-0.7.6.tgz";
      name = "knex-0.7.6.tgz";
      sha1 = "325d18174b0625658ff0d35aaf1cd9e631696992";
    };
    deps = {
      "bluebird-2.9.25" = self.by-version."bluebird"."2.9.25";
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "generic-pool-redux-0.1.0" = self.by-version."generic-pool-redux"."0.1.0";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "interpret-0.3.10" = self.by-version."interpret"."0.3.10";
      "liftoff-0.13.6" = self.by-version."liftoff"."0.13.6";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "tildify-1.0.0" = self.by-version."tildify"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "knex" = self.by-version."knex"."0.7.6";
  by-spec."lcov-parse"."0.0.6" = self.by-version."lcov-parse"."0.0.6";
  by-version."lcov-parse"."0.0.6" = self.buildNodePackage {
    name = "lcov-parse-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lcov-parse/-/lcov-parse-0.0.6.tgz";
      name = "lcov-parse-0.0.6.tgz";
      sha1 = "819e5da8bf0791f9d3f39eea5ed1868187f11175";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."liftoff"."~0.13.2" = self.by-version."liftoff"."0.13.6";
  by-version."liftoff"."0.13.6" = self.buildNodePackage {
    name = "liftoff-0.13.6";
    version = "0.13.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/liftoff/-/liftoff-0.13.6.tgz";
      name = "liftoff-0.13.6.tgz";
      sha1 = "600e8966b92d1e0150eab5b577652569f4c7d1d8";
    };
    deps = {
      "findup-sync-0.1.3" = self.by-version."findup-sync"."0.1.3";
      "resolve-1.0.0" = self.by-version."resolve"."1.0.0";
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
      "extend-1.3.0" = self.by-version."extend"."1.3.0";
      "flagged-respawn-0.3.1" = self.by-version."flagged-respawn"."0.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash".">= 3.2.0 < 4.0.0" = self.by-version."lodash"."3.8.0";
  by-version."lodash"."3.8.0" = self.buildNodePackage {
    name = "lodash-3.8.0";
    version = "3.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-3.8.0.tgz";
      name = "lodash-3.8.0.tgz";
      sha1 = "376eb98bdcd9382a9365c33c4cb8250de1325b91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."^3.1.0" = self.by-version."lodash"."3.8.0";
  by-spec."lodash"."^3.6" = self.by-version."lodash"."3.8.0";
  "lodash" = self.by-version."lodash"."3.8.0";
  by-spec."lodash"."^3.6.0" = self.by-version."lodash"."3.8.0";
  by-spec."lodash"."~2.4.0" = self.by-version."lodash"."2.4.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."~2.4.1" = self.by-version."lodash"."2.4.2";
  by-spec."lodash._basetostring"."^3.0.0" = self.by-version."lodash._basetostring"."3.0.0";
  by-version."lodash._basetostring"."3.0.0" = self.buildNodePackage {
    name = "lodash._basetostring-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._basetostring/-/lodash._basetostring-3.0.0.tgz";
      name = "lodash._basetostring-3.0.0.tgz";
      sha1 = "75a9a4aaaa2b2a8761111ff5431e7d83c1daf0e2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._createpadding"."^3.0.0" = self.by-version."lodash._createpadding"."3.6.0";
  by-version."lodash._createpadding"."3.6.0" = self.buildNodePackage {
    name = "lodash._createpadding-3.6.0";
    version = "3.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._createpadding/-/lodash._createpadding-3.6.0.tgz";
      name = "lodash._createpadding-3.6.0.tgz";
      sha1 = "c466850dd1a05e6bfec54fd0cf0db28b68332d5e";
    };
    deps = {
      "lodash.repeat-3.0.0" = self.by-version."lodash.repeat"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.pad"."^3.0.0" = self.by-version."lodash.pad"."3.1.0";
  by-version."lodash.pad"."3.1.0" = self.buildNodePackage {
    name = "lodash.pad-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.pad/-/lodash.pad-3.1.0.tgz";
      name = "lodash.pad-3.1.0.tgz";
      sha1 = "9f18b1f3749a95e197b5ff2ae752ea9851ada965";
    };
    deps = {
      "lodash._basetostring-3.0.0" = self.by-version."lodash._basetostring"."3.0.0";
      "lodash._createpadding-3.6.0" = self.by-version."lodash._createpadding"."3.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.padleft"."^3.0.0" = self.by-version."lodash.padleft"."3.1.1";
  by-version."lodash.padleft"."3.1.1" = self.buildNodePackage {
    name = "lodash.padleft-3.1.1";
    version = "3.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.padleft/-/lodash.padleft-3.1.1.tgz";
      name = "lodash.padleft-3.1.1.tgz";
      sha1 = "150151f1e0245edba15d50af2d71f1d5cff46530";
    };
    deps = {
      "lodash._basetostring-3.0.0" = self.by-version."lodash._basetostring"."3.0.0";
      "lodash._createpadding-3.6.0" = self.by-version."lodash._createpadding"."3.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.padright"."^3.0.0" = self.by-version."lodash.padright"."3.1.1";
  by-version."lodash.padright"."3.1.1" = self.buildNodePackage {
    name = "lodash.padright-3.1.1";
    version = "3.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.padright/-/lodash.padright-3.1.1.tgz";
      name = "lodash.padright-3.1.1.tgz";
      sha1 = "79f7770baaa39738c040aeb5465e8d88f2aacec0";
    };
    deps = {
      "lodash._basetostring-3.0.0" = self.by-version."lodash._basetostring"."3.0.0";
      "lodash._createpadding-3.6.0" = self.by-version."lodash._createpadding"."3.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.repeat"."^3.0.0" = self.by-version."lodash.repeat"."3.0.0";
  by-version."lodash.repeat"."3.0.0" = self.buildNodePackage {
    name = "lodash.repeat-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.repeat/-/lodash.repeat-3.0.0.tgz";
      name = "lodash.repeat-3.0.0.tgz";
      sha1 = "c340f4136c99dc5b2e397b3fd50cffbd172a94b0";
    };
    deps = {
      "lodash._basetostring-3.0.0" = self.by-version."lodash._basetostring"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."log-driver"."1.2.4" = self.by-version."log-driver"."1.2.4";
  by-version."log-driver"."1.2.4" = self.buildNodePackage {
    name = "log-driver-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/log-driver/-/log-driver-1.2.4.tgz";
      name = "log-driver-1.2.4.tgz";
      sha1 = "2d62d7faef45d8a71341961a04b0761eca99cfa3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lolex"."1.1.0" = self.by-version."lolex"."1.1.0";
  by-version."lolex"."1.1.0" = self.buildNodePackage {
    name = "lolex-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lolex/-/lolex-1.1.0.tgz";
      name = "lolex-1.1.0.tgz";
      sha1 = "5dbbbc850395e7523c74b3586f7fbd2626d25b1b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."2" = self.by-version."lru-cache"."2.6.2";
  by-version."lru-cache"."2.6.2" = self.buildNodePackage {
    name = "lru-cache-2.6.2";
    version = "2.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.6.2.tgz";
      name = "lru-cache-2.6.2.tgz";
      sha1 = "77741638c6dc972e503dbe41dcb6bfdfba499a38";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."~2.5.0" = self.by-version."lru-cache"."2.5.2";
  by-version."lru-cache"."2.5.2" = self.buildNodePackage {
    name = "lru-cache-2.5.2";
    version = "2.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.2.tgz";
      name = "lru-cache-2.5.2.tgz";
      sha1 = "1fddad938aae1263ce138680be1b3f591c0ab41c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."media-typer"."0.3.0" = self.by-version."media-typer"."0.3.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."merge-descriptors"."1.0.0" = self.by-version."merge-descriptors"."1.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."0.0.1" = self.by-version."methods"."0.0.1";
  by-version."methods"."0.0.1" = self.buildNodePackage {
    name = "methods-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/methods/-/methods-0.0.1.tgz";
      name = "methods-0.0.1.tgz";
      sha1 = "277c90f8bef39709645a8371c51c3b6c648e068c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."1.0.0" = self.by-version."methods"."1.0.0";
  by-version."methods"."1.0.0" = self.buildNodePackage {
    name = "methods-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/methods/-/methods-1.0.0.tgz";
      name = "methods-1.0.0.tgz";
      sha1 = "9a73d86375dfcef26ef61ca3e4b8a2e2538a80e3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."~1.1.1" = self.by-version."methods"."1.1.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."1.2.5" = self.by-version."mime"."1.2.5";
  by-version."mime"."1.2.5" = self.buildNodePackage {
    name = "mime-1.2.5";
    version = "1.2.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.2.5.tgz";
      name = "mime-1.2.5.tgz";
      sha1 = "9eed073022a8bf5e16c8566c6867b8832bfbfa13";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."1.3.4" = self.by-version."mime"."1.3.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."~1.2.11" = self.by-version."mime"."1.2.11";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db".">= 1.1.2 < 2" = self.by-version."mime-db"."1.9.1";
  by-version."mime-db"."1.9.1" = self.buildNodePackage {
    name = "mime-db-1.9.1";
    version = "1.9.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.9.1.tgz";
      name = "mime-db-1.9.1.tgz";
      sha1 = "1431049a71791482c29f37bafc8ea2cb3a6dd3e8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.9.1" = self.by-version."mime-db"."1.9.1";
  by-spec."mime-types"."~1.0.1" = self.by-version."mime-types"."1.0.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.1" = self.by-version."mime-types"."2.0.11";
  by-version."mime-types"."2.0.11" = self.buildNodePackage {
    name = "mime-types-2.0.11";
    version = "2.0.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.11.tgz";
      name = "mime-types-2.0.11.tgz";
      sha1 = "bf3449042799d877c815c29929d1e74760e72007";
    };
    deps = {
      "mime-db-1.9.1" = self.by-version."mime-db"."1.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.11" = self.by-version."mime-types"."2.0.11";
  by-spec."mime-types"."~2.0.3" = self.by-version."mime-types"."2.0.11";
  by-spec."minimatch"."0.3" = self.by-version."minimatch"."0.3.0";
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
      "lru-cache-2.6.2" = self.by-version."lru-cache"."2.6.2";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."0.x" = self.by-version."minimatch"."0.4.0";
  by-version."minimatch"."0.4.0" = self.buildNodePackage {
    name = "minimatch-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-0.4.0.tgz";
      name = "minimatch-0.4.0.tgz";
      sha1 = "bd2c7d060d2c8c8fd7cde7f1f2ed2d5b270fdb1b";
    };
    deps = {
      "lru-cache-2.6.2" = self.by-version."lru-cache"."2.6.2";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."^2.0.1" = self.by-version."minimatch"."2.0.7";
  by-version."minimatch"."2.0.7" = self.buildNodePackage {
    name = "minimatch-2.0.7";
    version = "2.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-2.0.7.tgz";
      name = "minimatch-2.0.7.tgz";
      sha1 = "d23652ab10e663e7d914602e920e21f9f66492be";
    };
    deps = {
      "brace-expansion-1.1.0" = self.by-version."brace-expansion"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."~0.2.0" = self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = self.buildNodePackage {
    name = "minimatch-0.2.14";
    version = "0.2.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
      name = "minimatch-0.2.14.tgz";
      sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
    };
    deps = {
      "lru-cache-2.6.2" = self.by-version."lru-cache"."2.6.2";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."~0.2.11" = self.by-version."minimatch"."0.2.14";
  by-spec."minimist"."0.0.8" = self.by-version."minimist"."0.0.8";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."~0.0.1" = self.by-version."minimist"."0.0.10";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."~0.0.7" = self.by-version."minimist"."0.0.10";
  by-spec."minimist"."~1.1.0" = self.by-version."minimist"."1.1.1";
  by-version."minimist"."1.1.1" = self.buildNodePackage {
    name = "minimist-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-1.1.1.tgz";
      name = "minimist-1.1.1.tgz";
      sha1 = "1bc2bc71658cdca5712475684363615b0b4f695b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.3.0" = self.by-version."mkdirp"."0.3.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.5" = self.by-version."mkdirp"."0.5.1";
  by-version."mkdirp"."0.5.1" = self.buildNodePackage {
    name = "mkdirp-0.5.1";
    version = "0.5.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
      name = "mkdirp-0.5.1.tgz";
      sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
    };
    deps = {
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.5.0" = self.by-version."mkdirp"."0.5.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.5.x" = self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp".">=0.5 0" = self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."^0.5.0" = self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.5.0" = self.by-version."mkdirp"."0.5.1";
  by-spec."mocha"."^2.1.0" = self.by-version."mocha"."2.2.4";
  by-version."mocha"."2.2.4" = self.buildNodePackage {
    name = "mocha-2.2.4";
    version = "2.2.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mocha/-/mocha-2.2.4.tgz";
      name = "mocha-2.2.4.tgz";
      sha1 = "192b0edc0e17e56613bc66e5fc7e81c00413a98d";
    };
    deps = {
      "commander-2.3.0" = self.by-version."commander"."2.3.0";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "glob-3.2.3" = self.by-version."glob"."3.2.3";
      "growl-1.8.1" = self.by-version."growl"."1.8.1";
      "jade-0.26.3" = self.by-version."jade"."0.26.3";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "supports-color-1.2.1" = self.by-version."supports-color"."1.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "mocha" = self.by-version."mocha"."2.2.4";
  by-spec."morgan"."^1.3.0" = self.by-version."morgan"."1.5.3";
  by-version."morgan"."1.5.3" = self.buildNodePackage {
    name = "morgan-1.5.3";
    version = "1.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/morgan/-/morgan-1.5.3.tgz";
      name = "morgan-1.5.3.tgz";
      sha1 = "8adb4e72f9e5c5436e5d93f42910835f79da9fdf";
    };
    deps = {
      "basic-auth-1.0.1" = self.by-version."basic-auth"."1.0.1";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "morgan" = self.by-version."morgan"."1.5.3";
  by-spec."ms"."0.6.2" = self.by-version."ms"."0.6.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.7.0" = self.by-version."ms"."0.7.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.7.1" = self.by-version."ms"."0.7.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."1.6.x" = self.by-version."nan"."1.6.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."~1.0.0" = self.by-version."nan"."1.0.0";
  by-version."nan"."1.0.0" = self.buildNodePackage {
    name = "nan-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-1.0.0.tgz";
      name = "nan-1.0.0.tgz";
      sha1 = "ae24f8850818d662fcab5acf7f3b95bfaa2ccf38";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."~1.8.4" = self.by-version."nan"."1.8.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nconf"."^0.6.9" = self.by-version."nconf"."0.6.9";
  by-version."nconf"."0.6.9" = self.buildNodePackage {
    name = "nconf-0.6.9";
    version = "0.6.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nconf/-/nconf-0.6.9.tgz";
      name = "nconf-0.6.9.tgz";
      sha1 = "9570ef15ed6f9ae6b2b3c8d5e71b66d3193cd661";
    };
    deps = {
      "async-0.2.9" = self.by-version."async"."0.2.9";
      "ini-1.3.3" = self.by-version."ini"."1.3.3";
      "optimist-0.6.0" = self.by-version."optimist"."0.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "nconf" = self.by-version."nconf"."0.6.9";
  by-spec."negotiator"."0.5.3" = self.by-version."negotiator"."0.5.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-pre-gyp"."~0.6.7" = self.by-version."node-pre-gyp"."0.6.7";
  by-version."node-pre-gyp"."0.6.7" = self.buildNodePackage {
    name = "node-pre-gyp-0.6.7";
    version = "0.6.7";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-pre-gyp/-/node-pre-gyp-0.6.7.tgz";
      name = "node-pre-gyp-0.6.7.tgz";
      sha1 = "4c3ee4ac2934b0b27fead6bc76391c0dccf38ea8";
    };
    deps = {
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "npmlog-1.2.0" = self.by-version."npmlog"."1.2.0";
      "request-2.55.0" = self.by-version."request"."2.55.0";
      "semver-4.3.4" = self.by-version."semver"."4.3.4";
      "tar-2.1.1" = self.by-version."tar"."2.1.1";
      "tar-pack-2.0.0" = self.by-version."tar-pack"."2.0.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "rc-1.0.1" = self.by-version."rc"."1.0.1";
      "rimraf-2.3.3" = self.by-version."rimraf"."2.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."^1.4.1" = self.by-version."node-uuid"."1.4.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "node-uuid" = self.by-version."node-uuid"."1.4.3";
  by-spec."node-uuid"."~1.4.0" = self.by-version."node-uuid"."1.4.3";
  by-spec."nopt"."3.x" = self.by-version."nopt"."3.0.1";
  by-version."nopt"."3.0.1" = self.buildNodePackage {
    name = "nopt-3.0.1";
    version = "3.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/nopt-3.0.1.tgz";
      name = "nopt-3.0.1.tgz";
      sha1 = "bce5c42446a3291f47622a370abbf158fbbacbfd";
    };
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nopt"."~3.0.1" = self.by-version."nopt"."3.0.1";
  by-spec."npmlog"."~1.2.0" = self.by-version."npmlog"."1.2.0";
  by-version."npmlog"."1.2.0" = self.buildNodePackage {
    name = "npmlog-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/npmlog/-/npmlog-1.2.0.tgz";
      name = "npmlog-1.2.0.tgz";
      sha1 = "b512f18ae8696a0192ada78ba00c06dbbd91bafb";
    };
    deps = {
      "ansi-0.3.0" = self.by-version."ansi"."0.3.0";
      "are-we-there-yet-1.0.4" = self.by-version."are-we-there-yet"."1.0.4";
      "gauge-1.2.0" = self.by-version."gauge"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.3.0" = self.by-version."oauth-sign"."0.3.0";
  by-version."oauth-sign"."0.3.0" = self.buildNodePackage {
    name = "oauth-sign-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
      name = "oauth-sign-0.3.0.tgz";
      sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.6.0" = self.by-version."oauth-sign"."0.6.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.2.0" = self.by-version."on-finished"."2.2.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.2.1" = self.by-version."on-finished"."2.2.1";
  by-spec."on-headers"."~1.0.0" = self.by-version."on-headers"."1.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."^1.3.0" = self.by-version."once"."1.3.2";
  by-version."once"."1.3.2" = self.buildNodePackage {
    name = "once-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/once/-/once-1.3.2.tgz";
      name = "once-1.3.2.tgz";
      sha1 = "d8feeca93b039ec1dcdee7741c92bdac5e28081b";
    };
    deps = {
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."~1.1.1" = self.by-version."once"."1.1.1";
  by-version."once"."1.1.1" = self.buildNodePackage {
    name = "once-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/once/-/once-1.1.1.tgz";
      name = "once-1.1.1.tgz";
      sha1 = "9db574933ccb08c3a7614d154032c09ea6f339e7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."0.6.0" = self.by-version."optimist"."0.6.0";
  by-version."optimist"."0.6.0" = self.buildNodePackage {
    name = "optimist-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/optimist/-/optimist-0.6.0.tgz";
      name = "optimist-0.6.0.tgz";
      sha1 = "69424826f3405f79f142e6fc3d9ae58d4dbb9200";
    };
    deps = {
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."~0.3" = self.by-version."optimist"."0.3.7";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."~0.3.5" = self.by-version."optimist"."0.3.7";
  by-spec."options".">=0.0.5" = self.by-version."options"."0.0.6";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseurl"."~1.3.0" = self.by-version."parseurl"."1.3.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-to-regexp"."0.1.3" = self.by-version."path-to-regexp"."0.1.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pkginfo"."0.3.x" = self.by-version."pkginfo"."0.3.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."proxy-addr"."~1.0.7" = self.by-version."proxy-addr"."1.0.8";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."0.6.6" = self.by-version."qs"."0.6.6";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."2.4.1" = self.by-version."qs"."2.4.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."2.4.2" = self.by-version."qs"."2.4.2";
  by-version."qs"."2.4.2" = self.buildNodePackage {
    name = "qs-2.4.2";
    version = "2.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-2.4.2.tgz";
      name = "qs-2.4.2.tgz";
      sha1 = "f7ce788e5777df0b5010da7f7c4e73ba32470f5a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~1.0.0" = self.by-version."qs"."1.0.2";
  by-version."qs"."1.0.2" = self.buildNodePackage {
    name = "qs-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-1.0.2.tgz";
      name = "qs-1.0.2.tgz";
      sha1 = "50a93e2b5af6691c31bcea5dae78ee6ea1903768";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~2.4.0" = self.by-version."qs"."2.4.2";
  by-spec."range-parser"."~1.0.2" = self.by-version."range-parser"."1.0.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."raw-body"."~2.0.1" = self.by-version."raw-body"."2.0.1";
  by-version."raw-body"."2.0.1" = self.buildNodePackage {
    name = "raw-body-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/raw-body/-/raw-body-2.0.1.tgz";
      name = "raw-body-2.0.1.tgz";
      sha1 = "2b70a3ffd1681c0521bae73454e0ccbc785d378e";
    };
    deps = {
      "bytes-2.0.1" = self.by-version."bytes"."2.0.1";
      "iconv-lite-0.4.8" = self.by-version."iconv-lite"."0.4.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rc"."~1.0.1" = self.by-version."rc"."1.0.1";
  by-version."rc"."1.0.1" = self.buildNodePackage {
    name = "rc-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rc/-/rc-1.0.1.tgz";
      name = "rc-1.0.1.tgz";
      sha1 = "f919c25e804cb0aa60f6fd92d929fc86b45013e8";
    };
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "strip-json-comments-0.1.3" = self.by-version."strip-json-comments"."0.1.3";
      "ini-1.3.3" = self.by-version."ini"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."1.0.27-1" = self.by-version."readable-stream"."1.0.27-1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^1.1.12" = self.by-version."readable-stream"."1.1.13";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^1.1.13" = self.by-version."readable-stream"."1.1.13";
  by-spec."readable-stream"."~1.0.2" = self.by-version."readable-stream"."1.0.33";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."~1.0.26" = self.by-version."readable-stream"."1.0.33";
  by-spec."reduce-component"."1.0.1" = self.by-version."reduce-component"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2.40.0" = self.by-version."request"."2.40.0";
  by-version."request"."2.40.0" = self.buildNodePackage {
    name = "request-2.40.0";
    version = "2.40.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.40.0.tgz";
      name = "request-2.40.0.tgz";
      sha1 = "4dd670f696f1e6e842e66b4b5e839301ab9beb67";
    };
    deps = {
      "qs-1.0.2" = self.by-version."qs"."1.0.2";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
    };
    optionalDependencies = {
      "tough-cookie-1.1.0" = self.by-version."tough-cookie"."1.1.0";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2.x" = self.by-version."request"."2.55.0";
  by-version."request"."2.55.0" = self.buildNodePackage {
    name = "request-2.55.0";
    version = "2.55.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.55.0.tgz";
      name = "request-2.55.0.tgz";
      sha1 = "d75c1cdf679d76bb100f9bffe1fe551b5c24e93d";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-2.0.11" = self.by-version."mime-types"."2.0.11";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.4.2" = self.by-version."qs"."2.4.2";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-1.1.0" = self.by-version."tough-cookie"."1.1.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.7.0" = self.by-version."har-validator"."1.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."require-directory"."^1.2.0" = self.by-version."require-directory"."1.2.0";
  by-version."require-directory"."1.2.0" = self.buildNodePackage {
    name = "require-directory-1.2.0";
    version = "1.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/require-directory/-/require-directory-1.2.0.tgz";
      name = "require-directory-1.2.0.tgz";
      sha1 = "35ff45a82ab73ca6ca35c746c0a17014371e1afd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "require-directory" = self.by-version."require-directory"."1.2.0";
  by-spec."resolve"."0.7.x" = self.by-version."resolve"."0.7.4";
  by-version."resolve"."0.7.4" = self.buildNodePackage {
    name = "resolve-0.7.4";
    version = "0.7.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/resolve/-/resolve-0.7.4.tgz";
      name = "resolve-0.7.4.tgz";
      sha1 = "395a9ef9e873fbfe12bd14408bd91bb936003d69";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."~1.0.0" = self.by-version."resolve"."1.0.0";
  by-version."resolve"."1.0.0" = self.buildNodePackage {
    name = "resolve-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/resolve/-/resolve-1.0.0.tgz";
      name = "resolve-1.0.0.tgz";
      sha1 = "2a6e3b314dcd57c6519e8e2282af8687e8de61c6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."2" = self.by-version."rimraf"."2.3.3";
  by-version."rimraf"."2.3.3" = self.buildNodePackage {
    name = "rimraf-2.3.3";
    version = "2.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.3.3.tgz";
      name = "rimraf-2.3.3.tgz";
      sha1 = "d0073d8b3010611e8f3ad377b08e9a3c18b98f06";
    };
    deps = {
      "glob-4.5.3" = self.by-version."glob"."4.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."~2.2.0" = self.by-version."rimraf"."2.2.8";
  by-version."rimraf"."2.2.8" = self.buildNodePackage {
    name = "rimraf-2.2.8";
    version = "2.2.8";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
      name = "rimraf-2.2.8.tgz";
      sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."~2.3.2" = self.by-version."rimraf"."2.3.3";
  by-spec."ripple-lib"."^0.12.3" = self.by-version."ripple-lib"."0.12.4";
  by-version."ripple-lib"."0.12.4" = self.buildNodePackage {
    name = "ripple-lib-0.12.4";
    version = "0.12.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ripple-lib/-/ripple-lib-0.12.4.tgz";
      name = "ripple-lib-0.12.4.tgz";
      sha1 = "97675f9ae92bda1397deaaad70a76955d14f91fd";
    };
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "bignumber.js-2.0.7" = self.by-version."bignumber.js"."2.0.7";
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "lodash-3.8.0" = self.by-version."lodash"."3.8.0";
      "lru-cache-2.5.2" = self.by-version."lru-cache"."2.5.2";
      "ripple-wallet-generator-1.0.3" = self.by-version."ripple-wallet-generator"."1.0.3";
      "ws-0.7.1" = self.by-version."ws"."0.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "ripple-lib" = self.by-version."ripple-lib"."0.12.4";
  by-spec."ripple-lib-transactionparser"."^0.3.2" =
    self.by-version."ripple-lib-transactionparser"."0.3.2";
  by-version."ripple-lib-transactionparser"."0.3.2" = self.buildNodePackage {
    name = "ripple-lib-transactionparser-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ripple-lib-transactionparser/-/ripple-lib-transactionparser-0.3.2.tgz";
      name = "ripple-lib-transactionparser-0.3.2.tgz";
      sha1 = "cf85e44f9f623798b68f664244e026956092f874";
    };
    deps = {
      "bignumber.js-1.4.1" = self.by-version."bignumber.js"."1.4.1";
      "lodash-3.8.0" = self.by-version."lodash"."3.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "ripple-lib-transactionparser" = self.by-version."ripple-lib-transactionparser"."0.3.2";
  by-spec."ripple-wallet-generator"."^1.0.3" = self.by-version."ripple-wallet-generator"."1.0.3";
  by-version."ripple-wallet-generator"."1.0.3" = self.buildNodePackage {
    name = "ripple-wallet-generator-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ripple-wallet-generator/-/ripple-wallet-generator-1.0.3.tgz";
      name = "ripple-wallet-generator-1.0.3.tgz";
      sha1 = "2a1f0f6e2a39998fcf8fa89a55cb5c999cdb86ca";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."samsam"."~1.1" = self.by-version."samsam"."1.1.2";
  by-version."samsam"."1.1.2" = self.buildNodePackage {
    name = "samsam-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/samsam/-/samsam-1.1.2.tgz";
      name = "samsam-1.1.2.tgz";
      sha1 = "bec11fdc83a9fda063401210e40176c3024d1567";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver"."~4.3.2" = self.by-version."semver"."4.3.4";
  by-version."semver"."4.3.4" = self.buildNodePackage {
    name = "semver-4.3.4";
    version = "4.3.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-4.3.4.tgz";
      name = "semver-4.3.4.tgz";
      sha1 = "bf43a1aae304de040e12a13f84200ca7aeab7589";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."send"."0.12.2" = self.by-version."send"."0.12.2";
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
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.9.2" = self.by-version."serve-static"."1.9.2";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sigmund"."~1.0.0" = self.by-version."sigmund"."1.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sinon".">=1.4.0 <2" = self.by-version."sinon"."1.14.1";
  by-version."sinon"."1.14.1" = self.buildNodePackage {
    name = "sinon-1.14.1";
    version = "1.14.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sinon/-/sinon-1.14.1.tgz";
      name = "sinon-1.14.1.tgz";
      sha1 = "d82797841918734507c94b7a73e3f560904578ad";
    };
    deps = {
      "formatio-1.1.1" = self.by-version."formatio"."1.1.1";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "lolex-1.1.0" = self.by-version."lolex"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sinon"."~1.10.0" = self.by-version."sinon"."1.10.3";
  by-version."sinon"."1.10.3" = self.buildNodePackage {
    name = "sinon-1.10.3";
    version = "1.10.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sinon/-/sinon-1.10.3.tgz";
      name = "sinon-1.10.3.tgz";
      sha1 = "c063e0e99d8327dc199113aab52eb83a2e9e3c2c";
    };
    deps = {
      "formatio-1.0.2" = self.by-version."formatio"."1.0.2";
      "util-0.10.3" = self.by-version."util"."0.10.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "sinon" = self.by-version."sinon"."1.10.3";
  by-spec."sinon-chai"."^2.5.0" = self.by-version."sinon-chai"."2.7.0";
  by-version."sinon-chai"."2.7.0" = self.buildNodePackage {
    name = "sinon-chai-2.7.0";
    version = "2.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sinon-chai/-/sinon-chai-2.7.0.tgz";
      name = "sinon-chai-2.7.0.tgz";
      sha1 = "493df3a3d758933fdd3678d011a4f738d5e72540";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [
      self.by-version."chai"."2.3.0"
      self.by-version."sinon"."1.14.1"
    ];
    os = [ ];
    cpu = [ ];
  };
  "sinon-chai" = self.by-version."sinon-chai"."2.7.0";
  by-spec."sntp"."0.2.x" = self.by-version."sntp"."0.2.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sntp"."1.x.x" = self.by-version."sntp"."1.0.9";
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
      "hoek-2.13.0" = self.by-version."hoek"."2.13.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.1.33" = self.by-version."source-map"."0.1.43";
  by-version."source-map"."0.1.43" = self.buildNodePackage {
    name = "source-map-0.1.43";
    version = "0.1.43";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/source-map/-/source-map-0.1.43.tgz";
      name = "source-map-0.1.43.tgz";
      sha1 = "c24bc146ca517c1471f5dacbe2571b2b7f9e3346";
    };
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.1.7" = self.by-version."source-map"."0.1.43";
  by-spec."sprintf-js"."~1.0.2" = self.by-version."sprintf-js"."1.0.2";
  by-version."sprintf-js"."1.0.2" = self.buildNodePackage {
    name = "sprintf-js-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.2.tgz";
      name = "sprintf-js-1.0.2.tgz";
      sha1 = "11e4d84ff32144e35b0bf3a66f8587f38d8f9978";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sqlite3"."^3.0.2" = self.by-version."sqlite3"."3.0.8";
  by-version."sqlite3"."3.0.8" = self.buildNodePackage {
    name = "sqlite3-3.0.8";
    version = "3.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sqlite3/-/sqlite3-3.0.8.tgz";
      name = "sqlite3-3.0.8.tgz";
      sha1 = "662d6507426ba2af0cdaf894a1766c8099c0e435";
    };
    deps = {
      "nan-1.8.4" = self.by-version."nan"."1.8.4";
      "node-pre-gyp-0.6.7" = self.by-version."node-pre-gyp"."0.6.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "sqlite3" = self.by-version."sqlite3"."3.0.8";
  by-spec."stack-trace"."0.0.x" = self.by-version."stack-trace"."0.0.9";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string_decoder"."~0.10.x" = self.by-version."string_decoder"."0.10.31";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stringstream"."~0.0.4" = self.by-version."stringstream"."0.0.4";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^0.3.0" = self.by-version."strip-ansi"."0.3.0";
  by-version."strip-ansi"."0.3.0" = self.buildNodePackage {
    name = "strip-ansi-0.3.0";
    version = "0.3.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.3.0.tgz";
      name = "strip-ansi-0.3.0.tgz";
      sha1 = "25f48ea22ca79187f3174a4db8759347bb126220";
    };
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^2.0.1" = self.by-version."strip-ansi"."2.0.1";
  by-version."strip-ansi"."2.0.1" = self.buildNodePackage {
    name = "strip-ansi-2.0.1";
    version = "2.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-2.0.1.tgz";
      name = "strip-ansi-2.0.1.tgz";
      sha1 = "df62c1aa94ed2f114e1d0f21fd1d50482b79a60e";
    };
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-json-comments"."0.1.x" = self.by-version."strip-json-comments"."0.1.3";
  by-version."strip-json-comments"."0.1.3" = self.buildNodePackage {
    name = "strip-json-comments-0.1.3";
    version = "0.1.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-json-comments/-/strip-json-comments-0.1.3.tgz";
      name = "strip-json-comments-0.1.3.tgz";
      sha1 = "164c64e370a8a3cc00c9e01b539e569823f0ee54";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."superagent"."0.18.0" = self.by-version."superagent"."0.18.0";
  by-version."superagent"."0.18.0" = self.buildNodePackage {
    name = "superagent-0.18.0";
    version = "0.18.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/superagent/-/superagent-0.18.0.tgz";
      name = "superagent-0.18.0.tgz";
      sha1 = "9d4375a3ae2c4fbd55fd20d5b12a2470d2fc8f62";
    };
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "formidable-1.0.14" = self.by-version."formidable"."1.0.14";
      "mime-1.2.5" = self.by-version."mime"."1.2.5";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "methods-0.0.1" = self.by-version."methods"."0.0.1";
      "cookiejar-1.3.2" = self.by-version."cookiejar"."1.3.2";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "reduce-component-1.0.1" = self.by-version."reduce-component"."1.0.1";
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "form-data-0.1.2" = self.by-version."form-data"."0.1.2";
      "readable-stream-1.0.27-1" = self.by-version."readable-stream"."1.0.27-1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."supertest"."^0.13.0" = self.by-version."supertest"."0.13.0";
  by-version."supertest"."0.13.0" = self.buildNodePackage {
    name = "supertest-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/supertest/-/supertest-0.13.0.tgz";
      name = "supertest-0.13.0.tgz";
      sha1 = "4892bafd9beaa9bbcc95fd5a9f04949aef1ce06f";
    };
    deps = {
      "superagent-0.18.0" = self.by-version."superagent"."0.18.0";
      "methods-1.0.0" = self.by-version."methods"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "supertest" = self.by-version."supertest"."0.13.0";
  by-spec."supports-color"."^0.2.0" = self.by-version."supports-color"."0.2.0";
  by-version."supports-color"."0.2.0" = self.buildNodePackage {
    name = "supports-color-0.2.0";
    version = "0.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-0.2.0.tgz";
      name = "supports-color-0.2.0.tgz";
      sha1 = "d92de2694eb3f67323973d7ae3d8b55b4c22190a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."supports-color"."^1.3.0" = self.by-version."supports-color"."1.3.1";
  by-version."supports-color"."1.3.1" = self.buildNodePackage {
    name = "supports-color-1.3.1";
    version = "1.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-1.3.1.tgz";
      name = "supports-color-1.3.1.tgz";
      sha1 = "15758df09d8ff3b4acc307539fabe27095e1042d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."supports-color"."~1.2.0" = self.by-version."supports-color"."1.2.1";
  by-version."supports-color"."1.2.1" = self.buildNodePackage {
    name = "supports-color-1.2.1";
    version = "1.2.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-1.2.1.tgz";
      name = "supports-color-1.2.1.tgz";
      sha1 = "12ee21507086cd98c1058d9ec0f4ac476b7af3b2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar"."~0.1.17" = self.by-version."tar"."0.1.20";
  by-version."tar"."0.1.20" = self.buildNodePackage {
    name = "tar-0.1.20";
    version = "0.1.20";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tar/-/tar-0.1.20.tgz";
      name = "tar-0.1.20.tgz";
      sha1 = "42940bae5b5f22c74483699126f9f3f27449cb13";
    };
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar"."~2.1.0" = self.by-version."tar"."2.1.1";
  by-version."tar"."2.1.1" = self.buildNodePackage {
    name = "tar-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tar/-/tar-2.1.1.tgz";
      name = "tar-2.1.1.tgz";
      sha1 = "ac0649e135fa4546e430c7698514e1da2e8a7cc4";
    };
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-1.0.6" = self.by-version."fstream"."1.0.6";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-pack"."~2.0.0" = self.by-version."tar-pack"."2.0.0";
  by-version."tar-pack"."2.0.0" = self.buildNodePackage {
    name = "tar-pack-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tar-pack/-/tar-pack-2.0.0.tgz";
      name = "tar-pack-2.0.0.tgz";
      sha1 = "c2c401c02dd366138645e917b3a6baa256a9dcab";
    };
    deps = {
      "uid-number-0.0.3" = self.by-version."uid-number"."0.0.3";
      "once-1.1.1" = self.by-version."once"."1.1.1";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "tar-0.1.20" = self.by-version."tar"."0.1.20";
      "fstream-ignore-0.0.7" = self.by-version."fstream-ignore"."0.0.7";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    optionalDependencies = {
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tildify"."~1.0.0" = self.by-version."tildify"."1.0.0";
  by-version."tildify"."1.0.0" = self.buildNodePackage {
    name = "tildify-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tildify/-/tildify-1.0.0.tgz";
      name = "tildify-1.0.0.tgz";
      sha1 = "2a021db5e8fbde0a8f8b4df37adaa8fb1d39d7dd";
    };
    deps = {
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tinycolor"."0.x" = self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = self.buildNodePackage {
    name = "tinycolor-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
      name = "tinycolor-0.0.1.tgz";
      sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie".">=0.12.0" = self.by-version."tough-cookie"."1.1.0";
  by-version."tough-cookie"."1.1.0" = self.buildNodePackage {
    name = "tough-cookie-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-1.1.0.tgz";
      name = "tough-cookie-1.1.0.tgz";
      sha1 = "126d2490e66ae5286b6863debd4a341076915954";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel-agent"."~0.4.0" = self.by-version."tunnel-agent"."0.4.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-detect"."0.1.1" = self.by-version."type-detect"."0.1.1";
  by-version."type-detect"."0.1.1" = self.buildNodePackage {
    name = "type-detect-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/type-detect/-/type-detect-0.1.1.tgz";
      name = "type-detect-0.1.1.tgz";
      sha1 = "0ba5ec2a885640e470ea4e8505971900dac58822";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."~1.6.1" = self.by-version."type-is"."1.6.2";
  by-version."type-is"."1.6.2" = self.buildNodePackage {
    name = "type-is-1.6.2";
    version = "1.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/type-is/-/type-is-1.6.2.tgz";
      name = "type-is-1.6.2.tgz";
      sha1 = "694e83e5d110417e681cea278227f264ae406e33";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.0.11" = self.by-version."mime-types"."2.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."~1.6.2" = self.by-version."type-is"."1.6.2";
  by-spec."uglify-js"."~2.3" = self.by-version."uglify-js"."2.3.6";
  by-version."uglify-js"."2.3.6" = self.buildNodePackage {
    name = "uglify-js-2.3.6";
    version = "2.3.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.3.6.tgz";
      name = "uglify-js-2.3.6.tgz";
      sha1 = "fa0984770b428b7a9b2a8058f46355d14fef211a";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uid-number"."0.0.3" = self.by-version."uid-number"."0.0.3";
  by-version."uid-number"."0.0.3" = self.buildNodePackage {
    name = "uid-number-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.3.tgz";
      name = "uid-number-0.0.3.tgz";
      sha1 = "cefb0fa138d8d8098da71a40a0d04a8327d6e1cc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ultron"."1.0.x" = self.by-version."ultron"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."~1.7.0" = self.by-version."underscore"."1.7.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore.string"."~2.4.0" = self.by-version."underscore.string"."2.4.0";
  by-version."underscore.string"."2.4.0" = self.buildNodePackage {
    name = "underscore.string-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.4.0.tgz";
      name = "underscore.string-2.4.0.tgz";
      sha1 = "8cdd8fbac4e2d2ea1e7e2e8097c42f442280f85b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."user-home"."^1.0.0" = self.by-version."user-home"."1.1.1";
  by-version."user-home"."1.1.1" = self.buildNodePackage {
    name = "user-home-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/user-home/-/user-home-1.1.1.tgz";
      name = "user-home-1.1.1.tgz";
      sha1 = "2b5be23a32b63a7c9deb8d0f28d485724a3df190";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utf-8-validate"."1.0.x" = self.by-version."utf-8-validate"."1.0.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."util".">=0.10.3 <1" = self.by-version."util"."0.10.3";
  by-version."util"."0.10.3" = self.buildNodePackage {
    name = "util-0.10.3";
    version = "0.10.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/util/-/util-0.10.3.tgz";
      name = "util-0.10.3.tgz";
      sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utils-merge"."1.0.0" = self.by-version."utils-merge"."1.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vary"."~1.0.0" = self.by-version."vary"."1.0.0";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."when"."~3.4.6" = self.by-version."when"."3.4.6";
  by-version."when"."3.4.6" = self.buildNodePackage {
    name = "when-3.4.6";
    version = "3.4.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/when/-/when-3.4.6.tgz";
      name = "when-3.4.6.tgz";
      sha1 = "8fbcb7cc1439d2c3a68c431f1516e6dcce9ad28c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."which"."1.0.x" = self.by-version."which"."1.0.9";
  by-version."which"."1.0.9" = self.buildNodePackage {
    name = "which-1.0.9";
    version = "1.0.9";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/which/-/which-1.0.9.tgz";
      name = "which-1.0.9.tgz";
      sha1 = "460c1da0f810103d0321a9b633af9e575e64486f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."winston"."^1.0.0" = self.by-version."winston"."1.0.0";
  by-version."winston"."1.0.0" = self.buildNodePackage {
    name = "winston-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/winston/-/winston-1.0.0.tgz";
      name = "winston-1.0.0.tgz";
      sha1 = "30e36e0041fc0a864b0029565719e4dc41d026a4";
    };
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "colors-1.0.3" = self.by-version."colors"."1.0.3";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "winston" = self.by-version."winston"."1.0.0";
  by-spec."wordwrap"."0.0.x" = self.by-version."wordwrap"."0.0.3";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap".">=0.0.2" = self.by-version."wordwrap"."1.0.0";
  by-version."wordwrap"."1.0.0" = self.buildNodePackage {
    name = "wordwrap-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz";
      name = "wordwrap-1.0.0.tgz";
      sha1 = "27584810891456a4171c8d0226441ade90cbcaeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap"."~0.0.2" = self.by-version."wordwrap"."0.0.3";
  by-spec."wrappy"."1" = self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = self.buildNodePackage {
    name = "wrappy-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
      name = "wrappy-1.0.1.tgz";
      sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ws"."^0.4.32" = self.by-version."ws"."0.4.32";
  by-version."ws"."0.4.32" = self.buildNodePackage {
    name = "ws-0.4.32";
    version = "0.4.32";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/ws/-/ws-0.4.32.tgz";
      name = "ws-0.4.32.tgz";
      sha1 = "787a6154414f3c99ed83c5772153b20feb0cec32";
    };
    deps = {
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
      "nan-1.0.0" = self.by-version."nan"."1.0.0";
      "tinycolor-0.0.1" = self.by-version."tinycolor"."0.0.1";
      "options-0.0.6" = self.by-version."options"."0.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  "ws" = self.by-version."ws"."0.4.32";
  by-spec."ws"."~0.7.1" = self.by-version."ws"."0.7.1";
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
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."^4.0.0" = self.by-version."xtend"."4.0.0";
  by-version."xtend"."4.0.0" = self.buildNodePackage {
    name = "xtend-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xtend/-/xtend-4.0.0.tgz";
      name = "xtend-4.0.0.tgz";
      sha1 = "8bc36ff87aedbe7ce9eaf0bca36b2354a743840f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [ ];
    os = [ ];
    cpu = [ ];
  };
}
