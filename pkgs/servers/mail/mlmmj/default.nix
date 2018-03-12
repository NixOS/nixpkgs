{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {

  name = "mlmmj-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://mlmmj.org/releases/${name}.tar.gz";
    sha256 = "1sghqvwizvm1a9w56r34qy5njaq1c26bagj85r60h32gh3fx02bn";
  };

  postInstall = ''
    # grab all documentation files
    docfiles=$(find -maxdepth 1 -name "[[:upper:]][[:upper:]]*")
    install -vDm 644 -t $out/share/doc/mlmmj/ $docfiles
  '';

  meta = with stdenv.lib; {
    homepage = http://mlmmj.org;
    description = "Mailing List Management Made Joyful";
    maintainers = [ maintainers.edwtjo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

}
