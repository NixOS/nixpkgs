{ lib, stdenv, fetchurl, python2, emacs }:

stdenv.mkDerivation rec {
  pname = "pydb";
  version = "1.26";

  src = fetchurl {
    url =  "mirror://sourceforge/sourceforge/bashdb/${pname}-${version}.tar.bz2";
    sha256 = "1wlkz1hd5d4gkzhkjkzcm650c1lchj28hj36jx96mklglm41h4q1";
  };

  buildInputs = [ python2 emacs /* emacs is optional */ ];

  preConfigure = ''
    p="$(toPythonPath $out)"
    configureFlags="$configureFlags --with-python=${python2.interpreter} --with-site-packages=$p"
  '';

  meta = {
    description = "Python debugger with GDB-like commands and Emacs bindings";
    homepage = "http://bashdb.sourceforge.net/pydb/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
