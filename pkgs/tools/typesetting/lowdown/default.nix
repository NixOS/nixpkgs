{ lib, stdenv, fetchurl, fixDarwinDylibNames, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.8.0";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "17w0hldlg7x0f4946bz1pmgkpp08dha3myz8pk0rx8n2lqlw76f3n9giq69kw82sgzg7qqy31sl9mxvgaxyf6hcdgmxnkr7h8d9xmak";
  };

  nativeBuildInputs = [ which ]
    ++ lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  configurePhase = ''
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                LIBDIR=''${!outputLib}/lib \
                MANDIR=''${!outputMan}/share/man
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

