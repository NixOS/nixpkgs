{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libxml2,
  nettle,
  withGTK3 ? !stdenv.hostPlatform.isStatic,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "stoken";
  version = "0.93";

  src = fetchFromGitHub {
    owner = "cernekee";
    repo = "stoken";
    rev = "v${version}";
    hash = "sha256-8N7TXdBu37eXWIKCBdaXVW0pvN094oRWrdlcy9raddI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      libxml2
      nettle
    ]
    ++ lib.optionals withGTK3 [
      gtk3
    ];

  meta = with lib; {
    description = "Software Token for Linux/UNIX";
    homepage = "https://github.com/cernekee/stoken";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
