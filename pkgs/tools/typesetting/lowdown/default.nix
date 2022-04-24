{ lib, stdenv, fetchurl, fixDarwinDylibNames, which
, enableShared ? !(stdenv.hostPlatform.isStatic)
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.11.1";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "1l0055g8v0dygyxvk5rchp4sn1g2lakbf6hhq0wkj6nxkfpl43mkyc4vpb02r7v6iqfdwq4461dmdi78blsb3nj8b1gcjx75v7x9pa1";
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
