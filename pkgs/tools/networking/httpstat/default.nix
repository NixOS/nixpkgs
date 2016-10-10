{ stdenv, fetchFromGitHub, curl, python, pythonPackages, ... }:

pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "httpstat";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "reorx";
      repo = pname;
      rev = "${version}";
      sha256 = "1zfbv3fz3g3wwvsgrcyrk2cp7pjhkpf7lmx57ry9b43c62gcd7yh";
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
