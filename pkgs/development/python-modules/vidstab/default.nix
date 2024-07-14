{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
  imutils,
  progress,
  matplotlib,
}:

buildPythonPackage rec {
  version = "1.7.4";
  format = "setuptools";
  pname = "vidstab";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hlxKCX4qhSeqi/yWqwvMDSgKiMyT6rzDZTEmj100POE=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    imutils
    progress
    matplotlib
  ];

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
