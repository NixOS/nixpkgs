{ lib, stdenv, fetchFromSourcehut, fennel, lua }:

stdenv.mkDerivation rec {
  pname = "fnlfmt";
  version = "0.2.3";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = version;
    sha256 = "sha256-FKmr5Xihyk+ikYN8WXBq5UFJziwEb8xaUBswNt/JMBg=";
  };

  nativeBuildInputs = [ fennel ];

  buildInputs = [ lua ];

  buildPhase = ''
    runHook preBuild

    echo "#!${lua}/bin/lua" > fnlfmt
    ${fennel}/bin/fennel --require-as-include --compile cli.fnl >> fnlfmt
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
  };
}
