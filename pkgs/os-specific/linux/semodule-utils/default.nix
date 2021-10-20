{ lib, stdenv, fetchurl, libsepol }:

stdenv.mkDerivation rec {
  pname = "semodule-utils";
  version = "2.9";

  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/${pname}-${version}.tar.gz";
    sha256 = "01yrwnd3calmw6r8kdh8ld7i7fb250n2yqqqk9p0ymrlwsg6g0w0";
  };

  buildInputs = [ libsepol ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = with lib; {
    description = "SELinux policy core utilities (packaging additions)";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms;
    maintainers = [ maintainers.e-user ];
  };
}
