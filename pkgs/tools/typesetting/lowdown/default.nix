{ lib, stdenv, fetchurl, fixDarwinDylibNames, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.8.5";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "0gvrjxvizpxm5xvw8v2jygmx244wdl9n75qxz4chqbzkwshk4gwscz38p7sq9qlsbq8jmnv4l095a9dl9b836kym38hh1bvzmdiflar";
  };

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

  # Fix lib extension so that fixDarwinDylibNames detects it
  postInstall = lib.optionalString stdenv.isDarwin ''
    mv $lib/lib/liblowdown.{so,dylib}
  '';

  patches = lib.optional (!stdenv.hostPlatform.isStatic) ./shared.patch;

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
