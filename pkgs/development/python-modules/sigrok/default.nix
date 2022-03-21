{ lib
, stdenv
, libsigrok
, toPythonModule
, python
, autoreconfHook
, pythonImportsCheckHook
, pythonCatchConflictsHook
, swig
, setuptools
, numpy
, pygobject3
}:

# build libsigrok plus its Python bindings. Unfortunately it does not appear
# to be possible to build them separately, at least not easily.
toPythonModule ((libsigrok.override {
  inherit python;
}).overrideAttrs (orig: {
  pname = "${python.libPrefix}-sigrok";

  patches = orig.patches or [] ++ [
    # Makes libsigrok install the bindings into site-packages properly (like
    # we expect) instead of making a version-specific *.egg subdirectory.
    ./python-install.patch
  ];

  nativeBuildInputs = orig.nativeBuildInputs or [] ++ [
    autoreconfHook
    setuptools
    swig
    numpy
  ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    pythonImportsCheckHook
    pythonCatchConflictsHook
  ];

  buildInputs = orig.buildInputs or [] ++ [
    pygobject3 # makes headers available the configure script checks for
  ];

  propagatedBuildInputs = orig.propagatedBuildInputs or [] ++ [
    pygobject3
    numpy
  ];

  postInstall = ''
    ${orig.postInstall or ""}

    # for pythonImportsCheck
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';

  pythonImportsCheck = [ "sigrok" "sigrok.core" ];

  meta = orig.meta // {
    description = "Python bindings for libsigrok";
    maintainers = orig.meta.maintainers ++ [
      lib.maintainers.sternenseemann
    ];
  };
}))
