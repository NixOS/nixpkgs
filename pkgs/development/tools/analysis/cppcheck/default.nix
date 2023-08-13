{ docbook_xsl
, docbook_xml_dtd_45
, fetchFromGitHub
, installShellFiles
, lib
, libxslt
, pcre
, pkg-config
, python3
, stdenv
, which
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppcheck";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "danmar";
    repo = "cppcheck";
    rev = finalAttrs.version;
    hash = "sha256-ZQ1EgnC2JBc0AvSW8PtgMzJoWSPt04Xfh8dqOU+KMfw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    docbook_xsl
    docbook_xml_dtd_45
    installShellFiles
    libxslt
    pkg-config
    python3
    which
  ];

  buildInputs = [
    pcre
    (python3.withPackages (ps: [ ps.pygments ]))
  ];

  makeFlags = [ "PREFIX=$(out)" "MATCHCOMPILER=yes" "FILESDIR=$(out)/share/cppcheck" "HAVE_RULES=yes" ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'PCRE_CONFIG = $(shell which pcre-config)' 'PCRE_CONFIG = $(PKG_CONFIG) libpcre'
  '';

  postBuild = ''
    make DB2MAN=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl man
  '';

  postInstall = ''
    installManPage cppcheck.1
  '';

  # test/testcondition.cpp:4949(TestCondition::alwaysTrueContainer): Assertion failed.
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo 'int main() {}' > ./installcheck.cpp
    $out/bin/cppcheck ./installcheck.cpp > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "A static analysis tool for C/C++ code";
    homepage = "http://cppcheck.sourceforge.net/";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching allocation-deallocation,
      buffer overruns and more.
    '';
    maintainers = with lib.maintainers; [ joachifm ];
    platforms = lib.platforms.unix;
  };
})
