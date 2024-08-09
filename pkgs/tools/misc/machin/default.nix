{ lib
, stdenv
, nasm
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "machin";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    sha256 = "0b1l8gw60zs58wckm82v9jiw1q6b65srr523snyrp7iibh9vnb7d";
  };

  cargoSha256 = "1afynsf1xpys42bvii3rlrm4p2bl36sziby28r8lrwp7947bs800";

  nativeBuildInputs = [ nasm ];

  postInstall = "make PREFIX=$out copy-data";

  meta = with lib; {
    description = "A cli program that simplifies file conversions and batch processing. It's inspired from filter/map/reduce";
    homepage = "https://github.com/mothsart/machin";
    changelog = "https://github.com/mothsart/machin/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = with licenses; [ mit ];
  };
}
