{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pifpaf";
  version = "3.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lmixfUP+pq0RdyXeY6MmUQOx1sMLHqojOKUK1mivbaU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    daiquiri
    fixtures
    jinja2
    pbr
    psutil
    xattr
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = with python3.pkgs; [
    requests
    testtools
  ];

  pythonImportsCheck = [ "pifpaf" ];

  meta = with lib; {
    description = "Suite of tools and fixtures to manage daemons for testing";
    mainProgram = "pifpaf";
    homepage = "https://github.com/jd/pifpaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
