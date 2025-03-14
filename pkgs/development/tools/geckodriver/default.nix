{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  Security,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  version = "0.36.0";
  pname = "geckodriver";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "geckodriver";
    tag = "v${version}";
    sha256 = "sha256-rqJ6+QKfEhdHGZBT9yEWtsBlETxz4XeEZXisXf7RdIE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wFRZhQzFBwwNfiszwr7XK3e8tfqqFG6DIe7viWvB5vg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
