{ stdenv, fetchurl, alsaLib, curl, gdk_pixbuf, gcc, glib, gtk3,
  libX11, openssl, ncurses5, SDL, SDL_ttf, unzip, zlib, wrapGAppsHook }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "epsxe-${version}";
  version = "2.0.5";

  src = let
    version2 = concatStrings (splitString "." version);
    platform = "linux" + (optionalString stdenv.is64bit "_x64");
  in fetchurl {
    url = "http://www.epsxe.com/files/ePSXe${version2}${platform}.zip";
    sha256 = if stdenv.is64bit
             then "16fa9qc2xhaz1f6294m0b56s5l86cbmclwm9w3mqnch0yjsrvab0"
             else "1677lclam557kp8jwvchdrk27zfj50fqx2q9i3bcx26d9k61q3kl";
  };

  nativeBuildInputs = [ unzip wrapGAppsHook ];
  sourceRoot = ".";

  buildInputs = [
    alsaLib
    curl
    gdk_pixbuf
    glib
    gtk3
    libX11
    openssl
    ncurses5
    SDL
    SDL_ttf
    stdenv.cc.cc.lib
    zlib
  ];

  dontStrip = true;

  installPhase = ''
    install -D ${if stdenv.is64bit then "epsxe_x64" else "ePSXe"} $out/bin/epsxe
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${makeLibraryPath buildInputs} \
      $out/bin/epsxe
  '';

  meta = {
    homepage = http://epsxe.com/;
    description = "Enhanced PSX (PlayStation 1) emulator";
    license = licenses.unfree;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
