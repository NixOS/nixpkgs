{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "xcat";
  version = "1.2.0";
  disabled = python3.pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "01r5998gdvqjdrahpk0ci27lx9yghbddlanqcspr3qp5y5930i0s";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    aiohttp
    appdirs
    click
    colorama
    faust-cchardet
    prompt-toolkit
    xpath-expressions
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "xcat" ];

  meta = with lib; {
    description = "XPath injection tool";
    mainProgram = "xcat";
    longDescription = ''
      xcat is an advanced tool for exploiting XPath injection vulnerabilities,
      featuring a comprehensive set of features to read the entire file being
      queried as well as other files on the filesystem, environment variables
      and directories.
    '';
    homepage = "https://github.com/orf/xcat";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
