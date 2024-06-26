{
  lib,
  stdenv,
  fetchzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "randtype";
  version = "1.13";

  src = fetchzip {
    url = "mirror://sourceforge/randtype/${pname}-${version}.tar.gz";
    sha256 = "055xs02qwpgbkn2l57bwghbsrsysg1zhm2asp0byvjpz4sc4w1rd";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/man/man1 $out/bin
    install -cp randtype.1.gz $out/share/man/man1
    install -cps randtype $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "semi-random text typer";
    mainProgram = "randtype";
    homepage = "https://benkibbey.wordpress.com/randtype/";
    maintainers = with maintainers; [ dandellion ];
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/randtype.x86_64-darwin
  };
}
