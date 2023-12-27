
{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-+/0raANdWXPnme/l82wzbhf+kYggBvs4iYswDUPFjlI=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-46255.patch";
      url = "https://github.com/authzed/spicedb/commit/ae50421b80f895e4c98d999b18e06b6f1e6f1cf8.patch";
      hash = "sha256-6VYye1lJkUxekRI870KonP+IFk61HkCS1NGhrJ3Vhv8=";
    })
  ];

  vendorHash = "sha256-r0crxfE3XtsT4+5lWNY6R/bcuxq2WeongK9l7ABXQo8=";

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
    mainProgram = "spicedb";
  };
}
