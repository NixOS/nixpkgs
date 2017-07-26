{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nuttcp-${version}";
  version = "8.1.4";

  src = fetchurl {
    urls = [
      "http://nuttcp.net/nuttcp/latest/${name}.c"
      "http://nuttcp.net/nuttcp/${name}/${name}.c"
      "http://nuttcp.net/nuttcp/beta/${name}.c"
    ];
    sha256 = "1mygfhwxfi6xg0iycivx98ckak2abc3vwndq74278kpd8g0yyqyh";
  };

  man = fetchurl {
    url = "http://nuttcp.net/nuttcp/${name}/nuttcp.8";
    sha256 = "1yang94mcdqg362qbi85b63746hk6gczxrk619hyj91v5763n4vx";
  };

  unpackPhase = ":";

  buildPhase = ''
    cc -O2 -o nuttcp $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nuttcp $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Network performance measurement tool";
    longDescription = ''
      nuttcp is a network performance measurement tool intended for use by
      network and system managers. Its most basic usage is to determine the raw
      TCP (or UDP) network layer throughput by transferring memory buffers from
      a source system across an interconnecting network to a destination
      system, either transferring data for a specified time interval, or
      alternatively transferring a specified number of bytes. In addition to
      reporting the achieved network throughput in Mbps, nuttcp also provides
      additional useful information related to the data transfer such as user,
      system, and wall-clock time, transmitter and receiver CPU utilization,
      and loss percentage (for UDP transfers).
    '';
    license = licenses.gpl2;
    homepage = http://nuttcp.net/;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
}
