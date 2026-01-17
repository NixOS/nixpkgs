{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  tkinter,
  tkgl,
}:

buildPythonPackage rec {
  pname = "tkinter-gl";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "tkinter_gl";
    tag = "v${version}_as_released";
    hash = "sha256-ObI8EEQ7mAOAuV6f+Ld4HH0xkFzqiAZqHDvzjwPA/wM";
  };

  postPatch = ''
    # Remove compiled TkGL, we compile it ourselves
    rm -r src/tkinter_gl/tk
    # Platform-specific directories are only necessary when using compiled TkGL
    substituteInPlace src/tkinter_gl/__init__.py \
      --replace-fail "pkg_dir = os.path.join(__path__[0], 'tk', sys.platform,)" \
                     "pkg_dir = os.path.join(__path__[0], 'tk')"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ tkinter ];

  postInstall =
    let
      pkgDir = "$out/${python.sitePackages}/tkinter_gl/tk";
    in
    ''
      mkdir -p ${pkgDir}
      ln -s ${tkgl}/lib/Tkgl* ${pkgDir}
    '';

  pythonImportsCheck = [ "tkinter_gl" ];

  meta = {
    description = "Base class for GL rendering surfaces in tkinter";
    changelog = "https://github.com/3-manifolds/tkinter_gl/releases/tag/${src.tag}";
    homepage = "https://github.com/3-manifolds/tkinter_gl";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
