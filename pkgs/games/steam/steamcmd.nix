{
  lib,
  stdenv,
  fetchurl,
  steam-run,
  bash,
  coreutils,
  steamRoot ? "~/.local/share/Steam",
}:

stdenv.mkDerivation {
  pname = "steamcmd";
  version = "20180104"; # According to steamcmd_linux.tar.gz mtime

  src = fetchurl {
    url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz";
    sha256 = "0z0y0zqvhydmfc9y9vg5am0vz7m3gbj4l2dwlrfz936hpx301gyf";
  };

  # The source tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir $name
    cd $name
    sourceRoot=.
  '';

  buildInputs = [
    bash
    steam-run
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/steamcmd/linux32
    install -Dm755 steamcmd.sh $out/share/steamcmd/steamcmd.sh
    install -Dm755 linux32/* $out/share/steamcmd/linux32

    mkdir -p $out/bin
    substitute ${./steamcmd.sh} $out/bin/steamcmd \
      --subst-var out \
      --subst-var-by coreutils ${coreutils} \
      --subst-var-by steamRoot "${steamRoot}" \
      --subst-var-by steamRun ${steam-run}
    chmod 0755 $out/bin/steamcmd
  '';

  meta = with lib; {
    description = "Steam command-line tools";
    homepage = "https://developer.valvesoftware.com/wiki/SteamCMD";
    platforms = platforms.linux;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ tadfisher ];
  };
}
