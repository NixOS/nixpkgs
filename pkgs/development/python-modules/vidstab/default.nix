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
  version = "1.0.1";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31b45fa6c6c726ee05c4e106d95682f17258750d09e2e1c880bbccbf866f323e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy pandas imutils progress matplotlib ];

  # tests not packaged with pypi
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/AdamSpannbauer/python_video_stab;
    description = "Video Stabilization using OpenCV";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
