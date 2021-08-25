{ stdenv, lib, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "171zmqqkgdpbspn70sgsypnyw7m6q2x8izwxrzbyi5xslsgd24i4";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
  cargoSha256 = "0r1m1zv3mkmmaalln3ny6m33dyjqzdyfbmkcav05kz12xjdd94fs";

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.all;
  };
}
