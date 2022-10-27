{ lib, stdenv, fetchFromGitHub, SDL2, IOKit, Foundation, cmake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "bugdom";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "jorio";
    repo = pname;
    rev = version;
    sha256 = "sha256-pgms2mipW1zol35LVCuU5+7mN7CBiVGFvu1CJ3CrGU0=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Expects SDL2.framework in specific location, which we don't have
    # Passing this in cmakeFlags doesn't work because the path is hard-coded for Darwin
    substituteInPlace cmake/FindSDL2.cmake \
      --replace 'set(SDL2_LIBRARIES' 'set(SDL2_LIBRARIES "${SDL2}/lib/libSDL2.dylib") #'
  '';

  buildInputs = [
    SDL2
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    Foundation
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

  installPhase = ''
    runHook preInstall

  '' + (if stdenv.hostPlatform.isDarwin then ''
    mkdir -p $out/{bin,Applications}
    mv {,$out/Applications/}Bugdom.app
    ln -s $out/{Applications/Bugdom.app/Contents/MacOS,bin}/Bugdom
  '' else ''
    mkdir -p $out/share/bugdom
    mv Data $out/share/bugdom
    install -Dm755 {.,$out/bin}/Bugdom
    wrapProgram $out/bin/Bugdom --run "cd $out/share/bugdom"
  '') + ''

    runHook postInstall
  '';

  meta = with lib; {
    description = "A port of Bugdom, a 1999 Macintosh game by Pangea Software, for modern operating systems";
    homepage = "https://github.com/jorio/Bugdom";
    license = with licenses; [ cc-by-sa-40 ];
    maintainers = with maintainers; [ lux ];
    mainProgram = "Bugdom";
    platforms = platforms.unix;
  };
}
