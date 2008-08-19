args : with args; with builderDefs;
  let localDefs = builderDefs.meta.function (rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = mirror://sourceforge/libvncserver/x11vnc-0.9.3.tar.gz;
      sha256 = "0sfzkbqd2d94w51czci9w5j5z67amcl1gphgg6x77dyr2h46kc0a";
    };

    buildInputs = [libXfixes fixesproto openssl libXdamage damageproto
      zlib libX11 xproto libjpeg libXtst libXinerama xineramaproto
      libXrandr randrproto libXext xextproto inputproto recordproto];
    configureFlags = [];
  });
  in with localDefs;
stdenv.mkDerivation rec {
  name = "x11vnc-"+version;
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
      [doConfigure doMakeInstall doForceShare doPropagate]);
  meta = {
    description = "
    X11 VNC - VNC server connected to real X11 screen.
";
    homepage = "http://www.karlrunge.com/x11vnc/";
		inherit src;
  };
}

