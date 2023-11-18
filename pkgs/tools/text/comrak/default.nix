{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = version;
    sha256 = "sha256-eyLgAVo4U0a1JByJsoWOnKGhDcaOhul145KeOOkmHq8=";
  };

  cargoSha256 = "sha256-Q9VmiC07UxstwRPertTteeHX34zTo58a2wPkQtSwUPU=";

  meta = with lib; {
    description = "A CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
