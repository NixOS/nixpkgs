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

  makeFlags = [
    "PREFIX=$(out)"
    "LIBSEPOLA=${stdenv.lib.getLib libsepol}/lib/libsepol.a"
  ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "SELinux policy compiler";
  };
}
