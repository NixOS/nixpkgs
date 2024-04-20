{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, buildPythonPackage
, pytestCheckHook
, setuptools
, pyyaml
, msgpack
, pandas
, joblib
, filelock
, rocminfo
}:

buildPythonPackage rec {
  pname = "tensile";
  version = "6.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "Tensile";
    rev = "rocm-${version}";
    hash = "sha256-B9/2Iw1chwDL6it1CKC8W8v4Qac/J2z9nwlpwjnllDc=";
  };

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    msgpack
    pandas
    joblib
  ];

  doCheck = false; # Too many errors, not sure how to set this up properly

  nativeCheckInputs = [
    pytestCheckHook
    filelock
    rocminfo
  ];

  preCheck = ''
    export ROCM_PATH=${rocminfo}
  '';

  pythonImportsCheck = [ "Tensile" ];

  passthru.updateScript = rocmUpdateScript {
    name = pname;
    owner = src.owner;
    repo = src.repo;
  };

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCm/Tensile";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor version != versions.minor stdenv.cc.version || versionAtLeast version "7.0.0";
  };
}
