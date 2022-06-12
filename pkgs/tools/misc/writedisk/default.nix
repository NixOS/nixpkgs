{ lib
, rustPlatform
, fetchCrate
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "writedisk";
  version = "1.2.0";

  src = fetchCrate {
    inherit version;
    pname = "writedisk";
    sha256 = "sha256-f5+Qw9Agepx2wIUmsAA2M9g/ajbFjjLR5RPPtQncRKU=";
  };

  cargoSha256 = "sha256-SMAhh7na+XQyVtbfzsBGOCdBRLP58JL1fPSBVKFkhdc=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Small utility for writing a disk image to a USB drive";
    homepage = "https://github.com/nicholasbishop/writedisk";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ devhell ];
  };
}
