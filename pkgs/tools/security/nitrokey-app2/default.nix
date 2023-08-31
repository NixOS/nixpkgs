{ lib
, fetchFromGitHub
, python3
, version ? "2.1.2"
, hash ? "sha256-VyhIFNXxH/FohgjhBeZXoQYppP7PEz+ei0qzsWz1xhk="
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nitrokey-app2";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    inherit hash;
  };

  nativeBuildInputs = [
    python3.pkgs.flit-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyudev
    pyqt5
    pyqt5-stubs
    qt-material
    pynitrokey
  ];

  meta = with lib; {
    description = "Provides extra functionality for the Nitrokey 3";
    longDescription = ''
       This application allows to manage Nitrokey 3 devices. To manage
       Nitrokey Pro and Nitrokey Storage devices, use the older Nitrokey App.
    '';
    homepage = "https://github.com/Nitrokey/nitrokey-app";
    license = licenses.asl20;
    maintainers = with maintainers; [ mib ];
    mainProgram = "nitrokeyapp";
  };
}
