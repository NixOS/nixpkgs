{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "dstat-${version}";
  format = "other";
  version = "0.7.3";

  src = fetchurl {
    url = "https://github.com/dagwieers/dstat/archive/${version}.tar.gz";
    sha256 = "16286z3y2lc9nsq8njzjkv6k2vyxrj9xiixj1k3gnsbvhlhkirj6";
  };

  propagatedBuildInputs = with python2Packages; [ python-wifi ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://dag.wieers.com/home-made/dstat/;
    description = "Versatile resource statistics tool";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds nckx ];
  };
}
