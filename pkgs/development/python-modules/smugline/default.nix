{ stdenv
, fetchFromGitHub
, docopt
, requests
, smugpy
, python
, pkgs
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname   = "smugline";
  version = "20160106";

  src = fetchFromGitHub {
    owner  = "gingerlime";
    repo   = pname;
    rev    = "134554c574c2d282112ba60165a8c5ffe0f16fd4";
    sha256 = "00n012ijkdrx8wsl8x3ghdcxcdp29s4kwr3yxvlyj79g5yhfvaj6";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ python pkgs.makeWrapper ];
  propagatedBuildInputs = [ docopt requests smugpy ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp smugline.py $out/libexec
    makeWrapper ${python.interpreter} $out/bin/smugline \
      --add-flags "$out/libexec/smugline.py" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gingerlime/smugline;
    description = "A simple command line tool for smugmug ";
    license = licenses.mit;
  };

}
