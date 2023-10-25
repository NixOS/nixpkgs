{ fetchgit, gawk, jq, lib, makeWrapper, slurp, stdenv, sway, bash }:

stdenv.mkDerivation rec {
  pname = "wlprop";
  version = "unstable-2022-08-18";

  src = fetchgit {
    url = "https://gist.github.com/f313386043395ff06570e02af2d9a8e0";
    rev = "758c548bfb4be5b437c428c8062b3987f126f002";
    sha256 = "sha256-ZJ9LYYrU2cNYikiVNTlEcI4QXcoqfl7iwk3Be+NhGG8=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    install -Dm755 wlprop.sh $out/bin/wlprop
    wrapProgram "$out/bin/wlprop" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ gawk jq slurp sway ]}"

    runHook postInstall
  '';
  passthru.scriptName = "wlprop.sh";

  meta = with lib; {
    description = "An xprop clone for wlroots based compositors";
    homepage = "https://gist.github.com/crispyricepc/f313386043395ff06570e02af2d9a8e0";
    license = licenses.mit;
    maintainers = with maintainers; [ sebtm ];
    platforms = platforms.linux;
  };
}
