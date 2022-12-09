{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, babashka
, graalvm17-ce
}:

stdenvNoCC.mkDerivation rec {
  pname = "bbin";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "babashka";
    repo = "bbin";
    rev = "v${version}";
    sha256 = "sha256-Oo6YF+uxcUG26Pz1X5uzPE/Hsx0UToOErZ2oUiKuZyI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D bbin $out/bin/bbin
    mkdir -p $out/share
    cp -r docs $out/share/docs
    wrapProgram $out/bin/bbin \
      --prefix PATH : "${lib.makeBinPath [ babashka graalvm17-ce ]}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/babashka/bbin";
    description = "Install any Babashka script or project with one command";
    license = licenses.mit;
    inherit (babashka.meta) platforms;
    maintainers = with maintainers; [ sohalt ];
  };
}
