{ stdenv
, fetchFromGitHub
, pkgconfig
, asciidoc
, docbook_xsl
, fuse
, libuuid
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "vmfs-tools";
  version = "0.2.5.20160116";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = pname;
    rev = "4ab76ef5b074bdf06e4b518ff6d50439de05ae7f";
    sha256 = "14y412ww5hxk336ils62s3fwykfh6mx1j0iiaa5cwc615pi6qvi4";
  };

  nativeBuildInputs = [ asciidoc docbook_xsl libxslt pkgconfig ];

  buildInputs = [ fuse libuuid ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} AUTHORS LICENSE README TODO
  '';

  meta = with stdenv.lib; {
    description = "FUSE-based VMFS (vmware) file system tools";
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.gpl2;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
