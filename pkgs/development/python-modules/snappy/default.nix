{
  lib,
  stdenv,
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

  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace setup.py \
        --replace-fail "/usr/include/GL" "${libGL.dev}/include/GL"
      substituteInPlace freedesktop/share/applications/snappy.desktop \
        --replace-fail "Exec=/usr/bin/env python3 -m snappy.app" "Exec=SnapPy"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace setup.py \
        --replace-fail "poss_roots = [ ''' ]" "poss_roots = [ '$SDKROOT' ]"
    '';

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

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

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share
    cp -r freedesktop/share/{applications,icons} $out/share
  '';

  sphinxRoot = "doc_src";

  postInstallSphinx = ''
    ln -s ''${!outputDoc}/share/doc/$name/html $out/${python.sitePackages}/snappy/doc
  '';

  pythonImportsCheck = [ "snappy" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m snappy.test --skip-gui
    runHook postCheck
  '';

  meta = {
    description = "Studying the topology and geometry of 3-manifolds, with a focus on hyperbolic structures";
    changelog = "https://snappy.computop.org/news.html";
    mainProgram = "SnapPy";
    homepage = "https://snappy.computop.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
