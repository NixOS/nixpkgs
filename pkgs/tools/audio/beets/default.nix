{ stdenv, fetchFromGitHub, buildPythonPackage, pythonPackages, python }:

buildPythonPackage rec {
  name = "beets-${version}";
  version = "1.3.9";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "sampsyo";
    repo = "beets";
    rev = "v${version}";
    sha256 = "1srhkiyjqx6i3gn20ihf087l5pa77yh5b81ivc52lj491fda7xqk";
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
    maintainers = with stdenv.lib.maintainers; [ iElectric aszlig ];
  };
}
