{ lib, stdenv, fetchurl, fixDarwinDylibNames, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.8.4";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "1rbsngfw36lyc8s6qxl8hgb1pzj0gdzlb7yqkfblb8fpgs2z0ggyhnfszrqfir8s569i7a9yk9bdx2ggwqhjj56hmi2i4inlnb3rmni";
  };

  nativeBuildInputs = [ which ]
    ++ lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  configurePhase = ''
    runHook preConfigure
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                LIBDIR=''${!outputLib}/lib \
                MANDIR=''${!outputMan}/share/man
    runHook postConfigure
  '';

  # Fix lib extension so that fixDarwinDylibNames detects it
  postInstall = lib.optionalString (stdenv.isDarwin && !stdenv.isAarch64) ''
    mv $lib/lib/liblowdown.{so,dylib}
  '';

  patches = lib.optional (!stdenv.hostPlatform.isStatic) ./shared.patch;

  patchPhase = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    substituteInPlace main.c \
      --replace '#elif HAVE_SANDBOX_INIT' '#elif 0'
  '';

  doInstallCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  installCheckPhase = "echo '# TEST' > test.md; $out/bin/lowdown test.md";

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
