{ config, lib, pkgs, fetchFromGitHub, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "rss-bridge";
  version = "2020-02-26";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = version;
    sha256 = "075k4bylx9308d083ry5a9q4629ccnrnndqqdqp1g42rzlqrw79q";
  };

  patchPhase = ''
    substituteInPlace lib/rssbridge.php \
      --replace "define('PATH_CACHE', PATH_ROOT . 'cache/');" "define('PATH_CACHE', getenv('RSSBRIDGE_DATA') . '/cache/');" \
      --replace "define('FILE_CONFIG', PATH_ROOT . 'config.ini.php');" "define('FILE_CONFIG', getenv('RSSBRIDGE_DATA') . '/config.ini.php');" \
      --replace "define('WHITELIST', PATH_ROOT . 'whitelist.txt');" "define('WHITELIST', getenv('RSSBRIDGE_DATA') . '/whitelist.txt');"
  '';

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  meta = with lib; {
    description = "The RSS feed for websites missing it";
    homepage = "https://github.com/RSS-Bridge/rss-bridge";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dawidsowa ];
    platforms = platforms.all;
  };
}
