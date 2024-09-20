{ lib, stdenv, fetchurl, fixDarwinDylibNames, which, dieHook
, fetchpatch
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
# for passthru.tests
, nix
}:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "1.1.0";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    hash = "sha512-EpAWTz7Zy+2qqJGgzLrt0tK7WEZ+hHbdyqzAmMiaqc6uNXscR88git6/UbTjvB9Yanvetvw9huSuyhcORCEIug==";
  };

  patches = [
    # Improve UTF-8 handling on macOS by not treating bytes >=0x80, which tend to be
    # UTF-8 continuation bytes, as control characters.
    #
    # This leaves control characters U+0080 through U+009F in the output
    # (incorrectly) but doesn't mangle other UTF-8 characters, so it's a net
    # win.
    #
    # See: https://github.com/kristapsdz/lowdown/pull/140
    (fetchpatch {
      url = "https://github.com/kristapsdz/lowdown/commit/5a02866dd682363a8e4f6b344c223cfe8b597da9.diff";
      hash = "sha256-7tGhZJQQySeBv4h6A4r69BBbQkPRX/3JTw/80A8YXjQ=";
    })
    (fetchpatch {
      url = "https://github.com/kristapsdz/lowdown/commit/c033a6886e4d6efb948782fbc389fe5f673acf36.diff";
      hash = "sha256-7DvKFerAMoPifuTn7rOX4ru888HfBkpspH1opIbzj08=";
    })

    # Don't output a newline after .SH
    #
    # This fixes `makewhatis` output on macOS and (as a result) `man`
    # completions for `fish` on macOS.
    #
    # See: https://github.com/kristapsdz/lowdown/pull/138
    (fetchpatch {
      url = "https://github.com/kristapsdz/lowdown/commit/e05929a09a697de3d2eb14d0f0a087a6fae22e11.diff";
      hash = "sha256-P03W+hFeBKwfJB+DhGCPq0DtiOiLLc+0ZvWrWqXFvVU=";
    })
    (fetchpatch {
      url = "https://github.com/kristapsdz/lowdown/commit/9906f8ceac586c54eb39ae78105fd84653a89c33.diff";
      hash = "sha256-nBnAgTb8RDe/QpUhow3lyeR7UIVJX2o4lmP78e2fw/E=";
    })
  ];

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
      soVersion = "1";
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
