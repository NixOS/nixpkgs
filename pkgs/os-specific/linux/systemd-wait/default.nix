{ python3Packages, fetchFromGitHub, lib }:

python3Packages.buildPythonApplication rec {
  pname = "systemd-wait";
  version = "0.1+2018-10-05";

  src = fetchFromGitHub {
    owner = "Stebalien";
    repo = pname;
    rev = "bbb58dd4584cc08ad20c3888edb7628f28aee3c7";
    sha256 = "1l8rd0wzf3m7fk0g1c8wc0csdisdfac0filhixpgp0ck9ignayq5";
  };

  propagatedBuildInputs = with python3Packages; [
    dbus-python pygobject3
  ];

  meta = {
    homepage = "https://github.com/Stebalien/systemd-wait";
    license = lib.licenses.gpl3;
    description = "Wait for a systemd unit to enter a specific state";
    mainProgram = "systemd-wait";
    maintainers = [ lib.maintainers.benley ];
    platforms = lib.platforms.linux;
  };
}
