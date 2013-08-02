{ stdenv, fetchurl, disnix, socat, pkgconfig }:

stdenv.mkDerivation {
  name = "disnixos-0.2pre77208b9bf296b2376bd95154b333db304b50bec0.tar.gz";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/5578534/download/3/disnixos-0.2pre77208b9bf296b2376bd95154b333db304b50bec0.tar.gz;
    sha256 = "0a9ah16rhq6kgknylq9dsv6mk8pp4vbahqls9hcg99ys9bn18d8z";
  };
  
  buildInputs = [ socat pkgconfig disnix ];
  
  dontStrip = true;
  
  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
