{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."adal-node"."0.1.16" =
    self.by-version."adal-node"."0.1.16";
  by-version."adal-node"."0.1.16" = self.buildNodePackage {
    name = "adal-node-0.1.16";
    version = "0.1.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/adal-node/-/adal-node-0.1.16.tgz";
      name = "adal-node-0.1.16.tgz";
      sha1 = "ed205574c05ae93c68f0b59909588242f2c9ccf8";
    };
    deps = {
      "date-utils-1.2.18" = self.by-version."date-utils"."1.2.18";
      "jws-3.1.3" = self.by-version."jws"."3.1.3";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "request-2.69.0" = self.by-version."request"."2.69.0";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "xmldom-0.1.22" = self.by-version."xmldom"."0.1.22";
      "xpath.js-1.0.6" = self.by-version."xpath.js"."1.0.6";
      "async-1.5.2" = self.by-version."async"."1.5.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."adal-node"."0.1.17" =
    self.by-version."adal-node"."0.1.17";
  by-version."adal-node"."0.1.17" = self.buildNodePackage {
    name = "adal-node-0.1.17";
    version = "0.1.17";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/adal-node/-/adal-node-0.1.17.tgz";
      name = "adal-node-0.1.17.tgz";
      sha1 = "7946eb374c837730bd3cc49b0894928154e505d0";
    };
    deps = {
      "date-utils-1.2.18" = self.by-version."date-utils"."1.2.18";
      "jws-3.1.3" = self.by-version."jws"."3.1.3";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "request-2.69.0" = self.by-version."request"."2.69.0";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "xmldom-0.1.22" = self.by-version."xmldom"."0.1.22";
      "xpath.js-1.0.6" = self.by-version."xpath.js"."1.0.6";
      "async-1.5.2" = self.by-version."async"."1.5.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."1.0.0";
  by-version."amdefine"."1.0.0" = self.buildNodePackage {
    name = "amdefine-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/amdefine/-/amdefine-1.0.0.tgz";
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
  by-spec."ansi-regex"."^2.0.0" =
    self.by-version."ansi-regex"."2.0.0";
  by-version."ansi-regex"."2.0.0" = self.buildNodePackage {
    name = "ansi-regex-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
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
  by-spec."ansi-styles"."^2.1.0" =
    self.by-version."ansi-styles"."2.2.0";
  by-version."ansi-styles"."2.2.0" = self.buildNodePackage {
    name = "ansi-styles-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.0.tgz";
      name = "ansi-styles-2.2.0.tgz";
      sha1 = "c59191936e6ed1c1315a4b6b6b97f3acfbfa68b0";
    };
    deps = {
      "color-convert-1.0.0" = self.by-version."color-convert"."1.0.0";
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
  by-spec."asn1".">=0.2.3 <0.3.0" =
    self.by-version."asn1"."0.2.3";
  by-version."asn1"."0.2.3" = self.buildNodePackage {
    name = "asn1-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz";
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
  by-spec."assert-plus".">=0.2.0 <0.3.0" =
    self.by-version."assert-plus"."0.2.0";
  by-version."assert-plus"."0.2.0" = self.buildNodePackage {
    name = "assert-plus-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.2.0.tgz";
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
  by-spec."assert-plus"."^0.2.0" =
    self.by-version."assert-plus"."0.2.0";
  by-spec."assert-plus"."^1.0.0" =
    self.by-version."assert-plus"."1.0.0";
  by-version."assert-plus"."1.0.0" = self.buildNodePackage {
    name = "assert-plus-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz";
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
  by-spec."async"."0.1.x" =
    self.by-version."async"."0.1.22";
  by-version."async"."0.1.22" = self.buildNodePackage {
    name = "async-0.1.22";
    version = "0.1.22";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
      name = "async-0.1.22.tgz";
      sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."0.2.7" =
    self.by-version."async"."0.2.7";
  by-version."async"."0.2.7" = self.buildNodePackage {
    name = "async-0.2.7";
    version = "0.2.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.2.7.tgz";
      name = "async-0.2.7.tgz";
      sha1 = "44c5ee151aece6c4bf5364cfc7c28fe4e58f18df";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."1.4.2" =
    self.by-version."async"."1.4.2";
  by-version."async"."1.4.2" = self.buildNodePackage {
    name = "async-1.4.2";
    version = "1.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-1.4.2.tgz";
      name = "async-1.4.2.tgz";
      sha1 = "6c9edcb11ced4f0dd2f2d40db0d49a109c088aab";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async".">=0.6.0" =
    self.by-version."async"."1.5.2";
  by-version."async"."1.5.2" = self.buildNodePackage {
    name = "async-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-1.5.2.tgz";
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
  by-spec."aws-sign2"."~0.6.0" =
    self.by-version."aws-sign2"."0.6.0";
  by-version."aws-sign2"."0.6.0" = self.buildNodePackage {
    name = "aws-sign2-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz";
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
    self.by-version."aws4"."1.3.2";
  by-version."aws4"."1.3.2" = self.buildNodePackage {
    name = "aws4-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws4/-/aws4-1.3.2.tgz";
      name = "aws4-1.3.2.tgz";
      sha1 = "d39e0bee412ced0e8ed94a23e314f313a95b9fd1";
    };
    deps = {
      "lru-cache-4.0.0" = self.by-version."lru-cache"."4.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-authorization"."2.0.0" =
    self.by-version."azure-arm-authorization"."2.0.0";
  by-version."azure-arm-authorization"."2.0.0" = self.buildNodePackage {
    name = "azure-arm-authorization-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-authorization/-/azure-arm-authorization-2.0.0.tgz";
      name = "azure-arm-authorization-2.0.0.tgz";
      sha1 = "56b558ba43b9cb5657662251dabe3cb34c16c56f";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-commerce"."0.1.1" =
    self.by-version."azure-arm-commerce"."0.1.1";
  by-version."azure-arm-commerce"."0.1.1" = self.buildNodePackage {
    name = "azure-arm-commerce-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-commerce/-/azure-arm-commerce-0.1.1.tgz";
      name = "azure-arm-commerce-0.1.1.tgz";
      sha1 = "3329693b8aba7d1b84e10ae2655d54262a1f1c59";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-compute"."0.15.0" =
    self.by-version."azure-arm-compute"."0.15.0";
  by-version."azure-arm-compute"."0.15.0" = self.buildNodePackage {
    name = "azure-arm-compute-0.15.0";
    version = "0.15.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-compute/-/azure-arm-compute-0.15.0.tgz";
      name = "azure-arm-compute-0.15.0.tgz";
      sha1 = "a057ba240bd5ee9972c8813066d925204af09e27";
    };
    deps = {
      "ms-rest-1.10.0" = self.by-version."ms-rest"."1.10.0";
      "ms-rest-azure-1.10.0" = self.by-version."ms-rest-azure"."1.10.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-datalake-analytics"."0.1.2" =
    self.by-version."azure-arm-datalake-analytics"."0.1.2";
  by-version."azure-arm-datalake-analytics"."0.1.2" = self.buildNodePackage {
    name = "azure-arm-datalake-analytics-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-datalake-analytics/-/azure-arm-datalake-analytics-0.1.2.tgz";
      name = "azure-arm-datalake-analytics-0.1.2.tgz";
      sha1 = "7b8c26ba3808c220e7c1183f884d72f3e8d915a9";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "moment-2.12.0" = self.by-version."moment"."2.12.0";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-datalake-store"."0.1.2" =
    self.by-version."azure-arm-datalake-store"."0.1.2";
  by-version."azure-arm-datalake-store"."0.1.2" = self.buildNodePackage {
    name = "azure-arm-datalake-store-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-datalake-store/-/azure-arm-datalake-store-0.1.2.tgz";
      name = "azure-arm-datalake-store-0.1.2.tgz";
      sha1 = "dc8be199bfa4c8d4b10efe70d35a2414b8eb8d9a";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-dns"."0.10.1" =
    self.by-version."azure-arm-dns"."0.10.1";
  by-version."azure-arm-dns"."0.10.1" = self.buildNodePackage {
    name = "azure-arm-dns-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-dns/-/azure-arm-dns-0.10.1.tgz";
      name = "azure-arm-dns-0.10.1.tgz";
      sha1 = "8f6dded24a8b8dbc9b81f6b273970ac8ba2a0c54";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-hdinsight"."0.1.0" =
    self.by-version."azure-arm-hdinsight"."0.1.0";
  by-version."azure-arm-hdinsight"."0.1.0" = self.buildNodePackage {
    name = "azure-arm-hdinsight-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-hdinsight/-/azure-arm-hdinsight-0.1.0.tgz";
      name = "azure-arm-hdinsight-0.1.0.tgz";
      sha1 = "10243278ae8cca0de0d68a2cbbe0fc9119a859ef";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-hdinsight-jobs"."0.1.0" =
    self.by-version."azure-arm-hdinsight-jobs"."0.1.0";
  by-version."azure-arm-hdinsight-jobs"."0.1.0" = self.buildNodePackage {
    name = "azure-arm-hdinsight-jobs-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-hdinsight-jobs/-/azure-arm-hdinsight-jobs-0.1.0.tgz";
      name = "azure-arm-hdinsight-jobs-0.1.0.tgz";
      sha1 = "252938f18d4341adf9942261656e791490c3c220";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-insights"."0.10.2" =
    self.by-version."azure-arm-insights"."0.10.2";
  by-version."azure-arm-insights"."0.10.2" = self.buildNodePackage {
    name = "azure-arm-insights-0.10.2";
    version = "0.10.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-insights/-/azure-arm-insights-0.10.2.tgz";
      name = "azure-arm-insights-0.10.2.tgz";
      sha1 = "3aad583c147685e35bc55fd0f013c701882fea42";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "moment-2.6.0" = self.by-version."moment"."2.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-network"."0.12.1" =
    self.by-version."azure-arm-network"."0.12.1";
  by-version."azure-arm-network"."0.12.1" = self.buildNodePackage {
    name = "azure-arm-network-0.12.1";
    version = "0.12.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-network/-/azure-arm-network-0.12.1.tgz";
      name = "azure-arm-network-0.12.1.tgz";
      sha1 = "57c659e9d25f35e2ac0b79a0f78f7d025ceb20b8";
    };
    deps = {
      "ms-rest-1.10.0" = self.by-version."ms-rest"."1.10.0";
      "ms-rest-azure-1.10.0" = self.by-version."ms-rest-azure"."1.10.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-rediscache"."0.2.1" =
    self.by-version."azure-arm-rediscache"."0.2.1";
  by-version."azure-arm-rediscache"."0.2.1" = self.buildNodePackage {
    name = "azure-arm-rediscache-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-rediscache/-/azure-arm-rediscache-0.2.1.tgz";
      name = "azure-arm-rediscache-0.2.1.tgz";
      sha1 = "22e516e7519dd12583e174cca4eeb3b20c993d02";
    };
    deps = {
      "ms-rest-1.10.0" = self.by-version."ms-rest"."1.10.0";
      "ms-rest-azure-1.10.0" = self.by-version."ms-rest-azure"."1.10.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-resource"."1.0.0-preview" =
    self.by-version."azure-arm-resource"."1.0.0-preview";
  by-version."azure-arm-resource"."1.0.0-preview" = self.buildNodePackage {
    name = "azure-arm-resource-1.0.0-preview";
    version = "1.0.0-preview";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-resource/-/azure-arm-resource-1.0.0-preview.tgz";
      name = "azure-arm-resource-1.0.0-preview.tgz";
      sha1 = "c664d4d0f3c4394680106f34359340e3c6a0cac2";
    };
    deps = {
      "ms-rest-1.10.0" = self.by-version."ms-rest"."1.10.0";
      "ms-rest-azure-1.10.0" = self.by-version."ms-rest-azure"."1.10.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-storage"."0.12.2-preview" =
    self.by-version."azure-arm-storage"."0.12.2-preview";
  by-version."azure-arm-storage"."0.12.2-preview" = self.buildNodePackage {
    name = "azure-arm-storage-0.12.2-preview";
    version = "0.12.2-preview";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-storage/-/azure-arm-storage-0.12.2-preview.tgz";
      name = "azure-arm-storage-0.12.2-preview.tgz";
      sha1 = "ecdfe608b58fe7e136f47cd2f4139ee010a724e6";
    };
    deps = {
      "ms-rest-1.10.0" = self.by-version."ms-rest"."1.10.0";
      "ms-rest-azure-1.10.0" = self.by-version."ms-rest-azure"."1.10.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-trafficmanager"."0.10.5" =
    self.by-version."azure-arm-trafficmanager"."0.10.5";
  by-version."azure-arm-trafficmanager"."0.10.5" = self.buildNodePackage {
    name = "azure-arm-trafficmanager-0.10.5";
    version = "0.10.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-trafficmanager/-/azure-arm-trafficmanager-0.10.5.tgz";
      name = "azure-arm-trafficmanager-0.10.5.tgz";
      sha1 = "b42683cb6dfdfed0f93875d72a0b8a53b3204d01";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-arm-website"."0.10.0" =
    self.by-version."azure-arm-website"."0.10.0";
  by-version."azure-arm-website"."0.10.0" = self.buildNodePackage {
    name = "azure-arm-website-0.10.0";
    version = "0.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-arm-website/-/azure-arm-website-0.10.0.tgz";
      name = "azure-arm-website-0.10.0.tgz";
      sha1 = "610400ecb801bff16b7e2d7c1c6d1fe99c4f9ec9";
    };
    deps = {
      "azure-common-0.9.12" = self.by-version."azure-common"."0.9.12";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "moment-2.6.0" = self.by-version."moment"."2.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-compute"."0.13.0" =
    self.by-version."azure-asm-compute"."0.13.0";
  by-version."azure-asm-compute"."0.13.0" = self.buildNodePackage {
    name = "azure-asm-compute-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-compute/-/azure-asm-compute-0.13.0.tgz";
      name = "azure-asm-compute-0.13.0.tgz";
      sha1 = "321999c92fcabb7da852a251cd97f461a0758065";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-hdinsight"."0.10.2" =
    self.by-version."azure-asm-hdinsight"."0.10.2";
  by-version."azure-asm-hdinsight"."0.10.2" = self.buildNodePackage {
    name = "azure-asm-hdinsight-0.10.2";
    version = "0.10.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-hdinsight/-/azure-asm-hdinsight-0.10.2.tgz";
      name = "azure-asm-hdinsight-0.10.2.tgz";
      sha1 = "2d11cdaaa073fc38f31c718991d5923fb7259fa0";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-mgmt"."0.10.1" =
    self.by-version."azure-asm-mgmt"."0.10.1";
  by-version."azure-asm-mgmt"."0.10.1" = self.buildNodePackage {
    name = "azure-asm-mgmt-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-mgmt/-/azure-asm-mgmt-0.10.1.tgz";
      name = "azure-asm-mgmt-0.10.1.tgz";
      sha1 = "d0a44b47ccabf338b19d53271675733cfa2d1751";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-network"."0.10.2" =
    self.by-version."azure-asm-network"."0.10.2";
  by-version."azure-asm-network"."0.10.2" = self.buildNodePackage {
    name = "azure-asm-network-0.10.2";
    version = "0.10.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-network/-/azure-asm-network-0.10.2.tgz";
      name = "azure-asm-network-0.10.2.tgz";
      sha1 = "eeeffd4c3f86f67212c995213fe5d5c1ebddc651";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-sb"."0.10.1" =
    self.by-version."azure-asm-sb"."0.10.1";
  by-version."azure-asm-sb"."0.10.1" = self.buildNodePackage {
    name = "azure-asm-sb-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-sb/-/azure-asm-sb-0.10.1.tgz";
      name = "azure-asm-sb-0.10.1.tgz";
      sha1 = "92487b24166041119714f66760ec1f36e8dc7222";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-sql"."0.10.1" =
    self.by-version."azure-asm-sql"."0.10.1";
  by-version."azure-asm-sql"."0.10.1" = self.buildNodePackage {
    name = "azure-asm-sql-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-sql/-/azure-asm-sql-0.10.1.tgz";
      name = "azure-asm-sql-0.10.1.tgz";
      sha1 = "47728df19a6d4f1cc935235c69fa9cf048cc8f42";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-storage"."0.10.1" =
    self.by-version."azure-asm-storage"."0.10.1";
  by-version."azure-asm-storage"."0.10.1" = self.buildNodePackage {
    name = "azure-asm-storage-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-storage/-/azure-asm-storage-0.10.1.tgz";
      name = "azure-asm-storage-0.10.1.tgz";
      sha1 = "878ad15f6daee36e44f30e5cd348fb61a8f14172";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-subscription"."0.10.1" =
    self.by-version."azure-asm-subscription"."0.10.1";
  by-version."azure-asm-subscription"."0.10.1" = self.buildNodePackage {
    name = "azure-asm-subscription-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-subscription/-/azure-asm-subscription-0.10.1.tgz";
      name = "azure-asm-subscription-0.10.1.tgz";
      sha1 = "917a5e87a04b69c0f5c29339fe910bb5e5e7a04c";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-trafficmanager"."0.10.3" =
    self.by-version."azure-asm-trafficmanager"."0.10.3";
  by-version."azure-asm-trafficmanager"."0.10.3" = self.buildNodePackage {
    name = "azure-asm-trafficmanager-0.10.3";
    version = "0.10.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-trafficmanager/-/azure-asm-trafficmanager-0.10.3.tgz";
      name = "azure-asm-trafficmanager-0.10.3.tgz";
      sha1 = "91e2e63d73869090613cd42ee38a3823e55f4447";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-asm-website"."0.10.1" =
    self.by-version."azure-asm-website"."0.10.1";
  by-version."azure-asm-website"."0.10.1" = self.buildNodePackage {
    name = "azure-asm-website-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-asm-website/-/azure-asm-website-0.10.1.tgz";
      name = "azure-asm-website-0.10.1.tgz";
      sha1 = "0b8fabdb460e3b36ee72836d74630cc9685f572e";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "moment-2.6.0" = self.by-version."moment"."2.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-cli"."*" =
    self.by-version."azure-cli"."0.9.17";
  by-version."azure-cli"."0.9.17" = self.buildNodePackage {
    name = "azure-cli-0.9.17";
    version = "0.9.17";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-cli/-/azure-cli-0.9.17.tgz";
      name = "azure-cli-0.9.17.tgz";
      sha1 = "1f1cd28719c5fb8e201c01bf2a257a0880e743eb";
    };
    deps = {
      "adal-node-0.1.17" = self.by-version."adal-node"."0.1.17";
      "async-1.4.2" = self.by-version."async"."1.4.2";
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "azure-arm-authorization-2.0.0" = self.by-version."azure-arm-authorization"."2.0.0";
      "azure-arm-commerce-0.1.1" = self.by-version."azure-arm-commerce"."0.1.1";
      "azure-arm-compute-0.15.0" = self.by-version."azure-arm-compute"."0.15.0";
      "azure-arm-hdinsight-0.1.0" = self.by-version."azure-arm-hdinsight"."0.1.0";
      "azure-arm-hdinsight-jobs-0.1.0" = self.by-version."azure-arm-hdinsight-jobs"."0.1.0";
      "azure-arm-insights-0.10.2" = self.by-version."azure-arm-insights"."0.10.2";
      "azure-arm-network-0.12.1" = self.by-version."azure-arm-network"."0.12.1";
      "azure-arm-trafficmanager-0.10.5" = self.by-version."azure-arm-trafficmanager"."0.10.5";
      "azure-arm-dns-0.10.1" = self.by-version."azure-arm-dns"."0.10.1";
      "azure-arm-website-0.10.0" = self.by-version."azure-arm-website"."0.10.0";
      "azure-arm-rediscache-0.2.1" = self.by-version."azure-arm-rediscache"."0.2.1";
      "azure-arm-datalake-analytics-0.1.2" = self.by-version."azure-arm-datalake-analytics"."0.1.2";
      "azure-arm-datalake-store-0.1.2" = self.by-version."azure-arm-datalake-store"."0.1.2";
      "azure-extra-0.2.12" = self.by-version."azure-extra"."0.2.12";
      "azure-gallery-2.0.0-pre.18" = self.by-version."azure-gallery"."2.0.0-pre.18";
      "azure-keyvault-0.10.1" = self.by-version."azure-keyvault"."0.10.1";
      "azure-asm-compute-0.13.0" = self.by-version."azure-asm-compute"."0.13.0";
      "azure-asm-hdinsight-0.10.2" = self.by-version."azure-asm-hdinsight"."0.10.2";
      "azure-asm-trafficmanager-0.10.3" = self.by-version."azure-asm-trafficmanager"."0.10.3";
      "azure-asm-mgmt-0.10.1" = self.by-version."azure-asm-mgmt"."0.10.1";
      "azure-monitoring-0.10.2" = self.by-version."azure-monitoring"."0.10.2";
      "azure-asm-network-0.10.2" = self.by-version."azure-asm-network"."0.10.2";
      "azure-arm-resource-1.0.0-preview" = self.by-version."azure-arm-resource"."1.0.0-preview";
      "azure-arm-storage-0.12.2-preview" = self.by-version."azure-arm-storage"."0.12.2-preview";
      "azure-asm-sb-0.10.1" = self.by-version."azure-asm-sb"."0.10.1";
      "azure-asm-sql-0.10.1" = self.by-version."azure-asm-sql"."0.10.1";
      "azure-asm-storage-0.10.1" = self.by-version."azure-asm-storage"."0.10.1";
      "azure-asm-subscription-0.10.1" = self.by-version."azure-asm-subscription"."0.10.1";
      "azure-asm-website-0.10.1" = self.by-version."azure-asm-website"."0.10.1";
      "azure-storage-0.7.0" = self.by-version."azure-storage"."0.7.0";
      "caller-id-0.1.0" = self.by-version."caller-id"."0.1.0";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "commander-1.0.4" = self.by-version."commander"."1.0.4";
      "easy-table-0.0.1" = self.by-version."easy-table"."0.0.1";
      "event-stream-3.1.5" = self.by-version."event-stream"."3.1.5";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "github-0.1.6" = self.by-version."github"."0.1.6";
      "js2xmlparser-1.0.0" = self.by-version."js2xmlparser"."1.0.0";
      "jsrsasign-4.8.2" = self.by-version."jsrsasign"."4.8.2";
      "kuduscript-1.0.6" = self.by-version."kuduscript"."1.0.6";
      "moment-2.6.0" = self.by-version."moment"."2.6.0";
      "ms-rest-azure-1.10.0" = self.by-version."ms-rest-azure"."1.10.0";
      "node-forge-0.6.23" = self.by-version."node-forge"."0.6.23";
      "node-uuid-1.2.0" = self.by-version."node-uuid"."1.2.0";
      "number-is-nan-1.0.0" = self.by-version."number-is-nan"."1.0.0";
      "omelette-0.1.0" = self.by-version."omelette"."0.1.0";
      "openssl-wrapper-0.2.1" = self.by-version."openssl-wrapper"."0.2.1";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "request-2.52.0" = self.by-version."request"."2.52.0";
      "ssh-key-to-pem-0.11.0" = self.by-version."ssh-key-to-pem"."0.11.0";
      "streamline-0.10.17" = self.by-version."streamline"."0.10.17";
      "streamline-streams-0.1.5" = self.by-version."streamline-streams"."0.1.5";
      "through-2.3.4" = self.by-version."through"."2.3.4";
      "tunnel-0.0.2" = self.by-version."tunnel"."0.0.2";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "validator-3.1.0" = self.by-version."validator"."3.1.0";
      "winston-0.6.2" = self.by-version."winston"."0.6.2";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "xml2js-0.1.14" = self.by-version."xml2js"."0.1.14";
      "xmlbuilder-0.4.3" = self.by-version."xmlbuilder"."0.4.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "azure-cli" = self.by-version."azure-cli"."0.9.17";
  by-spec."azure-common"."0.9.12" =
    self.by-version."azure-common"."0.9.12";
  by-version."azure-common"."0.9.12" = self.buildNodePackage {
    name = "azure-common-0.9.12";
    version = "0.9.12";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-common/-/azure-common-0.9.12.tgz";
      name = "azure-common-0.9.12.tgz";
      sha1 = "8ca8167c2dbaa43b61e3caa9c7d98e78908749f6";
    };
    deps = {
      "xml2js-0.2.7" = self.by-version."xml2js"."0.2.7";
      "xmlbuilder-0.4.3" = self.by-version."xmlbuilder"."0.4.3";
      "dateformat-1.0.2-1.2.3" = self.by-version."dateformat"."1.0.2-1.2.3";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "tunnel-0.0.4" = self.by-version."tunnel"."0.0.4";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "validator-3.1.0" = self.by-version."validator"."3.1.0";
      "envconf-0.0.4" = self.by-version."envconf"."0.0.4";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-common"."0.9.16" =
    self.by-version."azure-common"."0.9.16";
  by-version."azure-common"."0.9.16" = self.buildNodePackage {
    name = "azure-common-0.9.16";
    version = "0.9.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-common/-/azure-common-0.9.16.tgz";
      name = "azure-common-0.9.16.tgz";
      sha1 = "0158ce02f7341d08f4146e3e232e3c327d10ac6e";
    };
    deps = {
      "xml2js-0.2.7" = self.by-version."xml2js"."0.2.7";
      "xmlbuilder-0.4.3" = self.by-version."xmlbuilder"."0.4.3";
      "dateformat-1.0.2-1.2.3" = self.by-version."dateformat"."1.0.2-1.2.3";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "tunnel-0.0.4" = self.by-version."tunnel"."0.0.4";
      "request-2.45.0" = self.by-version."request"."2.45.0";
      "validator-3.22.2" = self.by-version."validator"."3.22.2";
      "envconf-0.0.4" = self.by-version."envconf"."0.0.4";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-common"."^0.9.10" =
    self.by-version."azure-common"."0.9.16";
  by-spec."azure-common"."^0.9.13" =
    self.by-version."azure-common"."0.9.16";
  by-spec."azure-extra"."0.2.12" =
    self.by-version."azure-extra"."0.2.12";
  by-version."azure-extra"."0.2.12" = self.buildNodePackage {
    name = "azure-extra-0.2.12";
    version = "0.2.12";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-extra/-/azure-extra-0.2.12.tgz";
      name = "azure-extra-0.2.12.tgz";
      sha1 = "9fa99fb577f678eadcc4d292a9c1aed8aed9d088";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-gallery"."2.0.0-pre.18" =
    self.by-version."azure-gallery"."2.0.0-pre.18";
  by-version."azure-gallery"."2.0.0-pre.18" = self.buildNodePackage {
    name = "azure-gallery-2.0.0-pre.18";
    version = "2.0.0-pre.18";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-gallery/-/azure-gallery-2.0.0-pre.18.tgz";
      name = "azure-gallery-2.0.0-pre.18.tgz";
      sha1 = "3cd4c5e4e0091551d6a5ee757af2354c8a36b3e6";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-keyvault"."0.10.1" =
    self.by-version."azure-keyvault"."0.10.1";
  by-version."azure-keyvault"."0.10.1" = self.buildNodePackage {
    name = "azure-keyvault-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-keyvault/-/azure-keyvault-0.10.1.tgz";
      name = "azure-keyvault-0.10.1.tgz";
      sha1 = "b3899d04b5115a22b794a9e83f89201a66c83855";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-monitoring"."0.10.2" =
    self.by-version."azure-monitoring"."0.10.2";
  by-version."azure-monitoring"."0.10.2" = self.buildNodePackage {
    name = "azure-monitoring-0.10.2";
    version = "0.10.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-monitoring/-/azure-monitoring-0.10.2.tgz";
      name = "azure-monitoring-0.10.2.tgz";
      sha1 = "2b7d493306747b43e4e2dcad44d65328e6c3cf57";
    };
    deps = {
      "azure-common-0.9.16" = self.by-version."azure-common"."0.9.16";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "moment-2.6.0" = self.by-version."moment"."2.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."azure-storage"."0.7.0" =
    self.by-version."azure-storage"."0.7.0";
  by-version."azure-storage"."0.7.0" = self.buildNodePackage {
    name = "azure-storage-0.7.0";
    version = "0.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/azure-storage/-/azure-storage-0.7.0.tgz";
      name = "azure-storage-0.7.0.tgz";
      sha1 = "246fc65adf96b3332043ecbc2b0176506b8a7359";
    };
    deps = {
      "extend-1.2.1" = self.by-version."extend"."1.2.1";
      "browserify-mime-1.2.9" = self.by-version."browserify-mime"."1.2.9";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "readable-stream-2.0.5" = self.by-version."readable-stream"."2.0.5";
      "request-2.57.0" = self.by-version."request"."2.57.0";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "validator-3.22.2" = self.by-version."validator"."3.22.2";
      "xml2js-0.2.7" = self.by-version."xml2js"."0.2.7";
      "xmlbuilder-0.4.3" = self.by-version."xmlbuilder"."0.4.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64-url"."^1.2.1" =
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
  by-spec."base64url"."~1.0.4" =
    self.by-version."base64url"."1.0.6";
  by-version."base64url"."1.0.6" = self.buildNodePackage {
    name = "base64url-1.0.6";
    version = "1.0.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64url/-/base64url-1.0.6.tgz";
      name = "base64url-1.0.6.tgz";
      sha1 = "d64d375d68a7c640d912e2358d170dca5bb54681";
    };
    deps = {
      "concat-stream-1.4.10" = self.by-version."concat-stream"."1.4.10";
      "meow-2.0.0" = self.by-version."meow"."2.0.0";
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
      url = "http://registry.npmjs.org/bl/-/bl-0.9.5.tgz";
      name = "bl-0.9.5.tgz";
      sha1 = "c06b797af085ea00bc527afc8efcf11de2232054";
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
  by-spec."bl"."~1.0.0" =
    self.by-version."bl"."1.0.3";
  by-version."bl"."1.0.3" = self.buildNodePackage {
    name = "bl-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bl/-/bl-1.0.3.tgz";
      name = "bl-1.0.3.tgz";
      sha1 = "fc5421a28fd4226036c3b3891a66a25bc64d226e";
    };
    deps = {
      "readable-stream-2.0.5" = self.by-version."readable-stream"."2.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."^2.9.30" =
    self.by-version."bluebird"."2.10.2";
  by-version."bluebird"."2.10.2" = self.buildNodePackage {
    name = "bluebird-2.10.2";
    version = "2.10.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bluebird/-/bluebird-2.10.2.tgz";
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
    self.by-version."boom"."2.10.1";
  by-version."boom"."2.10.1" = self.buildNodePackage {
    name = "boom-2.10.1";
    version = "2.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-2.10.1.tgz";
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
  by-spec."browserify-mime"."~1.2.9" =
    self.by-version."browserify-mime"."1.2.9";
  by-version."browserify-mime"."1.2.9" = self.buildNodePackage {
    name = "browserify-mime-1.2.9";
    version = "1.2.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/browserify-mime/-/browserify-mime-1.2.9.tgz";
      name = "browserify-mime-1.2.9.tgz";
      sha1 = "aeb1af28de6c0d7a6a2ce40adb68ff18422af31f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-equal-constant-time"."^1.0.1" =
    self.by-version."buffer-equal-constant-time"."1.0.1";
  by-version."buffer-equal-constant-time"."1.0.1" = self.buildNodePackage {
    name = "buffer-equal-constant-time-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/buffer-equal-constant-time/-/buffer-equal-constant-time-1.0.1.tgz";
      name = "buffer-equal-constant-time-1.0.1.tgz";
      sha1 = "f8e71132f7ffe6e01a5c9697a4c6f3e48d5cc819";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caller-id"."0.1.x" =
    self.by-version."caller-id"."0.1.0";
  by-version."caller-id"."0.1.0" = self.buildNodePackage {
    name = "caller-id-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caller-id/-/caller-id-0.1.0.tgz";
      name = "caller-id-0.1.0.tgz";
      sha1 = "59bdac0893d12c3871408279231f97458364f07b";
    };
    deps = {
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase"."^1.0.1" =
    self.by-version."camelcase"."1.2.1";
  by-version."camelcase"."1.2.1" = self.buildNodePackage {
    name = "camelcase-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/camelcase/-/camelcase-1.2.1.tgz";
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
  by-spec."camelcase-keys"."^1.0.0" =
    self.by-version."camelcase-keys"."1.0.0";
  by-version."camelcase-keys"."1.0.0" = self.buildNodePackage {
    name = "camelcase-keys-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/camelcase-keys/-/camelcase-keys-1.0.0.tgz";
      name = "camelcase-keys-1.0.0.tgz";
      sha1 = "bd1a11bf9b31a1ce493493a930de1a0baf4ad7ec";
    };
    deps = {
      "camelcase-1.2.1" = self.by-version."camelcase"."1.2.1";
      "map-obj-1.0.1" = self.by-version."map-obj"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.10.0" =
    self.by-version."caseless"."0.10.0";
  by-version."caseless"."0.10.0" = self.buildNodePackage {
    name = "caseless-0.10.0";
    version = "0.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.10.0.tgz";
      name = "caseless-0.10.0.tgz";
      sha1 = "ed6b2719adcd1fd18f58dc081c0f1a5b43963909";
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
      url = "http://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
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
  by-spec."chalk"."^1.0.0" =
    self.by-version."chalk"."1.1.1";
  by-version."chalk"."1.1.1" = self.buildNodePackage {
    name = "chalk-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-1.1.1.tgz";
      name = "chalk-1.1.1.tgz";
      sha1 = "509afb67066e7499f7eb3535c77445772ae2d019";
    };
    deps = {
      "ansi-styles-2.2.0" = self.by-version."ansi-styles"."2.2.0";
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
    self.by-version."chalk"."1.1.1";
  by-spec."color-convert"."^1.0.0" =
    self.by-version."color-convert"."1.0.0";
  by-version."color-convert"."1.0.0" = self.buildNodePackage {
    name = "color-convert-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/color-convert/-/color-convert-1.0.0.tgz";
      name = "color-convert-1.0.0.tgz";
      sha1 = "3c26fcd885d272d45beacf6e41baba75c89a8579";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."colors"."0.x.x" =
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
  by-spec."combined-stream"."^1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-version."combined-stream"."1.0.5" = self.buildNodePackage {
    name = "combined-stream-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
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
  by-spec."combined-stream"."~1.0.1" =
    self.by-version."combined-stream"."1.0.5";
  by-spec."combined-stream"."~1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-spec."commander"."1.0.4" =
    self.by-version."commander"."1.0.4";
  by-version."commander"."1.0.4" = self.buildNodePackage {
    name = "commander-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-1.0.4.tgz";
      name = "commander-1.0.4.tgz";
      sha1 = "5edeb1aee23c4fb541a6b70d692abef19669a2d3";
    };
    deps = {
      "keypress-0.1.0" = self.by-version."keypress"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."^2.8.1" =
    self.by-version."commander"."2.9.0";
  by-version."commander"."2.9.0" = self.buildNodePackage {
    name = "commander-2.9.0";
    version = "2.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
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
  by-spec."commander"."^2.9.0" =
    self.by-version."commander"."2.9.0";
  by-spec."commander"."~1.1.1" =
    self.by-version."commander"."1.1.1";
  by-version."commander"."1.1.1" = self.buildNodePackage {
    name = "commander-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-1.1.1.tgz";
      name = "commander-1.1.1.tgz";
      sha1 = "50d1651868ae60eccff0a2d9f34595376bc6b041";
    };
    deps = {
      "keypress-0.1.0" = self.by-version."keypress"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."~1.4.7" =
    self.by-version."concat-stream"."1.4.10";
  by-version."concat-stream"."1.4.10" = self.buildNodePackage {
    name = "concat-stream-1.4.10";
    version = "1.4.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/concat-stream/-/concat-stream-1.4.10.tgz";
      name = "concat-stream-1.4.10.tgz";
      sha1 = "acc3bbf5602cb8cc980c6ac840fa7d8603e3ef36";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
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
    self.by-version."cryptiles"."2.0.5";
  by-version."cryptiles"."2.0.5" = self.buildNodePackage {
    name = "cryptiles-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
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
  by-spec."ctype"."0.5.2" =
    self.by-version."ctype"."0.5.2";
  by-version."ctype"."0.5.2" = self.buildNodePackage {
    name = "ctype-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
      name = "ctype-0.5.2.tgz";
      sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
    };
    deps = {
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
  by-spec."dashdash".">=1.10.1 <2.0.0" =
    self.by-version."dashdash"."1.13.0";
  by-version."dashdash"."1.13.0" = self.buildNodePackage {
    name = "dashdash-1.13.0";
    version = "1.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dashdash/-/dashdash-1.13.0.tgz";
      name = "dashdash-1.13.0.tgz";
      sha1 = "a5aae6fd9d8e156624eb0dd9259eb12ba245385a";
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
  by-spec."date-utils"."*" =
    self.by-version."date-utils"."1.2.18";
  by-version."date-utils"."1.2.18" = self.buildNodePackage {
    name = "date-utils-1.2.18";
    version = "1.2.18";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/date-utils/-/date-utils-1.2.18.tgz";
      name = "date-utils-1.2.18.tgz";
      sha1 = "6a55e61b20250e9c24d836b1eaac9b32ee255d51";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dateformat"."1.0.2-1.2.3" =
    self.by-version."dateformat"."1.0.2-1.2.3";
  by-version."dateformat"."1.0.2-1.2.3" = self.buildNodePackage {
    name = "dateformat-1.0.2-1.2.3";
    version = "1.0.2-1.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.2-1.2.3.tgz";
      name = "dateformat-1.0.2-1.2.3.tgz";
      sha1 = "b0220c02de98617433b72851cf47de3df2cdbee9";
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
  by-spec."delayed-stream"."~1.0.0" =
    self.by-version."delayed-stream"."1.0.0";
  by-version."delayed-stream"."1.0.0" = self.buildNodePackage {
    name = "delayed-stream-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
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
  by-spec."easy-table"."0.0.1" =
    self.by-version."easy-table"."0.0.1";
  by-version."easy-table"."0.0.1" = self.buildNodePackage {
    name = "easy-table-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/easy-table/-/easy-table-0.0.1.tgz";
      name = "easy-table-0.0.1.tgz";
      sha1 = "dbd809177a1dd7afc06b4849d1ca7eff13e299eb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ecc-jsbn".">=0.0.1 <1.0.0" =
    self.by-version."ecc-jsbn"."0.1.1";
  by-version."ecc-jsbn"."0.1.1" = self.buildNodePackage {
    name = "ecc-jsbn-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
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
  by-spec."ecdsa-sig-formatter"."^1.0.0" =
    self.by-version."ecdsa-sig-formatter"."1.0.5";
  by-version."ecdsa-sig-formatter"."1.0.5" = self.buildNodePackage {
    name = "ecdsa-sig-formatter-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ecdsa-sig-formatter/-/ecdsa-sig-formatter-1.0.5.tgz";
      name = "ecdsa-sig-formatter-1.0.5.tgz";
      sha1 = "0d0f32b638611f6b8f36ffd305a3e512ea5444e6";
    };
    deps = {
      "base64-url-1.2.1" = self.by-version."base64-url"."1.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."envconf"."~0.0.4" =
    self.by-version."envconf"."0.0.4";
  by-version."envconf"."0.0.4" = self.buildNodePackage {
    name = "envconf-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/envconf/-/envconf-0.0.4.tgz";
      name = "envconf-0.0.4.tgz";
      sha1 = "85675afba237c43f98de2d46adc0e532a4dcf48b";
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
      url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
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
  by-spec."event-stream"."3.1.5" =
    self.by-version."event-stream"."3.1.5";
  by-version."event-stream"."3.1.5" = self.buildNodePackage {
    name = "event-stream-3.1.5";
    version = "3.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/event-stream/-/event-stream-3.1.5.tgz";
      name = "event-stream-3.1.5.tgz";
      sha1 = "6cba5a3ae02a7e4967d65ad04ef12502a2fff66c";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "from-0.1.3" = self.by-version."from"."0.1.3";
      "map-stream-0.1.0" = self.by-version."map-stream"."0.1.0";
      "pause-stream-0.0.11" = self.by-version."pause-stream"."0.0.11";
      "split-0.2.10" = self.by-version."split"."0.2.10";
      "stream-combiner-0.0.4" = self.by-version."stream-combiner"."0.0.4";
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
  by-spec."extend"."~3.0.0" =
    self.by-version."extend"."3.0.0";
  by-version."extend"."3.0.0" = self.buildNodePackage {
    name = "extend-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
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
  by-spec."extsprintf"."1.0.2" =
    self.by-version."extsprintf"."1.0.2";
  by-version."extsprintf"."1.0.2" = self.buildNodePackage {
    name = "extsprintf-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
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
  by-spec."eyes"."0.x.x" =
    self.by-version."eyes"."0.1.8";
  by-spec."fibers"."^1.0.1" =
    self.by-version."fibers"."1.0.10";
  by-version."fibers"."1.0.10" = self.buildNodePackage {
    name = "fibers-1.0.10";
    version = "1.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fibers/-/fibers-1.0.10.tgz";
      name = "fibers-1.0.10.tgz";
      sha1 = "0ccea7287e5dafd2626c2c9d3f15113a1b5829cd";
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
  by-spec."forever-agent"."~0.6.0" =
    self.by-version."forever-agent"."0.6.1";
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
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.6.1" =
    self.by-version."forever-agent"."0.6.1";
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
      "async-0.9.2" = self.by-version."async"."0.9.2";
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
  by-spec."form-data"."~1.0.0-rc3" =
    self.by-version."form-data"."1.0.0-rc3";
  by-version."form-data"."1.0.0-rc3" = self.buildNodePackage {
    name = "form-data-1.0.0-rc3";
    version = "1.0.0-rc3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc3.tgz";
      name = "form-data-1.0.0-rc3.tgz";
      sha1 = "d35bc62e7fbc2937ae78f948aaa0d38d90607577";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.10" = self.by-version."mime-types"."2.1.10";
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
  by-spec."galaxy"."^0.1.11" =
    self.by-version."galaxy"."0.1.12";
  by-version."galaxy"."0.1.12" = self.buildNodePackage {
    name = "galaxy-0.1.12";
    version = "0.1.12";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/galaxy/-/galaxy-0.1.12.tgz";
      name = "galaxy-0.1.12.tgz";
      sha1 = "0c989774f2870c69378aa665648cdc60f343aa53";
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
      url = "http://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
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
      url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
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
  by-spec."github"."0.1.6" =
    self.by-version."github"."0.1.6";
  by-version."github"."0.1.6" = self.buildNodePackage {
    name = "github-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/github/-/github-0.1.6.tgz";
      name = "github-0.1.6.tgz";
      sha1 = "1344e694f8d20ef9b29bcbfd1ca5eb4f7a287922";
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
      url = "http://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
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
  by-spec."har-validator"."^1.6.1" =
    self.by-version."har-validator"."1.8.0";
  by-version."har-validator"."1.8.0" = self.buildNodePackage {
    name = "har-validator-1.8.0";
    version = "1.8.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/har-validator/-/har-validator-1.8.0.tgz";
      name = "har-validator-1.8.0.tgz";
      sha1 = "d83842b0eb4c435960aeb108a067a3aa94c0eeb2";
    };
    deps = {
      "bluebird-2.10.2" = self.by-version."bluebird"."2.10.2";
      "chalk-1.1.1" = self.by-version."chalk"."1.1.1";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "is-my-json-valid-2.13.1" = self.by-version."is-my-json-valid"."2.13.1";
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
      url = "http://registry.npmjs.org/har-validator/-/har-validator-2.0.6.tgz";
      name = "har-validator-2.0.6.tgz";
      sha1 = "cdcbc08188265ad119b6a5a7c8ab70eecfb5d27d";
    };
    deps = {
      "chalk-1.1.1" = self.by-version."chalk"."1.1.1";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "is-my-json-valid-2.13.1" = self.by-version."is-my-json-valid"."2.13.1";
      "pinkie-promise-2.0.0" = self.by-version."pinkie-promise"."2.0.0";
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
      url = "http://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
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
  by-spec."hawk"."~3.1.0" =
    self.by-version."hawk"."3.1.3";
  by-version."hawk"."3.1.3" = self.buildNodePackage {
    name = "hawk-3.1.3";
    version = "3.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-3.1.3.tgz";
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
    self.by-version."hoek"."2.16.3";
  by-version."hoek"."2.16.3" = self.buildNodePackage {
    name = "hoek-2.16.3";
    version = "2.16.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
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
  by-spec."http-signature"."~0.11.0" =
    self.by-version."http-signature"."0.11.0";
  by-version."http-signature"."0.11.0" = self.buildNodePackage {
    name = "http-signature-0.11.0";
    version = "0.11.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-signature/-/http-signature-0.11.0.tgz";
      name = "http-signature-0.11.0.tgz";
      sha1 = "1796cf67a001ad5cd6849dca0991485f09089fe6";
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
      url = "http://registry.npmjs.org/http-signature/-/http-signature-1.1.1.tgz";
      name = "http-signature-1.1.1.tgz";
      sha1 = "df72e267066cd0ac67fb76adf8e134a8fbcf91bf";
    };
    deps = {
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
      "jsprim-1.2.2" = self.by-version."jsprim"."1.2.2";
      "sshpk-1.7.4" = self.by-version."sshpk"."1.7.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."indent-string"."^1.1.0" =
    self.by-version."indent-string"."1.2.2";
  by-version."indent-string"."1.2.2" = self.buildNodePackage {
    name = "indent-string-1.2.2";
    version = "1.2.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/indent-string/-/indent-string-1.2.2.tgz";
      name = "indent-string-1.2.2.tgz";
      sha1 = "db99bcc583eb6abbb1e48dcbb1999a986041cb6b";
    };
    deps = {
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "repeating-1.1.3" = self.by-version."repeating"."1.1.3";
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
  by-spec."is-my-json-valid"."^2.12.0" =
    self.by-version."is-my-json-valid"."2.13.1";
  by-version."is-my-json-valid"."2.13.1" = self.buildNodePackage {
    name = "is-my-json-valid-2.13.1";
    version = "2.13.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.13.1.tgz";
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
  by-spec."is-property"."^1.0.0" =
    self.by-version."is-property"."1.0.2";
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
      url = "http://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz";
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
  by-spec."isstream"."~0.1.2" =
    self.by-version."isstream"."0.1.2";
  by-spec."jodid25519".">=1.0.0 <2.0.0" =
    self.by-version."jodid25519"."1.0.2";
  by-version."jodid25519"."1.0.2" = self.buildNodePackage {
    name = "jodid25519-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jodid25519/-/jodid25519-1.0.2.tgz";
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
  by-spec."js2xmlparser"."1.0.0" =
    self.by-version."js2xmlparser"."1.0.0";
  by-version."js2xmlparser"."1.0.0" = self.buildNodePackage {
    name = "js2xmlparser-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/js2xmlparser/-/js2xmlparser-1.0.0.tgz";
      name = "js2xmlparser-1.0.0.tgz";
      sha1 = "5a170f2e8d6476ce45405e04823242513782fe30";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsbn".">=0.1.0 <0.2.0" =
    self.by-version."jsbn"."0.1.0";
  by-version."jsbn"."0.1.0" = self.buildNodePackage {
    name = "jsbn-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsbn/-/jsbn-0.1.0.tgz";
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
  by-spec."jsbn"."~0.1.0" =
    self.by-version."jsbn"."0.1.0";
  by-spec."json-schema"."0.2.2" =
    self.by-version."json-schema"."0.2.2";
  by-version."json-schema"."0.2.2" = self.buildNodePackage {
    name = "json-schema-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
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
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-version."json-stringify-safe"."5.0.1" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.1";
    version = "5.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
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
  by-spec."jsonpointer"."2.0.0" =
    self.by-version."jsonpointer"."2.0.0";
  by-version."jsonpointer"."2.0.0" = self.buildNodePackage {
    name = "jsonpointer-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-2.0.0.tgz";
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
    self.by-version."jsprim"."1.2.2";
  by-version."jsprim"."1.2.2" = self.buildNodePackage {
    name = "jsprim-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsprim/-/jsprim-1.2.2.tgz";
      name = "jsprim-1.2.2.tgz";
      sha1 = "f20c906ac92abd58e3b79ac8bc70a48832512da1";
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
  by-spec."jsrsasign"."4.8.2 " =
    self.by-version."jsrsasign"."4.8.2";
  by-version."jsrsasign"."4.8.2" = self.buildNodePackage {
    name = "jsrsasign-4.8.2";
    version = "4.8.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsrsasign/-/jsrsasign-4.8.2.tgz";
      name = "jsrsasign-4.8.2.tgz";
      sha1 = "bd0a7040d426d7598d6c742ec8f875d0e88644a9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jwa"."^1.1.2" =
    self.by-version."jwa"."1.1.3";
  by-version."jwa"."1.1.3" = self.buildNodePackage {
    name = "jwa-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jwa/-/jwa-1.1.3.tgz";
      name = "jwa-1.1.3.tgz";
      sha1 = "fa9f2f005ff0c630e7c41526a31f37f79733cd6d";
    };
    deps = {
      "base64url-1.0.6" = self.by-version."base64url"."1.0.6";
      "buffer-equal-constant-time-1.0.1" = self.by-version."buffer-equal-constant-time"."1.0.1";
      "ecdsa-sig-formatter-1.0.5" = self.by-version."ecdsa-sig-formatter"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jws"."3.x.x" =
    self.by-version."jws"."3.1.3";
  by-version."jws"."3.1.3" = self.buildNodePackage {
    name = "jws-3.1.3";
    version = "3.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jws/-/jws-3.1.3.tgz";
      name = "jws-3.1.3.tgz";
      sha1 = "b88f1b4581a2c5ee8813c06b3fdf90ea9b5c7e6c";
    };
    deps = {
      "base64url-1.0.6" = self.by-version."base64url"."1.0.6";
      "jwa-1.1.3" = self.by-version."jwa"."1.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keypress"."0.1.x" =
    self.by-version."keypress"."0.1.0";
  by-version."keypress"."0.1.0" = self.buildNodePackage {
    name = "keypress-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keypress/-/keypress-0.1.0.tgz";
      name = "keypress-0.1.0.tgz";
      sha1 = "4a3188d4291b66b4f65edb99f806aa9ae293592a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kuduscript"."1.0.6" =
    self.by-version."kuduscript"."1.0.6";
  by-version."kuduscript"."1.0.6" = self.buildNodePackage {
    name = "kuduscript-1.0.6";
    version = "1.0.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/kuduscript/-/kuduscript-1.0.6.tgz";
      name = "kuduscript-1.0.6.tgz";
      sha1 = "466628f1d4f68d972a28939012e055156bdbcf16";
    };
    deps = {
      "commander-1.1.1" = self.by-version."commander"."1.1.1";
      "streamline-0.4.11" = self.by-version."streamline"."0.4.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."^4.0.0" =
    self.by-version."lru-cache"."4.0.0";
  by-version."lru-cache"."4.0.0" = self.buildNodePackage {
    name = "lru-cache-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-4.0.0.tgz";
      name = "lru-cache-4.0.0.tgz";
      sha1 = "b5cbf01556c16966febe54ceec0fb4dc90df6c28";
    };
    deps = {
      "pseudomap-1.0.2" = self.by-version."pseudomap"."1.0.2";
      "yallist-2.0.0" = self.by-version."yallist"."2.0.0";
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
  by-spec."meow"."~2.0.0" =
    self.by-version."meow"."2.0.0";
  by-version."meow"."2.0.0" = self.buildNodePackage {
    name = "meow-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/meow/-/meow-2.0.0.tgz";
      name = "meow-2.0.0.tgz";
      sha1 = "8f530a8ecf5d40d3f4b4df93c3472900fba2a8f1";
    };
    deps = {
      "camelcase-keys-1.0.0" = self.by-version."camelcase-keys"."1.0.0";
      "indent-string-1.2.2" = self.by-version."indent-string"."1.2.2";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "object-assign-1.0.0" = self.by-version."object-assign"."1.0.0";
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
  by-spec."mime-db"."~1.22.0" =
    self.by-version."mime-db"."1.22.0";
  by-version."mime-db"."1.22.0" = self.buildNodePackage {
    name = "mime-db-1.22.0";
    version = "1.22.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.22.0.tgz";
      name = "mime-db-1.22.0.tgz";
      sha1 = "ab23a6372dc9d86d3dc9121bd0ebd38105a1904a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.3" =
    self.by-version."mime-types"."2.1.10";
  by-version."mime-types"."2.1.10" = self.buildNodePackage {
    name = "mime-types-2.1.10";
    version = "2.1.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.10.tgz";
      name = "mime-types-2.1.10.tgz";
      sha1 = "b93c7cb4362e16d41072a7e54538fb4d43070837";
    };
    deps = {
      "mime-db-1.22.0" = self.by-version."mime-db"."1.22.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.14";
  by-spec."mime-types"."~2.1.7" =
    self.by-version."mime-types"."2.1.10";
  by-spec."minimist"."^1.1.0" =
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
  by-spec."moment"."2.6.0" =
    self.by-version."moment"."2.6.0";
  by-version."moment"."2.6.0" = self.buildNodePackage {
    name = "moment-2.6.0";
    version = "2.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/moment/-/moment-2.6.0.tgz";
      name = "moment-2.6.0.tgz";
      sha1 = "0765b72b841dd213fa91914c0f6765122719f061";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."moment"."^2.6.0" =
    self.by-version."moment"."2.12.0";
  by-version."moment"."2.12.0" = self.buildNodePackage {
    name = "moment-2.12.0";
    version = "2.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/moment/-/moment-2.12.0.tgz";
      name = "moment-2.12.0.tgz";
      sha1 = "dc2560d19838d6c0731b1a6afa04675264d360d6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms-rest"."^1.10.0" =
    self.by-version."ms-rest"."1.10.0";
  by-version."ms-rest"."1.10.0" = self.buildNodePackage {
    name = "ms-rest-1.10.0";
    version = "1.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms-rest/-/ms-rest-1.10.0.tgz";
      name = "ms-rest-1.10.0.tgz";
      sha1 = "d1d9a93f3c7f7189500475ac680875ed1da56d99";
    };
    deps = {
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "tunnel-0.0.4" = self.by-version."tunnel"."0.0.4";
      "request-2.69.0" = self.by-version."request"."2.69.0";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "through-2.3.8" = self.by-version."through"."2.3.8";
      "moment-2.12.0" = self.by-version."moment"."2.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms-rest"."^1.8.0" =
    self.by-version."ms-rest"."1.10.0";
  by-spec."ms-rest-azure"."^1.8.0" =
    self.by-version."ms-rest-azure"."1.10.0";
  by-version."ms-rest-azure"."1.10.0" = self.buildNodePackage {
    name = "ms-rest-azure-1.10.0";
    version = "1.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms-rest-azure/-/ms-rest-azure-1.10.0.tgz";
      name = "ms-rest-azure-1.10.0.tgz";
      sha1 = "467f481de7f3f10b5d020de393d0de71ada6278a";
    };
    deps = {
      "async-0.2.7" = self.by-version."async"."0.2.7";
      "uuid-2.0.1" = self.by-version."uuid"."2.0.1";
      "adal-node-0.1.16" = self.by-version."adal-node"."0.1.16";
      "ms-rest-1.10.0" = self.by-version."ms-rest"."1.10.0";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "moment-2.12.0" = self.by-version."moment"."2.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-forge"."0.6.23" =
    self.by-version."node-forge"."0.6.23";
  by-version."node-forge"."0.6.23" = self.buildNodePackage {
    name = "node-forge-0.6.23";
    version = "0.6.23";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-forge/-/node-forge-0.6.23.tgz";
      name = "node-forge-0.6.23.tgz";
      sha1 = "f03cf65ebd5d4d9dd2f7becb57ceaf78ed94a2bf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."1.2.0" =
    self.by-version."node-uuid"."1.2.0";
  by-version."node-uuid"."1.2.0" = self.buildNodePackage {
    name = "node-uuid-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.2.0.tgz";
      name = "node-uuid-1.2.0.tgz";
      sha1 = "81a9fe32934719852499b58b2523d2cd5fdfd65b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."1.4.1" =
    self.by-version."node-uuid"."1.4.1";
  by-version."node-uuid"."1.4.1" = self.buildNodePackage {
    name = "node-uuid-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
      name = "node-uuid-1.4.1.tgz";
      sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid".">= 1.3.3" =
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
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.7";
  by-spec."node-uuid"."~1.4.7" =
    self.by-version."node-uuid"."1.4.7";
  by-spec."number-is-nan"."1.0.0" =
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
  by-spec."number-is-nan"."^1.0.0" =
    self.by-version."number-is-nan"."1.0.0";
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
  by-spec."oauth-sign"."~0.8.0" =
    self.by-version."oauth-sign"."0.8.1";
  by-version."oauth-sign"."0.8.1" = self.buildNodePackage {
    name = "oauth-sign-0.8.1";
    version = "0.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.1.tgz";
      name = "oauth-sign-0.8.1.tgz";
      sha1 = "182439bdb91378bf7460e75c64ea43e6448def06";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^1.0.0" =
    self.by-version."object-assign"."1.0.0";
  by-version."object-assign"."1.0.0" = self.buildNodePackage {
    name = "object-assign-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-assign/-/object-assign-1.0.0.tgz";
      name = "object-assign-1.0.0.tgz";
      sha1 = "e65dc8766d3b47b4b8307465c8311da030b070a6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."omelette"."0.1.0" =
    self.by-version."omelette"."0.1.0";
  by-version."omelette"."0.1.0" = self.buildNodePackage {
    name = "omelette-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/omelette/-/omelette-0.1.0.tgz";
      name = "omelette-0.1.0.tgz";
      sha1 = "31cc7eb472a513c07483d24d3e1bf164cb0d23b8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."openssl-wrapper"."0.2.1" =
    self.by-version."openssl-wrapper"."0.2.1";
  by-version."openssl-wrapper"."0.2.1" = self.buildNodePackage {
    name = "openssl-wrapper-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/openssl-wrapper/-/openssl-wrapper-0.2.1.tgz";
      name = "openssl-wrapper-0.2.1.tgz";
      sha1 = "ff2d6552c83bb14437edc0371784704c75289473";
    };
    deps = {
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "q-0.9.7" = self.by-version."q"."0.9.7";
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
  by-spec."pinkie"."^2.0.0" =
    self.by-version."pinkie"."2.0.4";
  by-version."pinkie"."2.0.4" = self.buildNodePackage {
    name = "pinkie-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz";
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
      "pinkie-2.0.4" = self.by-version."pinkie"."2.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pkginfo"."0.2.x" =
    self.by-version."pkginfo"."0.2.3";
  by-version."pkginfo"."0.2.3" = self.buildNodePackage {
    name = "pkginfo-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.2.3.tgz";
      name = "pkginfo-0.2.3.tgz";
      sha1 = "7239c42a5ef6c30b8f328439d9b9ff71042490f8";
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
  by-spec."pseudomap"."^1.0.1" =
    self.by-version."pseudomap"."1.0.2";
  by-version."pseudomap"."1.0.2" = self.buildNodePackage {
    name = "pseudomap-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pseudomap/-/pseudomap-1.0.2.tgz";
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
  by-spec."q"."~0.9.3" =
    self.by-version."q"."0.9.7";
  by-version."q"."0.9.7" = self.buildNodePackage {
    name = "q-0.9.7";
    version = "0.9.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
      name = "q-0.9.7.tgz";
      sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
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
  by-spec."qs"."~3.1.0" =
    self.by-version."qs"."3.1.0";
  by-version."qs"."3.1.0" = self.buildNodePackage {
    name = "qs-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-3.1.0.tgz";
      name = "qs-3.1.0.tgz";
      sha1 = "d0e9ae745233a12dc43fb4f3055bba446261153c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~6.0.2" =
    self.by-version."qs"."6.0.2";
  by-version."qs"."6.0.2" = self.buildNodePackage {
    name = "qs-6.0.2";
    version = "6.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-6.0.2.tgz";
      name = "qs-6.0.2.tgz";
      sha1 = "88c68d590e8ed56c76c79f352c17b982466abfcd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."~1.0.0" =
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
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."readable-stream"."~1.1.9" =
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
  by-spec."readable-stream"."~2.0.0" =
    self.by-version."readable-stream"."2.0.5";
  by-version."readable-stream"."2.0.5" = self.buildNodePackage {
    name = "readable-stream-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-2.0.5.tgz";
      name = "readable-stream-2.0.5.tgz";
      sha1 = "a2426f8dcd4551c77a33f96edf2886a23c829669";
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
  by-spec."readable-stream"."~2.0.5" =
    self.by-version."readable-stream"."2.0.5";
  by-spec."repeating"."^1.1.0" =
    self.by-version."repeating"."1.1.3";
  by-version."repeating"."1.1.3" = self.buildNodePackage {
    name = "repeating-1.1.3";
    version = "1.1.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/repeating/-/repeating-1.1.3.tgz";
      name = "repeating-1.1.3.tgz";
      sha1 = "3d4114218877537494f97f77f9785fab810fa4ac";
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
  by-spec."request"."2.45.0" =
    self.by-version."request"."2.45.0";
  by-version."request"."2.45.0" = self.buildNodePackage {
    name = "request-2.45.0";
    version = "2.45.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.45.0.tgz";
      name = "request-2.45.0.tgz";
      sha1 = "29d713a0a07f17fb2e7b61815d2010681718e93c";
    };
    deps = {
      "bl-0.9.5" = self.by-version."bl"."0.9.5";
      "caseless-0.6.0" = self.by-version."caseless"."0.6.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "qs-1.2.2" = self.by-version."qs"."1.2.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "tunnel-agent-0.4.2" = self.by-version."tunnel-agent"."0.4.2";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
    };
    optionalDependencies = {
      "tough-cookie-2.2.2" = self.by-version."tough-cookie"."2.2.2";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.4.0" = self.by-version."oauth-sign"."0.4.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2.52.0" =
    self.by-version."request"."2.52.0";
  by-version."request"."2.52.0" = self.buildNodePackage {
    name = "request-2.52.0";
    version = "2.52.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.52.0.tgz";
      name = "request-2.52.0.tgz";
      sha1 = "02d82a8adc04dc94a3a79f09fc850ade9aa21e74";
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
      "tunnel-agent-0.4.2" = self.by-version."tunnel-agent"."0.4.2";
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
  by-spec."request"."2.69.0" =
    self.by-version."request"."2.69.0";
  by-version."request"."2.69.0" = self.buildNodePackage {
    name = "request-2.69.0";
    version = "2.69.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.69.0.tgz";
      name = "request-2.69.0.tgz";
      sha1 = "cf91d2e000752b1217155c005241911991a2346a";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.3.2" = self.by-version."aws4"."1.3.2";
      "bl-1.0.3" = self.by-version."bl"."1.0.3";
      "caseless-0.11.0" = self.by-version."caseless"."0.11.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-1.0.0-rc3" = self.by-version."form-data"."1.0.0-rc3";
      "har-validator-2.0.6" = self.by-version."har-validator"."2.0.6";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.10" = self.by-version."mime-types"."2.1.10";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "oauth-sign-0.8.1" = self.by-version."oauth-sign"."0.8.1";
      "qs-6.0.2" = self.by-version."qs"."6.0.2";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.2.2" = self.by-version."tough-cookie"."2.2.2";
      "tunnel-agent-0.4.2" = self.by-version."tunnel-agent"."0.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2.9.x" =
    self.by-version."request"."2.9.203";
  by-version."request"."2.9.203" = self.buildNodePackage {
    name = "request-2.9.203";
    version = "2.9.203";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.9.203.tgz";
      name = "request-2.9.203.tgz";
      sha1 = "6c1711a5407fb94a114219563e44145bcbf4723a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request".">= 2.52.0" =
    self.by-version."request"."2.69.0";
  by-spec."request".">= 2.9.203" =
    self.by-version."request"."2.69.0";
  by-spec."request"."~2.57.0" =
    self.by-version."request"."2.57.0";
  by-version."request"."2.57.0" = self.buildNodePackage {
    name = "request-2.57.0";
    version = "2.57.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.57.0.tgz";
      name = "request-2.57.0.tgz";
      sha1 = "d445105a42d009b9d724289633b449a6d723d989";
    };
    deps = {
      "bl-0.9.5" = self.by-version."bl"."0.9.5";
      "caseless-0.10.0" = self.by-version."caseless"."0.10.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "qs-3.1.0" = self.by-version."qs"."3.1.0";
      "tunnel-agent-0.4.2" = self.by-version."tunnel-agent"."0.4.2";
      "tough-cookie-2.2.2" = self.by-version."tough-cookie"."2.2.2";
      "http-signature-0.11.0" = self.by-version."http-signature"."0.11.0";
      "oauth-sign-0.8.1" = self.by-version."oauth-sign"."0.8.1";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.8.0" = self.by-version."har-validator"."1.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sax"."0.5.2" =
    self.by-version."sax"."0.5.2";
  by-version."sax"."0.5.2" = self.buildNodePackage {
    name = "sax-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sax/-/sax-0.5.2.tgz";
      name = "sax-0.5.2.tgz";
      sha1 = "735ffaa39a1cff8ffb9598f0223abdb03a9fb2ea";
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
    self.by-version."sax"."1.1.6";
  by-version."sax"."1.1.6" = self.buildNodePackage {
    name = "sax-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sax/-/sax-1.1.6.tgz";
      name = "sax-1.1.6.tgz";
      sha1 = "5d616be8a5e607d54e114afae55b7eaf2fcc3240";
    };
    deps = {
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
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.1.43" =
    self.by-version."source-map"."0.1.43";
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
      "amdefine-1.0.0" = self.by-version."amdefine"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."split"."0.2" =
    self.by-version."split"."0.2.10";
  by-version."split"."0.2.10" = self.buildNodePackage {
    name = "split-0.2.10";
    version = "0.2.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/split/-/split-0.2.10.tgz";
      name = "split-0.2.10.tgz";
      sha1 = "67097c601d697ce1368f418f06cd201cf0521a57";
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
  by-spec."ssh-key-to-pem"."0.11.0" =
    self.by-version."ssh-key-to-pem"."0.11.0";
  by-version."ssh-key-to-pem"."0.11.0" = self.buildNodePackage {
    name = "ssh-key-to-pem-0.11.0";
    version = "0.11.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ssh-key-to-pem/-/ssh-key-to-pem-0.11.0.tgz";
      name = "ssh-key-to-pem-0.11.0.tgz";
      sha1 = "512675a28f08f1e581779e1989ab1e13effb49e4";
    };
    deps = {
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.2" = self.by-version."ctype"."0.5.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sshpk"."^1.7.0" =
    self.by-version."sshpk"."1.7.4";
  by-version."sshpk"."1.7.4" = self.buildNodePackage {
    name = "sshpk-1.7.4";
    version = "1.7.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/sshpk/-/sshpk-1.7.4.tgz";
      name = "sshpk-1.7.4.tgz";
      sha1 = "ad7b47defca61c8415d964243b62b0ce60fbca38";
    };
    deps = {
      "asn1-0.2.3" = self.by-version."asn1"."0.2.3";
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
      "dashdash-1.13.0" = self.by-version."dashdash"."1.13.0";
    };
    optionalDependencies = {
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
      "tweetnacl-0.14.1" = self.by-version."tweetnacl"."0.14.1";
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
  by-spec."stack-trace"."~0.0.7" =
    self.by-version."stack-trace"."0.0.9";
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
  by-spec."streamline"."0.10.17" =
    self.by-version."streamline"."0.10.17";
  by-version."streamline"."0.10.17" = self.buildNodePackage {
    name = "streamline-0.10.17";
    version = "0.10.17";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/streamline/-/streamline-0.10.17.tgz";
      name = "streamline-0.10.17.tgz";
      sha1 = "fa2170da74194dbd0b54f756523f0d0d370426af";
    };
    deps = {
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
    };
    optionalDependencies = {
      "fibers-1.0.10" = self.by-version."fibers"."1.0.10";
      "galaxy-0.1.12" = self.by-version."galaxy"."0.1.12";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."streamline"."~0.4.10" =
    self.by-version."streamline"."0.4.11";
  by-version."streamline"."0.4.11" = self.buildNodePackage {
    name = "streamline-0.4.11";
    version = "0.4.11";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/streamline/-/streamline-0.4.11.tgz";
      name = "streamline-0.4.11.tgz";
      sha1 = "0e3c4f24a3f052b231b12d5049085a0a099be782";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."streamline-streams"."0.1.5" =
    self.by-version."streamline-streams"."0.1.5";
  by-version."streamline-streams"."0.1.5" = self.buildNodePackage {
    name = "streamline-streams-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/streamline-streams/-/streamline-streams-0.1.5.tgz";
      name = "streamline-streams-0.1.5.tgz";
      sha1 = "5b0ff80cf543f603cc3438ed178ca2aec7899b54";
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
  by-spec."stringstream"."~0.0.4" =
    self.by-version."stringstream"."0.0.5";
  by-version."stringstream"."0.0.5" = self.buildNodePackage {
    name = "stringstream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
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
      url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz";
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
  by-spec."supports-color"."^2.0.0" =
    self.by-version."supports-color"."2.0.0";
  by-version."supports-color"."2.0.0" = self.buildNodePackage {
    name = "supports-color-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
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
  by-spec."through"."2.3.4" =
    self.by-version."through"."2.3.4";
  by-version."through"."2.3.4" = self.buildNodePackage {
    name = "through-2.3.4";
    version = "2.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/through/-/through-2.3.4.tgz";
      name = "through-2.3.4.tgz";
      sha1 = "495e40e8d8a8eaebc7c275ea88c2b8fc14c56455";
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
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.8";
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."2.2.2";
  by-version."tough-cookie"."2.2.2" = self.buildNodePackage {
    name = "tough-cookie-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-2.2.2.tgz";
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
  by-spec."tunnel"."0.0.2" =
    self.by-version."tunnel"."0.0.2";
  by-version."tunnel"."0.0.2" = self.buildNodePackage {
    name = "tunnel-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel/-/tunnel-0.0.2.tgz";
      name = "tunnel-0.0.2.tgz";
      sha1 = "f23bcd8b7a7b8a864261b2084f66f93193396334";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel"."~0.0.2" =
    self.by-version."tunnel"."0.0.4";
  by-version."tunnel"."0.0.4" = self.buildNodePackage {
    name = "tunnel-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel/-/tunnel-0.0.4.tgz";
      name = "tunnel-0.0.4.tgz";
      sha1 = "2d3785a158c174c9a16dc2c046ec5fc5f1742213";
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
    self.by-version."tunnel-agent"."0.4.2";
  by-version."tunnel-agent"."0.4.2" = self.buildNodePackage {
    name = "tunnel-agent-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.2.tgz";
      name = "tunnel-agent-0.4.2.tgz";
      sha1 = "1104e3f36ac87125c287270067d582d18133bfee";
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
    self.by-version."tunnel-agent"."0.4.2";
  by-spec."tweetnacl".">=0.13.0 <1.0.0" =
    self.by-version."tweetnacl"."0.14.1";
  by-version."tweetnacl"."0.14.1" = self.buildNodePackage {
    name = "tweetnacl-0.14.1";
    version = "0.14.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.1.tgz";
      name = "tweetnacl-0.14.1.tgz";
      sha1 = "37c6a1fb5cd4b63b7acee450d8419d9c0024cc03";
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
  by-version."typedarray"."0.0.6" = self.buildNodePackage {
    name = "typedarray-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
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
  by-spec."underscore".">= 1.3.1" =
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
  by-spec."underscore"."^1.4.0" =
    self.by-version."underscore"."1.8.3";
  by-spec."underscore"."~1.4.4" =
    self.by-version."underscore"."1.4.4";
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
  by-spec."uuid"."2.0.1" =
    self.by-version."uuid"."2.0.1";
  by-version."uuid"."2.0.1" = self.buildNodePackage {
    name = "uuid-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/uuid/-/uuid-2.0.1.tgz";
      name = "uuid-2.0.1.tgz";
      sha1 = "c2a30dedb3e535d72ccf82e343941a50ba8533ac";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."validator"."~3.1.0" =
    self.by-version."validator"."3.1.0";
  by-version."validator"."3.1.0" = self.buildNodePackage {
    name = "validator-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/validator/-/validator-3.1.0.tgz";
      name = "validator-3.1.0.tgz";
      sha1 = "2ea1ff7e92254d69367f385f015299e5ead8755b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."validator"."~3.22.2" =
    self.by-version."validator"."3.22.2";
  by-version."validator"."3.22.2" = self.buildNodePackage {
    name = "validator-3.22.2";
    version = "3.22.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/validator/-/validator-3.22.2.tgz";
      name = "validator-3.22.2.tgz";
      sha1 = "6f297ae67f7f82acc76d0afdb49f18d9a09c18c0";
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
      url = "http://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
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
  by-spec."winston"."0.6.x" =
    self.by-version."winston"."0.6.2";
  by-version."winston"."0.6.2" = self.buildNodePackage {
    name = "winston-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/winston/-/winston-0.6.2.tgz";
      name = "winston-0.6.2.tgz";
      sha1 = "4144fe2586cdc19a612bf8c035590132c9064bd2";
    };
    deps = {
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.2.3" = self.by-version."pkginfo"."0.2.3";
      "request-2.9.203" = self.by-version."request"."2.9.203";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
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
      url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
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
      "sax-1.1.6" = self.by-version."sax"."1.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xml2js"."0.2.7" =
    self.by-version."xml2js"."0.2.7";
  by-version."xml2js"."0.2.7" = self.buildNodePackage {
    name = "xml2js-0.2.7";
    version = "0.2.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.7.tgz";
      name = "xml2js-0.2.7.tgz";
      sha1 = "1838518bb01741cae0878bab4915e494c32306af";
    };
    deps = {
      "sax-0.5.2" = self.by-version."sax"."0.5.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xmlbuilder"."0.4.3" =
    self.by-version."xmlbuilder"."0.4.3";
  by-version."xmlbuilder"."0.4.3" = self.buildNodePackage {
    name = "xmlbuilder-0.4.3";
    version = "0.4.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xmlbuilder/-/xmlbuilder-0.4.3.tgz";
      name = "xmlbuilder-0.4.3.tgz";
      sha1 = "c4614ba74e0ad196e609c9272cd9e1ddb28a8a58";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xmlbuilder"."0.4.x" =
    self.by-version."xmlbuilder"."0.4.3";
  by-spec."xmldom".">= 0.1.x" =
    self.by-version."xmldom"."0.1.22";
  by-version."xmldom"."0.1.22" = self.buildNodePackage {
    name = "xmldom-0.1.22";
    version = "0.1.22";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xmldom/-/xmldom-0.1.22.tgz";
      name = "xmldom-0.1.22.tgz";
      sha1 = "10de4e5e964981f03c8cc72fadc08d14b6c3aa26";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xpath.js"."~1.0.5" =
    self.by-version."xpath.js"."1.0.6";
  by-version."xpath.js"."1.0.6" = self.buildNodePackage {
    name = "xpath.js-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xpath.js/-/xpath.js-1.0.6.tgz";
      name = "xpath.js-1.0.6.tgz";
      sha1 = "fe4b81c1b152ebd8e1395265fedc5b00fca29b90";
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
      url = "http://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
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
  by-spec."yallist"."^2.0.0" =
    self.by-version."yallist"."2.0.0";
  by-version."yallist"."2.0.0" = self.buildNodePackage {
    name = "yallist-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yallist/-/yallist-2.0.0.tgz";
      name = "yallist-2.0.0.tgz";
      sha1 = "306c543835f09ee1a4cb23b7bce9ab341c91cdd4";
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
