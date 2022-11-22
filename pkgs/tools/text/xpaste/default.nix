{ lib
, fetchFromGitHub
, python3Packages
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "xpaste";
  version = "1.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ossobv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Z9YxhVP+FUvWET91ob4SPSW+XX7/wzlgPr53vO517L4=";
  };

  propagatedBuildInputs = with python3Packages; [
    xlib
  ];

  patches = [
    (fetchpatch {
      # https://github.com/ossobv/xpaste/pull/6
      name = "fix-function-call-after-wayland-update.patch";
      url = "https://github.com/ossobv/xpaste/commit/47412738dad4b5fc8bc287ead23c8440bfdc547d.patch";
      hash = "sha256-t4LZG600AsFTtKjXCxioGcAP4YcHIdQ/fVMIYjsunuA=";
    })
  ];

  # no tests, no python module to import, no version output to check
  doCheck = false;

  meta = with lib; {
    description = "Paste text into X windows that don't work with selections";
    homepage = "https://github.com/ossobv/xpaste";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gador ];
  };
}
