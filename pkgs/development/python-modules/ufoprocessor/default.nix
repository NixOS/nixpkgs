{
  lib,
  buildPythonPackage,
  fetchPypi,
  defcon,
  fonttools,
  lxml,
  fs,
  mutatormath,
  fontmath,
  fontparts,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ufoprocessor";
  version = "1.14.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ic7LJRxEvwxdmfhiiuyzBOlnFUaE5wGfk6Jf7kJkcyE=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    defcon
    fontmath
    fontparts
    fonttools
    mutatormath
  ]
  ++ defcon.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.ufo;

  checkPhase = ''
    runHook preCheck
    for t in Tests/*.py; do
      python "$t"
    done
    runHook postCheck
  '';

  meta = with lib; {
    description = "Read, write and generate UFOs with designspace data";
    homepage = "https://github.com/LettError/ufoProcessor";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
