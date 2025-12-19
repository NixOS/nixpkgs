{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  wrapQtAppsHook,
  cmake,
  extra-cmake-modules,
  kwin,
  kwin-x11,
  qttools,

  withKwinX11 ? false,
}:

stdenv.mkDerivation rec {
  pname = "kwin-better-blur-dx" + lib.optionalString withKwinX11 "-x11";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "xarblu";
    repo = "kwin-effects-better-blur-dx";
    tag = "v${version}";
    hash = "sha256-e9Al48mFQF8Kefmw8WyhGNTKcXZs51hKJCRAjzhMvTs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qttools
  ]
  ++ lib.optional withKwinX11 kwin-x11
  ++ lib.optional (!withKwinX11) kwin;

  cmakeFlags = lib.optional withKwinX11 "-DBETTERBLUR_X11=on";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Fork of the Plasma 6 blur effect with additional features and bug fixes";
    homepage = "https://github.com/xarblu/kwin-effects-better-blur-dx";
    license = with lib.licenses; [
      gpl2Plus # Some files: https://github.com/search?q=repo%3Axarblu%2Fkwin-effects-better-blur-dx%20SPDX-License-Identifier&type=code
      gpl3Only # Project: https://github.com/xarblu/kwin-effects-better-blur-dx/blob/main/LICENSE
    ];
    maintainers = with lib.maintainers; [ eth-p ];
  };
}
