/* This file defines the composition for CRAN (R) packages. */

{pkgs, __overrides}:

rec {

  inherit (pkgs) buildRPackage fetchurl stdenv R;

  inherit (stdenv.lib) maintainers;

  inherit __overrides;

  abind = buildRPackage rec {
    name = "abind-1.4-0";
    src = fetchurl {
      url = "mirror://cran/src/contrib/abind_1.4-0.tar.gz";
      sha256 = "1b9634bf6ad68022338d71a23a689f1af4afd9d6c12c0b982b88fc21363ff568";
    };
  };

  chron = buildRPackage rec {
    name = "chron-2.3-44";
    src = fetchurl {
      url = "mirror://cran/src/contrib/chron_2.3-44.tar.gz";
      sha256 = "ba7d46223e615b4d09145a364a4c37ccff718384486ca154a6e025cf3ed91148";
    };
  };

  colorspace = buildRPackage rec {
    name = "colorspace-1.2-2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/colorspace_1.2-2.tar.gz";
      sha256 = "7f6ca98e5d005bc7d6e37b03577d65995809150d1d293ce68b6720e7a6b2054d";
    };
  };

  DBI = buildRPackage rec {
    name = "DBI-0.2-7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/DBI_0.2-7.tar.gz";
      sha256 = "e90a988740f99060d5c4aacb1f2b148b0eb81c5b468bafeadf3aaeccf563b5e3";
    };
  };

  dichromat = buildRPackage rec {
    name = "dichromat-2.0-0";
    src = fetchurl {
      url = "mirror://cran/src/contrib/dichromat_2.0-0.tar.gz";
      sha256 = "31151eaf36f70bdc1172da5ff5088ee51cc0a3db4ead59c7c38c25316d580dd1";
    };
  };

  digest = buildRPackage rec {
    name = "digest-0.6.3";
    src = fetchurl {
      url = "mirror://cran/src/contrib/digest_0.6.3.tar.gz";
      sha256 = "5be8f1386c0c273fcc915df7b557393c5f3de43c44fd16614db9cc5ba6d1d57c";
    };
  };

  ggplot2 = buildRPackage rec {
    name = "ggplot2-0.9.3.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/ggplot2_0.9.3.1.tar.gz";
      sha256 = "b4c97404fd44571f9980712af963949ed204b5d4e639d97df9ba9a17423a6601";
    };
    propagatedBuildInputs = [ digest plyr gtable reshape2 scales proto ];
  };

  gtable = buildRPackage rec {
    name = "gtable-0.1.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/gtable_0.1.2.tar.gz";
      sha256 = "b08ba8e62e0ce05e7a4c07ba3ffa67719161db62438b04f14343f8928d74304d";
    };
  };

  gtools = buildRPackage rec {
    name = "gtools-3.0.0";
    src = fetchurl {
      url = "mirror://cran/src/contrib/gtools_3.0.0.tar.gz";
      sha256 = "e35f08ac9df875b57dcf23028baa226372d7482d7814a011f9b1fdd0697ee73c";
    };
  };

  gsubfn = buildRPackage rec {
    name = "gsubfn-0.6-5";
    src = fetchurl {
      url = "mirror://cran/src/contrib/gsubfn_0.6-5.tar.gz";
      sha256 = "9a7b51ae6aabd1c99e8633d3dc75232d8c4a175df750c7d1c359bd0f5fc197be";
    };
    propagatedBuildInputs = [ proto ];
  };

  labeling = buildRPackage rec {
    name = "labeling-0.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/labeling_0.2.tar.gz";
      sha256 = "8aaa7f8b91923088da4e47ae42620fadcff7f2bc566064c63d138e2145e38aa4";
    };
  };

  lars = buildRPackage rec {
    name = "lars-1.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/lars_1.2.tar.gz";
      sha256 = "64745b568f20b2cfdae3dad02fba92ebf78ffee466a71aaaafd4f48c3921922e";
    };
  };

  LiblineaR = buildRPackage rec {
    name = "LiblineaR-1.80-7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/LiblineaR_1.80-7.tar.gz";
      sha256 = "9ba0280c5165bf0bbd46cb5ec7c66fdece38fc3f73fce2ec800763923ae8e4bd";
    };
  };

  linprog = buildRPackage rec {
    name = "linprog-0.9-2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/linprog_0.9-2.tar.gz";
      sha256 = "8937b2e30692e38de1713f1513b78f505f73da6f5b4a576d151ad60bac2221ce";
    };
    propagatedBuildInputs = [ lpSolve ];
  };

  lpSolve = buildRPackage rec {
    name = "lpSolve-5.6.7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/lpSolve_5.6.7.tar.gz";
      sha256 = "16def9237f38c4d7a59651173fd87df3cd3c563f640c6952e13bdd2a084737ef";
    };
  };

  munsell = buildRPackage rec {
    name = "munsell-0.4.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/munsell_0.4.2.tar.gz";
      sha256 = "84e787f58f626c52a1e3fc1201f724835dfa8023358bfed742e7001441f425ae";
    };
    propagatedBuildInputs = [ colorspace ];
  };

  pamr = buildRPackage rec {
    name = "pamr-1.54.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/pamr_1.54.1.tar.gz";
      sha256 = "139dbc39b4eccd6a55b6a3c42a1c8be61dcce0613535a634c3e42731fc315516";
    };
  };

  penalized = buildRPackage rec {
    name = "penalized-0.9-42";
    src = fetchurl {
      url = "mirror://cran/src/contrib/penalized_0.9-42.tar.gz";
      sha256 = "98e8e39b02ecbabaa7050211e34941c73e1e687f39250cf3cbacb7c5dcbb1e98";
    };
  };

  plyr = buildRPackage rec {
    name = "plyr-1.8";
    src = fetchurl {
      url = "mirror://cran/src/contrib/plyr_1.8.tar.gz";
      sha256 = "0bd6861af241e6c5ce777ef3f1b0eb72b31cc026669a68f6250b8ecfadf71a66";
    };
  };

  proto = buildRPackage rec {
    name = "proto-0.3-10";
    src = fetchurl {
      url = "mirror://cran/src/contrib/proto_0.3-10.tar.gz";
      sha256 = "d0d941bfbf247879b3510c8ef3e35853b1fbe83ff3ce952e93d3f8244afcbb0e";
    };
  };

  randomForest = buildRPackage rec {
    name = "randomForest-4.6-7";
    src = fetchurl {
      url = "mirror://cran/src/contrib/randomForest_4.6-7.tar.gz";
      sha256 = "8206e88b242c07efc10f148d17dfcc265a31361e1bcf44bfe17aed95c357be0b";
    };
    propagatedBuildInputs = [ plyr stringr ];
  };

  reshape2 = buildRPackage rec {
    name = "reshape2-1.2.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/reshape2_1.2.2.tar.gz";
      sha256 = "9131025b8f684e1629ab3e2748d4cf2b907b7c89cfbff667c925bc0fb5dfc103";
    };
    propagatedBuildInputs = [ plyr stringr ];
  };

  RColorBrewer = buildRPackage rec {
    name = "RColorBrewer-1.0-5";
    src = fetchurl {
      url = "mirror://cran/src/contrib/RColorBrewer_1.0-5.tar.gz";
      sha256 = "5ac1c44c1a53f9521134e7ed7c148c72e49271cbd229c5263d2d7fd91c8b8e78";
    };
  };

  RSQLite = buildRPackage rec {
    name = "RSQlite-0.11.4";
    src = fetchurl {
      url = "mirror://cran/src/contrib/RSQLite_0.11.4.tar.gz";
      sha256 = "bba0cbf2a1a3120d667a731da1ca5b9bd4db23b813e1abf6f51fb01540c2000c";
    };
    propagatedBuildInputs = [ DBI ];
  };

  RSQLiteExtfuns = buildRPackage rec {
    name = "RSQlite.extfuns-0.0.1";
    src = fetchurl {
      url = "mirror://cran/src/contrib/RSQLite.extfuns_0.0.1.tar.gz";
      sha256 = "ca5c7947c041e17ba83bed3f5866f7eeb9b7f361e5c050c9b58eec5670f03d0e";
    };
    propagatedBuildInputs = [ RSQLite ];
  };

  scales = buildRPackage rec {
    name = "scales-0.2.3";
    src = fetchurl {
      url = "mirror://cran/src/contrib/scales_0.2.3.tar.gz";
      sha256 = "46aef8eb261abc39f87b71184e5484bc8c2c94e01d3714ce4b2fd60727bc40d9";
    };
    propagatedBuildInputs = [ RColorBrewer stringr dichromat munsell plyr labeling ];
  };

  stringr = buildRPackage rec {
    name = "stringr-0.6.2";
    src = fetchurl {
      url = "mirror://cran/src/contrib/stringr_0.6.2.tar.gz";
      sha256 = "c3fc9c71d060ad592d2cfc51c36ab2f8e5f8cf9a25dfe42c637447dd416b6737";
    };
  };

  sqldf = buildRPackage rec {
    name = "sqldf-0.4-6.4";
    src = fetchurl {
      url = "mirror://cran/src/contrib/sqldf_0.4-6.4.tar.gz";
      sha256 = "6c51e4e48b93310f765c661a1756fe068629da775248d38a98c38f5b6f7511c4";
    };
    propagatedBuildInputs = [ DBI gsubfn proto chron RSQLite RSQLiteExtfuns ];
  };
}
