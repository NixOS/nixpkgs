{ stdenv, python3Packages, pew }:

with python3Packages;
let
  version = "11.9.0";

  unwrapped = buildPythonApplication rec {
    name = "${pname}-unwrapped-${version}";
    pname = "pipenv";
    inherit version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "0s291ayiszqg4ia0fiya2g3ra6m6bf7mrds1c4dscz71azxm4g3v";
    };

    LC_ALL = "en_US.UTF-8";

    propagatedBuildInputs = [ pew pip requests flake8 ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Python Development Workflow for Humans";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ berdario ];
    };
  };
in stdenv.mkDerivation {
  name = "pipenv-${version}";
  unpackPhase = ":";
  # avoid propagating python packages to avoid polluting nix-shell environments.
  # Python version might be different. Python packages might be unwanted.
  installPhase = ''
    runHook preInstall
    mkdir $out
    ln -s ${unwrapped}/bin $out/bin
    runHook postInstall
  '';
  passthru = {
    inherit unwrapped;
  };
}
