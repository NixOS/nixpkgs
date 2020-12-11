{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, python2
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
, spdlog
, fmt
, zlib # optional
}:

stdenv.mkDerivation rec {
  pname = "lizardfs";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0zk73wmx82ari3m2mv0zx04x1ggsdmwcwn7k6bkl5c0jnxffc4ax";
  };

  patches = [
    # Use system-provided spdlog instead of downloading an old one (next two patches)
    (fetchpatch {
      url = "https://salsa.debian.org/debian/lizardfs/raw/d003c371/debian/patches/system-spdlog.patch";
      sha256 = "1znpqqzb0k5bb7s4d7abfxzn5ry1khz8r76sb808c95cpkw91a9i";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/lizardfs/raw/bfcd5bcf/debian/patches/spdlog.patch";
      sha256 = "0j44rb816i6kfh3y2qdha59c4ja6wmcnlrlq29il4ybxn42914md";
    })
    # Fix https://github.com/lizardfs/lizardfs/issues/655
    # (Remove upon update to 3.13)
    (fetchpatch {
      url = "https://github.com/lizardfs/lizardfs/commit/5d20c95179be09241b039050bceda3c46980c004.patch";
      sha256 = "185bfcz2rjr4cnxld2yc2nxwzz0rk4x1fl1sd25g8gr5advllmdv";
    })
    # Add SPDLOG_FMT_EXTERNAL flag to disable spdlog from using bundled fmt
    # Would use https://github.com/lizardfs/lizardfs/commit/31b0cd40f84ee75f99643ad19122061e3d6fb6cc.patch
    # if it didn't failed to patch
    ./cmake-def-spdlog-fmt-external.patch
  ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs =
  [ db fuse asciidoc libxml2 libxslt docbook_xml_dtd_412 docbook_xsl
    zlib boost judy pam spdlog fmt python2
  ];
  
  cmakeFlags = [ "-DSPDLOG_FMT_EXTERNAL=ON" ];

  meta = with stdenv.lib; {
    homepage = "https://lizardfs.com";
    description = "A highly reliable, scalable and efficient distributed file system";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem shamilton ];
  };
}
