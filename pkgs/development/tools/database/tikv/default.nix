{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, rustfmt
, protobuf
}:
let
  version = "6.3.0";
  src = fetchFromGitHub {
    owner = "tikv";
    repo = "tikv";
    rev = "f9ae84f772c522dea7d57dceedba801db3a2103c";
    sha256 = "sha256-zDcvnblPOq+WK3d7UnA4id/3DriFAj+3sh3zjqFercw=";
  };

  meta = with lib; {
    description = "Distributed transactional key-value database, originally created to complement TiDB";
    homepage = "https://github.com/tikv/tikv";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
    platforms = platforms.unix;
  };
in
{
  tikv-server = rustPlatform.buildRustPackage {
    pname = "tikv-server";
    inherit version src;

    cargoSha256 = "sha256-HqaYcbGfPiUwbCaGB6+388NZr/aBr0QIXiO0oRz/Dlg=";

    buildAndTestSubdir = "server";

    PROTOC = "${protobuf}/bin/protoc";

    nativeBuildInputs = [ rustfmt rustPlatform.bindgenHook ];
    
    doCheck = false;
  };
  tikv-client = rustPlatform.buildRustPackage {
    pname = "tikv-ctl";
      
    inherit version src;

    cargoSha256 = "sha256-pxan6W/CEsOxv8DbbytEBuIqxWn/C4qT4ze/RnvESOM=";

    PROTOC = "${protobuf}/bin/protoc";

    nativeBuildInputs = [ rustfmt rustPlatform.bindgenHook ];

    # buildAndTestSubdir = "client";
  };
}
