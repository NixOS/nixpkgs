{ lib
, python2
}:

python2.pkgs.buildPythonApplication rec {
  pname = "bitbucket-cli";
  version = "0.5.1";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1xmn73x6jirnwfwcdy380ncmkai9f9dhmld6zin01ypbqwgf50fq";
  };

  propagatedBuildInputs = with python2.pkgs; [
    requests
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Bitbucket command line interface";
    homepage = "https://bitbucket.org/zhemao/bitbucket-cli";
    maintainers = with maintainers; [ refnil ];
    license = licenses.bsd2;
  };
}
