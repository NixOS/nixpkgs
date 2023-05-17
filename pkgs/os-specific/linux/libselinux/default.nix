{ lib, stdenv, fetchurl, fetchpatch, buildPackages, pcre, pkg-config, libsepol
, enablePython ? !stdenv.hostPlatform.isStatic, swig ? null, python3 ? null
, fts
}:

assert enablePython -> swig != null && python3 != null;

with lib;

stdenv.mkDerivation rec {
  pname = "libselinux";
  version = "3.3";
  inherit (libsepol) se_url;

  outputs = [ "bin" "out" "dev" "man" ] ++ optional enablePython "py";

  src = fetchurl {
    url = "${se_url}/${version}/libselinux-${version}.tar.gz";
    sha256 = "0mvh793g7fg6wb6zqhkdyrv80x6k84ypqwi8ii89c91xcckyxzdc";
  };

  patches = [
    # Make it possible to disable shared builds (for pkgsStatic).
    #
    # We can't use fetchpatch because it processes includes/excludes
    # /after/ stripping the prefix, which wouldn't work here because
    # there would be no way to distinguish between
    # e.g. libselinux/src/Makefile and libsepol/src/Makefile.
    #
    # This is a static email, so we shouldn't have to worry about
    # normalizing the patch.
    (fetchurl {
      url = "https://lore.kernel.org/selinux/20211113141616.361640-1-hi@alyssa.is/raw";
      sha256 = "16a2s2ji9049892i15yyqgp4r20hi1hij4c1s4s8law9jsx65b3n";
      postFetch = ''
        mv "$out" $TMPDIR/patch
        ${buildPackages.patchutils_0_3_3}/bin/filterdiff \
            -i 'a/libselinux/*' --strip 1 <$TMPDIR/patch >"$out"
      '';
    })
  ];

  nativeBuildInputs = [ pkg-config python3 ] ++ optionals enablePython [ swig ];
  buildInputs = [ libsepol pcre fts ] ++ optionals enablePython [ python3 ];

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

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
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ optionals stdenv.hostPlatform.isStatic [
    "DISABLE_SHARED=y"
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
