{ stdenv, fetchgit, perl, kmod }:

# Requires the acpi_call kernel module in order to run.
stdenv.mkDerivation rec {
  name = "tpacpi-bat";

  src = fetchgit {
    url = "https://github.com/teleshoes/tpacpi-bat.git";
    rev = "06ec1d5c7e0766b43b5acb98dd61aa96360da6be";
    sha256 = "0l72qvjk5j7sg9x4by7an0xwx65x10dx82fky8lnwlwfv54vgg8l";
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
