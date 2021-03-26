{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "uwuify";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Daniel-Liu-c0deb0t";
    repo = "uwu";
    rev = "v${version}";
    sha256 = "sha256-tPmLqgrWi7wDoMjMrxodKp4S0ICwV9Kp7Pa151rHho0=";
  };

  cargoSha256 = "sha256-HUP6OEvoGJ/BtAl+yuGzqEp1bsxfGAh0UJtXz9/ZiK8=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "Fast text uwuifier";
    homepage = "https://github.com/Daniel-Liu-c0deb0t/uwu";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
