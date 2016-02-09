{ stdenv, fetchurl, python, pythonPackages }:

stdenv.mkDerivation rec {
  name = "dstat-0.7.2";

  src = fetchurl {
    url = "http://dag.wieers.com/home-made/dstat/${name}.tar.bz2";
    sha256 = "1bivnciwlamnl9q6i5ygr7jhs8pp833z2bkbrffvsa60szcqda9l";
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
