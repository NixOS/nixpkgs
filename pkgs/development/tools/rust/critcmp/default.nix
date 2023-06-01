{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "critcmp";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "critcmp";
    rev = version;
    hash = "sha256-B9unlodAhdmRogHX7tqky320xpaUG2p8nRZS7uGOXGY=";
  };

  cargoHash = "sha256-Y1vfUOwCWAjMnNlm40XM9sQvooVtnGETTpIIsN/HTOU=";

  meta = with lib; {
    description = "A command line tool for comparing benchmarks run by Criterion";
    homepage = "https://github.com/BurntSushi/critcmp";
    license = with licenses; [ mit unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
