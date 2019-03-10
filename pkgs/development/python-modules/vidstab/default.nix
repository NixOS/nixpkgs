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
  version = "1.5.6";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b488aed337855ac8b3730f7c6964c2ad41111a8f61ab0b457197696feefa593";
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
