{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, python3
, db
, fuse
, asciidoc
, libxml2
, libxslt
, docbook_xml_dtd_412
, docbook_xsl
, boost
, pkg-config
, judy
, pam
, spdlog
, fmt
, systemdMinimal
, zlib # optional
}:

stdenv.mkDerivation rec {
  pname = "lizardfs";
  version = "3.13.0-rc3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-rgaFhJvmA1RVDL4+vQLMC0GrdlgUlvJeZ5/JJ67C20Q=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [
    db fuse asciidoc libxml2 libxslt docbook_xml_dtd_412 docbook_xsl
    zlib boost judy pam spdlog fmt python3 systemdMinimal
  ];

  meta = with lib; {
    homepage = "https://lizardfs.com";
    description = "A highly reliable, scalable and efficient distributed file system";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem shamilton ];
    # 'fprintf' was not declared in this scope
    broken = true;
  };
}
