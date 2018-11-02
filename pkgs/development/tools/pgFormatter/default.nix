{ buildPerlPackage, fetchFromGitHub, glibcLocales, lib, ... }:

# original implementation stolen from https://github.com/ariutta/nixpkgs-custom/blob/aa72a115a71bb248a2a7f0deac55132e68b54365/perl-packages.nix#L13

buildPerlPackage rec {
  name = "pgFormatter-${version}";
  version = "v3.2";

  src = fetchFromGitHub {
    owner  = "darold";
    repo   = "pgFormatter";
    rev    = "${version}";
    sha256 = "1rvamvgymm4b60bq0s46mdxhqavl628vcqp7f7j1slrs4wm62ykc";
  };

  # glibcLocales is needed to fix a locale issue. See this comment:
  # https://github.com/NixOS/nixpkgs/issues/8398#issuecomment-186832814
  # TODO: is buildInputs the right way to specify this dependency?
  buildInputs = [ glibcLocales ];

  outputs = [ "out" ];

  makeMakerFlags = [ "INSTALLDIRS=vendor" ];

  # Makefile.PL only accepts DESTDIR and INSTALLDIRS, but we need to set more to make this work for NixOS.
  patchPhase = ''
    sed -i "s#'DESTDIR'      => \$DESTDIR,#'DESTDIR'      => '$out/',#" Makefile.PL
    sed -i "s#'INSTALLDIRS'  => \$INSTALLDIRS,#'INSTALLDIRS'  => \$INSTALLDIRS, 'INSTALLVENDORLIB'  => 'bin/lib', 'INSTALLVENDORBIN'  => 'bin', 'INSTALLVENDORSCRIPT'  => 'bin', 'INSTALLVENDORMAN1DIR'  => 'share/man/man1', 'INSTALLVENDORMAN3DIR'  => 'share/man/man3',#" Makefile.PL
  '';

  doCheck = false;

  meta = {
    description = "A PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI.";
    homepage = https://github.com/darold/pgFormatter;
    maintainers = with lib.maintainers; [ ariutta srghma ];
    license = with lib.licenses; [ postgresql artistic2 ];
  };
}
