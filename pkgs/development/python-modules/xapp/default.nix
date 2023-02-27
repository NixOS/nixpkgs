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
}:

buildPythonPackage rec {
  pname = "xapp";
  version = "2.4.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "python-xapp";
    rev = version;
    hash = "sha256-qEK71cGNGmaThxlFVsfnLUTD83RTr8GP+501c4UbHCk=";
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

  meta = with lib; {
    homepage = "https://github.com/linuxmint/python-xapp";
    description = "Cross-desktop libraries and common resources for python";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
