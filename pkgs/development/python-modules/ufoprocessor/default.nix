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
  version = "1.9.0";

  src = fetchPypi {
    pname = "ufoProcessor";
    inherit version;
    hash = "sha256-uqi9m7uxHOAEZH6xkGEF9NW/28GzOIyk02+rV5UKQVs=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    defcon
    lxml
    fonttools
    fs
    fontmath
    fontparts
    mutatormath
  ];

  checkPhase = ''
    runHook preCheck
    for t in Tests/*.py; do
      # https://github.com/LettError/ufoProcessor/issues/32
      [[ "$(basename "$t")" = "tests_fp.py" ]] || python "$t"
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
