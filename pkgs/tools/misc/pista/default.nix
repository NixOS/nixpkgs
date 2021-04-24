{ stdenv, lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "pista";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "pista";
    rev = "v${version}";
    sha256 = "1nrqgl5r5ja95g5xhfvkvfz72g318pqc7yj4fwl6xnad19smvms0";
    fetchSubmodules = true;
  };

  cargoSha256 = "1qjg4z4nfqmiawczs4p4rf4mq250aqb5brd3hd2jcjdhqajksr90";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # does not have tests
  doCheck = false;

  meta = with lib; {
    description = "Simple {bash, zsh} prompt for programmers";
    homepage = "https://github.com/NerdyPepper/pista";
    license = licenses.mit;
    maintainers = with maintainers; [ nerdypepper ];
  };
}
