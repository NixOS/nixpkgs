{ stdenv, fetchgit, openssl }:

let
  version = "4.0.0";

in stdenv.mkDerivation rec {
  name = "wrk-${version}";

  src = fetchgit {
    url = "https://github.com/wg/wrk.git";
    rev = "7cdede916a53da253c995767a92eec36a245a2cc";
    sha256 = "0m8i5pk2rj40v28bzrskkzw54v9jqdby52dwfcypannhlhgqnhy2";
  };

  buildInputs = [ openssl ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp wrk $out/bin
  '';
  
  meta = with stdenv.lib; {
    description = "HTTP benchmarking tool";
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
