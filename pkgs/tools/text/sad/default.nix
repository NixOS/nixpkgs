{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.21";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kM5jeoFmDOwgnzdSwfPJfZhpBS8RPMNt143S5iYYrF4=";
  };

  cargoSha256 = "sha256-JwYUM4o4I3dC1HgG4bkUS1PH4MsxcvwdefjefnEZQFs=";

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
