{ lib
, stdenv
, python3
, python3Minimal
}:

let
  # python3Minimal can't be overridden with packages on Darwin, due to a missing framework.
  # Instead of modifying stdenv, we take the easy way out, since most people on Darwin will
  # just be hacking on the Nixpkgs manual (which also uses make-options-doc).
  python = ((if stdenv.isDarwin then python3 else python3Minimal).override {
    self = python;
    includeSiteCustomize = true;
  });

  # TODO add our own small test suite, maybe add tests for these deps to channels?
  markdown-it-py-no-tests = python.pkgs.markdown-it-py.override {
    disableTests = true;
  };
  mdit-py-plugins-no-tests = python.pkgs.mdit-py-plugins.override {
    markdown-it-py = markdown-it-py-no-tests;
    disableTests = true;
  };
in

python.pkgs.buildPythonApplication {
  pname = "nixos-render-docs";
  version = "0.0";
  format = "pyproject";

  src = lib.cleanSourceWith {
    filter = name: type:
      lib.cleanSourceFilter name type
      && ! (type == "directory"
            && builtins.elem
              (baseNameOf name)
              [
                ".pytest_cache"
                ".mypy_cache"
                "__pycache__"
              ]);
    src = ./src;
  };

  nativeBuildInputs = [
    python.pkgs.setuptools
    python.pkgs.pytestCheckHook
  ];

  propagatedBuildInputs = [
    markdown-it-py-no-tests
    mdit-py-plugins-no-tests
    python.pkgs.frozendict
  ];

  pytestFlagsArray = [ "-vvrP" "tests/" ];

  meta = with lib; {
    description = "Renderer for NixOS manual and option docs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
