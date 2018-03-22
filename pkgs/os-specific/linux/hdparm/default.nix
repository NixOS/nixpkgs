{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hdparm-9.54";

  src = fetchurl {
    url = "mirror://sourceforge/hdparm/${name}.tar.gz";
    sha256 = "0ghnhdj7wfw6acfyhdawpfa5n9kvkvzgi1fw6i7sghgbjx5nhyjd";

  };

  preBuild = ''
    makeFlagsArray=(sbindir=$out/sbin manprefix=$out)
    '';

  meta = with stdenv.lib; {
    description = "A tool to get/set ATA/SATA drive parameters under Linux";
    homepage = https://sourceforge.net/projects/hdparm/;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.fuuzetsu ];
  };

}
