{ stdenv, fetchFromGitHub, curl, pythonPackages, glibcLocales }:

pythonPackages.buildPythonApplication rec {
    name = "${pname}-${version}";
    pname = "httpstat";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "reorx";
      repo = pname;
      rev = "${version}";
      sha256 = "1zfbv3fz3g3wwvsgrcyrk2cp7pjhkpf7lmx57ry9b43c62gcd7yh";
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
