{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gprbuild-boot
, which
, gnat
, xmlada
}:

stdenv.mkDerivation {
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
  ];

  propagatedBuildInputs = [
    xmlada
  ];

  makeFlags = [
    "ENABLE_SHARED=${if stdenv.hostPlatform.isStatic then "no" else "yes"}"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    # confusingly, for gprbuild --target is autoconf --host
    "TARGET=${stdenv.hostPlatform.config}"
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    "LIBRARY_TYPE=relocatable"
  ];

  # Fixes gprbuild being linked statically always
  patches = lib.optional (!stdenv.hostPlatform.isStatic) (fetchpatch {
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
}
