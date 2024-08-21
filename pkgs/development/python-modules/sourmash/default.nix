{
  lib,
  fetchPypi,
  buildPythonPackage,
  stdenv,
  pythonOlder,
  overrideSDK,
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
let
  stdenv' = if stdenv.isDarwin then overrideSDK stdenv { darwinMinVersion = "10.14"; } else stdenv;
in
buildPythonPackage rec {
  pname = "sourmash";
  version = "4.8.11";
  pyproject = true;
  disabled = pythonOlder "3.9";

  stdenv = stdenv';

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GganbfRkuSaFd5qqpu0CpXe91zpKsyly6BNFgQNNNL8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-im/TPxnT8c2QbWlzCY60wVwJFRIhSnVW7E4kv6bm0p4=";
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
