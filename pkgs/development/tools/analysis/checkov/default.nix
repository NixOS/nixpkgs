{ pkgs, lib, python3, fetchFromGitHub }:

let
  pname = "checkov";
  version = "1.0.674";
  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = pname;
    rev = version;
    sha256 = "/S8ic5ZVxA2vd/rjRPX5gslbmnULL7BSx34vgWIsheQ=";
  };

  disabled = pkgs.python3Packages.pythonOlder "3.7";

  # CheckOV only work with `dpath 1.5.0`
  dpath = pkgs.python3Packages.buildPythonPackage rec {
    pname = "dpath";
    version = "1.5.0";

    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "SWYVtOqEI20Y4NKGEi3nSGmmDg+H4sfsZ4f/KGxINhs=";
    };

    doCheck = false;
  };
in
python3.pkgs.buildPythonPackage rec {
  inherit pname version disabled src;

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
    pytest
    coverage
    bandit
    bc-python-hcl2
    deep_merge
    tabulate
    colorama
    termcolor
    junit-xml
    dpath
    pyyaml
    boto3
    GitPython
    six
    jmespath
    tqdm
    update_checker
    semantic-version
    packaging
  ];

  # Both of these tests are pulling from external srouces (https://github.com/bridgecrewio/checkov/blob/f03a4204d291cf47e3753a02a9b8c8d805bbd1be/.github/workflows/build.yml)
  preCheck = ''
    rm -rf integration_tests/*
    rm -rf tests/terraform/*
  '';

  # Wrap the executable so that the python packages are available
  # it's just a shebang script which calls `python -m checkov "$@"`
  postFixup = ''
    wrapProgram $out/bin/checkov \
      --set PYTHONPATH $PYTHONPATH
  '';

  meta = with lib; {
    homepage = "https://github.com/bridgecrewio/checkov";
    description = "Static code analysis tool for infrastructure-as-code";
    longDescription = ''
    Prevent cloud misconfigurations during build-time for Terraform, Cloudformation, Kubernetes, Serverless framework and other infrastructure-as-code-languages with Checkov by Bridgecrew.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ anhdle14 ];
  };
}
