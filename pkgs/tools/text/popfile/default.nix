{ lib, stdenv, fetchzip, makeWrapper, perlPackages,
... }:

stdenv.mkDerivation rec {
  appname = "popfile";
  version = "1.1.3";
  name = "${appname}-${version}";

  src = fetchzip {
    url = "https://getpopfile.org/downloads/${appname}-${version}.zip";
    sha256 = "0gcib9j7zxk8r2vb5dbdz836djnyfza36vi8215nxcdfx1xc7l63";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = (with perlPackages; [
    ## These are all taken from the popfile documentation as applicable to Linux
    ## https://getpopfile.org/docs/howtos:allplatformsrequireperl
    perl
    DBI
    DBDSQLite
    HTMLTagset
    TimeDate # == DateParse
    HTMLTemplate
    # IO::Socket::Socks is not in nixpkgs
    # IOSocketSocks
    IOSocketSSL
    NetSSLeay
    SOAPLite
  ]);

  installPhase = ''
    mkdir -p $out/bin
    # I user `cd` rather than `cp $out/* ...` b/c the * breaks syntax
    # highlighting in emacs for me.
    cd $src
    cp -r * $out/bin
    cd $out/bin
    chmod +x *.pl

    find $out -name '*.pl' -executable | while read path; do
      wrapProgram "$path" \
        --prefix PERL5LIB : $PERL5LIB:$out/bin \
        --set POPFILE_ROOT $out/bin \
        --run 'export POPFILE_USER=''${POPFILE_USER:-$HOME/.popfile}' \
        --run 'test -d "$POPFILE_USER" || mkdir -m 0700 -p "$POPFILE_USER"'
    done
  '';

  meta = {
    description = "An email classification system that automatically sorts messages and fights spam";
    homepage = "https://getpopfile.org/";
    license = lib.licenses.gpl2;

    # Should work on macOS, but havent tested it.
    # Windows support is more complicated.
    # https://getpopfile.org/docs/faq:systemrequirements
    platforms = lib.platforms.linux;
  };
}
