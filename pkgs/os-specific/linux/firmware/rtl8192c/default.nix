{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "rtl8192c-fw";
  src = fetchurl {
    url = "ftp://WebUser:AxPL9s3k@202.134.71.21/cn/wlan/92ce_se_de_linux_mac80211_0004.0816.2011.tar.gz";
    sha256 = "1kg63h5rj4kja2csmqsrxjipb1wpznfbrvn9cla9d9byksy5fn64";
  };

  phases = [ "unpackPhase" "installPhase" ];

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "ensureDir $out; cp -a firmware/* $out";
  
  meta = {
    description = "Firmware for the Realtek RTL8192c wireless cards";
    homepage = "http://www.realtek.com";
    license = "non-free";
  };
}
