{ stdenv, fetchFromGitHub, bison, flex, python3 , swig
, libsepol, libselinux, checkpolicy
, withGraphics ? false
}:

with stdenv.lib;
with python3.pkgs;

buildPythonApplication rec {
  pname = "setools";
  version = "2017-11-10";

  src = fetchFromGitHub {
    owner = "TresysTechnology";
    repo = pname;
    rev = "a1aa0f33f5c428d3f9fe82960ed5de36f38047f7";
    sha256 = "0iyj35fff93cprjkzbkg9dn5xz8dg5h2kjx3476fl625nxxskndn";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol swig ];
  propagatedBuildInputs = [ enum34 libselinux networkx ]
    ++ optionals withGraphics [ pyqt5 ];

  checkInputs = [ tox checkpolicy ];
  preCheck = ''
    export CHECKPOLICY=${checkpolicy}/bin/checkpolicy
  '';

  setupPyBuildFlags = [ "-i" ];

  preBuild = ''
    export SEPOL="${libsepol}/lib/libsepol.a"
  '';

  meta = {
    description = "SELinux Tools";
    homepage = https://github.com/TresysTechnology/setools/wiki;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
