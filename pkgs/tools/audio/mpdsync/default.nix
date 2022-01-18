{ stdenv, python2, fetchFromGitHub }:
with python2.pkgs;
stdenv.mkDerivation {
  pname = "mpdsync";
  version = "unstable-2017-06-15";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "mpdsync";
    rev = "da90058f44dd9578cc5f2fb96a1fb2b26da40d07";
    sha256 = "1mfg3ipqj5dvyyqbgp6ia6sc1ja5gmm2c9mfrwx0jw2dl182if6q";
  };

  pythonPath = [ mpd2 ];

  nativeBuildInputs = [
    wrapPython
  ];

  dontBuild = true;

  installPhase = "install -D mpdsync.py $out/bin/mpdsync";
  postFixup = "wrapPythonPrograms";

}
