{ lib, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with lib;
with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-4T5FIdnKi35JSm+IoYA2gIBBRV0nN0YLEw9xvDqNcgo=";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ libsepol ];
  propagatedBuildInputs = [ enum34 libselinux networkx ]
    ++ optionals withGraphics [ pyqt5 ];

  nativeCheckInputs = [ tox checkpolicy ];
  preCheck = ''
    export CHECKPOLICY=${checkpolicy}/bin/checkpolicy
  '';

  setupPyBuildFlags = [ "-i" ];

  preBuild = ''
    export SEPOL="${lib.getLib libsepol}/lib/libsepol.a"
  '';

  meta = {
    description = "SELinux Policy Analysis Tools";
    homepage = "https://github.com/SELinuxProject/setools";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
