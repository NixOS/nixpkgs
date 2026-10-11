{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  python-xlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "xlib-hotkeys";
  version = "2024.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bkbilly";
    repo = "xlib_hotkeys";
    tag = finalAttrs.version;
    hash = "sha256-9NqvxhRvmqLwUL6Y6i9oRY7+VaRefytGqiBzaEG/r4g=";
  };

  # Upstream pins its build backend with `~=` to versions from 2023. Nothing in the build actually
  # needs them, and nixpkgs checks build dependencies, so relax them to what is available.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'requires = ["setuptools~=68.0.0", "wheel~=0.40.0"]' \
        'requires = ["setuptools"]'
  '';

  build-system = [ setuptools ];

  dependencies = [ python-xlib ];

  # Upstream ships no test suite.
  doCheck = false;

  pythonImportsCheck = [ "xlib_hotkeys" ];

  meta = {
    description = "Register keyboard hotkeys to a callback function";
    homepage = "https://github.com/bkbilly/xlib_hotkeys";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      giggio
      bkbilly
    ];
    platforms = lib.platforms.linux;
  };
})
