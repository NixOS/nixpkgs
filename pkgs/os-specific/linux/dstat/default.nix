{ stdenv, fetchurl, python, pythonPackages }:

stdenv.mkDerivation rec {
  name = "dstat-${version}";
  version = "0.7.3";

  src = fetchurl {
    url = "https://github.com/dagwieers/dstat/archive/${version}.tar.gz";
    sha256 = "16286z3y2lc9nsq8njzjkv6k2vyxrj9xiixj1k3gnsbvhlhkirj6";
  };

  buildInputs = with pythonPackages; [ python-wifi wrapPython ];

  pythonPath = with pythonPackages; [ python-wifi ];

  patchPhase = ''
    sed -i -e 's|/usr/bin/env python|${python}/bin/python|' \
           -e "s|/usr/share/dstat|$out/share/dstat|" dstat
  '';

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    homepage = http://dag.wieers.com/home-made/dstat/;
    description = "Versatile resource statistics tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds nckx ];
  };
}
