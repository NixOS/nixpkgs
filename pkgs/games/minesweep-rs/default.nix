{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.11";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jGg6GrPDPOWvIQiZ9UJbGHLaxTxSV7EvqIcEoGrfRZ0=";
  };

  cargoHash = "sha256-IKf44wCCzXcasuimnAwnEhJGmag67rGxQE7+rBEUVOI=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
