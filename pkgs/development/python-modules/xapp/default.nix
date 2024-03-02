{ lib
, fetchFromGitHub
, buildPythonPackage
, python
, meson
, ninja
, psutil
, pygobject3
, gtk3
, gobject-introspection
, xapp
, polkit
, gitUpdater
}:

buildPythonPackage rec {
  pname = "xapp";
  version = "21";

  format = "other";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = "refs/tags/master.mint${version}";
    hash = "sha256-Kvhp+biZ+KK9FYma/8cUEaQCHPKMLjOO909kbyMLQ3o=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  propagatedBuildInputs = [
    psutil
    pygobject3
    gtk3
    gobject-introspection
    xapp
    polkit
  ];

  postPatch = ''
    substituteInPlace "xapp/os.py" --replace "/usr/bin/pkexec" "${polkit}/bin/pkexec"
  '';

  postInstall = ''
    # This is typically set by pipInstallHook/eggInstallHook,
    # so we have to do so manually when using meson.
    # https://github.com/NixOS/nixpkgs/issues/175227
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  doCheck = false;
  pythonImportsCheck = [ "xapp" ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = "^master.*";
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/python-xapp";
    description = "Cross-desktop libraries and common resources for python";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
