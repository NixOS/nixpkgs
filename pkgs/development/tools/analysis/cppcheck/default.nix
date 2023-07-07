{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, pcre
, python3
, libxslt
, docbook_xsl
, docbook_xml_dtd_45
, which
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "cppcheck";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "danmar";
    repo = "cppcheck";
    rev = version;
    hash = "sha256-Zu1Ly5KsgmjtsVQlBzgB/h+varfkyB73t8bxzqB3a3M=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config installShellFiles libxslt docbook_xsl docbook_xml_dtd_45 which python3 ];
  buildInputs = [ pcre (python3.withPackages (ps: [ps.pygments])) ];

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

  meta = with lib; {
    description = "A static analysis tool for C/C++ code";
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching allocation-deallocation,
      buffer overruns and more.
    '';
    homepage = "http://cppcheck.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
