{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  version = "2.1.15";
  name = "grab-site-${version}";

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "ArchiveTeam";
    repo = "grab-site";
    sha256 = "1h3ajsj1c2wlxji1san97vmjd9d97dv0rh0jw1p77irkcvhzfpj8";
  };

  propagatedBuildInputs = with python3Packages; [
    click ludios_wpull manhole lmdb autobahn fb-re2 websockets cchardet
  ];

  checkPhase = ''
    export PATH=$PATH:$out/bin
    bash ./tests/offline-tests
  '';

  meta = with stdenv.lib; {
    description = "Crawler for web archiving with WARC output";
    homepage = https://github.com/ArchiveTeam/grab-site;
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
    platforms = platforms.all;
  };
}
