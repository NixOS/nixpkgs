{ lib, fetchFromGitHub, python3
, libsepol, libselinux, checkpolicy
, fetchpatch
, withGraphics ? false
}:

with lib;
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

  patches = [
    (fetchpatch { # included in 4.4.0
      url = "https://github.com/SELinuxProject/setools/commit/f1b4a5d375be05fbccedb258c940d771bff8e524.diff";
      sha256 = "1r38s6i4i6bdr2zdp5wcg1yifpf3pd018c73a511mgynyg7d11xy";
    })
  ];

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
    export SEPOL="${lib.getLib libsepol}/lib/libsepol.a"
  '';

  meta = {
    description = "SELinux Policy Analysis Tools";
    homepage = "https://github.com/SELinuxProject/setools";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
