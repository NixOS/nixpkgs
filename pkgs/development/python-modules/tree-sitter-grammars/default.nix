{
  lib,
  buildPythonPackage,
  setuptools,
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
  pyproject = true;
  build-system = [ setuptools ];

  src = symlinkJoin {
    name = "${drvPrefix}-source";
    paths = [
      (writeTextDir "${snakeCaseName}/__init__.py" ''
        # AUTO-GENERATED DO NOT EDIT

        # preload the parser object before importing c binding
        # this way we can avoid dynamic linker kicking in when
        # downstream code imports this python module
        import ctypes
        import sys
        import os
        parser = "${grammarDrv}/parser"
        try:
            ctypes.CDLL(parser, mode=ctypes.RTLD_GLOBAL) # cached
        except OSError as e:
            raise ImportError(f"cannot load tree-sitter parser object from {parser}: {e}")

        # expose binding
        from ._binding import language
        __all__ = ["language"]
      '')
      (writeTextDir "${snakeCaseName}/binding.c" ''
        // AUTO-GENERATED DO NOT EDIT

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
        # AUTO-GENERATED DO NOT EDIT

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
        # AUTO-GENERATED DO NOT EDIT

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
          "Topic :: Software Development :: Compilers",
          "Topic :: Text Processing :: Linguistic",
        ]

        requires-python = ">=3.8"
        license = "MIT"
        readme = "README.md"

        [project.optional-dependencies]
        core = ["tree-sitter~=0.21"]

        [tool.cibuildwheel]
        build = "cp38-*"
        build-frontend = "build"
      '')
      (writeTextDir "tests/test_language.py" ''
        # AUTO-GENERATED DO NOT EDIT

        from ${snakeCaseName} import language
        from tree_sitter import Language, Parser

        # This test only checks that the binding can load the grammar from the compiled shared object.
        # It does not verify the grammar itself; that is tested in
        # `pkgs/development/tools/parsing/tree-sitter/grammar.nix`.

        def test_language():
          lang = Language(language())
          assert lang is not None
          parser = Parser(lang)
          tree = parser.parse(bytes("", "utf-8"))
          assert tree is not None
      '')
    ];
  };

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
