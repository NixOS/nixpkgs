{ stdenv, fetchzip, pythonPackages, buildPythonApplication }:

let honcho = buildPythonApplication rec {
  name = "honcho-${version}";
  version = "0.6.6";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/nickstenning/honcho/archive/v${version}.tar.gz";
    sha256 = "1ishyzvq19hdln2nn3bjlk0kwfqsbddpypp28n88jp3px6832w02";
  };

  buildInputs = with pythonPackages; [ nose mock jinja2 ];
  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python clone of Foreman, a tool for managing Procfile-based applications";
    license = licenses.mit;
    homepage = https://github.com/nickstenning/honcho;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
};

in

# Some of honcho's tests require that honcho be installed in the environment in
# order to work. This is a trick to build it without running tests, then pass
# it to itself as a buildInput so the tests work.
honcho.overrideDerivation (x: { buildInputs = [ honcho ]; doCheck = true; })
