{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rtss";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Freaky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WeeZsB42/4SlIaWwKvOqWiPNV5p0QOToynI8ozVVxJM=";
  };

  cargoSha256 = "sha256-aHK9KBzRbU2IYr7vOdlz0Aw4iYGjD6VedbWPE/V7AVc=";

  meta = with lib; {
    description = "Annotate output with relative durations between lines";
    mainProgram = "rtss";
    homepage = "https://github.com/Freaky/rtss";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
