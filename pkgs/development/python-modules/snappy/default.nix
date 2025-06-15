{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cypari,
  cython,
  fxrays,
  ipython,
  libGL,
  libX11,
  low-index,
  packaging,
  pickleshare,
  plink,
  pypng,
  pyx,
  snappy-15-knots,
  snappy-manifolds,
  spherogram,
  sphinx,
  sphinx-rtd-theme,
  tkinter-gl,
}:

buildPythonPackage rec {
  pname = "snappy";
  version = "3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "SnapPy";
    tag = "${version}_as_released";
    hash = "sha256-IwPxuyVDsL5yML+J06HTKlz52sYrPkohLJ0XDXDwTlo=";
  };

  build-system = [
    setuptools
    cython
    sphinx
    sphinx-rtd-theme
  ];

  buildInputs = [
    libGL
    libX11
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/include/GL" "${libGL.dev}/include/GL" \
      --replace-fail "'python/doc'" "'$out/${python.sitePackages}/snappy/doc'"
    substituteInPlace python/app_menus.py \
      --replace-fail "sys.platform.startswith('linux')" "False"
    substituteInPlace freedesktop/share/applications/snappy.desktop \
      --replace-fail "Exec=/usr/bin/env python3 -m snappy.app" "Exec=SnapPy"
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libGL.dev}/include"
    "-I${libX11.dev}/include"
  ];
  env.SNAPPY_ALWAYS_BUILD_CYOPENGL = "True";

  postInstall = ''
    ${python.interpreter} setup.py build_docs
    cp -r freedesktop/share $out/
  '';

  dependencies = [
    cypari
    fxrays
    ipython
    low-index
    packaging
    pickleshare
    plink
    pypng
    pyx
    snappy-manifolds
    spherogram
    tkinter-gl
  ];

  optional-dependencies.snappy-15-knots = [ snappy-15-knots ];

  pythonImportsCheck = [ "snappy" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m snappy.test
    runHook postCheck
  '';

  meta = {
    description = "Studying the topology and geometry of 3-manifolds, with a focus on hyperbolic structures";
    changelog = "https://snappy.computop.org/news.html";
    mainProgram = "SnapPy";
    homepage = "https://snappy.computop.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
    platforms = lib.platforms.linux;
  };
}
