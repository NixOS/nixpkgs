{ stdenv, fetchFromGitHub, makeWrapper, pythonPackages, perl, zip
, rtmpdump, substituteAll }:

let
  inherit (pythonPackages) python nose pycrypto requests mock;
in stdenv.mkDerivation rec {
  name = "svtplay-dl-${version}";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
    sha256 = "1iam2pdcrlpcgk2hx3m7zawznp2p939xdv8cpll6sd6n0l4hpdc9";
  };

  pythonPaths = [ pycrypto requests ];
  buildInputs = [ python perl nose mock rtmpdump makeWrapper ] ++ pythonPaths;
  nativeBuildInputs = [ zip ];

  postPatch = ''
    substituteInPlace lib/svtplay_dl/fetcher/rtmp.py \
      --replace '"rtmpdump"' '"${rtmpdump}/bin/rtmpdump"'

    substituteInPlace scripts/run-tests.sh \
      --replace 'PYTHONPATH=lib' 'PYTHONPATH=lib:$PYTHONPATH'
  '';

  makeFlags = "PREFIX=$(out) SYSCONFDIR=$(out)/etc PYTHON=${python.interpreter}";

  postInstall = ''
    wrapProgram "$out/bin/svtplay-dl" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  doCheck = true;
  checkPhase = ''
    sed -i "/def test_parse_m3u8/i\\
        @unittest.skip('requires internet')" lib/svtplay_dl/tests/hls.py

    sh scripts/run-tests.sh -2
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/spaam/svtplay-dl;
    description = "Command-line tool to download videos from svtplay.se and other sites";
    license = licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
