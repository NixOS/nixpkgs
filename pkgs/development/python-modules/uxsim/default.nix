{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  qt5,
  hackgen-font,
  python3,
  matplotlib,
  numpy,
  pandas,
  pillow,
  pyqt5,
  scipy,
  tqdm,
}:
buildPythonPackage rec {
  pname = "uxsim";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "toruseo";
    repo = "UXsim";
    rev = "v${version}";
    hash = "sha256-qPAFodvx+Z7RsRhzdTq1TRsbvrUFaqRJZxYg3FM6q8A=";
  };

  patches = [
    ./add-qt-plugin-path-to-env.patch
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    pillow
    pyqt5
    scipy
    tqdm
  ];

  pythonImportsCheck = ["uxsim"];


  # QT_PLUGIN_PATH is required to be set for the program to produce its images
  # our patch sets it to $NIX_QT_PLUGIN_PATH if QT_PLUGIN_PATH is not set
  # and here we replace this string with the actual path to qt plugins
  postInstall = ''
    substituteInPlace $out/${python3.sitePackages}/uxsim/__init__.py \
      --replace-fail '$NIX_QT_PLUGIN_PATH' '${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}'

    mkdir -p $out/${python3.sitePackages}/uxsim/files
    ln -s ${hackgen-font}/share/fonts/hackgen/HackGen-Regular.ttf $out/${python3.sitePackages}/uxsim/files/
  '';

  meta = with lib; {
    description = "Vehicular traffic flow simulator in road network, written in pure Python";
    homepage = "https://github.com/toruseo/UXsim";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
  };
}
