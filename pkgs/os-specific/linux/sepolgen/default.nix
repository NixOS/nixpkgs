{ stdenv, fetchurl, libsepol, python }:

stdenv.mkDerivation rec {
  name = "sepolgen-${version}";
  version = "1.2.1";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/sepolgen-${version}.tar.gz";
    sha256 = "1c41hz4a64mjvbfhgc7c7plydahsc161z0qn46qz2g3bvimj9323";
  };

  makeFlags = "PREFIX=$(out) DESTDIR=$(out) PYTHONLIBDIR=lib/${python.libPrefix}/site-packages";

  buildInputs = [ python ];

  meta = with stdenv.lib; {
    inherit (libsepol.meta) homepage platforms maintainers;
    description = "SELinux policy generation library";
    license = licenses.gpl2;
  };
}
