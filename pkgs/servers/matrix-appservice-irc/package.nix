{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."Base64"."~0.2.0" =
    self.by-version."Base64"."0.2.1";
  by-version."Base64"."0.2.1" = self.buildNodePackage {
    name = "Base64-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/Base64/-/Base64-0.2.1.tgz";
      name = "Base64-0.2.1.tgz";
      sha1 = "ba3a4230708e186705065e66babdd4c35cf60028";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."JSONStream"."^1.0.3" =
    self.by-version."JSONStream"."1.1.3";
  by-version."JSONStream"."1.1.3" = self.buildNodePackage {
    name = "JSONStream-1.1.3";
    version = "1.1.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/JSONStream/-/JSONStream-1.1.3.tgz";
      name = "JSONStream-1.1.3.tgz";
      sha1 = "1b296c7949b47e4fc22ac7958f76d2fbe2415493";
    };
    deps = {
      "jsonparse-1.2.0" = self.by-version."jsonparse"."1.2.0";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.0.9";
  by-version."abbrev"."1.0.9" = self.buildNodePackage {
    name = "abbrev-1.0.9";
    version = "1.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abbrev/-/abbrev-1.0.9.tgz";
      name = "abbrev-1.0.9.tgz";
      sha1 = "91b4792588a7738c25f35dd6f63752a2f8776135";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abbrev"."1.0.x" =
    self.by-version."abbrev"."1.0.9";
  by-spec."accepts"."~1.2.7" =
    self.by-version."accepts"."1.2.13";
  by-version."accepts"."1.2.13" = self.buildNodePackage {
    name = "accepts-1.2.13";
    version = "1.2.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/accepts/-/accepts-1.2.13.tgz";
      name = "accepts-1.2.13.tgz";
      sha1 = "e5f1f3928c6d95fd96558c36ec3d9d0de4a6ecea";
    };
    deps = {
      "mime-types-2.1.11" = self.by-version."mime-types"."2.1.11";
      "negotiator-0.5.3" = self.by-version."negotiator"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."acorn"."^1.0.3" =
    self.by-version."acorn"."1.2.2";
  by-version."acorn"."1.2.2" = self.buildNodePackage {
    name = "acorn-1.2.2";
    version = "1.2.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/acorn/-/acorn-1.2.2.tgz";
      name = "acorn-1.2.2.tgz";
      sha1 = "c8ce27de0acc76d896d2b1fad3df588d9e82f014";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."acorn"."^2.7.0" =
    self.by-version."acorn"."2.7.0";
  by-version."acorn"."2.7.0" = self.buildNodePackage {
    name = "acorn-2.7.0";
    version = "2.7.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/acorn/-/acorn-2.7.0.tgz";
      name = "acorn-2.7.0.tgz";
      sha1 = "ab6e7d9d886aaca8b085bc3312b79a198433f0e7";
    };
    deps = {
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
      "kind-of-3.0.3" = self.by-version."kind-of"."3.0.3";
      "longest-1.0.1" = self.by-version."longest"."1.0.1";
      "repeat-string-1.5.4" = self.by-version."repeat-string"."1.5.4";
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
    self.by-version."amdefine"."1.0.0";
  by-version."amdefine"."1.0.0" = self.buildNodePackage {
    name = "amdefine-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/amdefine/-/amdefine-1.0.0.tgz";
      name = "amdefine-1.0.0.tgz";
      sha1 = "fd17474700cb5cc9c2b709f0be9d23ce3c198c33";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-escapes"."^1.1.0" =
    self.by-version."ansi-escapes"."1.4.0";
  by-version."ansi-escapes"."1.4.0" = self.buildNodePackage {
    name = "ansi-escapes-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-1.4.0.tgz";
      name = "ansi-escapes-1.4.0.tgz";
      sha1 = "d3a8a83b319aa67793662b13e761c7911422306e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^2.0.0" =
    self.by-version."ansi-regex"."2.0.0";
  by-version."ansi-regex"."2.0.0" = self.buildNodePackage {
    name = "ansi-regex-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
      name = "ansi-regex-2.0.0.tgz";
      sha1 = "c5061b6e0ef8a81775e50f5d66151bf6bf371107";
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
  by-spec."argparse"."^1.0.2" =
    self.by-version."argparse"."1.0.7";
  by-version."argparse"."1.0.7" = self.buildNodePackage {
    name = "argparse-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/argparse/-/argparse-1.0.7.tgz";
      name = "argparse-1.0.7.tgz";
      sha1 = "c289506480557810f14a8bc62d7a06f63ed7f951";
    };
    deps = {
      "sprintf-js-1.0.3" = self.by-version."sprintf-js"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."argparse"."^1.0.7" =
    self.by-version."argparse"."1.0.7";
  by-spec."array-union"."^1.0.1" =
    self.by-version."array-union"."1.0.2";
  by-version."array-union"."1.0.2" = self.buildNodePackage {
    name = "array-union-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz";
      name = "array-union-1.0.2.tgz";
      sha1 = "9a34410e4f4e3da23dea375be5be70f24778ec39";
    };
    deps = {
      "array-uniq-1.0.3" = self.by-version."array-uniq"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-uniq"."^1.0.1" =
    self.by-version."array-uniq"."1.0.3";
  by-version."array-uniq"."1.0.3" = self.buildNodePackage {
    name = "array-uniq-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz";
      name = "array-uniq-1.0.3.tgz";
      sha1 = "af6ac877a25cc7f74e058894753858dfdb24fdb6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arrify"."^1.0.0" =
    self.by-version."arrify"."1.0.1";
  by-version."arrify"."1.0.1" = self.buildNodePackage {
    name = "arrify-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz";
      name = "arrify-1.0.1.tgz";
      sha1 = "898508da2226f380df904728456849c1501a4b0d";
    };
    deps = {
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
      url = "https://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
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
  by-spec."asn1.js"."^4.0.0" =
    self.by-version."asn1.js"."4.8.0";
  by-version."asn1.js"."4.8.0" = self.buildNodePackage {
    name = "asn1.js-4.8.0";
    version = "4.8.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/asn1.js/-/asn1.js-4.8.0.tgz";
      name = "asn1.js-4.8.0.tgz";
      sha1 = "e0e04e9923319163be46aed9e5378973b161ef13";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimalistic-assert-1.0.0" = self.by-version."minimalistic-assert"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert"."~1.3.0" =
    self.by-version."assert"."1.3.0";
  by-version."assert"."1.3.0" = self.buildNodePackage {
    name = "assert-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/assert/-/assert-1.3.0.tgz";
      name = "assert-1.3.0.tgz";
      sha1 = "03939a622582a812cc202320a0b9a56c9b815849";
    };
    deps = {
      "util-0.10.3" = self.by-version."util"."0.10.3";
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
      url = "https://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
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
  by-spec."ast-types"."0.8.15" =
    self.by-version."ast-types"."0.8.15";
  by-version."ast-types"."0.8.15" = self.buildNodePackage {
    name = "ast-types-0.8.15";
    version = "0.8.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ast-types/-/ast-types-0.8.15.tgz";
      name = "ast-types-0.8.15.tgz";
      sha1 = "8eef0827f04dff0ec8857ba925abe3fea6194e52";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."astw"."^2.0.0" =
    self.by-version."astw"."2.0.0";
  by-version."astw"."2.0.0" = self.buildNodePackage {
    name = "astw-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/astw/-/astw-2.0.0.tgz";
      name = "astw-2.0.0.tgz";
      sha1 = "08121ac8288d35611c0ceec663f6cd545604897d";
    };
    deps = {
      "acorn-1.2.2" = self.by-version."acorn"."1.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."0.2.10" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = self.buildNodePackage {
    name = "async-0.2.10";
    version = "0.2.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-0.2.10.tgz";
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
      url = "https://registry.npmjs.org/async/-/async-0.9.2.tgz";
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
  by-spec."async"."1.x" =
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
  by-spec."async"."^1.4.0" =
    self.by-version."async"."1.5.2";
  by-spec."async"."^1.5.2" =
    self.by-version."async"."1.5.2";
  by-spec."async"."~0.2.6" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.2";
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = self.buildNodePackage {
    name = "aws-sign2-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
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
    self.by-version."aws4"."1.4.1";
  by-version."aws4"."1.4.1" = self.buildNodePackage {
    name = "aws4-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws4/-/aws4-1.4.1.tgz";
      name = "aws4-1.4.1.tgz";
      sha1 = "fde7d5292466d230e5ee0f4e038d9dfaab08fc61";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."base62"."0.1.1" =
    self.by-version."base62"."0.1.1";
  by-version."base62"."0.1.1" = self.buildNodePackage {
    name = "base62-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/base62/-/base62-0.1.1.tgz";
      name = "base62-0.1.1.tgz";
      sha1 = "7b4174c2f94449753b11c2651c083da841a7b084";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64-js"."0.0.8" =
    self.by-version."base64-js"."0.0.8";
  by-version."base64-js"."0.0.8" = self.buildNodePackage {
    name = "base64-js-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/base64-js/-/base64-js-0.0.8.tgz";
      name = "base64-js-0.0.8.tgz";
      sha1 = "1101e9544f4a76b1bc3b26d452ca96d7a35e7978";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."basic-auth"."~1.0.1" =
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
  by-spec."binary-search-tree"."0.2.5" =
    self.by-version."binary-search-tree"."0.2.5";
  by-version."binary-search-tree"."0.2.5" = self.buildNodePackage {
    name = "binary-search-tree-0.2.5";
    version = "0.2.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/binary-search-tree/-/binary-search-tree-0.2.5.tgz";
      name = "binary-search-tree-0.2.5.tgz";
      sha1 = "7dbb3b210fdca082450dad2334c304af39bdc784";
    };
    deps = {
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."~0.9.0" =
    self.by-version."bl"."0.9.5";
  by-version."bl"."0.9.5" = self.buildNodePackage {
    name = "bl-0.9.5";
    version = "0.9.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bl/-/bl-0.9.5.tgz";
      name = "bl-0.9.5.tgz";
      sha1 = "c06b797af085ea00bc527afc8efcf11de2232054";
    };
    deps = {
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."bluebird"."^2.9.34" =
    self.by-version."bluebird"."2.10.2";
  by-version."bluebird"."2.10.2" = self.buildNodePackage {
    name = "bluebird-2.10.2";
    version = "2.10.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bluebird/-/bluebird-2.10.2.tgz";
      name = "bluebird-2.10.2.tgz";
      sha1 = "024a5517295308857f14f91f1106fc3b555f446b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."^3.1.1" =
    self.by-version."bluebird"."3.4.1";
  by-version."bluebird"."3.4.1" = self.buildNodePackage {
    name = "bluebird-3.4.1";
    version = "3.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bluebird/-/bluebird-3.4.1.tgz";
      name = "bluebird-3.4.1.tgz";
      sha1 = "b731ddf48e2dd3bedac2e75e1215a11bcb91fa07";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bluebird" = self.by-version."bluebird"."3.4.1";
  by-spec."bn.js"."^4.0.0" =
    self.by-version."bn.js"."4.11.5";
  by-version."bn.js"."4.11.5" = self.buildNodePackage {
    name = "bn.js-4.11.5";
    version = "4.11.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bn.js/-/bn.js-4.11.5.tgz";
      name = "bn.js-4.11.5.tgz";
      sha1 = "d4572591b6bf70ef60f76790d6c2e92d8979350a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bn.js"."^4.1.0" =
    self.by-version."bn.js"."4.11.5";
  by-spec."bn.js"."^4.1.1" =
    self.by-version."bn.js"."4.11.5";
  by-spec."bn.js"."^4.4.0" =
    self.by-version."bn.js"."4.11.5";
  by-spec."body-parser"."~1.12.0" =
    self.by-version."body-parser"."1.12.4";
  by-version."body-parser"."1.12.4" = self.buildNodePackage {
    name = "body-parser-1.12.4";
    version = "1.12.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/body-parser/-/body-parser-1.12.4.tgz";
      name = "body-parser-1.12.4.tgz";
      sha1 = "090700c4ba28862a8520ef378395fdee5f61c229";
    };
    deps = {
      "bytes-1.0.0" = self.by-version."bytes"."1.0.0";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "iconv-lite-0.4.8" = self.by-version."iconv-lite"."0.4.8";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "qs-2.4.2" = self.by-version."qs"."2.4.2";
      "raw-body-2.0.2" = self.by-version."raw-body"."2.0.2";
      "type-is-1.6.13" = self.by-version."type-is"."1.6.13";
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
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.5";
  by-version."brace-expansion"."1.1.5" = self.buildNodePackage {
    name = "brace-expansion-1.1.5";
    version = "1.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.5.tgz";
      name = "brace-expansion-1.1.5.tgz";
      sha1 = "f5b4ad574e2cb7ccc1eb83e6fe79b8ecadf7a526";
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
  by-spec."brorand"."^1.0.1" =
    self.by-version."brorand"."1.0.5";
  by-version."brorand"."1.0.5" = self.buildNodePackage {
    name = "brorand-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/brorand/-/brorand-1.0.5.tgz";
      name = "brorand-1.0.5.tgz";
      sha1 = "07b54ca30286abd1718a0e2a830803efdc9bfa04";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browser-pack"."^5.0.0" =
    self.by-version."browser-pack"."5.0.1";
  by-version."browser-pack"."5.0.1" = self.buildNodePackage {
    name = "browser-pack-5.0.1";
    version = "5.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/browser-pack/-/browser-pack-5.0.1.tgz";
      name = "browser-pack-5.0.1.tgz";
      sha1 = "4197719b20c6e0aaa09451c5111e53efb6fbc18d";
    };
    deps = {
      "JSONStream-1.1.3" = self.by-version."JSONStream"."1.1.3";
      "combine-source-map-0.6.1" = self.by-version."combine-source-map"."0.6.1";
      "defined-1.0.0" = self.by-version."defined"."1.0.0";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "umd-3.0.1" = self.by-version."umd"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browser-request"."^0.3.3" =
    self.by-version."browser-request"."0.3.3";
  by-version."browser-request"."0.3.3" = self.buildNodePackage {
    name = "browser-request-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browser-request/-/browser-request-0.3.3.tgz";
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
  by-spec."browser-resolve"."^1.7.0" =
    self.by-version."browser-resolve"."1.11.2";
  by-version."browser-resolve"."1.11.2" = self.buildNodePackage {
    name = "browser-resolve-1.11.2";
    version = "1.11.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browser-resolve/-/browser-resolve-1.11.2.tgz";
      name = "browser-resolve-1.11.2.tgz";
      sha1 = "8ff09b0a2c421718a1051c260b32e48f442938ce";
    };
    deps = {
      "resolve-1.1.7" = self.by-version."resolve"."1.1.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browser-resolve"."^1.7.1" =
    self.by-version."browser-resolve"."1.11.2";
  by-spec."browserify"."^10.2.3" =
    self.by-version."browserify"."10.2.6";
  by-version."browserify"."10.2.6" = self.buildNodePackage {
    name = "browserify-10.2.6";
    version = "10.2.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify/-/browserify-10.2.6.tgz";
      name = "browserify-10.2.6.tgz";
      sha1 = "dcbfef794f548f5f8498214814f697a5c50c0896";
    };
    deps = {
      "JSONStream-1.1.3" = self.by-version."JSONStream"."1.1.3";
      "assert-1.3.0" = self.by-version."assert"."1.3.0";
      "browser-pack-5.0.1" = self.by-version."browser-pack"."5.0.1";
      "browser-resolve-1.11.2" = self.by-version."browser-resolve"."1.11.2";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
      "buffer-3.6.0" = self.by-version."buffer"."3.6.0";
      "builtins-0.0.7" = self.by-version."builtins"."0.0.7";
      "commondir-0.0.1" = self.by-version."commondir"."0.0.1";
      "concat-stream-1.4.10" = self.by-version."concat-stream"."1.4.10";
      "console-browserify-1.1.0" = self.by-version."console-browserify"."1.1.0";
      "constants-browserify-0.0.1" = self.by-version."constants-browserify"."0.0.1";
      "crypto-browserify-3.11.0" = self.by-version."crypto-browserify"."3.11.0";
      "defined-1.0.0" = self.by-version."defined"."1.0.0";
      "deps-sort-1.3.9" = self.by-version."deps-sort"."1.3.9";
      "domain-browser-1.1.7" = self.by-version."domain-browser"."1.1.7";
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "events-1.0.2" = self.by-version."events"."1.0.2";
      "glob-4.5.3" = self.by-version."glob"."4.5.3";
      "has-1.0.1" = self.by-version."has"."1.0.1";
      "htmlescape-1.1.1" = self.by-version."htmlescape"."1.1.1";
      "http-browserify-1.7.0" = self.by-version."http-browserify"."1.7.0";
      "https-browserify-0.0.1" = self.by-version."https-browserify"."0.0.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "insert-module-globals-6.6.3" = self.by-version."insert-module-globals"."6.6.3";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "labeled-stream-splicer-1.0.2" = self.by-version."labeled-stream-splicer"."1.0.2";
      "module-deps-3.9.1" = self.by-version."module-deps"."3.9.1";
      "os-browserify-0.1.2" = self.by-version."os-browserify"."0.1.2";
      "parents-1.0.1" = self.by-version."parents"."1.0.1";
      "path-browserify-0.0.0" = self.by-version."path-browserify"."0.0.0";
      "process-0.11.5" = self.by-version."process"."0.11.5";
      "punycode-1.4.1" = self.by-version."punycode"."1.4.1";
      "querystring-es3-0.2.1" = self.by-version."querystring-es3"."0.2.1";
      "read-only-stream-1.1.1" = self.by-version."read-only-stream"."1.1.1";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "resolve-1.1.7" = self.by-version."resolve"."1.1.7";
      "shasum-1.0.2" = self.by-version."shasum"."1.0.2";
      "shell-quote-0.0.1" = self.by-version."shell-quote"."0.0.1";
      "stream-browserify-1.0.0" = self.by-version."stream-browserify"."1.0.0";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "subarg-1.0.0" = self.by-version."subarg"."1.0.0";
      "syntax-error-1.1.6" = self.by-version."syntax-error"."1.1.6";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "timers-browserify-1.4.2" = self.by-version."timers-browserify"."1.4.2";
      "tty-browserify-0.0.0" = self.by-version."tty-browserify"."0.0.0";
      "url-0.10.3" = self.by-version."url"."0.10.3";
      "util-0.10.3" = self.by-version."util"."0.10.3";
      "vm-browserify-0.0.4" = self.by-version."vm-browserify"."0.0.4";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-aes"."^1.0.0" =
    self.by-version."browserify-aes"."1.0.6";
  by-version."browserify-aes"."1.0.6" = self.buildNodePackage {
    name = "browserify-aes-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify-aes/-/browserify-aes-1.0.6.tgz";
      name = "browserify-aes-1.0.6.tgz";
      sha1 = "5e7725dbdef1fd5930d4ebab48567ce451c48a0a";
    };
    deps = {
      "buffer-xor-1.0.3" = self.by-version."buffer-xor"."1.0.3";
      "cipher-base-1.0.2" = self.by-version."cipher-base"."1.0.2";
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
      "evp_bytestokey-1.0.0" = self.by-version."evp_bytestokey"."1.0.0";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-aes"."^1.0.4" =
    self.by-version."browserify-aes"."1.0.6";
  by-spec."browserify-cipher"."^1.0.0" =
    self.by-version."browserify-cipher"."1.0.0";
  by-version."browserify-cipher"."1.0.0" = self.buildNodePackage {
    name = "browserify-cipher-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify-cipher/-/browserify-cipher-1.0.0.tgz";
      name = "browserify-cipher-1.0.0.tgz";
      sha1 = "9988244874bf5ed4e28da95666dcd66ac8fc363a";
    };
    deps = {
      "browserify-aes-1.0.6" = self.by-version."browserify-aes"."1.0.6";
      "browserify-des-1.0.0" = self.by-version."browserify-des"."1.0.0";
      "evp_bytestokey-1.0.0" = self.by-version."evp_bytestokey"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-des"."^1.0.0" =
    self.by-version."browserify-des"."1.0.0";
  by-version."browserify-des"."1.0.0" = self.buildNodePackage {
    name = "browserify-des-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify-des/-/browserify-des-1.0.0.tgz";
      name = "browserify-des-1.0.0.tgz";
      sha1 = "daa277717470922ed2fe18594118a175439721dd";
    };
    deps = {
      "cipher-base-1.0.2" = self.by-version."cipher-base"."1.0.2";
      "des.js-1.0.0" = self.by-version."des.js"."1.0.0";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-rsa"."^4.0.0" =
    self.by-version."browserify-rsa"."4.0.1";
  by-version."browserify-rsa"."4.0.1" = self.buildNodePackage {
    name = "browserify-rsa-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify-rsa/-/browserify-rsa-4.0.1.tgz";
      name = "browserify-rsa-4.0.1.tgz";
      sha1 = "21e0abfaf6f2029cf2fafb133567a701d4135524";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "randombytes-2.0.3" = self.by-version."randombytes"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-sign"."^4.0.0" =
    self.by-version."browserify-sign"."4.0.0";
  by-version."browserify-sign"."4.0.0" = self.buildNodePackage {
    name = "browserify-sign-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify-sign/-/browserify-sign-4.0.0.tgz";
      name = "browserify-sign-4.0.0.tgz";
      sha1 = "10773910c3c206d5420a46aad8694f820b85968f";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "browserify-rsa-4.0.1" = self.by-version."browserify-rsa"."4.0.1";
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
      "create-hmac-1.1.4" = self.by-version."create-hmac"."1.1.4";
      "elliptic-6.3.1" = self.by-version."elliptic"."6.3.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "parse-asn1-5.0.0" = self.by-version."parse-asn1"."5.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-zlib"."~0.1.2" =
    self.by-version."browserify-zlib"."0.1.4";
  by-version."browserify-zlib"."0.1.4" = self.buildNodePackage {
    name = "browserify-zlib-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.1.4.tgz";
      name = "browserify-zlib-0.1.4.tgz";
      sha1 = "bb35f8a519f600e0fa6b8485241c979d0141fb2d";
    };
    deps = {
      "pako-0.2.8" = self.by-version."pako"."0.2.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer"."^3.0.0" =
    self.by-version."buffer"."3.6.0";
  by-version."buffer"."3.6.0" = self.buildNodePackage {
    name = "buffer-3.6.0";
    version = "3.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/buffer/-/buffer-3.6.0.tgz";
      name = "buffer-3.6.0.tgz";
      sha1 = "a72c936f77b96bf52f5f7e7b467180628551defb";
    };
    deps = {
      "base64-js-0.0.8" = self.by-version."base64-js"."0.0.8";
      "ieee754-1.1.6" = self.by-version."ieee754"."1.1.6";
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-shims"."^1.0.0" =
    self.by-version."buffer-shims"."1.0.0";
  by-version."buffer-shims"."1.0.0" = self.buildNodePackage {
    name = "buffer-shims-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/buffer-shims/-/buffer-shims-1.0.0.tgz";
      name = "buffer-shims-1.0.0.tgz";
      sha1 = "9978ce317388c649ad8793028c3477ef044a8b51";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-xor"."^1.0.2" =
    self.by-version."buffer-xor"."1.0.3";
  by-version."buffer-xor"."1.0.3" = self.buildNodePackage {
    name = "buffer-xor-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/buffer-xor/-/buffer-xor-1.0.3.tgz";
      name = "buffer-xor-1.0.3.tgz";
      sha1 = "26e61ed1422fb70dd42e6e36729ed51d855fe8d9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."builtins"."~0.0.3" =
    self.by-version."builtins"."0.0.7";
  by-version."builtins"."0.0.7" = self.buildNodePackage {
    name = "builtins-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/builtins/-/builtins-0.0.7.tgz";
      name = "builtins-0.0.7.tgz";
      sha1 = "355219cd6cf18dbe7c01cc7fd2dce765cfdc549a";
    };
    deps = {
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
      url = "https://registry.npmjs.org/bytes/-/bytes-1.0.0.tgz";
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
  by-spec."bytes"."2.1.0" =
    self.by-version."bytes"."2.1.0";
  by-version."bytes"."2.1.0" = self.buildNodePackage {
    name = "bytes-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytes/-/bytes-2.1.0.tgz";
      name = "bytes-2.1.0.tgz";
      sha1 = "ac93c410e2ffc9cc7cf4b464b38289067f5e47b4";
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
  by-spec."caseless"."~0.9.0" =
    self.by-version."caseless"."0.9.0";
  by-version."caseless"."0.9.0" = self.buildNodePackage {
    name = "caseless-0.9.0";
    version = "0.9.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/caseless/-/caseless-0.9.0.tgz";
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
  by-spec."chalk"."^1.0.0" =
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
  by-spec."chalk"."^1.1.1" =
    self.by-version."chalk"."1.1.3";
  by-spec."cipher-base"."^1.0.0" =
    self.by-version."cipher-base"."1.0.2";
  by-version."cipher-base"."1.0.2" = self.buildNodePackage {
    name = "cipher-base-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cipher-base/-/cipher-base-1.0.2.tgz";
      name = "cipher-base-1.0.2.tgz";
      sha1 = "54ac1d1ebdf6a1bcd3559e6f369d72697f2cab8f";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cipher-base"."^1.0.1" =
    self.by-version."cipher-base"."1.0.2";
  by-spec."cli-cursor"."^1.0.1" =
    self.by-version."cli-cursor"."1.0.2";
  by-version."cli-cursor"."1.0.2" = self.buildNodePackage {
    name = "cli-cursor-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cli-cursor/-/cli-cursor-1.0.2.tgz";
      name = "cli-cursor-1.0.2.tgz";
      sha1 = "64da3f7d56a54412e59794bd62dc35295e8f2987";
    };
    deps = {
      "restore-cursor-1.0.1" = self.by-version."restore-cursor"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cli-width"."^1.0.1" =
    self.by-version."cli-width"."1.1.1";
  by-version."cli-width"."1.1.1" = self.buildNodePackage {
    name = "cli-width-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cli-width/-/cli-width-1.1.1.tgz";
      name = "cli-width-1.1.1.tgz";
      sha1 = "a4d293ef67ebb7b88d4a4d42c0ccf00c4d1e366d";
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
  by-spec."code-point-at"."^1.0.0" =
    self.by-version."code-point-at"."1.0.0";
  by-version."code-point-at"."1.0.0" = self.buildNodePackage {
    name = "code-point-at-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/code-point-at/-/code-point-at-1.0.0.tgz";
      name = "code-point-at-1.0.0.tgz";
      sha1 = "f69b192d3f7d91e382e4b71bddb77878619ab0c6";
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
  by-spec."coffee-script".">=1.0.1" =
    self.by-version."coffee-script"."1.10.0";
  by-version."coffee-script"."1.10.0" = self.buildNodePackage {
    name = "coffee-script-1.10.0";
    version = "1.10.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/coffee-script/-/coffee-script-1.10.0.tgz";
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
  by-spec."colors"."1.0.x" =
    self.by-version."colors"."1.0.3";
  by-version."colors"."1.0.3" = self.buildNodePackage {
    name = "colors-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
      name = "colors-1.0.3.tgz";
      sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combine-source-map"."~0.6.1" =
    self.by-version."combine-source-map"."0.6.1";
  by-version."combine-source-map"."0.6.1" = self.buildNodePackage {
    name = "combine-source-map-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/combine-source-map/-/combine-source-map-0.6.1.tgz";
      name = "combine-source-map-0.6.1.tgz";
      sha1 = "9b4a09c316033d768e0f11e029fa2730e079ad96";
    };
    deps = {
      "convert-source-map-1.1.3" = self.by-version."convert-source-map"."1.1.3";
      "inline-source-map-0.5.0" = self.by-version."inline-source-map"."0.5.0";
      "lodash.memoize-3.0.4" = self.by-version."lodash.memoize"."3.0.4";
      "source-map-0.4.4" = self.by-version."source-map"."0.4.4";
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
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.7";
  by-version."combined-stream"."0.0.7" = self.buildNodePackage {
    name = "combined-stream-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
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
  by-spec."combined-stream"."~1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-spec."commander"."^2.9.0" =
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
  by-spec."commondir"."0.0.1" =
    self.by-version."commondir"."0.0.1";
  by-version."commondir"."0.0.1" = self.buildNodePackage {
    name = "commondir-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/commondir/-/commondir-0.0.1.tgz";
      name = "commondir-0.0.1.tgz";
      sha1 = "89f00fdcd51b519c578733fec563e6a6da7f5be2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."concat-stream"."^1.4.6" =
    self.by-version."concat-stream"."1.5.1";
  by-version."concat-stream"."1.5.1" = self.buildNodePackage {
    name = "concat-stream-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.5.1.tgz";
      name = "concat-stream-1.5.1.tgz";
      sha1 = "f3b80acf9e1f48e3875c0688b41b6c31602eea1c";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-2.0.6" = self.by-version."readable-stream"."2.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."~1.4.1" =
    self.by-version."concat-stream"."1.4.10";
  by-version."concat-stream"."1.4.10" = self.buildNodePackage {
    name = "concat-stream-1.4.10";
    version = "1.4.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.4.10.tgz";
      name = "concat-stream-1.4.10.tgz";
      sha1 = "acc3bbf5602cb8cc980c6ac840fa7d8603e3ef36";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."~1.4.5" =
    self.by-version."concat-stream"."1.4.10";
  by-spec."console-browserify"."^1.1.0" =
    self.by-version."console-browserify"."1.1.0";
  by-version."console-browserify"."1.1.0" = self.buildNodePackage {
    name = "console-browserify-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/console-browserify/-/console-browserify-1.1.0.tgz";
      name = "console-browserify-1.1.0.tgz";
      sha1 = "f0241c45730a9fc6323b206dbf38edc741d0bb10";
    };
    deps = {
      "date-now-0.1.4" = self.by-version."date-now"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."constants-browserify"."~0.0.1" =
    self.by-version."constants-browserify"."0.0.1";
  by-version."constants-browserify"."0.0.1" = self.buildNodePackage {
    name = "constants-browserify-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/constants-browserify/-/constants-browserify-0.0.1.tgz";
      name = "constants-browserify-0.0.1.tgz";
      sha1 = "92577db527ba6c4cf0a4568d84bc031f441e21f2";
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
      url = "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.0.tgz";
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
  by-spec."convert-source-map"."~1.1.0" =
    self.by-version."convert-source-map"."1.1.3";
  by-version."convert-source-map"."1.1.3" = self.buildNodePackage {
    name = "convert-source-map-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/convert-source-map/-/convert-source-map-1.1.3.tgz";
      name = "convert-source-map-1.1.3.tgz";
      sha1 = "4829c877e9fe49b3161f3bf3673888e204699860";
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
      url = "https://registry.npmjs.org/cookie/-/cookie-0.1.2.tgz";
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
  by-spec."crc"."3.2.1" =
    self.by-version."crc"."3.2.1";
  by-version."crc"."3.2.1" = self.buildNodePackage {
    name = "crc-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/crc/-/crc-3.2.1.tgz";
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
  by-spec."crc"."^3.2.1" =
    self.by-version."crc"."3.4.0";
  by-version."crc"."3.4.0" = self.buildNodePackage {
    name = "crc-3.4.0";
    version = "3.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/crc/-/crc-3.4.0.tgz";
      name = "crc-3.4.0.tgz";
      sha1 = "4258e351613a74ef1153dfcb05e820c3e9715d7f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "crc" = self.by-version."crc"."3.4.0";
  by-spec."create-ecdh"."^4.0.0" =
    self.by-version."create-ecdh"."4.0.0";
  by-version."create-ecdh"."4.0.0" = self.buildNodePackage {
    name = "create-ecdh-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/create-ecdh/-/create-ecdh-4.0.0.tgz";
      name = "create-ecdh-4.0.0.tgz";
      sha1 = "888c723596cdf7612f6498233eebd7a35301737d";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "elliptic-6.3.1" = self.by-version."elliptic"."6.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."create-hash"."^1.1.0" =
    self.by-version."create-hash"."1.1.2";
  by-version."create-hash"."1.1.2" = self.buildNodePackage {
    name = "create-hash-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/create-hash/-/create-hash-1.1.2.tgz";
      name = "create-hash-1.1.2.tgz";
      sha1 = "51210062d7bb7479f6c65bb41a92208b1d61abad";
    };
    deps = {
      "cipher-base-1.0.2" = self.by-version."cipher-base"."1.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "ripemd160-1.0.1" = self.by-version."ripemd160"."1.0.1";
      "sha.js-2.4.5" = self.by-version."sha.js"."2.4.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."create-hash"."^1.1.1" =
    self.by-version."create-hash"."1.1.2";
  by-spec."create-hmac"."^1.1.0" =
    self.by-version."create-hmac"."1.1.4";
  by-version."create-hmac"."1.1.4" = self.buildNodePackage {
    name = "create-hmac-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/create-hmac/-/create-hmac-1.1.4.tgz";
      name = "create-hmac-1.1.4.tgz";
      sha1 = "d3fb4ba253eb8b3f56e39ea2fbcb8af747bd3170";
    };
    deps = {
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."create-hmac"."^1.1.2" =
    self.by-version."create-hmac"."1.1.4";
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
  by-spec."crypto-browserify"."^3.0.0" =
    self.by-version."crypto-browserify"."3.11.0";
  by-version."crypto-browserify"."3.11.0" = self.buildNodePackage {
    name = "crypto-browserify-3.11.0";
    version = "3.11.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/crypto-browserify/-/crypto-browserify-3.11.0.tgz";
      name = "crypto-browserify-3.11.0.tgz";
      sha1 = "3652a0906ab9b2a7e0c3ce66a408e957a2485522";
    };
    deps = {
      "browserify-cipher-1.0.0" = self.by-version."browserify-cipher"."1.0.0";
      "browserify-sign-4.0.0" = self.by-version."browserify-sign"."4.0.0";
      "create-ecdh-4.0.0" = self.by-version."create-ecdh"."4.0.0";
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
      "create-hmac-1.1.4" = self.by-version."create-hmac"."1.1.4";
      "diffie-hellman-5.0.2" = self.by-version."diffie-hellman"."5.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "pbkdf2-3.0.4" = self.by-version."pbkdf2"."3.0.4";
      "public-encrypt-4.0.0" = self.by-version."public-encrypt"."4.0.0";
      "randombytes-2.0.3" = self.by-version."randombytes"."2.0.3";
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
      url = "https://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
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
      url = "https://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
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
  by-spec."d"."^0.1.1" =
    self.by-version."d"."0.1.1";
  by-version."d"."0.1.1" = self.buildNodePackage {
    name = "d-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/d/-/d-0.1.1.tgz";
      name = "d-0.1.1.tgz";
      sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
    };
    deps = {
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."d"."~0.1.1" =
    self.by-version."d"."0.1.1";
  by-spec."dashdash"."^1.12.0" =
    self.by-version."dashdash"."1.14.0";
  by-version."dashdash"."1.14.0" = self.buildNodePackage {
    name = "dashdash-1.14.0";
    version = "1.14.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dashdash/-/dashdash-1.14.0.tgz";
      name = "dashdash-1.14.0.tgz";
      sha1 = "29e486c5418bf0f356034a993d51686a33e84141";
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
  by-spec."date-now"."^0.1.4" =
    self.by-version."date-now"."0.1.4";
  by-version."date-now"."0.1.4" = self.buildNodePackage {
    name = "date-now-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/date-now/-/date-now-0.1.4.tgz";
      name = "date-now-0.1.4.tgz";
      sha1 = "eaf439fd4d4848ad74e5cc7dbef200672b9e345b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."^2.1.1" =
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
  by-spec."debug"."~2.2.0" =
    self.by-version."debug"."2.2.0";
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
  by-spec."deep-is"."~0.1.2" =
    self.by-version."deep-is"."0.1.3";
  by-version."deep-is"."0.1.3" = self.buildNodePackage {
    name = "deep-is-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz";
      name = "deep-is-0.1.3.tgz";
      sha1 = "b369d6fb5dbc13eecf524f91b070feedc357cf34";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-is"."~0.1.3" =
    self.by-version."deep-is"."0.1.3";
  by-spec."defined"."^1.0.0" =
    self.by-version."defined"."1.0.0";
  by-version."defined"."1.0.0" = self.buildNodePackage {
    name = "defined-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/defined/-/defined-1.0.0.tgz";
      name = "defined-1.0.0.tgz";
      sha1 = "c98d9bcef75674188e110969151199e39b1fa693";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."del"."^2.0.2" =
    self.by-version."del"."2.2.1";
  by-version."del"."2.2.1" = self.buildNodePackage {
    name = "del-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/del/-/del-2.2.1.tgz";
      name = "del-2.2.1.tgz";
      sha1 = "f6763026472209c4f0349111c5ac280868bec4fe";
    };
    deps = {
      "globby-5.0.0" = self.by-version."globby"."5.0.0";
      "is-path-cwd-1.0.0" = self.by-version."is-path-cwd"."1.0.0";
      "is-path-in-cwd-1.0.0" = self.by-version."is-path-in-cwd"."1.0.0";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
      "rimraf-2.5.3" = self.by-version."rimraf"."2.5.3";
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
      url = "https://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
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
  by-spec."depd"."~1.0.1" =
    self.by-version."depd"."1.0.1";
  by-version."depd"."1.0.1" = self.buildNodePackage {
    name = "depd-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/depd/-/depd-1.0.1.tgz";
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
  by-spec."deps-sort"."^1.3.7" =
    self.by-version."deps-sort"."1.3.9";
  by-version."deps-sort"."1.3.9" = self.buildNodePackage {
    name = "deps-sort-1.3.9";
    version = "1.3.9";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/deps-sort/-/deps-sort-1.3.9.tgz";
      name = "deps-sort-1.3.9.tgz";
      sha1 = "29dfff53e17b36aecae7530adbbbf622c2ed1a71";
    };
    deps = {
      "JSONStream-1.1.3" = self.by-version."JSONStream"."1.1.3";
      "shasum-1.0.2" = self.by-version."shasum"."1.0.2";
      "subarg-1.0.0" = self.by-version."subarg"."1.0.0";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."des.js"."^1.0.0" =
    self.by-version."des.js"."1.0.0";
  by-version."des.js"."1.0.0" = self.buildNodePackage {
    name = "des.js-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/des.js/-/des.js-1.0.0.tgz";
      name = "des.js-1.0.0.tgz";
      sha1 = "c074d2e2aa6a8a9a07dbd61f9a15c2cd83ec8ecc";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimalistic-assert-1.0.0" = self.by-version."minimalistic-assert"."1.0.0";
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
      url = "https://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
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
  by-spec."detective"."^4.0.0" =
    self.by-version."detective"."4.3.1";
  by-version."detective"."4.3.1" = self.buildNodePackage {
    name = "detective-4.3.1";
    version = "4.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/detective/-/detective-4.3.1.tgz";
      name = "detective-4.3.1.tgz";
      sha1 = "9fb06dd1ee8f0ea4dbcc607cda39d9ce1d4f726f";
    };
    deps = {
      "acorn-1.2.2" = self.by-version."acorn"."1.2.2";
      "defined-1.0.0" = self.by-version."defined"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."diffie-hellman"."^5.0.0" =
    self.by-version."diffie-hellman"."5.0.2";
  by-version."diffie-hellman"."5.0.2" = self.buildNodePackage {
    name = "diffie-hellman-5.0.2";
    version = "5.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/diffie-hellman/-/diffie-hellman-5.0.2.tgz";
      name = "diffie-hellman-5.0.2.tgz";
      sha1 = "b5835739270cfe26acf632099fded2a07f209e5e";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "miller-rabin-4.0.0" = self.by-version."miller-rabin"."4.0.0";
      "randombytes-2.0.3" = self.by-version."randombytes"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."doctrine"."^0.7.1" =
    self.by-version."doctrine"."0.7.2";
  by-version."doctrine"."0.7.2" = self.buildNodePackage {
    name = "doctrine-0.7.2";
    version = "0.7.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/doctrine/-/doctrine-0.7.2.tgz";
      name = "doctrine-0.7.2.tgz";
      sha1 = "7cb860359ba3be90e040b26b729ce4bfa654c523";
    };
    deps = {
      "esutils-1.1.6" = self.by-version."esutils"."1.1.6";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
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
  by-spec."domain-browser"."~1.1.0" =
    self.by-version."domain-browser"."1.1.7";
  by-version."domain-browser"."1.1.7" = self.buildNodePackage {
    name = "domain-browser-1.1.7";
    version = "1.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domain-browser/-/domain-browser-1.1.7.tgz";
      name = "domain-browser-1.1.7.tgz";
      sha1 = "867aa4b093faa05f1de08c06f4d7b21fdf8698bc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
    self.by-version."domhandler"."2.3.0";
  by-version."domhandler"."2.3.0" = self.buildNodePackage {
    name = "domhandler-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/domhandler/-/domhandler-2.3.0.tgz";
      name = "domhandler-2.3.0.tgz";
      sha1 = "2de59a0822d5027fabff6f032c2b25a2a8abe738";
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
  by-spec."domutils"."^1.5.1" =
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
  by-spec."duplexer2"."0.0.2" =
    self.by-version."duplexer2"."0.0.2";
  by-version."duplexer2"."0.0.2" = self.buildNodePackage {
    name = "duplexer2-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/duplexer2/-/duplexer2-0.0.2.tgz";
      name = "duplexer2-0.0.2.tgz";
      sha1 = "c614dcf67e2fb14995a91711e5a617e8a60a31db";
    };
    deps = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."duplexer2"."~0.0.2" =
    self.by-version."duplexer2"."0.0.2";
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
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
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
      url = "https://registry.npmjs.org/ee-first/-/ee-first-1.1.0.tgz";
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
  by-spec."elliptic"."^6.0.0" =
    self.by-version."elliptic"."6.3.1";
  by-version."elliptic"."6.3.1" = self.buildNodePackage {
    name = "elliptic-6.3.1";
    version = "6.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/elliptic/-/elliptic-6.3.1.tgz";
      name = "elliptic-6.3.1.tgz";
      sha1 = "17781f2109ab0ec686b146bdcff5d2e8c6aeceda";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "brorand-1.0.5" = self.by-version."brorand"."1.0.5";
      "hash.js-1.0.3" = self.by-version."hash.js"."1.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
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
  by-spec."es3ify"."^0.1.3" =
    self.by-version."es3ify"."0.1.4";
  by-version."es3ify"."0.1.4" = self.buildNodePackage {
    name = "es3ify-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es3ify/-/es3ify-0.1.4.tgz";
      name = "es3ify-0.1.4.tgz";
      sha1 = "ad9fa5df1ae34f3f31e1211b5818b2d51078dfd1";
    };
    deps = {
      "esprima-fb-3001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
      "jstransform-3.0.0" = self.by-version."jstransform"."3.0.0";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."^0.10.7" =
    self.by-version."es5-ext"."0.10.12";
  by-version."es5-ext"."0.10.12" = self.buildNodePackage {
    name = "es5-ext-0.10.12";
    version = "0.10.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.12.tgz";
      name = "es5-ext-0.10.12.tgz";
      sha1 = "aa84641d4db76b62abba5e45fd805ecbab140047";
    };
    deps = {
      "es6-iterator-2.0.0" = self.by-version."es6-iterator"."2.0.0";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."^0.10.8" =
    self.by-version."es5-ext"."0.10.12";
  by-spec."es5-ext"."~0.10.11" =
    self.by-version."es5-ext"."0.10.12";
  by-spec."es5-ext"."~0.10.2" =
    self.by-version."es5-ext"."0.10.12";
  by-spec."es5-ext"."~0.10.7" =
    self.by-version."es5-ext"."0.10.12";
  by-spec."es6-iterator"."2" =
    self.by-version."es6-iterator"."2.0.0";
  by-version."es6-iterator"."2.0.0" = self.buildNodePackage {
    name = "es6-iterator-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.0.tgz";
      name = "es6-iterator-2.0.0.tgz";
      sha1 = "bd968567d61635e33c0b80727613c9cb4b096bac";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-map"."^0.1.3" =
    self.by-version."es6-map"."0.1.4";
  by-version."es6-map"."0.1.4" = self.buildNodePackage {
    name = "es6-map-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-map/-/es6-map-0.1.4.tgz";
      name = "es6-map-0.1.4.tgz";
      sha1 = "a34b147be224773a4d7da8072794cefa3632b897";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
      "es6-iterator-2.0.0" = self.by-version."es6-iterator"."2.0.0";
      "es6-set-0.1.4" = self.by-version."es6-set"."0.1.4";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
      "event-emitter-0.3.4" = self.by-version."event-emitter"."0.3.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-set"."~0.1.3" =
    self.by-version."es6-set"."0.1.4";
  by-version."es6-set"."0.1.4" = self.buildNodePackage {
    name = "es6-set-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-set/-/es6-set-0.1.4.tgz";
      name = "es6-set-0.1.4.tgz";
      sha1 = "9516b6761c2964b92ff479456233a247dc707ce8";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
      "es6-iterator-2.0.0" = self.by-version."es6-iterator"."2.0.0";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
      "event-emitter-0.3.4" = self.by-version."event-emitter"."0.3.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."3" =
    self.by-version."es6-symbol"."3.1.0";
  by-version."es6-symbol"."3.1.0" = self.buildNodePackage {
    name = "es6-symbol-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.0.tgz";
      name = "es6-symbol-3.1.0.tgz";
      sha1 = "94481c655e7a7cad82eba832d97d5433496d7ffa";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."~3.1" =
    self.by-version."es6-symbol"."3.1.0";
  by-spec."es6-symbol"."~3.1.0" =
    self.by-version."es6-symbol"."3.1.0";
  by-spec."es6-weak-map"."^2.0.1" =
    self.by-version."es6-weak-map"."2.0.1";
  by-version."es6-weak-map"."2.0.1" = self.buildNodePackage {
    name = "es6-weak-map-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-2.0.1.tgz";
      name = "es6-weak-map-2.0.1.tgz";
      sha1 = "0d2bbd8827eb5fb4ba8f97fbfea50d43db21ea81";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
      "es6-iterator-2.0.0" = self.by-version."es6-iterator"."2.0.0";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
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
      url = "https://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
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
  by-spec."escape-string-regexp"."^1.0.5" =
    self.by-version."escape-string-regexp"."1.0.5";
  by-spec."escodegen"."1.7.x" =
    self.by-version."escodegen"."1.7.1";
  by-version."escodegen"."1.7.1" = self.buildNodePackage {
    name = "escodegen-1.7.1";
    version = "1.7.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/escodegen/-/escodegen-1.7.1.tgz";
      name = "escodegen-1.7.1.tgz";
      sha1 = "30ecfcf66ca98dc67cd2fd162abeb6eafa8ce6fc";
    };
    deps = {
      "estraverse-1.9.3" = self.by-version."estraverse"."1.9.3";
      "esutils-2.0.2" = self.by-version."esutils"."2.0.2";
      "esprima-1.2.5" = self.by-version."esprima"."1.2.5";
      "optionator-0.5.0" = self.by-version."optionator"."0.5.0";
    };
    optionalDependencies = {
      "source-map-0.2.0" = self.by-version."source-map"."0.2.0";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escope"."^3.3.0" =
    self.by-version."escope"."3.6.0";
  by-version."escope"."3.6.0" = self.buildNodePackage {
    name = "escope-3.6.0";
    version = "3.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/escope/-/escope-3.6.0.tgz";
      name = "escope-3.6.0.tgz";
      sha1 = "e01975e812781a163a6dadfdd80398dc64c889c3";
    };
    deps = {
      "es6-map-0.1.4" = self.by-version."es6-map"."0.1.4";
      "es6-weak-map-2.0.1" = self.by-version."es6-weak-map"."2.0.1";
      "esrecurse-4.1.0" = self.by-version."esrecurse"."4.1.0";
      "estraverse-4.2.0" = self.by-version."estraverse"."4.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eslint"."^1.10.3" =
    self.by-version."eslint"."1.10.3";
  by-version."eslint"."1.10.3" = self.buildNodePackage {
    name = "eslint-1.10.3";
    version = "1.10.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/eslint/-/eslint-1.10.3.tgz";
      name = "eslint-1.10.3.tgz";
      sha1 = "fb19a91b13c158082bbca294b17d979bc8353a0a";
    };
    deps = {
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "concat-stream-1.5.1" = self.by-version."concat-stream"."1.5.1";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "doctrine-0.7.2" = self.by-version."doctrine"."0.7.2";
      "escape-string-regexp-1.0.5" = self.by-version."escape-string-regexp"."1.0.5";
      "escope-3.6.0" = self.by-version."escope"."3.6.0";
      "espree-2.2.5" = self.by-version."espree"."2.2.5";
      "estraverse-4.2.0" = self.by-version."estraverse"."4.2.0";
      "estraverse-fb-1.3.1" = self.by-version."estraverse-fb"."1.3.1";
      "esutils-2.0.2" = self.by-version."esutils"."2.0.2";
      "file-entry-cache-1.2.4" = self.by-version."file-entry-cache"."1.2.4";
      "glob-5.0.15" = self.by-version."glob"."5.0.15";
      "globals-8.18.0" = self.by-version."globals"."8.18.0";
      "handlebars-4.0.5" = self.by-version."handlebars"."4.0.5";
      "inquirer-0.11.4" = self.by-version."inquirer"."0.11.4";
      "is-my-json-valid-2.13.1" = self.by-version."is-my-json-valid"."2.13.1";
      "is-resolvable-1.0.0" = self.by-version."is-resolvable"."1.0.0";
      "js-yaml-3.4.5" = self.by-version."js-yaml"."3.4.5";
      "json-stable-stringify-1.0.1" = self.by-version."json-stable-stringify"."1.0.1";
      "lodash.clonedeep-3.0.2" = self.by-version."lodash.clonedeep"."3.0.2";
      "lodash.merge-3.3.2" = self.by-version."lodash.merge"."3.3.2";
      "lodash.omit-3.1.0" = self.by-version."lodash.omit"."3.1.0";
      "minimatch-3.0.2" = self.by-version."minimatch"."3.0.2";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "optionator-0.6.0" = self.by-version."optionator"."0.6.0";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
      "path-is-inside-1.0.1" = self.by-version."path-is-inside"."1.0.1";
      "shelljs-0.5.3" = self.by-version."shelljs"."0.5.3";
      "strip-json-comments-1.0.4" = self.by-version."strip-json-comments"."1.0.4";
      "text-table-0.2.0" = self.by-version."text-table"."0.2.0";
      "user-home-2.0.0" = self.by-version."user-home"."2.0.0";
      "xml-escape-1.0.0" = self.by-version."xml-escape"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "eslint" = self.by-version."eslint"."1.10.3";
  by-spec."esmangle-evaluator"."^1.0.0" =
    self.by-version."esmangle-evaluator"."1.0.1";
  by-version."esmangle-evaluator"."1.0.1" = self.buildNodePackage {
    name = "esmangle-evaluator-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/esmangle-evaluator/-/esmangle-evaluator-1.0.1.tgz";
      name = "esmangle-evaluator-1.0.1.tgz";
      sha1 = "620d866ef4861b3311f75766d52a8572bb3c6336";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."espree"."^2.2.4" =
    self.by-version."espree"."2.2.5";
  by-version."espree"."2.2.5" = self.buildNodePackage {
    name = "espree-2.2.5";
    version = "2.2.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/espree/-/espree-2.2.5.tgz";
      name = "espree-2.2.5.tgz";
      sha1 = "df691b9310889402aeb29cc066708c56690b854b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."2.5.x" =
    self.by-version."esprima"."2.5.0";
  by-version."esprima"."2.5.0" = self.buildNodePackage {
    name = "esprima-2.5.0";
    version = "2.5.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima/-/esprima-2.5.0.tgz";
      name = "esprima-2.5.0.tgz";
      sha1 = "f387a46fd344c1b1a39baf8c20bfb43b6d0058cc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."^1.2.2" =
    self.by-version."esprima"."1.2.5";
  by-version."esprima"."1.2.5" = self.buildNodePackage {
    name = "esprima-1.2.5";
    version = "1.2.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima/-/esprima-1.2.5.tgz";
      name = "esprima-1.2.5.tgz";
      sha1 = "0993502feaf668138325756f30f9a51feeec11e9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima"."^2.6.0" =
    self.by-version."esprima"."2.7.2";
  by-version."esprima"."2.7.2" = self.buildNodePackage {
    name = "esprima-2.7.2";
    version = "2.7.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima/-/esprima-2.7.2.tgz";
      name = "esprima-2.7.2.tgz";
      sha1 = "f43be543609984eae44c933ac63352a6af35f339";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima-fb"."~15001.1001.0-dev-harmony-fb" =
    self.by-version."esprima-fb"."15001.1001.0-dev-harmony-fb";
  by-version."esprima-fb"."15001.1001.0-dev-harmony-fb" = self.buildNodePackage {
    name = "esprima-fb-15001.1001.0-dev-harmony-fb";
    version = "15001.1001.0-dev-harmony-fb";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima-fb/-/esprima-fb-15001.1001.0-dev-harmony-fb.tgz";
      name = "esprima-fb-15001.1001.0-dev-harmony-fb.tgz";
      sha1 = "43beb57ec26e8cf237d3dd8b33e42533577f2659";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima-fb"."~3001.0001.0000-dev-harmony-fb" =
    self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
  by-version."esprima-fb"."3001.1.0-dev-harmony-fb" = self.buildNodePackage {
    name = "esprima-fb-3001.1.0-dev-harmony-fb";
    version = "3001.1.0-dev-harmony-fb";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/esprima-fb/-/esprima-fb-3001.0001.0000-dev-harmony-fb.tgz";
      name = "esprima-fb-3001.1.0-dev-harmony-fb.tgz";
      sha1 = "b77d37abcd38ea0b77426bb8bc2922ce6b426411";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esprima-fb"."~3001.1.0-dev-harmony-fb" =
    self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
  by-spec."esrecurse"."^4.1.0" =
    self.by-version."esrecurse"."4.1.0";
  by-version."esrecurse"."4.1.0" = self.buildNodePackage {
    name = "esrecurse-4.1.0";
    version = "4.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/esrecurse/-/esrecurse-4.1.0.tgz";
      name = "esrecurse-4.1.0.tgz";
      sha1 = "4713b6536adf7f2ac4f327d559e7756bff648220";
    };
    deps = {
      "estraverse-4.1.1" = self.by-version."estraverse"."4.1.1";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."estraverse"."*" =
    self.by-version."estraverse"."4.2.0";
  by-version."estraverse"."4.2.0" = self.buildNodePackage {
    name = "estraverse-4.2.0";
    version = "4.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/estraverse/-/estraverse-4.2.0.tgz";
      name = "estraverse-4.2.0.tgz";
      sha1 = "0dee3fed31fcd469618ce7342099fc1afa0bdb13";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."estraverse".">=4.1.1 <5.0.0" =
    self.by-version."estraverse"."4.2.0";
  by-spec."estraverse"."^1.9.1" =
    self.by-version."estraverse"."1.9.3";
  by-version."estraverse"."1.9.3" = self.buildNodePackage {
    name = "estraverse-1.9.3";
    version = "1.9.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/estraverse/-/estraverse-1.9.3.tgz";
      name = "estraverse-1.9.3.tgz";
      sha1 = "af67f2dc922582415950926091a4005d29c9bb44";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."estraverse"."^4.1.1" =
    self.by-version."estraverse"."4.2.0";
  by-spec."estraverse"."~4.1.0" =
    self.by-version."estraverse"."4.1.1";
  by-version."estraverse"."4.1.1" = self.buildNodePackage {
    name = "estraverse-4.1.1";
    version = "4.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/estraverse/-/estraverse-4.1.1.tgz";
      name = "estraverse-4.1.1.tgz";
      sha1 = "f6caca728933a850ef90661d0e17982ba47111a2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."estraverse-fb"."^1.3.1" =
    self.by-version."estraverse-fb"."1.3.1";
  by-version."estraverse-fb"."1.3.1" = self.buildNodePackage {
    name = "estraverse-fb-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/estraverse-fb/-/estraverse-fb-1.3.1.tgz";
      name = "estraverse-fb-1.3.1.tgz";
      sha1 = "160e75a80e605b08ce894bcce2fe3e429abf92bf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [
      self.by-version."estraverse"."4.2.0"];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esutils"."^1.1.6" =
    self.by-version."esutils"."1.1.6";
  by-version."esutils"."1.1.6" = self.buildNodePackage {
    name = "esutils-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/esutils/-/esutils-1.1.6.tgz";
      name = "esutils-1.1.6.tgz";
      sha1 = "c01ccaa9ae4b897c6d0c3e210ae52f3c7a844375";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."esutils"."^2.0.2" =
    self.by-version."esutils"."2.0.2";
  by-version."esutils"."2.0.2" = self.buildNodePackage {
    name = "esutils-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/esutils/-/esutils-2.0.2.tgz";
      name = "esutils-2.0.2.tgz";
      sha1 = "0abf4f1caa5bcb1f7a9d8acc6dea4faaa04bac9b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."etag"."~1.6.0" =
    self.by-version."etag"."1.6.0";
  by-version."etag"."1.6.0" = self.buildNodePackage {
    name = "etag-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/etag/-/etag-1.6.0.tgz";
      name = "etag-1.6.0.tgz";
      sha1 = "8bcb2c6af1254c481dfc8b997c906ef4e442c207";
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
  by-spec."event-emitter"."~0.3.4" =
    self.by-version."event-emitter"."0.3.4";
  by-version."event-emitter"."0.3.4" = self.buildNodePackage {
    name = "event-emitter-0.3.4";
    version = "0.3.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/event-emitter/-/event-emitter-0.3.4.tgz";
      name = "event-emitter-0.3.4.tgz";
      sha1 = "8d63ddfb4cfe1fae3b32ca265c4c720222080bb5";
    };
    deps = {
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
      "d-0.1.1" = self.by-version."d"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."events"."~1.0.0" =
    self.by-version."events"."1.0.2";
  by-version."events"."1.0.2" = self.buildNodePackage {
    name = "events-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/events/-/events-1.0.2.tgz";
      name = "events-1.0.2.tgz";
      sha1 = "75849dcfe93d10fb057c30055afdbd51d06a8e24";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."evp_bytestokey"."^1.0.0" =
    self.by-version."evp_bytestokey"."1.0.0";
  by-version."evp_bytestokey"."1.0.0" = self.buildNodePackage {
    name = "evp_bytestokey-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/evp_bytestokey/-/evp_bytestokey-1.0.0.tgz";
      name = "evp_bytestokey-1.0.0.tgz";
      sha1 = "497b66ad9fef65cd7c08a6180824ba1476b66e53";
    };
    deps = {
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."exit-hook"."^1.0.0" =
    self.by-version."exit-hook"."1.1.1";
  by-version."exit-hook"."1.1.1" = self.buildNodePackage {
    name = "exit-hook-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/exit-hook/-/exit-hook-1.1.1.tgz";
      name = "exit-hook-1.1.1.tgz";
      sha1 = "f05ca233b48c05d54fff07765df8507e95c02ff8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."~4.12.0" =
    self.by-version."express"."4.12.4";
  by-version."express"."4.12.4" = self.buildNodePackage {
    name = "express-4.12.4";
    version = "4.12.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/express/-/express-4.12.4.tgz";
      name = "express-4.12.4.tgz";
      sha1 = "8fec2510255bc6b2e58107c48239c0fa307c1aa2";
    };
    deps = {
      "accepts-1.2.13" = self.by-version."accepts"."1.2.13";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.6.0" = self.by-version."etag"."1.6.0";
      "finalhandler-0.3.6" = self.by-version."finalhandler"."0.3.6";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "merge-descriptors-1.0.0" = self.by-version."merge-descriptors"."1.0.0";
      "methods-1.1.2" = self.by-version."methods"."1.1.2";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.10" = self.by-version."proxy-addr"."1.0.10";
      "qs-2.4.2" = self.by-version."qs"."2.4.2";
      "range-parser-1.0.3" = self.by-version."range-parser"."1.0.3";
      "send-0.12.3" = self.by-version."send"."0.12.3";
      "serve-static-1.9.3" = self.by-version."serve-static"."1.9.3";
      "type-is-1.6.13" = self.by-version."type-is"."1.6.13";
      "vary-1.0.1" = self.by-version."vary"."1.0.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extend"."^2.0.0" =
    self.by-version."extend"."2.0.1";
  by-version."extend"."2.0.1" = self.buildNodePackage {
    name = "extend-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extend/-/extend-2.0.1.tgz";
      name = "extend-2.0.1.tgz";
      sha1 = "1ee8010689e7395ff9448241c98652bc759a8260";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "extend" = self.by-version."extend"."2.0.1";
  by-spec."extend"."^3.0.0" =
    self.by-version."extend"."3.0.0";
  by-version."extend"."3.0.0" = self.buildNodePackage {
    name = "extend-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
      name = "extend-3.0.0.tgz";
      sha1 = "5a474353b9f3353ddd8176dfd37b91c83a46f1d4";
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
    self.by-version."extend"."3.0.0";
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
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = self.buildNodePackage {
    name = "eyes-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
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
  by-spec."falafel"."^1.0.1" =
    self.by-version."falafel"."1.2.0";
  by-version."falafel"."1.2.0" = self.buildNodePackage {
    name = "falafel-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/falafel/-/falafel-1.2.0.tgz";
      name = "falafel-1.2.0.tgz";
      sha1 = "c18d24ef5091174a497f318cd24b026a25cddab4";
    };
    deps = {
      "acorn-1.2.2" = self.by-version."acorn"."1.2.2";
      "foreach-2.0.5" = self.by-version."foreach"."2.0.5";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "object-keys-1.0.11" = self.by-version."object-keys"."1.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fast-levenshtein"."~1.0.0" =
    self.by-version."fast-levenshtein"."1.0.7";
  by-version."fast-levenshtein"."1.0.7" = self.buildNodePackage {
    name = "fast-levenshtein-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-1.0.7.tgz";
      name = "fast-levenshtein-1.0.7.tgz";
      sha1 = "0178dcdee023b92905193af0959e8a7639cfdcb9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fast-levenshtein"."~1.0.6" =
    self.by-version."fast-levenshtein"."1.0.7";
  by-spec."figures"."^1.3.5" =
    self.by-version."figures"."1.7.0";
  by-version."figures"."1.7.0" = self.buildNodePackage {
    name = "figures-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/figures/-/figures-1.7.0.tgz";
      name = "figures-1.7.0.tgz";
      sha1 = "cbe1e3affcf1cd44b80cadfed28dc793a9701d2e";
    };
    deps = {
      "escape-string-regexp-1.0.5" = self.by-version."escape-string-regexp"."1.0.5";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."file-entry-cache"."^1.1.1" =
    self.by-version."file-entry-cache"."1.2.4";
  by-version."file-entry-cache"."1.2.4" = self.buildNodePackage {
    name = "file-entry-cache-1.2.4";
    version = "1.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-1.2.4.tgz";
      name = "file-entry-cache-1.2.4.tgz";
      sha1 = "9a586072c69365a7ef7ec72a7c2b9046de091e9c";
    };
    deps = {
      "flat-cache-1.0.10" = self.by-version."flat-cache"."1.0.10";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fileset"."0.2.x" =
    self.by-version."fileset"."0.2.1";
  by-version."fileset"."0.2.1" = self.buildNodePackage {
    name = "fileset-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fileset/-/fileset-0.2.1.tgz";
      name = "fileset-0.2.1.tgz";
      sha1 = "588ef8973c6623b2a76df465105696b96aac8067";
    };
    deps = {
      "minimatch-2.0.10" = self.by-version."minimatch"."2.0.10";
      "glob-5.0.15" = self.by-version."glob"."5.0.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fileset"."~0.1.5" =
    self.by-version."fileset"."0.1.8";
  by-version."fileset"."0.1.8" = self.buildNodePackage {
    name = "fileset-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fileset/-/fileset-0.1.8.tgz";
      name = "fileset-0.1.8.tgz";
      sha1 = "506b91a9396eaa7e32fb42a84077c7a0c736b741";
    };
    deps = {
      "minimatch-0.4.0" = self.by-version."minimatch"."0.4.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fill-keys"."^1.0.2" =
    self.by-version."fill-keys"."1.0.2";
  by-version."fill-keys"."1.0.2" = self.buildNodePackage {
    name = "fill-keys-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fill-keys/-/fill-keys-1.0.2.tgz";
      name = "fill-keys-1.0.2.tgz";
      sha1 = "9a8fa36f4e8ad634e3bf6b4f3c8882551452eb20";
    };
    deps = {
      "is-object-1.0.1" = self.by-version."is-object"."1.0.1";
      "merge-descriptors-1.0.1" = self.by-version."merge-descriptors"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."finalhandler"."0.3.6" =
    self.by-version."finalhandler"."0.3.6";
  by-version."finalhandler"."0.3.6" = self.buildNodePackage {
    name = "finalhandler-0.3.6";
    version = "0.3.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/finalhandler/-/finalhandler-0.3.6.tgz";
      name = "finalhandler-0.3.6.tgz";
      sha1 = "daf9c4161b1b06e001466b1411dfdb6973be138b";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."flat-cache"."^1.0.9" =
    self.by-version."flat-cache"."1.0.10";
  by-version."flat-cache"."1.0.10" = self.buildNodePackage {
    name = "flat-cache-1.0.10";
    version = "1.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/flat-cache/-/flat-cache-1.0.10.tgz";
      name = "flat-cache-1.0.10.tgz";
      sha1 = "73d6df4a28502160a05e059544a6aeeae8b0047a";
    };
    deps = {
      "del-2.2.1" = self.by-version."del"."2.2.1";
      "graceful-fs-4.1.4" = self.by-version."graceful-fs"."4.1.4";
      "read-json-sync-1.1.1" = self.by-version."read-json-sync"."1.1.1";
      "write-0.2.1" = self.by-version."write"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."foreach"."^2.0.5" =
    self.by-version."foreach"."2.0.5";
  by-version."foreach"."2.0.5" = self.buildNodePackage {
    name = "foreach-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/foreach/-/foreach-2.0.5.tgz";
      name = "foreach-2.0.5.tgz";
      sha1 = "0bee005018aeb260d0a3af3ae658dd0136ec1b99";
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
      url = "https://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
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
  by-spec."form-data"."~0.2.0" =
    self.by-version."form-data"."0.2.0";
  by-version."form-data"."0.2.0" = self.buildNodePackage {
    name = "form-data-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/form-data/-/form-data-0.2.0.tgz";
      name = "form-data-0.2.0.tgz";
      sha1 = "26f8bc26da6440e299cbdcfb69035c4f77a6e466";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~1.0.0-rc4" =
    self.by-version."form-data"."1.0.0-rc4";
  by-version."form-data"."1.0.0-rc4" = self.buildNodePackage {
    name = "form-data-1.0.0-rc4";
    version = "1.0.0-rc4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/form-data/-/form-data-1.0.0-rc4.tgz";
      name = "form-data-1.0.0-rc4.tgz";
      sha1 = "05ac6bc22227b43e4461f488161554699d4f8b5e";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.11" = self.by-version."mime-types"."2.1.11";
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
  by-spec."fresh"."0.2.4" =
    self.by-version."fresh"."0.2.4";
  by-version."fresh"."0.2.4" = self.buildNodePackage {
    name = "fresh-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fresh/-/fresh-0.2.4.tgz";
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
  by-spec."fs"."0.0.2" =
    self.by-version."fs"."0.0.2";
  by-version."fs"."0.0.2" = self.buildNodePackage {
    name = "fs-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs/-/fs-0.0.2.tgz";
      name = "fs-0.0.2.tgz";
      sha1 = "e1f244ef3933c1b2a64bd4799136060d0f5914f8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "fs" = self.by-version."fs"."0.0.2";
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
  by-spec."function-bind"."^1.0.2" =
    self.by-version."function-bind"."1.1.0";
  by-version."function-bind"."1.1.0" = self.buildNodePackage {
    name = "function-bind-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/function-bind/-/function-bind-1.1.0.tgz";
      name = "function-bind-1.1.0.tgz";
      sha1 = "16176714c801798e4e8f2cf7f7529467bb4a5771";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gaze"."~0.3.2" =
    self.by-version."gaze"."0.3.4";
  by-version."gaze"."0.3.4" = self.buildNodePackage {
    name = "gaze-0.3.4";
    version = "0.3.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/gaze/-/gaze-0.3.4.tgz";
      name = "gaze-0.3.4.tgz";
      sha1 = "5f94bdda0afe53bc710969bcd6f282548d60c279";
    };
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "fileset-0.1.8" = self.by-version."fileset"."0.1.8";
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
  by-spec."generate-object-property"."^1.1.0" =
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
  by-spec."getpass"."^0.1.1" =
    self.by-version."getpass"."0.1.6";
  by-version."getpass"."0.1.6" = self.buildNodePackage {
    name = "getpass-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/getpass/-/getpass-0.1.6.tgz";
      name = "getpass-0.1.6.tgz";
      sha1 = "283ffd9fc1256840875311c1b60e8c40187110e6";
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
  by-spec."glob"."3.x" =
    self.by-version."glob"."3.2.11";
  by-version."glob"."3.2.11" = self.buildNodePackage {
    name = "glob-3.2.11";
    version = "3.2.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-3.2.11.tgz";
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
  by-spec."glob"."5.x" =
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
      "inflight-1.0.5" = self.by-version."inflight"."1.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-3.0.2" = self.by-version."minimatch"."3.0.2";
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^4.0.5" =
    self.by-version."glob"."4.5.3";
  by-version."glob"."4.5.3" = self.buildNodePackage {
    name = "glob-4.5.3";
    version = "4.5.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-4.5.3.tgz";
      name = "glob-4.5.3.tgz";
      sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
    };
    deps = {
      "inflight-1.0.5" = self.by-version."inflight"."1.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.10" = self.by-version."minimatch"."2.0.10";
      "once-1.3.3" = self.by-version."once"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^5.0.14" =
    self.by-version."glob"."5.0.15";
  by-spec."glob"."^7.0.3" =
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
      "inflight-1.0.5" = self.by-version."inflight"."1.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-3.0.2" = self.by-version."minimatch"."3.0.2";
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^7.0.5" =
    self.by-version."glob"."7.0.5";
  by-spec."globals"."^8.11.0" =
    self.by-version."globals"."8.18.0";
  by-version."globals"."8.18.0" = self.buildNodePackage {
    name = "globals-8.18.0";
    version = "8.18.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/globals/-/globals-8.18.0.tgz";
      name = "globals-8.18.0.tgz";
      sha1 = "93d4a62bdcac38cfafafc47d6b034768cb0ffcb4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."globby"."^5.0.0" =
    self.by-version."globby"."5.0.0";
  by-version."globby"."5.0.0" = self.buildNodePackage {
    name = "globby-5.0.0";
    version = "5.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/globby/-/globby-5.0.0.tgz";
      name = "globby-5.0.0.tgz";
      sha1 = "ebd84667ca0dbb330b99bcfc68eac2bc54370e0d";
    };
    deps = {
      "array-union-1.0.2" = self.by-version."array-union"."1.0.2";
      "arrify-1.0.1" = self.by-version."arrify"."1.0.1";
      "glob-7.0.5" = self.by-version."glob"."7.0.5";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."^4.1.2" =
    self.by-version."graceful-fs"."4.1.4";
  by-version."graceful-fs"."4.1.4" = self.buildNodePackage {
    name = "graceful-fs-4.1.4";
    version = "4.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.4.tgz";
      name = "graceful-fs-4.1.4.tgz";
      sha1 = "ef089d2880f033b011823ce5c8fae798da775dbd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."growl"."~1.7.0" =
    self.by-version."growl"."1.7.0";
  by-version."growl"."1.7.0" = self.buildNodePackage {
    name = "growl-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/growl/-/growl-1.7.0.tgz";
      name = "growl-1.7.0.tgz";
      sha1 = "de2d66136d002e112ba70f3f10c31cf7c350b2da";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."handlebars"."^4.0.0" =
    self.by-version."handlebars"."4.0.5";
  by-version."handlebars"."4.0.5" = self.buildNodePackage {
    name = "handlebars-4.0.5";
    version = "4.0.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/handlebars/-/handlebars-4.0.5.tgz";
      name = "handlebars-4.0.5.tgz";
      sha1 = "92c6ed6bb164110c50d4d8d0fbddc70806c6f8e7";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "source-map-0.4.4" = self.by-version."source-map"."0.4.4";
    };
    optionalDependencies = {
      "uglify-js-2.7.0" = self.by-version."uglify-js"."2.7.0";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."handlebars"."^4.0.1" =
    self.by-version."handlebars"."4.0.5";
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
      "is-my-json-valid-2.13.1" = self.by-version."is-my-json-valid"."2.13.1";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has"."^1.0.0" =
    self.by-version."has"."1.0.1";
  by-version."has"."1.0.1" = self.buildNodePackage {
    name = "has-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has/-/has-1.0.1.tgz";
      name = "has-1.0.1.tgz";
      sha1 = "8461733f538b0837c9361e39a9ab9e9704dc2f28";
    };
    deps = {
      "function-bind-1.1.0" = self.by-version."function-bind"."1.1.0";
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
      "ansi-regex-2.0.0" = self.by-version."ansi-regex"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-flag"."^1.0.0" =
    self.by-version."has-flag"."1.0.0";
  by-version."has-flag"."1.0.0" = self.buildNodePackage {
    name = "has-flag-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has-flag/-/has-flag-1.0.0.tgz";
      name = "has-flag-1.0.0.tgz";
      sha1 = "9d9e793165ce017a00f00418c43f942a7b1d11fa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hash.js"."^1.0.0" =
    self.by-version."hash.js"."1.0.3";
  by-version."hash.js"."1.0.3" = self.buildNodePackage {
    name = "hash.js-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hash.js/-/hash.js-1.0.3.tgz";
      name = "hash.js-1.0.3.tgz";
      sha1 = "1332ff00156c0a0ffdd8236013d07b77a0451573";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
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
      url = "https://registry.npmjs.org/hawk/-/hawk-2.3.1.tgz";
      name = "hawk-2.3.1.tgz";
      sha1 = "1e731ce39447fa1d0f6d707f7bceebec0fd1ec1f";
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
  by-spec."htmlescape"."^1.1.0" =
    self.by-version."htmlescape"."1.1.1";
  by-version."htmlescape"."1.1.1" = self.buildNodePackage {
    name = "htmlescape-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/htmlescape/-/htmlescape-1.1.1.tgz";
      name = "htmlescape-1.1.1.tgz";
      sha1 = "3a03edc2214bca3b66424a3e7959349509cb0351";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."htmlparser2"."^3.9.0" =
    self.by-version."htmlparser2"."3.9.1";
  by-version."htmlparser2"."3.9.1" = self.buildNodePackage {
    name = "htmlparser2-3.9.1";
    version = "3.9.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/htmlparser2/-/htmlparser2-3.9.1.tgz";
      name = "htmlparser2-3.9.1.tgz";
      sha1 = "621b7a58bc9acd003f7af0a2c9a00aa67c8505d2";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
      "domhandler-2.3.0" = self.by-version."domhandler"."2.3.0";
      "domutils-1.5.1" = self.by-version."domutils"."1.5.1";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "readable-stream-2.1.4" = self.by-version."readable-stream"."2.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-browserify"."^1.4.0" =
    self.by-version."http-browserify"."1.7.0";
  by-version."http-browserify"."1.7.0" = self.buildNodePackage {
    name = "http-browserify-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/http-browserify/-/http-browserify-1.7.0.tgz";
      name = "http-browserify-1.7.0.tgz";
      sha1 = "33795ade72df88acfbfd36773cefeda764735b20";
    };
    deps = {
      "Base64-0.2.1" = self.by-version."Base64"."0.2.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
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
      url = "https://registry.npmjs.org/http-signature/-/http-signature-0.10.1.tgz";
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
      "jsprim-1.3.0" = self.by-version."jsprim"."1.3.0";
      "sshpk-1.8.3" = self.by-version."sshpk"."1.8.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."https-browserify"."~0.0.0" =
    self.by-version."https-browserify"."0.0.1";
  by-version."https-browserify"."0.0.1" = self.buildNodePackage {
    name = "https-browserify-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/https-browserify/-/https-browserify-0.0.1.tgz";
      name = "https-browserify-0.0.1.tgz";
      sha1 = "3f91365cabe60b77ed0ebba24b454e3e09d95a82";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv"."~2.1.6" =
    self.by-version."iconv"."2.1.11";
  by-version."iconv"."2.1.11" = self.buildNodePackage {
    name = "iconv-2.1.11";
    version = "2.1.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/iconv/-/iconv-2.1.11.tgz";
      name = "iconv-2.1.11.tgz";
      sha1 = "5f5da93a643506f5ceaa8bd9c78d6174f8b9351a";
    };
    deps = {
      "nan-2.0.9" = self.by-version."nan"."2.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."0.4.8" =
    self.by-version."iconv-lite"."0.4.8";
  by-version."iconv-lite"."0.4.8" = self.buildNodePackage {
    name = "iconv-lite-0.4.8";
    version = "0.4.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.8.tgz";
      name = "iconv-lite-0.4.8.tgz";
      sha1 = "c6019a7595f2cefca702eab694a010bcd9298d20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ieee754"."^1.1.4" =
    self.by-version."ieee754"."1.1.6";
  by-version."ieee754"."1.1.6" = self.buildNodePackage {
    name = "ieee754-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ieee754/-/ieee754-1.1.6.tgz";
      name = "ieee754-1.1.6.tgz";
      sha1 = "2e1013219c6d6712973ec54d981ec19e5579de97";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."immediate"."~3.0.5" =
    self.by-version."immediate"."3.0.5";
  by-version."immediate"."3.0.5" = self.buildNodePackage {
    name = "immediate-3.0.5";
    version = "3.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/immediate/-/immediate-3.0.5.tgz";
      name = "immediate-3.0.5.tgz";
      sha1 = "d6e01b480a9006a6e091bf56a7b7f6334c385ad9";
    };
    deps = {
      "inline-process-browser-1.0.0" = self.by-version."inline-process-browser"."1.0.0";
      "unreachable-branch-transform-0.3.0" = self.by-version."unreachable-branch-transform"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."indexof"."0.0.1" =
    self.by-version."indexof"."0.0.1";
  by-version."indexof"."0.0.1" = self.buildNodePackage {
    name = "indexof-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/indexof/-/indexof-0.0.1.tgz";
      name = "indexof-0.0.1.tgz";
      sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
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
    self.by-version."inflight"."1.0.5";
  by-version."inflight"."1.0.5" = self.buildNodePackage {
    name = "inflight-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inflight/-/inflight-1.0.5.tgz";
      name = "inflight-1.0.5.tgz";
      sha1 = "db3204cd5a9de2e6cd890b85c6e2f66bcf4f620a";
    };
    deps = {
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "wrappy-1.0.2" = self.by-version."wrappy"."1.0.2";
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
  by-spec."inherits"."2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."^2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inline-process-browser"."^1.0.0" =
    self.by-version."inline-process-browser"."1.0.0";
  by-version."inline-process-browser"."1.0.0" = self.buildNodePackage {
    name = "inline-process-browser-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inline-process-browser/-/inline-process-browser-1.0.0.tgz";
      name = "inline-process-browser-1.0.0.tgz";
      sha1 = "46a61b153dd3c9b1624b1a00626edb4f7f414f22";
    };
    deps = {
      "falafel-1.2.0" = self.by-version."falafel"."1.2.0";
      "through2-0.6.5" = self.by-version."through2"."0.6.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inline-source-map"."~0.5.0" =
    self.by-version."inline-source-map"."0.5.0";
  by-version."inline-source-map"."0.5.0" = self.buildNodePackage {
    name = "inline-source-map-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inline-source-map/-/inline-source-map-0.5.0.tgz";
      name = "inline-source-map-0.5.0.tgz";
      sha1 = "4a4c5dd8e4fb5e9b3cda60c822dfadcaee66e0af";
    };
    deps = {
      "source-map-0.4.4" = self.by-version."source-map"."0.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inquirer"."^0.11.0" =
    self.by-version."inquirer"."0.11.4";
  by-version."inquirer"."0.11.4" = self.buildNodePackage {
    name = "inquirer-0.11.4";
    version = "0.11.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inquirer/-/inquirer-0.11.4.tgz";
      name = "inquirer-0.11.4.tgz";
      sha1 = "81e3374e8361beaff2d97016206d359d0b32fa4d";
    };
    deps = {
      "ansi-escapes-1.4.0" = self.by-version."ansi-escapes"."1.4.0";
      "ansi-regex-2.0.0" = self.by-version."ansi-regex"."2.0.0";
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "cli-cursor-1.0.2" = self.by-version."cli-cursor"."1.0.2";
      "cli-width-1.1.1" = self.by-version."cli-width"."1.1.1";
      "figures-1.7.0" = self.by-version."figures"."1.7.0";
      "lodash-3.10.1" = self.by-version."lodash"."3.10.1";
      "readline2-1.0.1" = self.by-version."readline2"."1.0.1";
      "run-async-0.1.0" = self.by-version."run-async"."0.1.0";
      "rx-lite-3.1.2" = self.by-version."rx-lite"."3.1.2";
      "string-width-1.0.1" = self.by-version."string-width"."1.0.1";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."insert-module-globals"."^6.4.1" =
    self.by-version."insert-module-globals"."6.6.3";
  by-version."insert-module-globals"."6.6.3" = self.buildNodePackage {
    name = "insert-module-globals-6.6.3";
    version = "6.6.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/insert-module-globals/-/insert-module-globals-6.6.3.tgz";
      name = "insert-module-globals-6.6.3.tgz";
      sha1 = "20638e29a30f9ed1ca2e3a825fbc2cba5246ddfc";
    };
    deps = {
      "JSONStream-1.1.3" = self.by-version."JSONStream"."1.1.3";
      "combine-source-map-0.6.1" = self.by-version."combine-source-map"."0.6.1";
      "concat-stream-1.4.10" = self.by-version."concat-stream"."1.4.10";
      "is-buffer-1.1.3" = self.by-version."is-buffer"."1.1.3";
      "lexical-scope-1.2.0" = self.by-version."lexical-scope"."1.2.0";
      "process-0.11.5" = self.by-version."process"."0.11.5";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ipaddr.js"."1.0.5" =
    self.by-version."ipaddr.js"."1.0.5";
  by-version."ipaddr.js"."1.0.5" = self.buildNodePackage {
    name = "ipaddr.js-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.0.5.tgz";
      name = "ipaddr.js-1.0.5.tgz";
      sha1 = "5fa78cf301b825c78abc3042d812723049ea23c7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."irc"."matrix-org/node-irc#45d7ca190477bd545817e8152f2e626c9166cf6b" =
    self.by-version."irc"."0.3.12";
  by-version."irc"."0.3.12" = self.buildNodePackage {
    name = "irc-0.3.12";
    version = "0.3.12";
    bin = false;
    src = fetchgit {
      url = "git://github.com/matrix-org/node-irc.git";
      rev = "45d7ca190477bd545817e8152f2e626c9166cf6b";
      sha256 = "1jqj0y2g28wyihdyb6aw4pxljmb1y9dkdv4sjqb21ijspb6qfjss";
    };
    deps = {
      "irc-colors-1.3.0" = self.by-version."irc-colors"."1.3.0";
    };
    optionalDependencies = {
      "iconv-2.1.11" = self.by-version."iconv"."2.1.11";
      "node-icu-charset-detector-0.1.4" = self.by-version."node-icu-charset-detector"."0.1.4";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "irc" = self.by-version."irc"."0.3.12";
  by-spec."irc-colors"."^1.1.0" =
    self.by-version."irc-colors"."1.3.0";
  by-version."irc-colors"."1.3.0" = self.buildNodePackage {
    name = "irc-colors-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/irc-colors/-/irc-colors-1.3.0.tgz";
      name = "irc-colors-1.3.0.tgz";
      sha1 = "6e907b42be44ff6fc61d2d4a30b33f32259a7099";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-buffer"."^1.0.2" =
    self.by-version."is-buffer"."1.1.3";
  by-version."is-buffer"."1.1.3" = self.buildNodePackage {
    name = "is-buffer-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.3.tgz";
      name = "is-buffer-1.1.3.tgz";
      sha1 = "db897fc3f7aca2d50de94b6c8c2896a4771627af";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-buffer"."^1.1.0" =
    self.by-version."is-buffer"."1.1.3";
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
      "number-is-nan-1.0.0" = self.by-version."number-is-nan"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.10.0" =
    self.by-version."is-my-json-valid"."2.13.1";
  by-version."is-my-json-valid"."2.13.1" = self.buildNodePackage {
    name = "is-my-json-valid-2.13.1";
    version = "2.13.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.13.1.tgz";
      name = "is-my-json-valid-2.13.1.tgz";
      sha1 = "d55778a82feb6b0963ff4be111d5d1684e890707";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.2.0" = self.by-version."generate-object-property"."1.2.0";
      "jsonpointer-2.0.0" = self.by-version."jsonpointer"."2.0.0";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.12.4" =
    self.by-version."is-my-json-valid"."2.13.1";
  by-spec."is-object"."~1.0.1" =
    self.by-version."is-object"."1.0.1";
  by-version."is-object"."1.0.1" = self.buildNodePackage {
    name = "is-object-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-object/-/is-object-1.0.1.tgz";
      name = "is-object-1.0.1.tgz";
      sha1 = "8952688c5ec2ffd6b03ecc85e769e02903083470";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-path-cwd"."^1.0.0" =
    self.by-version."is-path-cwd"."1.0.0";
  by-version."is-path-cwd"."1.0.0" = self.buildNodePackage {
    name = "is-path-cwd-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-path-cwd/-/is-path-cwd-1.0.0.tgz";
      name = "is-path-cwd-1.0.0.tgz";
      sha1 = "d225ec23132e89edd38fda767472e62e65f1106d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-path-in-cwd"."^1.0.0" =
    self.by-version."is-path-in-cwd"."1.0.0";
  by-version."is-path-in-cwd"."1.0.0" = self.buildNodePackage {
    name = "is-path-in-cwd-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-1.0.0.tgz";
      name = "is-path-in-cwd-1.0.0.tgz";
      sha1 = "6477582b8214d602346094567003be8a9eac04dc";
    };
    deps = {
      "is-path-inside-1.0.0" = self.by-version."is-path-inside"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-path-inside"."^1.0.0" =
    self.by-version."is-path-inside"."1.0.0";
  by-version."is-path-inside"."1.0.0" = self.buildNodePackage {
    name = "is-path-inside-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-path-inside/-/is-path-inside-1.0.0.tgz";
      name = "is-path-inside-1.0.0.tgz";
      sha1 = "fc06e5a1683fbda13de667aff717bbc10a48f37f";
    };
    deps = {
      "path-is-inside-1.0.1" = self.by-version."path-is-inside"."1.0.1";
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
  by-spec."is-resolvable"."^1.0.0" =
    self.by-version."is-resolvable"."1.0.0";
  by-version."is-resolvable"."1.0.0" = self.buildNodePackage {
    name = "is-resolvable-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-resolvable/-/is-resolvable-1.0.0.tgz";
      name = "is-resolvable-1.0.0.tgz";
      sha1 = "8df57c61ea2e3c501408d100fb013cf8d6e0cc62";
    };
    deps = {
      "tryit-1.0.2" = self.by-version."tryit"."1.0.2";
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
  by-spec."isarray"."^1.0.0" =
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
  by-spec."isarray"."~0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-spec."isarray"."~1.0.0" =
    self.by-version."isarray"."1.0.0";
  by-spec."isexe"."^1.1.1" =
    self.by-version."isexe"."1.1.2";
  by-version."isexe"."1.1.2" = self.buildNodePackage {
    name = "isexe-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isexe/-/isexe-1.1.2.tgz";
      name = "isexe-1.1.2.tgz";
      sha1 = "36f3e22e60750920f5e7241a476a8c6a42275ad0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isstream"."0.1.x" =
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
  by-spec."isstream"."~0.1.1" =
    self.by-version."isstream"."0.1.2";
  by-spec."isstream"."~0.1.2" =
    self.by-version."isstream"."0.1.2";
  by-spec."istanbul"."^0.3.17" =
    self.by-version."istanbul"."0.3.22";
  by-version."istanbul"."0.3.22" = self.buildNodePackage {
    name = "istanbul-0.3.22";
    version = "0.3.22";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/istanbul/-/istanbul-0.3.22.tgz";
      name = "istanbul-0.3.22.tgz";
      sha1 = "3e164d85021fe19c985d1f0e7ef0c3e22d012eb6";
    };
    deps = {
      "abbrev-1.0.9" = self.by-version."abbrev"."1.0.9";
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "escodegen-1.7.1" = self.by-version."escodegen"."1.7.1";
      "esprima-2.5.0" = self.by-version."esprima"."2.5.0";
      "fileset-0.2.1" = self.by-version."fileset"."0.2.1";
      "handlebars-4.0.5" = self.by-version."handlebars"."4.0.5";
      "js-yaml-3.6.1" = self.by-version."js-yaml"."3.6.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "resolve-1.1.7" = self.by-version."resolve"."1.1.7";
      "supports-color-3.1.2" = self.by-version."supports-color"."3.1.2";
      "which-1.2.10" = self.by-version."which"."1.2.10";
      "wordwrap-1.0.0" = self.by-version."wordwrap"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "istanbul" = self.by-version."istanbul"."0.3.22";
  by-spec."jasmine-growl-reporter"."~0.0.2" =
    self.by-version."jasmine-growl-reporter"."0.0.3";
  by-version."jasmine-growl-reporter"."0.0.3" = self.buildNodePackage {
    name = "jasmine-growl-reporter-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jasmine-growl-reporter/-/jasmine-growl-reporter-0.0.3.tgz";
      name = "jasmine-growl-reporter-0.0.3.tgz";
      sha1 = "b87ae551e359d28ad5217765eaef6c07b763f6c8";
    };
    deps = {
      "growl-1.7.0" = self.by-version."growl"."1.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jasmine-node"."^1.14.5" =
    self.by-version."jasmine-node"."1.14.5";
  by-version."jasmine-node"."1.14.5" = self.buildNodePackage {
    name = "jasmine-node-1.14.5";
    version = "1.14.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/jasmine-node/-/jasmine-node-1.14.5.tgz";
      name = "jasmine-node-1.14.5.tgz";
      sha1 = "18e8397b856924ee77003666c3731b5aea50c39d";
    };
    deps = {
      "coffee-script-1.10.0" = self.by-version."coffee-script"."1.10.0";
      "jasmine-reporters-1.0.2" = self.by-version."jasmine-reporters"."1.0.2";
      "jasmine-growl-reporter-0.0.3" = self.by-version."jasmine-growl-reporter"."0.0.3";
      "requirejs-2.2.0" = self.by-version."requirejs"."2.2.0";
      "walkdir-0.0.11" = self.by-version."walkdir"."0.0.11";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "gaze-0.3.4" = self.by-version."gaze"."0.3.4";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "jasmine-node" = self.by-version."jasmine-node"."1.14.5";
  by-spec."jasmine-reporters"."~1.0.0" =
    self.by-version."jasmine-reporters"."1.0.2";
  by-version."jasmine-reporters"."1.0.2" = self.buildNodePackage {
    name = "jasmine-reporters-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jasmine-reporters/-/jasmine-reporters-1.0.2.tgz";
      name = "jasmine-reporters-1.0.2.tgz";
      sha1 = "ab613ed5977dc7487e85b3c12f6a8ea8db2ade31";
    };
    deps = {
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jayschema"."^0.3.1" =
    self.by-version."jayschema"."0.3.1";
  by-version."jayschema"."0.3.1" = self.buildNodePackage {
    name = "jayschema-0.3.1";
    version = "0.3.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/jayschema/-/jayschema-0.3.1.tgz";
      name = "jayschema-0.3.1.tgz";
      sha1 = "76f4769f9b172ef7d5dcde4875b49cb736179b58";
    };
    deps = {
      "when-3.4.6" = self.by-version."when"."3.4.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "jayschema" = self.by-version."jayschema"."0.3.1";
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
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-yaml"."3.4.5" =
    self.by-version."js-yaml"."3.4.5";
  by-version."js-yaml"."3.4.5" = self.buildNodePackage {
    name = "js-yaml-3.4.5";
    version = "3.4.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/js-yaml/-/js-yaml-3.4.5.tgz";
      name = "js-yaml-3.4.5.tgz";
      sha1 = "c3403797df12b91866574f2de23646fe8cafb44d";
    };
    deps = {
      "argparse-1.0.7" = self.by-version."argparse"."1.0.7";
      "esprima-2.7.2" = self.by-version."esprima"."2.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-yaml"."3.x" =
    self.by-version."js-yaml"."3.6.1";
  by-version."js-yaml"."3.6.1" = self.buildNodePackage {
    name = "js-yaml-3.6.1";
    version = "3.6.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/js-yaml/-/js-yaml-3.6.1.tgz";
      name = "js-yaml-3.6.1.tgz";
      sha1 = "6e5fe67d8b205ce4d22fad05b7781e8dadcc4b30";
    };
    deps = {
      "argparse-1.0.7" = self.by-version."argparse"."1.0.7";
      "esprima-2.7.2" = self.by-version."esprima"."2.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-yaml"."^3.2.7" =
    self.by-version."js-yaml"."3.6.1";
  "js-yaml" = self.by-version."js-yaml"."3.6.1";
  by-spec."js-yaml"."^3.4.0" =
    self.by-version."js-yaml"."3.6.1";
  by-spec."jsbn"."~0.1.0" =
    self.by-version."jsbn"."0.1.0";
  by-version."jsbn"."0.1.0" = self.buildNodePackage {
    name = "jsbn-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsbn/-/jsbn-0.1.0.tgz";
      name = "jsbn-0.1.0.tgz";
      sha1 = "650987da0dd74f4ebf5a11377a2aa2d273e97dfd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-schema"."0.2.2" =
    self.by-version."json-schema"."0.2.2";
  by-version."json-schema"."0.2.2" = self.buildNodePackage {
    name = "json-schema-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
      name = "json-schema-0.2.2.tgz";
      sha1 = "50354f19f603917c695f70b85afa77c3b0f23506";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stable-stringify"."^1.0.0" =
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
  by-spec."json-stable-stringify"."~0.0.0" =
    self.by-version."json-stable-stringify"."0.0.1";
  by-version."json-stable-stringify"."0.0.1" = self.buildNodePackage {
    name = "json-stable-stringify-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-stable-stringify/-/json-stable-stringify-0.0.1.tgz";
      name = "json-stable-stringify-0.0.1.tgz";
      sha1 = "611c23e814db375527df851193db59dd2af27f45";
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
  by-spec."json-stringify-safe"."~5.0.0" =
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
  by-spec."json-stringify-safe"."~5.0.1" =
    self.by-version."json-stringify-safe"."5.0.1";
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
  by-spec."jsonparse"."^1.1.0" =
    self.by-version."jsonparse"."1.2.0";
  by-version."jsonparse"."1.2.0" = self.buildNodePackage {
    name = "jsonparse-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonparse/-/jsonparse-1.2.0.tgz";
      name = "jsonparse-1.2.0.tgz";
      sha1 = "5c0c5685107160e72fe7489bddea0b44c2bc67bd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonpointer"."2.0.0" =
    self.by-version."jsonpointer"."2.0.0";
  by-version."jsonpointer"."2.0.0" = self.buildNodePackage {
    name = "jsonpointer-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonpointer/-/jsonpointer-2.0.0.tgz";
      name = "jsonpointer-2.0.0.tgz";
      sha1 = "3af1dd20fe85463910d469a385e33017d2a030d9";
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
    self.by-version."jsprim"."1.3.0";
  by-version."jsprim"."1.3.0" = self.buildNodePackage {
    name = "jsprim-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsprim/-/jsprim-1.3.0.tgz";
      name = "jsprim-1.3.0.tgz";
      sha1 = "ce2e1bef835204b4f3099928c602f8b6ae615650";
    };
    deps = {
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
      "json-schema-0.2.2" = self.by-version."json-schema"."0.2.2";
      "verror-1.3.6" = self.by-version."verror"."1.3.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jstransform"."~3.0.0" =
    self.by-version."jstransform"."3.0.0";
  by-version."jstransform"."3.0.0" = self.buildNodePackage {
    name = "jstransform-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jstransform/-/jstransform-3.0.0.tgz";
      name = "jstransform-3.0.0.tgz";
      sha1 = "a2591ab6cee8d97bf3be830dbfa2313b87cd640b";
    };
    deps = {
      "base62-0.1.1" = self.by-version."base62"."0.1.1";
      "esprima-fb-3001.1.0-dev-harmony-fb" = self.by-version."esprima-fb"."3001.1.0-dev-harmony-fb";
      "source-map-0.1.31" = self.by-version."source-map"."0.1.31";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kind-of"."^3.0.2" =
    self.by-version."kind-of"."3.0.3";
  by-version."kind-of"."3.0.3" = self.buildNodePackage {
    name = "kind-of-3.0.3";
    version = "3.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/kind-of/-/kind-of-3.0.3.tgz";
      name = "kind-of-3.0.3.tgz";
      sha1 = "c61608747d815b0362556db3276362a7a38aded3";
    };
    deps = {
      "is-buffer-1.1.3" = self.by-version."is-buffer"."1.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."labeled-stream-splicer"."^1.0.0" =
    self.by-version."labeled-stream-splicer"."1.0.2";
  by-version."labeled-stream-splicer"."1.0.2" = self.buildNodePackage {
    name = "labeled-stream-splicer-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/labeled-stream-splicer/-/labeled-stream-splicer-1.0.2.tgz";
      name = "labeled-stream-splicer-1.0.2.tgz";
      sha1 = "4615331537784981e8fd264e1f3a434c4e0ddd65";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "stream-splicer-1.3.2" = self.by-version."stream-splicer"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."levn"."~0.2.5" =
    self.by-version."levn"."0.2.5";
  by-version."levn"."0.2.5" = self.buildNodePackage {
    name = "levn-0.2.5";
    version = "0.2.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/levn/-/levn-0.2.5.tgz";
      name = "levn-0.2.5.tgz";
      sha1 = "ba8d339d0ca4a610e3a3f145b9caf48807155054";
    };
    deps = {
      "prelude-ls-1.1.2" = self.by-version."prelude-ls"."1.1.2";
      "type-check-0.3.2" = self.by-version."type-check"."0.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lexical-scope"."^1.2.0" =
    self.by-version."lexical-scope"."1.2.0";
  by-version."lexical-scope"."1.2.0" = self.buildNodePackage {
    name = "lexical-scope-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lexical-scope/-/lexical-scope-1.2.0.tgz";
      name = "lexical-scope-1.2.0.tgz";
      sha1 = "fcea5edc704a4b3a8796cdca419c3a0afaf22df4";
    };
    deps = {
      "astw-2.0.0" = self.by-version."astw"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lie"."3.0.2" =
    self.by-version."lie"."3.0.2";
  by-version."lie"."3.0.2" = self.buildNodePackage {
    name = "lie-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lie/-/lie-3.0.2.tgz";
      name = "lie-3.0.2.tgz";
      sha1 = "ffda21d7bba26f377cad865d3649b2fc8ce39fea";
    };
    deps = {
      "es3ify-0.1.4" = self.by-version."es3ify"."0.1.4";
      "immediate-3.0.5" = self.by-version."immediate"."3.0.5";
      "inline-process-browser-1.0.0" = self.by-version."inline-process-browser"."1.0.0";
      "unreachable-branch-transform-0.3.0" = self.by-version."unreachable-branch-transform"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."localforage"."^1.3.0" =
    self.by-version."localforage"."1.4.2";
  by-version."localforage"."1.4.2" = self.buildNodePackage {
    name = "localforage-1.4.2";
    version = "1.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/localforage/-/localforage-1.4.2.tgz";
      name = "localforage-1.4.2.tgz";
      sha1 = "5fae8a91d146d1ea9b4c6dcd0eddebdcf6a61653";
    };
    deps = {
      "lie-3.0.2" = self.by-version."lie"."3.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."^3.3.1" =
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
  by-spec."lodash._arraycopy"."^3.0.0" =
    self.by-version."lodash._arraycopy"."3.0.0";
  by-version."lodash._arraycopy"."3.0.0" = self.buildNodePackage {
    name = "lodash._arraycopy-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._arraycopy/-/lodash._arraycopy-3.0.0.tgz";
      name = "lodash._arraycopy-3.0.0.tgz";
      sha1 = "76e7b7c1f1fb92547374878a562ed06a3e50f6e1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._arrayeach"."^3.0.0" =
    self.by-version."lodash._arrayeach"."3.0.0";
  by-version."lodash._arrayeach"."3.0.0" = self.buildNodePackage {
    name = "lodash._arrayeach-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._arrayeach/-/lodash._arrayeach-3.0.0.tgz";
      name = "lodash._arrayeach-3.0.0.tgz";
      sha1 = "bab156b2a90d3f1bbd5c653403349e5e5933ef9e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._arraymap"."^3.0.0" =
    self.by-version."lodash._arraymap"."3.0.0";
  by-version."lodash._arraymap"."3.0.0" = self.buildNodePackage {
    name = "lodash._arraymap-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._arraymap/-/lodash._arraymap-3.0.0.tgz";
      name = "lodash._arraymap-3.0.0.tgz";
      sha1 = "1a8fd0f4c0df4b61dea076d717cdc97f0a3c3e66";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._baseassign"."^3.0.0" =
    self.by-version."lodash._baseassign"."3.2.0";
  by-version."lodash._baseassign"."3.2.0" = self.buildNodePackage {
    name = "lodash._baseassign-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._baseassign/-/lodash._baseassign-3.2.0.tgz";
      name = "lodash._baseassign-3.2.0.tgz";
      sha1 = "8c38a099500f215ad09e59f1722fd0c52bfe0a4e";
    };
    deps = {
      "lodash._basecopy-3.0.1" = self.by-version."lodash._basecopy"."3.0.1";
      "lodash.keys-3.1.2" = self.by-version."lodash.keys"."3.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._baseclone"."^3.0.0" =
    self.by-version."lodash._baseclone"."3.3.0";
  by-version."lodash._baseclone"."3.3.0" = self.buildNodePackage {
    name = "lodash._baseclone-3.3.0";
    version = "3.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._baseclone/-/lodash._baseclone-3.3.0.tgz";
      name = "lodash._baseclone-3.3.0.tgz";
      sha1 = "303519bf6393fe7e42f34d8b630ef7794e3542b7";
    };
    deps = {
      "lodash._arraycopy-3.0.0" = self.by-version."lodash._arraycopy"."3.0.0";
      "lodash._arrayeach-3.0.0" = self.by-version."lodash._arrayeach"."3.0.0";
      "lodash._baseassign-3.2.0" = self.by-version."lodash._baseassign"."3.2.0";
      "lodash._basefor-3.0.3" = self.by-version."lodash._basefor"."3.0.3";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
      "lodash.keys-3.1.2" = self.by-version."lodash.keys"."3.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._basecopy"."^3.0.0" =
    self.by-version."lodash._basecopy"."3.0.1";
  by-version."lodash._basecopy"."3.0.1" = self.buildNodePackage {
    name = "lodash._basecopy-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._basecopy/-/lodash._basecopy-3.0.1.tgz";
      name = "lodash._basecopy-3.0.1.tgz";
      sha1 = "8da0e6a876cf344c0ad8a54882111dd3c5c7ca36";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._basedifference"."^3.0.0" =
    self.by-version."lodash._basedifference"."3.0.3";
  by-version."lodash._basedifference"."3.0.3" = self.buildNodePackage {
    name = "lodash._basedifference-3.0.3";
    version = "3.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._basedifference/-/lodash._basedifference-3.0.3.tgz";
      name = "lodash._basedifference-3.0.3.tgz";
      sha1 = "f2c204296c2a78e02b389081b6edcac933cf629c";
    };
    deps = {
      "lodash._baseindexof-3.1.0" = self.by-version."lodash._baseindexof"."3.1.0";
      "lodash._cacheindexof-3.0.2" = self.by-version."lodash._cacheindexof"."3.0.2";
      "lodash._createcache-3.1.2" = self.by-version."lodash._createcache"."3.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._baseflatten"."^3.0.0" =
    self.by-version."lodash._baseflatten"."3.1.4";
  by-version."lodash._baseflatten"."3.1.4" = self.buildNodePackage {
    name = "lodash._baseflatten-3.1.4";
    version = "3.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._baseflatten/-/lodash._baseflatten-3.1.4.tgz";
      name = "lodash._baseflatten-3.1.4.tgz";
      sha1 = "0770ff80131af6e34f3b511796a7ba5214e65ff7";
    };
    deps = {
      "lodash.isarguments-3.0.8" = self.by-version."lodash.isarguments"."3.0.8";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._basefor"."^3.0.0" =
    self.by-version."lodash._basefor"."3.0.3";
  by-version."lodash._basefor"."3.0.3" = self.buildNodePackage {
    name = "lodash._basefor-3.0.3";
    version = "3.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._basefor/-/lodash._basefor-3.0.3.tgz";
      name = "lodash._basefor-3.0.3.tgz";
      sha1 = "7550b4e9218ef09fad24343b612021c79b4c20c2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._baseindexof"."^3.0.0" =
    self.by-version."lodash._baseindexof"."3.1.0";
  by-version."lodash._baseindexof"."3.1.0" = self.buildNodePackage {
    name = "lodash._baseindexof-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._baseindexof/-/lodash._baseindexof-3.1.0.tgz";
      name = "lodash._baseindexof-3.1.0.tgz";
      sha1 = "fe52b53a1c6761e42618d654e4a25789ed61822c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._bindcallback"."^3.0.0" =
    self.by-version."lodash._bindcallback"."3.0.1";
  by-version."lodash._bindcallback"."3.0.1" = self.buildNodePackage {
    name = "lodash._bindcallback-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._bindcallback/-/lodash._bindcallback-3.0.1.tgz";
      name = "lodash._bindcallback-3.0.1.tgz";
      sha1 = "e531c27644cf8b57a99e17ed95b35c748789392e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._cacheindexof"."^3.0.0" =
    self.by-version."lodash._cacheindexof"."3.0.2";
  by-version."lodash._cacheindexof"."3.0.2" = self.buildNodePackage {
    name = "lodash._cacheindexof-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._cacheindexof/-/lodash._cacheindexof-3.0.2.tgz";
      name = "lodash._cacheindexof-3.0.2.tgz";
      sha1 = "3dc69ac82498d2ee5e3ce56091bafd2adc7bde92";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._createassigner"."^3.0.0" =
    self.by-version."lodash._createassigner"."3.1.1";
  by-version."lodash._createassigner"."3.1.1" = self.buildNodePackage {
    name = "lodash._createassigner-3.1.1";
    version = "3.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._createassigner/-/lodash._createassigner-3.1.1.tgz";
      name = "lodash._createassigner-3.1.1.tgz";
      sha1 = "838a5bae2fdaca63ac22dee8e19fa4e6d6970b11";
    };
    deps = {
      "lodash._bindcallback-3.0.1" = self.by-version."lodash._bindcallback"."3.0.1";
      "lodash._isiterateecall-3.0.9" = self.by-version."lodash._isiterateecall"."3.0.9";
      "lodash.restparam-3.6.1" = self.by-version."lodash.restparam"."3.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._createcache"."^3.0.0" =
    self.by-version."lodash._createcache"."3.1.2";
  by-version."lodash._createcache"."3.1.2" = self.buildNodePackage {
    name = "lodash._createcache-3.1.2";
    version = "3.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._createcache/-/lodash._createcache-3.1.2.tgz";
      name = "lodash._createcache-3.1.2.tgz";
      sha1 = "56d6a064017625e79ebca6b8018e17440bdcf093";
    };
    deps = {
      "lodash._getnative-3.9.1" = self.by-version."lodash._getnative"."3.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._getnative"."^3.0.0" =
    self.by-version."lodash._getnative"."3.9.1";
  by-version."lodash._getnative"."3.9.1" = self.buildNodePackage {
    name = "lodash._getnative-3.9.1";
    version = "3.9.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._getnative/-/lodash._getnative-3.9.1.tgz";
      name = "lodash._getnative-3.9.1.tgz";
      sha1 = "570bc7dede46d61cdcde687d65d3eecbaa3aaff5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._isiterateecall"."^3.0.0" =
    self.by-version."lodash._isiterateecall"."3.0.9";
  by-version."lodash._isiterateecall"."3.0.9" = self.buildNodePackage {
    name = "lodash._isiterateecall-3.0.9";
    version = "3.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._isiterateecall/-/lodash._isiterateecall-3.0.9.tgz";
      name = "lodash._isiterateecall-3.0.9.tgz";
      sha1 = "5203ad7ba425fae842460e696db9cf3e6aac057c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._pickbyarray"."^3.0.0" =
    self.by-version."lodash._pickbyarray"."3.0.2";
  by-version."lodash._pickbyarray"."3.0.2" = self.buildNodePackage {
    name = "lodash._pickbyarray-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._pickbyarray/-/lodash._pickbyarray-3.0.2.tgz";
      name = "lodash._pickbyarray-3.0.2.tgz";
      sha1 = "1f898d9607eb560b0e167384b77c7c6d108aa4c5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._pickbycallback"."^3.0.0" =
    self.by-version."lodash._pickbycallback"."3.0.0";
  by-version."lodash._pickbycallback"."3.0.0" = self.buildNodePackage {
    name = "lodash._pickbycallback-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash._pickbycallback/-/lodash._pickbycallback-3.0.0.tgz";
      name = "lodash._pickbycallback-3.0.0.tgz";
      sha1 = "ff61b9a017a7b3af7d30e6c53de28afa19b8750a";
    };
    deps = {
      "lodash._basefor-3.0.3" = self.by-version."lodash._basefor"."3.0.3";
      "lodash.keysin-3.0.8" = self.by-version."lodash.keysin"."3.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.clonedeep"."^3.0.1" =
    self.by-version."lodash.clonedeep"."3.0.2";
  by-version."lodash.clonedeep"."3.0.2" = self.buildNodePackage {
    name = "lodash.clonedeep-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-3.0.2.tgz";
      name = "lodash.clonedeep-3.0.2.tgz";
      sha1 = "a0a1e40d82a5ea89ff5b147b8444ed63d92827db";
    };
    deps = {
      "lodash._baseclone-3.3.0" = self.by-version."lodash._baseclone"."3.3.0";
      "lodash._bindcallback-3.0.1" = self.by-version."lodash._bindcallback"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.isarguments"."^3.0.0" =
    self.by-version."lodash.isarguments"."3.0.8";
  by-version."lodash.isarguments"."3.0.8" = self.buildNodePackage {
    name = "lodash.isarguments-3.0.8";
    version = "3.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.isarguments/-/lodash.isarguments-3.0.8.tgz";
      name = "lodash.isarguments-3.0.8.tgz";
      sha1 = "5bf8da887f01f2a9e49c0a175cdaeb318a0e43dc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.isarray"."^3.0.0" =
    self.by-version."lodash.isarray"."3.0.4";
  by-version."lodash.isarray"."3.0.4" = self.buildNodePackage {
    name = "lodash.isarray-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.isarray/-/lodash.isarray-3.0.4.tgz";
      name = "lodash.isarray-3.0.4.tgz";
      sha1 = "79e4eb88c36a8122af86f844aa9bcd851b5fbb55";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.isplainobject"."^3.0.0" =
    self.by-version."lodash.isplainobject"."3.2.0";
  by-version."lodash.isplainobject"."3.2.0" = self.buildNodePackage {
    name = "lodash.isplainobject-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.isplainobject/-/lodash.isplainobject-3.2.0.tgz";
      name = "lodash.isplainobject-3.2.0.tgz";
      sha1 = "9a8238ae16b200432960cd7346512d0123fbf4c5";
    };
    deps = {
      "lodash._basefor-3.0.3" = self.by-version."lodash._basefor"."3.0.3";
      "lodash.isarguments-3.0.8" = self.by-version."lodash.isarguments"."3.0.8";
      "lodash.keysin-3.0.8" = self.by-version."lodash.keysin"."3.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.istypedarray"."^3.0.0" =
    self.by-version."lodash.istypedarray"."3.0.6";
  by-version."lodash.istypedarray"."3.0.6" = self.buildNodePackage {
    name = "lodash.istypedarray-3.0.6";
    version = "3.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.istypedarray/-/lodash.istypedarray-3.0.6.tgz";
      name = "lodash.istypedarray-3.0.6.tgz";
      sha1 = "c9a477498607501d8e8494d283b87c39281cef62";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.keys"."^3.0.0" =
    self.by-version."lodash.keys"."3.1.2";
  by-version."lodash.keys"."3.1.2" = self.buildNodePackage {
    name = "lodash.keys-3.1.2";
    version = "3.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.keys/-/lodash.keys-3.1.2.tgz";
      name = "lodash.keys-3.1.2.tgz";
      sha1 = "4dbc0472b156be50a0b286855d1bd0b0c656098a";
    };
    deps = {
      "lodash._getnative-3.9.1" = self.by-version."lodash._getnative"."3.9.1";
      "lodash.isarguments-3.0.8" = self.by-version."lodash.isarguments"."3.0.8";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.keysin"."^3.0.0" =
    self.by-version."lodash.keysin"."3.0.8";
  by-version."lodash.keysin"."3.0.8" = self.buildNodePackage {
    name = "lodash.keysin-3.0.8";
    version = "3.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.keysin/-/lodash.keysin-3.0.8.tgz";
      name = "lodash.keysin-3.0.8.tgz";
      sha1 = "22c4493ebbedb1427962a54b445b2c8a767fb47f";
    };
    deps = {
      "lodash.isarguments-3.0.8" = self.by-version."lodash.isarguments"."3.0.8";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.memoize"."~3.0.3" =
    self.by-version."lodash.memoize"."3.0.4";
  by-version."lodash.memoize"."3.0.4" = self.buildNodePackage {
    name = "lodash.memoize-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.memoize/-/lodash.memoize-3.0.4.tgz";
      name = "lodash.memoize-3.0.4.tgz";
      sha1 = "2dcbd2c287cbc0a55cc42328bd0c736150d53e3f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.merge"."^3.3.2" =
    self.by-version."lodash.merge"."3.3.2";
  by-version."lodash.merge"."3.3.2" = self.buildNodePackage {
    name = "lodash.merge-3.3.2";
    version = "3.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.merge/-/lodash.merge-3.3.2.tgz";
      name = "lodash.merge-3.3.2.tgz";
      sha1 = "0d90d93ed637b1878437bb3e21601260d7afe994";
    };
    deps = {
      "lodash._arraycopy-3.0.0" = self.by-version."lodash._arraycopy"."3.0.0";
      "lodash._arrayeach-3.0.0" = self.by-version."lodash._arrayeach"."3.0.0";
      "lodash._createassigner-3.1.1" = self.by-version."lodash._createassigner"."3.1.1";
      "lodash._getnative-3.9.1" = self.by-version."lodash._getnative"."3.9.1";
      "lodash.isarguments-3.0.8" = self.by-version."lodash.isarguments"."3.0.8";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
      "lodash.isplainobject-3.2.0" = self.by-version."lodash.isplainobject"."3.2.0";
      "lodash.istypedarray-3.0.6" = self.by-version."lodash.istypedarray"."3.0.6";
      "lodash.keys-3.1.2" = self.by-version."lodash.keys"."3.1.2";
      "lodash.keysin-3.0.8" = self.by-version."lodash.keysin"."3.0.8";
      "lodash.toplainobject-3.0.0" = self.by-version."lodash.toplainobject"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.omit"."^3.1.0" =
    self.by-version."lodash.omit"."3.1.0";
  by-version."lodash.omit"."3.1.0" = self.buildNodePackage {
    name = "lodash.omit-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.omit/-/lodash.omit-3.1.0.tgz";
      name = "lodash.omit-3.1.0.tgz";
      sha1 = "897fe382e6413d9ac97c61f78ed1e057a00af9f3";
    };
    deps = {
      "lodash._arraymap-3.0.0" = self.by-version."lodash._arraymap"."3.0.0";
      "lodash._basedifference-3.0.3" = self.by-version."lodash._basedifference"."3.0.3";
      "lodash._baseflatten-3.1.4" = self.by-version."lodash._baseflatten"."3.1.4";
      "lodash._bindcallback-3.0.1" = self.by-version."lodash._bindcallback"."3.0.1";
      "lodash._pickbyarray-3.0.2" = self.by-version."lodash._pickbyarray"."3.0.2";
      "lodash._pickbycallback-3.0.0" = self.by-version."lodash._pickbycallback"."3.0.0";
      "lodash.keysin-3.0.8" = self.by-version."lodash.keysin"."3.0.8";
      "lodash.restparam-3.6.1" = self.by-version."lodash.restparam"."3.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.restparam"."^3.0.0" =
    self.by-version."lodash.restparam"."3.6.1";
  by-version."lodash.restparam"."3.6.1" = self.buildNodePackage {
    name = "lodash.restparam-3.6.1";
    version = "3.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.restparam/-/lodash.restparam-3.6.1.tgz";
      name = "lodash.restparam-3.6.1.tgz";
      sha1 = "936a4e309ef330a7645ed4145986c85ae5b20805";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.toplainobject"."^3.0.0" =
    self.by-version."lodash.toplainobject"."3.0.0";
  by-version."lodash.toplainobject"."3.0.0" = self.buildNodePackage {
    name = "lodash.toplainobject-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.toplainobject/-/lodash.toplainobject-3.0.0.tgz";
      name = "lodash.toplainobject-3.0.0.tgz";
      sha1 = "28790ad942d293d78aa663a07ecf7f52ca04198d";
    };
    deps = {
      "lodash._basecopy-3.0.1" = self.by-version."lodash._basecopy"."3.0.1";
      "lodash.keysin-3.0.8" = self.by-version."lodash.keysin"."3.0.8";
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
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.7.3";
  by-version."lru-cache"."2.7.3" = self.buildNodePackage {
    name = "lru-cache-2.7.3";
    version = "2.7.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lru-cache/-/lru-cache-2.7.3.tgz";
      name = "lru-cache-2.7.3.tgz";
      sha1 = "6d4524e8b955f95d4f5b58851ce21dd72fb4e952";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."matrix-appservice"."^0.3.1" =
    self.by-version."matrix-appservice"."0.3.2";
  by-version."matrix-appservice"."0.3.2" = self.buildNodePackage {
    name = "matrix-appservice-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/matrix-appservice/-/matrix-appservice-0.3.2.tgz";
      name = "matrix-appservice-0.3.2.tgz";
      sha1 = "2706677b722bb82df396c77fcddf54a655ededc1";
    };
    deps = {
      "body-parser-1.12.4" = self.by-version."body-parser"."1.12.4";
      "express-4.12.4" = self.by-version."express"."4.12.4";
      "js-yaml-3.6.1" = self.by-version."js-yaml"."3.6.1";
      "morgan-1.5.3" = self.by-version."morgan"."1.5.3";
      "request-2.53.0" = self.by-version."request"."2.53.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."matrix-appservice-bridge"."^1.0.1" =
    self.by-version."matrix-appservice-bridge"."1.1.1";
  by-version."matrix-appservice-bridge"."1.1.1" = self.buildNodePackage {
    name = "matrix-appservice-bridge-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/matrix-appservice-bridge/-/matrix-appservice-bridge-1.1.1.tgz";
      name = "matrix-appservice-bridge-1.1.1.tgz";
      sha1 = "54c5e54f3373a3899f92845345ab518da0b63df1";
    };
    deps = {
      "bluebird-2.10.2" = self.by-version."bluebird"."2.10.2";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "jayschema-0.3.1" = self.by-version."jayschema"."0.3.1";
      "js-yaml-3.6.1" = self.by-version."js-yaml"."3.6.1";
      "matrix-appservice-0.3.2" = self.by-version."matrix-appservice"."0.3.2";
      "matrix-js-sdk-0.4.1" = self.by-version."matrix-js-sdk"."0.4.1";
      "nedb-1.8.0" = self.by-version."nedb"."1.8.0";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
      "request-2.73.0" = self.by-version."request"."2.73.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "matrix-appservice-bridge" = self.by-version."matrix-appservice-bridge"."1.1.1";
  by-spec."matrix-js-sdk"."0.4.1" =
    self.by-version."matrix-js-sdk"."0.4.1";
  by-version."matrix-js-sdk"."0.4.1" = self.buildNodePackage {
    name = "matrix-js-sdk-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/matrix-js-sdk/-/matrix-js-sdk-0.4.1.tgz";
      name = "matrix-js-sdk-0.4.1.tgz";
      sha1 = "e371ae931799ce4b65d807a5b8cdee21ceb1e509";
    };
    deps = {
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
      "browserify-10.2.6" = self.by-version."browserify"."10.2.6";
      "q-1.4.1" = self.by-version."q"."1.4.1";
      "request-2.73.0" = self.by-version."request"."2.73.0";
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
  by-spec."merge-descriptors"."1.0.0" =
    self.by-version."merge-descriptors"."1.0.0";
  by-version."merge-descriptors"."1.0.0" = self.buildNodePackage {
    name = "merge-descriptors-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.0.tgz";
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
  by-spec."merge-descriptors"."~1.0.0" =
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
  by-spec."methods"."~1.1.1" =
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
  by-spec."miller-rabin"."^4.0.0" =
    self.by-version."miller-rabin"."4.0.0";
  by-version."miller-rabin"."4.0.0" = self.buildNodePackage {
    name = "miller-rabin-4.0.0";
    version = "4.0.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/miller-rabin/-/miller-rabin-4.0.0.tgz";
      name = "miller-rabin-4.0.0.tgz";
      sha1 = "4a62fb1d42933c05583982f4c716f6fb9e6c6d3d";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "brorand-1.0.5" = self.by-version."brorand"."1.0.5";
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
  by-spec."mime-db"."~1.12.0" =
    self.by-version."mime-db"."1.12.0";
  by-version."mime-db"."1.12.0" = self.buildNodePackage {
    name = "mime-db-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.12.0.tgz";
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
  by-spec."mime-db"."~1.23.0" =
    self.by-version."mime-db"."1.23.0";
  by-version."mime-db"."1.23.0" = self.buildNodePackage {
    name = "mime-db-1.23.0";
    version = "1.23.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.23.0.tgz";
      name = "mime-db-1.23.0.tgz";
      sha1 = "a31b4070adaea27d732ea333740a64d0ec9a6659";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.10" =
    self.by-version."mime-types"."2.1.11";
  by-version."mime-types"."2.1.11" = self.buildNodePackage {
    name = "mime-types-2.1.11";
    version = "2.1.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-types/-/mime-types-2.1.11.tgz";
      name = "mime-types-2.1.11.tgz";
      sha1 = "c259c471bda808a85d6cd193b430a5fae4473b3c";
    };
    deps = {
      "mime-db-1.23.0" = self.by-version."mime-db"."1.23.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.1" =
    self.by-version."mime-types"."2.0.14";
  by-version."mime-types"."2.0.14" = self.buildNodePackage {
    name = "mime-types-2.0.14";
    version = "2.0.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-types/-/mime-types-2.0.14.tgz";
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
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.14";
  by-spec."mime-types"."~2.1.11" =
    self.by-version."mime-types"."2.1.11";
  by-spec."mime-types"."~2.1.6" =
    self.by-version."mime-types"."2.1.11";
  by-spec."mime-types"."~2.1.7" =
    self.by-version."mime-types"."2.1.11";
  by-spec."minimalistic-assert"."^1.0.0" =
    self.by-version."minimalistic-assert"."1.0.0";
  by-version."minimalistic-assert"."1.0.0" = self.buildNodePackage {
    name = "minimalistic-assert-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimalistic-assert/-/minimalistic-assert-1.0.0.tgz";
      name = "minimalistic-assert-1.0.0.tgz";
      sha1 = "702be2dda6b37f4836bcb3f5db56641b64a1d3d3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."0.3" =
    self.by-version."minimatch"."0.3.0";
  by-version."minimatch"."0.3.0" = self.buildNodePackage {
    name = "minimatch-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz";
      name = "minimatch-0.3.0.tgz";
      sha1 = "275d8edaac4f1bb3326472089e7949c8394699dd";
    };
    deps = {
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."0.x" =
    self.by-version."minimatch"."0.4.0";
  by-version."minimatch"."0.4.0" = self.buildNodePackage {
    name = "minimatch-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-0.4.0.tgz";
      name = "minimatch-0.4.0.tgz";
      sha1 = "bd2c7d060d2c8c8fd7cde7f1f2ed2d5b270fdb1b";
    };
    deps = {
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."2 || 3" =
    self.by-version."minimatch"."3.0.2";
  by-version."minimatch"."3.0.2" = self.buildNodePackage {
    name = "minimatch-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.2.tgz";
      name = "minimatch-3.0.2.tgz";
      sha1 = "0f398a7300ea441e9c348c83d98ab8c9dbf9c40a";
    };
    deps = {
      "brace-expansion-1.1.5" = self.by-version."brace-expansion"."1.1.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."2.x" =
    self.by-version."minimatch"."2.0.10";
  by-version."minimatch"."2.0.10" = self.buildNodePackage {
    name = "minimatch-2.0.10";
    version = "2.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-2.0.10.tgz";
      name = "minimatch-2.0.10.tgz";
      sha1 = "8d087c39c6b38c001b97fca7ce6d0e1e80afbac7";
    };
    deps = {
      "brace-expansion-1.1.5" = self.by-version."brace-expansion"."1.1.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."^2.0.1" =
    self.by-version."minimatch"."2.0.10";
  by-spec."minimatch"."^3.0.0" =
    self.by-version."minimatch"."3.0.2";
  by-spec."minimatch"."^3.0.2" =
    self.by-version."minimatch"."3.0.2";
  by-spec."minimatch"."~0.2.9" =
    self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = self.buildNodePackage {
    name = "minimatch-0.2.14";
    version = "0.2.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
      name = "minimatch-0.2.14.tgz";
      sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
    };
    deps = {
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
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
  by-spec."minimist"."^1.1.0" =
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
  by-spec."mkdirp"."0.5.x" =
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
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = self.buildNodePackage {
    name = "mkdirp-0.3.5";
    version = "0.3.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
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
  by-spec."mkdirp"."~0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."module-deps"."^3.7.11" =
    self.by-version."module-deps"."3.9.1";
  by-version."module-deps"."3.9.1" = self.buildNodePackage {
    name = "module-deps-3.9.1";
    version = "3.9.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/module-deps/-/module-deps-3.9.1.tgz";
      name = "module-deps-3.9.1.tgz";
      sha1 = "ea75caf9199090d25b0d5512b5acacb96e7f87f3";
    };
    deps = {
      "JSONStream-1.1.3" = self.by-version."JSONStream"."1.1.3";
      "browser-resolve-1.11.2" = self.by-version."browser-resolve"."1.11.2";
      "concat-stream-1.4.10" = self.by-version."concat-stream"."1.4.10";
      "defined-1.0.0" = self.by-version."defined"."1.0.0";
      "detective-4.3.1" = self.by-version."detective"."4.3.1";
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "parents-1.0.1" = self.by-version."parents"."1.0.1";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "resolve-1.1.7" = self.by-version."resolve"."1.1.7";
      "stream-combiner2-1.0.2" = self.by-version."stream-combiner2"."1.0.2";
      "subarg-1.0.0" = self.by-version."subarg"."1.0.0";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."module-not-found-error"."^1.0.0" =
    self.by-version."module-not-found-error"."1.0.1";
  by-version."module-not-found-error"."1.0.1" = self.buildNodePackage {
    name = "module-not-found-error-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/module-not-found-error/-/module-not-found-error-1.0.1.tgz";
      name = "module-not-found-error-1.0.1.tgz";
      sha1 = "cf8b4ff4f29640674d6cdd02b0e3bc523c2bbdc0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."morgan"."~1.5.1" =
    self.by-version."morgan"."1.5.3";
  by-version."morgan"."1.5.3" = self.buildNodePackage {
    name = "morgan-1.5.3";
    version = "1.5.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/morgan/-/morgan-1.5.3.tgz";
      name = "morgan-1.5.3.tgz";
      sha1 = "8adb4e72f9e5c5436e5d93f42910835f79da9fdf";
    };
    deps = {
      "basic-auth-1.0.4" = self.by-version."basic-auth"."1.0.4";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
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
  by-spec."mute-stream"."0.0.5" =
    self.by-version."mute-stream"."0.0.5";
  by-version."mute-stream"."0.0.5" = self.buildNodePackage {
    name = "mute-stream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.5.tgz";
      name = "mute-stream-0.0.5.tgz";
      sha1 = "8fbfabb0a98a253d3184331f9e8deb7372fac6c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."^2.0.0" =
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
  by-spec."nan"."~2.0.4" =
    self.by-version."nan"."2.0.9";
  by-version."nan"."2.0.9" = self.buildNodePackage {
    name = "nan-2.0.9";
    version = "2.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.0.9.tgz";
      name = "nan-2.0.9.tgz";
      sha1 = "d02a770f46778842cceb94e17cab31ffc7234a05";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nedb"."^1.1.2" =
    self.by-version."nedb"."1.8.0";
  by-version."nedb"."1.8.0" = self.buildNodePackage {
    name = "nedb-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nedb/-/nedb-1.8.0.tgz";
      name = "nedb-1.8.0.tgz";
      sha1 = "0e3502cd82c004d5355a43c9e55577bd7bd91d88";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "binary-search-tree-0.2.5" = self.by-version."binary-search-tree"."0.2.5";
      "localforage-1.4.2" = self.by-version."localforage"."1.4.2";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "nedb" = self.by-version."nedb"."1.8.0";
  by-spec."nedb"."^1.1.3" =
    self.by-version."nedb"."1.8.0";
  by-spec."negotiator"."0.5.3" =
    self.by-version."negotiator"."0.5.3";
  by-version."negotiator"."0.5.3" = self.buildNodePackage {
    name = "negotiator-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/negotiator/-/negotiator-0.5.3.tgz";
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
  by-spec."node-icu-charset-detector"."^0.1.0" =
    self.by-version."node-icu-charset-detector"."0.1.4";
  by-version."node-icu-charset-detector"."0.1.4" = self.buildNodePackage {
    name = "node-icu-charset-detector-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-icu-charset-detector/-/node-icu-charset-detector-0.1.4.tgz";
      name = "node-icu-charset-detector-0.1.4.tgz";
      sha1 = "4979c21f72cf4f79cbeec27b586d6f7138d0c9cd";
    };
    deps = {
      "nan-2.4.0" = self.by-version."nan"."2.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.7";
  by-version."node-uuid"."1.4.7" = self.buildNodePackage {
    name = "node-uuid-1.4.7";
    version = "1.4.7";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-uuid/-/node-uuid-1.4.7.tgz";
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
  by-spec."node-uuid"."~1.4.7" =
    self.by-version."node-uuid"."1.4.7";
  by-spec."nopt"."3.x" =
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
      "abbrev-1.0.9" = self.by-version."abbrev"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nopt"."^3.0.1" =
    self.by-version."nopt"."3.0.6";
  "nopt" = self.by-version."nopt"."3.0.6";
  by-spec."nopt"."^3.0.3" =
    self.by-version."nopt"."3.0.6";
  by-spec."number-is-nan"."^1.0.0" =
    self.by-version."number-is-nan"."1.0.0";
  by-version."number-is-nan"."1.0.0" = self.buildNodePackage {
    name = "number-is-nan-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.0.tgz";
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
  by-spec."oauth-sign"."~0.6.0" =
    self.by-version."oauth-sign"."0.6.0";
  by-version."oauth-sign"."0.6.0" = self.buildNodePackage {
    name = "oauth-sign-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.6.0.tgz";
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
  by-spec."object-assign"."^4.0.1" =
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
  by-spec."object-assign"."^4.1.0" =
    self.by-version."object-assign"."4.1.0";
  by-spec."object-keys"."^1.0.6" =
    self.by-version."object-keys"."1.0.11";
  by-version."object-keys"."1.0.11" = self.buildNodePackage {
    name = "object-keys-1.0.11";
    version = "1.0.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-keys/-/object-keys-1.0.11.tgz";
      name = "object-keys-1.0.11.tgz";
      sha1 = "c54601778ad560f1142ce0e01bcca8b56d13426d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.2.1" =
    self.by-version."on-finished"."2.2.1";
  by-version."on-finished"."2.2.1" = self.buildNodePackage {
    name = "on-finished-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-finished/-/on-finished-2.2.1.tgz";
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
  by-spec."once"."1.x" =
    self.by-version."once"."1.3.3";
  by-version."once"."1.3.3" = self.buildNodePackage {
    name = "once-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/once/-/once-1.3.3.tgz";
      name = "once-1.3.3.tgz";
      sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
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
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.3";
  by-spec."onetime"."^1.0.0" =
    self.by-version."onetime"."1.1.0";
  by-version."onetime"."1.1.0" = self.buildNodePackage {
    name = "onetime-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/onetime/-/onetime-1.1.0.tgz";
      name = "onetime-1.1.0.tgz";
      sha1 = "a1f7838f8314c516f05ecefcbc4ccfe04b4ed789";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."optionator"."^0.5.0" =
    self.by-version."optionator"."0.5.0";
  by-version."optionator"."0.5.0" = self.buildNodePackage {
    name = "optionator-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/optionator/-/optionator-0.5.0.tgz";
      name = "optionator-0.5.0.tgz";
      sha1 = "b75a8995a2d417df25b6e4e3862f50aa88651368";
    };
    deps = {
      "prelude-ls-1.1.2" = self.by-version."prelude-ls"."1.1.2";
      "deep-is-0.1.3" = self.by-version."deep-is"."0.1.3";
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
      "type-check-0.3.2" = self.by-version."type-check"."0.3.2";
      "levn-0.2.5" = self.by-version."levn"."0.2.5";
      "fast-levenshtein-1.0.7" = self.by-version."fast-levenshtein"."1.0.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optionator"."^0.6.0" =
    self.by-version."optionator"."0.6.0";
  by-version."optionator"."0.6.0" = self.buildNodePackage {
    name = "optionator-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/optionator/-/optionator-0.6.0.tgz";
      name = "optionator-0.6.0.tgz";
      sha1 = "b63ecbbf0e315fad4bc9827b45dc7ba45284fcb6";
    };
    deps = {
      "prelude-ls-1.1.2" = self.by-version."prelude-ls"."1.1.2";
      "deep-is-0.1.3" = self.by-version."deep-is"."0.1.3";
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
      "type-check-0.3.2" = self.by-version."type-check"."0.3.2";
      "levn-0.2.5" = self.by-version."levn"."0.2.5";
      "fast-levenshtein-1.0.7" = self.by-version."fast-levenshtein"."1.0.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-browserify"."~0.1.1" =
    self.by-version."os-browserify"."0.1.2";
  by-version."os-browserify"."0.1.2" = self.buildNodePackage {
    name = "os-browserify-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-browserify/-/os-browserify-0.1.2.tgz";
      name = "os-browserify-0.1.2.tgz";
      sha1 = "49ca0293e0b19590a5f5de10c7f265a617d8fe54";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-homedir"."^1.0.0" =
    self.by-version."os-homedir"."1.0.1";
  by-version."os-homedir"."1.0.1" = self.buildNodePackage {
    name = "os-homedir-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.1.tgz";
      name = "os-homedir-1.0.1.tgz";
      sha1 = "0d62bdf44b916fd3bbdcf2cab191948fb094f007";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pako"."~0.2.0" =
    self.by-version."pako"."0.2.8";
  by-version."pako"."0.2.8" = self.buildNodePackage {
    name = "pako-0.2.8";
    version = "0.2.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pako/-/pako-0.2.8.tgz";
      name = "pako-0.2.8.tgz";
      sha1 = "15ad772915362913f20de4a8a164b4aacc6165d6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parents"."^1.0.0" =
    self.by-version."parents"."1.0.1";
  by-version."parents"."1.0.1" = self.buildNodePackage {
    name = "parents-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/parents/-/parents-1.0.1.tgz";
      name = "parents-1.0.1.tgz";
      sha1 = "fedd4d2bf193a77745fe71e371d73c3307d9c751";
    };
    deps = {
      "path-platform-0.11.15" = self.by-version."path-platform"."0.11.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parents"."^1.0.1" =
    self.by-version."parents"."1.0.1";
  by-spec."parse-asn1"."^5.0.0" =
    self.by-version."parse-asn1"."5.0.0";
  by-version."parse-asn1"."5.0.0" = self.buildNodePackage {
    name = "parse-asn1-5.0.0";
    version = "5.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parse-asn1/-/parse-asn1-5.0.0.tgz";
      name = "parse-asn1-5.0.0.tgz";
      sha1 = "35060f6d5015d37628c770f4e091a0b5a278bc23";
    };
    deps = {
      "asn1.js-4.8.0" = self.by-version."asn1.js"."4.8.0";
      "browserify-aes-1.0.6" = self.by-version."browserify-aes"."1.0.6";
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
      "evp_bytestokey-1.0.0" = self.by-version."evp_bytestokey"."1.0.0";
      "pbkdf2-3.0.4" = self.by-version."pbkdf2"."3.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseurl"."~1.3.0" =
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
  by-spec."path-browserify"."~0.0.0" =
    self.by-version."path-browserify"."0.0.0";
  by-version."path-browserify"."0.0.0" = self.buildNodePackage {
    name = "path-browserify-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-browserify/-/path-browserify-0.0.0.tgz";
      name = "path-browserify-0.0.0.tgz";
      sha1 = "a0b870729aae214005b7d5032ec2cbbb0fb4451a";
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
    self.by-version."path-is-absolute"."1.0.0";
  by-version."path-is-absolute"."1.0.0" = self.buildNodePackage {
    name = "path-is-absolute-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.0.tgz";
      name = "path-is-absolute-1.0.0.tgz";
      sha1 = "263dada66ab3f2fb10bf7f9d24dd8f3e570ef912";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-is-inside"."^1.0.1" =
    self.by-version."path-is-inside"."1.0.1";
  by-version."path-is-inside"."1.0.1" = self.buildNodePackage {
    name = "path-is-inside-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.1.tgz";
      name = "path-is-inside-1.0.1.tgz";
      sha1 = "98d8f1d030bf04bd7aeee4a1ba5485d40318fd89";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-platform"."~0.11.15" =
    self.by-version."path-platform"."0.11.15";
  by-version."path-platform"."0.11.15" = self.buildNodePackage {
    name = "path-platform-0.11.15";
    version = "0.11.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-platform/-/path-platform-0.11.15.tgz";
      name = "path-platform-0.11.15.tgz";
      sha1 = "e864217f74c36850f0852b78dc7bf7d4a5721bf2";
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
      url = "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.3.tgz";
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
  by-spec."pbkdf2"."^3.0.3" =
    self.by-version."pbkdf2"."3.0.4";
  by-version."pbkdf2"."3.0.4" = self.buildNodePackage {
    name = "pbkdf2-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pbkdf2/-/pbkdf2-3.0.4.tgz";
      name = "pbkdf2-3.0.4.tgz";
      sha1 = "12c8bfaf920543786a85150b03f68d5f1aa982fc";
    };
    deps = {
      "create-hmac-1.1.4" = self.by-version."create-hmac"."1.1.4";
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
      url = "https://registry.npmjs.org/pify/-/pify-2.3.0.tgz";
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
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.1";
  by-version."pkginfo"."0.3.1" = self.buildNodePackage {
    name = "pkginfo-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pkginfo/-/pkginfo-0.3.1.tgz";
      name = "pkginfo-0.3.1.tgz";
      sha1 = "5b29f6a81f70717142e09e765bbeab97b4f81e21";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prelude-ls"."~1.1.0" =
    self.by-version."prelude-ls"."1.1.2";
  by-version."prelude-ls"."1.1.2" = self.buildNodePackage {
    name = "prelude-ls-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz";
      name = "prelude-ls-1.1.2.tgz";
      sha1 = "21932a549f5e52ffd9a827f570e04be62a97da54";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prelude-ls"."~1.1.1" =
    self.by-version."prelude-ls"."1.1.2";
  by-spec."prelude-ls"."~1.1.2" =
    self.by-version."prelude-ls"."1.1.2";
  by-spec."private"."~0.1.5" =
    self.by-version."private"."0.1.6";
  by-version."private"."0.1.6" = self.buildNodePackage {
    name = "private-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/private/-/private-0.1.6.tgz";
      name = "private-0.1.6.tgz";
      sha1 = "55c6a976d0f9bafb9924851350fe47b9b5fbb7c1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."process"."~0.11.0" =
    self.by-version."process"."0.11.5";
  by-version."process"."0.11.5" = self.buildNodePackage {
    name = "process-0.11.5";
    version = "0.11.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/process/-/process-0.11.5.tgz";
      name = "process-0.11.5.tgz";
      sha1 = "de49788f60e706f333adeea57a187ea9cc4c8495";
    };
    deps = {
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
  by-spec."proxy-addr"."~1.0.8" =
    self.by-version."proxy-addr"."1.0.10";
  by-version."proxy-addr"."1.0.10" = self.buildNodePackage {
    name = "proxy-addr-1.0.10";
    version = "1.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.10.tgz";
      name = "proxy-addr-1.0.10.tgz";
      sha1 = "0d40a82f801fc355567d2ecb65efe3f077f121c5";
    };
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-1.0.5" = self.by-version."ipaddr.js"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."proxyquire"."^1.4.0" =
    self.by-version."proxyquire"."1.7.10";
  by-version."proxyquire"."1.7.10" = self.buildNodePackage {
    name = "proxyquire-1.7.10";
    version = "1.7.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/proxyquire/-/proxyquire-1.7.10.tgz";
      name = "proxyquire-1.7.10.tgz";
      sha1 = "75be0770a81188f4d08bd01dfc30b767365aa20d";
    };
    deps = {
      "fill-keys-1.0.2" = self.by-version."fill-keys"."1.0.2";
      "module-not-found-error-1.0.1" = self.by-version."module-not-found-error"."1.0.1";
      "resolve-1.1.7" = self.by-version."resolve"."1.1.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "proxyquire" = self.by-version."proxyquire"."1.7.10";
  by-spec."public-encrypt"."^4.0.0" =
    self.by-version."public-encrypt"."4.0.0";
  by-version."public-encrypt"."4.0.0" = self.buildNodePackage {
    name = "public-encrypt-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/public-encrypt/-/public-encrypt-4.0.0.tgz";
      name = "public-encrypt-4.0.0.tgz";
      sha1 = "39f699f3a46560dd5ebacbca693caf7c65c18cc6";
    };
    deps = {
      "bn.js-4.11.5" = self.by-version."bn.js"."4.11.5";
      "browserify-rsa-4.0.1" = self.by-version."browserify-rsa"."4.0.1";
      "create-hash-1.1.2" = self.by-version."create-hash"."1.1.2";
      "parse-asn1-5.0.0" = self.by-version."parse-asn1"."5.0.0";
      "randombytes-2.0.3" = self.by-version."randombytes"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode"."1.3.2" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = self.buildNodePackage {
    name = "punycode-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
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
  by-spec."punycode"."^1.3.2" =
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
  by-spec."q"."^1.4.1" =
    self.by-version."q"."1.4.1";
  by-version."q"."1.4.1" = self.buildNodePackage {
    name = "q-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/q/-/q-1.4.1.tgz";
      name = "q-1.4.1.tgz";
      sha1 = "55705bcd93c5f3673530c2c2cbc0c2b3addc286e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."2.4.2" =
    self.by-version."qs"."2.4.2";
  by-version."qs"."2.4.2" = self.buildNodePackage {
    name = "qs-2.4.2";
    version = "2.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-2.4.2.tgz";
      name = "qs-2.4.2.tgz";
      sha1 = "f7ce788e5777df0b5010da7f7c4e73ba32470f5a";
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
      url = "https://registry.npmjs.org/qs/-/qs-2.3.3.tgz";
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
  by-spec."qs"."~6.2.0" =
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
  by-spec."querystring"."0.2.0" =
    self.by-version."querystring"."0.2.0";
  by-version."querystring"."0.2.0" = self.buildNodePackage {
    name = "querystring-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/querystring/-/querystring-0.2.0.tgz";
      name = "querystring-0.2.0.tgz";
      sha1 = "b209849203bb25df820da756e747005878521620";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."querystring-es3"."~0.2.0" =
    self.by-version."querystring-es3"."0.2.1";
  by-version."querystring-es3"."0.2.1" = self.buildNodePackage {
    name = "querystring-es3-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/querystring-es3/-/querystring-es3-0.2.1.tgz";
      name = "querystring-es3-0.2.1.tgz";
      sha1 = "9ec61f79049875707d69414596fd907a4d711e73";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."randombytes"."^2.0.0" =
    self.by-version."randombytes"."2.0.3";
  by-version."randombytes"."2.0.3" = self.buildNodePackage {
    name = "randombytes-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/randombytes/-/randombytes-2.0.3.tgz";
      name = "randombytes-2.0.3.tgz";
      sha1 = "674c99760901c3c4112771a31e521dc349cc09ec";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."randombytes"."^2.0.1" =
    self.by-version."randombytes"."2.0.3";
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.3";
  by-version."range-parser"."1.0.3" = self.buildNodePackage {
    name = "range-parser-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/range-parser/-/range-parser-1.0.3.tgz";
      name = "range-parser-1.0.3.tgz";
      sha1 = "6872823535c692e2c2a0103826afd82c2e0ff175";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."raw-body"."~2.0.1" =
    self.by-version."raw-body"."2.0.2";
  by-version."raw-body"."2.0.2" = self.buildNodePackage {
    name = "raw-body-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/raw-body/-/raw-body-2.0.2.tgz";
      name = "raw-body-2.0.2.tgz";
      sha1 = "a2c2f98c8531cee99c63d8d238b7de97bb659fca";
    };
    deps = {
      "bytes-2.1.0" = self.by-version."bytes"."2.1.0";
      "iconv-lite-0.4.8" = self.by-version."iconv-lite"."0.4.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."read-json-sync"."^1.1.0" =
    self.by-version."read-json-sync"."1.1.1";
  by-version."read-json-sync"."1.1.1" = self.buildNodePackage {
    name = "read-json-sync-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/read-json-sync/-/read-json-sync-1.1.1.tgz";
      name = "read-json-sync-1.1.1.tgz";
      sha1 = "43c669ae864aae308dfbbb2721a67e295ec8fff6";
    };
    deps = {
      "graceful-fs-4.1.4" = self.by-version."graceful-fs"."4.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."read-only-stream"."^1.1.1" =
    self.by-version."read-only-stream"."1.1.1";
  by-version."read-only-stream"."1.1.1" = self.buildNodePackage {
    name = "read-only-stream-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/read-only-stream/-/read-only-stream-1.1.1.tgz";
      name = "read-only-stream-1.1.1.tgz";
      sha1 = "5da77c799ed1388d3ef88a18471bb5924f8a0ba1";
    };
    deps = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "readable-wrap-1.0.0" = self.by-version."readable-wrap"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream".">=1.0.33-1 <1.1.0-0" =
    self.by-version."readable-stream"."1.0.34";
  by-version."readable-stream"."1.0.34" = self.buildNodePackage {
    name = "readable-stream-1.0.34";
    version = "1.0.34";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz";
      name = "readable-stream-1.0.34.tgz";
      sha1 = "125820e34bc842d2f2aaafafe4c2916ee32c157c";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
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
  by-spec."readable-stream".">=1.1.13-1 <1.2.0-0" =
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
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^1.0.27-1" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^1.0.31" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^1.1.13" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^1.1.13-1" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^2.0.2" =
    self.by-version."readable-stream"."2.1.4";
  by-version."readable-stream"."2.1.4" = self.buildNodePackage {
    name = "readable-stream-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.1.4.tgz";
      name = "readable-stream-2.1.4.tgz";
      sha1 = "70b9791c6fcb8480db44bd155a0f6bb58f172468";
    };
    deps = {
      "buffer-shims-1.0.0" = self.by-version."buffer-shims"."1.0.0";
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
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
  by-spec."readable-stream"."~1.0.17" =
    self.by-version."readable-stream"."1.0.34";
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.34";
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
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
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
  by-spec."readable-wrap"."^1.0.0" =
    self.by-version."readable-wrap"."1.0.0";
  by-version."readable-wrap"."1.0.0" = self.buildNodePackage {
    name = "readable-wrap-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-wrap/-/readable-wrap-1.0.0.tgz";
      name = "readable-wrap-1.0.0.tgz";
      sha1 = "3b5a211c631e12303a54991c806c17e7ae206bff";
    };
    deps = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readline2"."^1.0.1" =
    self.by-version."readline2"."1.0.1";
  by-version."readline2"."1.0.1" = self.buildNodePackage {
    name = "readline2-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readline2/-/readline2-1.0.1.tgz";
      name = "readline2-1.0.1.tgz";
      sha1 = "41059608ffc154757b715d9989d199ffbf372e35";
    };
    deps = {
      "code-point-at-1.0.0" = self.by-version."code-point-at"."1.0.0";
      "is-fullwidth-code-point-1.0.0" = self.by-version."is-fullwidth-code-point"."1.0.0";
      "mute-stream-0.0.5" = self.by-version."mute-stream"."0.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."recast"."^0.10.1" =
    self.by-version."recast"."0.10.43";
  by-version."recast"."0.10.43" = self.buildNodePackage {
    name = "recast-0.10.43";
    version = "0.10.43";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/recast/-/recast-0.10.43.tgz";
      name = "recast-0.10.43.tgz";
      sha1 = "b95d50f6d60761a5f6252e15d80678168491ce7f";
    };
    deps = {
      "esprima-fb-15001.1001.0-dev-harmony-fb" = self.by-version."esprima-fb"."15001.1001.0-dev-harmony-fb";
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
      "private-0.1.6" = self.by-version."private"."0.1.6";
      "ast-types-0.8.15" = self.by-version."ast-types"."0.8.15";
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
  by-spec."repeat-string"."^1.5.2" =
    self.by-version."repeat-string"."1.5.4";
  by-version."repeat-string"."1.5.4" = self.buildNodePackage {
    name = "repeat-string-1.5.4";
    version = "1.5.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/repeat-string/-/repeat-string-1.5.4.tgz";
      name = "repeat-string-1.5.4.tgz";
      sha1 = "64ec0c91e0f4b475f90d5b643651e3e6e5b6c2d5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.53.0" =
    self.by-version."request"."2.73.0";
  by-version."request"."2.73.0" = self.buildNodePackage {
    name = "request-2.73.0";
    version = "2.73.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/request/-/request-2.73.0.tgz";
      name = "request-2.73.0.tgz";
      sha1 = "5f78a9fde4370abc8ff6479d7a84a71a14b878a2";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.4.1" = self.by-version."aws4"."1.4.1";
      "bl-1.1.2" = self.by-version."bl"."1.1.2";
      "caseless-0.11.0" = self.by-version."caseless"."0.11.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-1.0.0-rc4" = self.by-version."form-data"."1.0.0-rc4";
      "har-validator-2.0.6" = self.by-version."har-validator"."2.0.6";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.11" = self.by-version."mime-types"."2.1.11";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "oauth-sign-0.8.2" = self.by-version."oauth-sign"."0.8.2";
      "qs-6.2.0" = self.by-version."qs"."6.2.0";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.2.2" = self.by-version."tough-cookie"."2.2.2";
      "tunnel-agent-0.4.3" = self.by-version."tunnel-agent"."0.4.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.54.0" =
    self.by-version."request"."2.73.0";
  "request" = self.by-version."request"."2.73.0";
  by-spec."request"."^2.61.0" =
    self.by-version."request"."2.73.0";
  by-spec."request"."~2.53.0" =
    self.by-version."request"."2.53.0";
  by-version."request"."2.53.0" = self.buildNodePackage {
    name = "request-2.53.0";
    version = "2.53.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/request/-/request-2.53.0.tgz";
      name = "request-2.53.0.tgz";
      sha1 = "180a3ae92b7b639802e4f9545dd8fcdeb71d760c";
    };
    deps = {
      "bl-0.9.5" = self.by-version."bl"."0.9.5";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.3" = self.by-version."tunnel-agent"."0.4.3";
      "tough-cookie-2.2.2" = self.by-version."tough-cookie"."2.2.2";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."requirejs".">=0.27.1" =
    self.by-version."requirejs"."2.2.0";
  by-version."requirejs"."2.2.0" = self.buildNodePackage {
    name = "requirejs-2.2.0";
    version = "2.2.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/requirejs/-/requirejs-2.2.0.tgz";
      name = "requirejs-2.2.0.tgz";
      sha1 = "0f2b1538af2b8d0a4fffffde5d367aa9cd4cfe84";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."1.1.7" =
    self.by-version."resolve"."1.1.7";
  by-version."resolve"."1.1.7" = self.buildNodePackage {
    name = "resolve-1.1.7";
    version = "1.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz";
      name = "resolve-1.1.7.tgz";
      sha1 = "203114d82ad2c5ed9e8e0411b3932875e889e97b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."1.1.x" =
    self.by-version."resolve"."1.1.7";
  by-spec."resolve"."^1.1.3" =
    self.by-version."resolve"."1.1.7";
  by-spec."resolve"."^1.1.4" =
    self.by-version."resolve"."1.1.7";
  by-spec."resolve"."~1.1.7" =
    self.by-version."resolve"."1.1.7";
  by-spec."restore-cursor"."^1.0.1" =
    self.by-version."restore-cursor"."1.0.1";
  by-version."restore-cursor"."1.0.1" = self.buildNodePackage {
    name = "restore-cursor-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/restore-cursor/-/restore-cursor-1.0.1.tgz";
      name = "restore-cursor-1.0.1.tgz";
      sha1 = "34661f46886327fed2991479152252df92daa541";
    };
    deps = {
      "exit-hook-1.1.1" = self.by-version."exit-hook"."1.1.1";
      "onetime-1.1.0" = self.by-version."onetime"."1.1.0";
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
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.5.3";
  by-version."rimraf"."2.5.3" = self.buildNodePackage {
    name = "rimraf-2.5.3";
    version = "2.5.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.5.3.tgz";
      name = "rimraf-2.5.3.tgz";
      sha1 = "6e5efdda4aa2f03417f6b2a574aec29f4b652705";
    };
    deps = {
      "glob-7.0.5" = self.by-version."glob"."7.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ripemd160"."^1.0.0" =
    self.by-version."ripemd160"."1.0.1";
  by-version."ripemd160"."1.0.1" = self.buildNodePackage {
    name = "ripemd160-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ripemd160/-/ripemd160-1.0.1.tgz";
      name = "ripemd160-1.0.1.tgz";
      sha1 = "93a4bbd4942bc574b69a8fa57c71de10ecca7d6e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."run-async"."^0.1.0" =
    self.by-version."run-async"."0.1.0";
  by-version."run-async"."0.1.0" = self.buildNodePackage {
    name = "run-async-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/run-async/-/run-async-0.1.0.tgz";
      name = "run-async-0.1.0.tgz";
      sha1 = "c8ad4a5e110661e402a7d21b530e009f25f8e389";
    };
    deps = {
      "once-1.3.3" = self.by-version."once"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rx-lite"."^3.1.2" =
    self.by-version."rx-lite"."3.1.2";
  by-version."rx-lite"."3.1.2" = self.buildNodePackage {
    name = "rx-lite-3.1.2";
    version = "3.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/rx-lite/-/rx-lite-3.1.2.tgz";
      name = "rx-lite-3.1.2.tgz";
      sha1 = "19ce502ca572665f3b647b10939f97fd1615f102";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sanitize-html"."^1.6.1" =
    self.by-version."sanitize-html"."1.13.0";
  by-version."sanitize-html"."1.13.0" = self.buildNodePackage {
    name = "sanitize-html-1.13.0";
    version = "1.13.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sanitize-html/-/sanitize-html-1.13.0.tgz";
      name = "sanitize-html-1.13.0.tgz";
      sha1 = "4ee17cbec516bfe32f2ce6686a569d7e6b4f3631";
    };
    deps = {
      "htmlparser2-3.9.1" = self.by-version."htmlparser2"."3.9.1";
      "regexp-quote-0.0.0" = self.by-version."regexp-quote"."0.0.0";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "sanitize-html" = self.by-version."sanitize-html"."1.13.0";
  by-spec."send"."0.12.3" =
    self.by-version."send"."0.12.3";
  by-version."send"."0.12.3" = self.buildNodePackage {
    name = "send-0.12.3";
    version = "0.12.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/send/-/send-0.12.3.tgz";
      name = "send-0.12.3.tgz";
      sha1 = "cd12dc58fde21e4f91902b39b2fda05a7a6d9bdc";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.6.0" = self.by-version."etag"."1.6.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "range-parser-1.0.3" = self.by-version."range-parser"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.9.3" =
    self.by-version."serve-static"."1.9.3";
  by-version."serve-static"."1.9.3" = self.buildNodePackage {
    name = "serve-static-1.9.3";
    version = "1.9.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/serve-static/-/serve-static-1.9.3.tgz";
      name = "serve-static-1.9.3.tgz";
      sha1 = "5f8da07323ad385ff3dc541f1a7917b2e436eb57";
    };
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "send-0.12.3" = self.by-version."send"."0.12.3";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sha.js"."^2.3.6" =
    self.by-version."sha.js"."2.4.5";
  by-version."sha.js"."2.4.5" = self.buildNodePackage {
    name = "sha.js-2.4.5";
    version = "2.4.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sha.js/-/sha.js-2.4.5.tgz";
      name = "sha.js-2.4.5.tgz";
      sha1 = "27d171efcc82a118b99639ff581660242b506e7c";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sha.js"."~2.4.4" =
    self.by-version."sha.js"."2.4.5";
  by-spec."shasum"."^1.0.0" =
    self.by-version."shasum"."1.0.2";
  by-version."shasum"."1.0.2" = self.buildNodePackage {
    name = "shasum-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/shasum/-/shasum-1.0.2.tgz";
      name = "shasum-1.0.2.tgz";
      sha1 = "e7012310d8f417f4deb5712150e5678b87ae565f";
    };
    deps = {
      "json-stable-stringify-0.0.1" = self.by-version."json-stable-stringify"."0.0.1";
      "sha.js-2.4.5" = self.by-version."sha.js"."2.4.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."shell-quote"."~0.0.1" =
    self.by-version."shell-quote"."0.0.1";
  by-version."shell-quote"."0.0.1" = self.buildNodePackage {
    name = "shell-quote-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/shell-quote/-/shell-quote-0.0.1.tgz";
      name = "shell-quote-0.0.1.tgz";
      sha1 = "1a41196f3c0333c482323593d6886ecf153dd986";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."shelljs"."^0.5.3" =
    self.by-version."shelljs"."0.5.3";
  by-version."shelljs"."0.5.3" = self.buildNodePackage {
    name = "shelljs-0.5.3";
    version = "0.5.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/shelljs/-/shelljs-0.5.3.tgz";
      name = "shelljs-0.5.3.tgz";
      sha1 = "c54982b996c76ef0c1e6b59fbdc5825f5b713113";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sigmund"."~1.0.0" =
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
  by-spec."source-map"."0.1.31" =
    self.by-version."source-map"."0.1.31";
  by-version."source-map"."0.1.31" = self.buildNodePackage {
    name = "source-map-0.1.31";
    version = "0.1.31";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/source-map/-/source-map-0.1.31.tgz";
      name = "source-map-0.1.31.tgz";
      sha1 = "9f704d0d69d9e138a81badf6ebb4fde33d151c61";
    };
    deps = {
      "amdefine-1.0.0" = self.by-version."amdefine"."1.0.0";
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
      "amdefine-1.0.0" = self.by-version."amdefine"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.2.0" =
    self.by-version."source-map"."0.2.0";
  by-version."source-map"."0.2.0" = self.buildNodePackage {
    name = "source-map-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/source-map/-/source-map-0.2.0.tgz";
      name = "source-map-0.2.0.tgz";
      sha1 = "dab73fbcfc2ba819b4de03bd6f6eaa48164b3f9d";
    };
    deps = {
      "amdefine-1.0.0" = self.by-version."amdefine"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.4.0" =
    self.by-version."source-map"."0.4.4";
  by-spec."source-map"."~0.4.2" =
    self.by-version."source-map"."0.4.4";
  by-spec."source-map"."~0.5.0" =
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
  by-spec."source-map"."~0.5.1" =
    self.by-version."source-map"."0.5.6";
  by-spec."sprintf-js"."~1.0.2" =
    self.by-version."sprintf-js"."1.0.3";
  by-version."sprintf-js"."1.0.3" = self.buildNodePackage {
    name = "sprintf-js-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz";
      name = "sprintf-js-1.0.3.tgz";
      sha1 = "04e6926f662895354f3dd015203633b857297e2c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sshpk"."^1.7.0" =
    self.by-version."sshpk"."1.8.3";
  by-version."sshpk"."1.8.3" = self.buildNodePackage {
    name = "sshpk-1.8.3";
    version = "1.8.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sshpk/-/sshpk-1.8.3.tgz";
      name = "sshpk-1.8.3.tgz";
      sha1 = "890cc9d614dc5292e5cb1a543b03c9abaa5c374e";
    };
    deps = {
      "asn1-0.2.3" = self.by-version."asn1"."0.2.3";
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
      "dashdash-1.14.0" = self.by-version."dashdash"."1.14.0";
      "getpass-0.1.6" = self.by-version."getpass"."0.1.6";
    };
    optionalDependencies = {
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
      "tweetnacl-0.13.3" = self.by-version."tweetnacl"."0.13.3";
      "jodid25519-1.0.2" = self.by-version."jodid25519"."1.0.2";
      "ecc-jsbn-0.1.1" = self.by-version."ecc-jsbn"."0.1.1";
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
      url = "https://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
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
  by-spec."stream-browserify"."^1.0.0" =
    self.by-version."stream-browserify"."1.0.0";
  by-version."stream-browserify"."1.0.0" = self.buildNodePackage {
    name = "stream-browserify-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stream-browserify/-/stream-browserify-1.0.0.tgz";
      name = "stream-browserify-1.0.0.tgz";
      sha1 = "bf9b4abfb42b274d751479e44e0ff2656b6f1193";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-combiner2"."~1.0.0" =
    self.by-version."stream-combiner2"."1.0.2";
  by-version."stream-combiner2"."1.0.2" = self.buildNodePackage {
    name = "stream-combiner2-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stream-combiner2/-/stream-combiner2-1.0.2.tgz";
      name = "stream-combiner2-1.0.2.tgz";
      sha1 = "ba72a6b50cbfabfa950fc8bc87604bd01eb60671";
    };
    deps = {
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-splicer"."^1.1.0" =
    self.by-version."stream-splicer"."1.3.2";
  by-version."stream-splicer"."1.3.2" = self.buildNodePackage {
    name = "stream-splicer-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stream-splicer/-/stream-splicer-1.3.2.tgz";
      name = "stream-splicer-1.3.2.tgz";
      sha1 = "3c0441be15b9bf4e226275e6dc83964745546661";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "readable-wrap-1.0.0" = self.by-version."readable-wrap"."1.0.0";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string-width"."^1.0.1" =
    self.by-version."string-width"."1.0.1";
  by-version."string-width"."1.0.1" = self.buildNodePackage {
    name = "string-width-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/string-width/-/string-width-1.0.1.tgz";
      name = "string-width-1.0.1.tgz";
      sha1 = "c92129b6f1d7f52acf9af424a26e3864a05ceb0a";
    };
    deps = {
      "code-point-at-1.0.0" = self.by-version."code-point-at"."1.0.0";
      "is-fullwidth-code-point-1.0.0" = self.by-version."is-fullwidth-code-point"."1.0.0";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string_decoder"."~0.10.0" =
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
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
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
      "ansi-regex-2.0.0" = self.by-version."ansi-regex"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-json-comments"."~1.0.1" =
    self.by-version."strip-json-comments"."1.0.4";
  by-version."strip-json-comments"."1.0.4" = self.buildNodePackage {
    name = "strip-json-comments-1.0.4";
    version = "1.0.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-1.0.4.tgz";
      name = "strip-json-comments-1.0.4.tgz";
      sha1 = "1e15fbcac97d3ee99bf2d73b4c656b082bbafb91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."subarg"."^1.0.0" =
    self.by-version."subarg"."1.0.0";
  by-version."subarg"."1.0.0" = self.buildNodePackage {
    name = "subarg-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/subarg/-/subarg-1.0.0.tgz";
      name = "subarg-1.0.0.tgz";
      sha1 = "f62cf17581e996b48fc965699f54c06ae268b8d2";
    };
    deps = {
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."supports-color"."^3.1.0" =
    self.by-version."supports-color"."3.1.2";
  by-version."supports-color"."3.1.2" = self.buildNodePackage {
    name = "supports-color-3.1.2";
    version = "3.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/supports-color/-/supports-color-3.1.2.tgz";
      name = "supports-color-3.1.2.tgz";
      sha1 = "72a262894d9d408b956ca05ff37b2ed8a6e2a2d5";
    };
    deps = {
      "has-flag-1.0.0" = self.by-version."has-flag"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."syntax-error"."^1.1.1" =
    self.by-version."syntax-error"."1.1.6";
  by-version."syntax-error"."1.1.6" = self.buildNodePackage {
    name = "syntax-error-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/syntax-error/-/syntax-error-1.1.6.tgz";
      name = "syntax-error-1.1.6.tgz";
      sha1 = "b4549706d386cc1c1dc7c2423f18579b6cade710";
    };
    deps = {
      "acorn-2.7.0" = self.by-version."acorn"."2.7.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."text-table"."~0.2.0" =
    self.by-version."text-table"."0.2.0";
  by-version."text-table"."0.2.0" = self.buildNodePackage {
    name = "text-table-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz";
      name = "text-table-0.2.0.tgz";
      sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through".">=2.2.7 <3" =
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
  by-spec."through"."^2.3.6" =
    self.by-version."through"."2.3.8";
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.8";
  by-spec."through2"."^0.6.2" =
    self.by-version."through2"."0.6.5";
  by-version."through2"."0.6.5" = self.buildNodePackage {
    name = "through2-0.6.5";
    version = "0.6.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-0.6.5.tgz";
      name = "through2-0.6.5.tgz";
      sha1 = "41ab9c67b29d57209071410e1d7a7a968cd3ad48";
    };
    deps = {
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through2"."^0.6.5" =
    self.by-version."through2"."0.6.5";
  by-spec."through2"."^1.0.0" =
    self.by-version."through2"."1.1.1";
  by-version."through2"."1.1.1" = self.buildNodePackage {
    name = "through2-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-1.1.1.tgz";
      name = "through2-1.1.1.tgz";
      sha1 = "0847cbc4449f3405574dbdccd9bb841b83ac3545";
    };
    deps = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through2"."~0.5.1" =
    self.by-version."through2"."0.5.1";
  by-version."through2"."0.5.1" = self.buildNodePackage {
    name = "through2-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-0.5.1.tgz";
      name = "through2-0.5.1.tgz";
      sha1 = "dfdd012eb9c700e2323fd334f38ac622ab372da7";
    };
    deps = {
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."timers-browserify"."^1.0.1" =
    self.by-version."timers-browserify"."1.4.2";
  by-version."timers-browserify"."1.4.2" = self.buildNodePackage {
    name = "timers-browserify-1.4.2";
    version = "1.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/timers-browserify/-/timers-browserify-1.4.2.tgz";
      name = "timers-browserify-1.4.2.tgz";
      sha1 = "c9c58b575be8407375cb5e2462dacee74359f41d";
    };
    deps = {
      "process-0.11.5" = self.by-version."process"."0.11.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."2.2.2";
  by-version."tough-cookie"."2.2.2" = self.buildNodePackage {
    name = "tough-cookie-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.2.2.tgz";
      name = "tough-cookie-2.2.2.tgz";
      sha1 = "c83a1830f4e5ef0b93ef2a3488e724f8de016ac7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie"."~2.2.0" =
    self.by-version."tough-cookie"."2.2.2";
  by-spec."tryit"."^1.0.1" =
    self.by-version."tryit"."1.0.2";
  by-version."tryit"."1.0.2" = self.buildNodePackage {
    name = "tryit-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tryit/-/tryit-1.0.2.tgz";
      name = "tryit-1.0.2.tgz";
      sha1 = "c196b0073e6b1c595d93c9c830855b7acc32a453";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tty-browserify"."~0.0.0" =
    self.by-version."tty-browserify"."0.0.0";
  by-version."tty-browserify"."0.0.0" = self.buildNodePackage {
    name = "tty-browserify-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tty-browserify/-/tty-browserify-0.0.0.tgz";
      name = "tty-browserify-0.0.0.tgz";
      sha1 = "a157ba402da24e9bf957f9aa69d524eed42901a6";
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
  by-spec."tunnel-agent"."~0.4.1" =
    self.by-version."tunnel-agent"."0.4.3";
  by-spec."tweetnacl"."~0.13.0" =
    self.by-version."tweetnacl"."0.13.3";
  by-version."tweetnacl"."0.13.3" = self.buildNodePackage {
    name = "tweetnacl-0.13.3";
    version = "0.13.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.13.3.tgz";
      name = "tweetnacl-0.13.3.tgz";
      sha1 = "d628b56f3bcc3d5ae74ba9d4c1a704def5ab4b56";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-check"."~0.3.1" =
    self.by-version."type-check"."0.3.2";
  by-version."type-check"."0.3.2" = self.buildNodePackage {
    name = "type-check-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz";
      name = "type-check-0.3.2.tgz";
      sha1 = "5884cab512cf1d355e3fb784f30804b2b520db72";
    };
    deps = {
      "prelude-ls-1.1.2" = self.by-version."prelude-ls"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."~1.6.2" =
    self.by-version."type-is"."1.6.13";
  by-version."type-is"."1.6.13" = self.buildNodePackage {
    name = "type-is-1.6.13";
    version = "1.6.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/type-is/-/type-is-1.6.13.tgz";
      name = "type-is-1.6.13.tgz";
      sha1 = "6e83ba7bc30cd33a7bb0b7fb00737a2085bf9d08";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.1.11" = self.by-version."mime-types"."2.1.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typedarray"."~0.0.5" =
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
  by-spec."uglify-js"."^2.6" =
    self.by-version."uglify-js"."2.7.0";
  by-version."uglify-js"."2.7.0" = self.buildNodePackage {
    name = "uglify-js-2.7.0";
    version = "2.7.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/uglify-js/-/uglify-js-2.7.0.tgz";
      name = "uglify-js-2.7.0.tgz";
      sha1 = "f021e38ba2ca740860f5bd5c695c2a817345f0ec";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
      "yargs-3.10.0" = self.by-version."yargs"."3.10.0";
    };
    optionalDependencies = {
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
  by-spec."umd"."^3.0.0" =
    self.by-version."umd"."3.0.1";
  by-version."umd"."3.0.1" = self.buildNodePackage {
    name = "umd-3.0.1";
    version = "3.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/umd/-/umd-3.0.1.tgz";
      name = "umd-3.0.1.tgz";
      sha1 = "8ae556e11011f63c2596708a8837259f01b3d60e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore".">= 1.3.1" =
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
  by-spec."underscore"."~1.4.4" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = self.buildNodePackage {
    name = "underscore-1.4.4";
    version = "1.4.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
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
  by-spec."unreachable-branch-transform"."^0.3.0" =
    self.by-version."unreachable-branch-transform"."0.3.0";
  by-version."unreachable-branch-transform"."0.3.0" = self.buildNodePackage {
    name = "unreachable-branch-transform-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unreachable-branch-transform/-/unreachable-branch-transform-0.3.0.tgz";
      name = "unreachable-branch-transform-0.3.0.tgz";
      sha1 = "d99cc4c6e746d264928845b611db54b0f3474caa";
    };
    deps = {
      "esmangle-evaluator-1.0.1" = self.by-version."esmangle-evaluator"."1.0.1";
      "recast-0.10.43" = self.by-version."recast"."0.10.43";
      "through2-0.6.5" = self.by-version."through2"."0.6.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."url"."~0.10.1" =
    self.by-version."url"."0.10.3";
  by-version."url"."0.10.3" = self.buildNodePackage {
    name = "url-0.10.3";
    version = "0.10.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/url/-/url-0.10.3.tgz";
      name = "url-0.10.3.tgz";
      sha1 = "021e4d9c7705f21bbf37d03ceb58767402774c64";
    };
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
      "querystring-0.2.0" = self.by-version."querystring"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."user-home"."^2.0.0" =
    self.by-version."user-home"."2.0.0";
  by-version."user-home"."2.0.0" = self.buildNodePackage {
    name = "user-home-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/user-home/-/user-home-2.0.0.tgz";
      name = "user-home-2.0.0.tgz";
      sha1 = "9c70bfd8169bc1dcbf48604e0f04b8b49cde9e9f";
    };
    deps = {
      "os-homedir-1.0.1" = self.by-version."os-homedir"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."util"."0.10.3" =
    self.by-version."util"."0.10.3";
  by-version."util"."0.10.3" = self.buildNodePackage {
    name = "util-0.10.3";
    version = "0.10.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/util/-/util-0.10.3.tgz";
      name = "util-0.10.3.tgz";
      sha1 = "7afb1afe50805246489e3db7fe0ed379336ac0f9";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."util"."~0.10.1" =
    self.by-version."util"."0.10.3";
  by-spec."util-deprecate"."~1.0.1" =
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
  by-spec."vary"."~1.0.0" =
    self.by-version."vary"."1.0.1";
  by-version."vary"."1.0.1" = self.buildNodePackage {
    name = "vary-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vary/-/vary-1.0.1.tgz";
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
  by-spec."vm-browserify"."~0.0.1" =
    self.by-version."vm-browserify"."0.0.4";
  by-version."vm-browserify"."0.0.4" = self.buildNodePackage {
    name = "vm-browserify-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vm-browserify/-/vm-browserify-0.0.4.tgz";
      name = "vm-browserify-0.0.4.tgz";
      sha1 = "5d7ea45bbef9e4a6ff65f95438e0a87c357d5a73";
    };
    deps = {
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."walkdir".">= 0.0.1" =
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
  by-spec."when"."~3.4.6" =
    self.by-version."when"."3.4.6";
  by-version."when"."3.4.6" = self.buildNodePackage {
    name = "when-3.4.6";
    version = "3.4.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/when/-/when-3.4.6.tgz";
      name = "when-3.4.6.tgz";
      sha1 = "8fbcb7cc1439d2c3a68c431f1516e6dcce9ad28c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."which"."^1.1.1" =
    self.by-version."which"."1.2.10";
  by-version."which"."1.2.10" = self.buildNodePackage {
    name = "which-1.2.10";
    version = "1.2.10";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/which/-/which-1.2.10.tgz";
      name = "which-1.2.10.tgz";
      sha1 = "91cd9bd0751322411b659b40f054b21de957ab2d";
    };
    deps = {
      "isexe-1.1.2" = self.by-version."isexe"."1.1.2";
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
  by-spec."winston"."^0.9.0" =
    self.by-version."winston"."0.9.0";
  by-version."winston"."0.9.0" = self.buildNodePackage {
    name = "winston-0.9.0";
    version = "0.9.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/winston/-/winston-0.9.0.tgz";
      name = "winston-0.9.0.tgz";
      sha1 = "b5726e6c42291e305e36286ce7ae9f3b74a527a8";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "colors-1.0.3" = self.by-version."colors"."1.0.3";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "pkginfo-0.3.1" = self.by-version."pkginfo"."0.3.1";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "winston" = self.by-version."winston"."0.9.0";
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
  by-spec."wordwrap"."^1.0.0" =
    self.by-version."wordwrap"."1.0.0";
  by-version."wordwrap"."1.0.0" = self.buildNodePackage {
    name = "wordwrap-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wordwrap/-/wordwrap-1.0.0.tgz";
      name = "wordwrap-1.0.0.tgz";
      sha1 = "27584810891456a4171c8d0226441ade90cbcaeb";
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
  by-spec."write"."^0.2.1" =
    self.by-version."write"."0.2.1";
  by-version."write"."0.2.1" = self.buildNodePackage {
    name = "write-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/write/-/write-0.2.1.tgz";
      name = "write-0.2.1.tgz";
      sha1 = "5fc03828e264cea3fe91455476f7a3c566cb0757";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xml-escape"."~1.0.0" =
    self.by-version."xml-escape"."1.0.0";
  by-version."xml-escape"."1.0.0" = self.buildNodePackage {
    name = "xml-escape-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xml-escape/-/xml-escape-1.0.0.tgz";
      name = "xml-escape-1.0.0.tgz";
      sha1 = "00963d697b2adf0c185c4e04e73174ba9b288eb2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend".">=4.0.0 <4.1.0-0" =
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
  by-spec."xtend"."^4.0.0" =
    self.by-version."xtend"."4.0.1";
  by-spec."xtend"."~3.0.0" =
    self.by-version."xtend"."3.0.0";
  by-version."xtend"."3.0.0" = self.buildNodePackage {
    name = "xtend-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xtend/-/xtend-3.0.0.tgz";
      name = "xtend-3.0.0.tgz";
      sha1 = "5cce7407baf642cba7becda568111c493f59665a";
    };
    deps = {
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
}
