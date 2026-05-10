{
  lib,
  stdenv,
  fetchgit,
  libxml2,
  libxslt,
  docbook-xsl,
  docbook_xml_dtd_44,
  makeWrapper,
  parallel, # for its priority
  perl, # for pod2man
  cctools,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "moreutils";
  version = "0.70";

  src = fetchgit {
    url = "git://git.joeyh.name/moreutils";
    tag = version;
    hash = "sha256-71ACHzzk258U4q2L7GJ59mrMZG99M7nQkcH4gHafGP0=";
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
  buildInputs = [
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

  meta = {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young";
    homepage = "https://joeyh.name/code/moreutils/";
    maintainers = with lib.maintainers; [
      koral
      pSub
    ];
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;

    # If somebody explicitly installs GNU parallel, they probably want
    # its parallel executable instead of moreutils'.
    priority = (parallel.meta.priority or lib.meta.defaultPriority) + 1;
  };
}
