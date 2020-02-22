{ stdenv, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with stdenv.lib;
with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = version;
    sha256 = "18kklv26dwm2fdjjzfflvxsq83b2svnwf4g18xq7wsfsri121a90";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ libsepol ];
  propagatedBuildInputs = [ enum34 libselinux networkx ]
    ++ optionals withGraphics [ pyqt5 ];

  checkInputs = [ tox checkpolicy ];
  preCheck = ''
    export CHECKPOLICY=${checkpolicy}/bin/checkpolicy
  '';

  setupPyBuildFlags = [ "-i" ];

  preBuild = ''
    export SEPOL="${stdenv.lib.getLib libsepol}/lib/libsepol.a"
  '';

  meta = {
    description = "SELinux Policy Analysis Tools";
    homepage = https://github.com/SELinuxProject/setools;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
