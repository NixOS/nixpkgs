{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rskk3cb253xbdn42ccm5ks39xac4q1hgz67nfi1hpwnavpx5g6p";
  };

  cargoSha256 = "0d00r52qhahdx1yylpri7cm85csvy0bwzspwgwqwgilxcfnf5a16";

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
