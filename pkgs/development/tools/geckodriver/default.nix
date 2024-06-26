{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  Security,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  version = "0.34.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-jrF55j3/WKpGl7sJzRmPyaNMbxPqAoXWiuQJsxfIYgc=";
  };

  cargoHash = "sha256-4on4aBkRI9PiPgNcxVktTDX28qRy3hvV9+glNB6hT1k=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = "https://github.com/mozilla/geckodriver";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
    mainProgram = "geckodriver";
  };
}
