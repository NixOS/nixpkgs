{ appimageTools
, fetchurl
, lib
, xorg
, udev
, wooting-udev-rules
}:

appimageTools.wrapType2 rec {
  pname = "wootility";
  version = "4.5.0";

  src = fetchurl {
    url = "https://s3.eu-west-2.amazonaws.com/wooting-update/wootility-lekker-linux-latest/wootility-lekker-${version}.AppImage";
    sha256 = "sha256-5V1OpQZk234iKXOlpoXCbWPyixXkrWT8KkrGB92lPro=";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiPkgs = extraPkgs;
  extraPkgs =
    pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ ([
      udev
      wooting-udev-rules
      xorg.libxkbfile
    ]);
  extraInstallCommands = "mv $out/bin/{${pname}-${version},${pname}}";

  meta = with lib; {
    homepage = "https://wooting.io/wootility";
    description = "A customization and management software for Wooting keyboards";
    platforms = [ "x86_64-linux" ];
    license = "unknown";
    maintainers = with maintainers; [ davidtwco ];
    mainProgram = "wootility";
  };
}
