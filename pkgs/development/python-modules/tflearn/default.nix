{ lib, buildPythonPackage, fetchurl, pytest, scipy, h5py,
pillow, tensorflow }:

buildPythonPackage rec {
  version = "0.3.2";
  name = "tflearn-${version}";

  src = fetchurl {
    url = "mirror://pypi/t/tflearn/${name}.tar.gz";
    sha256 = "034lvbslcivyj64r4w6xmr90ckmyxmrnkka9kal50x4175h02n1z";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ scipy h5py pillow tensorflow ];

  doCheck = false;

  meta = with lib; {
    description = "Deep learning library featuring a higher-level API for TensorFlow";
    homepage    = "https://github.com/tflearn/tflearn";
    license     = licenses.mit;
  };
}
