{ lib, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = version;
    sha256 = "1qvd5j6zwq4fmlahg45swjplhif2z89x7s6pnp07gvcp2fbqdsh5";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ libsepol ];
  propagatedBuildInputs = [ enum34 libselinux networkx ]
    ++ lib.optionals withGraphics [ pyqt5 ];

  checkInputs = [ tox checkpolicy ];
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
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
