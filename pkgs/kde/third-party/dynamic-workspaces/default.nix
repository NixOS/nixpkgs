{
  lib,
  stdenv,
  fetchFromGitHub,
  kpackage,
  kwin,
}:

stdenv.mkDerivation {
  pname = "dynamic-workspaces";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "d86leader";
    repo = "dynamic_workspaces";
    # 3.2 was released on KDE Store but not tagged.
    rev = "a06e723804398d672be74eba0cd4ccee062e1410";
    hash = "sha256-fOxWVj6bB5nBiPXvVvjwc3MVjKWaOniqPe7UnsPsusE=";
  };

  nativeBuildInputs = [
    kpackage
  ];

  buildInputs = [
    kwin
  ];

  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    kpackagetool6 --type KWin/Script --install $src --packageroot $out/share/kwin/scripts

    runHook postInstall
  '';

  meta = {
    description = "KWin script that automatically adds/removes virtual desktops";
    homepage = "https://github.com/maurges/dynamic_workspaces";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
