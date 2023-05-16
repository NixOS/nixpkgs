<<<<<<< HEAD
{ docbook_xml_dtd_45
, docbook_xsl
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
  version = "2.12.0";

  outputs = [ "out" "man" ];
=======
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
  version = "2.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "danmar";
    repo = "cppcheck";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-Rfm63ERmTsmmH8W6aiBMx+NiQjzGuoWHqHRRqWishhw=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
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

  enableParallelBuilding = true;
  strictDeps = true;

  # test/testcondition.cpp:4949(TestCondition::alwaysTrueContainer): Assertion failed.
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);
  doInstallCheck = true;
=======
    rev = version;
    hash = "sha256-M63uHhyEDmuWrEu7Y3Zks1Eq5WgenSlqWln2DMBj3fU=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config installShellFiles libxslt docbook_xsl docbook_xml_dtd_45 which python3 ];
  buildInputs = [ pcre (python3.withPackages (ps: [ps.pygments])) ];

  makeFlags = [ "PREFIX=$(out)" "MATCHCOMPILER=yes" "FILESDIR=$(out)/share/cppcheck" "HAVE_RULES=yes" ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
=======
  # test/testcondition.cpp:4949(TestCondition::alwaysTrueContainer): Assertion failed.
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  doInstallCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installCheckPhase = ''
    runHook preInstallCheck

    echo 'int main() {}' > ./installcheck.cpp
    $out/bin/cppcheck ./installcheck.cpp > /dev/null

    runHook postInstallCheck
  '';

<<<<<<< HEAD
  meta = {
    description = "A static analysis tool for C/C++ code";
    homepage = "http://cppcheck.sourceforge.net";
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "A static analysis tool for C/C++ code";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching allocation-deallocation,
      buffer overruns and more.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ joachifm paveloom ];
    platforms = lib.platforms.unix;
  };
})
=======
    homepage = "http://cppcheck.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
