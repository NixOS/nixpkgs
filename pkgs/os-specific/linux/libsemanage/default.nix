{ stdenv, fetchurl, pkgconfig, bison, flex, libsepol, libselinux, bzip2, audit
, enablePython ? true, swig ? null, python ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libsemanage";
  version = "2.9";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "075w6y3l9hiy5hicgwrmijyxmhfyd1r7cnc08qxyg4j46jfk8xi5";
   };

  outputs = [ "out" "dev" "man" ] ++ optional enablePython "py";

  nativeBuildInputs = [ bison flex pkgconfig ];
  buildInputs = [ libsepol libselinux bzip2 audit ]
    ++ optionals enablePython [ swig python ];

  makeFlags = [
    "PREFIX=$(out)"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "PYTHON=python"
    "PYTHONLIBDIR=$(py)/${python.sitePackages}"
    "DEFAULT_SEMANAGE_CONF_LOCATION=$(out)/etc/selinux/semanage.conf"
  ];

  installTargets = [ "install" ] ++ optionals enablePython [ "install-pywrap" ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "Policy management tools for SELinux";
    license = stdenv.lib.licenses.lgpl21;
  };
}
