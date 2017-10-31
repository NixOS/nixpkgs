{ stdenv, fetchFromGitHub, perl, kmod }:

# Requires the acpi_call kernel module in order to run.
stdenv.mkDerivation rec {
  name = "tpacpi-bat-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "teleshoes";
    repo = "tpacpi-bat";
    rev = "v${version}";
    sha256 = "0wbaz34z99gqx721alh5vmpxpj2yxg3x9m8jqyivfi1wfpwc2nd5";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp tpacpi-bat $out/bin
  '';

  postPatch = ''
    substituteInPlace tpacpi-bat --replace modprobe ${kmod}/bin/modprobe
  '';

  meta = {
    maintainers = [stdenv.lib.maintainers.orbekk];
    platforms = stdenv.lib.platforms.linux;
    description = "Tool to set battery charging thesholds on Lenovo Thinkpad";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
