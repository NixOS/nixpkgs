{ lib, python3Packages, fetchPypi, withTwitter ? false}:

python3Packages.buildPythonApplication rec {
  pname = "mailman-rss";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1brrik70jyagxa9l0cfmlxvqpilwj1q655bphxnvjxyganxf4c00";
  };

  propagatedBuildInputs = with python3Packages; [ python-dateutil future requests beautifulsoup4 ]
    ++ lib.optional withTwitter python3Packages.twitter
  ;

  # No tests in Pypi Tarball
  doCheck = false;

  meta = with lib; {
    description = "Mailman archive -> rss converter";
    homepage = "https://github.com/kyamagu/mailman-rss";
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
    mainProgram = "mailman-rss";
  };
}
