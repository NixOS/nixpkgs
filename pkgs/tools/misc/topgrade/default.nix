{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kkk718s65r3j5k3a3wz9p0q1v8rjz0yshmfwxak3aw99nj9yyvq";
  };

  cargoSha256 = "1g6jzbmicyqnp0dkcbw7sa36b3qxag8f596mb47wq2fl25pg0d3x";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  # TODO: add manpage (topgrade.8) to postInstall on next update

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ filalex77 hugoreeves ];
  };
}
