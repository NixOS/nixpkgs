{ stdenv, fetchurl, libsepol, libselinux, bison, flex }:
stdenv.mkDerivation rec {

  name = "checkpolicy-${version}";
  version = "2.1.11";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "1wahs32l4jjlg0s3lyihdhvwmsy7yyvq5pk96q9lsiilc5vvrb06";
  };

  buildInputs = [ libsepol libselinux bison flex ];

  preBuild = '' makeFlags="$makeFlags LEX=flex LIBDIR=${libsepol}/lib PREFIX=$out" '';

  meta = with stdenv.lib; {
    description = "SELinux policy compiler";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
