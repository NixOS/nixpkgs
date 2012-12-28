{ stdenv, fetchurl, pkgconfig, python, cython
, pygtk, pygobject, pycairo, notify, xlibs, gtk
, ffmpeg, x264, libvpx, makeWrapper}:

stdenv.mkDerivation rec {
  name = "xpra-0.3.2";
  
  src = fetchurl {
    url = http://xpra.org/src/xpra-0.3.2.tar.bz2;
    sha256 = "1s1z6r0r78qvf59ci3vxammjz7lj5m64jyk0bfn7yxd5jl3sy41y";
  };

  nativeBuildInputs = [ cython ];

  buildInputs = [
    pkgconfig python pygtk gtk ffmpeg x264 libvpx makeWrapper
    xlibs.inputproto xlibs.libXcomposite xlibs.libXdamage xlibs.libXtst
  ];

  buildPhase = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0)"
    NIX_LDFLAGS="$NIX_LDFLAGS -lXcomposite -lXdamage"
    ./do-build
  '';

  pythonPaths = [
    "$out/lib/python"
    "$(toPythonPath ${pygtk})/gtk-2.0"
  ] ++ map (i: "$(toPythonPath ${i})") [
    pygobject pycairo notify
  ];

  installPhase = ''
    mkdir -p $out
    cp -r install/* $out

    for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
            --set PYTHONPATH "${stdenv.lib.concatStringsSep ":" pythonPaths}" \
            --prefix PATH : "${xlibs.xauth}/bin:${xlibs.xorgserver}/bin:${xlibs.xmodmap}/bin"
    done
  '';
  
  meta = {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
  };
}
