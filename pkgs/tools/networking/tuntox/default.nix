{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, libtoxcore, libsodium, libevent }:

stdenv.mkDerivation rec {
  name = "tuntox-${version}";
  version = "0.0.8";

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libtoxcore
    libsodium
    libevent
  ];

  src = fetchFromGitHub {
    owner = "gjedeer";
    repo = "tuntox";
    rev = "${version}";
    sha256 = "1vm34w6jxg5vhzk2lzpmv6s0182l4ic8ic9kq6x2l84m78i0wjm9";
  };

  makeFlags = "tuntox_nostatic";

  installPhase = ''
    install -m755 -D tuntox_nostatic "$out/bin/tuntox"
    install -m755 -D scripts/tokssh "$out/bin/tokssh"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tunnel TCP connections over the Tox protocol";
    longDescription = ''
      Tuntox is a program which forwards TCP connections over the Tox protocol.
      This allows low-latency access to distant machines behind a NAT you can't
      control or with a dynamic IP address.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fgaz ];
    homepage = https://github.com/gjedeer/tuntox;
  };
}
