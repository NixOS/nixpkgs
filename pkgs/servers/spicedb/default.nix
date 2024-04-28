
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
    (fetchpatch {
      name = "CVE-2024-27101.patch";
      url = "https://github.com/authzed/spicedb/commit/ef443c442b96909694390324a99849b0407007fe.patch";
      hash = "sha256-8xXM0EBxJ0hI7RtURFxmRpYqGdSGZ/jZVP4KAuh2E/U=";
    })
    (fetchpatch {
      name = "CVE-2024-32001.patch";
      url = "https://github.com/authzed/spicedb/commit/a244ed1edfaf2382711dccdb699971ec97190c7b.patch";
      hash = "sha256-tdSqo7tFXs/ea5dIKV9Aikva9Za0Hj1Ng4LeCAQX9DA=";
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
