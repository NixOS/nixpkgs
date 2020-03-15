{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "02rcgz1sklll0gpxjwb7y3jc6flzr4492qp72blra6a26qpb7vxp";
  };

  cargoSha256 = "1kd4q2ddm5byf62xj923n140k9x89yf9yswwgsnvkbpvrnpl4mwj";

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
