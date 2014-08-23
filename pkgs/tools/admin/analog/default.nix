{ stdenv, fetchurl }:

let
  name = "analog-6.0";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.analog.cx/${name}.tar.gz";
    sha256 = "31c0e2bedd0968f9d4657db233b20427d8c497be98194daf19d6f859d7f6fcca";
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
    homepage = "http://www.analog.cx/";
    license = stdenv.lib.licenses.gpl2;
    description = "Powerful tool to generate web server statistics";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };

}
