{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gprbuild-boot
, which
, gnat
, xmlada
, fixDarwinDylibNames
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation ({
  pname = "gprbuild";

  # See ./boot.nix for an explanation of the gprbuild setupHook,
  # our custom knowledge base entry and the situation wrt a
  # (future) gprbuild wrapper.
  inherit (gprbuild-boot)
    version
    src
    setupHook
    meta
    ;

  nativeBuildInputs = [
    gnat
    gprbuild-boot
    which
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  propagatedBuildInputs = [
    xmlada
  ];

  makeFlags = [
    "ENABLE_SHARED=${if enableShared then "yes" else "no"}"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    # confusingly, for gprbuild --target is autoconf --host
    "TARGET=${stdenv.hostPlatform.config}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals enableShared [
    "LIBRARY_TYPE=relocatable"
  ];

  # Fixes gprbuild being linked statically always
  patches = lib.optional enableShared (fetchpatch {
    name = "gprbuild-relocatable-build.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/relocatable-build.patch?h=gprbuild&id=1d4e8a5cb982e79135a0aaa3ef87654bed1fe4f0";
    sha256 = "1r3xsp1pk9h666mm8mdravkybmd5gv2f751x2ffb1kxnwq1rwiyn";
  });

  buildFlags = [ "all" "libgpr.build" ];

  installFlags = [ "all" "libgpr.install" ];

  # link gprconfig_kb db from gprbuild-boot into build dir,
  # the install process copies its contents to $out
  preInstall = ''
    ln -sf ${gprbuild-boot}/share/gprconfig share/gprconfig
  '';

  # no need for the install script
  postInstall = ''
    rm $out/doinstall
  '';
} // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
  NIX_LDFLAGS = "-rpath $out/lib";
})
