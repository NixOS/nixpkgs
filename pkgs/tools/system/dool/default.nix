{ lib
, stdenv
, fetchFromGitHub
, python3
}:

stdenv.mkDerivation rec {
  pname = "dool";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "scottchiefbaker";
    repo = "dool";
    rev = "v${version}";
    hash = "sha256-G9mcvUPGQw+0AtvlHdnnfAmcZtcUH/Sc77UVeA/FYZc=";
  };

  buildInputs = [
    python3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  # fix the plugins directory
  postPatch = ''
    substituteInPlace dool \
      --replace \
        "os.path.abspath(os.path.dirname(sys.argv[0])) + '/plugins/'" \
        "'$out/share/dool/'"
  '';

  meta = with lib; {
    description = "Python3 compatible clone of dstat";
    homepage = "https://github.com/scottchiefbaker/dool";
    changelog = "https://github.com/scottchiefbaker/dool/blob/${src.rev}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
    mainProgram = "dool";
  };
}
