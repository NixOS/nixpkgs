# TODO: some files are not at the right place.
# For now, we take the strategy of adding symlinks to fix this,
# however it is probably better to extract the files from
# the appropriate debian binary packages.

{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "firmware-linux-nonfree-0.34";

  src = fetchurl {
      url = "mirror://debian/pool/non-free/f/firmware-nonfree/firmware-nonfree_0.34.tar.gz";
      sha256 = "94fe856d00f63559486b7684c0fae9b30bee599c6d7dea8c7e00d2dcb548ee8a";
    };
 
  phases = [ "unpackPhase" "patchPhase" "installPhase" "postInstall" ];

  patchPhase = "rm -rf debian defines TODO";

  installPhase = "ensureDir $out && cp -ra * $out/";

  # repeat the same trick for radeon, 3com, etc.
  postInstall = "ln -s $out/realtek/rtlwifi $out/rtlwifi";

  meta = {
    description = "Non-free kernel firmware (packaged by Debian)";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = "unfree-redistributable-firmware";
    priority = "10";
  };
}

