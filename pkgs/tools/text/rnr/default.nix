{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rnr";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ismaelgv";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r1ahh8bmqrc7zb4bq5ka8bsngncf7im51nf5il49cvysij1i4q8";
  };

  cargoSha256 = "sha256-qgKL+y+w+9ADClxLNwglHMufaysY0K9g29PyuXZ7x7g=";

  meta = with lib; {
    description = "A command-line tool to batch rename files and directories";
    homepage = "https://github.com/ismaelgv/rnr";
    changelog = "https://github.com/ismaelgv/rnr/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
