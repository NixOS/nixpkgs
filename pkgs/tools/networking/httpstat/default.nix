{ stdenv, fetchFromGitHub, curl, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
    pname = "httpstat";
    version = "1.2.1";
    src = fetchFromGitHub {
      owner = "reorx";
      repo = pname;
      rev = version;
      sha256 = "1vriibcsq4j1hvm5yigbbmmv21dc40y5c9gvd31dg9qkaz26hml6";
    };
    doCheck = false; # No tests
    buildInputs = [ glibcLocales ];
    runtimeDeps = [ curl ];

    LC_ALL = "en_US.UTF-8";

    meta = {
      description = "curl statistics made simple";
      homepage = https://github.com/reorx/httpstat;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ nequissimus ];
    };
  }
