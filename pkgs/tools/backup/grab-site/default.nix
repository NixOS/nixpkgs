{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  version = "2.1.11";
  name = "grab-site-${version}";

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "ludios";
    repo = "grab-site";
    sha256 = "0w24ngr2b7nipqiwkxpql2467b5aq2vbknkb0sry6a457kb5ppsl";
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
    homepage = https://github.com/ludios/grab-site;
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
    platforms = platforms.all;
  };
}
