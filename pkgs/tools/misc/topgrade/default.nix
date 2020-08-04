{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rksd6bbnxaq8rfr5kabcl6xr6paqs0zg57xvn3vzpnnf41g1m3v";
  };

  cargoSha256 = "190sbp8j265iyxvl3rqs5q4wp6wk5c82f2yb46yhdmlm410zck47";

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
