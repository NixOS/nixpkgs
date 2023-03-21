{ lib
, stdenv
, python3
, python3Minimal
, runCommand
}:

let
  # python3Minimal can't be overridden with packages on Darwin, due to a missing framework.
  # Instead of modifying stdenv, we take the easy way out, since most people on Darwin will
  # just be hacking on the Nixpkgs manual (which also uses make-options-doc).
  python = ((if stdenv.isDarwin then python3 else python3Minimal).override {
    self = python;
    includeSiteCustomize = true;
  }).override {
    packageOverrides = final: prev: {
      markdown-it-py = prev.markdown-it-py.overridePythonAttrs (_: {
        doCheck = false;
      });
      mdit-py-plugins = prev.mdit-py-plugins.overridePythonAttrs (_: {
        doCheck = false;
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
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

  nativeBuildInputs = with python.pkgs; [
    setuptools
    pytestCheckHook
  ];

  propagatedBuildInputs = with python.pkgs; [
    markdown-it-py
    mdit-py-plugins
  ];

  pytestFlagsArray = [ "-vvrP" "tests/" ];

  # NOTE this is a CI test rather than a build-time test because we want to keep the
  # build closures small. mypy has an unreasonably large build closure for docs builds.
  passthru.tests.typing = runCommand "${pname}-mypy" {
    nativeBuildInputs = [
      (python3.withPackages (ps: with ps; [ mypy pytest markdown-it-py mdit-py-plugins ]))
    ];
  } ''
    mypy --strict ${src}
    touch $out
  '';

  meta = with lib; {
    description = "Renderer for NixOS manual and option docs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
