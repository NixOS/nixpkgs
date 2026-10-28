{
  stdenv,
  lib,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  tkgl,
  tkinter,
  nix-update-script,

  mesa,
  pyopengl,
  xvfb-run,
}:

buildPythonPackage (finalAttrs: {
  pname = "tkinter-gl";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "tkinter_gl";
    tag = "v${finalAttrs.version}_as_released";
    hash = "sha256-PNxxjyVGoMw4J/SXWvVITuGMq/HypxUwDkSxeFy2Vag=";
  };

  postPatch = ''
    # Remove compiled TkGL, we compile it ourselves
    rm -r src/tkinter_gl/tk
    # Platform-specific directories are only necessary when using compiled TkGL
    substituteInPlace src/tkinter_gl/__init__.py \
      --replace-fail "pkg_dir = os.path.join(__path__[0], 'tk', target)" \
                     "pkg_dir = os.path.join(__path__[0], 'tk')"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ tkinter ];

  postInstall =
    let
      pkgDir = "$out/${python.sitePackages}/tkinter_gl/tk";
    in
    ''
      mkdir -p ${pkgDir}
      ln -s ${tkgl}/lib/Tkgl* ${pkgDir}
    '';

  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = [
    xvfb-run
    pyopengl
    mesa.llvmpipeHook
  ];

  checkPhase = ''
    runHook preCheck

    export HOME=$TMPDIR
    xvfb-run --auto-display ${python.interpreter} ${./square.py}

    runHook postCheck
  '';

  pythonImportsCheck = [ "tkinter_gl" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)_as_released"
    ];
  };

  meta = {
    description = "Base class for GL rendering surfaces in tkinter";
    changelog = "https://github.com/3-manifolds/tkinter_gl/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/3-manifolds/tkinter_gl";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
})
