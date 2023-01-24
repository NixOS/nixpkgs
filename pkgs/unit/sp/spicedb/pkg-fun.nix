
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-v30F6JhLmPLuYVyegjMPOjUKQ51xxrNfYMqaEPmRuwI=";
  };

  vendorHash = "sha256-TMwijafZ5ILTr9ZA5CG5uFFIZe6EmnLAL2zD25l/1gs=";

  subPackages = [ "cmd/spicedb" ];

  meta = with lib; {
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
