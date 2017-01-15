{ stdenv, fetchurl, pythonPackages, pkgs, lib, ... }:

with pythonPackages;

buildPythonPackage rec {
  name = "couchpotato-${version}";
  version = "3.0.1";
  disabled = isPy3k;

  src = pkgs.fetchurl {
    url = "https://github.com/CouchPotato/CouchPotatoServer/archive/build/${version}.tar.gz";
    sha256 = "1xwjis3ijh1rff32mpdsphmsclf0lkpd3phpgxkccrigq1m9r3zh";
  };

  format = "other";

  postPatch = ''
    substituteInPlace CouchPotato.py --replace "dirname(os.path.abspath(__file__))" "os.path.join(dirname(os.path.abspath(__file__)), '../${python.sitePackages}')"
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/${python.sitePackages}/

    cp -r libs/* $out/${python.sitePackages}/
    cp -r couchpotato $out/${python.sitePackages}/

    cp CouchPotato.py $out/bin/couchpotato
    chmod +x $out/bin/*
  '';

  fixupPhase = ''
    wrapProgram "$out/bin/couchpotato" --prefix PYTHONPATH : "$PYTHONPATH:$out/${python.sitePackages}" \
                                          --prefix PATH : ${python}/bin
  '';

  meta = {
    description = "Automatic movie downloading via NZBs and torrents";
    license     = lib.licenses.gpl3;
    homepage    = https://couchpota.to/;
    maintainers = with lib.maintainers; [ fadenb ];
  };
}
