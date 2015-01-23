{ stdenv, fetchurl, python2, python2Packages, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.0.0-rc2";
  name = "ASynK-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/skarra/ASynK/archive/v${version}.tar.gz";
    sha256 = "14s53ijn9fpxr490ypnn92zk6h5rdadf7j3z98rah1h7l659qi1b";
  };

  propagatedBuildInputs = with python2Packages; [ python2 makeWrapper tornado requests dateutil ];

  installPhase = ''
    mkdir -p $out/bin
    cp asynk.py $out/bin/
    cp state.init.json $out/
    cp -R config $out/
    cp -R lib $out/
    cp -R asynk $out/

    substituteInPlace $out/bin/asynk.py \
      --replace "ASYNK_BASE_DIR    = os.path.dirname(os.path.abspath(__file__))" "ASYNK_BASE_DIR    = \"$out\""

    wrapProgram "$out/bin/asynk.py" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://asynk.io/;
    description = "Flexible contacts synchronization program";
    license = licenses.agpl3;
    maintainers = [ maintainers.DamienCassou ];
  };
}
