{ lib, stdenv, fetchurl, fixDarwinDylibNames, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.8.2";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "07xy6yjs24zkwrr06ly4ln5czvm3azw6iznx6m8gbrmzblkcp3gz1jcl9wclcyl8bs4xhgmyzkf5k67b95s0jndhyb9ap5zy6ixnias";
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
  postInstall = lib.optionalString stdenv.isDarwin ''
    mv $lib/lib/liblowdown.{so,dylib}
  '';

  patches = lib.optional (!stdenv.hostPlatform.isStatic) ./shared.patch;

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}

