{ lib, python2Packages }:

let
  truffleHogRegexes = python2Packages.buildPythonPackage rec {
    pname = "truffleHogRegexes";
    version = "0.0.4";
    src = python2Packages.fetchPypi {
      inherit pname version;
      sha256 = "09vrscbb4h4w01gmamlzghxx6cvrqdscylrbdcnbjsd05xl7zh4z";
    };
  };
in
  python2Packages.buildPythonApplication rec {
    pname = "truffleHog";
    version = "2.0.97";

    src = python2Packages.fetchPypi {
      inherit pname version;
      sha256 = "034kpv1p4m90286slvc6d4mlrzaf0b5jbd4qaj87hj65wbpcpg8r";
    };

    # Relax overly restricted version constraint
    postPatch = ''
      substituteInPlace setup.py --replace "GitPython ==" "GitPython >= "
    '';

    propagatedBuildInputs = [ python2Packages.GitPython truffleHogRegexes ];

    # Test cases run git clone and require network access
    doCheck = false;

    meta = {
      homepage = https://github.com/dxa4481/truffleHog;
      description = "Searches through git repositories for high entropy strings and secrets, digging deep into commit history";
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ bhipple ];
    };
  }
