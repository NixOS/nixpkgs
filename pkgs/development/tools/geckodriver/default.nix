{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  version = "0.33.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IBzLxiqfXFiEaDmCVZjAJCPcVInBT1ZZ5fkCOHedZkA=";
  };

  cargoHash = "sha256-4/VmF8reY0pz8wswQn3IlTNt6SaVunr2v+hv+oM+G/s=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
    mainProgram = "geckodriver";
  };
}
