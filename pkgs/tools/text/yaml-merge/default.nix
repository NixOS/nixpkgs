{ lib, stdenv, fetchFromGitHub, pythonPackages }:

stdenv.mkDerivation {
  pname = "yaml-merge";
  version = "unstable-2016-02-16";

  src = fetchFromGitHub {
    owner = "abbradar";
    repo = "yaml-merge";
    rev = "4eef7b68632d79dec369b4eff5a8c63f995f81dc";
    sha256 = "0mwda2shk43i6f22l379fcdchmb07fm7nf4i2ii7fk3ihkhb8dgp";
  };

  pythonPath = with pythonPackages; [ pyyaml ];
  nativeBuildInputs = [ pythonPackages.wrapPython ];

  installPhase = ''
    install -Dm755 yaml-merge.py $out/bin/yaml-merge
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Merge YAML data files";
    homepage = "https://github.com/abbradar/yaml-merge";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
