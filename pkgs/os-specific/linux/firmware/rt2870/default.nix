{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "rt2870-fw-22";
  src = fetchurl {
    url = "http://www.ralinktech.com/download.php?t=U0wyRnpjMlYwY3k4eU1ERXdMekF6THpNeEwyUnZkMjVzYjJGa01UWXpPRGs1T0Rnek5pNTZhWEE5UFQxU1ZESTROekJmUm1seWJYZGhjbVZmVmpJeUM%3D";
    name = "RT2870_Firmware_V22.zip";
    sha256 = "d24591a8529b0a609cc3c626ecee96484bb29b2c020260b82f6025459c11f263";
  };

  buildInputs = [ unzip ];
  
  buildPhase = "true";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "mkdir -p $out/${name}; cp *.bin $out; cp *.txt $out/${name}";
  
  meta = {
    description = "Firmware for the Ralink RT2870 wireless cards";
    homepage = http://www.ralinktech.com/;
    license = "non-free";
  };
}
