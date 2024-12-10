{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fierce";
  version = "1.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mschwager";
    repo = pname;
    rev = version;
    sha256 = "sha256-9VTPD5i203BTl2nADjq131W9elgnaHNIWGIUuCiYlHg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'dnspython==1.16.0' 'dnspython'
  '';

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "fierce"
  ];

  meta = with lib; {
    description = "DNS reconnaissance tool for locating non-contiguous IP space";
    mainProgram = "fierce";
    homepage = "https://github.com/mschwager/fierce";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
