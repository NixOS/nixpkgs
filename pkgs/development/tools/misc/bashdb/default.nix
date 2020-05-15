{ stdenv, fetchurl, makeWrapper, python3Packages }:

stdenv.mkDerivation rec {
  pname = "bashdb";
  version = "4.4-1.0.0";

  src = fetchurl {
    url =  "mirror://sourceforge/bashdb/${pname}-${version}.tar.bz2";
    sha256 = "0p7i7bpzs6q1i7swnkr89kxqgzr146xw8d2acmqwqbslzm9dqlml";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/bashdb --prefix PYTHONPATH ":" "$(toPythonPath ${python3Packages.pygments})"
  '';

  meta = {
    description = "Bash script debugger";
    homepage = "http://bashdb.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
