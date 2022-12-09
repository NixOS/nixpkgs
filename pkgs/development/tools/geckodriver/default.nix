{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  version = "0.31.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-sUu1D3HAxUTQFas4ylQ9LYC0dcKPyljoU+keENg17os=";
  };

  cargoSha256 = "sha256-alwsxC1xDAAhqMTkgmUO4iDDUAK0lisXn3Yxgo7ZBhg=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
