{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-+u8qrF/P8a19Bc085upT65xVPGIVR3My/k/enhdUJmQ=";
  };

  vendorHash = "sha256-f0UNUOi0WXm06dko+7O00C0dla/JlfGlXaZ00TMX0WU=";

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
