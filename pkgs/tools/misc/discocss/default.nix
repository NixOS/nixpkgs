{ stdenvNoCC
, lib
, fetchFromGitHub
, discordAlias ? false
, discord
, makeWrapper
, fetchpatch
}:

stdenvNoCC.mkDerivation rec {
  pname = "discocss";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-afmQCOOZ1MwQkbZZNHYfq2+IRv2eOtYBrGVHzDEbUHw=";
  };

  patches = lib.optional discordAlias [
    # Needed until https://github.com/mlvzk/discocss/pull/17 gets merged
    (fetchpatch {
      name = "discocss-make-discord-target-binary-configurable.patch";
      url = "https://github.com/mlvzk/discocss/commit/83b53f3d08cd1d448caa4aa77a4a19f2fdc2f523.patch";
      sha256 = "sha256-T7OCmX2ZVcTSSp+nXVSNvOSB5IDg9dG5b/mL9kIemmk=";
    })
  ];

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
  };
}
