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
    sha256 = "0ns11aamgavgsfj8qf5kq7dvzmgl0mhr1cbych2f075ipfdvva5s";
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
