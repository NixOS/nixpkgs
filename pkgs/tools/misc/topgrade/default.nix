{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v57dqkrh67cmj1ish650z8yk737hm1qynqr5yv0vlna86gwhrhs";
  };

  cargoSha256 = "00vxrv8lbdwwbdbaqb4rq0w3bc8n9qwk9zgb1j656lyswib7g1d3";

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
