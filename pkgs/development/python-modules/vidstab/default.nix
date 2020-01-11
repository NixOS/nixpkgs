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
  version = "1.7.2";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24cb7a25a6ed9a474f4d23c9deecf9163691fcde2559de10897f593ba849266b";
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
