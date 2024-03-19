{ lib, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with lib;
with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "4.4.4";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QCJfFdY4THBurx7G8q/WAzb7b9CwtNNGi5fn9D++BMU=";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ libsepol ];
  propagatedBuildInputs = [ enum34 libselinux networkx setuptools ]
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
