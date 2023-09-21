{ lib
, stdenv
, fetchfossil
, tcl

, enableTcl ? true
}:

stdenv.mkDerivation {
  pname = "pikchr";
  # To update, use the last check-in in https://pikchr.org/home/timeline?r=trunk
  version = "unstable-2022-12-07";

  src = fetchfossil {
    url = "https://pikchr.org/home";
    rev = "21ca6b843d65c404";
    sha256 = "sha256-fp06GqpLa/szRCS54KJ+SkT602oWvK3KyDFFjTmpNfI=";
  };

  # can't open generated html files
  postPatch = ''
    substituteInPlace Makefile --replace open "test -f"
  '';

  nativeBuildInputs = lib.optional enableTcl tcl.tclPackageHook;

  buildInputs = lib.optional enableTcl tcl;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  buildFlags = [ "pikchr" ] ++ lib.optional enableTcl "piktcl";

  installPhase = ''
    runHook preInstall
    install -Dm755 pikchr $out/bin/pikchr
    install -Dm755 pikchr.out $out/lib/pikchr.o
    install -Dm644 pikchr.h $out/include/pikchr.h
  '' + lib.optionalString enableTcl ''
    cp -r piktcl $out/lib/piktcl
  '' + ''
    runHook postInstall
  '';

  dontWrapTclBinaries = true;

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "A PIC-like markup language for diagrams in technical documentation";
    homepage = "https://pikchr.org";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "pikchr";
  };
}
