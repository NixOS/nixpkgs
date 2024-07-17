{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "proxychains-ng";
  version = "4.17";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cHRWPQm6aXsror0z+S2Ddm7w14c1OvEruDublWsvnXs=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/136093
    ./swap-priority-4-and-5-in-get_config_path.patch
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
