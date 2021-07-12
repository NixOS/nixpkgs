{ branch ? "master"
, callPackage
, fetchFromGitHub
}:

{
  master = callPackage ./base.nix {
    pname = "re3";
    version = "unstable-2021-09-03";

    src = fetchFromGitHub {
      owner = "GTAmodding";
      repo = "re3";
      rev = "3233ffe1c4b99e8efb4c41c6794b4fce880cf503";
      sha256 = "XJM4eDT9R9dDCTDHDjLQxrW+rXhlnAQxP40rn6ycNF4=";
    };
  };

  miami = callPackage ./base.nix {
    pname = "reVC";
    version = "unstable-2021-09-02";

    src = fetchFromGitHub {
      owner = "GTAmodding";
      repo = "re3";
      rev = "a16fcd8d6a79e433c1c6e73d540f1bbe27e14164";
      sha256 = "+C8EAdfsvM4e7C8A08UlNXYDuMgkiMGo7xXL9iwSmO8=";
    };
  };

  lcs = callPackage ./base.nix {
    pname = "reLCS";
    version = "unstable-2021-09-02";

    src = fetchFromGitHub {
      owner = "GTAmodding";
      repo = "re3";
      rev = "33abd1b4e7a7b19e2d09c796c481c3325c1e2902";
      sha256 = "nQDlJg92rxo/t3QPFUZj8/qmaLRr5z9MTAsAhHKNPys=";
    };
  };
}.${branch}
