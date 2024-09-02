{ bash
, fetchFromGitHub
, gawk
, git
, lib
, procps
, stdenvNoCC
, unixtools
, unzip
, wget
, xdotool
, xorg
, yad
, writeShellApplication
}:

stdenvNoCC.mkDerivation {
  pname = "steamtinkerlaunch";
  version = "12.12-unstable-2024-05-03";

  src = fetchFromGitHub {
    owner = "sonic2kk";
    repo = "steamtinkerlaunch";
    rev = "59b421b2f3686120a076909a4a158824cd4ef05e";
    hash = "sha256-CGtSGAm+52t2zFsPJEsm76w+FEHhbOd9NYuerGa31tc=";
  };

  installFlags = [ "PREFIX=\${out}" ];

  postInstall =
    let
      # We (ab)use writeShellApplication to produce a header for a shell script
      # here in order to add the runtimePath to the original script. We cannot
      # wrap here as that always corrupts $0 in bash scripts which STL uses to
      # install its compat tool.
      header = writeShellApplication {
        runtimeInputs = [
          bash
          gawk
          git
          procps
          unixtools.xxd
          unzip
          wget
          xdotool
          xorg.xprop
          xorg.xrandr
          xorg.xwininfo
          yad
        ];
        name = "stl-head";
        text = "";
        bashOptions = [ ];
      };
    in
    ''
      cp $out/bin/steamtinkerlaunch $TMPDIR/steamtinkerlaunch
      install ${lib.getExe header} -T $out/bin/steamtinkerlaunch
      tail -n +2 $TMPDIR/steamtinkerlaunch >> $out/bin/steamtinkerlaunch
    '';

  meta = with lib; {
    description = "Linux wrapper tool for use with the Steam client for custom launch options and 3rd party programs";
    mainProgram = "steamtinkerlaunch";
    homepage = "https://github.com/sonic2kk/steamtinkerlaunch";
    license = licenses.gpl3;
    maintainers = with maintainers; [ urandom surfaceflinger ];
    platforms = lib.platforms.linux;
  };
}
