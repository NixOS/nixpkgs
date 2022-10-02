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
    # zsh completion
    (fetchpatch {
      url = "https://github.com/rofl0r/proxychains-ng/commit/04023d3811d8ee34b498b429bac7a871045de59c.patch";
      sha256 = "sha256-Xcg2kmAhj/OJn/RKJAxb9MOJNJQY7FXmxEIzQ5dvabo=";
    })
    (fetchpatch {
      url = "https://github.com/rofl0r/proxychains-ng/commit/9b42da71f4df7b783cf07a58ffa095e293c43380.patch";
      sha256 = "sha256-tYv9XP51WtsjaoklwQk3D/MQceoOvtdMwBraECt6AXQ=";
    })
  ];

  installFlags = [
    "install-config"
    # TODO: check on next update if that works and remove postInstall
    # "install-zsh-completion"
  ];

  postInstall = ''
    ./tools/install.sh -D -m 644 completions/_proxychains $out/share/zsh/site_functions/_proxychains4
  '';

  meta = with lib; {
    description = "A preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zenithal ];
    platforms = platforms.linux ++ [ "aarch64-darwin" ];
  };
}
