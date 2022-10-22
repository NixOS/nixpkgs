{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "reftools-unstable";
  version = "2019-12-21";
  rev = "65925cf013156409e591f7a1be4df96f640d02f4";

  vendorSha256 = null;

  doCheck = false;

  excludedPackages = "cmd/fillswitch/test-fixtures";

  src = fetchFromGitHub {
    inherit rev;

    owner = "davidrjenni";
    repo = "reftools";
    sha256 = "18jg13skqi2v2vh2k6jvazv6ymhhybangjd23xn2asfk9g6cvnjs";
  };

  meta = with lib; {
    description = "Refactoring tools for Go";
    homepage = "https://github.com/davidrjenni/reftools";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
