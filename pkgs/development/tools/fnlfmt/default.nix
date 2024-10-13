{ lib, stdenv, fetchFromSourcehut, luaPackages, lua }:

stdenv.mkDerivation rec {
  pname = "fnlfmt";
  version = "0.3.2";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "sha256-wbeWAv4xhxh7M6tRd9qpgBRtg1/fqg0AUPvh2M5f60Q=";
  };

  nativeBuildInputs = [ luaPackages.fennel ];

  buildInputs = [ lua ];

  buildPhase = ''
    runHook preBuild

    echo "#!${lua}/bin/lua" > fnlfmt
    ${luaPackages.fennel}/bin/fennel --require-as-include --compile cli.fnl >> fnlfmt
    chmod +x fnlfmt

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D ./fnlfmt $out/bin/fnlfmt
    runHook postInstall
  '';

  meta = with lib; {
    description = "Formatter for Fennel";
    homepage = "https://git.sr.ht/~technomancy/fnlfmt";
    license = licenses.lgpl3Plus;
    platforms = lua.meta.platforms;
    maintainers = with maintainers; [ chiroptical ];
    mainProgram = "fnlfmt";
  };
}
