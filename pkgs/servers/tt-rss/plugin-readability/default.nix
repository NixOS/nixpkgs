{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-readability";
  version = "unstable-2024-04-03";

  src = fetchgit {
    url    = "https://git.tt-rss.org/fox/ttrss-af-readability.git";
    sha256 = "sha256-pLNNb3iAx8H4KtH7ODyqlkiZeA35w5F6PLQoN4kHFgM=";
    rev = "f2169ca419be339fa5ba32d0a50770f3d442d8b7";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/af_readability/
    cp -a * $out/af_readability/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Plugin for TT-RSS to inline article content using Readability";
    license = licenses.gpl3Plus;
    homepage = "https://community.tt-rss.org/";
    maintainers = with maintainers; [ gdamjan lunik1 ];
    platforms = platforms.all;
  };
}
