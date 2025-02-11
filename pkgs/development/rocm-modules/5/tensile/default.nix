{
  lib,
  stdenv,
  fetchFromGitHub,
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
  writeText,
}:

buildPythonPackage rec {
  pname = "tensile";
  version = "5.7.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "Tensile";
    rev = "rocm-${version}";
    hash = "sha256-CyPGiM/53duJc/oNtOsl6JSsl9uOOYm5R7O6YXaVOm4=";
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

  # TODO: remove this workaround once https://github.com/NixOS/nixpkgs/pull/323869
  # does not cause issues anymore, or at least replace it with a better workaround
  setupHook = writeText "setup-hook" ''
    export TENSILE_ROCM_ASSEMBLER_PATH="${stdenv.cc.cc}/bin/clang++";
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
    broken =
      versions.minor version != versions.minor stdenv.cc.version || versionAtLeast version "6.0.0";
  };
}
