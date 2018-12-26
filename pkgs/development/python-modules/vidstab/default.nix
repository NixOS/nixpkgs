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
  version = "1.0.0";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa7aa196ae40074cc2887f26472d1526d670715ab2dbbc032ca1fb1c68688392";
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
