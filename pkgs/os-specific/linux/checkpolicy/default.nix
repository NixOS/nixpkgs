{ stdenv, fetchurl, bison, flex, libsepol }:

stdenv.mkDerivation rec {
  name = "checkpolicy-${version}";
  version = "2.7";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "009j9jc0hi4l7k8f21hn8fm25n0mqgzdpd4nk30nds6d3nglf4sl";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol ];

  preBuild = ''
    makeFlagsArray+=("LIBDIR=${libsepol}/lib")
    makeFlagsArray+=("PREFIX=$out")
  '';

  meta = libsepol.meta // {
    description = "SELinux policy compiler";
  };
}
