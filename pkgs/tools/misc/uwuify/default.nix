{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "uwuify";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Daniel-Liu-c0deb0t";
    repo = "uwu";
    rev = "v${version}";
    sha256 = "sha256-MzXObbxccwEG7egmQMCdhUukGqZS+NgbYwZjTaqME7I=";
  };

  cargoSha256 = "sha256-iyoGLFIfHToOwqEb5lQ1nXR0W1gLOVMfvw39LX6ib+U=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "Fast text uwuifier";
    homepage = "https://github.com/Daniel-Liu-c0deb0t/uwu";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
