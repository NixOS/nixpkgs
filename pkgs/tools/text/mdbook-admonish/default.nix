{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wRRBasHnTelLCiHjjrMmXv/2V3P91n4kZ1aAt1tZx/Y=";
  };

  cargoHash = "sha256-KAcZyHanmbOKK+55dkINss9uOxk6P+r38M6qftYQwpw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
