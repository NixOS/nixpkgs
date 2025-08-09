{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  imagemagickBig,
  pkg-config,
  withXorg ? true,
  libX11,
  libv4l,
  qtbase,
  qtx11extras,
  wrapQtAppsHook,
  wrapGAppsHook3,
  gtk3,
  xmlto,
  docbook_xsl,
  autoreconfHook,
  dbus,
  enableVideo ? stdenv.hostPlatform.isLinux,
  # The implementation is buggy and produces an error like
  # Name Error (Connection ":1.4380" is not allowed to own the service "org.linuxtv.Zbar" due to security policies in the configuration file)
  # for every scanned code.
  # see https://github.com/mchehab/zbar/issues/104
  enableDbus ? false,
  libintl,
  libiconv,
  bash,
  python3,
  argp-standalone,
}:

stdenv.mkDerivation rec {
  pname = "zbar";
  version = "0.23.93";

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = version;
    sha256 = "sha256-6gOqMsmlYy6TK+iYPIBsCPAk8tYDliZYMYeTOidl4XQ=";
  };

  patches = [
    # Fix build, remove these two patches on a release beyond 0.23.93.
    (fetchpatch {
      name = "variable-pkg-config-path.patch";
      url = "https://github.com/mchehab/zbar/commit/368571ffa1a0f6cc41f708dd0d27f9b6e9409df8.patch";
      hash = "sha256-4VEuGAyR7rcIijPLlh4pzL82ESm99Wb35PV/FbY9H6Y=";
    })
    (fetchpatch {
      name = "qt5-detection-fix.patch";
      url = "https://github.com/mchehab/zbar/commit/a549566ea11eb03622bd4458a1728ffe3f589163.patch";
      hash = "sha256-NY3bAElwNvGP9IR6JxUf62vbjx3hONrqu9pMSqaZcLY=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    xmlto
    autoreconfHook
    docbook_xsl
  ]
  ++ lib.optionals enableVideo [
    wrapGAppsHook3
    wrapQtAppsHook
    qtbase
  ];

  buildInputs = [
    imagemagickBig
    libintl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals enableDbus [
    dbus
  ]
  ++ lib.optionals withXorg [
    libX11
  ]
  ++ lib.optionals enableVideo [
    libv4l
    gtk3
    qtbase
    qtx11extras
  ];

  nativeCheckInputs = [
    bash
    python3
  ];

  checkInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    argp-standalone
  ];

  # fix iconv linking on macOS
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export LDFLAGS="-liconv"
  '';

  # Note: postConfigure instead of postPatch in order to include some
  # autoconf-generated files. The template files for the autogen'd scripts are
  # not chmod +x, so patchShebangs misses them.
  postConfigure = ''
    patchShebangs test
  '';

  # Disable assertions which include -dev QtBase file paths.
  env.NIX_CFLAGS_COMPILE = "-DQT_NO_DEBUG";

  configureFlags = [
    "--without-python"
  ]
  ++ (
    if enableDbus then
      [
        "--with-dbusconfdir=${placeholder "out"}/share"
      ]
    else
      [
        "--without-dbus"
      ]
  )
  ++ (
    if enableVideo then
      [
        "--with-gtk=gtk3"
      ]
    else
      [
        "--disable-video"
        "--without-gtk"
        "--without-qt"
      ]
  );

  doCheck = true;

  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -largp"
  '';

  dontWrapQtApps = true;
  dontWrapGApps = true;

  postFixup = lib.optionalString enableVideo ''
    wrapGApp "$out/bin/zbarcam-gtk"
    wrapQtApp "$out/bin/zbarcam-qt"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bar code reader";
    longDescription = ''
      ZBar is an open source software suite for reading bar codes from various
      sources, such as video streams, image files and raw intensity sensors. It
      supports many popular symbologies (types of bar codes) including
      EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR
      Code.
    '';
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
    homepage = "https://github.com/mchehab/zbar";
    mainProgram = "zbarimg";
  };
}
