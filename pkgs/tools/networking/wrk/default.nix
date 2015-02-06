{ stdenv, fetchgit, openssl }:

let
  version = "3.1.2";

in stdenv.mkDerivation rec {
  name = "wrk-${version}";

  src = fetchgit {
    url = "https://github.com/wg/wrk.git";
    rev = "a52c770204a732aa63e1bb6eb241a70949e3a2a9";
    sha256 = "0b81lg251ivi94f7kfgz8ws4xns5p7hw5qiwjwwlc3dimjgrg387";
  };

  NIX_CFLAGS_COMPILE = "-I${openssl}/include";
  NIX_CFLAGS_LINK = "-L${openssl}/lib";

  installPhase = ''
    mkdir -p $out/bin
    cp wrk $out/bin
  '';
  
  meta = with stdenv.lib; {
    description = "HTTP benchmarking tool.";
    homepage = http://github.com/wg/wrk;
    longDescription = ''
      wrk is a modern HTTP benchmarking tool capable of generating
      significant load when run on a single multi-core CPU. It
      combines a multithreaded design with scalable event notification
      systems such as epoll and kqueue.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.linux;
  };
}
