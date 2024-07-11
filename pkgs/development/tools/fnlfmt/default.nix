{ lib, stdenv, fetchFromSourcehut, luaPackages, lua }:

stdenv.mkDerivation rec {
  pname = "fnlfmt";
  version = "0.3.1";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "sha256-rhbYG0TpqAZnbLaZOG739/pDA61Dwb4Y1HhBxWLtOus=";
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
