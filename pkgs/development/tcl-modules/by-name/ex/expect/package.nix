{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  tcl,
  makeWrapper,
  autoreconfHook,
  replaceVars,
}:

tcl.mkTclDerivation rec {
  pname = "expect";
  version = "5.45.4-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "tcltk-depot";
    repo = "expect";
    rev = "f1a97f45b8269b62c732e2a95f5cd78f26a79526";
    hash = "sha256-mmwlTMurUgo14W6kScEDynlg69kK2tMOjrXHSHuUxOI=";
  };

  patches = [
    (replaceVars ./fix-build-time-run-tcl.patch {
      tcl = "${buildPackages.tcl}/bin/tclsh";
    })
    # Include `sys/ioctl.h` and `util.h` on Darwin, which are required for `ioctl` and `openpty`.
    # Include `termios.h` on FreeBSD for `openpty`
    # TODO: rebase
    #./fix-darwin-bsd-clang16.patch
    # Remove some code which causes it to link against a file that does not exist at build time on native FreeBSD
    ./freebsd-unversioned.patch
  ];

  postPatch = ''
    sed -i "s,/bin/stty,$(type -p stty),g" configure.in
  '';

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  strictDeps = true;

  postInstall = ''
    tclWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ tcl ]})
    ${lib.optionalString stdenv.hostPlatform.isDarwin "tclWrapperArgs+=(--prefix DYLD_LIBRARY_PATH : $out/lib/expect${version})"}
  '';

  doCheck = true;
  installCheckTarget = "test";
  tclRequiresCheck = [ "Expect" ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Tool for automating interactive applications";
    homepage = "https://expect.sourceforge.net/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    mainProgram = "expect";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
