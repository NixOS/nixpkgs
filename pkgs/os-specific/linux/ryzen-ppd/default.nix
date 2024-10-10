{
  lib,
  python3Packages,
  fetchPypi,
  fetchFromGitHub,
  ryzenadj,
  dbus,
  upower,
  gobject-introspection,
  wrapGAppsNoGuiHook,
}:

python3Packages.buildPythonPackage rec {
  pname = "ryzen-ppd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xsmile";
    repo = "ryzen-ppd";
    rev = "${version}";
    sha256 = "sha256-ZXQ1lsJ+HPAlttIwWr0ACsUbwIKo1psz1rhxO8S70fw=";
  };

  propagatedBuildInputs = [
    ryzenadj
    dbus
    upower
    python3Packages.distutils
    python3Packages.pygobject3
    python3Packages.dbus-next
  ];

  buildInputs = [
    gobject-introspection
    wrapGAppsNoGuiHook
  ];

  makeWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${ryzenadj}/lib" ];

  pipInstallFlags = [ "--install-option='--optimize=1'" ];

  meta = with lib; {
    description = "Power Profiles Daemon Driver for AMD Ryzen";
    homepage = "https://github.com/xsmile/ryzen-ppd";
    license = licenses.gpl3;
    maintainers = with maintainers; [ SohamG ];
  };
}
