{
  lib,
  fetchPypi,
  buildPythonPackage,
  stdenv,
  pythonOlder,
  rustPlatform,
  bitstring,
  cachetools,
  cffi,
  deprecation,
  iconv,
  matplotlib,
  numpy,
  scipy,
  screed,
  hypothesis,
  pytest-xdist,
  pyyaml,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "sourmash";
  version = "4.9.4";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KIidEQQeOYgxh1x9F6Nn4+WTewldAGdS5Fx/IwL0Ym0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-/tVuR31T38/xx1+jglSGECAT1GmQEddQp9o6zAqlPyY=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    bindgenHook
  ];

  buildInputs = [ iconv ];

  propagatedBuildInputs = [
    bitstring
    cachetools
    cffi
    deprecation
    matplotlib
    numpy
    scipy
    screed
  ];

  pythonImportsCheck = [ "sourmash" ];
  nativeCheckInputs = [
    hypothesis
    pytest-xdist
    pytestCheckHook
    pyyaml
  ];

  # TODO(luizirber): Working on fixing these upstream
  disabledTests = [
    "test_compare_no_such_file"
    "test_do_sourmash_index_multiscaled_rescale_fail"
    "test_metagenome_kreport_out_fail"
  ];

  meta = with lib; {
    description = "Quickly search, compare, and analyze genomic and metagenomic data sets";
    mainProgram = "sourmash";
    homepage = "https://sourmash.bio";
    changelog = "https://github.com/sourmash-bio/sourmash/releases/tag/v${version}";
    maintainers = with maintainers; [ luizirber ];
    license = licenses.bsd3;
  };
}
