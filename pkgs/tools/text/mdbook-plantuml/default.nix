{ lib, fetchFromGitHub, stdenv, rustPlatform, darwin, pkg-config, openssl, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-plantuml";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sytsereitsma";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m53sp3k387injn6mwk2c6rkzw16b12m4j7q0p69fdb3fiqbkign";
  };

  cargoSha256 = "0xi14k86ym3rfz6901lmj444y814m7vp90bwsyjmcph3hdv6mjp0";

  nativeBuildInputs = [ pkg-config ];
  
  buildInputs = [ openssl openssl.dev libiconv ]
    ++ (lib.optionals stdenv.isDarwin
      [ darwin.apple_sdk.frameworks.CoreServices ]);

  meta = with lib; {
    description = "mdBook preprocessor to render PlantUML diagrams to png images in the book output directory.";
    homepage = "https://github.com/sytsereitsma/mdbook-plantuml";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ jcouyang ];
  };
}
