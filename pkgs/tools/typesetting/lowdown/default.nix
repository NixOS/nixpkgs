{ lib, stdenv, fetchurl, fixDarwinDylibNames, which
, enableShared ? !(stdenv.hostPlatform.isStatic)
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "1.0.0";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "2izqgzk677y511kms09c0hgar2ax5cd5hspr8djsa3qykaxq0688xkgfad00bl6j0jpixna714ipvqa0gxm480iz2sma7qhdgr6bl4x";
  };

  # Upstream always passes GNU-style "soname", but cctools expects "install_name".
  # Whatever name is inserted will be replaced by fixDarwinDylibNames.
  # https://github.com/kristapsdz/lowdown/issues/87
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace soname install_name
  '';

  nativeBuildInputs = [ which ]
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

  # Fix lib extension so that fixDarwinDylibNames detects it
  # Symlink liblowdown.so to liblowdown.so.1 (or equivalent)
  postInstall =
    let
      inherit (stdenv.hostPlatform.extensions) sharedLibrary;
    in

    lib.optionalString (enableShared && stdenv.isDarwin) ''
      mv $lib/lib/liblowdown.{so.1,1.dylib}
    '' + lib.optionalString enableShared ''
      ln -s $lib/lib/liblowdown*${sharedLibrary}* $lib/lib/liblowdown${sharedLibrary}
    '';

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    echo '# TEST' > test.md
    $out/bin/lowdown test.md
    runHook postInstallCheck
  '';

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkTarget = "regress";

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
