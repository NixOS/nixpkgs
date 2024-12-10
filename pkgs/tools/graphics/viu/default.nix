{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libsixel,
  withSixel ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "sha256-lAuIl25368Gv717a8p2So1o1VMDJJAOlDdqfItYizo4=";
  };

  # tests need an interactive terminal
  doCheck = false;

  cargoSha256 = "sha256-ildtjaYGbrQacJOdGDVwFv+kod+vZHqukWN6ARtJqI4=";

  buildFeatures = lib.optional withSixel "sixel";
  buildInputs = lib.optional withSixel libsixel;

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ chuangzhu ];
    mainProgram = "viu";
  };
}
