{ stdenv, pythonPackages, fetchurl, makeWrapper }:

with pythonPackages;
buildPythonApplication rec {
  pname = "photon";
  version = "1.0.7";

  src = fetchurl {
    url = "https://github.com/s0md3v/Photon/archive/v${version}.tar.gz";
    sha256 = "0c5l1sbkkagfxmh8v7yvi6z58mhqbwjyr7fczb5qwxm7la42ah9y";
  };

  patches = [ ./destdir.patch ];
  postPatch = ''
       substituteInPlace photon.py --replace DESTDIR $out/share/photon 
  '';

  dontBuild = true;
  doCheck = false;
  propagatedBuildInputs = [
    requests
    urllib3
  ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/photon}
    cp -R photon.py core plugins $out/share/photon
 
    makeWrapper ${python.interpreter} $out/bin/photon \
      --set PYTHONPATH "$PYTHONPATH:$out/share/photon" \
      --add-flags "-O $out/share/photon/photon.py"
  '';

  meta = with stdenv.lib; {
    description = "a lightning fast web crawler which extracts URLs, files, intel & endpoints from a target";
    homepage = https://github.com/s0md3v/Photon;
    license = licenses.gpl3;
    maintainers = with maintainers; [ genesis ];
  };
}
