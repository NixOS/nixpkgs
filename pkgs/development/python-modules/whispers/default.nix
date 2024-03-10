{ lib
, astroid
, beautifulsoup4
, buildPythonPackage
, crossplane
, fetchFromGitHub
, fetchpatch
, jellyfish
, jproperties
, luhn
, lxml
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adeptex";
    repo = "whispers";
    rev = "refs/tags/${version}";
    hash = "sha256-9vXku8BWJtlf+lmAcQ8a7qTisRNc+xVw0T0Eunc4lt4=";
  };

  patches = [
    # Support astroid > 3, https://github.com/adeptex/whispers/pull/117
    (fetchpatch {
      url = "https://github.com/adeptex/whispers/commit/ff25e81cb3d775e5fb186c2d135b77c27d9ed43a.patch";
      hash = "sha256-jKm7fs04mGUD7MZYAA/3xt01e9knuLun3c3u8PlLebg=";
    })
    (fetchpatch {
      url = "https://github.com/adeptex/whispers/commit/ba6a56dddb12d1cb62f94dd7659ba24fdc4363ee.patch";
      hash = "sha256-eHWnXHT0lzS7BqneMqfvV3w6GfrCiTJ5i+av82J+fpk=";
    })
    (fetchpatch {
      url = "https://github.com/adeptex/whispers/commit/8b7b1593eb86abfc09b3581d463fc7d0e06309dc.patch";
      hash = "sha256-JcRdv5eIyXKWaVqbJZlYqiSieE4z0MKF4dvO/hRBBMs=";
    })
    (fetchpatch {
      url = "https://github.com/adeptex/whispers/commit/71dcb614e4d9e0247afc50cd4214659739f8844e.patch";
      hash = "sha256-7XIFuc8Rf2ValN3BoAJOjSqjgmiOauxCFonMgGljFg0=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    astroid
    beautifulsoup4
    crossplane
    jellyfish
    jproperties
    luhn
    lxml
    pyyaml
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    # Some tests need the binary available in PATH
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [
    "whispers"
  ];

  meta = with lib; {
    description = "Tool to identify hardcoded secrets in static structured text";
    homepage = "https://github.com/adeptex/whispers";
    changelog = "https://github.com/adeptex/whispers/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
