{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."JSONSelect"."0.4.0" =
    self.by-version."JSONSelect"."0.4.0";
  by-version."JSONSelect"."0.4.0" = self.buildNodePackage {
    name = "JSONSelect-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/JSONSelect/-/JSONSelect-0.4.0.tgz";
      name = "JSONSelect-0.4.0.tgz";
      sha1 = "a08edcc67eb3fcbe99ed630855344a0cf282bb8d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.1.0";
  by-version."abbrev"."1.1.0" = self.buildNodePackage {
    name = "abbrev-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abbrev/-/abbrev-1.1.0.tgz";
      name = "abbrev-1.1.0.tgz";
      sha1 = "d0554c2256636e2f56e7c2e5ad183f859428d81f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."accepts"."~1.3.3" =
    self.by-version."accepts"."1.3.3";
  by-version."accepts"."1.3.3" = self.buildNodePackage {
    name = "accepts-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/accepts/-/accepts-1.3.3.tgz";
      name = "accepts-1.3.3.tgz";
      sha1 = "c3ca7434938648c3e0d9c1e328dd68b622c284ca";
    };
    deps = {
      "mime-types-2.1.15" = self.by-version."mime-types"."2.1.15";
      "negotiator-0.6.1" = self.by-version."negotiator"."0.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."addressparser"."~0.3.2" =
    self.by-version."addressparser"."0.3.2";
  by-version."addressparser"."0.3.2" = self.buildNodePackage {
    name = "addressparser-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/addressparser/-/addressparser-0.3.2.tgz";
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
  by-spec."ajv"."^4.9.1" =
    self.by-version."ajv"."4.11.8";
  by-version."ajv"."4.11.8" = self.buildNodePackage {
    name = "ajv-4.11.8";
    version = "4.11.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ajv/-/ajv-4.11.8.tgz";
      name = "ajv-4.11.8.tgz";
      sha1 = "82ffb02b29e662ae53bdc20af15947706739c536";
    };
    deps = {
      "co-4.6.0" = self.by-version."co"."4.6.0";
      "json-stable-stringify-1.0.1" = self.by-version."json-stable-stringify"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."align-text"."^0.1.1" =
    self.by-version."align-text"."0.1.4";
  by-version."align-text"."0.1.4" = self.buildNodePackage {
    name = "align-text-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/align-text/-/align-text-0.1.4.tgz";
      name = "align-text-0.1.4.tgz";
      sha1 = "0cd90a561093f35d0a99256c22b7069433fad117";
    };
    deps = {
      "kind-of-3.2.2" = self.by-version."kind-of"."3.2.2";
      "longest-1.0.1" = self.by-version."longest"."1.0.1";
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."align-text"."^0.1.3" =
    self.by-version."align-text"."0.1.4";
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."1.0.1";
  by-version."amdefine"."1.0.1" = self.buildNodePackage {
    name = "amdefine-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/amdefine/-/amdefine-1.0.1.tgz";
      name = "amdefine-1.0.1.tgz";
      sha1 = "4a5282ac164729e93619bcfd3ad151f817ce91f5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."amperize"."0.3.4" =
    self.by-version."amperize"."0.3.4";
  by-version."amperize"."0.3.4" = self.buildNodePackage {
    name = "amperize-0.3.4";
    version = "0.3.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/amperize/-/amperize-0.3.4.tgz";
      name = "amperize-0.3.4.tgz";
      sha1 = "04b61d8cc0eab4dd1dd822cead14c4c2461dec87";
    };
    deps = {
      "async-2.1.4" = self.by-version."async"."2.1.4";
      "emits-3.0.0" = self.by-version."emits"."3.0.0";
      "htmlparser2-3.9.2" = self.by-version."htmlparser2"."3.9.2";
      "image-size-0.5.1" = self.by-version."image-size"."0.5.1";
      "lodash.merge-4.6.0" = self.by-version."lodash.merge"."4.6.0";
      "nock-9.0.13" = self.by-version."nock"."9.0.13";
      "rewire-2.5.2" = self.by-version."rewire"."2.5.2";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "amperize" = self.by-version."amperize"."0.3.4";
  by-spec."ansi-regex"."^2.0.0" =
    self.by-version."ansi-regex"."2.1.1";
  by-version."ansi-regex"."2.1.1" = self.buildNodePackage {
    name = "ansi-regex-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz";
      name = "ansi-regex-2.1.1.tgz";
      sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-styles"."^2.1.0" =
    self.by-version."ansi-styles"."2.2.1";
  by-version."ansi-styles"."2.2.1" = self.buildNodePackage {
    name = "ansi-styles-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz";
      name = "ansi-styles-2.2.1.tgz";
      sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-styles"."^2.2.1" =
    self.by-version."ansi-styles"."2.2.1";
  by-spec."ap"."~0.2.0" =
    self.by-version."ap"."0.2.0";
  by-version."ap"."0.2.0" = self.buildNodePackage {
    name = "ap-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ap/-/ap-0.2.0.tgz";
      name = "ap-0.2.0.tgz";
      sha1 = "ae0942600b29912f0d2b14ec60c45e8f330b6110";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."append-field"."^0.1.0" =
    self.by-version."append-field"."0.1.0";
  by-version."append-field"."0.1.0" = self.buildNodePackage {
    name = "append-field-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/append-field/-/append-field-0.1.0.tgz";
      name = "append-field-0.1.0.tgz";
      sha1 = "6ddc58fa083c7bc545d3c5995b2830cc2366d44a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aproba"."^1.0.3" =
    self.by-version."aproba"."1.1.2";
  by-version."aproba"."1.1.2" = self.buildNodePackage {
    name = "aproba-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aproba/-/aproba-1.1.2.tgz";
      name = "aproba-1.1.2.tgz";
      sha1 = "45c6629094de4e96f693ef7eab74ae079c240fc1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."archiver"."1.3.0" =
    self.by-version."archiver"."1.3.0";
  by-version."archiver"."1.3.0" = self.buildNodePackage {
    name = "archiver-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/archiver/-/archiver-1.3.0.tgz";
      name = "archiver-1.3.0.tgz";
      sha1 = "4f2194d6d8f99df3f531e6881f14f15d55faaf22";
    };
    deps = {
      "archiver-utils-1.3.0" = self.by-version."archiver-utils"."1.3.0";
      "async-2.4.1" = self.by-version."async"."2.4.1";
      "buffer-crc32-0.2.13" = self.by-version."buffer-crc32"."0.2.13";
      "glob-7.1.2" = self.by-version."glob"."7.1.2";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
      "tar-stream-1.5.4" = self.by-version."tar-stream"."1.5.4";
      "zip-stream-1.1.1" = self.by-version."zip-stream"."1.1.1";
      "walkdir-0.0.11" = self.by-version."walkdir"."0.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "archiver" = self.by-version."archiver"."1.3.0";
  by-spec."archiver-utils"."^1.3.0" =
    self.by-version."archiver-utils"."1.3.0";
  by-version."archiver-utils"."1.3.0" = self.buildNodePackage {
    name = "archiver-utils-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/archiver-utils/-/archiver-utils-1.3.0.tgz";
      name = "archiver-utils-1.3.0.tgz";
      sha1 = "e50b4c09c70bf3d680e32ff1b7994e9f9d895174";
    };
    deps = {
      "glob-7.1.2" = self.by-version."glob"."7.1.2";
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "lazystream-1.0.0" = self.by-version."lazystream"."1.0.0";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
      "normalize-path-2.1.1" = self.by-version."normalize-path"."2.1.1";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."are-we-there-yet"."~1.1.2" =
    self.by-version."are-we-there-yet"."1.1.4";
  by-version."are-we-there-yet"."1.1.4" = self.buildNodePackage {
    name = "are-we-there-yet-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.1.4.tgz";
      name = "are-we-there-yet-1.1.4.tgz";
      sha1 = "bb5dca382bb94f05e15194373d16fd3ba1ca110d";
    };
    deps = {
      "delegates-1.0.0" = self.by-version."delegates"."1.0.0";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arr-diff"."^2.0.0" =
    self.by-version."arr-diff"."2.0.0";
  by-version."arr-diff"."2.0.0" = self.buildNodePackage {
    name = "arr-diff-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz";
      name = "arr-diff-2.0.0.tgz";
      sha1 = "8f3b827f955a8bd669697e4a4256ac3ceae356cf";
    };
    deps = {
      "arr-flatten-1.0.3" = self.by-version."arr-flatten"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arr-flatten"."^1.0.1" =
    self.by-version."arr-flatten"."1.0.3";
  by-version."arr-flatten"."1.0.3" = self.buildNodePackage {
    name = "arr-flatten-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.0.3.tgz";
      name = "arr-flatten-1.0.3.tgz";
      sha1 = "a274ed85ac08849b6bd7847c4580745dc51adfb1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-flatten"."1.1.1" =
    self.by-version."array-flatten"."1.1.1";
  by-version."array-flatten"."1.1.1" = self.buildNodePackage {
    name = "array-flatten-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz";
      name = "array-flatten-1.1.1.tgz";
      sha1 = "9a5f699051b1e7073328f2a008968b64ea2955d2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-unique"."^0.2.1" =
    self.by-version."array-unique"."0.2.1";
  by-version."array-unique"."0.2.1" = self.buildNodePackage {
    name = "array-unique-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz";
      name = "array-unique-0.2.1.tgz";
      sha1 = "a1d97ccafcbc2625cc70fadceb36a50c58b01a53";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asn1"."~0.2.3" =
    self.by-version."asn1"."0.2.3";
  by-version."asn1"."0.2.3" = self.buildNodePackage {
    name = "asn1-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz";
      name = "asn1-0.2.3.tgz";
      sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."1.0.0" =
    self.by-version."assert-plus"."1.0.0";
  by-version."assert-plus"."1.0.0" = self.buildNodePackage {
    name = "assert-plus-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz";
      name = "assert-plus-1.0.0.tgz";
      sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."^0.2.0" =
    self.by-version."assert-plus"."0.2.0";
  by-version."assert-plus"."0.2.0" = self.buildNodePackage {
    name = "assert-plus-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/assert-plus/-/assert-plus-0.2.0.tgz";
      name = "assert-plus-0.2.0.tgz";
      sha1 = "d74e1b87e7affc0db8aadb7021f3fe48101ab234";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."^1.0.0" =
    self.by-version."assert-plus"."1.0.0";
  by-spec."assertion-error"."^1.0.1" =
    self.by-version."assertion-error"."1.0.2";
  by-version."assertion-error"."1.0.2" = self.buildNodePackage {
    name = "assertion-error-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/assertion-error/-/assertion-error-1.0.2.tgz";
      name = "assertion-error-1.0.2.tgz";
      sha1 = "13ca515d86206da0bac66e834dd397d87581094c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."2.1.4" =
    self.by-version."async"."2.1.4";
  by-version."async"."2.1.4" = self.buildNodePackage {
    name = "async-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-2.1.4.tgz";
      name = "async-2.1.4.tgz";
      sha1 = "2d2160c7788032e4dd6cbe2502f1f9a2c8f6cde4";
    };
    deps = {
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."^1.4.0" =
    self.by-version."async"."1.5.2";
  by-version."async"."1.5.2" = self.buildNodePackage {
    name = "async-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-1.5.2.tgz";
      name = "async-1.5.2.tgz";
      sha1 = "ec6a61ae56480c0c3cb241c95618e20892f9672a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."^2.0.0" =
    self.by-version."async"."2.4.1";
  by-version."async"."2.4.1" = self.buildNodePackage {
    name = "async-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-2.4.1.tgz";
      name = "async-2.4.1.tgz";
      sha1 = "62a56b279c98a11d0987096a01cc3eeb8eb7bbd7";
    };
    deps = {
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asynckit"."^0.4.0" =
    self.by-version."asynckit"."0.4.0";
  by-version."asynckit"."0.4.0" = self.buildNodePackage {
    name = "asynckit-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz";
      name = "asynckit-0.4.0.tgz";
      sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sdk"."2.0.5" =
    self.by-version."aws-sdk"."2.0.5";
  by-version."aws-sdk"."2.0.5" = self.buildNodePackage {
    name = "aws-sdk-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws-sdk/-/aws-sdk-2.0.5.tgz";
      name = "aws-sdk-2.0.5.tgz";
      sha1 = "f3ebb1898d0632b7b6672e8d77728cbbb69f98c6";
    };
    deps = {
      "aws-sdk-apis-3.1.10" = self.by-version."aws-sdk-apis"."3.1.10";
      "xml2js-0.2.6" = self.by-version."xml2js"."0.2.6";
      "xmlbuilder-0.4.2" = self.by-version."xmlbuilder"."0.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sdk-apis"."3.x" =
    self.by-version."aws-sdk-apis"."3.1.10";
  by-version."aws-sdk-apis"."3.1.10" = self.buildNodePackage {
    name = "aws-sdk-apis-3.1.10";
    version = "3.1.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws-sdk-apis/-/aws-sdk-apis-3.1.10.tgz";
      name = "aws-sdk-apis-3.1.10.tgz";
      sha1 = "4eed97f590a16cf080fd1b8d8cfdf2472de8ab0e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sign2"."~0.6.0" =
    self.by-version."aws-sign2"."0.6.0";
  by-version."aws-sign2"."0.6.0" = self.buildNodePackage {
    name = "aws-sign2-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz";
      name = "aws-sign2-0.6.0.tgz";
      sha1 = "14342dd38dbcc94d0e5b87d763cd63612c0e794f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws4"."^1.2.1" =
    self.by-version."aws4"."1.6.0";
  by-version."aws4"."1.6.0" = self.buildNodePackage {
    name = "aws4-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws4/-/aws4-1.6.0.tgz";
      name = "aws4-1.6.0.tgz";
      sha1 = "83ef5ca860b2b32e4a0deedee8c771b9db57471e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."babel-runtime"."^6.11.6" =
    self.by-version."babel-runtime"."6.23.0";
  by-version."babel-runtime"."6.23.0" = self.buildNodePackage {
    name = "babel-runtime-6.23.0";
    version = "6.23.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/babel-runtime/-/babel-runtime-6.23.0.tgz";
      name = "babel-runtime-6.23.0.tgz";
      sha1 = "0a9489f144de70efb3ce4300accdb329e2fc543b";
    };
    deps = {
      "core-js-2.4.1" = self.by-version."core-js"."2.4.1";
      "regenerator-runtime-0.10.5" = self.by-version."regenerator-runtime"."0.10.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."babel-runtime"."^6.6.1" =
    self.by-version."babel-runtime"."6.23.0";
  by-spec."balanced-match"."^0.4.1" =
    self.by-version."balanced-match"."0.4.2";
  by-version."balanced-match"."0.4.2" = self.buildNodePackage {
    name = "balanced-match-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/balanced-match/-/balanced-match-0.4.2.tgz";
      name = "balanced-match-0.4.2.tgz";
      sha1 = "cb3f3e3c732dc0f01ee70b403f302e61d7709838";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."basic-auth"."~1.0.3" =
    self.by-version."basic-auth"."1.0.4";
  by-version."basic-auth"."1.0.4" = self.buildNodePackage {
    name = "basic-auth-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/basic-auth/-/basic-auth-1.0.4.tgz";
      name = "basic-auth-1.0.4.tgz";
      sha1 = "030935b01de7c9b94a824b29f3fccb750d3a5290";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bcrypt-pbkdf"."^1.0.0" =
    self.by-version."bcrypt-pbkdf"."1.0.1";
  by-version."bcrypt-pbkdf"."1.0.1" = self.buildNodePackage {
    name = "bcrypt-pbkdf-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz";
      name = "bcrypt-pbkdf-1.0.1.tgz";
      sha1 = "63bc5dcb61331b92bc05fd528953c33462a06f8d";
    };
    deps = {
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bcryptjs"."2.4.3" =
    self.by-version."bcryptjs"."2.4.3";
  by-version."bcryptjs"."2.4.3" = self.buildNodePackage {
    name = "bcryptjs-2.4.3";
    version = "2.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bcryptjs/-/bcryptjs-2.4.3.tgz";
      name = "bcryptjs-2.4.3.tgz";
      sha1 = "9ab5627b93e60621ff7cdac5da9733027df1d0cb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bcryptjs" = self.by-version."bcryptjs"."2.4.3";
  by-spec."bignumber.js"."1.0.1" =
    self.by-version."bignumber.js"."1.0.1";
  by-version."bignumber.js"."1.0.1" = self.buildNodePackage {
    name = "bignumber.js-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bignumber.js/-/bignumber.js-1.0.1.tgz";
      name = "bignumber.js-1.0.1.tgz";
      sha1 = "0e953896823b783d48ea921884d3fd90b89bdcb1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."^1.0.0" =
    self.by-version."bl"."1.2.1";
  by-version."bl"."1.2.1" = self.buildNodePackage {
    name = "bl-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bl/-/bl-1.2.1.tgz";
      name = "bl-1.2.1.tgz";
      sha1 = "cac328f7bee45730d404b692203fcb590e172d5e";
    };
    deps = {
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."^1.0.1" =
    self.by-version."bl"."1.2.1";
  by-spec."bl"."~1.1.2" =
    self.by-version."bl"."1.1.2";
  by-version."bl"."1.1.2" = self.buildNodePackage {
    name = "bl-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bl/-/bl-1.1.2.tgz";
      name = "bl-1.1.2.tgz";
      sha1 = "fdca871a99713aa00d19e3bbba41c44787a65398";
    };
    deps = {
      "readable-stream-2.0.6" = self.by-version."readable-stream"."2.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."block-stream"."*" =
    self.by-version."block-stream"."0.0.9";
  by-version."block-stream"."0.0.9" = self.buildNodePackage {
    name = "block-stream-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/block-stream/-/block-stream-0.0.9.tgz";
      name = "block-stream-0.0.9.tgz";
      sha1 = "13ebfe778a03205cfe03751481ebb4b3300c126a";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."3.4.6" =
    self.by-version."bluebird"."3.4.6";
  by-version."bluebird"."3.4.6" = self.buildNodePackage {
    name = "bluebird-3.4.6";
    version = "3.4.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bluebird/-/bluebird-3.4.6.tgz";
      name = "bluebird-3.4.6.tgz";
      sha1 = "01da8d821d87813d158967e743d5fe6c62cf8c0f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."3.5.0" =
    self.by-version."bluebird"."3.5.0";
  by-version."bluebird"."3.5.0" = self.buildNodePackage {
    name = "bluebird-3.5.0";
    version = "3.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bluebird/-/bluebird-3.5.0.tgz";
      name = "bluebird-3.5.0.tgz";
      sha1 = "791420d7f551eea2897453a8a77653f96606d67c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bluebird" = self.by-version."bluebird"."3.5.0";
  by-spec."bluebird"."^3.0.5" =
    self.by-version."bluebird"."3.5.0";
  by-spec."bluebird"."^3.4.3" =
    self.by-version."bluebird"."3.5.0";
  by-spec."bluebird"."^3.4.6" =
    self.by-version."bluebird"."3.5.0";
  by-spec."body-parser"."1.17.0" =
    self.by-version."body-parser"."1.17.0";
  by-version."body-parser"."1.17.0" = self.buildNodePackage {
    name = "body-parser-1.17.0";
    version = "1.17.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/body-parser/-/body-parser-1.17.0.tgz";
      name = "body-parser-1.17.0.tgz";
      sha1 = "d956ae2d756ae10bb784187725ea5a249430febd";
    };
    deps = {
      "bytes-2.4.0" = self.by-version."bytes"."2.4.0";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "http-errors-1.6.1" = self.by-version."http-errors"."1.6.1";
      "iconv-lite-0.4.15" = self.by-version."iconv-lite"."0.4.15";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "qs-6.3.1" = self.by-version."qs"."6.3.1";
      "raw-body-2.2.0" = self.by-version."raw-body"."2.2.0";
      "type-is-1.6.15" = self.by-version."type-is"."1.6.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "body-parser" = self.by-version."body-parser"."1.17.0";
  by-spec."bookshelf"."0.10.2" =
    self.by-version."bookshelf"."0.10.2";
  by-version."bookshelf"."0.10.2" = self.buildNodePackage {
    name = "bookshelf-0.10.2";
    version = "0.10.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bookshelf/-/bookshelf-0.10.2.tgz";
      name = "bookshelf-0.10.2.tgz";
      sha1 = "f3fb9adec7535c15699745224df1de479b6bd17f";
    };
    deps = {
      "babel-runtime-6.23.0" = self.by-version."babel-runtime"."6.23.0";
      "bluebird-3.5.0" = self.by-version."bluebird"."3.5.0";
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "create-error-0.3.1" = self.by-version."create-error"."0.3.1";
      "inflection-1.12.0" = self.by-version."inflection"."1.12.0";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [
      self.by-version."knex"."0.12.9"];
    os = [ ];
    cpu = [ ];
  };
  "bookshelf" = self.by-version."bookshelf"."0.10.2";
  by-spec."boolbase"."~1.0.0" =
    self.by-version."boolbase"."1.0.0";
  by-version."boolbase"."1.0.0" = self.buildNodePackage {
    name = "boolbase-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz";
      name = "boolbase-1.0.0.tgz";
      sha1 = "68dff5fbe60c51eb37725ea9e3ed310dcc1e776e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.10.1";
  by-version."boom"."2.10.1" = self.buildNodePackage {
    name = "boom-2.10.1";
    version = "2.10.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/boom/-/boom-2.10.1.tgz";
      name = "boom-2.10.1.tgz";
      sha1 = "39c8918ceff5799f83f9492a848f625add0c766f";
    };
    deps = {
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.1.7" =
    self.by-version."brace-expansion"."1.1.7";
  by-version."brace-expansion"."1.1.7" = self.buildNodePackage {
    name = "brace-expansion-1.1.7";
    version = "1.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.7.tgz";
      name = "brace-expansion-1.1.7.tgz";
      sha1 = "3effc3c50e000531fb720eaff80f0ae8ef23cf59";
    };
    deps = {
      "balanced-match-0.4.2" = self.by-version."balanced-match"."0.4.2";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."braces"."^1.8.2" =
    self.by-version."braces"."1.8.5";
  by-version."braces"."1.8.5" = self.buildNodePackage {
    name = "braces-1.8.5";
    version = "1.8.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/braces/-/braces-1.8.5.tgz";
      name = "braces-1.8.5.tgz";
      sha1 = "ba77962e12dff969d6b76711e914b737857bf6a7";
    };
    deps = {
      "expand-range-1.8.2" = self.by-version."expand-range"."1.8.2";
      "preserve-0.2.0" = self.by-version."preserve"."0.2.0";
      "repeat-element-1.1.2" = self.by-version."repeat-element"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-crc32"."^0.2.1" =
    self.by-version."buffer-crc32"."0.2.13";
  by-version."buffer-crc32"."0.2.13" = self.buildNodePackage {
    name = "buffer-crc32-0.2.13";
    version = "0.2.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz";
      name = "buffer-crc32-0.2.13.tgz";
      sha1 = "0d333e3f00eac50aa1454abd30ef8c2a5d9a7242";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-writer"."1.0.1" =
    self.by-version."buffer-writer"."1.0.1";
  by-version."buffer-writer"."1.0.1" = self.buildNodePackage {
    name = "buffer-writer-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/buffer-writer/-/buffer-writer-1.0.1.tgz";
      name = "buffer-writer-1.0.1.tgz";
      sha1 = "22a936901e3029afcd7547eb4487ceb697a3bf08";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bunyan"."1.8.5" =
    self.by-version."bunyan"."1.8.5";
  by-version."bunyan"."1.8.5" = self.buildNodePackage {
    name = "bunyan-1.8.5";
    version = "1.8.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/bunyan/-/bunyan-1.8.5.tgz";
      name = "bunyan-1.8.5.tgz";
      sha1 = "0d619e83005fb89070f5f47982fc1bf00600878a";
    };
    deps = {
    };
    optionalDependencies = {
      "dtrace-provider-0.8.2" = self.by-version."dtrace-provider"."0.8.2";
      "mv-2.1.1" = self.by-version."mv"."2.1.1";
      "safe-json-stringify-1.0.4" = self.by-version."safe-json-stringify"."1.0.4";
      "moment-2.18.1" = self.by-version."moment"."2.18.1";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bunyan-loggly"."1.1.0" =
    self.by-version."bunyan-loggly"."1.1.0";
  by-version."bunyan-loggly"."1.1.0" = self.buildNodePackage {
    name = "bunyan-loggly-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bunyan-loggly/-/bunyan-loggly-1.1.0.tgz";
      name = "bunyan-loggly-1.1.0.tgz";
      sha1 = "f2198453b33419a80446f39b3fd7cadc99d63ae0";
    };
    deps = {
      "clone-1.0.2" = self.by-version."clone"."1.0.2";
      "loggly-1.1.1" = self.by-version."loggly"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."busboy"."^0.2.11" =
    self.by-version."busboy"."0.2.14";
  by-version."busboy"."0.2.14" = self.buildNodePackage {
    name = "busboy-0.2.14";
    version = "0.2.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/busboy/-/busboy-0.2.14.tgz";
      name = "busboy-0.2.14.tgz";
      sha1 = "6c2a622efcf47c57bbbe1e2a9c37ad36c7925453";
    };
    deps = {
      "dicer-0.2.5" = self.by-version."dicer"."0.2.5";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytes"."2.3.0" =
    self.by-version."bytes"."2.3.0";
  by-version."bytes"."2.3.0" = self.buildNodePackage {
    name = "bytes-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytes/-/bytes-2.3.0.tgz";
      name = "bytes-2.3.0.tgz";
      sha1 = "d5b680a165b6201739acb611542aabc2d8ceb070";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytes"."2.4.0" =
    self.by-version."bytes"."2.4.0";
  by-version."bytes"."2.4.0" = self.buildNodePackage {
    name = "bytes-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytes/-/bytes-2.4.0.tgz";
      name = "bytes-2.4.0.tgz";
      sha1 = "7d97196f9d5baf7f6935e25985549edd2a6c2339";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caller"."1.0.1" =
    self.by-version."caller"."1.0.1";
  by-version."caller"."1.0.1" = self.buildNodePackage {
    name = "caller-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/caller/-/caller-1.0.1.tgz";
      name = "caller-1.0.1.tgz";
      sha1 = "b851860f70e195db3d277395aa1a7e23ea30ecf5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase"."^1.0.2" =
    self.by-version."camelcase"."1.2.1";
  by-version."camelcase"."1.2.1" = self.buildNodePackage {
    name = "camelcase-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/camelcase/-/camelcase-1.2.1.tgz";
      name = "camelcase-1.2.1.tgz";
      sha1 = "9bb5304d2e0b56698b2c758b08a3eaa9daa58a39";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase"."^2.0.1" =
    self.by-version."camelcase"."2.1.1";
  by-version."camelcase"."2.1.1" = self.buildNodePackage {
    name = "camelcase-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/camelcase/-/camelcase-2.1.1.tgz";
      name = "camelcase-2.1.1.tgz";
      sha1 = "7c1d16d679a1bbe59ca02cacecfb011e201f5a1f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.11.0" =
    self.by-version."caseless"."0.11.0";
  by-version."caseless"."0.11.0" = self.buildNodePackage {
    name = "caseless-0.11.0";
    version = "0.11.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
      name = "caseless-0.11.0.tgz";
      sha1 = "715b96ea9841593cc33067923f5ec60ebda4f7d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.12.0" =
    self.by-version."caseless"."0.12.0";
  by-version."caseless"."0.12.0" = self.buildNodePackage {
    name = "caseless-0.12.0";
    version = "0.12.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz";
      name = "caseless-0.12.0.tgz";
      sha1 = "1b681c21ff84033c826543090689420d187151dc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."center-align"."^0.1.1" =
    self.by-version."center-align"."0.1.3";
  by-version."center-align"."0.1.3" = self.buildNodePackage {
    name = "center-align-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/center-align/-/center-align-0.1.3.tgz";
      name = "center-align-0.1.3.tgz";
      sha1 = "aa0d32629b6ee972200411cbd4461c907bc2b7ad";
    };
    deps = {
      "align-text-0.1.4" = self.by-version."align-text"."0.1.4";
      "lazy-cache-1.0.4" = self.by-version."lazy-cache"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chai".">=1.9.2 <4.0.0" =
    self.by-version."chai"."3.5.0";
  by-version."chai"."3.5.0" = self.buildNodePackage {
    name = "chai-3.5.0";
    version = "3.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chai/-/chai-3.5.0.tgz";
      name = "chai-3.5.0.tgz";
      sha1 = "4d02637b067fe958bdbfdd3a40ec56fef7373247";
    };
    deps = {
      "assertion-error-1.0.2" = self.by-version."assertion-error"."1.0.2";
      "deep-eql-0.1.3" = self.by-version."deep-eql"."0.1.3";
      "type-detect-1.0.0" = self.by-version."type-detect"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."1.1.1" =
    self.by-version."chalk"."1.1.1";
  by-version."chalk"."1.1.1" = self.buildNodePackage {
    name = "chalk-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chalk/-/chalk-1.1.1.tgz";
      name = "chalk-1.1.1.tgz";
      sha1 = "509afb67066e7499f7eb3535c77445772ae2d019";
    };
    deps = {
      "ansi-styles-2.2.1" = self.by-version."ansi-styles"."2.2.1";
      "escape-string-regexp-1.0.5" = self.by-version."escape-string-regexp"."1.0.5";
      "has-ansi-2.0.0" = self.by-version."has-ansi"."2.0.0";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "supports-color-2.0.0" = self.by-version."supports-color"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."1.1.3" =
    self.by-version."chalk"."1.1.3";
  by-version."chalk"."1.1.3" = self.buildNodePackage {
    name = "chalk-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz";
      name = "chalk-1.1.3.tgz";
      sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
    };
    deps = {
      "ansi-styles-2.2.1" = self.by-version."ansi-styles"."2.2.1";
      "escape-string-regexp-1.0.5" = self.by-version."escape-string-regexp"."1.0.5";
      "has-ansi-2.0.0" = self.by-version."has-ansi"."2.0.0";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "supports-color-2.0.0" = self.by-version."supports-color"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "chalk" = self.by-version."chalk"."1.1.3";
  by-spec."chalk"."^1.0.0" =
    self.by-version."chalk"."1.1.3";
  by-spec."chalk"."^1.1.1" =
    self.by-version."chalk"."1.1.3";
  by-spec."cheerio"."0.22.0" =
    self.by-version."cheerio"."0.22.0";
  by-version."cheerio"."0.22.0" = self.buildNodePackage {
    name = "cheerio-0.22.0";
    version = "0.22.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cheerio/-/cheerio-0.22.0.tgz";
      name = "cheerio-0.22.0.tgz";
      sha1 = "a9baa860a3f9b595a6b81b1a86873121ed3a269e";
    };
    deps = {
      "css-select-1.2.0" = self.by-version."css-select"."1.2.0";
      "dom-serializer-0.1.0" = self.by-version."dom-serializer"."0.1.0";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
      "htmlparser2-3.9.2" = self.by-version."htmlparser2"."3.9.2";
      "lodash.assignin-4.2.0" = self.by-version."lodash.assignin"."4.2.0";
      "lodash.bind-4.2.1" = self.by-version."lodash.bind"."4.2.1";
      "lodash.defaults-4.2.0" = self.by-version."lodash.defaults"."4.2.0";
      "lodash.filter-4.6.0" = self.by-version."lodash.filter"."4.6.0";
      "lodash.flatten-4.4.0" = self.by-version."lodash.flatten"."4.4.0";
      "lodash.foreach-4.5.0" = self.by-version."lodash.foreach"."4.5.0";
      "lodash.map-4.6.0" = self.by-version."lodash.map"."4.6.0";
      "lodash.merge-4.6.0" = self.by-version."lodash.merge"."4.6.0";
      "lodash.pick-4.4.0" = self.by-version."lodash.pick"."4.4.0";
      "lodash.reduce-4.6.0" = self.by-version."lodash.reduce"."4.6.0";
      "lodash.reject-4.6.0" = self.by-version."lodash.reject"."4.6.0";
      "lodash.some-4.6.0" = self.by-version."lodash.some"."4.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cheerio" = self.by-version."cheerio"."0.22.0";
  by-spec."cjson"."~0.2.1" =
    self.by-version."cjson"."0.2.1";
  by-version."cjson"."0.2.1" = self.buildNodePackage {
    name = "cjson-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cjson/-/cjson-0.2.1.tgz";
      name = "cjson-0.2.1.tgz";
      sha1 = "73cd8aad65d9e1505f9af1744d3b79c1527682a5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cliui"."^2.1.0" =
    self.by-version."cliui"."2.1.0";
  by-version."cliui"."2.1.0" = self.buildNodePackage {
    name = "cliui-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cliui/-/cliui-2.1.0.tgz";
      name = "cliui-2.1.0.tgz";
      sha1 = "4b475760ff80264c762c3a1719032e91c7fea0d1";
    };
    deps = {
      "center-align-0.1.3" = self.by-version."center-align"."0.1.3";
      "right-align-0.1.3" = self.by-version."right-align"."0.1.3";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cliui"."^3.0.3" =
    self.by-version."cliui"."3.2.0";
  by-version."cliui"."3.2.0" = self.buildNodePackage {
    name = "cliui-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cliui/-/cliui-3.2.0.tgz";
      name = "cliui-3.2.0.tgz";
      sha1 = "120601537a916d29940f934da3b48d585a39213d";
    };
    deps = {
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "wrap-ansi-2.1.0" = self.by-version."wrap-ansi"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."clone"."^1.0.2" =
    self.by-version."clone"."1.0.2";
  by-version."clone"."1.0.2" = self.buildNodePackage {
    name = "clone-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/clone/-/clone-1.0.2.tgz";
      name = "clone-1.0.2.tgz";
      sha1 = "260b7a99ebb1edfe247538175f783243cb19d149";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."co"."^4.6.0" =
    self.by-version."co"."4.6.0";
  by-version."co"."4.6.0" = self.buildNodePackage {
    name = "co-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/co/-/co-4.6.0.tgz";
      name = "co-4.6.0.tgz";
      sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."code-point-at"."^1.0.0" =
    self.by-version."code-point-at"."1.1.0";
  by-version."code-point-at"."1.1.0" = self.buildNodePackage {
    name = "code-point-at-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz";
      name = "code-point-at-1.1.0.tgz";
      sha1 = "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."colors"."0.5.x" =
    self.by-version."colors"."0.5.1";
  by-version."colors"."0.5.1" = self.buildNodePackage {
    name = "colors-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/colors/-/colors-0.5.1.tgz";
      name = "colors-0.5.1.tgz";
      sha1 = "7d0023eaeb154e8ee9fce75dcb923d0ed1667774";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."colors"."^1.1.2" =
    self.by-version."colors"."1.1.2";
  by-version."colors"."1.1.2" = self.buildNodePackage {
    name = "colors-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/colors/-/colors-1.1.2.tgz";
      name = "colors-1.1.2.tgz";
      sha1 = "168a4701756b6a7f51a12ce0c97bfa28c084ed63";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."^1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-version."combined-stream"."1.0.5" = self.buildNodePackage {
    name = "combined-stream-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
      name = "combined-stream-1.0.5.tgz";
      sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
    };
    deps = {
      "delayed-stream-1.0.0" = self.by-version."delayed-stream"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."~1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-spec."commander"."2.9.0" =
    self.by-version."commander"."2.9.0";
  by-version."commander"."2.9.0" = self.buildNodePackage {
    name = "commander-2.9.0";
    version = "2.9.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
      name = "commander-2.9.0.tgz";
      sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
    };
    deps = {
      "graceful-readlink-1.0.1" = self.by-version."graceful-readlink"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."^2.2.0" =
    self.by-version."commander"."2.9.0";
  by-spec."commander"."^2.9.0" =
    self.by-version."commander"."2.9.0";
  by-spec."component-emitter"."^1.2.0" =
    self.by-version."component-emitter"."1.2.1";
  by-version."component-emitter"."1.2.1" = self.buildNodePackage {
    name = "component-emitter-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/component-emitter/-/component-emitter-1.2.1.tgz";
      name = "component-emitter-1.2.1.tgz";
      sha1 = "137918d6d78283f7df7a6b7c5a63e140e69425e6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."compress-commons"."^1.1.0" =
    self.by-version."compress-commons"."1.2.0";
  by-version."compress-commons"."1.2.0" = self.buildNodePackage {
    name = "compress-commons-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/compress-commons/-/compress-commons-1.2.0.tgz";
      name = "compress-commons-1.2.0.tgz";
      sha1 = "58587092ef20d37cb58baf000112c9278ff73b9f";
    };
    deps = {
      "buffer-crc32-0.2.13" = self.by-version."buffer-crc32"."0.2.13";
      "crc32-stream-2.0.0" = self.by-version."crc32-stream"."2.0.0";
      "normalize-path-2.1.1" = self.by-version."normalize-path"."2.1.1";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."compressible"."~2.0.8" =
    self.by-version."compressible"."2.0.10";
  by-version."compressible"."2.0.10" = self.buildNodePackage {
    name = "compressible-2.0.10";
    version = "2.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/compressible/-/compressible-2.0.10.tgz";
      name = "compressible-2.0.10.tgz";
      sha1 = "feda1c7f7617912732b29bf8cf26252a20b9eecd";
    };
    deps = {
      "mime-db-1.28.0" = self.by-version."mime-db"."1.28.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."compression"."1.6.2" =
    self.by-version."compression"."1.6.2";
  by-version."compression"."1.6.2" = self.buildNodePackage {
    name = "compression-1.6.2";
    version = "1.6.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/compression/-/compression-1.6.2.tgz";
      name = "compression-1.6.2.tgz";
      sha1 = "cceb121ecc9d09c52d7ad0c3350ea93ddd402bc3";
    };
    deps = {
      "accepts-1.3.3" = self.by-version."accepts"."1.3.3";
      "bytes-2.3.0" = self.by-version."bytes"."2.3.0";
      "compressible-2.0.10" = self.by-version."compressible"."2.0.10";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "on-headers-1.0.1" = self.by-version."on-headers"."1.0.1";
      "vary-1.1.1" = self.by-version."vary"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "compression" = self.by-version."compression"."1.6.2";
  by-spec."concat-map"."0.0.1" =
    self.by-version."concat-map"."0.0.1";
  by-version."concat-map"."0.0.1" = self.buildNodePackage {
    name = "concat-map-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
      name = "concat-map-0.0.1.tgz";
      sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."1.5.0" =
    self.by-version."concat-stream"."1.5.0";
  by-version."concat-stream"."1.5.0" = self.buildNodePackage {
    name = "concat-stream-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.5.0.tgz";
      name = "concat-stream-1.5.0.tgz";
      sha1 = "53f7d43c51c5e43f81c8fdd03321c631be68d611";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-2.0.6" = self.by-version."readable-stream"."2.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."^1.5.0" =
    self.by-version."concat-stream"."1.6.0";
  by-version."concat-stream"."1.6.0" = self.buildNodePackage {
    name = "concat-stream-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.0.tgz";
      name = "concat-stream-1.6.0.tgz";
      sha1 = "0aac662fd52be78964d5532f694784e70110acf7";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."config-chain"."~1.1.5" =
    self.by-version."config-chain"."1.1.11";
  by-version."config-chain"."1.1.11" = self.buildNodePackage {
    name = "config-chain-1.1.11";
    version = "1.1.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/config-chain/-/config-chain-1.1.11.tgz";
      name = "config-chain-1.1.11.tgz";
      sha1 = "aba09747dfbe4c3e70e766a6e41586e1859fc6f2";
    };
    deps = {
      "proto-list-1.2.4" = self.by-version."proto-list"."1.2.4";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connect-slashes"."1.3.1" =
    self.by-version."connect-slashes"."1.3.1";
  by-version."connect-slashes"."1.3.1" = self.buildNodePackage {
    name = "connect-slashes-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/connect-slashes/-/connect-slashes-1.3.1.tgz";
      name = "connect-slashes-1.3.1.tgz";
      sha1 = "95d61830d0f9d5853c8688f0b5f43988b186ac37";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "connect-slashes" = self.by-version."connect-slashes"."1.3.1";
  by-spec."console-control-strings"."^1.0.0" =
    self.by-version."console-control-strings"."1.1.0";
  by-version."console-control-strings"."1.1.0" = self.buildNodePackage {
    name = "console-control-strings-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz";
      name = "console-control-strings-1.1.0.tgz";
      sha1 = "3d7cf4464db6446ea644bf4b39507f9851008e8e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."console-control-strings"."~1.1.0" =
    self.by-version."console-control-strings"."1.1.0";
  by-spec."content-disposition"."0.5.1" =
    self.by-version."content-disposition"."0.5.1";
  by-version."content-disposition"."0.5.1" = self.buildNodePackage {
    name = "content-disposition-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.1.tgz";
      name = "content-disposition-0.5.1.tgz";
      sha1 = "87476c6a67c8daa87e32e87616df883ba7fb071b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-disposition"."0.5.2" =
    self.by-version."content-disposition"."0.5.2";
  by-version."content-disposition"."0.5.2" = self.buildNodePackage {
    name = "content-disposition-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.2.tgz";
      name = "content-disposition-0.5.2.tgz";
      sha1 = "0cf68bb9ddf5f2be7961c3a85178cb85dba78cb4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-type"."~1.0.2" =
    self.by-version."content-type"."1.0.2";
  by-version."content-type"."1.0.2" = self.buildNodePackage {
    name = "content-type-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/content-type/-/content-type-1.0.2.tgz";
      name = "content-type-1.0.2.tgz";
      sha1 = "b7d113aee7a8dd27bd21133c4dc2529df1721eed";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie"."0.3.1" =
    self.by-version."cookie"."0.3.1";
  by-version."cookie"."0.3.1" = self.buildNodePackage {
    name = "cookie-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookie/-/cookie-0.3.1.tgz";
      name = "cookie-0.3.1.tgz";
      sha1 = "e7e0a1f9ef43b4c8ba925c5c5a96e806d16873bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-session"."1.2.0" =
    self.by-version."cookie-session"."1.2.0";
  by-version."cookie-session"."1.2.0" = self.buildNodePackage {
    name = "cookie-session-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookie-session/-/cookie-session-1.2.0.tgz";
      name = "cookie-session-1.2.0.tgz";
      sha1 = "9df2beb9e723998e70d1e31fda37b28a0bcf37ff";
    };
    deps = {
      "cookies-0.5.0" = self.by-version."cookies"."0.5.0";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "on-headers-1.0.1" = self.by-version."on-headers"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cookie-session" = self.by-version."cookie-session"."1.2.0";
  by-spec."cookie-signature"."1.0.6" =
    self.by-version."cookie-signature"."1.0.6";
  by-version."cookie-signature"."1.0.6" = self.buildNodePackage {
    name = "cookie-signature-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz";
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
  by-spec."cookiejar"."^2.0.6" =
    self.by-version."cookiejar"."2.1.1";
  by-version."cookiejar"."2.1.1" = self.buildNodePackage {
    name = "cookiejar-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookiejar/-/cookiejar-2.1.1.tgz";
      name = "cookiejar-2.1.1.tgz";
      sha1 = "41ad57b1b555951ec171412a81942b1e8200d34a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookies"."0.5.0" =
    self.by-version."cookies"."0.5.0";
  by-version."cookies"."0.5.0" = self.buildNodePackage {
    name = "cookies-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookies/-/cookies-0.5.0.tgz";
      name = "cookies-0.5.0.tgz";
      sha1 = "164cac46a1d3ca3b3b87427414c24931d8381025";
    };
    deps = {
      "keygrip-1.0.1" = self.by-version."keygrip"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."core-js"."^2.4.0" =
    self.by-version."core-js"."2.4.1";
  by-version."core-js"."2.4.1" = self.buildNodePackage {
    name = "core-js-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/core-js/-/core-js-2.4.1.tgz";
      name = "core-js-2.4.1.tgz";
      sha1 = "4de911e667b0eae9124e34254b53aea6fc618d3e";
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
    self.by-version."core-util-is"."1.0.2";
  by-version."core-util-is"."1.0.2" = self.buildNodePackage {
    name = "core-util-is-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
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
  by-spec."cors"."2.8.3" =
    self.by-version."cors"."2.8.3";
  by-version."cors"."2.8.3" = self.buildNodePackage {
    name = "cors-2.8.3";
    version = "2.8.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cors/-/cors-2.8.3.tgz";
      name = "cors-2.8.3.tgz";
      sha1 = "4cf78e1d23329a7496b2fc2225b77ca5bb5eb802";
    };
    deps = {
      "object-assign-4.1.1" = self.by-version."object-assign"."4.1.1";
      "vary-1.1.1" = self.by-version."vary"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cors" = self.by-version."cors"."2.8.3";
  by-spec."crc"."^3.4.4" =
    self.by-version."crc"."3.4.4";
  by-version."crc"."3.4.4" = self.buildNodePackage {
    name = "crc-3.4.4";
    version = "3.4.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/crc/-/crc-3.4.4.tgz";
      name = "crc-3.4.4.tgz";
      sha1 = "9da1e980e3bd44fc5c93bf5ab3da3378d85e466b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."crc32-stream"."^2.0.0" =
    self.by-version."crc32-stream"."2.0.0";
  by-version."crc32-stream"."2.0.0" = self.buildNodePackage {
    name = "crc32-stream-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/crc32-stream/-/crc32-stream-2.0.0.tgz";
      name = "crc32-stream-2.0.0.tgz";
      sha1 = "e3cdd3b4df3168dd74e3de3fbbcb7b297fe908f4";
    };
    deps = {
      "crc-3.4.4" = self.by-version."crc"."3.4.4";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."create-error"."~0.3.1" =
    self.by-version."create-error"."0.3.1";
  by-version."create-error"."0.3.1" = self.buildNodePackage {
    name = "create-error-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/create-error/-/create-error-0.3.1.tgz";
      name = "create-error-0.3.1.tgz";
      sha1 = "69810245a629e654432bf04377360003a5351a23";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."2.x.x" =
    self.by-version."cryptiles"."2.0.5";
  by-version."cryptiles"."2.0.5" = self.buildNodePackage {
    name = "cryptiles-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
      name = "cryptiles-2.0.5.tgz";
      sha1 = "3bdfecdc608147c1c67202fa291e7dca59eaa3b8";
    };
    deps = {
      "boom-2.10.1" = self.by-version."boom"."2.10.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."css-select"."~1.2.0" =
    self.by-version."css-select"."1.2.0";
  by-version."css-select"."1.2.0" = self.buildNodePackage {
    name = "css-select-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/css-select/-/css-select-1.2.0.tgz";
      name = "css-select-1.2.0.tgz";
      sha1 = "2b3a110539c5355f1cd8d314623e870b121ec858";
    };
    deps = {
      "css-what-2.1.0" = self.by-version."css-what"."2.1.0";
      "domutils-1.5.1" = self.by-version."domutils"."1.5.1";
      "boolbase-1.0.0" = self.by-version."boolbase"."1.0.0";
      "nth-check-1.0.1" = self.by-version."nth-check"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."css-what"."2.1" =
    self.by-version."css-what"."2.1.0";
  by-version."css-what"."2.1.0" = self.buildNodePackage {
    name = "css-what-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/css-what/-/css-what-2.1.0.tgz";
      name = "css-what-2.1.0.tgz";
      sha1 = "9467d032c38cfaefb9f2d79501253062f87fa1bd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."csv-parser"."1.11.0" =
    self.by-version."csv-parser"."1.11.0";
  by-version."csv-parser"."1.11.0" = self.buildNodePackage {
    name = "csv-parser-1.11.0";
    version = "1.11.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/csv-parser/-/csv-parser-1.11.0.tgz";
      name = "csv-parser-1.11.0.tgz";
      sha1 = "cd92c3f49895a3c1591591035cbfbe6b51c55ab1";
    };
    deps = {
      "generate-function-1.1.0" = self.by-version."generate-function"."1.1.0";
      "generate-object-property-1.2.0" = self.by-version."generate-object-property"."1.2.0";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "ndjson-1.5.0" = self.by-version."ndjson"."1.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "csv-parser" = self.by-version."csv-parser"."1.11.0";
  by-spec."dashdash"."^1.12.0" =
    self.by-version."dashdash"."1.14.1";
  by-version."dashdash"."1.14.1" = self.buildNodePackage {
    name = "dashdash-1.14.1";
    version = "1.14.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz";
      name = "dashdash-1.14.1.tgz";
      sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
    };
    deps = {
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."0.7.4" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = self.buildNodePackage {
    name = "debug-0.7.4";
    version = "0.7.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
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
  by-spec."debug"."2.6.1" =
    self.by-version."debug"."2.6.1";
  by-version."debug"."2.6.1" = self.buildNodePackage {
    name = "debug-2.6.1";
    version = "2.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.6.1.tgz";
      name = "debug-2.6.1.tgz";
      sha1 = "79855090ba2c4e3115cc7d8769491d58f0491351";
    };
    deps = {
      "ms-0.7.2" = self.by-version."ms"."0.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."2.6.7" =
    self.by-version."debug"."2.6.7";
  by-version."debug"."2.6.7" = self.buildNodePackage {
    name = "debug-2.6.7";
    version = "2.6.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.6.7.tgz";
      name = "debug-2.6.7.tgz";
      sha1 = "92bad1f6d05bbb6bba22cca88bcd0ec894c2861e";
    };
    deps = {
      "ms-2.0.0" = self.by-version."ms"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."2.x.x" =
    self.by-version."debug"."2.6.8";
  by-version."debug"."2.6.8" = self.buildNodePackage {
    name = "debug-2.6.8";
    version = "2.6.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.6.8.tgz";
      name = "debug-2.6.8.tgz";
      sha1 = "e731531ca2ede27d188222427da17821d68ff4fc";
    };
    deps = {
      "ms-2.0.0" = self.by-version."ms"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."^2.1.3" =
    self.by-version."debug"."2.6.8";
  by-spec."debug"."^2.2.0" =
    self.by-version."debug"."2.6.8";
  by-spec."debug"."~2.2.0" =
    self.by-version."debug"."2.2.0";
  by-version."debug"."2.2.0" = self.buildNodePackage {
    name = "debug-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.2.0.tgz";
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
  by-spec."decamelize"."^1.0.0" =
    self.by-version."decamelize"."1.2.0";
  by-version."decamelize"."1.2.0" = self.buildNodePackage {
    name = "decamelize-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz";
      name = "decamelize-1.2.0.tgz";
      sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."decamelize"."^1.1.1" =
    self.by-version."decamelize"."1.2.0";
  by-spec."deep-eql"."^0.1.3" =
    self.by-version."deep-eql"."0.1.3";
  by-version."deep-eql"."0.1.3" = self.buildNodePackage {
    name = "deep-eql-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-eql/-/deep-eql-0.1.3.tgz";
      name = "deep-eql-0.1.3.tgz";
      sha1 = "ef558acab8de25206cd713906d74e56930eb69f2";
    };
    deps = {
      "type-detect-0.1.1" = self.by-version."type-detect"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-equal"."^1.0.0" =
    self.by-version."deep-equal"."1.0.1";
  by-version."deep-equal"."1.0.1" = self.buildNodePackage {
    name = "deep-equal-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-equal/-/deep-equal-1.0.1.tgz";
      name = "deep-equal-1.0.1.tgz";
      sha1 = "f5d260292b660e084eff4cdbc9f08ad3247448b5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-extend"."~0.4.0" =
    self.by-version."deep-extend"."0.4.2";
  by-version."deep-extend"."0.4.2" = self.buildNodePackage {
    name = "deep-extend-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-extend/-/deep-extend-0.4.2.tgz";
      name = "deep-extend-0.4.2.tgz";
      sha1 = "48b699c27e334bf89f10892be432f6e4c7d34a7f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."delayed-stream"."~1.0.0" =
    self.by-version."delayed-stream"."1.0.0";
  by-version."delayed-stream"."1.0.0" = self.buildNodePackage {
    name = "delayed-stream-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
      name = "delayed-stream-1.0.0.tgz";
      sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."delegates"."^1.0.0" =
    self.by-version."delegates"."1.0.0";
  by-version."delegates"."1.0.0" = self.buildNodePackage {
    name = "delegates-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz";
      name = "delegates-1.0.0.tgz";
      sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."depd"."1.1.0" =
    self.by-version."depd"."1.1.0";
  by-version."depd"."1.1.0" = self.buildNodePackage {
    name = "depd-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/depd/-/depd-1.1.0.tgz";
      name = "depd-1.1.0.tgz";
      sha1 = "e1bd82c6aab6ced965b97b88b17ed3e528ca18c3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."depd"."~1.1.0" =
    self.by-version."depd"."1.1.0";
  by-spec."destroy"."~1.0.4" =
    self.by-version."destroy"."1.0.4";
  by-version."destroy"."1.0.4" = self.buildNodePackage {
    name = "destroy-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz";
      name = "destroy-1.0.4.tgz";
      sha1 = "978857442c44749e4206613e37946205826abd80";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."detect-file"."^0.1.0" =
    self.by-version."detect-file"."0.1.0";
  by-version."detect-file"."0.1.0" = self.buildNodePackage {
    name = "detect-file-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/detect-file/-/detect-file-0.1.0.tgz";
      name = "detect-file-0.1.0.tgz";
      sha1 = "4935dedfd9488648e006b0129566e9386711ea63";
    };
    deps = {
      "fs-exists-sync-0.1.0" = self.by-version."fs-exists-sync"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dicer"."0.2.5" =
    self.by-version."dicer"."0.2.5";
  by-version."dicer"."0.2.5" = self.buildNodePackage {
    name = "dicer-0.2.5";
    version = "0.2.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dicer/-/dicer-0.2.5.tgz";
      name = "dicer-0.2.5.tgz";
      sha1 = "5996c086bb33218c812c090bddc09cd12facb70f";
    };
    deps = {
      "streamsearch-0.1.2" = self.by-version."streamsearch"."0.1.2";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."directmail"."~0.1.7" =
    self.by-version."directmail"."0.1.8";
  by-version."directmail"."0.1.8" = self.buildNodePackage {
    name = "directmail-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/directmail/-/directmail-0.1.8.tgz";
      name = "directmail-0.1.8.tgz";
      sha1 = "e4852c8a0c5519bef4904fcd96d760822f42a446";
    };
    deps = {
      "simplesmtp-0.3.35" = self.by-version."simplesmtp"."0.3.35";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dkim-signer"."~0.1.1" =
    self.by-version."dkim-signer"."0.1.2";
  by-version."dkim-signer"."0.1.2" = self.buildNodePackage {
    name = "dkim-signer-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dkim-signer/-/dkim-signer-0.1.2.tgz";
      name = "dkim-signer-0.1.2.tgz";
      sha1 = "2ff5d61c87d8fbff5a8b131cffc5ec3ba1c25553";
    };
    deps = {
      "punycode-1.2.4" = self.by-version."punycode"."1.2.4";
      "mimelib-0.2.19" = self.by-version."mimelib"."0.2.19";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dom-serializer"."0" =
    self.by-version."dom-serializer"."0.1.0";
  by-version."dom-serializer"."0.1.0" = self.buildNodePackage {
    name = "dom-serializer-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dom-serializer/-/dom-serializer-0.1.0.tgz";
      name = "dom-serializer-0.1.0.tgz";
      sha1 = "073c697546ce0780ce23be4a28e293e40bc30c82";
    };
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dom-serializer"."~0.1.0" =
    self.by-version."dom-serializer"."0.1.0";
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.3.0";
  by-version."domelementtype"."1.3.0" = self.buildNodePackage {
    name = "domelementtype-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domelementtype/-/domelementtype-1.3.0.tgz";
      name = "domelementtype-1.3.0.tgz";
      sha1 = "b17aed82e8ab59e52dd9c19b1756e0fc187204c2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domelementtype"."^1.3.0" =
    self.by-version."domelementtype"."1.3.0";
  by-spec."domelementtype"."~1.1.1" =
    self.by-version."domelementtype"."1.1.3";
  by-version."domelementtype"."1.1.3" = self.buildNodePackage {
    name = "domelementtype-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domelementtype/-/domelementtype-1.1.3.tgz";
      name = "domelementtype-1.1.3.tgz";
      sha1 = "bd28773e2642881aec51544924299c5cd822185b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domhandler"."^2.3.0" =
    self.by-version."domhandler"."2.4.1";
  by-version."domhandler"."2.4.1" = self.buildNodePackage {
    name = "domhandler-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domhandler/-/domhandler-2.4.1.tgz";
      name = "domhandler-2.4.1.tgz";
      sha1 = "892e47000a99be55bbf3774ffea0561d8879c259";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domutils"."1.5.1" =
    self.by-version."domutils"."1.5.1";
  by-version."domutils"."1.5.1" = self.buildNodePackage {
    name = "domutils-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domutils/-/domutils-1.5.1.tgz";
      name = "domutils-1.5.1.tgz";
      sha1 = "dcd8488a26f563d61079e48c9f7b7e32373682cf";
    };
    deps = {
      "dom-serializer-0.1.0" = self.by-version."dom-serializer"."0.1.0";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domutils"."^1.5.1" =
    self.by-version."domutils"."1.6.2";
  by-version."domutils"."1.6.2" = self.buildNodePackage {
    name = "domutils-1.6.2";
    version = "1.6.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domutils/-/domutils-1.6.2.tgz";
      name = "domutils-1.6.2.tgz";
      sha1 = "1958cc0b4c9426e9ed367fb1c8e854891b0fa3ff";
    };
    deps = {
      "dom-serializer-0.1.0" = self.by-version."dom-serializer"."0.1.0";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."downsize"."0.0.8" =
    self.by-version."downsize"."0.0.8";
  by-version."downsize"."0.0.8" = self.buildNodePackage {
    name = "downsize-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/downsize/-/downsize-0.0.8.tgz";
      name = "downsize-0.0.8.tgz";
      sha1 = "21435a610c8c68220f5cc31474979b4d025f038e";
    };
    deps = {
      "xregexp-2.0.0" = self.by-version."xregexp"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "downsize" = self.by-version."downsize"."0.0.8";
  by-spec."dtrace-provider"."~0.8" =
    self.by-version."dtrace-provider"."0.8.2";
  by-version."dtrace-provider"."0.8.2" = self.buildNodePackage {
    name = "dtrace-provider-0.8.2";
    version = "0.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dtrace-provider/-/dtrace-provider-0.8.2.tgz";
      name = "dtrace-provider-0.8.2.tgz";
      sha1 = "f067c2773f15da1b61eb20dbc96aa1cabb3330bc";
    };
    deps = {
      "nan-2.6.2" = self.by-version."nan"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ebnf-parser"."~0.1.9" =
    self.by-version."ebnf-parser"."0.1.10";
  by-version."ebnf-parser"."0.1.10" = self.buildNodePackage {
    name = "ebnf-parser-0.1.10";
    version = "0.1.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ebnf-parser/-/ebnf-parser-0.1.10.tgz";
      name = "ebnf-parser-0.1.10.tgz";
      sha1 = "cd1f6ba477c5638c40c97ed9b572db5bab5d8331";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ecc-jsbn"."~0.1.1" =
    self.by-version."ecc-jsbn"."0.1.1";
  by-version."ecc-jsbn"."0.1.1" = self.buildNodePackage {
    name = "ecc-jsbn-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
      name = "ecc-jsbn-0.1.1.tgz";
      sha1 = "0fc73a9ed5f0d53c38193398523ef7e543777505";
    };
    deps = {
      "jsbn-0.1.1" = self.by-version."jsbn"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."editorconfig"."^0.13.2" =
    self.by-version."editorconfig"."0.13.2";
  by-version."editorconfig"."0.13.2" = self.buildNodePackage {
    name = "editorconfig-0.13.2";
    version = "0.13.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/editorconfig/-/editorconfig-0.13.2.tgz";
      name = "editorconfig-0.13.2.tgz";
      sha1 = "8e57926d9ee69ab6cb999f027c2171467acceb35";
    };
    deps = {
      "bluebird-3.5.0" = self.by-version."bluebird"."3.5.0";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "lru-cache-3.2.0" = self.by-version."lru-cache"."3.2.0";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ee-first"."1.1.1" =
    self.by-version."ee-first"."1.1.1";
  by-version."ee-first"."1.1.1" = self.buildNodePackage {
    name = "ee-first-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz";
      name = "ee-first-1.1.1.tgz";
      sha1 = "590c61156b0ae2f4f0255732a158b266bc56b21d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."emits"."3.0.0" =
    self.by-version."emits"."3.0.0";
  by-version."emits"."3.0.0" = self.buildNodePackage {
    name = "emits-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/emits/-/emits-3.0.0.tgz";
      name = "emits-3.0.0.tgz";
      sha1 = "32752bba95e1707b219562384ab9bb8b1fd62f70";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."encodeurl"."~1.0.1" =
    self.by-version."encodeurl"."1.0.1";
  by-version."encodeurl"."1.0.1" = self.buildNodePackage {
    name = "encodeurl-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.1.tgz";
      name = "encodeurl-1.0.1.tgz";
      sha1 = "79e3d58655346909fe6f0f45a5de68103b294d20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."encoding"."~0.1.7" =
    self.by-version."encoding"."0.1.12";
  by-version."encoding"."0.1.12" = self.buildNodePackage {
    name = "encoding-0.1.12";
    version = "0.1.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/encoding/-/encoding-0.1.12.tgz";
      name = "encoding-0.1.12.tgz";
      sha1 = "538b66f3ee62cd1ab51ec323829d1f9480c74beb";
    };
    deps = {
      "iconv-lite-0.4.17" = self.by-version."iconv-lite"."0.4.17";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."^1.0.0" =
    self.by-version."end-of-stream"."1.4.0";
  by-version."end-of-stream"."1.4.0" = self.buildNodePackage {
    name = "end-of-stream-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.0.tgz";
      name = "end-of-stream-1.4.0.tgz";
      sha1 = "7a90d833efda6cfa6eac0f4949dbb0fad3a63206";
    };
    deps = {
      "once-1.4.0" = self.by-version."once"."1.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."entities"."^1.1.1" =
    self.by-version."entities"."1.1.1";
  by-version."entities"."1.1.1" = self.buildNodePackage {
    name = "entities-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/entities/-/entities-1.1.1.tgz";
      name = "entities-1.1.1.tgz";
      sha1 = "6e5c2d0a5621b5dadaecef80b90edfb5cd7772f0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."entities"."~1.1.1" =
    self.by-version."entities"."1.1.1";
  by-spec."escape-html"."~1.0.3" =
    self.by-version."escape-html"."1.0.3";
  by-version."escape-html"."1.0.3" = self.buildNodePackage {
    name = "escape-html-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz";
      name = "escape-html-1.0.3.tgz";
      sha1 = "0258eae4d3d0c0974de1c169188ef0051d1d1988";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."^1.0.2" =
    self.by-version."escape-string-regexp"."1.0.5";
  by-version."escape-string-regexp"."1.0.5" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
      name = "escape-string-regexp-1.0.5.tgz";
      sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escodegen"."0.0.21" =
    self.by-version."escodegen"."0.0.21";
  by-version."escodegen"."0.0.21" = self.buildNodePackage {
    name = "escodegen-0.0.21";
    version = "0.0.21";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/escodegen/-/escodegen-0.0.21.tgz";
      name = "escodegen-0.0.21.tgz";
      sha1 = "53d652cfa1030388279458a5266c5ffc709c63c3";
    };
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "estraverse-0.0.4" = self.by-version."estraverse"."0.0.4";
    };
    optionalDependencies = {
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escodegen"."~0.0.24" =
    self.by-version."escodegen"."0.0.28";
  by-version."escodegen"."0.0.28" = self.buildNodePackage {
    name = "escodegen-0.0.28";
    version = "0.0.28";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/escodegen/-/escodegen-0.0.28.tgz";
      name = "escodegen-0.0.28.tgz";
      sha1 = "0e4ff1715f328775d6cab51ac44a406cd7abffd3";
    };
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "estraverse-1.3.2" = self.by-version."estraverse"."1.3.2";
    };
    optionalDependencies = {
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."1.0.x" =
    self.by-version."esprima"."1.0.4";
  by-version."esprima"."1.0.4" = self.buildNodePackage {
    name = "esprima-1.0.4";
    version = "1.0.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
      name = "esprima-1.0.4.tgz";
      sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."1.2.2" =
    self.by-version."esprima"."1.2.2";
  by-version."esprima"."1.2.2" = self.buildNodePackage {
    name = "esprima-1.2.2";
    version = "1.2.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima/-/esprima-1.2.2.tgz";
      name = "esprima-1.2.2.tgz";
      sha1 = "76a0fd66fcfe154fd292667dc264019750b1657b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."~1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-spec."estraverse"."~0.0.4" =
    self.by-version."estraverse"."0.0.4";
  by-version."estraverse"."0.0.4" = self.buildNodePackage {
    name = "estraverse-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/estraverse/-/estraverse-0.0.4.tgz";
      name = "estraverse-0.0.4.tgz";
      sha1 = "01a0932dfee574684a598af5a67c3bf9b6428db2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."estraverse"."~1.3.0" =
    self.by-version."estraverse"."1.3.2";
  by-version."estraverse"."1.3.2" = self.buildNodePackage {
    name = "estraverse-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/estraverse/-/estraverse-1.3.2.tgz";
      name = "estraverse-1.3.2.tgz";
      sha1 = "37c2b893ef13d723f276d878d60d8535152a6c42";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."etag"."~1.7.0" =
    self.by-version."etag"."1.7.0";
  by-version."etag"."1.7.0" = self.buildNodePackage {
    name = "etag-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/etag/-/etag-1.7.0.tgz";
      name = "etag-1.7.0.tgz";
      sha1 = "03d30b5f67dd6e632d2945d30d6652731a34d5d8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."etag"."~1.8.0" =
    self.by-version."etag"."1.8.0";
  by-version."etag"."1.8.0" = self.buildNodePackage {
    name = "etag-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/etag/-/etag-1.8.0.tgz";
      name = "etag-1.8.0.tgz";
      sha1 = "6f631aef336d6c46362b51764044ce216be3c051";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-brackets"."^0.1.4" =
    self.by-version."expand-brackets"."0.1.5";
  by-version."expand-brackets"."0.1.5" = self.buildNodePackage {
    name = "expand-brackets-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz";
      name = "expand-brackets-0.1.5.tgz";
      sha1 = "df07284e342a807cd733ac5af72411e581d1177b";
    };
    deps = {
      "is-posix-bracket-0.1.1" = self.by-version."is-posix-bracket"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-range"."^1.8.1" =
    self.by-version."expand-range"."1.8.2";
  by-version."expand-range"."1.8.2" = self.buildNodePackage {
    name = "expand-range-1.8.2";
    version = "1.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz";
      name = "expand-range-1.8.2.tgz";
      sha1 = "a299effd335fe2721ebae8e257ec79644fc85337";
    };
    deps = {
      "fill-range-2.2.3" = self.by-version."fill-range"."2.2.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-tilde"."^1.2.2" =
    self.by-version."expand-tilde"."1.2.2";
  by-version."expand-tilde"."1.2.2" = self.buildNodePackage {
    name = "expand-tilde-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/expand-tilde/-/expand-tilde-1.2.2.tgz";
      name = "expand-tilde-1.2.2.tgz";
      sha1 = "0b81eba897e5a3d31d1c3d102f8f01441e559449";
    };
    deps = {
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."4.14.0" =
    self.by-version."express"."4.14.0";
  by-version."express"."4.14.0" = self.buildNodePackage {
    name = "express-4.14.0";
    version = "4.14.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/express/-/express-4.14.0.tgz";
      name = "express-4.14.0.tgz";
      sha1 = "c1ee3f42cdc891fb3dc650a8922d51ec847d0d66";
    };
    deps = {
      "accepts-1.3.3" = self.by-version."accepts"."1.3.3";
      "array-flatten-1.1.1" = self.by-version."array-flatten"."1.1.1";
      "content-disposition-0.5.1" = self.by-version."content-disposition"."0.5.1";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "cookie-0.3.1" = self.by-version."cookie"."0.3.1";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.7.0" = self.by-version."etag"."1.7.0";
      "finalhandler-0.5.0" = self.by-version."finalhandler"."0.5.0";
      "fresh-0.3.0" = self.by-version."fresh"."0.3.0";
      "merge-descriptors-1.0.1" = self.by-version."merge-descriptors"."1.0.1";
      "methods-1.1.2" = self.by-version."methods"."1.1.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "path-to-regexp-0.1.7" = self.by-version."path-to-regexp"."0.1.7";
      "proxy-addr-1.1.4" = self.by-version."proxy-addr"."1.1.4";
      "qs-6.2.0" = self.by-version."qs"."6.2.0";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "send-0.14.1" = self.by-version."send"."0.14.1";
      "serve-static-1.11.2" = self.by-version."serve-static"."1.11.2";
      "type-is-1.6.15" = self.by-version."type-is"."1.6.15";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vary-1.1.1" = self.by-version."vary"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."4.15.0" =
    self.by-version."express"."4.15.0";
  by-version."express"."4.15.0" = self.buildNodePackage {
    name = "express-4.15.0";
    version = "4.15.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/express/-/express-4.15.0.tgz";
      name = "express-4.15.0.tgz";
      sha1 = "8fb125829f70a04a59e1c40ceb8dea19cf5c879c";
    };
    deps = {
      "accepts-1.3.3" = self.by-version."accepts"."1.3.3";
      "array-flatten-1.1.1" = self.by-version."array-flatten"."1.1.1";
      "content-disposition-0.5.2" = self.by-version."content-disposition"."0.5.2";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "cookie-0.3.1" = self.by-version."cookie"."0.3.1";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.8.0" = self.by-version."etag"."1.8.0";
      "finalhandler-1.0.3" = self.by-version."finalhandler"."1.0.3";
      "fresh-0.5.0" = self.by-version."fresh"."0.5.0";
      "merge-descriptors-1.0.1" = self.by-version."merge-descriptors"."1.0.1";
      "methods-1.1.2" = self.by-version."methods"."1.1.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "path-to-regexp-0.1.7" = self.by-version."path-to-regexp"."0.1.7";
      "proxy-addr-1.1.4" = self.by-version."proxy-addr"."1.1.4";
      "qs-6.3.1" = self.by-version."qs"."6.3.1";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "send-0.15.0" = self.by-version."send"."0.15.0";
      "serve-static-1.12.0" = self.by-version."serve-static"."1.12.0";
      "setprototypeof-1.0.3" = self.by-version."setprototypeof"."1.0.3";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
      "type-is-1.6.15" = self.by-version."type-is"."1.6.15";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vary-1.1.1" = self.by-version."vary"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."4.15.0";
  by-spec."express-hbs"."1.0.3" =
    self.by-version."express-hbs"."1.0.3";
  by-version."express-hbs"."1.0.3" = self.buildNodePackage {
    name = "express-hbs-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/express-hbs/-/express-hbs-1.0.3.tgz";
      name = "express-hbs-1.0.3.tgz";
      sha1 = "ee84abbde0a54beaa1f9471089c9a8e294ebc590";
    };
    deps = {
      "handlebars-4.0.10" = self.by-version."handlebars"."4.0.10";
      "js-beautify-1.6.4" = self.by-version."js-beautify"."1.6.4";
      "readdirp-2.1.0" = self.by-version."readdirp"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express-hbs"."1.0.4" =
    self.by-version."express-hbs"."1.0.4";
  by-version."express-hbs"."1.0.4" = self.buildNodePackage {
    name = "express-hbs-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/express-hbs/-/express-hbs-1.0.4.tgz";
      name = "express-hbs-1.0.4.tgz";
      sha1 = "c4480d6e8a9f8c23500d3b1a1394f17eae451786";
    };
    deps = {
      "handlebars-4.0.6" = self.by-version."handlebars"."4.0.6";
      "js-beautify-1.6.8" = self.by-version."js-beautify"."1.6.8";
      "readdirp-2.1.0" = self.by-version."readdirp"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express-hbs" = self.by-version."express-hbs"."1.0.4";
  by-spec."extend"."^3.0.0" =
    self.by-version."extend"."3.0.1";
  by-version."extend"."3.0.1" = self.buildNodePackage {
    name = "extend-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extend/-/extend-3.0.1.tgz";
      name = "extend-3.0.1.tgz";
      sha1 = "a755ea7bc1adfcc5a31ce7e762dbaadc5e636444";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extend"."~3.0.0" =
    self.by-version."extend"."3.0.1";
  by-spec."extglob"."^0.3.1" =
    self.by-version."extglob"."0.3.2";
  by-version."extglob"."0.3.2" = self.buildNodePackage {
    name = "extglob-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz";
      name = "extglob-0.3.2.tgz";
      sha1 = "2e18ff3d2f49ab2765cec9023f011daa8d8349a1";
    };
    deps = {
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extract-zip-fork"."1.5.1" =
    self.by-version."extract-zip-fork"."1.5.1";
  by-version."extract-zip-fork"."1.5.1" = self.buildNodePackage {
    name = "extract-zip-fork-1.5.1";
    version = "1.5.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/extract-zip-fork/-/extract-zip-fork-1.5.1.tgz";
      name = "extract-zip-fork-1.5.1.tgz";
      sha1 = "f28d9409c1ec90256deb5875cb80ae2f9b292a7b";
    };
    deps = {
      "concat-stream-1.5.0" = self.by-version."concat-stream"."1.5.0";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "yauzl-2.4.1" = self.by-version."yauzl"."2.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "extract-zip-fork" = self.by-version."extract-zip-fork"."1.5.1";
  by-spec."extsprintf"."1.0.2" =
    self.by-version."extsprintf"."1.0.2";
  by-version."extsprintf"."1.0.2" = self.buildNodePackage {
    name = "extsprintf-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
      name = "extsprintf-1.0.2.tgz";
      sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fd-slicer"."~1.0.1" =
    self.by-version."fd-slicer"."1.0.1";
  by-version."fd-slicer"."1.0.1" = self.buildNodePackage {
    name = "fd-slicer-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.0.1.tgz";
      name = "fd-slicer-1.0.1.tgz";
      sha1 = "8b5bcbd9ec327c5041bf9ab023fd6750f1177e65";
    };
    deps = {
      "pend-1.2.0" = self.by-version."pend"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."filename-regex"."^2.0.0" =
    self.by-version."filename-regex"."2.0.1";
  by-version."filename-regex"."2.0.1" = self.buildNodePackage {
    name = "filename-regex-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.1.tgz";
      name = "filename-regex-2.0.1.tgz";
      sha1 = "c1c4b9bee3e09725ddb106b75c1e301fe2f18b26";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fill-range"."^2.1.0" =
    self.by-version."fill-range"."2.2.3";
  by-version."fill-range"."2.2.3" = self.buildNodePackage {
    name = "fill-range-2.2.3";
    version = "2.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fill-range/-/fill-range-2.2.3.tgz";
      name = "fill-range-2.2.3.tgz";
      sha1 = "50b77dfd7e469bc7492470963699fe7a8485a723";
    };
    deps = {
      "is-number-2.1.0" = self.by-version."is-number"."2.1.0";
      "isobject-2.1.0" = self.by-version."isobject"."2.1.0";
      "randomatic-1.1.6" = self.by-version."randomatic"."1.1.6";
      "repeat-element-1.1.2" = self.by-version."repeat-element"."1.1.2";
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."finalhandler"."0.5.0" =
    self.by-version."finalhandler"."0.5.0";
  by-version."finalhandler"."0.5.0" = self.buildNodePackage {
    name = "finalhandler-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/finalhandler/-/finalhandler-0.5.0.tgz";
      name = "finalhandler-0.5.0.tgz";
      sha1 = "e9508abece9b6dba871a6942a1d7911b91911ac7";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
      "unpipe-1.0.0" = self.by-version."unpipe"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."finalhandler"."~1.0.0" =
    self.by-version."finalhandler"."1.0.3";
  by-version."finalhandler"."1.0.3" = self.buildNodePackage {
    name = "finalhandler-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/finalhandler/-/finalhandler-1.0.3.tgz";
      name = "finalhandler-1.0.3.tgz";
      sha1 = "ef47e77950e999780e86022a560e3217e0d0cc89";
    };
    deps = {
      "debug-2.6.7" = self.by-version."debug"."2.6.7";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
      "unpipe-1.0.0" = self.by-version."unpipe"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."find-root"."1.0.0" =
    self.by-version."find-root"."1.0.0";
  by-version."find-root"."1.0.0" = self.buildNodePackage {
    name = "find-root-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/find-root/-/find-root-1.0.0.tgz";
      name = "find-root-1.0.0.tgz";
      sha1 = "962ff211aab25c6520feeeb8d6287f8f6e95807a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."findup-sync"."^0.4.2" =
    self.by-version."findup-sync"."0.4.3";
  by-version."findup-sync"."0.4.3" = self.buildNodePackage {
    name = "findup-sync-0.4.3";
    version = "0.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/findup-sync/-/findup-sync-0.4.3.tgz";
      name = "findup-sync-0.4.3.tgz";
      sha1 = "40043929e7bc60adf0b7f4827c4c6e75a0deca12";
    };
    deps = {
      "detect-file-0.1.0" = self.by-version."detect-file"."0.1.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
      "micromatch-2.3.11" = self.by-version."micromatch"."2.3.11";
      "resolve-dir-0.1.1" = self.by-version."resolve-dir"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."flagged-respawn"."^0.3.2" =
    self.by-version."flagged-respawn"."0.3.2";
  by-version."flagged-respawn"."0.3.2" = self.buildNodePackage {
    name = "flagged-respawn-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/flagged-respawn/-/flagged-respawn-0.3.2.tgz";
      name = "flagged-respawn-0.3.2.tgz";
      sha1 = "ff191eddcd7088a675b2610fffc976be9b8074b5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."follow-redirects"."0.0.3" =
    self.by-version."follow-redirects"."0.0.3";
  by-version."follow-redirects"."0.0.3" = self.buildNodePackage {
    name = "follow-redirects-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/follow-redirects/-/follow-redirects-0.0.3.tgz";
      name = "follow-redirects-0.0.3.tgz";
      sha1 = "6ce67a24db1fe13f226c1171a72a7ef2b17b8f65";
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
  by-spec."for-in"."^1.0.1" =
    self.by-version."for-in"."1.0.2";
  by-version."for-in"."1.0.2" = self.buildNodePackage {
    name = "for-in-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/for-in/-/for-in-1.0.2.tgz";
      name = "for-in-1.0.2.tgz";
      sha1 = "81068d295a8142ec0ac726c6e2200c30fb6d5e80";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."for-own"."^0.1.4" =
    self.by-version."for-own"."0.1.5";
  by-version."for-own"."0.1.5" = self.buildNodePackage {
    name = "for-own-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/for-own/-/for-own-0.1.5.tgz";
      name = "for-own-0.1.5.tgz";
      sha1 = "5265c681a4f294dabbf17c9509b6763aa84510ce";
    };
    deps = {
      "for-in-1.0.2" = self.by-version."for-in"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.6.1" =
    self.by-version."forever-agent"."0.6.1";
  by-version."forever-agent"."0.6.1" = self.buildNodePackage {
    name = "forever-agent-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
      name = "forever-agent-0.6.1.tgz";
      sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."^2.1.1" =
    self.by-version."form-data"."2.1.4";
  by-version."form-data"."2.1.4" = self.buildNodePackage {
    name = "form-data-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/form-data/-/form-data-2.1.4.tgz";
      name = "form-data-2.1.4.tgz";
      sha1 = "33c183acf193276ecaa98143a69e94bfee1750d1";
    };
    deps = {
      "asynckit-0.4.0" = self.by-version."asynckit"."0.4.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.15" = self.by-version."mime-types"."2.1.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~2.0.0" =
    self.by-version."form-data"."2.0.0";
  by-version."form-data"."2.0.0" = self.buildNodePackage {
    name = "form-data-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/form-data/-/form-data-2.0.0.tgz";
      name = "form-data-2.0.0.tgz";
      sha1 = "6f0aebadcc5da16c13e1ecc11137d85f9b883b25";
    };
    deps = {
      "asynckit-0.4.0" = self.by-version."asynckit"."0.4.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.15" = self.by-version."mime-types"."2.1.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~2.1.1" =
    self.by-version."form-data"."2.1.4";
  by-spec."formidable"."^1.1.1" =
    self.by-version."formidable"."1.1.1";
  by-version."formidable"."1.1.1" = self.buildNodePackage {
    name = "formidable-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/formidable/-/formidable-1.1.1.tgz";
      name = "formidable-1.1.1.tgz";
      sha1 = "96b8886f7c3c3508b932d6bd70c4d3a88f35f1a9";
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
      url = "https://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
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
  by-spec."fresh"."0.3.0" =
    self.by-version."fresh"."0.3.0";
  by-version."fresh"."0.3.0" = self.buildNodePackage {
    name = "fresh-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fresh/-/fresh-0.3.0.tgz";
      name = "fresh-0.3.0.tgz";
      sha1 = "651f838e22424e7566de161d8358caa199f83d4f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fresh"."0.5.0" =
    self.by-version."fresh"."0.5.0";
  by-version."fresh"."0.5.0" = self.buildNodePackage {
    name = "fresh-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fresh/-/fresh-0.5.0.tgz";
      name = "fresh-0.5.0.tgz";
      sha1 = "f474ca5e6a9246d6fd8e0953cfa9b9c805afa78e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fs-exists-sync"."^0.1.0" =
    self.by-version."fs-exists-sync"."0.1.0";
  by-version."fs-exists-sync"."0.1.0" = self.buildNodePackage {
    name = "fs-exists-sync-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs-exists-sync/-/fs-exists-sync-0.1.0.tgz";
      name = "fs-exists-sync-0.1.0.tgz";
      sha1 = "982d6893af918e72d08dec9e8673ff2b5a8d6add";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fs-extra"."0.26.2" =
    self.by-version."fs-extra"."0.26.2";
  by-version."fs-extra"."0.26.2" = self.buildNodePackage {
    name = "fs-extra-0.26.2";
    version = "0.26.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs-extra/-/fs-extra-0.26.2.tgz";
      name = "fs-extra-0.26.2.tgz";
      sha1 = "71b7697e539db037acf41e6e7923e94d605bf498";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "jsonfile-2.4.0" = self.by-version."jsonfile"."2.4.0";
      "klaw-1.3.1" = self.by-version."klaw"."1.3.1";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
      "rimraf-2.6.1" = self.by-version."rimraf"."2.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fs-extra"."2.1.2" =
    self.by-version."fs-extra"."2.1.2";
  by-version."fs-extra"."2.1.2" = self.buildNodePackage {
    name = "fs-extra-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs-extra/-/fs-extra-2.1.2.tgz";
      name = "fs-extra-2.1.2.tgz";
      sha1 = "046c70163cef9aad46b0e4a7fa467fb22d71de35";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "jsonfile-2.4.0" = self.by-version."jsonfile"."2.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "fs-extra" = self.by-version."fs-extra"."2.1.2";
  by-spec."fs.realpath"."^1.0.0" =
    self.by-version."fs.realpath"."1.0.0";
  by-version."fs.realpath"."1.0.0" = self.buildNodePackage {
    name = "fs.realpath-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz";
      name = "fs.realpath-1.0.0.tgz";
      sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.0" =
    self.by-version."fstream"."1.0.11";
  by-version."fstream"."1.0.11" = self.buildNodePackage {
    name = "fstream-1.0.11";
    version = "1.0.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fstream/-/fstream-1.0.11.tgz";
      name = "fstream-1.0.11.tgz";
      sha1 = "5c1fb1f117477114f0632a0eb4b71b3cb0fd3171";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "rimraf-2.6.1" = self.by-version."rimraf"."2.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.10" =
    self.by-version."fstream"."1.0.11";
  by-spec."fstream"."^1.0.2" =
    self.by-version."fstream"."1.0.11";
  by-spec."fstream-ignore"."^1.0.5" =
    self.by-version."fstream-ignore"."1.0.5";
  by-version."fstream-ignore"."1.0.5" = self.buildNodePackage {
    name = "fstream-ignore-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fstream-ignore/-/fstream-ignore-1.0.5.tgz";
      name = "fstream-ignore-1.0.5.tgz";
      sha1 = "9c31dae34767018fe1d249b24dada67d092da105";
    };
    deps = {
      "fstream-1.0.11" = self.by-version."fstream"."1.0.11";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.4" = self.by-version."minimatch"."3.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gauge"."~2.7.3" =
    self.by-version."gauge"."2.7.4";
  by-version."gauge"."2.7.4" = self.buildNodePackage {
    name = "gauge-2.7.4";
    version = "2.7.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/gauge/-/gauge-2.7.4.tgz";
      name = "gauge-2.7.4.tgz";
      sha1 = "2c03405c7538c39d7eb37b317022e325fb018bf7";
    };
    deps = {
      "aproba-1.1.2" = self.by-version."aproba"."1.1.2";
      "console-control-strings-1.1.0" = self.by-version."console-control-strings"."1.1.0";
      "has-unicode-2.0.1" = self.by-version."has-unicode"."2.0.1";
      "object-assign-4.1.1" = self.by-version."object-assign"."4.1.1";
      "signal-exit-3.0.2" = self.by-version."signal-exit"."3.0.2";
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "wide-align-1.1.2" = self.by-version."wide-align"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-function"."^1.0.1" =
    self.by-version."generate-function"."1.1.0";
  by-version."generate-function"."1.1.0" = self.buildNodePackage {
    name = "generate-function-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/generate-function/-/generate-function-1.1.0.tgz";
      name = "generate-function-1.1.0.tgz";
      sha1 = "54c21b080192b16d9877779c5bb81666e772365f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-function"."^2.0.0" =
    self.by-version."generate-function"."2.0.0";
  by-version."generate-function"."2.0.0" = self.buildNodePackage {
    name = "generate-function-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
      name = "generate-function-2.0.0.tgz";
      sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-object-property"."^1.0.0" =
    self.by-version."generate-object-property"."1.2.0";
  by-version."generate-object-property"."1.2.0" = self.buildNodePackage {
    name = "generate-object-property-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
      name = "generate-object-property-1.2.0.tgz";
      sha1 = "9c0e1c40308ce804f4783618b937fa88f99d50d0";
    };
    deps = {
      "is-property-1.0.2" = self.by-version."is-property"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-object-property"."^1.1.0" =
    self.by-version."generate-object-property"."1.2.0";
  by-spec."generic-pool"."2.4.3" =
    self.by-version."generic-pool"."2.4.3";
  by-version."generic-pool"."2.4.3" = self.buildNodePackage {
    name = "generic-pool-2.4.3";
    version = "2.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/generic-pool/-/generic-pool-2.4.3.tgz";
      name = "generic-pool-2.4.3.tgz";
      sha1 = "780c36f69dfad05a5a045dd37be7adca11a4f6ff";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generic-pool"."^2.4.2" =
    self.by-version."generic-pool"."2.5.4";
  by-version."generic-pool"."2.5.4" = self.buildNodePackage {
    name = "generic-pool-2.5.4";
    version = "2.5.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/generic-pool/-/generic-pool-2.5.4.tgz";
      name = "generic-pool-2.5.4.tgz";
      sha1 = "38c6188513e14030948ec6e5cf65523d9779299b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."getpass"."^0.1.1" =
    self.by-version."getpass"."0.1.7";
  by-version."getpass"."0.1.7" = self.buildNodePackage {
    name = "getpass-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz";
      name = "getpass-0.1.7.tgz";
      sha1 = "5eff8e3e684d569ae4cb2b1282604e8ba62149fa";
    };
    deps = {
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ghost-gql"."0.0.6" =
    self.by-version."ghost-gql"."0.0.6";
  by-version."ghost-gql"."0.0.6" = self.buildNodePackage {
    name = "ghost-gql-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ghost-gql/-/ghost-gql-0.0.6.tgz";
      name = "ghost-gql-0.0.6.tgz";
      sha1 = "be811bc95f8f72671009c33100fc85d2d02758ee";
    };
    deps = {
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ghost-gql" = self.by-version."ghost-gql"."0.0.6";
  by-spec."ghost-ignition"."^2.8.7" =
    self.by-version."ghost-ignition"."2.8.11";
  by-version."ghost-ignition"."2.8.11" = self.buildNodePackage {
    name = "ghost-ignition-2.8.11";
    version = "2.8.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ghost-ignition/-/ghost-ignition-2.8.11.tgz";
      name = "ghost-ignition-2.8.11.tgz";
      sha1 = "38a018ca2b63bc57e9f2c9037d45b4714b66eba0";
    };
    deps = {
      "bunyan-1.8.5" = self.by-version."bunyan"."1.8.5";
      "bunyan-loggly-1.1.0" = self.by-version."bunyan-loggly"."1.1.0";
      "caller-1.0.1" = self.by-version."caller"."1.0.1";
      "debug-2.6.8" = self.by-version."debug"."2.6.8";
      "find-root-1.0.0" = self.by-version."find-root"."1.0.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
      "moment-2.18.1" = self.by-version."moment"."2.18.1";
      "nconf-0.8.4" = self.by-version."nconf"."0.8.4";
      "prettyjson-1.1.3" = self.by-version."prettyjson"."1.1.3";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."5.0.15" =
    self.by-version."glob"."5.0.15";
  by-version."glob"."5.0.15" = self.buildNodePackage {
    name = "glob-5.0.15";
    version = "5.0.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-5.0.15.tgz";
      name = "glob-5.0.15.tgz";
      sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
    };
    deps = {
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.4" = self.by-version."minimatch"."3.0.4";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "glob" = self.by-version."glob"."5.0.15";
  by-spec."glob"."7.0.5" =
    self.by-version."glob"."7.0.5";
  by-version."glob"."7.0.5" = self.buildNodePackage {
    name = "glob-7.0.5";
    version = "7.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-7.0.5.tgz";
      name = "glob-7.0.5.tgz";
      sha1 = "b4202a69099bbb4d292a7c1b95b6682b67ebdc95";
    };
    deps = {
      "fs.realpath-1.0.0" = self.by-version."fs.realpath"."1.0.0";
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.4" = self.by-version."minimatch"."3.0.4";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^6.0.1" =
    self.by-version."glob"."6.0.4";
  by-version."glob"."6.0.4" = self.buildNodePackage {
    name = "glob-6.0.4";
    version = "6.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-6.0.4.tgz";
      name = "glob-6.0.4.tgz";
      sha1 = "0f08860f6a155127b2fadd4f9ce24b1aab6e4d22";
    };
    deps = {
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.4" = self.by-version."minimatch"."3.0.4";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^7.0.0" =
    self.by-version."glob"."7.1.2";
  by-version."glob"."7.1.2" = self.buildNodePackage {
    name = "glob-7.1.2";
    version = "7.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-7.1.2.tgz";
      name = "glob-7.1.2.tgz";
      sha1 = "c19c9df9a028702d678612384a6552404c636d15";
    };
    deps = {
      "fs.realpath-1.0.0" = self.by-version."fs.realpath"."1.0.0";
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.4" = self.by-version."minimatch"."3.0.4";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^7.0.5" =
    self.by-version."glob"."7.1.2";
  by-spec."glob-base"."^0.3.0" =
    self.by-version."glob-base"."0.3.0";
  by-version."glob-base"."0.3.0" = self.buildNodePackage {
    name = "glob-base-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz";
      name = "glob-base-0.3.0.tgz";
      sha1 = "dbb164f6221b1c0b1ccf82aea328b497df0ea3c4";
    };
    deps = {
      "glob-parent-2.0.0" = self.by-version."glob-parent"."2.0.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob-parent"."^2.0.0" =
    self.by-version."glob-parent"."2.0.0";
  by-version."glob-parent"."2.0.0" = self.buildNodePackage {
    name = "glob-parent-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz";
      name = "glob-parent-2.0.0.tgz";
      sha1 = "81383d72db054fcccf5336daa902f182f6edbb28";
    };
    deps = {
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."global-modules"."^0.2.3" =
    self.by-version."global-modules"."0.2.3";
  by-version."global-modules"."0.2.3" = self.buildNodePackage {
    name = "global-modules-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/global-modules/-/global-modules-0.2.3.tgz";
      name = "global-modules-0.2.3.tgz";
      sha1 = "ea5a3bed42c6d6ce995a4f8a1269b5dae223828d";
    };
    deps = {
      "global-prefix-0.1.5" = self.by-version."global-prefix"."0.1.5";
      "is-windows-0.2.0" = self.by-version."is-windows"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."global-prefix"."^0.1.4" =
    self.by-version."global-prefix"."0.1.5";
  by-version."global-prefix"."0.1.5" = self.buildNodePackage {
    name = "global-prefix-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/global-prefix/-/global-prefix-0.1.5.tgz";
      name = "global-prefix-0.1.5.tgz";
      sha1 = "8d3bc6b8da3ca8112a160d8d496ff0462bfef78f";
    };
    deps = {
      "homedir-polyfill-1.0.1" = self.by-version."homedir-polyfill"."1.0.1";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
      "is-windows-0.2.0" = self.by-version."is-windows"."0.2.0";
      "which-1.2.14" = self.by-version."which"."1.2.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."^4.1.0" =
    self.by-version."graceful-fs"."4.1.11";
  by-version."graceful-fs"."4.1.11" = self.buildNodePackage {
    name = "graceful-fs-4.1.11";
    version = "4.1.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.11.tgz";
      name = "graceful-fs-4.1.11.tgz";
      sha1 = "0e8bdfe4d1ddb8854d64e04ea7c00e2a026e5658";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."^4.1.2" =
    self.by-version."graceful-fs"."4.1.11";
  by-spec."graceful-fs"."^4.1.6" =
    self.by-version."graceful-fs"."4.1.11";
  by-spec."graceful-fs"."^4.1.9" =
    self.by-version."graceful-fs"."4.1.11";
  by-spec."graceful-readlink".">= 1.0.0" =
    self.by-version."graceful-readlink"."1.0.1";
  by-version."graceful-readlink"."1.0.1" = self.buildNodePackage {
    name = "graceful-readlink-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
      name = "graceful-readlink-1.0.1.tgz";
      sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gscan"."0.2.4" =
    self.by-version."gscan"."0.2.4";
  by-version."gscan"."0.2.4" = self.buildNodePackage {
    name = "gscan-0.2.4";
    version = "0.2.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/gscan/-/gscan-0.2.4.tgz";
      name = "gscan-0.2.4.tgz";
      sha1 = "f25f0bfbbc22cf731e8f4279d85b69e8e5bc7ff4";
    };
    deps = {
      "bluebird-3.4.6" = self.by-version."bluebird"."3.4.6";
      "chalk-1.1.1" = self.by-version."chalk"."1.1.1";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "express-4.14.0" = self.by-version."express"."4.14.0";
      "express-hbs-1.0.3" = self.by-version."express-hbs"."1.0.3";
      "extract-zip-fork-1.5.1" = self.by-version."extract-zip-fork"."1.5.1";
      "fs-extra-0.26.2" = self.by-version."fs-extra"."0.26.2";
      "ghost-ignition-2.8.11" = self.by-version."ghost-ignition"."2.8.11";
      "glob-7.0.5" = self.by-version."glob"."7.0.5";
      "lodash-3.10.1" = self.by-version."lodash"."3.10.1";
      "multer-1.1.0" = self.by-version."multer"."1.1.0";
      "package-json-validator-0.6.0" = self.by-version."package-json-validator"."0.6.0";
      "require-dir-0.1.0" = self.by-version."require-dir"."0.1.0";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "gscan" = self.by-version."gscan"."0.2.4";
  by-spec."handlebars"."4.0.6" =
    self.by-version."handlebars"."4.0.6";
  by-version."handlebars"."4.0.6" = self.buildNodePackage {
    name = "handlebars-4.0.6";
    version = "4.0.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/handlebars/-/handlebars-4.0.6.tgz";
      name = "handlebars-4.0.6.tgz";
      sha1 = "2ce4484850537f9c97a8026d5399b935c4ed4ed7";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "source-map-0.4.4" = self.by-version."source-map"."0.4.4";
    };
    optionalDependencies = {
      "uglify-js-2.8.28" = self.by-version."uglify-js"."2.8.28";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."handlebars"."^4.0.5" =
    self.by-version."handlebars"."4.0.10";
  by-version."handlebars"."4.0.10" = self.buildNodePackage {
    name = "handlebars-4.0.10";
    version = "4.0.10";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/handlebars/-/handlebars-4.0.10.tgz";
      name = "handlebars-4.0.10.tgz";
      sha1 = "3d30c718b09a3d96f23ea4cc1f403c4d3ba9ff4f";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "source-map-0.4.4" = self.by-version."source-map"."0.4.4";
    };
    optionalDependencies = {
      "uglify-js-2.8.28" = self.by-version."uglify-js"."2.8.28";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-schema"."^1.0.5" =
    self.by-version."har-schema"."1.0.5";
  by-version."har-schema"."1.0.5" = self.buildNodePackage {
    name = "har-schema-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/har-schema/-/har-schema-1.0.5.tgz";
      name = "har-schema-1.0.5.tgz";
      sha1 = "d263135f43307c02c602afc8fe95970c0151369e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."~2.0.6" =
    self.by-version."har-validator"."2.0.6";
  by-version."har-validator"."2.0.6" = self.buildNodePackage {
    name = "har-validator-2.0.6";
    version = "2.0.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/har-validator/-/har-validator-2.0.6.tgz";
      name = "har-validator-2.0.6.tgz";
      sha1 = "cdcbc08188265ad119b6a5a7c8ab70eecfb5d27d";
    };
    deps = {
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "is-my-json-valid-2.16.0" = self.by-version."is-my-json-valid"."2.16.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."~4.2.1" =
    self.by-version."har-validator"."4.2.1";
  by-version."har-validator"."4.2.1" = self.buildNodePackage {
    name = "har-validator-4.2.1";
    version = "4.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/har-validator/-/har-validator-4.2.1.tgz";
      name = "har-validator-4.2.1.tgz";
      sha1 = "33481d0f1bbff600dd203d75812a6a5fba002e2a";
    };
    deps = {
      "ajv-4.11.8" = self.by-version."ajv"."4.11.8";
      "har-schema-1.0.5" = self.by-version."har-schema"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-ansi"."^2.0.0" =
    self.by-version."has-ansi"."2.0.0";
  by-version."has-ansi"."2.0.0" = self.buildNodePackage {
    name = "has-ansi-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
      name = "has-ansi-2.0.0.tgz";
      sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
    };
    deps = {
      "ansi-regex-2.1.1" = self.by-version."ansi-regex"."2.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-unicode"."^2.0.0" =
    self.by-version."has-unicode"."2.0.1";
  by-version."has-unicode"."2.0.1" = self.buildNodePackage {
    name = "has-unicode-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz";
      name = "has-unicode-2.0.1.tgz";
      sha1 = "e0e6fe6a28cf51138855e086d1691e771de2a8b9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~3.1.3" =
    self.by-version."hawk"."3.1.3";
  by-version."hawk"."3.1.3" = self.buildNodePackage {
    name = "hawk-3.1.3";
    version = "3.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hawk/-/hawk-3.1.3.tgz";
      name = "hawk-3.1.3.tgz";
      sha1 = "078444bd7c1640b0fe540d2c9b73d59678e8e1c4";
    };
    deps = {
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
      "boom-2.10.1" = self.by-version."boom"."2.10.1";
      "cryptiles-2.0.5" = self.by-version."cryptiles"."2.0.5";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."he"."^1.0.0" =
    self.by-version."he"."1.1.1";
  by-version."he"."1.1.1" = self.buildNodePackage {
    name = "he-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/he/-/he-1.1.1.tgz";
      name = "he-1.1.1.tgz";
      sha1 = "93410fd21b009735151f8868c2f271f3427e23fd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."he"."~0.3.6" =
    self.by-version."he"."0.3.6";
  by-version."he"."0.3.6" = self.buildNodePackage {
    name = "he-0.3.6";
    version = "0.3.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/he/-/he-0.3.6.tgz";
      name = "he-0.3.6.tgz";
      sha1 = "9d7bc446e77963933301dd602d5731cb861135e0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hijackresponse"."^2.0.0" =
    self.by-version."hijackresponse"."2.0.1";
  by-version."hijackresponse"."2.0.1" = self.buildNodePackage {
    name = "hijackresponse-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hijackresponse/-/hijackresponse-2.0.1.tgz";
      name = "hijackresponse-2.0.1.tgz";
      sha1 = "45f5e0c9b87d73bad858f66021bec377c736b8b3";
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
    self.by-version."hoek"."2.16.3";
  by-version."hoek"."2.16.3" = self.buildNodePackage {
    name = "hoek-2.16.3";
    version = "2.16.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
      name = "hoek-2.16.3.tgz";
      sha1 = "20bb7403d3cea398e91dc4710a8ff1b8274a25ed";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."homedir-polyfill"."^1.0.0" =
    self.by-version."homedir-polyfill"."1.0.1";
  by-version."homedir-polyfill"."1.0.1" = self.buildNodePackage {
    name = "homedir-polyfill-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/homedir-polyfill/-/homedir-polyfill-1.0.1.tgz";
      name = "homedir-polyfill-1.0.1.tgz";
      sha1 = "4c2bbc8a758998feebf5ed68580f76d46768b4bc";
    };
    deps = {
      "parse-passwd-1.0.0" = self.by-version."parse-passwd"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."html-to-text"."3.2.0" =
    self.by-version."html-to-text"."3.2.0";
  by-version."html-to-text"."3.2.0" = self.buildNodePackage {
    name = "html-to-text-3.2.0";
    version = "3.2.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/html-to-text/-/html-to-text-3.2.0.tgz";
      name = "html-to-text-3.2.0.tgz";
      sha1 = "0dfa5d27ff816b07281c79eaf60d408744ac6d89";
    };
    deps = {
      "he-1.1.1" = self.by-version."he"."1.1.1";
      "htmlparser2-3.9.2" = self.by-version."htmlparser2"."3.9.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "underscore.string-3.3.4" = self.by-version."underscore.string"."3.3.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "html-to-text" = self.by-version."html-to-text"."3.2.0";
  by-spec."htmlparser2"."3.9.2" =
    self.by-version."htmlparser2"."3.9.2";
  by-version."htmlparser2"."3.9.2" = self.buildNodePackage {
    name = "htmlparser2-3.9.2";
    version = "3.9.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/htmlparser2/-/htmlparser2-3.9.2.tgz";
      name = "htmlparser2-3.9.2.tgz";
      sha1 = "1bdf87acca0f3f9e53fa4fcceb0f4b4cbb00b338";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
      "domhandler-2.4.1" = self.by-version."domhandler"."2.4.1";
      "domutils-1.6.2" = self.by-version."domutils"."1.6.2";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."htmlparser2"."^3.8.3" =
    self.by-version."htmlparser2"."3.9.2";
  by-spec."htmlparser2"."^3.9.0" =
    self.by-version."htmlparser2"."3.9.2";
  by-spec."htmlparser2"."^3.9.1" =
    self.by-version."htmlparser2"."3.9.2";
  by-spec."htmlparser2"."^3.9.2" =
    self.by-version."htmlparser2"."3.9.2";
  by-spec."http-errors"."~1.4.0" =
    self.by-version."http-errors"."1.4.0";
  by-version."http-errors"."1.4.0" = self.buildNodePackage {
    name = "http-errors-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/http-errors/-/http-errors-1.4.0.tgz";
      name = "http-errors-1.4.0.tgz";
      sha1 = "6c0242dea6b3df7afda153c71089b31c6e82aabf";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-errors"."~1.5.0" =
    self.by-version."http-errors"."1.5.1";
  by-version."http-errors"."1.5.1" = self.buildNodePackage {
    name = "http-errors-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/http-errors/-/http-errors-1.5.1.tgz";
      name = "http-errors-1.5.1.tgz";
      sha1 = "788c0d2c1de2c81b9e6e8c01843b6b97eb920750";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "setprototypeof-1.0.2" = self.by-version."setprototypeof"."1.0.2";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-errors"."~1.5.1" =
    self.by-version."http-errors"."1.5.1";
  by-spec."http-errors"."~1.6.1" =
    self.by-version."http-errors"."1.6.1";
  by-version."http-errors"."1.6.1" = self.buildNodePackage {
    name = "http-errors-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/http-errors/-/http-errors-1.6.1.tgz";
      name = "http-errors-1.6.1.tgz";
      sha1 = "5f8b8ed98aca545656bf572997387f904a722257";
    };
    deps = {
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "setprototypeof-1.0.3" = self.by-version."setprototypeof"."1.0.3";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-signature"."~1.1.0" =
    self.by-version."http-signature"."1.1.1";
  by-version."http-signature"."1.1.1" = self.buildNodePackage {
    name = "http-signature-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/http-signature/-/http-signature-1.1.1.tgz";
      name = "http-signature-1.1.1.tgz";
      sha1 = "df72e267066cd0ac67fb76adf8e134a8fbcf91bf";
    };
    deps = {
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
      "jsprim-1.4.0" = self.by-version."jsprim"."1.4.0";
      "sshpk-1.13.0" = self.by-version."sshpk"."1.13.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."0.4.15" =
    self.by-version."iconv-lite"."0.4.15";
  by-version."iconv-lite"."0.4.15" = self.buildNodePackage {
    name = "iconv-lite-0.4.15";
    version = "0.4.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.15.tgz";
      name = "iconv-lite-0.4.15.tgz";
      sha1 = "fe265a218ac6a57cfe854927e9d04c19825eddeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."~0.4.13" =
    self.by-version."iconv-lite"."0.4.17";
  by-version."iconv-lite"."0.4.17" = self.buildNodePackage {
    name = "iconv-lite-0.4.17";
    version = "0.4.17";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.17.tgz";
      name = "iconv-lite-0.4.17.tgz";
      sha1 = "4fdaa3b38acbc2c031b045d0edcdfe1ecab18c8d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."image-size"."0.5.1" =
    self.by-version."image-size"."0.5.1";
  by-version."image-size"."0.5.1" = self.buildNodePackage {
    name = "image-size-0.5.1";
    version = "0.5.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/image-size/-/image-size-0.5.1.tgz";
      name = "image-size-0.5.1.tgz";
      sha1 = "28eea8548a4b1443480ddddc1e083ae54652439f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "image-size" = self.by-version."image-size"."0.5.1";
  by-spec."inflection"."^1.5.1" =
    self.by-version."inflection"."1.12.0";
  by-version."inflection"."1.12.0" = self.buildNodePackage {
    name = "inflection-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inflection/-/inflection-1.12.0.tgz";
      name = "inflection-1.12.0.tgz";
      sha1 = "a200935656d6f5f6bc4dc7502e1aecb703228416";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inflight"."^1.0.4" =
    self.by-version."inflight"."1.0.6";
  by-version."inflight"."1.0.6" = self.buildNodePackage {
    name = "inflight-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz";
      name = "inflight-1.0.6.tgz";
      sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
    };
    deps = {
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "wrappy-1.0.2" = self.by-version."wrappy"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.3";
  by-version."inherits"."2.0.3" = self.buildNodePackage {
    name = "inherits-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz";
      name = "inherits-2.0.3.tgz";
      sha1 = "633c2c83e3da42a502f52466022480f4208261de";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = self.buildNodePackage {
    name = "inherits-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
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
  by-spec."inherits"."2.0.3" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."^2.0.1" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."^2.0.3" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.3";
  by-spec."ini"."^1.3.0" =
    self.by-version."ini"."1.3.4";
  by-version."ini"."1.3.4" = self.buildNodePackage {
    name = "ini-1.3.4";
    version = "1.3.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ini/-/ini-1.3.4.tgz";
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
  by-spec."ini"."^1.3.4" =
    self.by-version."ini"."1.3.4";
  by-spec."ini"."~1.3.0" =
    self.by-version."ini"."1.3.4";
  by-spec."interpret"."^0.6.5" =
    self.by-version."interpret"."0.6.6";
  by-version."interpret"."0.6.6" = self.buildNodePackage {
    name = "interpret-0.6.6";
    version = "0.6.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/interpret/-/interpret-0.6.6.tgz";
      name = "interpret-0.6.6.tgz";
      sha1 = "fecd7a18e7ce5ca6abfb953e1f86213a49f1625b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."intl"."1.2.5" =
    self.by-version."intl"."1.2.5";
  by-version."intl"."1.2.5" = self.buildNodePackage {
    name = "intl-1.2.5";
    version = "1.2.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/intl/-/intl-1.2.5.tgz";
      name = "intl-1.2.5.tgz";
      sha1 = "82244a2190c4e419f8371f5aa34daa3420e2abde";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "intl" = self.by-version."intl"."1.2.5";
  by-spec."intl-messageformat"."1.3.0" =
    self.by-version."intl-messageformat"."1.3.0";
  by-version."intl-messageformat"."1.3.0" = self.buildNodePackage {
    name = "intl-messageformat-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/intl-messageformat/-/intl-messageformat-1.3.0.tgz";
      name = "intl-messageformat-1.3.0.tgz";
      sha1 = "f7d926aded7a3ab19b2dc601efd54e99a4bd4eae";
    };
    deps = {
      "intl-messageformat-parser-1.2.0" = self.by-version."intl-messageformat-parser"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "intl-messageformat" = self.by-version."intl-messageformat"."1.3.0";
  by-spec."intl-messageformat-parser"."1.2.0" =
    self.by-version."intl-messageformat-parser"."1.2.0";
  by-version."intl-messageformat-parser"."1.2.0" = self.buildNodePackage {
    name = "intl-messageformat-parser-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/intl-messageformat-parser/-/intl-messageformat-parser-1.2.0.tgz";
      name = "intl-messageformat-parser-1.2.0.tgz";
      sha1 = "5906b7f953ab7470e0dc8549097b648b991892ff";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."invert-kv"."^1.0.0" =
    self.by-version."invert-kv"."1.0.0";
  by-version."invert-kv"."1.0.0" = self.buildNodePackage {
    name = "invert-kv-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/invert-kv/-/invert-kv-1.0.0.tgz";
      name = "invert-kv-1.0.0.tgz";
      sha1 = "104a8e4aaca6d3d8cd157a8ef8bfab2d7a3ffdb6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ipaddr.js"."1.3.0" =
    self.by-version."ipaddr.js"."1.3.0";
  by-version."ipaddr.js"."1.3.0" = self.buildNodePackage {
    name = "ipaddr.js-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.3.0.tgz";
      name = "ipaddr.js-1.3.0.tgz";
      sha1 = "1e03a52fdad83a8bbb2b25cbf4998b4cffcd3dec";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-buffer"."^1.1.5" =
    self.by-version."is-buffer"."1.1.5";
  by-version."is-buffer"."1.1.5" = self.buildNodePackage {
    name = "is-buffer-1.1.5";
    version = "1.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.5.tgz";
      name = "is-buffer-1.1.5.tgz";
      sha1 = "1f3b26ef613b214b88cbca23cc6c01d87961eecc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-dotfile"."^1.0.0" =
    self.by-version."is-dotfile"."1.0.3";
  by-version."is-dotfile"."1.0.3" = self.buildNodePackage {
    name = "is-dotfile-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.3.tgz";
      name = "is-dotfile-1.0.3.tgz";
      sha1 = "a6a2f32ffd2dfb04f5ca25ecd0f6b83cf798a1e1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-equal-shallow"."^0.1.3" =
    self.by-version."is-equal-shallow"."0.1.3";
  by-version."is-equal-shallow"."0.1.3" = self.buildNodePackage {
    name = "is-equal-shallow-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz";
      name = "is-equal-shallow-0.1.3.tgz";
      sha1 = "2238098fc221de0bcfa5d9eac4c45d638aa1c534";
    };
    deps = {
      "is-primitive-2.0.0" = self.by-version."is-primitive"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-extendable"."^0.1.1" =
    self.by-version."is-extendable"."0.1.1";
  by-version."is-extendable"."0.1.1" = self.buildNodePackage {
    name = "is-extendable-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz";
      name = "is-extendable-0.1.1.tgz";
      sha1 = "62b110e289a471418e3ec36a617d472e301dfc89";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-extglob"."^1.0.0" =
    self.by-version."is-extglob"."1.0.0";
  by-version."is-extglob"."1.0.0" = self.buildNodePackage {
    name = "is-extglob-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz";
      name = "is-extglob-1.0.0.tgz";
      sha1 = "ac468177c4943405a092fc8f29760c6ffc6206c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-fullwidth-code-point"."^1.0.0" =
    self.by-version."is-fullwidth-code-point"."1.0.0";
  by-version."is-fullwidth-code-point"."1.0.0" = self.buildNodePackage {
    name = "is-fullwidth-code-point-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz";
      name = "is-fullwidth-code-point-1.0.0.tgz";
      sha1 = "ef9e31386f031a7f0d643af82fde50c457ef00cb";
    };
    deps = {
      "number-is-nan-1.0.1" = self.by-version."number-is-nan"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-glob"."^2.0.0" =
    self.by-version."is-glob"."2.0.1";
  by-version."is-glob"."2.0.1" = self.buildNodePackage {
    name = "is-glob-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz";
      name = "is-glob-2.0.1.tgz";
      sha1 = "d096f926a3ded5600f3fdfd91198cb0888c2d863";
    };
    deps = {
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-glob"."^2.0.1" =
    self.by-version."is-glob"."2.0.1";
  by-spec."is-my-json-valid"."^2.12.4" =
    self.by-version."is-my-json-valid"."2.16.0";
  by-version."is-my-json-valid"."2.16.0" = self.buildNodePackage {
    name = "is-my-json-valid-2.16.0";
    version = "2.16.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.16.0.tgz";
      name = "is-my-json-valid-2.16.0.tgz";
      sha1 = "f079dd9bfdae65ee2038aae8acbc86ab109e3693";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.2.0" = self.by-version."generate-object-property"."1.2.0";
      "jsonpointer-4.0.1" = self.by-version."jsonpointer"."4.0.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-number"."^2.0.2" =
    self.by-version."is-number"."2.1.0";
  by-version."is-number"."2.1.0" = self.buildNodePackage {
    name = "is-number-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz";
      name = "is-number-2.1.0.tgz";
      sha1 = "01fcbbb393463a548f2f466cce16dece49db908f";
    };
    deps = {
      "kind-of-3.2.2" = self.by-version."kind-of"."3.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-number"."^2.1.0" =
    self.by-version."is-number"."2.1.0";
  by-spec."is-posix-bracket"."^0.1.0" =
    self.by-version."is-posix-bracket"."0.1.1";
  by-version."is-posix-bracket"."0.1.1" = self.buildNodePackage {
    name = "is-posix-bracket-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz";
      name = "is-posix-bracket-0.1.1.tgz";
      sha1 = "3334dc79774368e92f016e6fbc0a88f5cd6e6bc4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-primitive"."^2.0.0" =
    self.by-version."is-primitive"."2.0.0";
  by-version."is-primitive"."2.0.0" = self.buildNodePackage {
    name = "is-primitive-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz";
      name = "is-primitive-2.0.0.tgz";
      sha1 = "207bab91638499c07b2adf240a41a87210034575";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-property"."^1.0.0" =
    self.by-version."is-property"."1.0.2";
  by-version."is-property"."1.0.2" = self.buildNodePackage {
    name = "is-property-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
      name = "is-property-1.0.2.tgz";
      sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-typedarray"."~1.0.0" =
    self.by-version."is-typedarray"."1.0.0";
  by-version."is-typedarray"."1.0.0" = self.buildNodePackage {
    name = "is-typedarray-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz";
      name = "is-typedarray-1.0.0.tgz";
      sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-windows"."^0.2.0" =
    self.by-version."is-windows"."0.2.0";
  by-version."is-windows"."0.2.0" = self.buildNodePackage {
    name = "is-windows-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-windows/-/is-windows-0.2.0.tgz";
      name = "is-windows-0.2.0.tgz";
      sha1 = "de1aa6d63ea29dd248737b69f1ff8b8002d2108c";
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
      url = "https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
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
  by-spec."isarray"."1.0.0" =
    self.by-version."isarray"."1.0.0";
  by-version."isarray"."1.0.0" = self.buildNodePackage {
    name = "isarray-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz";
      name = "isarray-1.0.0.tgz";
      sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isarray"."~1.0.0" =
    self.by-version."isarray"."1.0.0";
  by-spec."isexe"."^2.0.0" =
    self.by-version."isexe"."2.0.0";
  by-version."isexe"."2.0.0" = self.buildNodePackage {
    name = "isexe-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz";
      name = "isexe-2.0.0.tgz";
      sha1 = "e8fbf374dc556ff8947a10dcb0572d633f2cfa10";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isobject"."^2.0.0" =
    self.by-version."isobject"."2.1.0";
  by-version."isobject"."2.1.0" = self.buildNodePackage {
    name = "isobject-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz";
      name = "isobject-2.1.0.tgz";
      sha1 = "f065561096a3f1da2ef46272f815c840d87e0c89";
    };
    deps = {
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isobject"."^2.1.0" =
    self.by-version."isobject"."2.1.0";
  by-spec."isstream"."~0.1.2" =
    self.by-version."isstream"."0.1.2";
  by-version."isstream"."0.1.2" = self.buildNodePackage {
    name = "isstream-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
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
  by-spec."jison"."0.4.13" =
    self.by-version."jison"."0.4.13";
  by-version."jison"."0.4.13" = self.buildNodePackage {
    name = "jison-0.4.13";
    version = "0.4.13";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/jison/-/jison-0.4.13.tgz";
      name = "jison-0.4.13.tgz";
      sha1 = "9041707d62241367f58834532b9f19c2c36fac78";
    };
    deps = {
      "JSONSelect-0.4.0" = self.by-version."JSONSelect"."0.4.0";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
      "escodegen-0.0.21" = self.by-version."escodegen"."0.0.21";
      "jison-lex-0.2.1" = self.by-version."jison-lex"."0.2.1";
      "ebnf-parser-0.1.10" = self.by-version."ebnf-parser"."0.1.10";
      "lex-parser-0.1.4" = self.by-version."lex-parser"."0.1.4";
      "nomnom-1.5.2" = self.by-version."nomnom"."1.5.2";
      "cjson-0.2.1" = self.by-version."cjson"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jison-lex"."0.2.x" =
    self.by-version."jison-lex"."0.2.1";
  by-version."jison-lex"."0.2.1" = self.buildNodePackage {
    name = "jison-lex-0.2.1";
    version = "0.2.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/jison-lex/-/jison-lex-0.2.1.tgz";
      name = "jison-lex-0.2.1.tgz";
      sha1 = "ac4b815e8cce5132eb12b5dfcfe8d707b8844dfe";
    };
    deps = {
      "lex-parser-0.1.4" = self.by-version."lex-parser"."0.1.4";
      "nomnom-1.5.2" = self.by-version."nomnom"."1.5.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jodid25519"."^1.0.0" =
    self.by-version."jodid25519"."1.0.2";
  by-version."jodid25519"."1.0.2" = self.buildNodePackage {
    name = "jodid25519-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jodid25519/-/jodid25519-1.0.2.tgz";
      name = "jodid25519-1.0.2.tgz";
      sha1 = "06d4912255093419477d425633606e0e90782967";
    };
    deps = {
      "jsbn-0.1.1" = self.by-version."jsbn"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-beautify"."1.6.4" =
    self.by-version."js-beautify"."1.6.4";
  by-version."js-beautify"."1.6.4" = self.buildNodePackage {
    name = "js-beautify-1.6.4";
    version = "1.6.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/js-beautify/-/js-beautify-1.6.4.tgz";
      name = "js-beautify-1.6.4.tgz";
      sha1 = "a9af79699742ac9a1b6fddc1fdbc78bc4d515fc3";
    };
    deps = {
      "config-chain-1.1.11" = self.by-version."config-chain"."1.1.11";
      "editorconfig-0.13.2" = self.by-version."editorconfig"."0.13.2";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-beautify"."1.6.8" =
    self.by-version."js-beautify"."1.6.8";
  by-version."js-beautify"."1.6.8" = self.buildNodePackage {
    name = "js-beautify-1.6.8";
    version = "1.6.8";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/js-beautify/-/js-beautify-1.6.8.tgz";
      name = "js-beautify-1.6.8.tgz";
      sha1 = "da1146d34431145309c89be7f69ed16e8e0ff07e";
    };
    deps = {
      "config-chain-1.1.11" = self.by-version."config-chain"."1.1.11";
      "editorconfig-0.13.2" = self.by-version."editorconfig"."0.13.2";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsbn"."~0.1.0" =
    self.by-version."jsbn"."0.1.1";
  by-version."jsbn"."0.1.1" = self.buildNodePackage {
    name = "jsbn-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz";
      name = "jsbn-0.1.1.tgz";
      sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-schema"."0.2.3" =
    self.by-version."json-schema"."0.2.3";
  by-version."json-schema"."0.2.3" = self.buildNodePackage {
    name = "json-schema-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-schema/-/json-schema-0.2.3.tgz";
      name = "json-schema-0.2.3.tgz";
      sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stable-stringify"."^1.0.1" =
    self.by-version."json-stable-stringify"."1.0.1";
  by-version."json-stable-stringify"."1.0.1" = self.buildNodePackage {
    name = "json-stable-stringify-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-stable-stringify/-/json-stable-stringify-1.0.1.tgz";
      name = "json-stable-stringify-1.0.1.tgz";
      sha1 = "9a759d39c5f2ff503fd5300646ed445f88c4f9af";
    };
    deps = {
      "jsonify-0.0.0" = self.by-version."jsonify"."0.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."5.0.1" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-version."json-stringify-safe"."5.0.1" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.1";
    version = "5.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
      name = "json-stringify-safe-5.0.1.tgz";
      sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."5.0.x" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-spec."json-stringify-safe"."^5.0.1" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-spec."json-stringify-safe"."~5.0.1" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-spec."jsonfile"."^2.1.0" =
    self.by-version."jsonfile"."2.4.0";
  by-version."jsonfile"."2.4.0" = self.buildNodePackage {
    name = "jsonfile-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonfile/-/jsonfile-2.4.0.tgz";
      name = "jsonfile-2.4.0.tgz";
      sha1 = "3736a2b428b87bbda0cc83b53fa3d633a35c2ae8";
    };
    deps = {
    };
    optionalDependencies = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonify"."~0.0.0" =
    self.by-version."jsonify"."0.0.0";
  by-version."jsonify"."0.0.0" = self.buildNodePackage {
    name = "jsonify-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz";
      name = "jsonify-0.0.0.tgz";
      sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonpath"."0.2.11" =
    self.by-version."jsonpath"."0.2.11";
  by-version."jsonpath"."0.2.11" = self.buildNodePackage {
    name = "jsonpath-0.2.11";
    version = "0.2.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonpath/-/jsonpath-0.2.11.tgz";
      name = "jsonpath-0.2.11.tgz";
      sha1 = "bfe22e0665b9712f8e7bdf7e2e1f8c08b594c60e";
    };
    deps = {
      "esprima-1.2.2" = self.by-version."esprima"."1.2.2";
      "jison-0.4.13" = self.by-version."jison"."0.4.13";
      "static-eval-0.2.3" = self.by-version."static-eval"."0.2.3";
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "jsonpath" = self.by-version."jsonpath"."0.2.11";
  by-spec."jsonpointer"."^4.0.0" =
    self.by-version."jsonpointer"."4.0.1";
  by-version."jsonpointer"."4.0.1" = self.buildNodePackage {
    name = "jsonpointer-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonpointer/-/jsonpointer-4.0.1.tgz";
      name = "jsonpointer-4.0.1.tgz";
      sha1 = "4fd92cb34e0e9db3c89c8622ecf51f9b978c6cb9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsprim"."^1.2.2" =
    self.by-version."jsprim"."1.4.0";
  by-version."jsprim"."1.4.0" = self.buildNodePackage {
    name = "jsprim-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsprim/-/jsprim-1.4.0.tgz";
      name = "jsprim-1.4.0.tgz";
      sha1 = "a3b87e40298d8c380552d8cc7628a0bb95a22918";
    };
    deps = {
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
      "json-schema-0.2.3" = self.by-version."json-schema"."0.2.3";
      "verror-1.3.6" = self.by-version."verror"."1.3.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keygrip"."~1.0.0" =
    self.by-version."keygrip"."1.0.1";
  by-version."keygrip"."1.0.1" = self.buildNodePackage {
    name = "keygrip-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/keygrip/-/keygrip-1.0.1.tgz";
      name = "keygrip-1.0.1.tgz";
      sha1 = "b02fa4816eef21a8c4b35ca9e52921ffc89a30e9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kind-of"."^3.0.2" =
    self.by-version."kind-of"."3.2.2";
  by-version."kind-of"."3.2.2" = self.buildNodePackage {
    name = "kind-of-3.2.2";
    version = "3.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/kind-of/-/kind-of-3.2.2.tgz";
      name = "kind-of-3.2.2.tgz";
      sha1 = "31ea21a734bab9bbb0f32466d893aea51e4a3c64";
    };
    deps = {
      "is-buffer-1.1.5" = self.by-version."is-buffer"."1.1.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."klaw"."^1.0.0" =
    self.by-version."klaw"."1.3.1";
  by-version."klaw"."1.3.1" = self.buildNodePackage {
    name = "klaw-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/klaw/-/klaw-1.3.1.tgz";
      name = "klaw-1.3.1.tgz";
      sha1 = "4088433b46b3b1ba259d78785d8e96f73ba02439";
    };
    deps = {
    };
    optionalDependencies = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."knex"."0.12.9" =
    self.by-version."knex"."0.12.9";
  by-version."knex"."0.12.9" = self.buildNodePackage {
    name = "knex-0.12.9";
    version = "0.12.9";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/knex/-/knex-0.12.9.tgz";
      name = "knex-0.12.9.tgz";
      sha1 = "aa852138c09ed46181e890fd698270bbe7761124";
    };
    deps = {
      "babel-runtime-6.23.0" = self.by-version."babel-runtime"."6.23.0";
      "bluebird-3.5.0" = self.by-version."bluebird"."3.5.0";
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "debug-2.6.8" = self.by-version."debug"."2.6.8";
      "generic-pool-2.5.4" = self.by-version."generic-pool"."2.5.4";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "interpret-0.6.6" = self.by-version."interpret"."0.6.6";
      "liftoff-2.2.5" = self.by-version."liftoff"."2.2.5";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
      "minimist-1.1.3" = self.by-version."minimist"."1.1.3";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "pg-connection-string-0.1.3" = self.by-version."pg-connection-string"."0.1.3";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "safe-buffer-5.1.0" = self.by-version."safe-buffer"."5.1.0";
      "tildify-1.0.0" = self.by-version."tildify"."1.0.0";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
      "v8flags-2.1.1" = self.by-version."v8flags"."2.1.1";
      "mysql-2.1.1" = self.by-version."mysql"."2.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "knex" = self.by-version."knex"."0.12.9";
  by-spec."knex".">=0.6.10 <0.13.0" =
    self.by-version."knex"."0.12.9";
  by-spec."lazy-cache"."^1.0.3" =
    self.by-version."lazy-cache"."1.0.4";
  by-version."lazy-cache"."1.0.4" = self.buildNodePackage {
    name = "lazy-cache-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lazy-cache/-/lazy-cache-1.0.4.tgz";
      name = "lazy-cache-1.0.4.tgz";
      sha1 = "a1d78fc3a50474cb80845d3b3b6e1da49a446e8e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lazystream"."^1.0.0" =
    self.by-version."lazystream"."1.0.0";
  by-version."lazystream"."1.0.0" = self.buildNodePackage {
    name = "lazystream-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lazystream/-/lazystream-1.0.0.tgz";
      name = "lazystream-1.0.0.tgz";
      sha1 = "f6995fe0f820392f61396be89462407bb77168e4";
    };
    deps = {
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lcid"."^1.0.0" =
    self.by-version."lcid"."1.0.0";
  by-version."lcid"."1.0.0" = self.buildNodePackage {
    name = "lcid-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lcid/-/lcid-1.0.0.tgz";
      name = "lcid-1.0.0.tgz";
      sha1 = "308accafa0bc483a3867b4b6f2b9506251d1b835";
    };
    deps = {
      "invert-kv-1.0.0" = self.by-version."invert-kv"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lex-parser"."0.1.x" =
    self.by-version."lex-parser"."0.1.4";
  by-version."lex-parser"."0.1.4" = self.buildNodePackage {
    name = "lex-parser-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lex-parser/-/lex-parser-0.1.4.tgz";
      name = "lex-parser-0.1.4.tgz";
      sha1 = "64c4f025f17fd53bfb45763faeb16f015a747550";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lex-parser"."~0.1.3" =
    self.by-version."lex-parser"."0.1.4";
  by-spec."liftoff"."~2.2.0" =
    self.by-version."liftoff"."2.2.5";
  by-version."liftoff"."2.2.5" = self.buildNodePackage {
    name = "liftoff-2.2.5";
    version = "2.2.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/liftoff/-/liftoff-2.2.5.tgz";
      name = "liftoff-2.2.5.tgz";
      sha1 = "998c2876cff484b103e4423b93d356da44734c91";
    };
    deps = {
      "extend-3.0.1" = self.by-version."extend"."3.0.1";
      "findup-sync-0.4.3" = self.by-version."findup-sync"."0.4.3";
      "flagged-respawn-0.3.2" = self.by-version."flagged-respawn"."0.3.2";
      "rechoir-0.6.2" = self.by-version."rechoir"."0.6.2";
      "resolve-1.3.3" = self.by-version."resolve"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."3.10.1" =
    self.by-version."lodash"."3.10.1";
  by-version."lodash"."3.10.1" = self.buildNodePackage {
    name = "lodash-3.10.1";
    version = "3.10.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash/-/lodash-3.10.1.tgz";
      name = "lodash-3.10.1.tgz";
      sha1 = "5bf45e8e49ba4189e17d482789dfd15bd140b7b6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."4.17.4" =
    self.by-version."lodash"."4.17.4";
  by-version."lodash"."4.17.4" = self.buildNodePackage {
    name = "lodash-4.17.4";
    version = "4.17.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash/-/lodash-4.17.4.tgz";
      name = "lodash-4.17.4.tgz";
      sha1 = "78203a4d1c328ae1d86dca6460e369b57f4055ae";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "lodash" = self.by-version."lodash"."4.17.4";
  by-spec."lodash"."^4.13.1" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash"."^4.14.0" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash"."^4.16.4" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash"."^4.17.4" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash"."^4.6.0" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash"."^4.8.0" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash"."~4.17.2" =
    self.by-version."lodash"."4.17.4";
  by-spec."lodash.assignin"."^4.0.9" =
    self.by-version."lodash.assignin"."4.2.0";
  by-version."lodash.assignin"."4.2.0" = self.buildNodePackage {
    name = "lodash.assignin-4.2.0";
    version = "4.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.assignin/-/lodash.assignin-4.2.0.tgz";
      name = "lodash.assignin-4.2.0.tgz";
      sha1 = "ba8df5fb841eb0a3e8044232b0e263a8dc6a28a2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.bind"."^4.1.4" =
    self.by-version."lodash.bind"."4.2.1";
  by-version."lodash.bind"."4.2.1" = self.buildNodePackage {
    name = "lodash.bind-4.2.1";
    version = "4.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.bind/-/lodash.bind-4.2.1.tgz";
      name = "lodash.bind-4.2.1.tgz";
      sha1 = "7ae3017e939622ac31b7d7d7dcb1b34db1690d35";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.defaults"."^4.0.0" =
    self.by-version."lodash.defaults"."4.2.0";
  by-version."lodash.defaults"."4.2.0" = self.buildNodePackage {
    name = "lodash.defaults-4.2.0";
    version = "4.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.defaults/-/lodash.defaults-4.2.0.tgz";
      name = "lodash.defaults-4.2.0.tgz";
      sha1 = "d09178716ffea4dde9e5fb7b37f6f0802274580c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.defaults"."^4.0.1" =
    self.by-version."lodash.defaults"."4.2.0";
  by-spec."lodash.filter"."^4.4.0" =
    self.by-version."lodash.filter"."4.6.0";
  by-version."lodash.filter"."4.6.0" = self.buildNodePackage {
    name = "lodash.filter-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.filter/-/lodash.filter-4.6.0.tgz";
      name = "lodash.filter-4.6.0.tgz";
      sha1 = "668b1d4981603ae1cc5a6fa760143e480b4c4ace";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.flatten"."^4.2.0" =
    self.by-version."lodash.flatten"."4.4.0";
  by-version."lodash.flatten"."4.4.0" = self.buildNodePackage {
    name = "lodash.flatten-4.4.0";
    version = "4.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.flatten/-/lodash.flatten-4.4.0.tgz";
      name = "lodash.flatten-4.4.0.tgz";
      sha1 = "f31c22225a9632d2bbf8e4addbef240aa765a61f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.foreach"."^4.3.0" =
    self.by-version."lodash.foreach"."4.5.0";
  by-version."lodash.foreach"."4.5.0" = self.buildNodePackage {
    name = "lodash.foreach-4.5.0";
    version = "4.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.foreach/-/lodash.foreach-4.5.0.tgz";
      name = "lodash.foreach-4.5.0.tgz";
      sha1 = "1a6a35eace401280c7f06dddec35165ab27e3e53";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.map"."^4.4.0" =
    self.by-version."lodash.map"."4.6.0";
  by-version."lodash.map"."4.6.0" = self.buildNodePackage {
    name = "lodash.map-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.map/-/lodash.map-4.6.0.tgz";
      name = "lodash.map-4.6.0.tgz";
      sha1 = "771ec7839e3473d9c4cde28b19394c3562f4f6d3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.merge"."4.6.0" =
    self.by-version."lodash.merge"."4.6.0";
  by-version."lodash.merge"."4.6.0" = self.buildNodePackage {
    name = "lodash.merge-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.0.tgz";
      name = "lodash.merge-4.6.0.tgz";
      sha1 = "69884ba144ac33fe699737a6086deffadd0f89c5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.merge"."^4.4.0" =
    self.by-version."lodash.merge"."4.6.0";
  by-spec."lodash.pick"."^4.2.1" =
    self.by-version."lodash.pick"."4.4.0";
  by-version."lodash.pick"."4.4.0" = self.buildNodePackage {
    name = "lodash.pick-4.4.0";
    version = "4.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.pick/-/lodash.pick-4.4.0.tgz";
      name = "lodash.pick-4.4.0.tgz";
      sha1 = "52f05610fff9ded422611441ed1fc123a03001b3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.reduce"."^4.4.0" =
    self.by-version."lodash.reduce"."4.6.0";
  by-version."lodash.reduce"."4.6.0" = self.buildNodePackage {
    name = "lodash.reduce-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.reduce/-/lodash.reduce-4.6.0.tgz";
      name = "lodash.reduce-4.6.0.tgz";
      sha1 = "f1ab6b839299ad48f784abbf476596f03b914d3b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.reject"."^4.4.0" =
    self.by-version."lodash.reject"."4.6.0";
  by-version."lodash.reject"."4.6.0" = self.buildNodePackage {
    name = "lodash.reject-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.reject/-/lodash.reject-4.6.0.tgz";
      name = "lodash.reject-4.6.0.tgz";
      sha1 = "80d6492dc1470864bbf583533b651f42a9f52415";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.some"."^4.4.0" =
    self.by-version."lodash.some"."4.6.0";
  by-version."lodash.some"."4.6.0" = self.buildNodePackage {
    name = "lodash.some-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.some/-/lodash.some-4.6.0.tgz";
      name = "lodash.some-4.6.0.tgz";
      sha1 = "1bb9f314ef6b8baded13b549169b2a945eb68e4d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.unescape"."^4.0.0" =
    self.by-version."lodash.unescape"."4.0.1";
  by-version."lodash.unescape"."4.0.1" = self.buildNodePackage {
    name = "lodash.unescape-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.unescape/-/lodash.unescape-4.0.1.tgz";
      name = "lodash.unescape-4.0.1.tgz";
      sha1 = "bf2249886ce514cda112fae9218cdc065211fc9c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."loggly"."^1.1.0" =
    self.by-version."loggly"."1.1.1";
  by-version."loggly"."1.1.1" = self.buildNodePackage {
    name = "loggly-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/loggly/-/loggly-1.1.1.tgz";
      name = "loggly-1.1.1.tgz";
      sha1 = "0a0fc1d3fa3a5ec44fdc7b897beba2a4695cebee";
    };
    deps = {
      "request-2.75.0" = self.by-version."request"."2.75.0";
      "timespan-2.3.0" = self.by-version."timespan"."2.3.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."longest"."^1.0.1" =
    self.by-version."longest"."1.0.1";
  by-version."longest"."1.0.1" = self.buildNodePackage {
    name = "longest-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/longest/-/longest-1.0.1.tgz";
      name = "longest-1.0.1.tgz";
      sha1 = "30a0b2da38f73770e8294a0d22e6625ed77d0097";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."^3.2.0" =
    self.by-version."lru-cache"."3.2.0";
  by-version."lru-cache"."3.2.0" = self.buildNodePackage {
    name = "lru-cache-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lru-cache/-/lru-cache-3.2.0.tgz";
      name = "lru-cache-3.2.0.tgz";
      sha1 = "71789b3b7f5399bec8565dda38aa30d2a097efee";
    };
    deps = {
      "pseudomap-1.0.2" = self.by-version."pseudomap"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."^4.0.0" =
    self.by-version."lru-cache"."4.0.2";
  by-version."lru-cache"."4.0.2" = self.buildNodePackage {
    name = "lru-cache-4.0.2";
    version = "4.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lru-cache/-/lru-cache-4.0.2.tgz";
      name = "lru-cache-4.0.2.tgz";
      sha1 = "1d17679c069cda5d040991a09dbc2c0db377e55e";
    };
    deps = {
      "pseudomap-1.0.2" = self.by-version."pseudomap"."1.0.2";
      "yallist-2.1.2" = self.by-version."yallist"."2.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mailcomposer"."~0.2.10" =
    self.by-version."mailcomposer"."0.2.12";
  by-version."mailcomposer"."0.2.12" = self.buildNodePackage {
    name = "mailcomposer-0.2.12";
    version = "0.2.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mailcomposer/-/mailcomposer-0.2.12.tgz";
      name = "mailcomposer-0.2.12.tgz";
      sha1 = "4d02a604616adcb45fb36d37513f4c1bd0b75681";
    };
    deps = {
      "mimelib-0.2.19" = self.by-version."mimelib"."0.2.19";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "he-0.3.6" = self.by-version."he"."0.3.6";
      "follow-redirects-0.0.3" = self.by-version."follow-redirects"."0.0.3";
      "dkim-signer-0.1.2" = self.by-version."dkim-signer"."0.1.2";
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
      url = "https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
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
  by-spec."merge-descriptors"."1.0.1" =
    self.by-version."merge-descriptors"."1.0.1";
  by-version."merge-descriptors"."1.0.1" = self.buildNodePackage {
    name = "merge-descriptors-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz";
      name = "merge-descriptors-1.0.1.tgz";
      sha1 = "b00aaa556dd8b44568150ec9d1b953f3f90cbb61";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."^1.1.1" =
    self.by-version."methods"."1.1.2";
  by-version."methods"."1.1.2" = self.buildNodePackage {
    name = "methods-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/methods/-/methods-1.1.2.tgz";
      name = "methods-1.1.2.tgz";
      sha1 = "5529a4d67654134edcc5266656835b0f851afcee";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."~1.1.2" =
    self.by-version."methods"."1.1.2";
  by-spec."micromatch"."^2.3.7" =
    self.by-version."micromatch"."2.3.11";
  by-version."micromatch"."2.3.11" = self.buildNodePackage {
    name = "micromatch-2.3.11";
    version = "2.3.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz";
      name = "micromatch-2.3.11.tgz";
      sha1 = "86677c97d1720b363431d04d0d15293bd38c1565";
    };
    deps = {
      "arr-diff-2.0.0" = self.by-version."arr-diff"."2.0.0";
      "array-unique-0.2.1" = self.by-version."array-unique"."0.2.1";
      "braces-1.8.5" = self.by-version."braces"."1.8.5";
      "expand-brackets-0.1.5" = self.by-version."expand-brackets"."0.1.5";
      "extglob-0.3.2" = self.by-version."extglob"."0.3.2";
      "filename-regex-2.0.1" = self.by-version."filename-regex"."2.0.1";
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
      "kind-of-3.2.2" = self.by-version."kind-of"."3.2.2";
      "normalize-path-2.1.1" = self.by-version."normalize-path"."2.1.1";
      "object.omit-2.0.1" = self.by-version."object.omit"."2.0.1";
      "parse-glob-3.0.4" = self.by-version."parse-glob"."3.0.4";
      "regex-cache-0.4.3" = self.by-version."regex-cache"."0.4.3";
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
      url = "https://registry.npmjs.org/mime/-/mime-1.3.4.tgz";
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
  by-spec."mime"."^1.3.4" =
    self.by-version."mime"."1.3.6";
  by-version."mime"."1.3.6" = self.buildNodePackage {
    name = "mime-1.3.6";
    version = "1.3.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime/-/mime-1.3.6.tgz";
      name = "mime-1.3.6.tgz";
      sha1 = "591d84d3653a6b0b4a3b9df8de5aa8108e72e5e0";
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
  by-version."mime"."1.2.11" = self.buildNodePackage {
    name = "mime-1.2.11";
    version = "1.2.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
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
  by-spec."mime-db".">= 1.27.0 < 2" =
    self.by-version."mime-db"."1.28.0";
  by-version."mime-db"."1.28.0" = self.buildNodePackage {
    name = "mime-db-1.28.0";
    version = "1.28.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.28.0.tgz";
      name = "mime-db-1.28.0.tgz";
      sha1 = "fedd349be06d2865b7fc57d837c6de4f17d7ac3c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.25.0" =
    self.by-version."mime-db"."1.25.0";
  by-version."mime-db"."1.25.0" = self.buildNodePackage {
    name = "mime-db-1.25.0";
    version = "1.25.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.25.0.tgz";
      name = "mime-db-1.25.0.tgz";
      sha1 = "c18dbd7c73a5dbf6f44a024dc0d165a1e7b1c392";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.27.0" =
    self.by-version."mime-db"."1.27.0";
  by-version."mime-db"."1.27.0" = self.buildNodePackage {
    name = "mime-db-1.27.0";
    version = "1.27.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.27.0.tgz";
      name = "mime-db-1.27.0.tgz";
      sha1 = "820f572296bbd20ec25ed55e5b5de869e5436eb1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."2.1.13" =
    self.by-version."mime-types"."2.1.13";
  by-version."mime-types"."2.1.13" = self.buildNodePackage {
    name = "mime-types-2.1.13";
    version = "2.1.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-types/-/mime-types-2.1.13.tgz";
      name = "mime-types-2.1.13.tgz";
      sha1 = "e07aaa9c6c6b9a7ca3012c69003ad25a39e92a88";
    };
    deps = {
      "mime-db-1.25.0" = self.by-version."mime-db"."1.25.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.11" =
    self.by-version."mime-types"."2.1.15";
  by-version."mime-types"."2.1.15" = self.buildNodePackage {
    name = "mime-types-2.1.15";
    version = "2.1.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-types/-/mime-types-2.1.15.tgz";
      name = "mime-types-2.1.15.tgz";
      sha1 = "a4ebf5064094569237b8cf70046776d09fc92aed";
    };
    deps = {
      "mime-db-1.27.0" = self.by-version."mime-db"."1.27.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.12" =
    self.by-version."mime-types"."2.1.15";
  by-spec."mime-types"."~2.1.11" =
    self.by-version."mime-types"."2.1.15";
  by-spec."mime-types"."~2.1.15" =
    self.by-version."mime-types"."2.1.15";
  by-spec."mime-types"."~2.1.7" =
    self.by-version."mime-types"."2.1.15";
  by-spec."mimelib"."~0.2.15" =
    self.by-version."mimelib"."0.2.19";
  by-version."mimelib"."0.2.19" = self.buildNodePackage {
    name = "mimelib-0.2.19";
    version = "0.2.19";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mimelib/-/mimelib-0.2.19.tgz";
      name = "mimelib-0.2.19.tgz";
      sha1 = "37ec90a6ac7d00954851d0b2c31618f0a49da0ee";
    };
    deps = {
      "encoding-0.1.12" = self.by-version."encoding"."0.1.12";
      "addressparser-0.3.2" = self.by-version."addressparser"."0.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."2 || 3" =
    self.by-version."minimatch"."3.0.4";
  by-version."minimatch"."3.0.4" = self.buildNodePackage {
    name = "minimatch-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz";
      name = "minimatch-3.0.4.tgz";
      sha1 = "5166e286457f03306064be5497e8dbb0c3d32083";
    };
    deps = {
      "brace-expansion-1.1.7" = self.by-version."brace-expansion"."1.1.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."^3.0.0" =
    self.by-version."minimatch"."3.0.4";
  by-spec."minimatch"."^3.0.2" =
    self.by-version."minimatch"."3.0.4";
  by-spec."minimatch"."^3.0.4" =
    self.by-version."minimatch"."3.0.4";
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = self.buildNodePackage {
    name = "minimist-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
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
  by-spec."minimist"."^1.1.3" =
    self.by-version."minimist"."1.2.0";
  by-version."minimist"."1.2.0" = self.buildNodePackage {
    name = "minimist-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz";
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
  by-spec."minimist"."^1.2.0" =
    self.by-version."minimist"."1.2.0";
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = self.buildNodePackage {
    name = "minimist-0.0.10";
    version = "0.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
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
  by-spec."minimist"."~1.1.0" =
    self.by-version."minimist"."1.1.3";
  by-version."minimist"."1.1.3" = self.buildNodePackage {
    name = "minimist-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-1.1.3.tgz";
      name = "minimist-1.1.3.tgz";
      sha1 = "3bedfd91a92d39016fcfaa1c681e8faa1a1efda8";
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
      url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
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
  by-spec."mkdirp".">=0.5 0" =
    self.by-version."mkdirp"."0.5.1";
  by-version."mkdirp"."0.5.1" = self.buildNodePackage {
    name = "mkdirp-0.5.1";
    version = "0.5.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
      name = "mkdirp-0.5.1.tgz";
      sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
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
  by-spec."mkdirp"."^0.5.0" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."^0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.5.0" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."moment"."2.18.1" =
    self.by-version."moment"."2.18.1";
  by-version."moment"."2.18.1" = self.buildNodePackage {
    name = "moment-2.18.1";
    version = "2.18.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/moment/-/moment-2.18.1.tgz";
      name = "moment-2.18.1.tgz";
      sha1 = "c36193dd3ce1c2eed2adb7c802dbbc77a81b1c0f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "moment" = self.by-version."moment"."2.18.1";
  by-spec."moment".">= 2.9.0" =
    self.by-version."moment"."2.18.1";
  by-spec."moment"."^2.10.6" =
    self.by-version."moment"."2.18.1";
  by-spec."moment"."^2.15.2" =
    self.by-version."moment"."2.18.1";
  by-spec."moment-timezone"."0.5.13" =
    self.by-version."moment-timezone"."0.5.13";
  by-version."moment-timezone"."0.5.13" = self.buildNodePackage {
    name = "moment-timezone-0.5.13";
    version = "0.5.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/moment-timezone/-/moment-timezone-0.5.13.tgz";
      name = "moment-timezone-0.5.13.tgz";
      sha1 = "99ce5c7d827262eb0f1f702044177f60745d7b90";
    };
    deps = {
      "moment-2.18.1" = self.by-version."moment"."2.18.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "moment-timezone" = self.by-version."moment-timezone"."0.5.13";
  by-spec."morgan"."1.7.0" =
    self.by-version."morgan"."1.7.0";
  by-version."morgan"."1.7.0" = self.buildNodePackage {
    name = "morgan-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/morgan/-/morgan-1.7.0.tgz";
      name = "morgan-1.7.0.tgz";
      sha1 = "eb10ca8e50d1abe0f8d3dad5c0201d052d981c62";
    };
    deps = {
      "basic-auth-1.0.4" = self.by-version."basic-auth"."1.0.4";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "on-headers-1.0.1" = self.by-version."on-headers"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "morgan" = self.by-version."morgan"."1.7.0";
  by-spec."ms"."0.7.1" =
    self.by-version."ms"."0.7.1";
  by-version."ms"."0.7.1" = self.buildNodePackage {
    name = "ms-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ms/-/ms-0.7.1.tgz";
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
  by-spec."ms"."0.7.2" =
    self.by-version."ms"."0.7.2";
  by-version."ms"."0.7.2" = self.buildNodePackage {
    name = "ms-0.7.2";
    version = "0.7.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ms/-/ms-0.7.2.tgz";
      name = "ms-0.7.2.tgz";
      sha1 = "ae25cf2512b3885a1d95d7f037868d8431124765";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."2.0.0" =
    self.by-version."ms"."2.0.0";
  by-version."ms"."2.0.0" = self.buildNodePackage {
    name = "ms-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz";
      name = "ms-2.0.0.tgz";
      sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."multer"."1.1.0" =
    self.by-version."multer"."1.1.0";
  by-version."multer"."1.1.0" = self.buildNodePackage {
    name = "multer-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/multer/-/multer-1.1.0.tgz";
      name = "multer-1.1.0.tgz";
      sha1 = "b32d536343950bf62c6eda7817e71f7376516fed";
    };
    deps = {
      "append-field-0.1.0" = self.by-version."append-field"."0.1.0";
      "busboy-0.2.14" = self.by-version."busboy"."0.2.14";
      "concat-stream-1.6.0" = self.by-version."concat-stream"."1.6.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "object-assign-3.0.0" = self.by-version."object-assign"."3.0.0";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "type-is-1.6.15" = self.by-version."type-is"."1.6.15";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."multer"."1.3.0" =
    self.by-version."multer"."1.3.0";
  by-version."multer"."1.3.0" = self.buildNodePackage {
    name = "multer-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/multer/-/multer-1.3.0.tgz";
      name = "multer-1.3.0.tgz";
      sha1 = "092b2670f6846fa4914965efc8cf94c20fec6cd2";
    };
    deps = {
      "append-field-0.1.0" = self.by-version."append-field"."0.1.0";
      "busboy-0.2.14" = self.by-version."busboy"."0.2.14";
      "concat-stream-1.6.0" = self.by-version."concat-stream"."1.6.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "object-assign-3.0.0" = self.by-version."object-assign"."3.0.0";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "type-is-1.6.15" = self.by-version."type-is"."1.6.15";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "multer" = self.by-version."multer"."1.3.0";
  by-spec."mv"."~2" =
    self.by-version."mv"."2.1.1";
  by-version."mv"."2.1.1" = self.buildNodePackage {
    name = "mv-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mv/-/mv-2.1.1.tgz";
      name = "mv-2.1.1.tgz";
      sha1 = "ae6ce0d6f6d5e0a4f7d893798d03c1ea9559b6a2";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "ncp-2.0.0" = self.by-version."ncp"."2.0.0";
      "rimraf-2.4.5" = self.by-version."rimraf"."2.4.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mysql"."2.1.1" =
    self.by-version."mysql"."2.1.1";
  by-version."mysql"."2.1.1" = self.buildNodePackage {
    name = "mysql-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mysql/-/mysql-2.1.1.tgz";
      name = "mysql-2.1.1.tgz";
      sha1 = "3ec79b945dee2830fc995515e551a54dceac8383";
    };
    deps = {
      "require-all-0.0.3" = self.by-version."require-all"."0.0.3";
      "bignumber.js-1.0.1" = self.by-version."bignumber.js"."1.0.1";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mysql" = self.by-version."mysql"."2.1.1";
  by-spec."nan"."^2.3.3" =
    self.by-version."nan"."2.6.2";
  by-version."nan"."2.6.2" = self.buildNodePackage {
    name = "nan-2.6.2";
    version = "2.6.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.6.2.tgz";
      name = "nan-2.6.2.tgz";
      sha1 = "e4ff34e6c95fdfb5aecc08de6596f43605a7db45";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."~2.4.0" =
    self.by-version."nan"."2.4.0";
  by-version."nan"."2.4.0" = self.buildNodePackage {
    name = "nan-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.4.0.tgz";
      name = "nan-2.4.0.tgz";
      sha1 = "fb3c59d45fe4effe215f0b890f8adf6eb32d2232";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nconf"."0.8.4" =
    self.by-version."nconf"."0.8.4";
  by-version."nconf"."0.8.4" = self.buildNodePackage {
    name = "nconf-0.8.4";
    version = "0.8.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nconf/-/nconf-0.8.4.tgz";
      name = "nconf-0.8.4.tgz";
      sha1 = "9502234f7ad6238cab7f92d7c068c20434d3ff93";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
      "secure-keys-1.0.0" = self.by-version."secure-keys"."1.0.0";
      "yargs-3.32.0" = self.by-version."yargs"."3.32.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ncp"."~2.0.0" =
    self.by-version."ncp"."2.0.0";
  by-version."ncp"."2.0.0" = self.buildNodePackage {
    name = "ncp-2.0.0";
    version = "2.0.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/ncp/-/ncp-2.0.0.tgz";
      name = "ncp-2.0.0.tgz";
      sha1 = "195a21d6c46e361d2fb1281ba38b91e9df7bdbb3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ndjson"."^1.4.0" =
    self.by-version."ndjson"."1.5.0";
  by-version."ndjson"."1.5.0" = self.buildNodePackage {
    name = "ndjson-1.5.0";
    version = "1.5.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/ndjson/-/ndjson-1.5.0.tgz";
      name = "ndjson-1.5.0.tgz";
      sha1 = "ae603b36b134bcec347b452422b0bf98d5832ec8";
    };
    deps = {
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "split2-2.1.1" = self.by-version."split2"."2.1.1";
      "through2-2.0.3" = self.by-version."through2"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."negotiator"."0.6.1" =
    self.by-version."negotiator"."0.6.1";
  by-version."negotiator"."0.6.1" = self.buildNodePackage {
    name = "negotiator-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/negotiator/-/negotiator-0.6.1.tgz";
      name = "negotiator-0.6.1.tgz";
      sha1 = "2b327184e8992101177b28563fb5e7102acd0ca9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."netjet"."1.1.3" =
    self.by-version."netjet"."1.1.3";
  by-version."netjet"."1.1.3" = self.buildNodePackage {
    name = "netjet-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/netjet/-/netjet-1.1.3.tgz";
      name = "netjet-1.1.3.tgz";
      sha1 = "5c4254b971362245afdf5f94d8f524bee91d7d5a";
    };
    deps = {
      "bl-1.2.1" = self.by-version."bl"."1.2.1";
      "hijackresponse-2.0.1" = self.by-version."hijackresponse"."2.0.1";
      "lodash.defaults-4.2.0" = self.by-version."lodash.defaults"."4.2.0";
      "lodash.unescape-4.0.1" = self.by-version."lodash.unescape"."4.0.1";
      "lru-cache-4.0.2" = self.by-version."lru-cache"."4.0.2";
      "posthtml-0.9.2" = self.by-version."posthtml"."0.9.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "netjet" = self.by-version."netjet"."1.1.3";
  by-spec."nock"."^9.0.2" =
    self.by-version."nock"."9.0.13";
  by-version."nock"."9.0.13" = self.buildNodePackage {
    name = "nock-9.0.13";
    version = "9.0.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nock/-/nock-9.0.13.tgz";
      name = "nock-9.0.13.tgz";
      sha1 = "d0bc39ef43d3179981e22b2e8ea069f916c5781a";
    };
    deps = {
      "chai-3.5.0" = self.by-version."chai"."3.5.0";
      "debug-2.6.8" = self.by-version."debug"."2.6.8";
      "deep-equal-1.0.1" = self.by-version."deep-equal"."1.0.1";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "propagate-0.4.0" = self.by-version."propagate"."0.4.0";
      "qs-6.4.0" = self.by-version."qs"."6.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-pre-gyp"."~0.6.31" =
    self.by-version."node-pre-gyp"."0.6.36";
  by-version."node-pre-gyp"."0.6.36" = self.buildNodePackage {
    name = "node-pre-gyp-0.6.36";
    version = "0.6.36";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-pre-gyp/-/node-pre-gyp-0.6.36.tgz";
      name = "node-pre-gyp-0.6.36.tgz";
      sha1 = "db604112cb74e0d477554e9b505b17abddfab786";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-4.0.1" = self.by-version."nopt"."4.0.1";
      "npmlog-4.1.0" = self.by-version."npmlog"."4.1.0";
      "rc-1.2.1" = self.by-version."rc"."1.2.1";
      "request-2.81.0" = self.by-version."request"."2.81.0";
      "rimraf-2.6.1" = self.by-version."rimraf"."2.6.1";
      "semver-5.3.0" = self.by-version."semver"."5.3.0";
      "tar-2.2.1" = self.by-version."tar"."2.2.1";
      "tar-pack-3.4.0" = self.by-version."tar-pack"."3.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."~1.4.7" =
    self.by-version."node-uuid"."1.4.8";
  by-version."node-uuid"."1.4.8" = self.buildNodePackage {
    name = "node-uuid-1.4.8";
    version = "1.4.8";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-uuid/-/node-uuid-1.4.8.tgz";
      name = "node-uuid-1.4.8.tgz";
      sha1 = "b040eb0923968afabf8d32fb1f17f1167fdab907";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nodemailer"."0.7.1" =
    self.by-version."nodemailer"."0.7.1";
  by-version."nodemailer"."0.7.1" = self.buildNodePackage {
    name = "nodemailer-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nodemailer/-/nodemailer-0.7.1.tgz";
      name = "nodemailer-0.7.1.tgz";
      sha1 = "1ec819e243622300a00abe746cb5d3389c0f316c";
    };
    deps = {
      "mailcomposer-0.2.12" = self.by-version."mailcomposer"."0.2.12";
      "simplesmtp-0.3.35" = self.by-version."simplesmtp"."0.3.35";
      "directmail-0.1.8" = self.by-version."directmail"."0.1.8";
      "he-0.3.6" = self.by-version."he"."0.3.6";
      "public-address-0.1.2" = self.by-version."public-address"."0.1.2";
      "aws-sdk-2.0.5" = self.by-version."aws-sdk"."2.0.5";
    };
    optionalDependencies = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "nodemailer" = self.by-version."nodemailer"."0.7.1";
  by-spec."nomnom"."1.5.2" =
    self.by-version."nomnom"."1.5.2";
  by-version."nomnom"."1.5.2" = self.buildNodePackage {
    name = "nomnom-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nomnom/-/nomnom-1.5.2.tgz";
      name = "nomnom-1.5.2.tgz";
      sha1 = "f4345448a853cfbd5c0d26320f2477ab0526fe2f";
    };
    deps = {
      "underscore-1.1.7" = self.by-version."underscore"."1.1.7";
      "colors-0.5.1" = self.by-version."colors"."0.5.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nopt"."^4.0.1" =
    self.by-version."nopt"."4.0.1";
  by-version."nopt"."4.0.1" = self.buildNodePackage {
    name = "nopt-4.0.1";
    version = "4.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/nopt/-/nopt-4.0.1.tgz";
      name = "nopt-4.0.1.tgz";
      sha1 = "d0d4685afd5415193c8c7505602d0d17cd64474d";
    };
    deps = {
      "abbrev-1.1.0" = self.by-version."abbrev"."1.1.0";
      "osenv-0.1.4" = self.by-version."osenv"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nopt"."~3.0.1" =
    self.by-version."nopt"."3.0.6";
  by-version."nopt"."3.0.6" = self.buildNodePackage {
    name = "nopt-3.0.6";
    version = "3.0.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz";
      name = "nopt-3.0.6.tgz";
      sha1 = "c6465dbf08abcd4db359317f79ac68a646b28ff9";
    };
    deps = {
      "abbrev-1.1.0" = self.by-version."abbrev"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."normalize-path"."^2.0.0" =
    self.by-version."normalize-path"."2.1.1";
  by-version."normalize-path"."2.1.1" = self.buildNodePackage {
    name = "normalize-path-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/normalize-path/-/normalize-path-2.1.1.tgz";
      name = "normalize-path-2.1.1.tgz";
      sha1 = "1ab28b556e198363a8c1a6f7e6fa20137fe6aed9";
    };
    deps = {
      "remove-trailing-separator-1.0.1" = self.by-version."remove-trailing-separator"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."normalize-path"."^2.0.1" =
    self.by-version."normalize-path"."2.1.1";
  by-spec."npmlog"."^4.0.2" =
    self.by-version."npmlog"."4.1.0";
  by-version."npmlog"."4.1.0" = self.buildNodePackage {
    name = "npmlog-4.1.0";
    version = "4.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/npmlog/-/npmlog-4.1.0.tgz";
      name = "npmlog-4.1.0.tgz";
      sha1 = "dc59bee85f64f00ed424efb2af0783df25d1c0b5";
    };
    deps = {
      "are-we-there-yet-1.1.4" = self.by-version."are-we-there-yet"."1.1.4";
      "console-control-strings-1.1.0" = self.by-version."console-control-strings"."1.1.0";
      "gauge-2.7.4" = self.by-version."gauge"."2.7.4";
      "set-blocking-2.0.0" = self.by-version."set-blocking"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nth-check"."~1.0.1" =
    self.by-version."nth-check"."1.0.1";
  by-version."nth-check"."1.0.1" = self.buildNodePackage {
    name = "nth-check-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nth-check/-/nth-check-1.0.1.tgz";
      name = "nth-check-1.0.1.tgz";
      sha1 = "9929acdf628fc2c41098deab82ac580cf149aae4";
    };
    deps = {
      "boolbase-1.0.0" = self.by-version."boolbase"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."number-is-nan"."^1.0.0" =
    self.by-version."number-is-nan"."1.0.1";
  by-version."number-is-nan"."1.0.1" = self.buildNodePackage {
    name = "number-is-nan-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz";
      name = "number-is-nan-1.0.1.tgz";
      sha1 = "097b602b53422a522c1afb8790318336941a011d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.8.1" =
    self.by-version."oauth-sign"."0.8.2";
  by-version."oauth-sign"."0.8.2" = self.buildNodePackage {
    name = "oauth-sign-0.8.2";
    version = "0.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.2.tgz";
      name = "oauth-sign-0.8.2.tgz";
      sha1 = "46a6ab7f0aead8deae9ec0565780b7d4efeb9d43";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth2orize"."1.8.0" =
    self.by-version."oauth2orize"."1.8.0";
  by-version."oauth2orize"."1.8.0" = self.buildNodePackage {
    name = "oauth2orize-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/oauth2orize/-/oauth2orize-1.8.0.tgz";
      name = "oauth2orize-1.8.0.tgz";
      sha1 = "f2ddc0115d635d0480746249c00f0ea1a9c51ba8";
    };
    deps = {
      "uid2-0.0.3" = self.by-version."uid2"."0.0.3";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "debug-2.6.8" = self.by-version."debug"."2.6.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "oauth2orize" = self.by-version."oauth2orize"."1.8.0";
  by-spec."object-assign"."4.1.0" =
    self.by-version."object-assign"."4.1.0";
  by-version."object-assign"."4.1.0" = self.buildNodePackage {
    name = "object-assign-4.1.0";
    version = "4.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-assign/-/object-assign-4.1.0.tgz";
      name = "object-assign-4.1.0.tgz";
      sha1 = "7a3b3d0e98063d43f4c03f2e8ae6cd51a86883a0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^3.0.0" =
    self.by-version."object-assign"."3.0.0";
  by-version."object-assign"."3.0.0" = self.buildNodePackage {
    name = "object-assign-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-assign/-/object-assign-3.0.0.tgz";
      name = "object-assign-3.0.0.tgz";
      sha1 = "9bedd5ca0897949bca47e7ff408062d549f587f2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^4" =
    self.by-version."object-assign"."4.1.1";
  by-version."object-assign"."4.1.1" = self.buildNodePackage {
    name = "object-assign-4.1.1";
    version = "4.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz";
      name = "object-assign-4.1.1.tgz";
      sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^4.1.0" =
    self.by-version."object-assign"."4.1.1";
  by-spec."object.omit"."^2.0.0" =
    self.by-version."object.omit"."2.0.1";
  by-version."object.omit"."2.0.1" = self.buildNodePackage {
    name = "object.omit-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz";
      name = "object.omit-2.0.1.tgz";
      sha1 = "1a9c744829f39dbb858c76ca3579ae2a54ebd1fa";
    };
    deps = {
      "for-own-0.1.5" = self.by-version."for-own"."0.1.5";
      "is-extendable-0.1.1" = self.by-version."is-extendable"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."^2.3.0" =
    self.by-version."on-finished"."2.3.0";
  by-version."on-finished"."2.3.0" = self.buildNodePackage {
    name = "on-finished-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz";
      name = "on-finished-2.3.0.tgz";
      sha1 = "20f1336481b083cd75337992a16971aa2d906947";
    };
    deps = {
      "ee-first-1.1.1" = self.by-version."ee-first"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.3.0" =
    self.by-version."on-finished"."2.3.0";
  by-spec."on-headers"."~1.0.0" =
    self.by-version."on-headers"."1.0.1";
  by-version."on-headers"."1.0.1" = self.buildNodePackage {
    name = "on-headers-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-headers/-/on-headers-1.0.1.tgz";
      name = "on-headers-1.0.1.tgz";
      sha1 = "928f5d0f470d49342651ea6794b0857c100693f7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-headers"."~1.0.1" =
    self.by-version."on-headers"."1.0.1";
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.4.0";
  by-version."once"."1.4.0" = self.buildNodePackage {
    name = "once-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
      name = "once-1.4.0.tgz";
      sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
    };
    deps = {
      "wrappy-1.0.2" = self.by-version."wrappy"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."^1.3.3" =
    self.by-version."once"."1.4.0";
  by-spec."once"."^1.4.0" =
    self.by-version."once"."1.4.0";
  by-spec."optimist"."^0.6.1" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = self.buildNodePackage {
    name = "optimist-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
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
  by-spec."optimist"."~0.6.0" =
    self.by-version."optimist"."0.6.1";
  by-spec."os-homedir"."^1.0.0" =
    self.by-version."os-homedir"."1.0.2";
  by-version."os-homedir"."1.0.2" = self.buildNodePackage {
    name = "os-homedir-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz";
      name = "os-homedir-1.0.2.tgz";
      sha1 = "ffbc4988336e0e833de0c168c7ef152121aa7fb3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-homedir"."^1.0.1" =
    self.by-version."os-homedir"."1.0.2";
  by-spec."os-locale"."^1.4.0" =
    self.by-version."os-locale"."1.4.0";
  by-version."os-locale"."1.4.0" = self.buildNodePackage {
    name = "os-locale-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-locale/-/os-locale-1.4.0.tgz";
      name = "os-locale-1.4.0.tgz";
      sha1 = "20f9f17ae29ed345e8bde583b13d2009803c14d9";
    };
    deps = {
      "lcid-1.0.0" = self.by-version."lcid"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-tmpdir"."^1.0.0" =
    self.by-version."os-tmpdir"."1.0.2";
  by-version."os-tmpdir"."1.0.2" = self.buildNodePackage {
    name = "os-tmpdir-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz";
      name = "os-tmpdir-1.0.2.tgz";
      sha1 = "bbe67406c79aa85c5cfec766fe5734555dfa1274";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."osenv"."^0.1.4" =
    self.by-version."osenv"."0.1.4";
  by-version."osenv"."0.1.4" = self.buildNodePackage {
    name = "osenv-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/osenv/-/osenv-0.1.4.tgz";
      name = "osenv-0.1.4.tgz";
      sha1 = "42fe6d5953df06c8064be6f176c3d05aaaa34644";
    };
    deps = {
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
      "os-tmpdir-1.0.2" = self.by-version."os-tmpdir"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."package-json-validator"."0.6.0" =
    self.by-version."package-json-validator"."0.6.0";
  by-version."package-json-validator"."0.6.0" = self.buildNodePackage {
    name = "package-json-validator-0.6.0";
    version = "0.6.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/package-json-validator/-/package-json-validator-0.6.0.tgz";
      name = "package-json-validator-0.6.0.tgz";
      sha1 = "5629c7328b1307d09e7f291027bd15952bbe80c2";
    };
    deps = {
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."packet-reader"."0.2.0" =
    self.by-version."packet-reader"."0.2.0";
  by-version."packet-reader"."0.2.0" = self.buildNodePackage {
    name = "packet-reader-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/packet-reader/-/packet-reader-0.2.0.tgz";
      name = "packet-reader-0.2.0.tgz";
      sha1 = "819df4d010b82d5ea5671f8a1a3acf039bcd7700";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parse-glob"."^3.0.4" =
    self.by-version."parse-glob"."3.0.4";
  by-version."parse-glob"."3.0.4" = self.buildNodePackage {
    name = "parse-glob-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz";
      name = "parse-glob-3.0.4.tgz";
      sha1 = "b2c376cfb11f35513badd173ef0bb6e3a388391c";
    };
    deps = {
      "glob-base-0.3.0" = self.by-version."glob-base"."0.3.0";
      "is-dotfile-1.0.3" = self.by-version."is-dotfile"."1.0.3";
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parse-passwd"."^1.0.0" =
    self.by-version."parse-passwd"."1.0.0";
  by-version."parse-passwd"."1.0.0" = self.buildNodePackage {
    name = "parse-passwd-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parse-passwd/-/parse-passwd-1.0.0.tgz";
      name = "parse-passwd-1.0.0.tgz";
      sha1 = "6d5b934a456993b23d37f40a382d6f1666a8e5c6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseurl"."~1.3.1" =
    self.by-version."parseurl"."1.3.1";
  by-version."parseurl"."1.3.1" = self.buildNodePackage {
    name = "parseurl-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parseurl/-/parseurl-1.3.1.tgz";
      name = "parseurl-1.3.1.tgz";
      sha1 = "c8ab8c9223ba34888aa64a297b28853bec18da56";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."passport"."0.3.2" =
    self.by-version."passport"."0.3.2";
  by-version."passport"."0.3.2" = self.buildNodePackage {
    name = "passport-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/passport/-/passport-0.3.2.tgz";
      name = "passport-0.3.2.tgz";
      sha1 = "9dd009f915e8fe095b0124a01b8f82da07510102";
    };
    deps = {
      "passport-strategy-1.0.0" = self.by-version."passport-strategy"."1.0.0";
      "pause-0.0.1" = self.by-version."pause"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "passport" = self.by-version."passport"."0.3.2";
  by-spec."passport-http-bearer"."1.0.1" =
    self.by-version."passport-http-bearer"."1.0.1";
  by-version."passport-http-bearer"."1.0.1" = self.buildNodePackage {
    name = "passport-http-bearer-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/passport-http-bearer/-/passport-http-bearer-1.0.1.tgz";
      name = "passport-http-bearer-1.0.1.tgz";
      sha1 = "147469ea3669e2a84c6167ef99dbb77e1f0098a8";
    };
    deps = {
      "passport-strategy-1.0.0" = self.by-version."passport-strategy"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "passport-http-bearer" = self.by-version."passport-http-bearer"."1.0.1";
  by-spec."passport-oauth2-client-password"."0.1.2" =
    self.by-version."passport-oauth2-client-password"."0.1.2";
  by-version."passport-oauth2-client-password"."0.1.2" = self.buildNodePackage {
    name = "passport-oauth2-client-password-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/passport-oauth2-client-password/-/passport-oauth2-client-password-0.1.2.tgz";
      name = "passport-oauth2-client-password-0.1.2.tgz";
      sha1 = "4f378b678b92d16dbbd233a6c706520093e561ba";
    };
    deps = {
      "passport-strategy-1.0.0" = self.by-version."passport-strategy"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "passport-oauth2-client-password" = self.by-version."passport-oauth2-client-password"."0.1.2";
  by-spec."passport-strategy"."1.x.x" =
    self.by-version."passport-strategy"."1.0.0";
  by-version."passport-strategy"."1.0.0" = self.buildNodePackage {
    name = "passport-strategy-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/passport-strategy/-/passport-strategy-1.0.0.tgz";
      name = "passport-strategy-1.0.0.tgz";
      sha1 = "b5539aa8fc225a3d1ad179476ddf236b440f52e4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-is-absolute"."^1.0.0" =
    self.by-version."path-is-absolute"."1.0.1";
  by-version."path-is-absolute"."1.0.1" = self.buildNodePackage {
    name = "path-is-absolute-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
      name = "path-is-absolute-1.0.1.tgz";
      sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-match"."1.2.4" =
    self.by-version."path-match"."1.2.4";
  by-version."path-match"."1.2.4" = self.buildNodePackage {
    name = "path-match-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-match/-/path-match-1.2.4.tgz";
      name = "path-match-1.2.4.tgz";
      sha1 = "a62747f3c7e0c2514762697f24443585b09100ea";
    };
    deps = {
      "http-errors-1.4.0" = self.by-version."http-errors"."1.4.0";
      "path-to-regexp-1.7.0" = self.by-version."path-to-regexp"."1.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "path-match" = self.by-version."path-match"."1.2.4";
  by-spec."path-parse"."^1.0.5" =
    self.by-version."path-parse"."1.0.5";
  by-version."path-parse"."1.0.5" = self.buildNodePackage {
    name = "path-parse-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-parse/-/path-parse-1.0.5.tgz";
      name = "path-parse-1.0.5.tgz";
      sha1 = "3c1adf871ea9cd6c9431b6ea2bd74a0ff055c4c1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-to-regexp"."0.1.7" =
    self.by-version."path-to-regexp"."0.1.7";
  by-version."path-to-regexp"."0.1.7" = self.buildNodePackage {
    name = "path-to-regexp-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz";
      name = "path-to-regexp-0.1.7.tgz";
      sha1 = "df604178005f522f15eb4490e7247a1bfaa67f8c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-to-regexp"."^1.0.0" =
    self.by-version."path-to-regexp"."1.7.0";
  by-version."path-to-regexp"."1.7.0" = self.buildNodePackage {
    name = "path-to-regexp-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-1.7.0.tgz";
      name = "path-to-regexp-1.7.0.tgz";
      sha1 = "59fde0f435badacba103a84e9d3bc64e96b9937d";
    };
    deps = {
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
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
      url = "https://registry.npmjs.org/pause/-/pause-0.0.1.tgz";
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
  by-spec."pend"."~1.2.0" =
    self.by-version."pend"."1.2.0";
  by-version."pend"."1.2.0" = self.buildNodePackage {
    name = "pend-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pend/-/pend-1.2.0.tgz";
      name = "pend-1.2.0.tgz";
      sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."performance-now"."^0.2.0" =
    self.by-version."performance-now"."0.2.0";
  by-version."performance-now"."0.2.0" = self.buildNodePackage {
    name = "performance-now-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/performance-now/-/performance-now-0.2.0.tgz";
      name = "performance-now-0.2.0.tgz";
      sha1 = "33ef30c5c77d4ea21c5a53869d91b56d8f2555e5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pg"."6.1.2" =
    self.by-version."pg"."6.1.2";
  by-version."pg"."6.1.2" = self.buildNodePackage {
    name = "pg-6.1.2";
    version = "6.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pg/-/pg-6.1.2.tgz";
      name = "pg-6.1.2.tgz";
      sha1 = "2c896a7434502e2b938c100fc085b4e974a186db";
    };
    deps = {
      "buffer-writer-1.0.1" = self.by-version."buffer-writer"."1.0.1";
      "packet-reader-0.2.0" = self.by-version."packet-reader"."0.2.0";
      "pg-connection-string-0.1.3" = self.by-version."pg-connection-string"."0.1.3";
      "pg-pool-1.7.1" = self.by-version."pg-pool"."1.7.1";
      "pg-types-1.12.0" = self.by-version."pg-types"."1.12.0";
      "pgpass-1.0.2" = self.by-version."pgpass"."1.0.2";
      "semver-4.3.2" = self.by-version."semver"."4.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pg" = self.by-version."pg"."6.1.2";
  by-spec."pg-connection-string"."0.1.3" =
    self.by-version."pg-connection-string"."0.1.3";
  by-version."pg-connection-string"."0.1.3" = self.buildNodePackage {
    name = "pg-connection-string-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pg-connection-string/-/pg-connection-string-0.1.3.tgz";
      name = "pg-connection-string-0.1.3.tgz";
      sha1 = "da1847b20940e42ee1492beaf65d49d91b245df7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pg-connection-string"."^0.1.3" =
    self.by-version."pg-connection-string"."0.1.3";
  by-spec."pg-pool"."1.*" =
    self.by-version."pg-pool"."1.7.1";
  by-version."pg-pool"."1.7.1" = self.buildNodePackage {
    name = "pg-pool-1.7.1";
    version = "1.7.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pg-pool/-/pg-pool-1.7.1.tgz";
      name = "pg-pool-1.7.1.tgz";
      sha1 = "421105cb7469979dcc48d6fc4fe3fe4659437437";
    };
    deps = {
      "generic-pool-2.4.3" = self.by-version."generic-pool"."2.4.3";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pg-types"."1.*" =
    self.by-version."pg-types"."1.12.0";
  by-version."pg-types"."1.12.0" = self.buildNodePackage {
    name = "pg-types-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pg-types/-/pg-types-1.12.0.tgz";
      name = "pg-types-1.12.0.tgz";
      sha1 = "8ad3b7b897e3fd463e62de241ad5fc640b4a66f0";
    };
    deps = {
      "ap-0.2.0" = self.by-version."ap"."0.2.0";
      "postgres-array-1.0.2" = self.by-version."postgres-array"."1.0.2";
      "postgres-bytea-1.0.0" = self.by-version."postgres-bytea"."1.0.0";
      "postgres-date-1.0.3" = self.by-version."postgres-date"."1.0.3";
      "postgres-interval-1.1.0" = self.by-version."postgres-interval"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pgpass"."1.x" =
    self.by-version."pgpass"."1.0.2";
  by-version."pgpass"."1.0.2" = self.buildNodePackage {
    name = "pgpass-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pgpass/-/pgpass-1.0.2.tgz";
      name = "pgpass-1.0.2.tgz";
      sha1 = "2a7bb41b6065b67907e91da1b07c1847c877b306";
    };
    deps = {
      "split-1.0.0" = self.by-version."split"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie"."^2.0.0" =
    self.by-version."pinkie"."2.0.4";
  by-version."pinkie"."2.0.4" = self.buildNodePackage {
    name = "pinkie-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz";
      name = "pinkie-2.0.4.tgz";
      sha1 = "72556b80cfa0d48a974e80e77248e80ed4f7f870";
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
    self.by-version."pinkie-promise"."2.0.1";
  by-version."pinkie-promise"."2.0.1" = self.buildNodePackage {
    name = "pinkie-promise-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz";
      name = "pinkie-promise-2.0.1.tgz";
      sha1 = "2135d6dfa7a358c069ac9b178776288228450ffa";
    };
    deps = {
      "pinkie-2.0.4" = self.by-version."pinkie"."2.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."postgres-array"."~1.0.0" =
    self.by-version."postgres-array"."1.0.2";
  by-version."postgres-array"."1.0.2" = self.buildNodePackage {
    name = "postgres-array-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/postgres-array/-/postgres-array-1.0.2.tgz";
      name = "postgres-array-1.0.2.tgz";
      sha1 = "8e0b32eb03bf77a5c0a7851e0441c169a256a238";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."postgres-bytea"."~1.0.0" =
    self.by-version."postgres-bytea"."1.0.0";
  by-version."postgres-bytea"."1.0.0" = self.buildNodePackage {
    name = "postgres-bytea-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/postgres-bytea/-/postgres-bytea-1.0.0.tgz";
      name = "postgres-bytea-1.0.0.tgz";
      sha1 = "027b533c0aa890e26d172d47cf9ccecc521acd35";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."postgres-date"."~1.0.0" =
    self.by-version."postgres-date"."1.0.3";
  by-version."postgres-date"."1.0.3" = self.buildNodePackage {
    name = "postgres-date-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/postgres-date/-/postgres-date-1.0.3.tgz";
      name = "postgres-date-1.0.3.tgz";
      sha1 = "e2d89702efdb258ff9d9cee0fe91bd06975257a8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."postgres-interval"."^1.1.0" =
    self.by-version."postgres-interval"."1.1.0";
  by-version."postgres-interval"."1.1.0" = self.buildNodePackage {
    name = "postgres-interval-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/postgres-interval/-/postgres-interval-1.1.0.tgz";
      name = "postgres-interval-1.1.0.tgz";
      sha1 = "1031e7bac34564132862adc9eb6c6d2f3aa75bb4";
    };
    deps = {
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."posthtml"."^0.9.0" =
    self.by-version."posthtml"."0.9.2";
  by-version."posthtml"."0.9.2" = self.buildNodePackage {
    name = "posthtml-0.9.2";
    version = "0.9.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/posthtml/-/posthtml-0.9.2.tgz";
      name = "posthtml-0.9.2.tgz";
      sha1 = "f4c06db9f67b61fd17c4e256e7e3d9515bf726fd";
    };
    deps = {
      "posthtml-parser-0.2.1" = self.by-version."posthtml-parser"."0.2.1";
      "posthtml-render-1.0.6" = self.by-version."posthtml-render"."1.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."posthtml-parser"."^0.2.0" =
    self.by-version."posthtml-parser"."0.2.1";
  by-version."posthtml-parser"."0.2.1" = self.buildNodePackage {
    name = "posthtml-parser-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/posthtml-parser/-/posthtml-parser-0.2.1.tgz";
      name = "posthtml-parser-0.2.1.tgz";
      sha1 = "35d530de386740c2ba24ff2eb2faf39ccdf271dd";
    };
    deps = {
      "htmlparser2-3.9.2" = self.by-version."htmlparser2"."3.9.2";
      "isobject-2.1.0" = self.by-version."isobject"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."posthtml-render"."^1.0.5" =
    self.by-version."posthtml-render"."1.0.6";
  by-version."posthtml-render"."1.0.6" = self.buildNodePackage {
    name = "posthtml-render-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/posthtml-render/-/posthtml-render-1.0.6.tgz";
      name = "posthtml-render-1.0.6.tgz";
      sha1 = "1b88b8e7860a8ebdfe2f2a1310a4642a55cf5bda";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."preserve"."^0.2.0" =
    self.by-version."preserve"."0.2.0";
  by-version."preserve"."0.2.0" = self.buildNodePackage {
    name = "preserve-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz";
      name = "preserve-0.2.0.tgz";
      sha1 = "815ed1f6ebc65926f865b310c0713bcb3315ce4b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prettyjson"."1.1.3" =
    self.by-version."prettyjson"."1.1.3";
  by-version."prettyjson"."1.1.3" = self.buildNodePackage {
    name = "prettyjson-1.1.3";
    version = "1.1.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/prettyjson/-/prettyjson-1.1.3.tgz";
      name = "prettyjson-1.1.3.tgz";
      sha1 = "d0787f732c9c3a566f4165fa4f1176fd67e6b263";
    };
    deps = {
      "colors-1.1.2" = self.by-version."colors"."1.1.2";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."process-nextick-args"."~1.0.6" =
    self.by-version."process-nextick-args"."1.0.7";
  by-version."process-nextick-args"."1.0.7" = self.buildNodePackage {
    name = "process-nextick-args-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.7.tgz";
      name = "process-nextick-args-1.0.7.tgz";
      sha1 = "150e20b756590ad3f91093f25a4f2ad8bff30ba3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."propagate"."0.4.0" =
    self.by-version."propagate"."0.4.0";
  by-version."propagate"."0.4.0" = self.buildNodePackage {
    name = "propagate-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/propagate/-/propagate-0.4.0.tgz";
      name = "propagate-0.4.0.tgz";
      sha1 = "f3fcca0a6fe06736a7ba572966069617c130b481";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."proto-list"."~1.2.1" =
    self.by-version."proto-list"."1.2.4";
  by-version."proto-list"."1.2.4" = self.buildNodePackage {
    name = "proto-list-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/proto-list/-/proto-list-1.2.4.tgz";
      name = "proto-list-1.2.4.tgz";
      sha1 = "212d5bfe1318306a420f6402b8e26ff39647a849";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."proxy-addr"."~1.1.2" =
    self.by-version."proxy-addr"."1.1.4";
  by-version."proxy-addr"."1.1.4" = self.buildNodePackage {
    name = "proxy-addr-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/proxy-addr/-/proxy-addr-1.1.4.tgz";
      name = "proxy-addr-1.1.4.tgz";
      sha1 = "27e545f6960a44a627d9b44467e35c1b6b4ce2f3";
    };
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-1.3.0" = self.by-version."ipaddr.js"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."proxy-addr"."~1.1.3" =
    self.by-version."proxy-addr"."1.1.4";
  by-spec."pseudomap"."^1.0.1" =
    self.by-version."pseudomap"."1.0.2";
  by-version."pseudomap"."1.0.2" = self.buildNodePackage {
    name = "pseudomap-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz";
      name = "pseudomap-1.0.2.tgz";
      sha1 = "f052a28da70e618917ef0a8ac34c1ae5a68286b3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."public-address"."~0.1.1" =
    self.by-version."public-address"."0.1.2";
  by-version."public-address"."0.1.2" = self.buildNodePackage {
    name = "public-address-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/public-address/-/public-address-0.1.2.tgz";
      name = "public-address-0.1.2.tgz";
      sha1 = "f95f3e0cf28b89f965b0f188fd1267ac0856552f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode"."^1.4.1" =
    self.by-version."punycode"."1.4.1";
  by-version."punycode"."1.4.1" = self.buildNodePackage {
    name = "punycode-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz";
      name = "punycode-1.4.1.tgz";
      sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode"."~1.2.4" =
    self.by-version."punycode"."1.2.4";
  by-version."punycode"."1.2.4" = self.buildNodePackage {
    name = "punycode-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/punycode/-/punycode-1.2.4.tgz";
      name = "punycode-1.2.4.tgz";
      sha1 = "54008ac972aec74175def9cba6df7fa9d3918740";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."6.2.0" =
    self.by-version."qs"."6.2.0";
  by-version."qs"."6.2.0" = self.buildNodePackage {
    name = "qs-6.2.0";
    version = "6.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-6.2.0.tgz";
      name = "qs-6.2.0.tgz";
      sha1 = "3b7848c03c2dece69a9522b0fae8c4126d745f3b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."6.3.1" =
    self.by-version."qs"."6.3.1";
  by-version."qs"."6.3.1" = self.buildNodePackage {
    name = "qs-6.3.1";
    version = "6.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-6.3.1.tgz";
      name = "qs-6.3.1.tgz";
      sha1 = "918c0b3bcd36679772baf135b1acb4c1651ed79d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."^6.0.2" =
    self.by-version."qs"."6.4.0";
  by-version."qs"."6.4.0" = self.buildNodePackage {
    name = "qs-6.4.0";
    version = "6.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-6.4.0.tgz";
      name = "qs-6.4.0.tgz";
      sha1 = "13e26d28ad6b0ffaa91312cd3bf708ed351e7233";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."^6.1.0" =
    self.by-version."qs"."6.4.0";
  by-spec."qs"."~6.2.0" =
    self.by-version."qs"."6.2.3";
  by-version."qs"."6.2.3" = self.buildNodePackage {
    name = "qs-6.2.3";
    version = "6.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-6.2.3.tgz";
      name = "qs-6.2.3.tgz";
      sha1 = "1cfcb25c10a9b2b483053ff39f5dfc9233908cfe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~6.4.0" =
    self.by-version."qs"."6.4.0";
  by-spec."rai"."~0.1.11" =
    self.by-version."rai"."0.1.12";
  by-version."rai"."0.1.12" = self.buildNodePackage {
    name = "rai-0.1.12";
    version = "0.1.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/rai/-/rai-0.1.12.tgz";
      name = "rai-0.1.12.tgz";
      sha1 = "8ccfd014d0f9608630dd73c19b8e4b057754a6a6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."randomatic"."^1.1.3" =
    self.by-version."randomatic"."1.1.6";
  by-version."randomatic"."1.1.6" = self.buildNodePackage {
    name = "randomatic-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/randomatic/-/randomatic-1.1.6.tgz";
      name = "randomatic-1.1.6.tgz";
      sha1 = "110dcabff397e9dcff7c0789ccc0a49adf1ec5bb";
    };
    deps = {
      "is-number-2.1.0" = self.by-version."is-number"."2.1.0";
      "kind-of-3.2.2" = self.by-version."kind-of"."3.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."range-parser"."~1.2.0" =
    self.by-version."range-parser"."1.2.0";
  by-version."range-parser"."1.2.0" = self.buildNodePackage {
    name = "range-parser-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/range-parser/-/range-parser-1.2.0.tgz";
      name = "range-parser-1.2.0.tgz";
      sha1 = "f49be6b487894ddc40dcc94a322f611092e00d5e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."raw-body"."~2.2.0" =
    self.by-version."raw-body"."2.2.0";
  by-version."raw-body"."2.2.0" = self.buildNodePackage {
    name = "raw-body-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/raw-body/-/raw-body-2.2.0.tgz";
      name = "raw-body-2.2.0.tgz";
      sha1 = "994976cf6a5096a41162840492f0bdc5d6e7fb96";
    };
    deps = {
      "bytes-2.4.0" = self.by-version."bytes"."2.4.0";
      "iconv-lite-0.4.15" = self.by-version."iconv-lite"."0.4.15";
      "unpipe-1.0.0" = self.by-version."unpipe"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rc"."^1.1.7" =
    self.by-version."rc"."1.2.1";
  by-version."rc"."1.2.1" = self.buildNodePackage {
    name = "rc-1.2.1";
    version = "1.2.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rc/-/rc-1.2.1.tgz";
      name = "rc-1.2.1.tgz";
      sha1 = "2e03e8e42ee450b8cb3dce65be1bf8974e1dfd95";
    };
    deps = {
      "deep-extend-0.4.2" = self.by-version."deep-extend"."0.4.2";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "strip-json-comments-2.0.1" = self.by-version."strip-json-comments"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."1.1.x" =
    self.by-version."readable-stream"."1.1.14";
  by-version."readable-stream"."1.1.14" = self.buildNodePackage {
    name = "readable-stream-1.1.14";
    version = "1.1.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz";
      name = "readable-stream-1.1.14.tgz";
      sha1 = "7cf4c54ef648e3813084c636dd2079e166c081d9";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^1.1.12" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^2.0.0" =
    self.by-version."readable-stream"."2.2.10";
  by-version."readable-stream"."2.2.10" = self.buildNodePackage {
    name = "readable-stream-2.2.10";
    version = "2.2.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.2.10.tgz";
      name = "readable-stream-2.2.10.tgz";
      sha1 = "effe72bb7c884c0dd335e2379d526196d9d011ee";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
      "process-nextick-args-1.0.7" = self.by-version."process-nextick-args"."1.0.7";
      "safe-buffer-5.1.0" = self.by-version."safe-buffer"."5.1.0";
      "string_decoder-1.0.1" = self.by-version."string_decoder"."1.0.1";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^2.0.2" =
    self.by-version."readable-stream"."2.2.10";
  by-spec."readable-stream"."^2.0.5" =
    self.by-version."readable-stream"."2.2.10";
  by-spec."readable-stream"."^2.0.6" =
    self.by-version."readable-stream"."2.2.10";
  by-spec."readable-stream"."^2.1.4" =
    self.by-version."readable-stream"."2.2.10";
  by-spec."readable-stream"."^2.1.5" =
    self.by-version."readable-stream"."2.2.10";
  by-spec."readable-stream"."^2.2.2" =
    self.by-version."readable-stream"."2.2.10";
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."~2.0.0" =
    self.by-version."readable-stream"."2.0.6";
  by-version."readable-stream"."2.0.6" = self.buildNodePackage {
    name = "readable-stream-2.0.6";
    version = "2.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.0.6.tgz";
      name = "readable-stream-2.0.6.tgz";
      sha1 = "8f90341e68a53ccc928788dacfcd11b36eb9b78e";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
      "process-nextick-args-1.0.7" = self.by-version."process-nextick-args"."1.0.7";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."~2.0.5" =
    self.by-version."readable-stream"."2.0.6";
  by-spec."readdirp"."2.1.0" =
    self.by-version."readdirp"."2.1.0";
  by-version."readdirp"."2.1.0" = self.buildNodePackage {
    name = "readdirp-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readdirp/-/readdirp-2.1.0.tgz";
      name = "readdirp-2.1.0.tgz";
      sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "minimatch-3.0.4" = self.by-version."minimatch"."3.0.4";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
      "set-immediate-shim-1.0.1" = self.by-version."set-immediate-shim"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rechoir"."^0.6.2" =
    self.by-version."rechoir"."0.6.2";
  by-version."rechoir"."0.6.2" = self.buildNodePackage {
    name = "rechoir-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/rechoir/-/rechoir-0.6.2.tgz";
      name = "rechoir-0.6.2.tgz";
      sha1 = "85204b54dba82d5742e28c96756ef43af50e3384";
    };
    deps = {
      "resolve-1.3.3" = self.by-version."resolve"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."regenerator-runtime"."^0.10.0" =
    self.by-version."regenerator-runtime"."0.10.5";
  by-version."regenerator-runtime"."0.10.5" = self.buildNodePackage {
    name = "regenerator-runtime-0.10.5";
    version = "0.10.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/regenerator-runtime/-/regenerator-runtime-0.10.5.tgz";
      name = "regenerator-runtime-0.10.5.tgz";
      sha1 = "336c3efc1220adcedda2c9fab67b5a7955a33658";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."regex-cache"."^0.4.2" =
    self.by-version."regex-cache"."0.4.3";
  by-version."regex-cache"."0.4.3" = self.buildNodePackage {
    name = "regex-cache-0.4.3";
    version = "0.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.3.tgz";
      name = "regex-cache-0.4.3.tgz";
      sha1 = "9b1a6c35d4d0dfcef5711ae651e8e9d3d7114145";
    };
    deps = {
      "is-equal-shallow-0.1.3" = self.by-version."is-equal-shallow"."0.1.3";
      "is-primitive-2.0.0" = self.by-version."is-primitive"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."regexp-quote"."0.0.0" =
    self.by-version."regexp-quote"."0.0.0";
  by-version."regexp-quote"."0.0.0" = self.buildNodePackage {
    name = "regexp-quote-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/regexp-quote/-/regexp-quote-0.0.0.tgz";
      name = "regexp-quote-0.0.0.tgz";
      sha1 = "1e0f4650c862dcbfed54fd42b148e9bb1721fcf2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."remove-trailing-separator"."^1.0.1" =
    self.by-version."remove-trailing-separator"."1.0.1";
  by-version."remove-trailing-separator"."1.0.1" = self.buildNodePackage {
    name = "remove-trailing-separator-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/remove-trailing-separator/-/remove-trailing-separator-1.0.1.tgz";
      name = "remove-trailing-separator-1.0.1.tgz";
      sha1 = "615ebb96af559552d4bf4057c8436d486ab63cc4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."repeat-element"."^1.1.2" =
    self.by-version."repeat-element"."1.1.2";
  by-version."repeat-element"."1.1.2" = self.buildNodePackage {
    name = "repeat-element-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.2.tgz";
      name = "repeat-element-1.1.2.tgz";
      sha1 = "ef089a178d1483baae4d93eb98b4f9e4e11d990a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."repeat-string"."^1.5.2" =
    self.by-version."repeat-string"."1.6.1";
  by-version."repeat-string"."1.6.1" = self.buildNodePackage {
    name = "repeat-string-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz";
      name = "repeat-string-1.6.1.tgz";
      sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2.75.x" =
    self.by-version."request"."2.75.0";
  by-version."request"."2.75.0" = self.buildNodePackage {
    name = "request-2.75.0";
    version = "2.75.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/request/-/request-2.75.0.tgz";
      name = "request-2.75.0.tgz";
      sha1 = "d2b8268a286da13eaa5d01adf5d18cc90f657d93";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.6.0" = self.by-version."aws4"."1.6.0";
      "bl-1.1.2" = self.by-version."bl"."1.1.2";
      "caseless-0.11.0" = self.by-version."caseless"."0.11.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.1" = self.by-version."extend"."3.0.1";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-2.0.0" = self.by-version."form-data"."2.0.0";
      "har-validator-2.0.6" = self.by-version."har-validator"."2.0.6";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.15" = self.by-version."mime-types"."2.1.15";
      "node-uuid-1.4.8" = self.by-version."node-uuid"."1.4.8";
      "oauth-sign-0.8.2" = self.by-version."oauth-sign"."0.8.2";
      "qs-6.2.3" = self.by-version."qs"."6.2.3";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.3.2" = self.by-version."tough-cookie"."2.3.2";
      "tunnel-agent-0.4.3" = self.by-version."tunnel-agent"."0.4.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.81.0" =
    self.by-version."request"."2.81.0";
  by-version."request"."2.81.0" = self.buildNodePackage {
    name = "request-2.81.0";
    version = "2.81.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/request/-/request-2.81.0.tgz";
      name = "request-2.81.0.tgz";
      sha1 = "c6928946a0e06c5f8d6f8a9333469ffda46298a0";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.6.0" = self.by-version."aws4"."1.6.0";
      "caseless-0.12.0" = self.by-version."caseless"."0.12.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.1" = self.by-version."extend"."3.0.1";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-2.1.4" = self.by-version."form-data"."2.1.4";
      "har-validator-4.2.1" = self.by-version."har-validator"."4.2.1";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.15" = self.by-version."mime-types"."2.1.15";
      "oauth-sign-0.8.2" = self.by-version."oauth-sign"."0.8.2";
      "performance-now-0.2.0" = self.by-version."performance-now"."0.2.0";
      "qs-6.4.0" = self.by-version."qs"."6.4.0";
      "safe-buffer-5.1.0" = self.by-version."safe-buffer"."5.1.0";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.3.2" = self.by-version."tough-cookie"."2.3.2";
      "tunnel-agent-0.6.0" = self.by-version."tunnel-agent"."0.6.0";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."require-all"."0.0.3" =
    self.by-version."require-all"."0.0.3";
  by-version."require-all"."0.0.3" = self.buildNodePackage {
    name = "require-all-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/require-all/-/require-all-0.0.3.tgz";
      name = "require-all-0.0.3.tgz";
      sha1 = "051e192246c00d399bfe6164bc4e810bc588e01a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."require-dir"."0.1.0" =
    self.by-version."require-dir"."0.1.0";
  by-version."require-dir"."0.1.0" = self.buildNodePackage {
    name = "require-dir-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/require-dir/-/require-dir-0.1.0.tgz";
      name = "require-dir-0.1.0.tgz";
      sha1 = "81e01e299faf5b74c34b6594f8e5add5985ddec5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."^1.1.6" =
    self.by-version."resolve"."1.3.3";
  by-version."resolve"."1.3.3" = self.buildNodePackage {
    name = "resolve-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resolve/-/resolve-1.3.3.tgz";
      name = "resolve-1.3.3.tgz";
      sha1 = "655907c3469a8680dc2de3a275a8fdd69691f0e5";
    };
    deps = {
      "path-parse-1.0.5" = self.by-version."path-parse"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."^1.1.7" =
    self.by-version."resolve"."1.3.3";
  by-spec."resolve-dir"."^0.1.0" =
    self.by-version."resolve-dir"."0.1.1";
  by-version."resolve-dir"."0.1.1" = self.buildNodePackage {
    name = "resolve-dir-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resolve-dir/-/resolve-dir-0.1.1.tgz";
      name = "resolve-dir-0.1.1.tgz";
      sha1 = "b219259a5602fac5c5c496ad894a6e8cc430261e";
    };
    deps = {
      "expand-tilde-1.2.2" = self.by-version."expand-tilde"."1.2.2";
      "global-modules-0.2.3" = self.by-version."global-modules"."0.2.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rewire"."^2.5.2" =
    self.by-version."rewire"."2.5.2";
  by-version."rewire"."2.5.2" = self.buildNodePackage {
    name = "rewire-2.5.2";
    version = "2.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/rewire/-/rewire-2.5.2.tgz";
      name = "rewire-2.5.2.tgz";
      sha1 = "6427de7b7feefa7d36401507eb64a5385bc58dc7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."right-align"."^0.1.1" =
    self.by-version."right-align"."0.1.3";
  by-version."right-align"."0.1.3" = self.buildNodePackage {
    name = "right-align-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/right-align/-/right-align-0.1.3.tgz";
      name = "right-align-0.1.3.tgz";
      sha1 = "61339b722fe6a3515689210d24e14c96148613ef";
    };
    deps = {
      "align-text-0.1.4" = self.by-version."align-text"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."2" =
    self.by-version."rimraf"."2.6.1";
  by-version."rimraf"."2.6.1" = self.buildNodePackage {
    name = "rimraf-2.6.1";
    version = "2.6.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.6.1.tgz";
      name = "rimraf-2.6.1.tgz";
      sha1 = "c2338ec643df7a1b7fe5c54fa86f57428a55f33d";
    };
    deps = {
      "glob-7.1.2" = self.by-version."glob"."7.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.6.1";
  by-spec."rimraf"."^2.5.1" =
    self.by-version."rimraf"."2.6.1";
  by-spec."rimraf"."^2.6.1" =
    self.by-version."rimraf"."2.6.1";
  by-spec."rimraf"."~2.4.0" =
    self.by-version."rimraf"."2.4.5";
  by-version."rimraf"."2.4.5" = self.buildNodePackage {
    name = "rimraf-2.4.5";
    version = "2.4.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.4.5.tgz";
      name = "rimraf-2.4.5.tgz";
      sha1 = "ee710ce5d93a8fdb856fb5ea8ff0e2d75934b2da";
    };
    deps = {
      "glob-6.0.4" = self.by-version."glob"."6.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rss"."1.2.2" =
    self.by-version."rss"."1.2.2";
  by-version."rss"."1.2.2" = self.buildNodePackage {
    name = "rss-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/rss/-/rss-1.2.2.tgz";
      name = "rss-1.2.2.tgz";
      sha1 = "50a1698876138133a74f9a05d2bdc8db8d27a921";
    };
    deps = {
      "mime-types-2.1.13" = self.by-version."mime-types"."2.1.13";
      "xml-1.0.1" = self.by-version."xml"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "rss" = self.by-version."rss"."1.2.2";
  by-spec."safe-buffer"."^5.0.1" =
    self.by-version."safe-buffer"."5.1.0";
  by-version."safe-buffer"."5.1.0" = self.buildNodePackage {
    name = "safe-buffer-5.1.0";
    version = "5.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.0.tgz";
      name = "safe-buffer-5.1.0.tgz";
      sha1 = "fe4c8460397f9eaaaa58e73be46273408a45e223";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."safe-json-stringify"."~1" =
    self.by-version."safe-json-stringify"."1.0.4";
  by-version."safe-json-stringify"."1.0.4" = self.buildNodePackage {
    name = "safe-json-stringify-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/safe-json-stringify/-/safe-json-stringify-1.0.4.tgz";
      name = "safe-json-stringify-1.0.4.tgz";
      sha1 = "81a098f447e4bbc3ff3312a243521bc060ef5911";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sanitize-html"."1.14.1" =
    self.by-version."sanitize-html"."1.14.1";
  by-version."sanitize-html"."1.14.1" = self.buildNodePackage {
    name = "sanitize-html-1.14.1";
    version = "1.14.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sanitize-html/-/sanitize-html-1.14.1.tgz";
      name = "sanitize-html-1.14.1.tgz";
      sha1 = "730ffa2249bdf18333effe45b286173c9c5ad0b8";
    };
    deps = {
      "htmlparser2-3.9.2" = self.by-version."htmlparser2"."3.9.2";
      "regexp-quote-0.0.0" = self.by-version."regexp-quote"."0.0.0";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "sanitize-html" = self.by-version."sanitize-html"."1.14.1";
  by-spec."sax"."0.4.2" =
    self.by-version."sax"."0.4.2";
  by-version."sax"."0.4.2" = self.buildNodePackage {
    name = "sax-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sax/-/sax-0.4.2.tgz";
      name = "sax-0.4.2.tgz";
      sha1 = "39f3b601733d6bec97105b242a2a40fd6978ac3c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."secure-keys"."^1.0.0" =
    self.by-version."secure-keys"."1.0.0";
  by-version."secure-keys"."1.0.0" = self.buildNodePackage {
    name = "secure-keys-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/secure-keys/-/secure-keys-1.0.0.tgz";
      name = "secure-keys-1.0.0.tgz";
      sha1 = "f0c82d98a3b139a8776a8808050b824431087fca";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver"."4.3.2" =
    self.by-version."semver"."4.3.2";
  by-version."semver"."4.3.2" = self.buildNodePackage {
    name = "semver-4.3.2";
    version = "4.3.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/semver/-/semver-4.3.2.tgz";
      name = "semver-4.3.2.tgz";
      sha1 = "c7a07158a80bedd052355b770d82d6640f803be7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver"."5.3.0" =
    self.by-version."semver"."5.3.0";
  by-version."semver"."5.3.0" = self.buildNodePackage {
    name = "semver-5.3.0";
    version = "5.3.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/semver/-/semver-5.3.0.tgz";
      name = "semver-5.3.0.tgz";
      sha1 = "9b2ce5d3de02d17c6012ad326aa6b4d0cf54f94f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "semver" = self.by-version."semver"."5.3.0";
  by-spec."semver"."^5.3.0" =
    self.by-version."semver"."5.3.0";
  by-spec."send"."0.14.1" =
    self.by-version."send"."0.14.1";
  by-version."send"."0.14.1" = self.buildNodePackage {
    name = "send-0.14.1";
    version = "0.14.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/send/-/send-0.14.1.tgz";
      name = "send-0.14.1.tgz";
      sha1 = "a954984325392f51532a7760760e459598c89f7a";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "destroy-1.0.4" = self.by-version."destroy"."1.0.4";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.7.0" = self.by-version."etag"."1.7.0";
      "fresh-0.3.0" = self.by-version."fresh"."0.3.0";
      "http-errors-1.5.1" = self.by-version."http-errors"."1.5.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."send"."0.14.2" =
    self.by-version."send"."0.14.2";
  by-version."send"."0.14.2" = self.buildNodePackage {
    name = "send-0.14.2";
    version = "0.14.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/send/-/send-0.14.2.tgz";
      name = "send-0.14.2.tgz";
      sha1 = "39b0438b3f510be5dc6f667a11f71689368cdeef";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "destroy-1.0.4" = self.by-version."destroy"."1.0.4";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.7.0" = self.by-version."etag"."1.7.0";
      "fresh-0.3.0" = self.by-version."fresh"."0.3.0";
      "http-errors-1.5.1" = self.by-version."http-errors"."1.5.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.2" = self.by-version."ms"."0.7.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."send"."0.15.0" =
    self.by-version."send"."0.15.0";
  by-version."send"."0.15.0" = self.buildNodePackage {
    name = "send-0.15.0";
    version = "0.15.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/send/-/send-0.15.0.tgz";
      name = "send-0.15.0.tgz";
      sha1 = "f0185d6466fa76424b866f3d533e2d19dd0aaa39";
    };
    deps = {
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "destroy-1.0.4" = self.by-version."destroy"."1.0.4";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.8.0" = self.by-version."etag"."1.8.0";
      "fresh-0.5.0" = self.by-version."fresh"."0.5.0";
      "http-errors-1.6.1" = self.by-version."http-errors"."1.6.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.2" = self.by-version."ms"."0.7.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."1.12.0" =
    self.by-version."serve-static"."1.12.0";
  by-version."serve-static"."1.12.0" = self.buildNodePackage {
    name = "serve-static-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/serve-static/-/serve-static-1.12.0.tgz";
      name = "serve-static-1.12.0.tgz";
      sha1 = "150eb8aa262c2dd1924e960373145446c069dad6";
    };
    deps = {
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "send-0.15.0" = self.by-version."send"."0.15.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.11.1" =
    self.by-version."serve-static"."1.11.2";
  by-version."serve-static"."1.11.2" = self.buildNodePackage {
    name = "serve-static-1.11.2";
    version = "1.11.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/serve-static/-/serve-static-1.11.2.tgz";
      name = "serve-static-1.11.2.tgz";
      sha1 = "2cf9889bd4435a320cc36895c9aa57bd662e6ac7";
    };
    deps = {
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "send-0.14.2" = self.by-version."send"."0.14.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."set-blocking"."~2.0.0" =
    self.by-version."set-blocking"."2.0.0";
  by-version."set-blocking"."2.0.0" = self.buildNodePackage {
    name = "set-blocking-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz";
      name = "set-blocking-2.0.0.tgz";
      sha1 = "045f9782d011ae9a6803ddd382b24392b3d890f7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."set-immediate-shim"."^1.0.1" =
    self.by-version."set-immediate-shim"."1.0.1";
  by-version."set-immediate-shim"."1.0.1" = self.buildNodePackage {
    name = "set-immediate-shim-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
      name = "set-immediate-shim-1.0.1.tgz";
      sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."setprototypeof"."1.0.2" =
    self.by-version."setprototypeof"."1.0.2";
  by-version."setprototypeof"."1.0.2" = self.buildNodePackage {
    name = "setprototypeof-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.2.tgz";
      name = "setprototypeof-1.0.2.tgz";
      sha1 = "81a552141ec104b88e89ce383103ad5c66564d08";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."setprototypeof"."1.0.3" =
    self.by-version."setprototypeof"."1.0.3";
  by-version."setprototypeof"."1.0.3" = self.buildNodePackage {
    name = "setprototypeof-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.3.tgz";
      name = "setprototypeof-1.0.3.tgz";
      sha1 = "66567e37043eeb4f04d91bd658c0cbefb55b8e04";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."showdown-ghost"."0.3.6" =
    self.by-version."showdown-ghost"."0.3.6";
  by-version."showdown-ghost"."0.3.6" = self.buildNodePackage {
    name = "showdown-ghost-0.3.6";
    version = "0.3.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/showdown-ghost/-/showdown-ghost-0.3.6.tgz";
      name = "showdown-ghost-0.3.6.tgz";
      sha1 = "ec73685cc5b4790352b00ed9e2cb26efc337d2f1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "showdown-ghost" = self.by-version."showdown-ghost"."0.3.6";
  by-spec."sigmund"."^1.0.1" =
    self.by-version."sigmund"."1.0.1";
  by-version."sigmund"."1.0.1" = self.buildNodePackage {
    name = "sigmund-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sigmund/-/sigmund-1.0.1.tgz";
      name = "sigmund-1.0.1.tgz";
      sha1 = "3ff21f198cad2175f9f3b781853fd94d0d19b590";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."signal-exit"."^3.0.0" =
    self.by-version."signal-exit"."3.0.2";
  by-version."signal-exit"."3.0.2" = self.buildNodePackage {
    name = "signal-exit-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.2.tgz";
      name = "signal-exit-3.0.2.tgz";
      sha1 = "b5fdc08f1287ea1178628e415e25132b73646c6d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."simplesmtp"."~0.2 || ~0.3.30" =
    self.by-version."simplesmtp"."0.3.35";
  by-version."simplesmtp"."0.3.35" = self.buildNodePackage {
    name = "simplesmtp-0.3.35";
    version = "0.3.35";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/simplesmtp/-/simplesmtp-0.3.35.tgz";
      name = "simplesmtp-0.3.35.tgz";
      sha1 = "017b1eb8b26317ac36d2a2a8a932631880736a03";
    };
    deps = {
      "rai-0.1.12" = self.by-version."rai"."0.1.12";
      "xoauth2-0.1.8" = self.by-version."xoauth2"."0.1.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."simplesmtp"."~0.3.30" =
    self.by-version."simplesmtp"."0.3.35";
  by-spec."sntp"."1.x.x" =
    self.by-version."sntp"."1.0.9";
  by-version."sntp"."1.0.9" = self.buildNodePackage {
    name = "sntp-1.0.9";
    version = "1.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
      name = "sntp-1.0.9.tgz";
      sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
    };
    deps = {
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map".">= 0.1.2" =
    self.by-version."source-map"."0.5.6";
  by-version."source-map"."0.5.6" = self.buildNodePackage {
    name = "source-map-0.5.6";
    version = "0.5.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/source-map/-/source-map-0.5.6.tgz";
      name = "source-map-0.5.6.tgz";
      sha1 = "75ce38f52bf0733c5a7f0c118d81334a2bb5f412";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."^0.4.4" =
    self.by-version."source-map"."0.4.4";
  by-version."source-map"."0.4.4" = self.buildNodePackage {
    name = "source-map-0.4.4";
    version = "0.4.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/source-map/-/source-map-0.4.4.tgz";
      name = "source-map-0.4.4.tgz";
      sha1 = "eba4f5da9c0dc999de68032d8b4f76173652036b";
    };
    deps = {
      "amdefine-1.0.1" = self.by-version."amdefine"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.5.1" =
    self.by-version."source-map"."0.5.6";
  by-spec."split"."^1.0.0" =
    self.by-version."split"."1.0.0";
  by-version."split"."1.0.0" = self.buildNodePackage {
    name = "split-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/split/-/split-1.0.0.tgz";
      name = "split-1.0.0.tgz";
      sha1 = "c4395ce683abcd254bc28fe1dabb6e5c27dcffae";
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
  by-spec."split2"."^2.1.0" =
    self.by-version."split2"."2.1.1";
  by-version."split2"."2.1.1" = self.buildNodePackage {
    name = "split2-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/split2/-/split2-2.1.1.tgz";
      name = "split2-2.1.1.tgz";
      sha1 = "7a1f551e176a90ecd3345f7246a0cfe175ef4fd0";
    };
    deps = {
      "through2-2.0.3" = self.by-version."through2"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sprintf-js"."^1.0.3" =
    self.by-version."sprintf-js"."1.1.1";
  by-version."sprintf-js"."1.1.1" = self.buildNodePackage {
    name = "sprintf-js-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.1.1.tgz";
      name = "sprintf-js-1.1.1.tgz";
      sha1 = "36be78320afe5801f6cea3ee78b6e5aab940ea0c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sqlite3"."3.1.8" =
    self.by-version."sqlite3"."3.1.8";
  by-version."sqlite3"."3.1.8" = self.buildNodePackage {
    name = "sqlite3-3.1.8";
    version = "3.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sqlite3/-/sqlite3-3.1.8.tgz";
      name = "sqlite3-3.1.8.tgz";
      sha1 = "4cbcf965d8b901d1b1015cbc7fc415aae157dfaa";
    };
    deps = {
      "nan-2.4.0" = self.by-version."nan"."2.4.0";
      "node-pre-gyp-0.6.36" = self.by-version."node-pre-gyp"."0.6.36";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "sqlite3" = self.by-version."sqlite3"."3.1.8";
  by-spec."sshpk"."^1.7.0" =
    self.by-version."sshpk"."1.13.0";
  by-version."sshpk"."1.13.0" = self.buildNodePackage {
    name = "sshpk-1.13.0";
    version = "1.13.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sshpk/-/sshpk-1.13.0.tgz";
      name = "sshpk-1.13.0.tgz";
      sha1 = "ff2a3e4fd04497555fed97b39a0fd82fafb3a33c";
    };
    deps = {
      "asn1-0.2.3" = self.by-version."asn1"."0.2.3";
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
      "dashdash-1.14.1" = self.by-version."dashdash"."1.14.1";
      "getpass-0.1.7" = self.by-version."getpass"."0.1.7";
    };
    optionalDependencies = {
      "jsbn-0.1.1" = self.by-version."jsbn"."0.1.1";
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
      "jodid25519-1.0.2" = self.by-version."jodid25519"."1.0.2";
      "ecc-jsbn-0.1.1" = self.by-version."ecc-jsbn"."0.1.1";
      "bcrypt-pbkdf-1.0.1" = self.by-version."bcrypt-pbkdf"."1.0.1";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."static-eval"."0.2.3" =
    self.by-version."static-eval"."0.2.3";
  by-version."static-eval"."0.2.3" = self.buildNodePackage {
    name = "static-eval-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/static-eval/-/static-eval-0.2.3.tgz";
      name = "static-eval-0.2.3.tgz";
      sha1 = "023f17ac9fee426ea788c12ea39206dc175f8b2a";
    };
    deps = {
      "escodegen-0.0.28" = self.by-version."escodegen"."0.0.28";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."statuses".">= 1.2.1 < 2" =
    self.by-version."statuses"."1.3.1";
  by-version."statuses"."1.3.1" = self.buildNodePackage {
    name = "statuses-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/statuses/-/statuses-1.3.1.tgz";
      name = "statuses-1.3.1.tgz";
      sha1 = "faf51b9eb74aaef3b3acf4ad5f61abf24cb7b93e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."statuses".">= 1.3.1 < 2" =
    self.by-version."statuses"."1.3.1";
  by-spec."statuses"."~1.3.0" =
    self.by-version."statuses"."1.3.1";
  by-spec."statuses"."~1.3.1" =
    self.by-version."statuses"."1.3.1";
  by-spec."streamsearch"."0.1.2" =
    self.by-version."streamsearch"."0.1.2";
  by-version."streamsearch"."0.1.2" = self.buildNodePackage {
    name = "streamsearch-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/streamsearch/-/streamsearch-0.1.2.tgz";
      name = "streamsearch-0.1.2.tgz";
      sha1 = "808b9d0e56fc273d809ba57338e929919a1a9f1a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string-width"."^1.0.1" =
    self.by-version."string-width"."1.0.2";
  by-version."string-width"."1.0.2" = self.buildNodePackage {
    name = "string-width-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz";
      name = "string-width-1.0.2.tgz";
      sha1 = "118bdf5b8cdc51a2a7e70d211e07e2b0b9b107d3";
    };
    deps = {
      "code-point-at-1.1.0" = self.by-version."code-point-at"."1.1.0";
      "is-fullwidth-code-point-1.0.0" = self.by-version."is-fullwidth-code-point"."1.0.0";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string-width"."^1.0.2" =
    self.by-version."string-width"."1.0.2";
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = self.buildNodePackage {
    name = "string_decoder-0.10.31";
    version = "0.10.31";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
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
  by-spec."string_decoder"."~1.0.0" =
    self.by-version."string_decoder"."1.0.1";
  by-version."string_decoder"."1.0.1" = self.buildNodePackage {
    name = "string_decoder-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/string_decoder/-/string_decoder-1.0.1.tgz";
      name = "string_decoder-1.0.1.tgz";
      sha1 = "62e200f039955a6810d8df0a33ffc0f013662d98";
    };
    deps = {
      "safe-buffer-5.1.0" = self.by-version."safe-buffer"."5.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stringstream"."~0.0.4" =
    self.by-version."stringstream"."0.0.5";
  by-version."stringstream"."0.0.5" = self.buildNodePackage {
    name = "stringstream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
      name = "stringstream-0.0.5.tgz";
      sha1 = "4e484cd4de5a0bbbee18e46307710a8a81621878";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^3.0.0" =
    self.by-version."strip-ansi"."3.0.1";
  by-version."strip-ansi"."3.0.1" = self.buildNodePackage {
    name = "strip-ansi-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz";
      name = "strip-ansi-3.0.1.tgz";
      sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
    };
    deps = {
      "ansi-regex-2.1.1" = self.by-version."ansi-regex"."2.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^3.0.1" =
    self.by-version."strip-ansi"."3.0.1";
  by-spec."strip-json-comments"."~2.0.1" =
    self.by-version."strip-json-comments"."2.0.1";
  by-version."strip-json-comments"."2.0.1" = self.buildNodePackage {
    name = "strip-json-comments-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz";
      name = "strip-json-comments-2.0.1.tgz";
      sha1 = "3c531942e908c2697c0ec344858c286c7ca0a60a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."superagent"."3.5.2" =
    self.by-version."superagent"."3.5.2";
  by-version."superagent"."3.5.2" = self.buildNodePackage {
    name = "superagent-3.5.2";
    version = "3.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/superagent/-/superagent-3.5.2.tgz";
      name = "superagent-3.5.2.tgz";
      sha1 = "3361a3971567504c351063abeaae0faa23dbf3f8";
    };
    deps = {
      "component-emitter-1.2.1" = self.by-version."component-emitter"."1.2.1";
      "cookiejar-2.1.1" = self.by-version."cookiejar"."2.1.1";
      "debug-2.6.8" = self.by-version."debug"."2.6.8";
      "extend-3.0.1" = self.by-version."extend"."3.0.1";
      "form-data-2.1.4" = self.by-version."form-data"."2.1.4";
      "formidable-1.1.1" = self.by-version."formidable"."1.1.1";
      "methods-1.1.2" = self.by-version."methods"."1.1.2";
      "mime-1.3.6" = self.by-version."mime"."1.3.6";
      "qs-6.4.0" = self.by-version."qs"."6.4.0";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "superagent" = self.by-version."superagent"."3.5.2";
  by-spec."supports-color"."^2.0.0" =
    self.by-version."supports-color"."2.0.0";
  by-version."supports-color"."2.0.0" = self.buildNodePackage {
    name = "supports-color-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
      name = "supports-color-2.0.0.tgz";
      sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar"."^2.2.1" =
    self.by-version."tar"."2.2.1";
  by-version."tar"."2.2.1" = self.buildNodePackage {
    name = "tar-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar/-/tar-2.2.1.tgz";
      name = "tar-2.2.1.tgz";
      sha1 = "8e4d2a256c0e2185c6b18ad694aec968b83cb1d1";
    };
    deps = {
      "block-stream-0.0.9" = self.by-version."block-stream"."0.0.9";
      "fstream-1.0.11" = self.by-version."fstream"."1.0.11";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-pack"."^3.4.0" =
    self.by-version."tar-pack"."3.4.0";
  by-version."tar-pack"."3.4.0" = self.buildNodePackage {
    name = "tar-pack-3.4.0";
    version = "3.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar-pack/-/tar-pack-3.4.0.tgz";
      name = "tar-pack-3.4.0.tgz";
      sha1 = "23be2d7f671a8339376cbdb0b8fe3fdebf317984";
    };
    deps = {
      "debug-2.6.8" = self.by-version."debug"."2.6.8";
      "fstream-1.0.11" = self.by-version."fstream"."1.0.11";
      "fstream-ignore-1.0.5" = self.by-version."fstream-ignore"."1.0.5";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
      "rimraf-2.6.1" = self.by-version."rimraf"."2.6.1";
      "tar-2.2.1" = self.by-version."tar"."2.2.1";
      "uid-number-0.0.6" = self.by-version."uid-number"."0.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-stream"."^1.5.0" =
    self.by-version."tar-stream"."1.5.4";
  by-version."tar-stream"."1.5.4" = self.buildNodePackage {
    name = "tar-stream-1.5.4";
    version = "1.5.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar-stream/-/tar-stream-1.5.4.tgz";
      name = "tar-stream-1.5.4.tgz";
      sha1 = "36549cf04ed1aee9b2a30c0143252238daf94016";
    };
    deps = {
      "bl-1.2.1" = self.by-version."bl"."1.2.1";
      "end-of-stream-1.4.0" = self.by-version."end-of-stream"."1.4.0";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
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
      url = "https://registry.npmjs.org/through/-/through-2.3.8.tgz";
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
  by-spec."through2"."^2.0.2" =
    self.by-version."through2"."2.0.3";
  by-version."through2"."2.0.3" = self.buildNodePackage {
    name = "through2-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-2.0.3.tgz";
      name = "through2-2.0.3.tgz";
      sha1 = "0004569b37c7c74ba39c43f3ced78d1ad94140be";
    };
    deps = {
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through2"."^2.0.3" =
    self.by-version."through2"."2.0.3";
  by-spec."tildify"."~1.0.0" =
    self.by-version."tildify"."1.0.0";
  by-version."tildify"."1.0.0" = self.buildNodePackage {
    name = "tildify-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tildify/-/tildify-1.0.0.tgz";
      name = "tildify-1.0.0.tgz";
      sha1 = "2a021db5e8fbde0a8f8b4df37adaa8fb1d39d7dd";
    };
    deps = {
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."timespan"."2.3.x" =
    self.by-version."timespan"."2.3.0";
  by-version."timespan"."2.3.0" = self.buildNodePackage {
    name = "timespan-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/timespan/-/timespan-2.3.0.tgz";
      name = "timespan-2.3.0.tgz";
      sha1 = "4902ce040bd13d845c8f59b27e9d59bad6f39929";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie"."~2.3.0" =
    self.by-version."tough-cookie"."2.3.2";
  by-version."tough-cookie"."2.3.2" = self.buildNodePackage {
    name = "tough-cookie-2.3.2";
    version = "2.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.3.2.tgz";
      name = "tough-cookie-2.3.2.tgz";
      sha1 = "f081f76e4c85720e6c37a5faced737150d84072a";
    };
    deps = {
      "punycode-1.4.1" = self.by-version."punycode"."1.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel-agent"."^0.6.0" =
    self.by-version."tunnel-agent"."0.6.0";
  by-version."tunnel-agent"."0.6.0" = self.buildNodePackage {
    name = "tunnel-agent-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
      name = "tunnel-agent-0.6.0.tgz";
      sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
    };
    deps = {
      "safe-buffer-5.1.0" = self.by-version."safe-buffer"."5.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel-agent"."~0.4.1" =
    self.by-version."tunnel-agent"."0.4.3";
  by-version."tunnel-agent"."0.4.3" = self.buildNodePackage {
    name = "tunnel-agent-0.4.3";
    version = "0.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.3.tgz";
      name = "tunnel-agent-0.4.3.tgz";
      sha1 = "6373db76909fe570e08d73583365ed828a74eeeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."^0.14.3" =
    self.by-version."tweetnacl"."0.14.5";
  by-version."tweetnacl"."0.14.5" = self.buildNodePackage {
    name = "tweetnacl-0.14.5";
    version = "0.14.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz";
      name = "tweetnacl-0.14.5.tgz";
      sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."~0.14.0" =
    self.by-version."tweetnacl"."0.14.5";
  by-spec."type-detect"."0.1.1" =
    self.by-version."type-detect"."0.1.1";
  by-version."type-detect"."0.1.1" = self.buildNodePackage {
    name = "type-detect-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/type-detect/-/type-detect-0.1.1.tgz";
      name = "type-detect-0.1.1.tgz";
      sha1 = "0ba5ec2a885640e470ea4e8505971900dac58822";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-detect"."^1.0.0" =
    self.by-version."type-detect"."1.0.0";
  by-version."type-detect"."1.0.0" = self.buildNodePackage {
    name = "type-detect-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/type-detect/-/type-detect-1.0.0.tgz";
      name = "type-detect-1.0.0.tgz";
      sha1 = "762217cc06db258ec48908a1298e8b95121e8ea2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."^1.6.4" =
    self.by-version."type-is"."1.6.15";
  by-version."type-is"."1.6.15" = self.buildNodePackage {
    name = "type-is-1.6.15";
    version = "1.6.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/type-is/-/type-is-1.6.15.tgz";
      name = "type-is-1.6.15.tgz";
      sha1 = "cab10fb4909e441c82842eafe1ad646c81804410";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.1.15" = self.by-version."mime-types"."2.1.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."~1.6.13" =
    self.by-version."type-is"."1.6.15";
  by-spec."type-is"."~1.6.14" =
    self.by-version."type-is"."1.6.15";
  by-spec."typedarray"."^0.0.6" =
    self.by-version."typedarray"."0.0.6";
  by-version."typedarray"."0.0.6" = self.buildNodePackage {
    name = "typedarray-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
      name = "typedarray-0.0.6.tgz";
      sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typedarray"."~0.0.5" =
    self.by-version."typedarray"."0.0.6";
  by-spec."uglify-js"."^2.6" =
    self.by-version."uglify-js"."2.8.28";
  by-version."uglify-js"."2.8.28" = self.buildNodePackage {
    name = "uglify-js-2.8.28";
    version = "2.8.28";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/uglify-js/-/uglify-js-2.8.28.tgz";
      name = "uglify-js-2.8.28.tgz";
      sha1 = "e335032df9bb20dcb918f164589d5af47f38834a";
    };
    deps = {
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
      "yargs-3.10.0" = self.by-version."yargs"."3.10.0";
    };
    optionalDependencies = {
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uglify-to-browserify"."~1.0.0" =
    self.by-version."uglify-to-browserify"."1.0.2";
  by-version."uglify-to-browserify"."1.0.2" = self.buildNodePackage {
    name = "uglify-to-browserify-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
      name = "uglify-to-browserify-1.0.2.tgz";
      sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uid-number"."^0.0.6" =
    self.by-version."uid-number"."0.0.6";
  by-version."uid-number"."0.0.6" = self.buildNodePackage {
    name = "uid-number-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/uid-number/-/uid-number-0.0.6.tgz";
      name = "uid-number-0.0.6.tgz";
      sha1 = "0ea10e8035e8eb5b8e4449f06da1c730663baa81";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uid2"."0.0.x" =
    self.by-version."uid2"."0.0.3";
  by-version."uid2"."0.0.3" = self.buildNodePackage {
    name = "uid2-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/uid2/-/uid2-0.0.3.tgz";
      name = "uid2-0.0.3.tgz";
      sha1 = "483126e11774df2f71b8b639dcd799c376162b82";
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
      url = "https://registry.npmjs.org/underscore/-/underscore-1.8.3.tgz";
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
  by-spec."underscore"."1.1.x" =
    self.by-version."underscore"."1.1.7";
  by-version."underscore"."1.1.7" = self.buildNodePackage {
    name = "underscore-1.1.7";
    version = "1.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore/-/underscore-1.1.7.tgz";
      name = "underscore-1.1.7.tgz";
      sha1 = "40bab84bad19d230096e8d6ef628bff055d83db0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."1.7.0" =
    self.by-version."underscore"."1.7.0";
  by-version."underscore"."1.7.0" = self.buildNodePackage {
    name = "underscore-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore/-/underscore-1.7.0.tgz";
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
  by-spec."underscore"."^1.8.3" =
    self.by-version."underscore"."1.8.3";
  by-spec."underscore.string"."^3.2.3" =
    self.by-version."underscore.string"."3.3.4";
  by-version."underscore.string"."3.3.4" = self.buildNodePackage {
    name = "underscore.string-3.3.4";
    version = "3.3.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore.string/-/underscore.string-3.3.4.tgz";
      name = "underscore.string-3.3.4.tgz";
      sha1 = "2c2a3f9f83e64762fdc45e6ceac65142864213db";
    };
    deps = {
      "sprintf-js-1.1.1" = self.by-version."sprintf-js"."1.1.1";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unidecode"."0.1.8" =
    self.by-version."unidecode"."0.1.8";
  by-version."unidecode"."0.1.8" = self.buildNodePackage {
    name = "unidecode-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unidecode/-/unidecode-0.1.8.tgz";
      name = "unidecode-0.1.8.tgz";
      sha1 = "efbb301538bc45246a9ac8c559d72f015305053e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "unidecode" = self.by-version."unidecode"."0.1.8";
  by-spec."unpipe"."1.0.0" =
    self.by-version."unpipe"."1.0.0";
  by-version."unpipe"."1.0.0" = self.buildNodePackage {
    name = "unpipe-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz";
      name = "unpipe-1.0.0.tgz";
      sha1 = "b2bf4ee8514aae6165b4817829d21b2ef49904ec";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unpipe"."~1.0.0" =
    self.by-version."unpipe"."1.0.0";
  by-spec."user-home"."^1.0.0" =
    self.by-version."user-home"."1.1.1";
  by-version."user-home"."1.1.1" = self.buildNodePackage {
    name = "user-home-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/user-home/-/user-home-1.1.1.tgz";
      name = "user-home-1.1.1.tgz";
      sha1 = "2b5be23a32b63a7c9deb8d0f28d485724a3df190";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."user-home"."^1.1.1" =
    self.by-version."user-home"."1.1.1";
  by-spec."util-deprecate"."^1.0.2" =
    self.by-version."util-deprecate"."1.0.2";
  by-version."util-deprecate"."1.0.2" = self.buildNodePackage {
    name = "util-deprecate-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
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
  by-spec."util-deprecate"."~1.0.1" =
    self.by-version."util-deprecate"."1.0.2";
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = self.buildNodePackage {
    name = "utils-merge-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
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
  by-spec."utils-merge"."1.x.x" =
    self.by-version."utils-merge"."1.0.0";
  by-spec."uuid"."3.0.0" =
    self.by-version."uuid"."3.0.0";
  by-version."uuid"."3.0.0" = self.buildNodePackage {
    name = "uuid-3.0.0";
    version = "3.0.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/uuid/-/uuid-3.0.0.tgz";
      name = "uuid-3.0.0.tgz";
      sha1 = "6728fc0459c450d796a99c31837569bdf672d728";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "uuid" = self.by-version."uuid"."3.0.0";
  by-spec."uuid"."^3.0.0" =
    self.by-version."uuid"."3.0.1";
  by-version."uuid"."3.0.1" = self.buildNodePackage {
    name = "uuid-3.0.1";
    version = "3.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/uuid/-/uuid-3.0.1.tgz";
      name = "uuid-3.0.1.tgz";
      sha1 = "6544bba2dfda8c1cf17e629a3a305e2bb1fee6c1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."v8flags"."^2.0.2" =
    self.by-version."v8flags"."2.1.1";
  by-version."v8flags"."2.1.1" = self.buildNodePackage {
    name = "v8flags-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/v8flags/-/v8flags-2.1.1.tgz";
      name = "v8flags-2.1.1.tgz";
      sha1 = "aab1a1fa30d45f88dd321148875ac02c0b55e5b4";
    };
    deps = {
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."validator"."6.3.0" =
    self.by-version."validator"."6.3.0";
  by-version."validator"."6.3.0" = self.buildNodePackage {
    name = "validator-6.3.0";
    version = "6.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/validator/-/validator-6.3.0.tgz";
      name = "validator-6.3.0.tgz";
      sha1 = "47ce23ed8d4eaddfa9d4b8ef0071b6cf1078d7c8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "validator" = self.by-version."validator"."6.3.0";
  by-spec."vary"."^1" =
    self.by-version."vary"."1.1.1";
  by-version."vary"."1.1.1" = self.buildNodePackage {
    name = "vary-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vary/-/vary-1.1.1.tgz";
      name = "vary-1.1.1.tgz";
      sha1 = "67535ebb694c1d52257457984665323f587e8d37";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vary"."~1.1.0" =
    self.by-version."vary"."1.1.1";
  by-spec."verror"."1.3.6" =
    self.by-version."verror"."1.3.6";
  by-version."verror"."1.3.6" = self.buildNodePackage {
    name = "verror-1.3.6";
    version = "1.3.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
      name = "verror-1.3.6.tgz";
      sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
    };
    deps = {
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."walkdir"."^0.0.11" =
    self.by-version."walkdir"."0.0.11";
  by-version."walkdir"."0.0.11" = self.buildNodePackage {
    name = "walkdir-0.0.11";
    version = "0.0.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/walkdir/-/walkdir-0.0.11.tgz";
      name = "walkdir-0.0.11.tgz";
      sha1 = "a16d025eb931bd03b52f308caed0f40fcebe9532";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."which"."^1.2.12" =
    self.by-version."which"."1.2.14";
  by-version."which"."1.2.14" = self.buildNodePackage {
    name = "which-1.2.14";
    version = "1.2.14";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/which/-/which-1.2.14.tgz";
      name = "which-1.2.14.tgz";
      sha1 = "9a87c4378f03e827cecaf1acdf56c736c01c14e5";
    };
    deps = {
      "isexe-2.0.0" = self.by-version."isexe"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wide-align"."^1.1.0" =
    self.by-version."wide-align"."1.1.2";
  by-version."wide-align"."1.1.2" = self.buildNodePackage {
    name = "wide-align-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wide-align/-/wide-align-1.1.2.tgz";
      name = "wide-align-1.1.2.tgz";
      sha1 = "571e0f1b0604636ebc0dfc21b0339bbe31341710";
    };
    deps = {
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."window-size"."0.1.0" =
    self.by-version."window-size"."0.1.0";
  by-version."window-size"."0.1.0" = self.buildNodePackage {
    name = "window-size-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz";
      name = "window-size-0.1.0.tgz";
      sha1 = "5438cd2ea93b202efa3a19fe8887aee7c94f9c9d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."window-size"."^0.1.4" =
    self.by-version."window-size"."0.1.4";
  by-version."window-size"."0.1.4" = self.buildNodePackage {
    name = "window-size-0.1.4";
    version = "0.1.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/window-size/-/window-size-0.1.4.tgz";
      name = "window-size-0.1.4.tgz";
      sha1 = "f8e1aa1ee5a53ec5bf151ffa09742a6ad7697876";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap"."0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = self.buildNodePackage {
    name = "wordwrap-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
      name = "wordwrap-0.0.2.tgz";
      sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
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
      url = "https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz";
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
  by-spec."wrap-ansi"."^2.0.0" =
    self.by-version."wrap-ansi"."2.1.0";
  by-version."wrap-ansi"."2.1.0" = self.buildNodePackage {
    name = "wrap-ansi-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-2.1.0.tgz";
      name = "wrap-ansi-2.1.0.tgz";
      sha1 = "d8fc3d284dd05794fe84973caecdd1cf824fdd85";
    };
    deps = {
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.2";
  by-version."wrappy"."1.0.2" = self.buildNodePackage {
    name = "wrappy-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
      name = "wrappy-1.0.2.tgz";
      sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xml"."1.0.1" =
    self.by-version."xml"."1.0.1";
  by-version."xml"."1.0.1" = self.buildNodePackage {
    name = "xml-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xml/-/xml-1.0.1.tgz";
      name = "xml-1.0.1.tgz";
      sha1 = "78ba72020029c5bc87b8a81a3cfcd74b4a2fc1e5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "xml" = self.by-version."xml"."1.0.1";
  by-spec."xml2js"."0.2.6" =
    self.by-version."xml2js"."0.2.6";
  by-version."xml2js"."0.2.6" = self.buildNodePackage {
    name = "xml2js-0.2.6";
    version = "0.2.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xml2js/-/xml2js-0.2.6.tgz";
      name = "xml2js-0.2.6.tgz";
      sha1 = "d209c4e4dda1fc9c452141ef41c077f5adfdf6c4";
    };
    deps = {
      "sax-0.4.2" = self.by-version."sax"."0.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xmlbuilder"."0.4.2" =
    self.by-version."xmlbuilder"."0.4.2";
  by-version."xmlbuilder"."0.4.2" = self.buildNodePackage {
    name = "xmlbuilder-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.2.tgz";
      name = "xmlbuilder-0.4.2.tgz";
      sha1 = "1776d65f3fdbad470a08d8604cdeb1c4e540ff83";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xoauth2"."~0.1.8" =
    self.by-version."xoauth2"."0.1.8";
  by-version."xoauth2"."0.1.8" = self.buildNodePackage {
    name = "xoauth2-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xoauth2/-/xoauth2-0.1.8.tgz";
      name = "xoauth2-0.1.8.tgz";
      sha1 = "b916ff10ecfb54320f16f24a3e975120653ab0d2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xregexp"."2.0.0" =
    self.by-version."xregexp"."2.0.0";
  by-version."xregexp"."2.0.0" = self.buildNodePackage {
    name = "xregexp-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xregexp/-/xregexp-2.0.0.tgz";
      name = "xregexp-2.0.0.tgz";
      sha1 = "52a63e56ca0b84a7f3a5f3d61872f126ad7a5943";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."^4.0.0" =
    self.by-version."xtend"."4.0.1";
  by-version."xtend"."4.0.1" = self.buildNodePackage {
    name = "xtend-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
      name = "xtend-4.0.1.tgz";
      sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."~4.0.1" =
    self.by-version."xtend"."4.0.1";
  by-spec."y18n"."^3.2.0" =
    self.by-version."y18n"."3.2.1";
  by-version."y18n"."3.2.1" = self.buildNodePackage {
    name = "y18n-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/y18n/-/y18n-3.2.1.tgz";
      name = "y18n-3.2.1.tgz";
      sha1 = "6d15fba884c08679c0d77e88e7759e811e07fa41";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."yallist"."^2.0.0" =
    self.by-version."yallist"."2.1.2";
  by-version."yallist"."2.1.2" = self.buildNodePackage {
    name = "yallist-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/yallist/-/yallist-2.1.2.tgz";
      name = "yallist-2.1.2.tgz";
      sha1 = "1c11f9218f076089a47dd512f93c6699a6a81d52";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."yargs"."^3.19.0" =
    self.by-version."yargs"."3.32.0";
  by-version."yargs"."3.32.0" = self.buildNodePackage {
    name = "yargs-3.32.0";
    version = "3.32.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/yargs/-/yargs-3.32.0.tgz";
      name = "yargs-3.32.0.tgz";
      sha1 = "03088e9ebf9e756b69751611d2a5ef591482c995";
    };
    deps = {
      "camelcase-2.1.1" = self.by-version."camelcase"."2.1.1";
      "cliui-3.2.0" = self.by-version."cliui"."3.2.0";
      "decamelize-1.2.0" = self.by-version."decamelize"."1.2.0";
      "os-locale-1.4.0" = self.by-version."os-locale"."1.4.0";
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
      "window-size-0.1.4" = self.by-version."window-size"."0.1.4";
      "y18n-3.2.1" = self.by-version."y18n"."3.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."yargs"."~3.10.0" =
    self.by-version."yargs"."3.10.0";
  by-version."yargs"."3.10.0" = self.buildNodePackage {
    name = "yargs-3.10.0";
    version = "3.10.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/yargs/-/yargs-3.10.0.tgz";
      name = "yargs-3.10.0.tgz";
      sha1 = "f7ee7bd857dd7c1d2d38c0e74efbd681d1431fd1";
    };
    deps = {
      "camelcase-1.2.1" = self.by-version."camelcase"."1.2.1";
      "cliui-2.1.0" = self.by-version."cliui"."2.1.0";
      "decamelize-1.2.0" = self.by-version."decamelize"."1.2.0";
      "window-size-0.1.0" = self.by-version."window-size"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."yauzl"."2.4.1" =
    self.by-version."yauzl"."2.4.1";
  by-version."yauzl"."2.4.1" = self.buildNodePackage {
    name = "yauzl-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/yauzl/-/yauzl-2.4.1.tgz";
      name = "yauzl-2.4.1.tgz";
      sha1 = "9528f442dab1b2284e58b4379bb194e22e0c4005";
    };
    deps = {
      "fd-slicer-1.0.1" = self.by-version."fd-slicer"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."zip-stream"."^1.1.0" =
    self.by-version."zip-stream"."1.1.1";
  by-version."zip-stream"."1.1.1" = self.buildNodePackage {
    name = "zip-stream-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/zip-stream/-/zip-stream-1.1.1.tgz";
      name = "zip-stream-1.1.1.tgz";
      sha1 = "5216b48bbb4d2651f64d5c6e6f09eb4a7399d557";
    };
    deps = {
      "archiver-utils-1.3.0" = self.by-version."archiver-utils"."1.3.0";
      "compress-commons-1.2.0" = self.by-version."compress-commons"."1.2.0";
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
      "readable-stream-2.2.10" = self.by-version."readable-stream"."2.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
