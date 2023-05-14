{ lib, fetchFromGitHub, buildPythonPackage, pytestCheckHook, pytest-cov, pytest-mock, fake-useragent, faker, scrapy }:

buildPythonPackage rec {
  pname = "scrapy-fake-useragent";
  version = "1.4.4";

  # PyPi tarball is corrupted
  src = fetchFromGitHub {
    owner = "alecxe";
    repo = pname;
    rev = "59c20d38c58c76618164760d546aa5b989a79b8b"; # no tags
    sha256 = "0yb7d51jws665rdfqkmi077w0pjxmb2ni7ysphj7lx7b18whq54j";
  };

  propagatedBuildInputs = [ fake-useragent faker ];

  nativeCheckInputs = [ pytestCheckHook scrapy pytest-cov pytest-mock ];

  meta = with lib; {
    description = "Random User-Agent middleware based on fake-useragent";
    homepage = "https://github.com/alecxe/scrapy-fake-useragent";
    license = licenses.mit;
  };
}
