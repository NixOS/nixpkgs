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
  version = "0.1.5";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b775652cc4f41812de04bc443ad522c1bdaef456a00c74857e9ebc5d2066e362";
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
