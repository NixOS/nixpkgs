{ stdenv, fetchurl, makeWrapper, python, perl, zip
, rtmpdump, nose, mock, pycrypto, substituteAll }:

stdenv.mkDerivation rec {
  name = "svtplay-dl-${version}";
  version = "0.10.2015.01.28";

  src = fetchurl {
    url = "https://github.com/spaam/svtplay-dl/archive/${version}.tar.gz";
    sha256 = "0hjqhb4s0qpw2l7azcqmckbdc4mcvczp0w1dfk125n01z0w9c20c";
  };

  pythonPaths = [ pycrypto ];
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
