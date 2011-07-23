{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "rtl8192c-fw";
  src = fetchurl {
    url = "ftp://WebUser:n8W9ErCy@208.70.202.219/cn/wlan/92ce_se_de_linux_mac80211_0003.0401.2011.tar.gz";
    sha256 = "002kj6f1xaali2iwrxvirqq0hbiyb2cpf93y2xycp3qd69cp8lik";
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
