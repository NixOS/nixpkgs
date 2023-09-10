{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, rustPlatform
, bitstring
, cachetools
, cffi
, deprecation
, iconv
, matplotlib
, numpy
, scipy
, screed
, hypothesis
, pytest-xdist
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sourmash";
  version = "4.8.3";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LIMpL9cLafytRFyPam/FBNi757j1v6o1FG/K2JknDQY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-mcJzFRYkdxuqqXH+ryg5v+9tQtuN1hkEeW2DF+wEJ/w=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
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
    homepage = "https://sourmash.bio";
    changelog = "https://github.com/sourmash-bio/sourmash/releases/tag/v${version}";
    maintainers = with maintainers; [ luizirber ];
    license = licenses.bsd3;
  };
}
