{ lib, stdenv, perlPackages, fetchFromGitHub, shortenPerlShebang }:

perlPackages.buildPerlPackage rec {
  pname = "pgformatter";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgFormatter";
    rev = "v${version}";
    sha256 = "1a6rmph96s7c8lpmpkizcvdf0x4jlsr5iqi7qjprxqsf6zak2rfg";
  };

  outputs = [ "out" ];

  makeMakerFlags = [ "INSTALLDIRS=vendor" ];

  # Avoid creating perllocal.pod, which contains a timestamp
  installTargets = [ "pure_install" ];

  # Makefile.PL only accepts DESTDIR and INSTALLDIRS, but we need to set more to make this work for NixOS.
  patchPhase = ''
    substituteInPlace pg_format \
      --replace "#!/usr/bin/env perl" "#!/usr/bin/perl"
    substituteInPlace Makefile.PL \
      --replace "'DESTDIR'      => \$DESTDIR," "'DESTDIR'      => '$out/'," \
      --replace "'INSTALLDIRS'  => \$INSTALLDIRS," "'INSTALLDIRS'  => \$INSTALLDIRS, 'INSTALLVENDORLIB' => 'bin/lib', 'INSTALLVENDORBIN' => 'bin', 'INSTALLVENDORSCRIPT' => 'bin', 'INSTALLVENDORMAN1DIR' => 'share/man/man1', 'INSTALLVENDORMAN3DIR' => 'share/man/man3',"
  '';

  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/pg_format
  '';

  doCheck = false;

  meta = with lib; {
    description = "A PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI";
    homepage = "https://github.com/darold/pgFormatter";
    changelog = "https://github.com/darold/pgFormatter/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = [ licenses.postgresql licenses.artistic2 ];
  };
}
