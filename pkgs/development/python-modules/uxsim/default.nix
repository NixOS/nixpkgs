{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  qt5,
  python,
  dill,
  matplotlib,
  networkx,
  numpy,
  pandas,
  pillow,
  pyqt5,
  scipy,
  tqdm,
}:
buildPythonPackage rec {
  pname = "uxsim";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "toruseo";
    repo = "UXsim";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-q8L6UkKL+M9zgax6jjxwkFrwayaxMTYJRfWt8Rnj00I=";
=======
    hash = "sha256-GK1tD0STBCR0Z/JHdhrgLun6t2snJqi/oFGUOeiXk6c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [ ./add-qt-plugin-path-to-env.patch ];

  build-system = [ setuptools ];

  dependencies = [
    dill
    matplotlib
    networkx
    numpy
    pandas
    pillow
    pyqt5
    scipy
    tqdm
  ];

  pythonImportsCheck = [ "uxsim" ];

  # QT_PLUGIN_PATH is required to be set for the program to produce its images
  # our patch sets it to $NIX_QT_PLUGIN_PATH if QT_PLUGIN_PATH is not set
  # and here we replace this string with the actual path to qt plugins
  postInstall = ''
    substituteInPlace $out/${python.sitePackages}/uxsim/__init__.py \
      --replace-fail '$NIX_QT_PLUGIN_PATH' '${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}'
  '';

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/toruseo/UXsim/releases/tag/${src.tag}";
    description = "Vehicular traffic flow simulator in road network, written in pure Python";
    homepage = "https://github.com/toruseo/UXsim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
=======
  meta = with lib; {
    changelog = "https://github.com/toruseo/UXsim/releases/tag/${src.tag}";
    description = "Vehicular traffic flow simulator in road network, written in pure Python";
    homepage = "https://github.com/toruseo/UXsim";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
