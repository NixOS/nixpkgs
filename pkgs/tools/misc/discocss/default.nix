{ stdenvNoCC
, lib
, fetchFromGitHub
, discordAlias ? false
, discord
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "discocss";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-of7OMgbuwebnFmbefGD1/dOhyTX1Hy7TccnWSRCweW0=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 discocss $out/bin/discocss
  '' + lib.optionalString discordAlias ''
    wrapProgram $out/bin/discocss --set DISCOCSS_DISCORD_BIN ${discord}/bin/Discord
    ln -s $out/bin/discocss $out/bin/Discord
    ln -s $out/bin/discocss $out/bin/discord
    mkdir -p $out/share
    ln -s ${discord}/share/* $out/share
  '';

  meta = with lib; {
    description = "A tiny Discord css-injector";
    changelog = "https://github.com/mlvzk/discocss/releases/tag/v${version}";
    homepage = "https://github.com/mlvzk/discocss";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mlvzk ];
    mainProgram = "discocss";
  };
}
