{ stdenv
, fetchzip
, fetchFromGitHub
, cmake
, makeWrapper
, python
, db
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

let
  # See https://github.com/lizardfs/lizardfs/blob/3.12/cmake/Libraries.cmake
  # We have to download it ourselves, as the build script normally does a download
  # on-build, which is not good
  spdlog = fetchzip {
    name = "spdlog-0.14.0";
    url = "https://github.com/gabime/spdlog/archive/v0.14.0.zip";
    sha256 = "13730429gwlabi432ilpnja3sfvy0nn2719vnhhmii34xcdyc57q";
  };
in stdenv.mkDerivation rec {
  name = "lizardfs-${version}";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "lizardfs";
    repo = "lizardfs";
    rev = "v${version}";
    sha256 = "0zk73wmx82ari3m2mv0zx04x1ggsdmwcwn7k6bkl5c0jnxffc4ax";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs =
    [ db fuse asciidoc libxml2 libxslt docbook_xml_dtd_412 docbook_xsl
      zlib boost judy pam
    ];

  patches = [
    ./remove-download-external.patch
  ];

  postUnpack = ''
    mkdir $sourceRoot/external/spdlog-0.14.0
    cp -R ${spdlog}/* $sourceRoot/external/spdlog-0.14.0/
    chmod -R 755 $sourceRoot/external/spdlog-0.14.0/
  '';

  postInstall = ''
    wrapProgram $out/sbin/lizardfs-cgiserver \
        --prefix PATH ":" "${python}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://lizardfs.com;
    description = "A highly reliable, scalable and efficient distributed file system";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.rushmorem ];
  };
}
