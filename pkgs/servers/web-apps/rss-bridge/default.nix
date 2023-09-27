{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rss-bridge";
  version = "2023-09-24";

  src = fetchFromGitHub {
    owner = "RSS-Bridge";
    repo = "rss-bridge";
    rev = version;
    sha256 = "sha256-N1pbveOgJrB1M+WelKD07Jmv9Vz5NqT+IJf//L8UEnU=";
  };

  postPatch = ''
    substituteInPlace lib/RssBridge.php \
        --replace "__DIR__ . '/../config.ini.php'" "getenv('RSSBRIDGE_DATA') . '/config.ini.php'"
    substituteInPlace lib/bootstrap.php \
        --replace "const PATH_CACHE = __DIR__ . '/../cache/';" "define('PATH_CACHE', getenv('RSSBRIDGE_DATA') . '/cache/');"
    substituteInPlace lib/Configuration.php \
        --replace "__DIR__ . '/../whitelist.txt'" "getenv('RSSBRIDGE_DATA') . '/whitelist.txt'"
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
