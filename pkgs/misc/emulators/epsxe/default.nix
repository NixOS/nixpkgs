{ stdenv, fetchurl, alsaLib, curl, gdk-pixbuf, glib, gtk3, libGLU_combined,
  libX11, openssl_1_0_2, ncurses5, SDL, SDL_ttf, unzip, zlib, wrapGAppsHook, autoPatchelfHook }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "epsxe";
  version = "2.0.5";

  src = let
    version2 = concatStrings (splitString "." version);
    platform = "linux" + (optionalString stdenv.is64bit "_x64");
  in fetchurl {
    url = "https://www.epsxe.com/files/ePSXe${version2}${platform}.zip";
    sha256 = if stdenv.is64bit
             then "16fa9qc2xhaz1f6294m0b56s5l86cbmclwm9w3mqnch0yjsrvab0"
             else "1677lclam557kp8jwvchdrk27zfj50fqx2q9i3bcx26d9k61q3kl";
  };

  nativeBuildInputs = [ unzip wrapGAppsHook autoPatchelfHook ];
  sourceRoot = ".";

  buildInputs = [
    alsaLib
    curl
    gdk-pixbuf
    glib
    gtk3
    libX11
    libGLU_combined
    openssl_1_0_2
    ncurses5
    SDL
    SDL_ttf
    stdenv.cc.cc.lib
    zlib
  ];

  dontStrip = true;

  installPhase = ''
    install -D ${if stdenv.is64bit then "epsxe_x64" else "ePSXe"} $out/bin/epsxe
  '';

  meta = {
    homepage = http://epsxe.com/;
    description = "Enhanced PSX (PlayStation 1) emulator";
    license = licenses.unfree;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
