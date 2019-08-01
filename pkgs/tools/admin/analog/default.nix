{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "analog";
  version = "6.0.15";

  src = fetchFromGitHub {
    owner = "c-amie";
    repo = "analog-ce";
    rev = version;
    sha256 = "1clrx2xr3n5zh6gaavvdxkc127hayssxrplrd2qvw70givywza0m";
  };

  configurePhase = ''
    sed -i src/anlghead.h \
      -e "s|#define DEFAULTCONFIGFILE .*|#define DEFAULTCONFIGFILE \"$out/etc/analog.cfg\"|g" \
      -e "s|#define LANGDIR .*|#define LANGDIR \"$out/share/$pname}/lang/\"|g"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc $out/share/doc/$pname $out/share/man/man1 $out/share/$pname
    mv analog $out/bin/
    cp examples/big.cfg $out/etc/analog.cfg
    mv analog.man $out/share/man/man1/analog.1
    mv docs $out/share/doc/$pname/manual
    mv how-to $out/share/doc/$pname/
    mv lang images examples $out/share/$pname/
  '';

  meta = {
    homepage = "https://www.c-amie.co.uk/software/analog/";
    license = lib.licenses.gpl2;
    description = "Powerful tool to generate web server statistics";
    maintainers = [ lib.maintainers.peti ];
    platforms = lib.platforms.linux;
  };

}
