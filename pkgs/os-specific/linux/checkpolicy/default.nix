{ stdenv, fetchurl, libsepol, libselinux, bison, flex }:
stdenv.mkDerivation rec {

  name = "checkpolicy-${version}";
  version = "2.2";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "1y5dx4s5k404fgpm7hlhgw8a9b9ksn3q2d3fj6f9rdac9n7nkxlz";
  };

  buildInputs = [ libsepol libselinux bison flex ];

  preBuild = '' makeFlags="$makeFlags LEX=flex LIBDIR=${libsepol}/lib PREFIX=$out" '';

  meta = with stdenv.lib; {
    description = "SELinux policy compiler";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
