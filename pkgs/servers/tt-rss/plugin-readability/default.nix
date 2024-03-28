{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-readability";
  version = "unstable-2023-04-02";

  src = fetchgit {
    url    = "https://git.tt-rss.org/fox/ttrss-af-readability.git";
    sha256 = "sha256-Pbwp+s4G+mOwjseiejb0gbHpInc2lvR+sv85sRP/DVg=";
    rev = "cdc97d886cb7085f9c44a1796ee4bbbf57534d06";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -a * $out/
  '';

  meta = with lib; {
    description = "Plugin for TT-RSS to inline article content using Readability";
    license = licenses.gpl3;
    homepage = "https://community.tt-rss.org/";
    maintainers = with maintainers; [ gdamjan ];
    platforms = platforms.all;
  };
}
