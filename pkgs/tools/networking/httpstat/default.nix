{ stdenv, fetchFromGitHub, curl, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
  pname = "httpstat";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "reorx";
    repo = pname;
    rev = version;
    sha256 = "18k2glnyzxlmry19ijmndim2vqqn3c86smd7xc3haw6k7qafifx1";
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
