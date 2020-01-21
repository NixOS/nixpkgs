{ stdenv, lib, buildPythonApplication, fetchFromGitHub
, vdf, wine, winetricks, zenity
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    sha256 = "0snhm9r5igik030iqxm3zd9zvhlnsxi20zac71bbc29qflsi2dhk";
  };

  propagatedBuildInputs = [ vdf ];

  # The wine install shipped with Proton must run under steam's
  # chrootenv, but winetricks and zenity break when running under
  # it. See https://github.com/NixOS/nix/issues/902.
  #
  # The current workaround is to use wine from nixpkgs
  makeWrapperArgs = [
    "--set STEAM_RUNTIME 0"
    "--set-default WINE ${wine}/bin/wine"
    "--set-default WINESERVER ${wine}/bin/wineserver"
    "--prefix PATH : ${lib.makeBinPath [
      (winetricks.override { inherit wine; })
      zenity
    ]}"
  ];

  meta = with stdenv.lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = https://github.com/Matoking/protontricks;
    license = licenses.gpl3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ metadark ];
  };
}
