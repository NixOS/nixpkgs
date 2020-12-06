{ stdenv, python37, fetchFromGitHub }:

let
  python = python37.override {
    self = python;
    packageOverrides = self: super: {
      tornado = super.tornado_4;
    };
  };

in with python.pkgs; buildPythonApplication rec {
  version = "2.1.19";
  name = "grab-site-${version}";

  src = fetchFromGitHub {
    rev = version;
    owner = "ArchiveTeam";
    repo = "grab-site";
    sha256 = "1v1hnhv5knzdl0kj3574ccwlh171vcb7faddp095ycdmiiybalk4";
  };

  propagatedBuildInputs = [
    click ludios_wpull manhole lmdb autobahn fb-re2 websockets cchardet
  ];

  checkPhase = ''
    export PATH=$PATH:$out/bin
    bash ./tests/offline-tests
  '';

  meta = with stdenv.lib; {
    description = "Crawler for web archiving with WARC output";
    homepage = "https://github.com/ArchiveTeam/grab-site";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
    platforms = platforms.all;
  };
}
