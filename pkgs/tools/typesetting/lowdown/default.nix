{ lib, stdenv, fetchurl, fixDarwinDylibNames, which }:

stdenv.mkDerivation rec {
  pname = "lowdown";
  version = "0.8.1";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "28kwj053lm3510cq7pg4rqx6linv5zphhm2h6r9icigclfq7j9ybnd7vqbn2v4ay0r8ghac5cjbqab5zy8cjlgllwhwsxg0dnk75x2i";
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

