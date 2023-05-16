{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qt5
}:

python3.pkgs.buildPythonApplication rec {
  pname = "patray";
  version = "0.1.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit version pname;
    sha256 = "0vaapn2p4257m1d5nbnwnh252b7lhl00560gr9pqh2b7xqm1bh6g";
  };

  patchPhase = ''
    sed -i '30i entry_points = { "console_scripts": [ "patray = patray.__main__:main" ] },' setup.py
    sed -i 's/production.txt/production.in/' setup.py
    sed -i '/pyside2/d' requirements/production.in
  '';

  propagatedBuildInputs = with python3.pkgs; [
    pulsectl
    loguru
    cock
    pyside2
  ];

  doCheck = false;

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  postFixup = ''
<<<<<<< HEAD
    wrapQtApp $out/bin/patray --prefix QT_PLUGIN_PATH : ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
  '';

=======
    wrapQtApp $out/bin/patray
  '';



>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Yet another tray pulseaudio frontend";
    homepage = "https://github.com/pohmelie/patray";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
