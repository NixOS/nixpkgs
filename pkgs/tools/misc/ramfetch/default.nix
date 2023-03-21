{ lib
, stdenv
, fetchgit
}:

stdenv.mkDerivation rec {
  name = "ramfetch";
  version = "1.1.0";

  src = fetchgit {
    url = "https://codeberg.org/o69mar/ramfetch.git";
    rev = "v${version}";
    hash = "sha256-XUph+rTbw5LXWRq+OSKl0EjFac+MQAx3NBu4rWdWR3w=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D ramfetch $out/bin/ramfetch

    runHook postInstall
  '';

  meta = {
    description = "A tool which displays memory information";
    homepage = "https://codeberg.org/o69mar/ramfetch";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.markbeep ];
  };
}
