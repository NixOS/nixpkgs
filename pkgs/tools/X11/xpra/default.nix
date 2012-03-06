{stdenv, fetchurl, pkgconfig, python, pyrex, pygtk, xlibs, gtk, makeWrapper}:

stdenv.mkDerivation {
  name = "xpra-0.0.3";
  
  src = fetchurl {
    url = http://partiwm.org/static/downloads/parti-all-0.0.3.tar.gz;
    sha256 = "17inksd4cc7mba2vfs17gz1yk3h6x6wf06pm3hcbs5scq8rr5bkp";
  };

  #src = /home/eelco/Dev/nixpkgs/parti-all-0.0.3;

  buildInputs = [
    pkgconfig python pyrex pygtk gtk makeWrapper
    xlibs.inputproto xlibs.libXcomposite xlibs.libXdamage xlibs.libXtst
  ];

  buildPhase = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0)"
    NIX_LDFLAGS="$NIX_LDFLAGS -lXcomposite -lXdamage"
    ./do-build
  '';

  installPhase = ''
    mkdir -p $out
    cp -r install/* $out

    for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
            --set PYTHONPATH "$out/lib/python:$(toPythonPath ${pygtk})/gtk-2.0:$PYTHONPATH" \
            --prefix PATH : "${xlibs.xauth}/bin:${xlibs.xorgserver}/bin:${xlibs.xmodmap}/bin"
    done
  '';
  
  meta = {
    homepage = http://partiwm.org/wiki/xpra;
    description = "Persistent remote applications for X";
  };
}
