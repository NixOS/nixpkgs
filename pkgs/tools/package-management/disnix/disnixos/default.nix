{ stdenv, fetchurl, disnix, socat, pkgconfig, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.2preead7dea88dedeb844450afc1f78bb58bd16ac909";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20173386/download/3/disnixos-0.2preead7dea88dedeb844450afc1f78bb58bd16ac909.tar.gz;
    sha256 = "08bkr9lpbfkz0irp4x4v2rgpn6jmm1i6vb29sbnrjdv755yh8q81";
  };
  
  buildInputs = [ socat pkgconfig disnix getopt ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
