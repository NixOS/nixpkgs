{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "snabb-${version}";
  version = "2015.12";

  src = fetchurl {
    url = "https://github.com/SnabbCo/snabbswitch/archive/v${version}.tar.gz";
    sha256 = "1949a6d3hqdr2hdfmrr1na9gvjdwdahadbhmvz2pg7azmpq6ssmr";
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

