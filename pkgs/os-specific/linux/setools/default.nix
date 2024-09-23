{ lib, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setools";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/6dOzSz2Do4d6TSS50fuak0CysoQ532zJ0bJ532BUCE=";
  };

  nativeBuildInputs = [ python3.pkgs.cython ];
  buildInputs = [ libsepol ];
  propagatedBuildInputs = with python3.pkgs; [ enum34 libselinux networkx setuptools ]
    ++ lib.optionals withGraphics [ pyqt5 ];

  nativeCheckInputs = [ python3.pkgs.tox checkpolicy ];
  preCheck = ''
    export CHECKPOLICY=${checkpolicy}/bin/checkpolicy
  '';

  setupPyBuildFlags = [ "-i" ];

  preBuild = ''
    export SEPOL="${lib.getLib libsepol}/lib/libsepol.a"
  '';

  meta = with lib; {
    description = "SELinux Policy Analysis Tools";
    homepage = "https://github.com/SELinuxProject/setools";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
