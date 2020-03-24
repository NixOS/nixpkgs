{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "deezloader-remix";
  version = "4.3.0";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://www.dropbox.com/s/nmznos9sxg72nlf/Deezloader_Remix_4.3.0-x86_64.appimage?dl=0";
    sha256 = "17v3gbliymzsmzjvwhz3z6bz86fpxcfzvnzafnlbrg8ikds3kamc";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.at-spi2-atk p.at-spi2-core ];
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Download songs, playlists and albums directly from Deezer's Server";
    homepage = "https://notabug.org/RemixDevs/DeezloaderRemix";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ luc65r ];
  };
}
