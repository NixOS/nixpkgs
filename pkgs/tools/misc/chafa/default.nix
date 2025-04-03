{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  autoconf,
  automake,
  libtool,
  pkg-config,
  which,
  libavif,
  libjxl,
  librsvg,
  libxslt,
  libxml2,
  docbook_xml_dtd_412,
  docbook_xsl,
  glib,
  Foundation,
}:

stdenv.mkDerivation rec {
  version = "1.14.5";
  pname = "chafa";

  src = fetchFromGitHub {
    owner = "hpjansson";
    repo = "chafa";
    rev = version;
    sha256 = "sha256-9RkN0yZnHf5cx6tsp3P6jsi0/xtplWxMm3hYCPjWj0M=";
  };

  outputs = [
    "bin"
    "dev"
    "man"
    "out"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    which
    libxslt
    libxml2
    docbook_xml_dtd_412
    docbook_xsl
    installShellFiles
  ];

  buildInputs = [
    glib
    libavif
    libjxl
    librsvg
  ];

  patches = [ ./xmlcatalog_patch.patch ];

  preConfigure = ''
    substituteInPlace ./autogen.sh --replace pkg-config '$PKG_CONFIG'
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--enable-man"
    "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
  ];

  postInstall = ''
    installShellCompletion --cmd chafa tools/completions/zsh-completion.zsh
  '';

  meta = with lib; {
    description = "Terminal graphics for the 21st century";
    homepage = "https://hpjansson.org/chafa/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.mog ];
    mainProgram = "chafa";
  };
}
