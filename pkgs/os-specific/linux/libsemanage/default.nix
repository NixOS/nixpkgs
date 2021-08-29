{ lib, stdenv, fetchurl, pkg-config, bison, flex, libsepol, libselinux, bzip2, audit
, enablePython ? true, swig ? null, python ? null
}:

with lib;

stdenv.mkDerivation rec {
  pname = "libsemanage";
  version = "2.9";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "075w6y3l9hiy5hicgwrmijyxmhfyd1r7cnc08qxyg4j46jfk8xi5";
   };

  outputs = [ "out" "dev" "man" ] ++ optional enablePython "py";

  nativeBuildInputs = [ bison flex pkg-config ];
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

  # The following turns the 'clobbered' error into a warning
  # which should fix the following error:
  #
  # semanage_store.c: In function 'semanage_exec_prog':
  # semanage_store.c:1278:6: error: variable 'i' might be clobbered by 'longjmp' or 'vfork' [8;;https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wclobbered-Werror=clobbered8;;]
  #  1278 |  int i;
  #       |      ^
  # cc1: all warnings being treated as errors
  NIX_CFLAGS_COMPILE = [ "-Wno-error=clobbered" ];

  installTargets = [ "install" ] ++ optionals enablePython [ "install-pywrap" ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "Policy management tools for SELinux";
    license = lib.licenses.lgpl21;
  };
}
