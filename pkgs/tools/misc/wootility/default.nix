{ appimageTools
, fetchurl
, lib
, xorg
, udev
, wooting-udev-rules
}:
<<<<<<< HEAD

appimageTools.wrapType2 rec {
  pname = "wootility";
  version = "4.5.0";

  src = fetchurl {
    url = "https://s3.eu-west-2.amazonaws.com/wooting-update/wootility-lekker-linux-latest/wootility-lekker-${version}.AppImage";
    sha256 = "sha256-5V1OpQZk234iKXOlpoXCbWPyixXkrWT8KkrGB92lPro=";
=======
let
  pname = "wootility";
  version = "3.5.12";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://s3.eu-west-2.amazonaws.com/wooting-update/wootility-linux-latest/wootility-${version}.AppImage";
    sha256 = "13bhckk25fzq9r9cdsg3yqjd4kn47asqdx8kw0in8iky4ri41vnc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  extraInstallCommands = "mv $out/bin/{${pname}-${version},${pname}}";
=======
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://wooting.io/wootility";
    description = "A customization and management software for Wooting keyboards";
    platforms = [ "x86_64-linux" ];
    license = "unknown";
    maintainers = with maintainers; [ davidtwco ];
  };
}
