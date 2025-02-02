{ lib, stdenv, perlPackages, fetchFromGitHub, shortenPerlShebang }:

perlPackages.buildPerlPackage rec {
  pname = "pgtop";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "cosimo";
    repo = "pgtop";
    rev = "v${version}";
    sha256 = "1awyl6ddfihm7dfr5y2z15r1si5cyipnlyyj3m1l19pk98s4x66l";
  };

  outputs = [ "out" ];

  buildInputs = with perlPackages; [ DBI DBDPg TermReadKey JSON LWP ];

  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/pgtop
  '';

  meta = with lib; {
    description = "a PostgreSQL clone of `mytop', which in turn is a `top' clone for MySQL";
    mainProgram = "pgtop";
    homepage = "https://github.com/cosimo/pgtop";
    changelog = "https://github.com/cosimo/pgtop/releases/tag/v${version}";
    maintainers = [ maintainers.hagl ];
    license = [ licenses.gpl2Only ];
  };
}
