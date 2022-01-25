{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "proxychains-ng";
  version = "4.16";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uu/zN6W0ue526/3a9QeYg6J4HLaovZJVOYXksjouYok=";
  };

  meta = with lib; {
    description = "A preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zenithal ];
    platforms = platforms.linux ++ [ "aarch64-darwin" ];
  };
}
