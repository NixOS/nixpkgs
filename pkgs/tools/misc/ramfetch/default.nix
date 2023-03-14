{ lib
, stdenv
, fetchgit
}:

stdenv.mkDerivation {
  name = "ramfetch";
  version = "v1.1.0";

  src = fetchgit {
    url = "https://codeberg.org/o69mar/ramfetch.git";
    rev = "v1.1.0";
    sha256 = "sha256-XUph+rTbw5LXWRq+OSKl0EjFac+MQAx3NBu4rWdWR3w=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    chmod 755 ramfetch
    mv ramfetch $out/bin/ramfetch

    runHook postInstall
  '';

  meta = with lib; {
    description = "ramfetch is a \"fetch\" tool which displays memory info using /proc/meminfo";
    homepage = "https://codeberg.org/o69mar/ramfetch";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.markbeep ];
  };

}
