{ stdenv, fetchurl, libsepol, python }:

stdenv.mkDerivation rec {
  name = "sepolgen-${version}";
  version = "1.1.8";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/sepolgen-${version}.tar.gz";
    sha256 = "1sssc9d4wz7l23yczlzplsmdr891sqr9w34ccn1bfwlnc4q63xdm";
  };

  makeFlags = "PREFIX=$(out) DESTDIR=$(out) PYTHONLIBDIR=lib/${python.libPrefix}/site-packages";

  buildInputs = [ python ];

  meta = with stdenv.lib; {
    inherit (libsepol.meta) homepage platforms maintainers;
    description = "SELinux policy generation library";
    license = licenses.gpl2;
  };
}
