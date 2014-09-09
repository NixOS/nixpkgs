{ stdenv, fetchurl, libsepol, libselinux, bison, flex }:
stdenv.mkDerivation rec {

  name = "checkpolicy-${version}";
  version = "2.3";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "0yr0r2cxz9lbj7i0wqgcd4wjvc6zf1fmqk0xjybnkdpcmw8jsqwh";
  };

  buildInputs = [ libsepol libselinux bison flex ];

  preBuild = ''
    makeFlags="$makeFlags LEX=flex LIBDIR=${libsepol}/lib PREFIX=$out"
    sed -e 's@[.]o$@& ../lex.yy.o@' -i test/Makefile
  '';

  meta = with stdenv.lib; {
    description = "SELinux policy compiler";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
