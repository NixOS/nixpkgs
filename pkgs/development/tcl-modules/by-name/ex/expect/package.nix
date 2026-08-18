{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  tcl,
  makeWrapper,
  autoreconfHook,
  replaceVars,
  dejagnu,
}:

tcl.mkTclDerivation (finalAttrs: {
  pname = "expect";
  version = "6.0a2";

  src = fetchFromGitHub {
    owner = "tcltk-depot";
    repo = "expect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVs8wU8WlJ0XtEv5Femhb4lwKtyVkPHjosXLbQ8QR4g=";
  };

  patches = [
    (replaceVars ./fix-build-time-run-tcl.patch {
      tcl = "${buildPackages.tcl}/bin/tclsh";
    })
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

  __structuredAttrs = true;

  strictDeps = true;

  postInstall = ''
    tclWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ tcl ]})
    ${lib.optionalString stdenv.hostPlatform.isDarwin "tclWrapperArgs+=(--prefix DYLD_LIBRARY_PATH : $out/lib/expect${finalAttrs.version})"}
  '';

  doCheck = true;
  installCheckTarget = "test";
  tclRequiresCheck = [ "Expect" ];

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests = {
    inherit dejagnu;
  };

  meta = {
    description = "Tool for automating interactive applications";
    homepage = "https://expect.sourceforge.net/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    mainProgram = "expect";
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
