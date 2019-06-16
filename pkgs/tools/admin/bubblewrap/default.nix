{ stdenv, fetchurl, libxslt, docbook_xsl, libcap, fetchpatch }:

stdenv.mkDerivation rec {
  name = "bubblewrap-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1y2bdlxnlr84xcbf31lzirc292c5ak9bd2wvcvh4ppsliih6pjny";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/projectatomic/bubblewrap/commit/efc89e3b939b4bde42c10f065f6b7b02958ed50e.patch";
      name = "CVE-2019-12439.patch";
      sha256 = "1p2w0ixrr3aca6i26ckmlq8ini4a6kgq53r9f98f7ghvbdlp4dkg";
    })
  ];

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
