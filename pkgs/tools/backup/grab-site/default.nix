{ stdenv, python37, fetchFromGitHub }:
let
  python = python37.override {
    self = python;
    packageOverrides = self: super: {
      tornado = super.tornado_4;
    };
  };

in
with python.pkgs; buildPythonApplication rec {
  pname = "grab-site";
  version = "2.2.0";

  src = fetchFromGitHub {
    rev = version;
    owner = "ArchiveTeam";
    repo = "grab-site";
    sha256 = "1jxcv9dral6h7vfpfqkp1yif6plj0vspzakymkj8hfl75nh0wpv8";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"wpull @ https://github.com/ArchiveTeam/ludios_wpull/tarball/master#egg=wpull-3.0.7"' '"wpull"'
  '';

  propagatedBuildInputs = [
    click
    ludios_wpull
    manhole
    lmdb
    autobahn
    fb-re2
    websockets
    cchardet
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
