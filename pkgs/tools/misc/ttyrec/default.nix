{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ttyrec";
  version = "1.0.8";

  src = fetchurl {
    url = "http://0xcc.net/ttyrec/${pname}-${version}.tar.gz";
    sha256 = "ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec";
  };

  patches = [ ./clang-fixes.patch ];

  makeFlags = stdenv.lib.optional stdenv.buildPlatform.isLinux "CFLAGS=-DSVR4"
    ++ stdenv.lib.optional stdenv.cc.isClang "CC=clang";

  installPhase = ''
    mkdir -p $out/{bin,man}
    cp ttytime ttyplay ttyrec $out/bin
    cp *.1 $out/man
  '';

  meta = with stdenv.lib; {
    homepage = http://0xcc.net/ttyrec/;
    description = "Terminal interaction recorder and player";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zimbatm ];
    broken = true; # 2020-01-28
  };
}
