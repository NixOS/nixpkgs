{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dephell";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mimoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v3psrkjhgbkq9lm3698ac77qgk090jbly4r187nryj0vcmf9s1l";
  };

  cargoSha256 = "0fwj782dbyj3ps16hxmq61drf8714863jb0d3mhivn3zlqawyyil";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A tool to analyze the third-party dependencies imported by a rust crate or rust workspace";
    homepage = "https://github.com/mimoo/cargo-dephell";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
