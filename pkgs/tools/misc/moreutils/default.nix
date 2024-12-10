{
  lib,
  stdenv,
  fetchgit,
  libxml2,
  libxslt,
  docbook-xsl,
  docbook_xml_dtd_44,
  perlPackages,
  makeWrapper,
  perl, # for pod2man
  cctools,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "moreutils";
  version = "0.69";

  src = fetchgit {
    url = "git://git.joeyh.name/moreutils";
    rev = "refs/tags/${version}";
    hash = "sha256-hVvRAIXlG8+pAD2v/Ma9Z6EUL/1xIRz7Gx1fOxoQyi0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    makeWrapper
    perl
    libxml2
    libxslt
    docbook-xsl
    docbook_xml_dtd_44
  ];
  buildInputs =
    [
      (perl.withPackages (p: [
        p.IPCRun
        p.TimeDate
        p.TimeDuration
      ]))
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
    ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "DOCBOOKXSL=${docbook-xsl}/xml/xsl/docbook"
    "INSTALL_BIN=install"
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "git://git.joeyh.name/moreutils";
  };

  meta = with lib; {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young";
    homepage = "https://joeyh.name/code/moreutils/";
    maintainers = with maintainers; [
      koral
      pSub
    ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
