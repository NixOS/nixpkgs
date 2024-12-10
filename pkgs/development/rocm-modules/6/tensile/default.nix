{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  pyyaml,
  msgpack,
  pandas,
  joblib,
  filelock,
  rocminfo,
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

  patches = [
    (fetchpatch {
      name = "Extend-Tensile-HIP-ISA-compatibility.patch";
      url = "https://github.com/GZGavinZhao/Tensile/commit/855cb15839849addb0816a6dde45772034a3e41f.patch";
      hash = "sha256-d+fVf/vz+sxGqJ96vuxe0jRMgbC5K6j5FQ5SJ1e3Sl8=";
    })
    (fetchpatch {
      name = "Don-t-copy-file-twice-in-copyStaticFiles.patch";
      url = "https://github.com/GZGavinZhao/Tensile/commit/9e14d5a00a096bddac605910a0e4dfb4c35bb0d5.patch";
      hash = "sha256-gOzjJyD1K056OFQ+hK5nbUeBhxLTIgQLoT+0K12SypI=";
    })
  ];

  doCheck = false; # Too many errors, not sure how to set this up properly

  nativeCheckInputs = [
    pytestCheckHook
    filelock
    rocminfo
  ];

  env = {
    ROCM_PATH = rocminfo;
  };

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
    broken =
      versions.minor version != versions.minor stdenv.cc.version || versionAtLeast version "7.0.0";
  };
}
