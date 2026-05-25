{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
  imutils,
  progress,
  matplotlib,
  setuptools,
}:

buildPythonPackage rec {
  version = "1.7.4";
  pname = "vidstab";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "865c4a097e2a8527aa8bfc96ab0bcc0d280a88cc93eabcc36531268f5d343ce1";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    imutils
    progress
    matplotlib
  ];

  # tests not packaged with pypi
  doCheck = false;
  pythonImportsCheck = [ "vidstab" ];

  meta = {
    homepage = "https://github.com/AdamSpannbauer/python_video_stab";
    description = "Video Stabilization using OpenCV";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
