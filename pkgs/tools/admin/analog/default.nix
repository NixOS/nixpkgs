{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {

  name = "analog-6.0.13";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "http://www.c-amie.co.uk/static/analog/6013/analog-src-6013ce.zip";
    sha256 = "1njfsclmxk8sn1i07k3qfk8fmsnz7qw9kmydk3bil7qjf4ngmzc6";
  };

  configurePhase = ''
    sed -i src/anlghead.h \
      -e "s|#define DEFAULTCONFIGFILE .*|#define DEFAULTCONFIGFILE \"$out/etc/analog.cfg\"|g" \
      -e "s|#define LANGDIR .*|#define LANGDIR \"$out/share/${name}/lang/\"|g"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc $out/share/doc/${name} $out/share/man/man1 $out/share/${name}
    mv analog $out/bin/
    cp examples/big.cfg $out/etc/analog.cfg
    mv analog.man $out/share/man/man1/analog.1
    mv docs $out/share/doc/${name}/manual
    mv how-to $out/share/doc/${name}/
    mv lang images examples $out/share/${name}/
  '';

  meta = {
    homepage = https://www.c-amie.co.uk/software/analog/;
    license = stdenv.lib.licenses.gpl2;
    description = "Powerful tool to generate web server statistics";
    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = stdenv.lib.platforms.linux;
  };

}
