{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rmfuse";
  version = "unstable-2021-06-06";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rschroll";
    repo = "rmfuse";
    rev = "3796b8610c8a965a60a417fc0bf8ea5200b71fd2";
    hash = "sha256-W3kS6Kkmp8iWMOYFL7r1GyjSQvFotBXQCuTMK0vyHQ8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'bidict = "^' 'bidict = ">=' \
      --replace 'xdg = "^5.0.1"' 'xdg-base-dirs = "^6.0.0"'
    substituteInPlace rmfuse/config.py \
      --replace 'from xdg import' 'from xdg_base_dirs import'
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bidict
    rmrl
    rmcl
    pyfuse3
    xdg-base-dirs
  ];

  meta = {
    description = "FUSE access to the reMarkable Cloud";
    homepage = "https://github.com/rschroll/rmfuse";
    license = lib.licenses.mit;
    longDescription = ''
      RMfuse provides access to your reMarkable Cloud files in the form of a
      FUSE filesystem. These files are exposed either in their original format,
      or as PDF files that contain your annotations. This lets you manage files
      in the reMarkable Cloud using the same tools you use on your local
      system.
    '';
    maintainers = with lib.maintainers; [ adisbladis ];
  };
}
