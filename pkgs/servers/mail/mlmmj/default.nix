{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {

  name = "mlmmj-${version}";
  version = "1.2.19.0";

  src = fetchurl {
    url = "http://mlmmj.org/releases/${name}.tar.gz";
    sha256 = "18n7b41nfdj7acvmqzkkz984d26xvz14xk8kmrnzv23dkda364m0";
  };

  meta = with stdenv.lib; {
    homepage = http://mlmmj.org;
    description = "Mailing List Management Made Joyful";
    maintainers = [ maintainers.edwtjo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

}