{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = version;
    sha256 = "0a01s9lqhqjqpycszfkgmxk60bk4h2ja9ykdhp32aqvcdsjsj763";
  };

  cargoSha256 = "sha256-+OQ4np+JaHMm3n4uayqlAwx+DTi5k4NgKEOWA2lB/BQ=";

  meta = with lib; {
    description = "A CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
