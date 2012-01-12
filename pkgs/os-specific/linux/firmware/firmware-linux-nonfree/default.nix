{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "firmware-linux-nonfree-0.34";

  src = fetchurl {
      url = "mirror://debian/pool/non-free/f/firmware-nonfree/firmware-nonfree_0.34.tar.gz";
      sha256 = "94fe856d00f63559486b7684c0fae9b30bee599c6d7dea8c7e00d2dcb548ee8a";
    };
 
  phases = [ "unpackPhase" "installPhase" "postInstall" ];

  installPhase = "ensureDir $out && cp -ra * $out/";

  postInstall = "ln -s $out/realtek/rtlwifi $out/rtlwifi";

  meta = {
    description = "Non-free kernel firmware (packaged by Debian)";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = "unfree-redistributable-firmware";
    priority = "10";
  };
}

