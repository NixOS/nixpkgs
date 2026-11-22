{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build dependencies
  setuptools,

  # dependencies
  cbor2,
  pyyaml,
  regex,
}:

buildPythonPackage rec {
  pname = "zcbor";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wEkYOS4tuxTG8DjXduLqawnDS6ECiwRardfDqVYWvDg=";
  };

  # https://github.com/nordicsemi/zcbor/pull/668, also fixed in the next upstream release
  patches = [
    (fetchpatch {
      url = "https://github.com/nordicsemi/zcbor/commit/59f5fc0f71153be58fd87071ed9eff7452c86acc.patch";
      excludes = [
        "scripts/requirements-base.txt"
        "tests/*"
      ];
      hash = "sha256-DHbooKWQMvAGdR5E1sC9njMyz2AK7/dt7yhLDjNQ4qE=";
    })
    (fetchpatch {
      url = "https://github.com/nordicsemi/zcbor/commit/e64f102ad4242304aa506e429f724f2816df3045.patch";
      excludes = [
        "scripts/requirements-base.txt"
        "tests/*"
      ];
      hash = "sha256-EPJSmAYjpd9yYiMl+Krm24veVcyvtKNj5SHtMw4D4Cc=";
    })
    (fetchpatch {
      url = "https://github.com/nordicsemi/zcbor/commit/4ec3d244cf3f23825c5e661b0ef1aab2b4012e72.patch";
      excludes = [
        "scripts/requirements-base.txt"
        "tests/*"
      ];
      hash = "sha256-Nz02yCVkr0rYNjI9XbKcXo1zDT4HOREoejANtZVNMIQ=";
    })
    (fetchpatch {
      url = "https://github.com/nordicsemi/zcbor/commit/3d9eae8c28e2341ed4796236f42cc944230344a0.patch";
      excludes = [
        "scripts/requirements-base.txt"
        "tests/*"
      ];
      hash = "sha256-aJcs8GrsAXvlDtalmiUQw5FA2L/YmxwoPeRjzu3aF/s=";
    })
    (fetchpatch {
      url = "https://github.com/nordicsemi/zcbor/commit/b63e811af7847baec7d8a738a14a7f1e9b8db84d.patch";
      excludes = [
        "scripts/requirements-base.txt"
        "tests/*"
      ];
      hash = "sha256-tc7t2jf4QG8HS4azTREO2rewZyVzTjIg7UC5hPs41iE=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cbor2
    pyyaml
    regex
  ];

  pythonImportsCheck = [ "zcbor" ];

  meta = {
    description = "Low footprint CBOR library in the C language (C++ compatible), tailored for use in microcontrollers";
    mainProgram = "zcbor";
    homepage = "https://pypi.org/project/zcbor/";
    changelog = "https://github.com/NordicSemiconductor/zcbor/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
