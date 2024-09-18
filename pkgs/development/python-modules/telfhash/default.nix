{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  capstone,
  packaging,
  pyelftools,
  tlsh,
  setuptools,
}:
buildPythonPackage rec {
  pname = "telfhash";
  version = "0.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "telfhash";
    rev = "v${version}";
    sha256 = "124zajv43wx9l8rvdvmzcnbh0xpzmbn253pznpbjwvygfx16gq02";
  };

  # The tlsh library's name is just "tlsh"
  postPatch = ''
    substituteInPlace requirements.txt \
       --replace-fail "python-tlsh" "tlsh" \
       --replace-fail "py-tlsh" "tlsh" \
       --replace-fail "nose>=1.3.7" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    capstone
    pyelftools
    tlsh
    packaging
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "telfhash" ];

  meta = with lib; {
    description = "Symbol hash for ELF files";
    mainProgram = "telfhash";
    homepage = "https://github.com/trendmicro/telfhash";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
