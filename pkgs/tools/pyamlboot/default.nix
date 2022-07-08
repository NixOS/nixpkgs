{ lib, fetchFromGitHub, pythonPackages
# , libsepol, libselinux, checkpolicy
# , withGraphics ? false
}:

with lib;

pythonPackages.buildPythonApplication rec {
  pname = "pyamlboot-unstable";
  version = "2021-08-17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "superna9999";
    repo = "pyamlboot";
    rev = "ffaaad9503192ece98970b7100a03c54ba58befc";
    sha256 = "sha256-2TD9UtMcxA29p3K6i5+SDSAVDiFhY1050QWx5MHne3s=";
  };

  # nativeBuildInputs = [ cython ];
  # buildInputs = [ libsepol ];
  propagatedBuildInputs = with pythonPackages; [ setuptools pyusb ];

  # checkInputs = [ tox checkpolicy ];
  # preCheck = ''
  #   export CHECKPOLICY=${checkpolicy}/bin/checkpolicy
  # '';

  # setupPyBuildFlags = [ "-i" ];

  # preBuild = ''
  #   export SEPOL="${lib.getLib libsepol}/lib/libsepol.a"
  # '';

  meta = {
    # description = "SELinux Policy Analysis Tools";
    # homepage = "https://github.com/SELinuxProject/setools";
    # license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
