{stdenv, fetchurl, fetchsvn, pythonPackages, xorg, pkgconfig, makeWrapper, argyllcms}:

pythonPackages.buildPythonPackage {

  # REGION AUTO UPDATE: { name="dispcalgui"; type="svn"; url="svn://svn.code.sf.net/p/dispcalgui/code/trunk"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/dispcalgui-svn-1425.tar.bz2"; sha256 = "9e07c59c9d6bc6162eddad44bd5c6241ea46136e48683183d57d8cc00ee78d87"; });
  name = "dispcalgui-svn-1425";
  # END

  # name = "dispcal-gui";
  # src = fetchsvn {
  #   url = "svn://svn.code.sf.net/p/dispcalgui/code/trunk";
  #   rev = "HEAD";
  #   sha256 = "1ky6iq2mddlz5bav9py45fcjmmh1d52sgk8974b2pngjm5ryamrp";
  # };

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

  meta = {
    description = "Open Source Display Calibration and Characterization powered by Argyll CMS";
    homepage = http://dispcalgui.hoech.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
