{ appimageTools
, fetchurl
, lib
, gsettings-desktop-schemas
, gtk3
, libxkbfile
, udev
, wooting-udev-rules
}:
let
  pname = "wootility";
  version = "3.5.12";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://s3.eu-west-2.amazonaws.com/wooting-update/wootility-linux-latest/wootility-${version}.AppImage";
    sha256 = "13bhckk25fzq9r9cdsg3yqjd4kn47asqdx8kw0in8iky4ri41vnc";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
  '';

  multiPkgs = extraPkgs;
  extraPkgs =
    pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ ([
      udev
      wooting-udev-rules
      libxkbfile
    ]);
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    homepage = "https://wooting.io/wootility";
    description = "A customization and management software for Wooting keyboards";
    platforms = [ "x86_64-linux" ];
    license = "unknown";
    maintainers = with maintainers; [ davidtwco ];
  };
}
