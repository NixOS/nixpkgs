{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  version = "0.32.1";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ts2OGRdz1ajJ36XXUC48Jkygr3LDdZfHJ88peJkjqbg=";
  };

  cargoHash = "sha256-b54/65xYZ9a04dPm90R9tzhdjTwTaXvi4NnQe9k+qvE=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
