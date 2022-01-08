{ lib, stdenv, fetchurl, libsepol }:

stdenv.mkDerivation rec {
  pname = "semodule-utils";
  version = "3.3";

  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0qvhl40a6jlm8p719nnlw2ghlxbh8lxbcsd59azxp884bxgfr61h";
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
