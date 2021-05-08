{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry
, isPy27
, docopt
, easywatch
, jinja2
, pytestCheckHook
, pytest-check
, markdown
}:

buildPythonPackage rec {
  pname = "staticjinja";
  version = "1.0.4";
  format = "pyproject";

  disabled = isPy27; # 0.4.0 drops python2 support

  # No tests in pypi
  src = fetchFromGitHub {
    owner = "staticjinja";
    repo = pname;
    rev = version;
    sha256 = "1saz6f71s693gz9c2k3bq2di2mrkj65mgmfdg86jk0z0zzjk90y1";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    jinja2
    docopt
    easywatch
  ];

  checkInputs = [
    pytestCheckHook
    pytest-check
    markdown
  ];

  # The tests need to find and call the installed staticjinja executable
  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "A library and cli tool that makes it easy to build static sites using Jinja2";
    homepage = "https://staticjinja.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
