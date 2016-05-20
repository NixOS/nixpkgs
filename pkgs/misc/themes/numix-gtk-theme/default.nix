{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.5.1";
  name = "numix-gtk-theme-${version}";
  
  src = fetchurl {
    url = "https://github.com/numixproject/Numix/archive/v${version}.tar.gz";
    sha256 = "0y6c4xr2n9sygxhgviwd97l02n17n53bkpfp62srkm05cq0jy87k";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Numix
    cp -dr --no-preserve='ownership' {LICENSE,CREDITS,index.theme,gtk-2.0,gtk-3.0,metacity-1,openbox-3,unity,xfce-notify-4.0,xfwm4} $out/share/themes/Numix/
  '';
  
  meta = {
    description = "Numix GTK theme";
    homepage = https://numixproject.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
