{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "squashfs-3.3";

  src = fetchurl {
    url = mirror://sourceforge/squashfs/squashfs3.3.tgz;
    sha256 = "1j55m26nyvlbld4yxad0r6s1f4rdw9yg89y2gv93ihkx3rx048w4";
  };
  
  buildInputs = [zlib];

  preBuild = ''
    cd squashfs-tools
  '';

  installPhase = ''
    ensureDir $out/sbin
    cp mksquashfs $out/sbin
    cp unsquashfs $out/sbin
  '';
}
