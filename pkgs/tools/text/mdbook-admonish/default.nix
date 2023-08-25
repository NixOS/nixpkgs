{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2c1wSij2MDRdrqxN+cmnFO0z6mH/fgeg9E3cm+8ssww=";
  };

  cargoHash = "sha256-UXH0SstMVprgezyr3I/6rv2uCMdDUUSIsQ3MJ49tdoI=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
