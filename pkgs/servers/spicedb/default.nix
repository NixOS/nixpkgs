
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-Q8NqWV9s4DrN3lEGkAYYm59HCIo6dIpQQHbzepKao+o=";
  };

  vendorHash = "sha256-61TnfP62a5bUtBLxDe1FpF28hcPGzyuO5D/JNTqAfx8=";

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
