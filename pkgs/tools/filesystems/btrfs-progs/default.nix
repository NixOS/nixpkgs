{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, pkg-config
, attr
, acl
, zlib
, libuuid
, e2fsprogs
, lzo
, asciidoc
, xmlto
, docbook_xml_dtd_45
, docbook_xsl
, libxslt
, zstd
, python3
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "5.12.1";

  src = fetchFromGitHub {
    owner = "kdave";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rC9X4XzmT6PUDCajLkhuG85nRjJTqQ4mvevF4HWgHNE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
    python3
    python3.pkgs.setuptools
  ];

  buildInputs = [ attr acl zlib libuuid e2fsprogs lzo zstd python3 ];

  # for python cross-compiling
  _PYTHON_HOST_PLATFORM = stdenv.hostPlatform.config;

  preConfigure = ''
    sh autogen.sh
  '';

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/share/bash-completion/completions/btrfs
  '';

  configureFlags = lib.optional stdenv.hostPlatform.isMusl "--disable-backtrace";

  meta = with lib; {
    description = "Utilities for the btrfs filesystem";
    homepage = "https://btrfs.wiki.kernel.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
