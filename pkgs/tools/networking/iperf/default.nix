args: with args;
stdenv.mkDerivation {
  name = "iperf-2.0.4";

  src = args.fetchurl {
    url = http://garr.dl.sourceforge.net/sourceforge/iperf/iperf-2.0.4.tar.gz;
    sha256 = "0i3r75prbyxs56rngjbrag8rg480ki3daaa924krrafng30z2liv";
  };

#buildInputs =(with args; []);

  meta = {
    homepage = ""; 
    description = "tool to measure IP bandwidth using UDP or TCP";
    license = "as-is";
  };
}
