{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  version = "0.32.2";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-w2zGiRvhuPMo79UsnckSISyCwBcIg5sfXIJLmnT3Tnk=";
  };

  cargoHash = "sha256-8P62yQpGXgswfSnAji0cIJwarx8IW0S5DO5gUMMp5PI=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
