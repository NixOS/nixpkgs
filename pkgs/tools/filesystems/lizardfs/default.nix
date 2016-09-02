{ stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, python
, fuse
, asciidoc
, libxml2
, libxslt
, docbook_xml_dtd_412
, docbook_xsl
, boost
, pkgconfig
, judy
, pam
, zlib # optional
}:

stdenv.mkDerivation rec {
  name = "lizardfs-${version}";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "lizardfs";
    repo = "lizardfs";
    rev = "v.${version}";
    sha256 = "18p2pj9crjqgxxxzdfcs3j3fqhinmwi7qxcf71jsw17syqwyygh8";
  };

  buildInputs = 
    [ cmake fuse asciidoc libxml2 libxslt docbook_xml_dtd_412 docbook_xsl
      zlib boost pkgconfig judy pam makeWrapper
    ];

  patches = [ ./412.patch ];

  postInstall = ''
    wrapProgram $out/sbin/lizardfs-cgiserver \
        --prefix PATH ":" "${python}/bin"

    # mfssnapshot and mfscgiserv are deprecated
    rm $out/bin/mfssnapshot $out/sbin/mfscgiserv
  '';

  meta = with stdenv.lib; {
    homepage = https://lizardfs.com;
    description = "A highly reliable, scalable and efficient distributed file system";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.rushmorem ];
  };
}
