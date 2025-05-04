{
  lib,
  stdenv,
  buildPythonPackage,
  pytestCheckHook,
  tree-sitter,
  symlinkJoin,
  writeTextDir,
  pythonOlder,
  # `name`: grammar derivation pname in the format of `tree-sitter-<lang>`
  name,
  grammarDrv,
}:
let
  inherit (grammarDrv) version;

  snakeCaseName = lib.replaceStrings [ "-" ] [ "_" ] name;
  drvPrefix = "python-${name}";
  # If the name of the grammar attribute differs from the grammar's symbol name,
  # it could cause a symbol mismatch at load time. This manually curated collection
  # of overrides ensures the binding can find the correct symbol
  langIdentOverrides = {
    tree_sitter_org_nvim = "tree_sitter_org";
  };
  langIdent = langIdentOverrides.${snakeCaseName} or snakeCaseName;
in
buildPythonPackage {
  inherit version;
  pname = drvPrefix;

  src = symlinkJoin {
    name = "${drvPrefix}-source";
    paths = [
      (writeTextDir "${snakeCaseName}/__init__.py" ''
        from ._binding import language

        __all__ = ["language"]
      '')
      (writeTextDir "${snakeCaseName}/binding.c" ''
        #include <Python.h>

        typedef struct TSLanguage TSLanguage;

        TSLanguage *${langIdent}(void);

        static PyObject* _binding_language(PyObject *self, PyObject *args) {
            return PyLong_FromVoidPtr(${langIdent}());
        }

        static PyMethodDef methods[] = {
            {"language", _binding_language, METH_NOARGS,
            "Get the tree-sitter language for this grammar."},
            {NULL, NULL, 0, NULL}
        };

        static struct PyModuleDef module = {
            .m_base = PyModuleDef_HEAD_INIT,
            .m_name = "_binding",
            .m_doc = NULL,
            .m_size = -1,
            .m_methods = methods
        };

        PyMODINIT_FUNC PyInit__binding(void) {
            return PyModule_Create(&module);
        }
      '')
      (writeTextDir "setup.py" ''
        from platform import system
        from setuptools import Extension, setup


        setup(
          packages=["${snakeCaseName}"],
          ext_package="${snakeCaseName}",
          ext_modules=[
            Extension(
              name="_binding",
              sources=["${snakeCaseName}/binding.c"],
              extra_objects = ["${grammarDrv}/parser"],
              extra_compile_args=(
                ["-std=c11"] if system() != 'Windows' else []
              ),
            )
          ],
        )
      '')
      (writeTextDir "pyproject.toml" ''
        [build-system]
        requires = ["setuptools", "wheel"]
        build-backend = "setuptools.build_meta"

        [project]
        name="${snakeCaseName}"
        description = "${langIdent} grammar for tree-sitter"
        version = "${version}"
        keywords = ["parsing", "incremental", "python"]
        classifiers = [
          "Development Status :: 4 - Beta",
          "Intended Audience :: Developers",
          "License :: OSI Approved :: MIT License",
          "Topic :: Software Development :: Compilers",
          "Topic :: Text Processing :: Linguistic",
        ]

        requires-python = ">=3.8"
        license.text = "MIT"
        readme = "README.md"

        [project.optional-dependencies]
        core = ["tree-sitter~=0.21"]

        [tool.cibuildwheel]
        build = "cp38-*"
        build-frontend = "build"
      '')
      (writeTextDir "tests/test_language.py" ''
        from ${snakeCaseName} import language
        from tree_sitter import Language, Parser

        # This test only checks that the binding can load the grammar from the compiled shared object.
        # It does not verify the grammar itself; that is tested in
        # `pkgs/development/tools/parsing/tree-sitter/grammar.nix`.

        def test_language():
          lang = Language(language())
          assert lang is not None
          parser = Parser()
          parser.language = lang
          tree = parser.parse(bytes("", "utf-8"))
          assert tree is not None
      '')
    ];
  };

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${grammarDrv}"
  '';

  preCheck = ''
    # https://github.com/NixOS/nixpkgs/issues/255262
    rm -r ${snakeCaseName}
  '';

  disabled = pythonOlder "3.8";

  nativeCheckInputs = [
    tree-sitter
    pytestCheckHook
  ];
  pythonImportsCheck = [ snakeCaseName ];

  meta = {
    description = "Python bindings for ${name}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      a-jay98
      adfaure
      mightyiam
      stepbrobd
    ];
  };
}
