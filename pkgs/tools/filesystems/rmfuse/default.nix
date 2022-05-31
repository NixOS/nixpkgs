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
    sha256 = "03qxy95jpk741b81bd38y51d4a0vynx2y1g662bci9r6m7l14yav";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'bidict = "^' 'bidict = ">='
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bidict
    rmrl
    rmcl
    pyfuse3
    xdg
  ];

  meta = {
    description = "FUSE access to the reMarkable Cloud";
    longDescription = ''
      RMfuse provides access to your reMarkable Cloud files in the form of a FUSE filesystem. These files are exposed either in their original format, or as PDF files that contain your annotations. This lets you manage files in the reMarkable Cloud using the same tools you use on your local system.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/rschroll/rmfuse";
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
