{stdenv, fetchsvn, pythonPackages, xorg, pkgconfig, makeWrapper, argyllcms}:

/* is known to segfault when calibrating on ati proprietary hardware */

pythonPackages.buildPythonPackage {

  name = "dispcal-gui";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/dispcalgui/code/trunk";
    rev = "HEAD";
    sha256 = "1ky6iq2mddlz5bav9py45fcjmmh1d52sgk8974b2pngjm5ryamrp";
  };

  doCheck = false;

  preConfigure = ''
    mkdir home
    export HOME=`pwd`/home
    sed -i 's@X11/extensions/dpms.h@xcb/dpms.h@' dispcalGUI/RealDisplaySizeMM.c
    sed -i "s@/etc/udev/rules.d@$out/etc/udev/rules.d@" setup.py dispcalGUI/setup.py

    # make it always look for argyllcms binaries in the argyllcms/bin store path
    sed -i 's@""" Find a single Argyll utility. Return the full path. """@return "'${argyllcms}'/bin/%s" % name@' dispcalGUI/worker.py
  '';

  buildInputs = [
    pkgconfig
    xorg.libX11
    xorg.libXxf86vm
    xorg.libxcb
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender

    makeWrapper
    pythonPackages.numpy
    pythonPackages.wxPython
  ];

  postInstall = ''
    wrapProgram $out/bin/dispcalGUI \
      --prefix PYTHONPATH ":" $PYTHONPATH
  '';

  # meta = {
  #   description = "<++>";
  #   homepage = <++>;
  #   license = stdenv.lib.licenses.;
  #   maintainers = [stdenv.lib.maintainers.marcweber];
  #   platforms = stdenv.lib.platforms.linux;
  # };
}
