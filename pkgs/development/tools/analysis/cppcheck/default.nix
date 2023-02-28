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
}:

stdenv.mkDerivation rec {
  pname = "cppcheck";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "danmar";
    repo = "cppcheck";
    rev = version;
    hash = "sha256-tN7MYMRBakdL++ZeY2u9s2B2wyAU7iaOB/hsv2GXI6s=";
  };

  buildInputs = [ pcre (python3.withPackages (ps: [ps.pygments])) ];
  nativeBuildInputs = [ installShellFiles libxslt docbook_xsl docbook_xml_dtd_45 which ];

  makeFlags = [ "PREFIX=$(out)" "MATCHCOMPILER=yes" "FILESDIR=$(out)/share/cppcheck" "HAVE_RULES=yes" ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  postBuild = ''
    make DB2MAN=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl man
  '';

  # test/testcondition.cpp:4949(TestCondition::alwaysTrueContainer): Assertion failed.
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  postInstall = ''
    installManPage cppcheck.1
  '';

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
