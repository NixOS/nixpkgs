{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1adx029cq30g0qnrvdq2di8bpadzdxrpbsqchxfsda8zg6cprh1j";
  };

  cargoSha256 = "0jpjn6sb8bkwnq7np487hb8bkm6rv84mihmqwy3ymgdzlqcng6sk";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  # TODO: add manpage (topgrade.8) to postInstall on next update

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 hugoreeves ];
  };
}
