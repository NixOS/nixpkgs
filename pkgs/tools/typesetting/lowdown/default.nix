{ lib, stdenv, fetchurl, fixDarwinDylibNames, which, dieHook
, enableShared ? !(stdenv.hostPlatform.isStatic)
, enableStatic ? stdenv.hostPlatform.isStatic
# for passthru.tests
, nix
}:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "1.0.2";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "1cizrzmldi7lrgdkpn4b6skp1b5hz2jskkbcbv9k6lmz08clm02gyifh7fgd8j2rklqsim34n5ifyg83xhsjzd57xqjys1ccjdn3a5m";
  };

  nativeBuildInputs = [ which dieHook ]
    ++ lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  preConfigure = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    echo 'HAVE_SANDBOX_INIT=0' > configure.local
  '';

  configurePhase = ''
    runHook preConfigure
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                LIBDIR=''${!outputLib}/lib \
                MANDIR=''${!outputMan}/share/man
    runHook postConfigure
  '';

  makeFlags = [
    "bins" # prevents shared object from being built unnecessarily
  ];

  installTargets = [
    "install"
  ] ++ lib.optionals enableShared [
    "install_shared"
  ] ++ lib.optionals enableStatic [
    "install_static"
  ];

  postInstall =
    let
      inherit (stdenv.hostPlatform.extensions) sharedLibrary;
      soVersion = "3";
    in

    # Check that soVersion is up to date even if we are not on darwin
    lib.optionalString (enableShared && !stdenv.isDarwin) ''
      test -f $lib/lib/liblowdown.so.${soVersion} || \
        die "postInstall: expected $lib/lib/liblowdown.so.${soVersion} is missing"
    ''
    # Fix lib extension so that fixDarwinDylibNames detects it, see
    # <https://github.com/kristapsdz/lowdown/issues/87#issuecomment-1532243650>.
    + lib.optionalString (enableShared && stdenv.isDarwin) ''
      darwinDylib="$lib/lib/liblowdown.${soVersion}.dylib"
      mv "$lib/lib/liblowdown.so.${soVersion}" "$darwinDylib"

      # Make sure we are re-creating a symbolic link here
      test -L "$lib/lib/liblowdown.so" || \
        die "postInstall: expected $lib/lib/liblowdown.so to be a symlink"
      ln -s "$darwinDylib" "$lib/lib/liblowdown.dylib"
      rm "$lib/lib/liblowdown.so"
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    echo '# TEST' > test.md
    $out/bin/lowdown test.md
    runHook postInstallCheck
  '';

  doCheck = true;
  checkTarget = "regress";

  passthru.tests = {
    # most important consumer in nixpkgs
    inherit nix;
  };

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
