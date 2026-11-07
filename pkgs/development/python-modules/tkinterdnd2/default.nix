{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  setuptools,

  tcl8Packages,
  tkinter,

  unittestCheckHook,
  libxcursor,
  xvfb,
}:
buildPythonPackage rec {
  pname = "tkinterdnd2";
  version = "0.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Eliav2";
    repo = "tkinterdnd2";
    tag = version;
    hash = "sha256-7+W+H0a6LUmh3822eUk+jTElEV6DGdNqIGF4mH+1AWU=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      tkdnd = "${tcl8Packages.tkdnd}/lib";
    })
  ];

  postPatch = ''
    touch tests/__init__.py
    substituteInPlace tests/test_tkinterdnd2.py \
      --replace-fail '2.9.2' '${tcl8Packages.tkdnd.version}'
  '';

  build-system = [ setuptools ];
  dependencies = [ tkinter ];

  nativeCheckInputs = [
    unittestCheckHook
    xvfb
  ];

  env.LD_LIBRARY_PATH = lib.makeLibraryPath [ libxcursor ];

  preCheck = ''
    export DISPLAY=:$((2000 + $RANDOM % 1000))
    Xvfb $DISPLAY -screen 5 1024x768x8 &
    xvfb_pid=$!
  '';

  postCheck = ''
    sleep 0.5
    kill $xvfb_pid
  '';

  meta = {
    description = "Fork of wrapper for George Petasis' tkDnD Tk extension version 2";
    homepage = "https://github.com/Eliav2/tkinterdnd2";
    changelog = "https://github.com/Eliav2/tkinterdnd2/raw/refs/tags/${version}/changelog.txt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
