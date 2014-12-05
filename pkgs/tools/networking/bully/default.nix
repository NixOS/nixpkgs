{stdenv, fetchurl, openssl, libpcap}:

stdenv.mkDerivation rec {
  name = "bully-${version}";
  version = "1.0-22";
  src = fetchurl {
    url = "https://github.com/bdpurcell/bully/archive/v${version}.tar.gz";
    sha256 = "72f568f659fdcf70455a17f91f25dde65a53431c67c796517d3d3c4a4703ab68";
  };
  buildInputs = [ openssl libpcap ];

  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bully $out/bin
  '';

  meta = {
    description = "Retrieve WPA/WPA2 passphrase from a WPS enabled access point";
    homepage = https://github.com/bdpurcell/bully;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    license = stdenv.lib.licenses.gpl3;
  };
}