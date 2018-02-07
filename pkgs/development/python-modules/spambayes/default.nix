{ buildPythonPackage, isPy3k, fetchPypi, bsddb3, pydns, lockfile }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "spambayes";
  version = "1.1b2";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1542dwdsmkav38cfjlbgf3bzz3z8nk7wzq173ya8ipk7g8g6s64d";
  };

  propagatedBuildInputs = [ bsddb3 pydns lockfile ];

  meta = {
    description = "Statistical anti-spam filter, initially based on the work of Paul Graham";
    homepage = http://spambayes.sourceforge.net/;
  };
}
