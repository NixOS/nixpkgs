{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "coloursum";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ticky";
    repo = "coloursum";
    rev = "v${version}";
    hash = "sha256-zA2JhSnlFccSY01WMGsgF4AmrF/3BRUCcSMfoEbEPgA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aZkWzJaEW6/fiCfb+RKNef0eJf/CJW8OU1N2OlHwuJM=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = with lib; {
    description = "Colourise your checksum output";
    mainProgram = "coloursum";
    homepage = "https://github.com/ticky/coloursum";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
