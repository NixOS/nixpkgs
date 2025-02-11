{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "ubidump";
  version = "0-unstable-2023-09-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nlitsme";
    repo = "ubidump";
    rev = "c8cffcbb8c2d61ebece81dff643b8eccfe6d5642";
    sha256 = "sha256-R568pV3bkdpNAexr8tfAbXVpvHEx/9r1KDWhDM+HyVg=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    setuptools # pkg_resources
    python-lzo
    crcmod
  ];

  meta = with lib; {
    description = "View or extract the contents of UBIFS images";
    homepage = "https://github.com/nlitsme/ubidump";
    license = licenses.mit;
    maintainers = with maintainers; [ sgo ];
    mainProgram = "ubidump";
  };
}
