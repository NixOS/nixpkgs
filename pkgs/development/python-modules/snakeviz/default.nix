{ stdenv, fetchurl, buildPythonPackage, tornado }:

buildPythonPackage rec {
  pname = "snakeviz";
  name = "${pname}-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://pypi/s/snakeviz/${name}.tar.gz";
    sha256 = "18vsaw1wmf903fg21zkk6a9b49gj47g52jm5h52g4iygngjhpx79";
  };

  # Upstream doesn't run tests from setup.py
  doCheck = false;
  propagatedBuildInputs = [ tornado ];

  meta = with stdenv.lib; {
    description = "Browser based viewer for profiling data";
    homepage = "https://jiffyclub.github.io/snakeviz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
