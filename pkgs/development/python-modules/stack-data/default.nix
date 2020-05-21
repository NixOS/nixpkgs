{ asttokens
, buildPythonPackage
, executing
, fetchFromGitHub
, git
, lib
, littleutils
, pure-eval
, pygments
, pytestCheckHook
, setuptools_scm
, toml
, typeguard
}:

buildPythonPackage rec {
  pname = "stack_data";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    sha256 = "148lhxihak8jm5dvryhsiykmn3s4mrlba8ki4dy1nbd8jnz06a4w";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    git
    setuptools_scm
    toml
  ];

  propagatedBuildInputs = [
    asttokens
    executing
    pure-eval
  ];

  checkInputs = [
    littleutils
    pygments
    pytestCheckHook
    typeguard
  ];

  meta = with lib; {
    description = "Extract data from stack frames and tracebacks";
    homepage = "https://github.com/alexmojaki/stack_data/";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
