{ lib, stdenv, fetchurl, pcre, pkg-config, libsepol
, enablePython ? true, swig ? null, python3 ? null
, fts
}:

assert enablePython -> swig != null && python3 != null;

with lib;

stdenv.mkDerivation rec {
  pname = "libselinux";
  version = "3.0";
  inherit (libsepol) se_release se_url;

  outputs = [ "bin" "out" "dev" "man" ] ++ optional enablePython "py";

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "0cr4p0qkr4qd5z1x677vwhz6mlz55kxyijwi2dmrvbhxcw7v78if";
  };

  nativeBuildInputs = [ pkg-config ] ++ optionals enablePython [ swig python3 ];
  buildInputs = [ libsepol pcre fts ] ++ optionals enablePython [ python3 ];

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags = [
    "PREFIX=$(out)"
    "INCDIR=$(dev)/include/selinux"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "MAN8DIR=$(man)/share/man/man8"
    "SBINDIR=$(bin)/sbin"
    "SHLIBDIR=$(out)/lib"

    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ] ++ optionals enablePython [
    "PYTHON=${python3.pythonForBuild.interpreter}"
    "PYTHONLIBDIR=$(py)/${python3.sitePackages}"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace src/procattr.c \
      --replace "#include <unistd.h>" ""
  '';

  preInstall = optionalString enablePython ''
    mkdir -p $py/${python3.sitePackages}/selinux
  '';

  installTargets = [ "install" ] ++ optional enablePython "install-pywrap";

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "SELinux core library";
  };
}
