{ stdenv
, lib
, buildPythonApplication
, fetchFromGitHub
, setuptools_scm
, vdf
, wine
, winetricks
, zenity
, pytest
}:

buildPythonApplication rec {
  pname = "protontricks";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = pname;
    rev = version;
    sha256 = "0ri4phi1rna9snrxa6gl23walyack09mgax7zpjqfpxivwls3ach";
  };

  # Fix interpreter in mock run.sh for tests
  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace '#!/bin/bash' '#!${stdenv.shell}' \
  '';

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  nativeBuildInputs = [ setuptools_scm ];
  requiredPythonModules = [ vdf ];

  # The wine install shipped with Proton must run under steam's
  # chrootenv, but winetricks and zenity break when running under
  # it. See https://github.com/NixOS/nix/issues/902.
  #
  # The current workaround is to use wine from nixpkgs
  makeWrapperArgs = [
    "--set STEAM_RUNTIME 0"
    "--set-default WINE ${wine}/bin/wine"
    "--set-default WINESERVER ${wine}/bin/wineserver"
    "--prefix PATH : ${lib.makeBinPath [ winetricks zenity ]}"
  ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    description = "A simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
