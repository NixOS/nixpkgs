{ stdenv, fetchFromGitHub, pkgconfig
, asciidoc, docbook_xsl, fuse, libuuid, libxslt }:

stdenv.mkDerivation rec {
  name = "vmfs-tools";

  src = fetchFromGitHub {
    owner  = "glandium";
    repo   = "vmfs-tools";
    rev    = "4ab76ef5b074bdf06e4b518ff6d50439de05ae7f";
    sha256 = "14y412ww5hxk336ils62s3fwykfh6mx1j0iiaa5cwc615pi6qvi4";
  };

  nativeBuildInputs = [ asciidoc docbook_xsl fuse libuuid libxslt pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/glandium/vmfs-tools;
    description = "FUSE-based VMFS (vmware) mounting tools";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
