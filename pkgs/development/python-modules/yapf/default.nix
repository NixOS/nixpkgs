{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, nose
, importlib-metadata
, platformdirs
, tomli
}:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.40.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lYWH61yOxshgEZqcJdAq3fMKRPdaoVKkIg0w5WqYA3w=";
  };

  # nose is unavailable on pypy
  doCheck = !isPyPy;

  propagatedBuildInputs = [
    importlib-metadata
    platformdirs
    tomli
  ];

  nativeCheckInputs = [
    nose
  ];

  meta = {
    homepage = "https://github.com/google/yapf";
    description = "Yet Another Python Formatter";
    longDescription = ''
      Most of the current formatters for Python --- e.g., autopep8, and pep8ify
      --- are made to remove lint errors from code. This has some obvious
      limitations. For instance, code that conforms to the PEP 8 guidelines may
      not be reformatted. But it doesn't mean that the code looks good.

      YAPF takes a different approach. It's based off of 'clang-format',
      developed by Daniel Jasper. In essence, the algorithm takes the code and
      reformats it to the best formatting that conforms to the style guide, even
      if the original code didn't violate the style guide. The idea is also
      similar to the 'gofmt' tool for the Go programming language: end all holy
      wars about formatting - if the whole codebase of a project is simply piped
      through YAPF whenever modifications are made, the style remains consistent
      throughout the project and there's no point arguing about style in every
      code review.

      The ultimate goal is that the code YAPF produces is as good as the code
      that a programmer would write if they were following the style guide. It
      takes away some of the drudgery of maintaining your code.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ AndersonTorres siddharthist ];
  };
}
