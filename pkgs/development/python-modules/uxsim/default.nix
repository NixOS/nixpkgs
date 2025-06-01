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
  version = "1.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "toruseo";
    repo = "UXsim";
    tag = "v${version}";
    hash = "sha256-YkH4ODdk8BUTMIcAk9jTFYSHdhD31B6kc4J9sxhRiZg=";
  };

  patches = [ ./add-qt-plugin-path-to-env.patch ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Vehicular traffic flow simulator in road network, written in pure Python";
    homepage = "https://github.com/toruseo/UXsim";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
