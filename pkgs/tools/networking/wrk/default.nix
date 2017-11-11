{ stdenv, fetchFromGitHub, luajit, openssl, perl }:

stdenv.mkDerivation rec {
  name = "wrk-${version}";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "wg";
    repo = "wrk";
    rev = version;
    sha256 = "1qg6w8xz4pr227h1gxrbm6ylhqvspk95hvq2f9iakni7s56pkh1w";
  };

  buildInputs = [ luajit openssl perl ];

  makeFlags = [ "WITH_LUAJIT=${luajit}" "WITH_OPENSSL=${openssl.dev}" "VER=${version}" ];

  preBuild = ''
    for f in src/*.h; do
      substituteInPlace $f \
        --replace "#include <luajit-2.0/" "#include <"
    done
  '';

  NIX_CFLAGS_COMPILE = [ "-DluaL_reg=luaL_Reg" ]; # needed since luajit-2.1.0-beta3
  
  installPhase = ''
    mkdir -p $out/bin
    cp wrk $out/bin
  '';
  
  meta = with stdenv.lib; {
    description = "HTTP benchmarking tool";
    homepage = https://github.com/wg/wrk;
    longDescription = ''
      wrk is a modern HTTP benchmarking tool capable of generating
      significant load when run on a single multi-core CPU. It
      combines a multithreaded design with scalable event notification
      systems such as epoll and kqueue.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.unix;
  };
}
