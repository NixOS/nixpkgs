{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "proxychains-ng";
  version = "4.15";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "128d502y8pn7q2ls6glx9bvibwzfh321sah5r5li6b6iywh2zqlc";
  };

  meta = with lib; {
    description = "A preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zenithal ];
    platforms = platforms.linux;
  };
}
