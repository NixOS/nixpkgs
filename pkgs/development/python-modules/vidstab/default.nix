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

buildPythonPackage (finalAttrs: {
  version = "1.7.4";
  pname = "vidstab";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hlxKCX4qhSeqi/yWqwvMDSgKiMyT6rzDZTEmj100POE=";
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
})
