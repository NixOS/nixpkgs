{ buildPythonPackage, fetchPypi, lib
, click, docker-py, pip, pyyaml, retrying, requests
, scrapinghub, tqdm, six, tox, pytest
}:

buildPythonPackage rec {
  pname = "shub";
  version = "2.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10v8hh21jjc16hhsjzcxqmjpysz5ans7pm5pcxizj6029mjkm3ix";
  };

  propagatedBuildInputs = [
    click
    docker-py
    pip
    pyyaml
    retrying
    requests
    scrapinghub
    tqdm
    six
  ];

  # Tests complain about homeless shelter due to the library looking
  # for the configuration file .scrapinghub.yml in the home
  doCheck = false;

  meta = with lib; {
    description = "The Scrapinghub command line client. It allows you to deploy projects or dependencies, schedule spiders, and retrieve scraped data or logs without leaving the command line";
    license = licenses.mit;
    homepage = http://shub.readthedocs.io/;
    maintainers = with maintainers; [ mredaelli ];
  };

}
