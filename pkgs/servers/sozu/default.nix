{ stdenv, rustPlatform, fetchFromGitHub, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.11.50";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    sha256 = "1srg2b8vwc4vp07kg4fizqj1rbm9hvf6hj1mjdh6yvb9cpbw3jz7";
  };

  cargoSha256 = "5WOigCiQZQ5DaTd15vV8pUh8Xl3UIe9yLG1ptUtY+iA=";

  buildInputs =
    stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with stdenv.lib; {
    description =
      "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
