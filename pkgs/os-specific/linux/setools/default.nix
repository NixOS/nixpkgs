{
  lib,
  fetchFromGitHub,
  python3,
  libsepol,
  libselinux,
  checkpolicy,
  withGraphics ? false,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "setools";
  version = "4.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SELinuxProject";
    repo = "setools";
    rev = "refs/tags/${version}";
    hash = "sha256-/6dOzSz2Do4d6TSS50fuak0CysoQ532zJ0bJ532BUCE=";
  };

  build-system = with python3.pkgs; [
    cython
    setuptools
  ];

  buildInputs = [ libsepol ];

  dependencies =
    with python3.pkgs;
    [
      libselinux
      setuptools
    ]
    ++ lib.optionals withGraphics [ pyqt5 ];

  optional-dependencies = {
    analysis = with python3.pkgs; [
      networkx
      pygraphviz
    ];
  };

  nativeCheckInputs = [
    python3.pkgs.tox
    checkpolicy
  ];

  setupPyBuildFlags = [ "-i" ];

  preBuild = ''
    export SEPOL="${lib.getLib libsepol}/lib/libsepol.a"
  '';

  preCheck = ''
    export CHECKPOLICY=${checkpolicy}/bin/checkpolicy
  '';

  meta = with lib; {
    description = "SELinux Policy Analysis Tools";
    homepage = "https://github.com/SELinuxProject/setools";
    changelog = "https://github.com/SELinuxProject/setools/blob/${version}/ChangeLog";
    license = with licenses; [
      gpl2Only
      lgpl21Plus
    ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
