{ stdenv, fetchFromGitHub, bison, flex, python3 , swig
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with stdenv.lib;
with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = version;
    sha256 = "1bjwcvr6rjx79cdcvaxn68bdrnl4f2a8gnnqsngdxhkhwpddksjy";
  };

  nativeBuildInputs = [ bison flex swig ];
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
