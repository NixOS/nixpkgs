{ mkDerivation, buildPackages, buildFreebsd, lib, hostVersion, mtree, pkgsBuildBuild, ... }:
mkDerivation {
  isStatic = true;
  inherit hostVersion;
  path = "include";

  extraPaths = [
    "contrib/libc-vis"
    "etc/mtree/BSD.include.dist"
    "sys"
  ];

  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal
    buildFreebsd.install
    buildPackages.mandoc buildPackages.groff /*nbperf*/ buildFreebsd.rpcgen

    # HACK use NetBSD's for now
    buildPackages.netbsd.mtree
    #mtree
  ];

  patches = [
    ./no-perms-BSD.include.dist.patch
  ];

  # The makefiles define INCSDIR per subdirectory, so we have to set
  # something else on the command line so those definitions aren't
  # overridden.
  postPatch = ''
    find "$BSDSRCDIR" -name Makefile -exec \
      sed -i -E \
        -e 's_/usr/include_''${INCSDIR0}_' \
        {} \;
  '';

  makeFlags = [
    "RPCGEN_CPP=${buildPackages.stdenv.cc.cc}/bin/cpp"
  ];

  # multiple header dirs, see above
  postConfigure = ''
    makeFlags=''${makeFlags/INCSDIR/INCSDIR0}
  '';

  headersOnly = true;

  MK_HESIOD = "yes";

  meta.platforms = lib.platforms.freebsd;
}
