{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, imutils
, progress
, matplotlib
}:

buildPythonPackage rec {
  version = "1.7.4";
  format = "setuptools";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    sha256 = "865c4a097e2a8527aa8bfc96ab0bcc0d280a88cc93eabcc36531268f5d343ce1";
  };

  propagatedBuildInputs = [ numpy pandas imutils progress matplotlib ];

  # tests not packaged with pypi
  doCheck = false;
  pythonImportsCheck = [ "vidstab" ];

  meta = with lib; {
    homepage = "https://github.com/AdamSpannbauer/python_video_stab";
    description = "Video Stabilization using OpenCV";
    license = licenses.mit;
    maintainers = [ ];
  };
}
