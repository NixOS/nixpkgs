{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libGL,
  libSM,
  SDL,
  SDL_image,
  SDL_ttf,
  glew,
  openalSoft,
  ncurses,
  glib,
  gtk2,
  gtk3,
  libsndfile,
  zlib,
  dfVersion,
  pkg-config,
}:

let
  inherit (lib)
    getAttr
    hasAttr
    licenses
    maintainers
    platforms
    versionOlder
    ;

  unfuck-releases = {
    "0.43.05" = {
      unfuckRelease = "0.43.05";
      hash = "sha256-4iLVrKmlVdvBICb8NLe/U7pHtL372CGDkxt/2lf2bZw=";
    };
    "0.44.05" = {
      unfuckRelease = "0.44.05";
      hash = "sha256-iwR9st4VsPJBn7cKH/cy8YS6Tcw8J+lMJK9/9Qgl0gM=";
    };
    "0.44.09" = {
      unfuckRelease = "0.44.09";
      hash = "sha256-9W9qON0QEjfXe2XzRvseixc+YznPzDQdcId08dEGF40=";
    };
    "0.44.10" = {
      unfuckRelease = "0.44.10";
      hash = "sha256-8ldEFcf5zPRdC/yXgMByeCC0pqZprreITIetKDpOYW0=";
    };
    "0.44.11" = {
      unfuckRelease = "0.44.11.1";
      hash = "sha256-f9vDe3Q3Vl2hFLCPSzYtqyv9rLKBKEnARZTu0MKaX88=";
    };
    "0.44.12" = {
      unfuckRelease = "0.44.12";
      hash = "sha256-f9vDe3Q3Vl2hFLCPSzYtqyv9rLKBKEnARZTu0MKaX88=";
    };
    "0.47.01" = {
      unfuckRelease = "0.47.01";
      hash = "sha256-k8yrcJVHlHNlmOL2kEPTftSfx4mXO35TcS0zAvFYu4c=";
    };
    "0.47.02" = {
      unfuckRelease = "0.47.01";
      hash = "sha256-k8yrcJVHlHNlmOL2kEPTftSfx4mXO35TcS0zAvFYu4c=";
    };
    "0.47.04" = {
      unfuckRelease = "0.47.04";
      hash = "sha256-KRr0A/2zANAOSDeP8V9tYe7tVO2jBLzU+TF6vTpISfE=";
    };
    "0.47.05" = {
      unfuckRelease = "0.47.05-final";
      hash = "sha256-kBdzU6KDpODOBP9XHM7lQRIEWUGOj838vXF1FbSr0Xw=";
    };
  };

  release =
    if hasAttr dfVersion unfuck-releases then
      getAttr dfVersion unfuck-releases
    else
      throw "[unfuck] Unknown Dwarf Fortress version: ${dfVersion}";
in

stdenv.mkDerivation {
  pname = "dwarf_fortress_unfuck";
  version = release.unfuckRelease;

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dwarf_fortress_unfuck";
    rev = release.unfuckRelease;
    inherit (release) hash;
  };

  patches = lib.optionals (versionOlder release.unfuckRelease "0.47.05") [
    (fetchpatch {
      name = "fix-noreturn-returning.patch";
      url = "https://github.com/svenstaro/dwarf_fortress_unfuck/commit/6dcfe5ae869fddd51940c6c37a95f7bc639f4389.patch";
      hash = "sha256-b9eI3iR7dmFqCrktPyn6QJ9U2A/7LvfYRS+vE3BOaqk=";
    })
  ];

  postPatch = ''
    # https://github.com/svenstaro/dwarf_fortress_unfuck/pull/27
    substituteInPlace CMakeLists.txt --replace \''${GLEW_LIBRARIES} GLEW::glew
  '';

  cmakeFlags = [
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      libSM
      SDL
      SDL_image
      SDL_ttf
      glew
      openalSoft
      ncurses
      libsndfile
      zlib
      libGL
    ]
    # switched to gtk3 in 0.47.05
    ++ (
      if versionOlder release.unfuckRelease "0.47.05" then
        [
          gtk2
        ]
      else
        [
          gtk3
        ]
    );

  # Don't strip unused symbols; dfhack hooks into some of them.
  dontStrip = true;

  installPhase = ''
    install -D -m755 ../build/libgraphics.so $out/lib/libgraphics.so
  '';

  # Breaks dfhack because of inlining.
  hardeningDisable = [ "fortify" ];

  passthru = { inherit dfVersion; };

  meta = {
    description = "Unfucked multimedia layer for Dwarf Fortress";
    homepage = "https://github.com/svenstaro/dwarf_fortress_unfuck";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      abbradar
      numinit
    ];
  };
}
