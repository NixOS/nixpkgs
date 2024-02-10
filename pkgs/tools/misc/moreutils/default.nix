{ lib
, stdenv
, fetchgit
, libxml2
, libxslt
, docbook-xsl
, docbook_xml_dtd_44
, perlPackages
, makeWrapper
, perl # for pod2man
, darwin
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "moreutils";
  version = "0.68";

  src = fetchgit {
    url = "git://git.joeyh.name/moreutils";
    rev = "refs/tags/${version}";
    hash = "sha256-kOY12oejH0xKaaPrKem+l0PACqyPqD4P1jEjOYfNntM=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /usr/share/xml/docbook/stylesheet/docbook-xsl ${docbook-xsl}/xml/xsl/docbook
  '';

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper perl libxml2 libxslt docbook-xsl docbook_xml_dtd_44 ];
  buildInputs = lib.optional stdenv.isDarwin darwin.cctools;

  propagatedBuildInputs = with perlPackages; [ perl IPCRun TimeDate TimeDuration ];

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/chronic --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/ts --prefix PERL5LIB : $PERL5LIB
  '';

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "git://git.joeyh.name/moreutils";
  };

  meta = with lib; {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young";
    homepage = "https://joeyh.name/code/moreutils/";
    maintainers = with maintainers; [ koral pSub ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
