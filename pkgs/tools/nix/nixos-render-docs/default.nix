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
  });

  # TODO add our own small test suite, maybe add tests for these deps to channels?
  markdown-it-py-no-tests = python.pkgs.markdown-it-py.override {
    disableTests = true;
  };
  mdit-py-plugins-no-tests = python.pkgs.mdit-py-plugins.override {
    markdown-it-py = markdown-it-py-no-tests;
    disableTests = true;
  };

  makeDeps = pkgs: small:
    [ pkgs.frozendict ]
    ++ (
      if small
      then [
        markdown-it-py-no-tests
        mdit-py-plugins-no-tests
      ]
      else [
        pkgs.markdown-it-py
        pkgs.mdit-py-plugins
      ]
    );
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

  nativeBuildInputs = [
    python.pkgs.setuptools
    python.pkgs.pytestCheckHook
  ];

  propagatedBuildInputs = makeDeps python.pkgs true;

  pytestFlagsArray = [ "-vvrP" "tests/" ];

  # NOTE this is a CI test rather than a build-time test because we want to keep the
  # build closures small. mypy has an unreasonably large build closure for docs builds.
  passthru.tests.typing = runCommand "${pname}-mypy" {
    nativeBuildInputs = [
      (python3.withPackages (p: [ p.mypy p.pytest ] ++ makeDeps p false))
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
