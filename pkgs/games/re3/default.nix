{ branch ? "master"
, callPackage
, fetchFromGitHub
}:

{
  master = callPackage ./base.nix {
    pname = "re3";
    version = "unstable-2021-07-12";

    src = fetchFromGitHub {
      owner = "GTAmodding";
      repo = "re3";
      rev = "a4b92fe9bec17ad00dc436574f57844c4b8d49f5";
      sha256 = "5CPgDhUgkB0B5EApwkdhh7qqEbtCE3Fee1CKu3BTGz4=";
    };
  };

  miami = callPackage ./base.nix {
    pname = "reVC";
    version = "unstable-2021-07-12";

    src = fetchFromGitHub {
      owner = "GTAmodding";
      repo = "re3";
      rev = "523b23339cd761d934501dcbcc059d131b5a28c4";
      sha256 = "Cb9C9Gh1VGPPwF2uO82wOdxD2rfaixdkBsClx3OFNvU=";
    };
  };

  lcs = callPackage ./base.nix {
    pname = "reLCS";
    version = "unstable-2021-07-12";

    src = fetchFromGitHub {
      owner = "GTAmodding";
      repo = "re3";
      rev = "6f0f9d7d695056575120ff49cc01297419c0d0e4";
      sha256 = "+/GPQ6H5uYalX5rUzl3W+X9EVKEgrb2h9mdvcLBE4bQ=";
    };
  };
}.${branch}
