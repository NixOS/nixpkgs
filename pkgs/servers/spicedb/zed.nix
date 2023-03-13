{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-kmbZ0fi7rbJUsMREOH+IxHIDfZ2qy+AD8Px9pu4eSxM=";
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
