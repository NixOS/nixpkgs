{stdenv, fetchurl, python}:

stdenv.mkDerivation rec {
  name = "disper-0.3.0";

  buildInputs = [python];

  preConfigure = ''
    export makeFlags="PREFIX=$out"
  '';

  src = fetchurl {
    url = http://ppa.launchpad.net/disper-dev/ppa/ubuntu/pool/main/d/disper/disper_0.3.0.tar.gz;
    sha256 = "1mfqidm5c89nknzksabqgjygdp57xpszz7hy2dxh39hpgrsk3l58";
  };

  meta = {
    description = "Disper is an on-the-fly display switch utility.";
    homepage = http://willem.engen.nl/projects/disper/;
  };

}
