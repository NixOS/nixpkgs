{ lib, stdenv, fetchurl, libsepol, python }:

stdenv.mkDerivation rec {
  pname = "sepolgen";
  version = "1.2.2";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/sepolgen-${version}.tar.gz";
    sha256 = "09139kspr41zgksayi4dh982p8080lrfl96p4dld51nknbpaigdy";
  };

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("PYTHONLIBDIR=lib/${python.libPrefix}/site-packages")
  '';

  meta = with lib; {
    inherit (libsepol.meta) homepage platforms maintainers;
    description = "SELinux policy generation library";
    license = licenses.gpl2;
  };
}
