{ lib
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "quark-engine";
  version = "21.10.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0992wsy3plxpcqmq8cnnl0by1vkmkfb4lq2vb5rsj89wj900ci2n";
  };

  propagatedBuildInputs = with python3.pkgs; [
    androguard
    click
    colorama
    gitMinimal
    graphviz
    pandas
    plotly
    prettytable
    prompt-toolkit
    rzpipe
    tqdm
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "prompt-toolkit==3.0.19" "prompt-toolkit>=3.0.19"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "quark"
  ];

  meta = with lib; {
    description = "Android malware (analysis and scoring) system";
    homepage = "https://quark-engine.readthedocs.io/";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
