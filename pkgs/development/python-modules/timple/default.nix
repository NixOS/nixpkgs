{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, matplotlib
, numpy
, pytestCheckHook
, pandas
}:

buildPythonPackage rec {
  pname = "timple";
  version = "0.1.6";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "Timple";
    rev = "v${version}";
    hash = "sha256-9JcbxCl/N4Ak9gaB/YNleP01ayXcrmk8jy36IzqP9+E=";
  };

  propagatedBuildInputs = [ matplotlib numpy ];

  pythonImportsCheck = [ "timple" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ pandas ];

  disabledTests = [
    # `baseline_images` directory for tests not included with `matplotlib` install.
    "test_mpl_default_functionality"
  ] ++ lib.optionals stdenv.isDarwin [
    # "91889 Trace/BPT trap: 5" on `aarch64-darwin`
    # "92311 Illegal instruction: 4" on `x86_64-darwin`.
    "test_auto_timedelta_formatter"
    "test_concise_timedelta_formatter"
    "test_plot_pandas_nat"
    "test_timdelta_formatter"
  ];


  meta = with lib; {
    description = "Extended functionality for plotting timedelta-like values with Matplotlib";
    homepage = "https://github.com/theOehrly/Timple";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
