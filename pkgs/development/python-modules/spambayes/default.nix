{ buildPythonPackage, isPy3k, fetchPypi, bsddb3, pydns, lockfile }:

buildPythonPackage rec {
  pname = "spambayes";
  version = "1.1b3";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "016r3g43ja73rls1nh1dl82d75lgsjdl4cv2r5s7zcihm47nb38q";
  };

  propagatedBuildInputs = [ bsddb3 pydns lockfile ];

  meta = {
    description = "Statistical anti-spam filter, initially based on the work of Paul Graham";
    homepage = http://spambayes.sourceforge.net/;
  };
}
