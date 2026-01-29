{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  fetchpatch,

  # build-time dependencies
  setuptools,
  cython,

  # non-Python runtime dependencies
  libGL,

  # Python runtime dependencies
  cypari,
  fxrays,
  ipython,
  low-index,
  packaging,
  pickleshare,
  plink,
  pypng,
  pyx,
  snappy-15-knots,
  snappy-manifolds,
  spherogram,
  tkinter-gl,

  # documentation
  sphinxHook,
  sphinx-rtd-theme,

  # tests
  runCommand,
  sage,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "snappy";
  version = "3.3";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "SnapPy";
    tag = "${version}_as_released";
    hash = "sha256-gok/94ziyOeXBgcfJNZVnS7vb7PCYL2r2BtNwnt/Peo=";
  };

  patches = [
    (fetchpatch {
      name = "no-copy-doc.patch";
      url = "https://github.com/3-manifolds/SnapPy/commit/c6aeeaaec7010a54e4ebdf2e8dad7b384c2ce8e5.patch";
      hash = "sha256-OV3Qr5wO5UHNzVFTPTujIpp5ptel6gvAlcMgrJ8C0KY=";
    })
  ];

  postPatch =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace setup.py \
        --replace-fail "/usr/include/GL" "${lib.getDev libGL}/include/GL"
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

  passthru.tests.sage =
    let
      sage' = sage.override {
        extraPythonPackages = ps: [ ps.snappy ];
        requireSageTests = false;
      };
    in
    runCommand "snappy-sage-tests"
      {
        nativeBuildInputs = [
          sage'
          writableTmpDirAsHomeHook
        ];
      }
      ''
        sage -python -m snappy.test --skip-gui
        touch $out
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
