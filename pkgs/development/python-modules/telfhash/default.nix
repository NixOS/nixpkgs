{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, packaging
, pyelftools
, tlsh
, nose
}:
buildPythonPackage rec {
  pname = "telfhash";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "telfhash";
    rev = "v${version}";
    sha256 = "124zajv43wx9l8rvdvmzcnbh0xpzmbn253pznpbjwvygfx16gq02";
  };

  # The tlsh library's name is just "tlsh"
  postPatch = ''
    substituteInPlace requirements.txt \
       --replace "python-tlsh" "tlsh" \
       --replace "py-tlsh" "tlsh"
  '';

  propagatedBuildInputs = [
    capstone
    pyelftools
    tlsh
    packaging
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "telfhash"
  ];

  meta = with lib; {
    description = "Symbol hash for ELF files";
    homepage = "https://github.com/trendmicro/telfhash";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
