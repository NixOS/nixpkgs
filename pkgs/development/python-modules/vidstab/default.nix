{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, imutils
, progress
, matplotlib
, pytest
}:

buildPythonPackage rec {
  version = "1.7.3";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "649a77a0c1b670d13a1bf411451945d7da439364dc0c33ee3636a23f1d82b456";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy pandas imutils progress matplotlib ];

  # tests not packaged with pypi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/AdamSpannbauer/python_video_stab";
    description = "Video Stabilization using OpenCV";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
