{ stdenv, fetchFromGitHub, curl, python, pythonPackages, ... }:

pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "httpstat";
    version = "1.2.1";
    src = fetchFromGitHub {
      owner = "reorx";
      repo = pname;
      rev = "${version}";
      sha256 = "1vriibcsq4j1hvm5yigbbmmv21dc40y5c9gvd31dg9qkaz26hml6";
    };
    doCheck = false;
    propagatedBuildInputs = [ ];
    runtimeDeps = [ curl ];

    installPhase = ''
      mkdir -p $out/${python.sitePackages}/
      cp httpstat.py $out/${python.sitePackages}/
      mkdir -p $out/bin
      ln -s $out/${python.sitePackages}/httpstat.py $out/bin/httpstat
      chmod +x $out/bin/httpstat
    '';

    meta = {
      description = "curl statistics made simple";
      homepage = https://github.com/reorx/httpstat;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ nequissimus ];
    };
  }
