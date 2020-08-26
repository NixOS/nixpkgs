{ stdenv, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with stdenv.lib;
with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = pname;
    rev = version;
    sha256 = "0vr20bi8w147z5lclqz1l0j1b34137zg2r04pkafkgqqk7qbyjk6";
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
    homepage = "https://github.com/SELinuxProject/setools";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
