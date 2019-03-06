{ stdenv, fetchurl, libsepol }:

stdenv.mkDerivation rec {
  name = "semodule-utils-${version}";
  version = "2.8";

  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/${name}.tar.gz";
    sha256 = "1pya3i6ggpl9hzfjhy74n4c91yqyzr6spkj3n5078qqc0w9rrxa4";
  };

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${stdenv.lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities (packaging additions)";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
