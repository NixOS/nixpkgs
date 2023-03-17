{ lib, python38, fetchFromGitHub }:
let
  python = python38.override {
    self = python;
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
      });
      tornado = super.tornado_4;
    };
  };

in
with python.pkgs; buildPythonApplication rec {
  pname = "grab-site";
  version = "2.2.7";

  src = fetchFromGitHub {
    rev = version;
    owner = "ArchiveTeam";
    repo = "grab-site";
    sha256 = "sha256-tf8GyFjya3+TVc2VjlY6ztfjCJgof6tg4an18pz+Ig8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"wpull @ https://github.com/ArchiveTeam/ludios_wpull/tarball/master#egg=wpull-${ludios_wpull.version}"' '"wpull"'
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

  meta = with lib; {
    description = "Crawler for web archiving with WARC output";
    homepage = "https://github.com/ArchiveTeam/grab-site";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
    platforms = platforms.all;
  };
}
