{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # Fix build on aarch64-darwin, should be removed in v4.16
    # https://github.com/rofl0r/proxychains-ng/issues/400
    (fetchpatch {
      url = "https://github.com/rofl0r/proxychains-ng/commit/7de7dd0de1ff387a627620ac3482b4cd9b3fba95.patch?full_index=1";
      sha256 = "sha256-m3a4Jal8L7w+xA0OJTPU68ILTaKgiITgsM1WVxuMce0=";
    })
  ];

  meta = with lib; {
    description = "A preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zenithal ];
    platforms = platforms.linux ++ [ "aarch64-darwin" ];
  };
}
