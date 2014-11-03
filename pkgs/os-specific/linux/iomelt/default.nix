{ stdenv, lib, fetchurl }:

let version = "0.7";
in stdenv.mkDerivation {
  name = "iomelt-${version}";
  src = fetchurl {
    url = "http://iomelt.com/s/iomelt-${version}.tar.gz";
    sha256 = "1jhrdm5b7f1bcbrdwcc4yzg26790jxl4d2ndqiwd9brl2g5537im";
  };

  preBuild = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    substituteInPlace Makefile \
      --replace /usr $out
  '';

  meta = with lib; {
    description = "A simple yet effective way to benchmark disk IO in Linux systems";
    homepage    = http://www.iomelt.com;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
