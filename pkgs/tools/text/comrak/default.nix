{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = version;
    sha256 = "sha256-VnCR09yu2b3zDWpSYQvJ18XNKuZaVtQ6JFnE7kNVips=";
  };

  cargoSha256 = "sha256-HHy8dm0aiREfqcKK51aW/j1AoJVq+4zOpQe2rvT1YNc=";

  meta = with lib; {
    description = "A CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
