{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "rt2860-fw-26";
  src = fetchurl {
    url = "http://www.ralinktech.com/download.php?t=U0wyRnpjMlYwY3k4eU1ERXdMekF6THpNeEwyUnZkMjVzYjJGa01UWTBNamsyTVRBNE1pNTZhWEE5UFQxU1ZESTROakJmUm1seWJYZGhjbVZmVmpJMkM%3D";
    name = "RT2860_Firmware_V26.zip";
    sha256 = "0kvjd8kfnmh8jj35jd10pnr1z7a00ks4c317dnnzgkd86mmcg4px";
  };

  buildInputs = [ unzip ];
  
  buildPhase = "true";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "ensureDir $out/${name}; cp *.bin $out; cp *.txt $out/${name}";
  
  meta = {
    description = "Firmware for the Ralink RT2860 wireless cards";
    homepage = http://www.ralinktech.com/;
    license = "non-free";
  };
}
