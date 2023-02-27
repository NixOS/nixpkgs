{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-bA9ZIYzt6d0PaIChQcS9uUakxmsx/SElHite6boAd3o=";
  };

  vendorHash = "sha256-4Y/98VEZWjk2k4UPtGEumOMbjjR4V1OnPvj5mxuX/DQ=";

  meta = with lib; {
    description = "Command line for managing SpiceDB";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar. zed is the command line client for SpiceDB.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
