{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mmv-${version}";
  version = "1.01b";

  src = fetchurl {
    url = "mirror://debian/pool/main/m/mmv/mmv_${version}.orig.tar.gz";
    sha256 = "0399c027ea1e51fd607266c1e33573866d4db89f64a74be8b4a1d2d1ff1fdeef";
  };

  hardeningDisable = [ "format" ];

  patches = [
    # Use Debian patched version, as upstream is no longer maintained and it
    # contains a _lot_ of fixes.
    (fetchurl {
      url = "mirror://debian/pool/main/m/mmv/mmv_${version}-15.diff.gz";
      sha256 = "9ad3e3d47510f816b4a18bae04ea75913588eec92248182f85dd09bc5ad2df13";
    })
  ];

  postPatch = ''
    sed -i \
      -e 's/^\s*LDFLAGS\s*=\s*-s\s*-N/LDFLAGS = -s/' \
      -e "s|/usr/bin|$out/bin|" \
      -e "s|/usr/man|$out/share/man|" \
      Makefile
  '';

  preInstall = ''
    mkdir -p "$out/bin" "$out/share/man/man1"
  '';

  postInstall = ''
    for variant in mcp mad mln
    do
      ln -s mmv "$out/bin/$variant"
      ln -s mmv.1 "$out/share/man/man1/$variant.1"
    done
  '';

  meta = {
    homepage = http://linux.maruhn.com/sec/mmv.html;
    description = "Utility for wildcard renaming, copying, etc";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
