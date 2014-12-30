{ stdenv, fetchurl, buildPythonPackage, pythonPackages, python }:

buildPythonPackage rec {
  name = "beets-1.3.9";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/b/beets/${name}.tar.gz";
    md5 = "0211b4abfe7887da22c1413e761fdcb4";
  };

  # tests depend on $HOME setting
  preConfigure = "export HOME=$TMPDIR";

  propagatedBuildInputs = [
    pythonPackages.pyyaml
    pythonPackages.unidecode
    pythonPackages.mutagen
    pythonPackages.munkres
    pythonPackages.musicbrainzngs
    pythonPackages.enum34
    pythonPackages.pylast
    pythonPackages.rarfile
    pythonPackages.flask
    python.modules.sqlite3
    python.modules.readline
  ];

  buildInputs = with pythonPackages; [ mock pyechonest six responses nose ];

  # 10 tests are failing
  doCheck = false;

  meta = {
    homepage = http://beets.radbox.org;
    description = "Music tagger and library organizer";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
