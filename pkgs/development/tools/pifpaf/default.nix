{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pifpaf";
  version = "3.1.5";
  format = "setuptools";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    testtools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "pifpaf" ];

  meta = with lib; {
    description = "Suite of tools and fixtures to manage daemons for testing";
    homepage = "https://github.com/jd/pifpaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
