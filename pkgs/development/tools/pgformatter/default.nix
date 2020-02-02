{ stdenv, perlPackages, fetchFromGitHub, shortenPerlShebang }:

perlPackages.buildPerlPackage rec {
  pname = "pgformatter";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgFormatter";
    rev = "v${version}";
    sha256 = "1fqhbs7q3nxda7acbcx8dyjh99d0mv485dpmiczxia7cy1xqi63g";
  };

  outputs = [ "out" ];

  makeMakerFlags = [ "INSTALLDIRS=vendor" ];

  # Makefile.PL only accepts DESTDIR and INSTALLDIRS, but we need to set more to make this work for NixOS.
  patchPhase = ''
    substituteInPlace pg_format \
      --replace "#!/usr/bin/env perl" "#!/usr/bin/perl"
    substituteInPlace Makefile.PL \
      --replace "'DESTDIR'      => \$DESTDIR," "'DESTDIR'      => '$out/'," \
      --replace "'INSTALLDIRS'  => \$INSTALLDIRS," "'INSTALLDIRS'  => \$INSTALLDIRS, 'INSTALLVENDORLIB' => 'bin/lib', 'INSTALLVENDORBIN' => 'bin', 'INSTALLVENDORSCRIPT' => 'bin', 'INSTALLVENDORMAN1DIR' => 'share/man/man1', 'INSTALLVENDORMAN3DIR' => 'share/man/man3',"
  '';

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin shortenPerlShebang;
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/pg_format
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI";
    homepage = "https://github.com/darold/pgFormatter";
    changelog = "https://github.com/darold/pgFormatter/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = [ licenses.postgresql licenses.artistic2 ];
  };
}
