{ lib
, buildPythonPackage
, pytestCheckHook
, tree-sitter
, symlinkJoin
, writeTextDir
  # `name`: grammar derivation pname in the format of `tree-sitter-<lang>`
, name
, grammarDrv
}:
let
  inherit (grammarDrv) version;

  snakeCaseName = lib.replaceStrings [ "-" ] [ "_" ] name;
  drvPrefix = "python-${name}";
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
      (writeTextDir "${snakeCaseName}/__init__.py"
        ''
          from ._binding import language

          __all__ = ["language"]
        ''
      )
      (writeTextDir "${snakeCaseName}/binding.c"
        ''
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
        ''
      )
      (writeTextDir "setup.py"
        ''
          from platform import system
          from setuptools import Extension, setup


          setup(
            name="${snakeCaseName}",
            version="${version}",
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
                define_macros=[
                  ("Py_LIMITED_API", "0x03080000"),
                  ("PY_SSIZE_T_CLEAN", None)
                ],
                py_limited_api=True,
              )
            ],
          )
        ''
      )
      (writeTextDir "tests/test_language.py"
        ''
          from ${snakeCaseName} import language
          from tree_sitter import Language, Parser


          def test_language():
            lang = Language(language())
            assert lang is not None
            parser = Parser()
            parser.language = lang
            tree = parser.parse(bytes("", "utf-8"))
            assert tree is not None
        ''
      )
    ];
  };

  preCheck = ''
    rm -r ${snakeCaseName}
  '';

  nativeCheckInputs = [ tree-sitter pytestCheckHook ];
  pythonImportsCheck = [ snakeCaseName ];

  meta = {
    description = "Python bindings for ${name}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-jay98 adfaure mightyiam stepbrobd ];
  };
}
