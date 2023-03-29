{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
    hash = "sha256-UTwaJDuIj0aZNGNbylBhIdZA6WAsqtW05IWPzh0f9cM=";
  };

  cargoHash = "sha256-CkYm/tMDCIQbUzoF2hgxFsyAl5bpeCVHcLWR9iwq7Cw=";

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
