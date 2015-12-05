{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "snabb-${version}";
  version = "2015.11";

  src = fetchurl {
    url = "https://github.com/SnabbCo/snabbswitch/archive/v${version}.tar.gz";
    sha256 = "1llyqbjjmh2s23hnx154qj0y6pn5mpxk8qj1fxfpk7dnbq78q601";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp src/snabb $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/SnabbCo/snabbswitch;
    description = "Simple and fast packet networking toolkit";
    longDescription = ''
      Snabb Switch is a LuaJIT-based toolkit for writing high-speed
      packet networking code (such as routing, switching, firewalling,
      and so on). It includes both a scripting inteface for creating
      new applications and also some built-in applications that are
      ready to run.
      It is especially intended for ISPs and other network operators.
    '';
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = [ maintainers.lukego ];
  };
}

