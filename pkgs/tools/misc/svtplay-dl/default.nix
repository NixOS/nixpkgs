{ stdenv, fetchFromGitHub, makeWrapper, python, perl, zip
, rtmpdump, nose, mock, pycrypto, requests2, substituteAll }:

stdenv.mkDerivation rec {
  name = "svtplay-dl-${version}";
  version = "0.30.2016.02.08";

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
    sha256 = "0nkgc43lf06h0w8k4zm5pdzp6r6jjc6j94ciljcm8333n0ykfzpr";
  };

  pythonPaths = [ pycrypto requests2 ];
  buildInputs = [ python perl nose mock rtmpdump makeWrapper ] ++ pythonPaths;
  nativeBuildInputs = [ zip ];

  postPatch = ''
    substituteInPlace lib/svtplay_dl/fetcher/rtmp.py \
      --replace '"rtmpdump"' '"${rtmpdump}/bin/rtmpdump"'

    substituteInPlace run-tests.sh \
      --replace 'PYTHONPATH=lib' 'PYTHONPATH=lib:$PYTHONPATH'
  '';

  makeFlags = "PREFIX=$(out) SYSCONFDIR=$(out)/etc PYTHON=${python}/bin/python";

  postInstall = ''
    wrapProgram "$out/bin/svtplay-dl" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  doCheck = true;
  checkPhase = "sh run-tests.sh -2";

  meta = with stdenv.lib; {
    homepage = https://github.com/spaam/svtplay-dl;
    description = "Command-line tool to download videos from svtplay.se and other sites";
    license = licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
