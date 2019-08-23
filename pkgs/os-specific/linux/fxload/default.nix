{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fxload-2002_04_11";

  src = fetchurl {
    url = mirror://sourceforge/linux-hotplug/fxload-2002_04_11.tar.gz;
    sha256 = "1hql93bp3dxrv1p67nc63xsbqwljyynm997ysldrc3n9ifi6s48m";
  };

  patches = [
    # Will be needed after linux-headers is updated to >= 2.6.21.
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/sys-apps/fxload/files/fxload-20020411-linux-headers-2.6.21.patch?rev=1.1";
      sha256 = "0ij0c8nr1rbyl5wmyv1cklhkxglvsqz32h21cjw4bjm151kgmk7p";
    })
  ];

  preBuild = ''
    substituteInPlace Makefile --replace /usr /
    makeFlagsArray=(INSTALL=install prefix=$out)
  '';

  preInstall = ''
    mkdir -p $out/sbin
    mkdir -p $out/share/man/man8
    mkdir -p $out/share/usb
  '';

  meta = with stdenv.lib; {
    homepage = http://linux-hotplug.sourceforge.net/?selected=usb;
    description = "Tool to upload firmware to Cypress EZ-USB microcontrollers";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
