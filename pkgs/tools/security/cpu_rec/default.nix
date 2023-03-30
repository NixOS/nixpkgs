{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "cpu_rec";
  version = "unstable-2021-06-21";

  src = fetchFromGitHub {
    owner = "airbus-seclab";
    repo = "cpu_rec";
    rev = "9cc225db5e027658ad28c6886b6d6a9980cbe69f";
    hash = "sha256-H08YGWH9Ys/6HdeWu6BRFHgxU5Lqq/TP03G40KsBQPs=";
  };

  propagatedBuildInputs = with python3Packages; [ pylzma ];

  preBuild = ''
    cat > setup.py << EOF
from setuptools import setup

setup(
  name='cpu_rec',
  version='0.1.0',
  install_requires=['pylzma'],
  scripts=[
    'cpu_rec.py',
  ],
)
EOF
  '';

  postInstall = ''
    # Unfortunately cpu_rec expects the corpus to be next to the script
    cp -r cpu_rec_corpus $out/bin
    mv $out/bin/cpu_rec.py $out/bin/cpu_rec
  '';

  meta = with lib; {
    homepage = "https://github.com/airbus-seclab/cpu_rec";
    description = "cpu_rec is a tool that recognizes cpu instructions in an arbitrary binary file.";
    license = licenses.asl20;
    maintainers = with maintainers; [ lorenz ];
  };
}
