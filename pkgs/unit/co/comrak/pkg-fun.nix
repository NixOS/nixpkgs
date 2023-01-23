{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = version;
    sha256 = "sha256-F6MZxbB3FYEJ8tzJ0tp9/s0aLaH35QUnOJS6mCVfzUQ=";
  };

  cargoSha256 = "sha256-+QPzwfoxt6+gpb4bDMd++1dBKoXOTON0z2EDdgmyy60=";

  meta = with lib; {
    description = "A CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
