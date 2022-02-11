{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "steam-fonts";
  version = "1";

  src = fetchurl {
    url = "https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip";
    sha256 = "1cgygmwich5f1jhhbmbkkpnzasjl8gy36xln76n6r2gjh6awqfx0";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -r *.TTF *.ttf $out/share/fonts/truetype
  '';
}
