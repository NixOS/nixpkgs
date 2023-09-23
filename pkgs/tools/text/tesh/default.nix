{ python3Packages, fetchFromGitHub, fetchpatch }:

let
  version = "0.3.0";
in python3Packages.buildPythonPackage rec {
  pname = "tesh";
  inherit version;

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OceanSprint";
    repo = "tesh";
    rev = version;
    hash = "sha256-/CSYz2YXbjKZszb1HMOCS+srVJ+TcFSeLeuz9VvtlI4=";
  };

  patches = [
    # https://github.com/OceanSprint/tesh/pull/49
    (fetchpatch {
      name = "replace-poetry-with-poetry-core-1.patch";
      url = "https://github.com/OceanSprint/tesh/commit/49b90f5a3c9cf111931393248943b1da966dc3ec.patch";
      hash = "sha256-s+eGO4NXTGbyXcLP37kCg4GDrjAsYIlOwNDR1Q7+1Uc=";
    })
    # https://github.com/OceanSprint/tesh/pull/50
    (fetchpatch {
      name = "replace-poetry-with-poetry-core-2.patch";
      url = "https://github.com/OceanSprint/tesh/commit/66798b54f28dc0b72159ee3a2144895cf945eaf0.patch";
      hash = "sha256-f3uL7TZlkrTOWYihwWNfhrY5/xlBrclAMnbxRNXCGJw=";
    })
  ];

  checkInputs = [ python3Packages.pytest ];
  nativeBuildInputs = [ python3Packages.poetry-core ];
  propagatedBuildInputs = with python3Packages; [ click pexpect ];
}
