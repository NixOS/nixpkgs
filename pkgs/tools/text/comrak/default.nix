{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = version;
    sha256 = "sha256-igJphBA49878xuSlAxbI3l6252aTkXaN7XbxVaSBVOw=";
  };

  cargoSha256 = "sha256-ucXb0SU7dpjeLzDN2OTxji3Mh+7bw+npSNsQjbOeY+s=";

  meta = with lib; {
    description = "A CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
