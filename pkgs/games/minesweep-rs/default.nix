{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.35";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IxyryBWU4NULjcQtUXHel533JosAmp0d0w/+Ntl2aT0=";
  };

  cargoHash = "sha256-BGjxZxT7iypvhusyx6K4yvK1S7j4WlvoSTkb79d/H1s=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
