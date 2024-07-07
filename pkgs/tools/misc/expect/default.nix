{ lib, stdenv, buildPackages, fetchurl, tcl, makeWrapper, autoreconfHook, fetchpatch, substituteAll }:

tcl.mkTclDerivation rec {
  pname = "expect";
  version = "5.45.4";

  src = fetchurl {
    url = "mirror://sourceforge/expect/Expect/${version}/expect${version}.tar.gz";
    hash = "sha256-Safag7C92fRtBKBN7sGcd2e7mjI+QMR4H4nK92C5LDQ=";
  };

  patches = [
    (substituteAll {
      src = ./fix-build-time-run-tcl.patch;
      tcl = "${buildPackages.tcl}/bin/tclsh";
    })
    # The following patches fix compilation with clang 15+
    (fetchpatch {
      url = "https://sourceforge.net/p/expect/patches/24/attachment/0001-Add-prototype-to-function-definitions.patch";
      hash = "sha256-X2Vv6VVM3KjmBHo2ukVWe5YTVXRmqe//Kw2kr73OpZs=";
    })
    (fetchpatch {
      url = "https://sourceforge.net/p/expect/patches/_discuss/thread/b813ca9895/6759/attachment/expect-configure-c99.patch";
      hash = "sha256-PxQQ9roWgVXUoCMxkXEgu+it26ES/JuzHF6oML/nk54=";
    })
    ./0004-enable-cross-compilation.patch
    # Include `sys/ioctl.h` and `util.h` on Darwin, which are required for `ioctl` and `openpty`.
    # Include `termios.h` on FreeBSD for `openpty`
    ./fix-darwin-bsd-clang16.patch
    # Remove some code which causes it to link against a file that does not exist at build time on native FreeBSD
    ./freebsd-unversioned.patch
  ];

  postPatch = ''
    sed -i "s,/bin/stty,$(type -p stty),g" configure.in
  '';

  nativeBuildInputs = [ autoreconfHook makeWrapper ];

  strictDeps = true;
  hardeningDisable = [ "format" ];

  postInstall = ''
    tclWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ tcl ]})
    ${lib.optionalString stdenv.isDarwin "tclWrapperArgs+=(--prefix DYLD_LIBRARY_PATH : $out/lib/expect${version})"}
  '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Tool for automating interactive applications";
    homepage = "https://expect.sourceforge.net/";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    mainProgram = "expect";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
