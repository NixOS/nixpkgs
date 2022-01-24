{ lib
, pkgs
, python3Packages
, fetchFromGitHub

, addr ? "127.0.0.1"
, port ? 8082
}:

#
# Timetagger itself is a library that a user must write a "run.py" script for
# We provide a basic "run.py" script with this package, which simply starts
# timetagger.
#

let
  tt = python3Packages.timetagger;
in
python3Packages.buildPythonPackage rec {
  pname = tt.name;
  version = tt.version;
  src = tt.src;
  meta = tt.meta;

  propagatedBuildInputs = [ tt ]
    ++ (with python3Packages; [
      setuptools
    ]);

  format = "custom";
  installPhase = ''
    mkdir -p $out/bin
    echo "#!${pkgs.python3}/bin/python3" >> $out/bin/timetagger
    cat run.py >> $out/bin/timetagger
    sed -Ei 's,0\.0\.0\.0:80,${addr}:${toString port},' $out/bin/timetagger
    chmod +x $out/bin/timetagger
  '';
}

