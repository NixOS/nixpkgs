{ stdenv, fetchFromGitHub, buildPythonApplication
, colorama, decorator, psutil, pyte, six
, pytest, pytest-mock
}:

buildPythonApplication rec {
  pname = "thefuck";
  version = "3.29";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = pname;
    rev = version;
    sha256 = "1qhxwjjgrzpqrqjv7l2847ywpln76lyd6j8bl9gz2r6kl0fx2fqs";
  };

  propagatedBuildInputs = [ colorama decorator psutil pyte six ];

  checkInputs = [ pytest pytest-mock ];

  checkPhase = ''
    export HOME=$TMPDIR
    export LANG=en_US.UTF-8
    export XDG_CACHE_HOME=$TMPDIR/cache
    export XDG_CONFIG_HOME=$TMPDIR/config
    py.test
  '';

  doCheck = false; # The above is only enough for tests to pass outside the sandbox.

  meta = with stdenv.lib; {
    homepage = https://github.com/nvbn/thefuck;
    description = "Magnificent app which corrects your previous console command.";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
