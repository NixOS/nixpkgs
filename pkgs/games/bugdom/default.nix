{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  IOKit,
  Foundation,
  OpenGL,
  cmake,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "bugdom";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = version;
    hash = "sha256-0c7v5tSqYuqtLOFl4sqD7+naJNqX/wlKHVntkZQGJ8A=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Expects SDL2.framework in specific location, which we don't have
    # Passing this in cmakeFlags doesn't work because the path is hard-coded for Darwin
    substituteInPlace cmake/FindSDL2.cmake \
      --replace 'set(SDL2_LIBRARIES' 'set(SDL2_LIBRARIES "${SDL2}/lib/libSDL2.dylib") #'
    # Expects plutil, which we don't have
    sed -i '/plutil/d' CMakeLists.txt
  '';

  buildInputs =
    [
      SDL2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      IOKit
      Foundation
      OpenGL
    ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    # Expects SDL2.framework in specific location, which we don't have
    "-DSDL2_INCLUDE_DIRS=${SDL2.dev}/include/SDL2"
  ];

  installPhase =
    ''
      runHook preInstall

    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/{bin,Applications}
          mv {,$out/Applications/}Bugdom.app
          makeWrapper $out/{Applications/Bugdom.app/Contents/MacOS,bin}/Bugdom
        ''
      else
        ''
          mkdir -p $out/share/bugdom
          mv Data $out/share/bugdom
          install -Dm755 {.,$out/bin}/Bugdom
          wrapProgram $out/bin/Bugdom --run "cd $out/share/bugdom"
          install -Dm644 $src/packaging/io.jor.bugdom.desktop $out/share/applications/io.jor.bugdom.desktop
          install -Dm644 $src/packaging/io.jor.bugdom.png $out/share/pixmaps/io.jor.bugdom.png
        ''
    )
    + ''

      runHook postInstall
    '';

  meta = with lib; {
    description = "Port of Bugdom, a 1999 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/Bugdom";
    license = with licenses; [ cc-by-sa-40 ];
    maintainers = with maintainers; [ lux ];
    mainProgram = "Bugdom";
    platforms = platforms.unix;
  };
}
