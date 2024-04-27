{ appimageTools
, fetchurl
, lib
, xorg
, udev
, wooting-udev-rules
}:

appimageTools.wrapType2 rec {
  pname = "wootility";
  version = "4.6.15";

  src = fetchurl {
    url = "https://s3.eu-west-2.amazonaws.com/wooting-update/wootility-lekker-linux-latest/wootility-lekker-${version}.AppImage";
    sha256 = "sha256-A/cjm9rhcgp68hbyjy7OfYPBKBcccl0OdD7MTdpEdPM=";
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

  meta = with lib; {
    homepage = "https://wooting.io/wootility";
    description = "A customization and management software for Wooting keyboards";
    platforms = [ "x86_64-linux" ];
    license = "unknown";
    maintainers = with maintainers; [ davidtwco ];
    mainProgram = "wootility";
  };
}
