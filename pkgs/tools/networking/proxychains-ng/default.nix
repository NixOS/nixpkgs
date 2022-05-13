{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      url = "https://github.com/rofl0r/proxychains-ng/commit/04023d3811d8ee34b498b429bac7a871045de59c.patch";
      sha256 = "sha256-Xcg2kmAhj/OJn/RKJAxb9MOJNJQY7FXmxEIzQ5dvabo=";
    })
  ];

  installFlags = [
    "install-config"
    "install-zsh-completion"
  ];

  meta = with lib; {
    description = "A preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zenithal ];
    platforms = platforms.linux ++ [ "aarch64-darwin" ];
  };
}
