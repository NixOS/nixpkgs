{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-P+Q0KrJSXc26LcIHFzzypMwjWsJvYGYFZ/6RsB+ELTA=";
  };

  cargoHash = "sha256-fhJZMvxGjNfhHP3vMVYUYpA4i5r7w0B0TXaxDZ5Z2YY=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
