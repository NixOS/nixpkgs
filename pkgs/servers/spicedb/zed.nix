{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-e9jgRvQ8eYy6eqweqQIyjEKZ4cfEq5DwGXBvBXB2Wk8=";
  };

  vendorHash = "sha256-VRWhhXgBnIkwkakhERm2iSKidPnk0e4iTXXJpJz4cRM=";

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
