/* This file defines the composition for CRAN (R) packages. */

{pkgs, overrides}:

let self = _self // overrides; _self = with self; {

  inherit (pkgs) buildRPackage fetchurl stdenv R;

  inherit (stdenv.lib) maintainers;

  abind = buildRPackage {
    name = "abind-1.4-0";
    src = fetchurl {
      url = "mirror://cran/src/contrib/abind_1.4-0.tar.gz";
      sha256 = "1b9634bf6ad68022338d71a23a689f1af4afd9d6c12c0b982b88fc21363ff568";
    };
  };

  chron = buildRPackage {
    name = "chron-2.3-44";
    src = fetchurl {
      url = "mirror://cran/src/contrib/chron_2.3-44.tar.gz";
      sha256 = "ba7d46223e615b4d09145a364a4c37ccff718384486ca154a6e025cf3ed91148";
    };
  };

  codetools = buildRPackage {
    name = "codetools-0.2-8";
    src = fetchurl {
      url = "mirror://cran/src/contrib/codetools_0.2-8.tar.gz";
      sha256 = "0m326kfxihm5ayfn5b4k8awdf34002iy094gazbc3h0y42r4g86b";
    };
  };

  colorspace = buildRPackage {
    name = "colorspace-1.2-2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/colorspace_1.2-2.tar.gz";
      sha256 = "7f6ca98e5d005bc7d6e37b03577d65995809150d1d293ce68b6720e7a6b2054d";
    };
  };

  dataTable = buildRPackage {
    name = "data.table-1.9.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/data.table_1.9.2.tar.gz";
      sha256 = "1fchjg939av89m0zsv85w2xcc8qriwkskk0mcsqy8ip6pcfnlg66";
    };
    propagatedBuildInputs = [ reshape2 ];
  };

  Defaults = buildRPackage {
    name = "Defaults-1.1-1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/Defaults_1.1-1.tar.gz";
      sha256 = "0ikgd5mswlky327pzp09cz93bn3mq7qnybq1r64y19c2brbax00d";
    };
  };

  DBI = buildRPackage {
    name = "DBI-0.2-7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/DBI_0.2-7.tar.gz";
      sha256 = "e90a988740f99060d5c4aacb1f2b148b0eb81c5b468bafeadf3aaeccf563b5e3";
    };
  };

  dichromat = buildRPackage {
    name = "dichromat-2.0-0";
    src = fetchurl {
      url = "mirror://cran/src/contrib/dichromat_2.0-0.tar.gz";
      sha256 = "31151eaf36f70bdc1172da5ff5088ee51cc0a3db4ead59c7c38c25316d580dd1";
    };
  };

  digest = buildRPackage {
    name = "digest-0.6.3";
    src = fetchurl {
      url = "mirror://cran/src/contrib/digest_0.6.3.tar.gz";
      sha256 = "5be8f1386c0c273fcc915df7b557393c5f3de43c44fd16614db9cc5ba6d1d57c";
    };
  };

  foreach = buildRPackage {
    name = "foreach-1.4.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/foreach_1.4.2.tar.gz";
      sha256 = "097zk7cwyjxgw2i8i547y437y0gg2fmyc5g4i8bbkn99004qzzfl";
    };
    propagatedBuildInputs = [ codetools iterators ];
  };

  ggplot2 = buildRPackage {
    name = "ggplot2-0.9.3.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/ggplot2_0.9.3.1.tar.gz";
      sha256 = "b4c97404fd44571f9980712af963949ed204b5d4e639d97df9ba9a17423a6601";
    };
    propagatedBuildInputs = [ digest plyr gtable reshape2 scales proto ];
  };

  gtable = buildRPackage {
    name = "gtable-0.1.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/gtable_0.1.2.tar.gz";
      sha256 = "b08ba8e62e0ce05e7a4c07ba3ffa67719161db62438b04f14343f8928d74304d";
    };
  };

  gtools = buildRPackage {
    name = "gtools-3.0.0";
    src = fetchurl {
      url = "mirror://cran/src/contrib/gtools_3.0.0.tar.gz";
      sha256 = "e35f08ac9df875b57dcf23028baa226372d7482d7814a011f9b1fdd0697ee73c";
    };
  };

  gsubfn = buildRPackage {
    name = "gsubfn-0.6-5";
    src = fetchurl {
      url = "mirror://cran/src/contrib/gsubfn_0.6-5.tar.gz";
      sha256 = "9a7b51ae6aabd1c99e8633d3dc75232d8c4a175df750c7d1c359bd0f5fc197be";
    };
    propagatedBuildInputs = [ proto ];
  };

  iterators = buildRPackage {
    name = "iterators-1.0.7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/iterators_1.0.7.tar.gz";
      sha256 = "1zwqawhcpi95fx4qqj4cy31v5qln2z503f7cvv9v5ch3ard4xxqv";
    };
  };

  labeling = buildRPackage {
    name = "labeling-0.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/labeling_0.2.tar.gz";
      sha256 = "8aaa7f8b91923088da4e47ae42620fadcff7f2bc566064c63d138e2145e38aa4";
    };
  };

  lars = buildRPackage {
    name = "lars-1.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/lars_1.2.tar.gz";
      sha256 = "64745b568f20b2cfdae3dad02fba92ebf78ffee466a71aaaafd4f48c3921922e";
    };
  };

  LiblineaR = buildRPackage {
    name = "LiblineaR-1.80-7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/LiblineaR_1.80-7.tar.gz";
      sha256 = "9ba0280c5165bf0bbd46cb5ec7c66fdece38fc3f73fce2ec800763923ae8e4bd";
    };
  };

  linprog = buildRPackage {
    name = "linprog-0.9-2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/linprog_0.9-2.tar.gz";
      sha256 = "8937b2e30692e38de1713f1513b78f505f73da6f5b4a576d151ad60bac2221ce";
    };
    propagatedBuildInputs = [ lpSolve ];
  };

  lpSolve = buildRPackage {
    name = "lpSolve-5.6.7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/lpSolve_5.6.7.tar.gz";
      sha256 = "16def9237f38c4d7a59651173fd87df3cd3c563f640c6952e13bdd2a084737ef";
    };
  };

  munsell = buildRPackage {
    name = "munsell-0.4.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/munsell_0.4.2.tar.gz";
      sha256 = "84e787f58f626c52a1e3fc1201f724835dfa8023358bfed742e7001441f425ae";
    };
    propagatedBuildInputs = [ colorspace ];
  };

  pamr = buildRPackage {
    name = "pamr-1.54.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/pamr_1.54.1.tar.gz";
      sha256 = "139dbc39b4eccd6a55b6a3c42a1c8be61dcce0613535a634c3e42731fc315516";
    };
  };

  penalized = buildRPackage {
    name = "penalized-0.9-42";
    src = fetchurl {
      url = "mirror://cran/src/contrib/penalized_0.9-42.tar.gz";
      sha256 = "98e8e39b02ecbabaa7050211e34941c73e1e687f39250cf3cbacb7c5dcbb1e98";
    };
  };

  plyr = buildRPackage {
    name = "plyr-1.8.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/plyr_1.8.1.tar.gz";
      sha256 = "0f2an3pr7flpng9y9mmrmyh08g3nivi6gdkfnw54arn0wxhkqfcm";
    };
    propagatedBuildInputs = [ Rcpp ];
  };

  proto = buildRPackage {
    name = "proto-0.3-10";
    src = fetchurl {
      url = "mirror://cran/src/contrib/proto_0.3-10.tar.gz";
      sha256 = "d0d941bfbf247879b3510c8ef3e35853b1fbe83ff3ce952e93d3f8244afcbb0e";
    };
  };

  randomForest = buildRPackage {
    name = "randomForest-4.6-7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/randomForest_4.6-7.tar.gz";
      sha256 = "8206e88b242c07efc10f148d17dfcc265a31361e1bcf44bfe17aed95c357be0b";
    };
    propagatedBuildInputs = [ plyr stringr ];
  };

  Rcpp = buildRPackage {
    name = "Rcpp-0.11.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/Rcpp_0.11.1.tar.gz";
      sha256 = "1ccsvdij6yym9dziqsjf5gr37968imz8i81334vi2fc69z5xzf30";
    };
  };

  reshape2 = buildRPackage {
    name = "reshape2-1.4";
    src = fetchurl {
      url = "mirror://cran/src/contrib/reshape2_1.4.tar.gz";
      sha256 = "0i3bim4clwyfdwwrmszsn9ga5gm4a2sh1i0jmpji3afbxc151yjp";
    };
    propagatedBuildInputs = [ plyr stringr Rcpp ];
  };

  RColorBrewer = buildRPackage {
    name = "RColorBrewer-1.0-5";
    src = fetchurl {
      url = "mirror://cran/src/contrib/RColorBrewer_1.0-5.tar.gz";
      sha256 = "5ac1c44c1a53f9521134e7ed7c148c72e49271cbd229c5263d2d7fd91c8b8e78";
    };
  };

  RSQLite = buildRPackage {
    name = "RSQlite-0.11.4";
    src = fetchurl {
      url = "mirror://cran/src/contrib/RSQLite_0.11.4.tar.gz";
      sha256 = "bba0cbf2a1a3120d667a731da1ca5b9bd4db23b813e1abf6f51fb01540c2000c";
    };
    propagatedBuildInputs = [ DBI ];
  };

  RSQLiteExtfuns = buildRPackage {
    name = "RSQlite.extfuns-0.0.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/RSQLite.extfuns_0.0.1.tar.gz";
      sha256 = "ca5c7947c041e17ba83bed3f5866f7eeb9b7f361e5c050c9b58eec5670f03d0e";
    };
    propagatedBuildInputs = [ RSQLite ];
  };

  scales = buildRPackage {
    name = "scales-0.2.3";
    src = fetchurl {
      url = "mirror://cran/src/contrib/scales_0.2.3.tar.gz";
      sha256 = "46aef8eb261abc39f87b71184e5484bc8c2c94e01d3714ce4b2fd60727bc40d9";
    };
    propagatedBuildInputs = [ RColorBrewer stringr dichromat munsell plyr labeling ];
  };

  stringr = buildRPackage {
    name = "stringr-0.6.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/stringr_0.6.2.tar.gz";
      sha256 = "c3fc9c71d060ad592d2cfc51c36ab2f8e5f8cf9a25dfe42c637447dd416b6737";
    };
  };

  sqldf = buildRPackage {
    name = "sqldf-0.4-6.4";
    src = fetchurl {
      url = "mirror://cran/src/contrib/sqldf_0.4-6.4.tar.gz";
      sha256 = "6c51e4e48b93310f765c661a1756fe068629da775248d38a98c38f5b6f7511c4";
    };
    propagatedBuildInputs = [ DBI gsubfn proto chron RSQLite RSQLiteExtfuns ];
  };

  xtable = buildRPackage {
    name = "xtable-1.7-3";
    src = fetchurl {
      url = "mirror://cran/src/contrib/xtable_1.7-3.tar.gz";
      sha256 = "1rsfq0acf1pvpci3jq9fbhsv6ws4d46yap8m2xjk1cr463m9gdcc";
    };
  };
}; in self
