{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-tw8Z8JtmmRLcvFacRDAdIi6TyMtm9FAZvRYNgd49qXg=";
  };

  vendorHash = "sha256-/BxQiaBFkJsySnQRU870CzvPxtPwvdwx4DwSzhaYYYQ=";

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
