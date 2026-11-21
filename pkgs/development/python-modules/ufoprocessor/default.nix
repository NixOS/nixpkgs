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
  version = "1.14.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sMT0KwkDsHceSZBkiV0GYSGkgqwGD0a3jcAMXywyKOU=";
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

  meta = {
    description = "Read, write and generate UFOs with designspace data";
    homepage = "https://github.com/LettError/ufoProcessor";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
