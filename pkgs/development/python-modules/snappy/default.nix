{
  lib,
  fetchpatch,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cypari,
  cython,
  fxrays,
  ipython,
  libGL,
  low-index,
  packaging,
  pickleshare,
  plink,
  pypng,
  pyx,
  snappy-15-knots,
  snappy-manifolds,
  spherogram,
  sphinxHook,
  sphinx-rtd-theme,
  tkinter-gl,
}:

buildPythonPackage rec {
  pname = "snappy";
  version = "3.2";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "SnapPy";
    tag = "${version}_as_released";
    hash = "sha256-IwPxuyVDsL5yML+J06HTKlz52sYrPkohLJ0XDXDwTlo=";
  };

  patches = [
    (fetchpatch {
      name = "no-copy-doc.patch";
      url = "https://github.com/3-manifolds/SnapPy/commit/c6aeeaaec7010a54e4ebdf2e8dad7b384c2ce8e5.patch";
      hash = "sha256-OV3Qr5wO5UHNzVFTPTujIpp5ptel6gvAlcMgrJ8C0KY=";
    })
    (fetchpatch {
      name = "fix-test-aarch64.patch";
      url = "https://github.com/3-manifolds/SnapPy/commit/a8d57db39bc8f486746dc61027779168d0bc316a.patch";
      hash = "sha256-RsuwaR+7UrVTKlPwQeHblTAN++La7b9BSMdFcJSiX5Q=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "/usr/include/GL" "${libGL.dev}/include/GL"
    substituteInPlace python/app_menus.py \
      --replace-fail "os.path.join(os.path.dirname(snappy_dir), 'doc')" \
                     "os.path.join('${placeholder "doc"}', 'share', 'doc', '$name', 'html')"
    substituteInPlace freedesktop/share/applications/snappy.desktop \
      --replace-fail "Exec=/usr/bin/env python3 -m snappy.app" "Exec=SnapPy"
  '';

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  sphinxRoot = "doc_src";

  buildInputs = [
    libGL
  ];

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

  env.SNAPPY_ALWAYS_BUILD_CYOPENGL = "True";

  postInstall = ''
    cp -r freedesktop/share $out/
  '';

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
