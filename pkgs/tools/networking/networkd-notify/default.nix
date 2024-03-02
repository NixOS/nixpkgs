{ lib
, fetchFromGitLab
, buildPythonApplication
, dbus-python
, pygobject3
, systemd
, wirelesstools
}:

buildPythonApplication rec {
  pname = "networkd-notify";
  version = "unstable-2022-11-29";
  # There is no setup.py, just a single Python script.
  format = "other";

  src = fetchFromGitLab {
    owner = "wavexx";
    repo = pname;
    rev = "c2f3e71076a0f51c097064b1eb2505a361c7cc0e";
    sha256 = "sha256-fanP1EWERT2Jy4OnMo8OMdR9flginYUgMw+XgmDve3o=";
  };

  propagatedBuildInputs = [
    dbus-python
    pygobject3
  ];

  patchPhase = ''
    sed -i \
      -e '/^NETWORKCTL = /c\NETWORKCTL = ["${systemd}/bin/networkctl"]' \
      -e '/^IWCONFIG = /c\IWCONFIG = ["${wirelesstools}/bin/iwconfig"]' \
      networkd-notify
  '';

  dontBuild = true;

  installPhase = ''
    install -D networkd-notify -t "$out/bin/"
    install -D -m0644 networkd-notify.desktop -t "$out/share/applications/"
  '';

  meta = with lib; {
    description = "Desktop notification integration for systemd-networkd";
    homepage = "https://gitlab.com/wavexx/networkd-notify";
    maintainers = with maintainers; [ danc86 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
