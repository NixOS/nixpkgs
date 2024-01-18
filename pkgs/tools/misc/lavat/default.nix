{ lib
, stdenv
, fetchFromGitHub
,
}:
let
  version = "2.0.0";
in
stdenv.mkDerivation {
  pname = "lavat";
  inherit version;

  src = fetchFromGitHub {
    owner = "AngelJumbo";
    repo = "lavat";
    rev = "v${version}";
    hash = "sha256-xDjqKhwoaqCqo7tkpcEe2MBEpVTJUOpKtu7Fi9aPOPo=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp lavat $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lava lamp simulation in the terminal";
    longDescription = ''
      Lavat puts ascii metaballs in your terminal to make it look a bit like a
      lava lamp.

      Lavat contains various options, including those to change the color and
      speed of the metaballs. For a full list, run `lavat -h`
    '';
    maintainers = [ maintainers.minion3665 ];
    license = licenses.mit;
    homepage = "https://github.com/AngelJumbo/lavat";
    platforms = platforms.all;
    mainProgram = "lavat";
  };
}
