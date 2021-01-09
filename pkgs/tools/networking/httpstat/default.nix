{ stdenv, fetchFromGitHub, curl, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  pname = "httpstat";
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "reorx";
    repo = pname;
    rev = version;
    sha256 = "sha256-zUdis41sQpJ1E3LdNwaCVj6gexi/Rk21IBUgoFISiDM=";
  };
  doCheck = false; # No tests
  buildInputs = [ glibcLocales ];
  runtimeDeps = [ curl ];

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "curl statistics made simple";
    homepage = "https://github.com/reorx/httpstat";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ nequissimus ];
  };
}
