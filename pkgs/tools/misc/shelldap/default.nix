{ lib, fetchurl, perlPackages }:
perlPackages.buildPerlPackage rec {
  pname = "shelldap";
  version = "1.4.0";
  src = fetchurl {
    url = "https://bitbucket.org/mahlon/shelldap/downloads/shelldap-${version}.tar.gz";
    sha256 = "07gkvvxcgw3pgkfy8p9mmidakciaq1rsq5zhmdqd8zcwgqkrr24i";
  };
  buildInputs = with perlPackages; [ perl YAMLSyck perlldap AlgorithmDiff IOSocketSSL AuthenSASL TermReadLineGnu TermShell ];
  prePatch = ''
    touch Makefile.PL
  '';
  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin shelldap
    runHook preInstall
  '';
  outputs = [ "out" ];
  meta = with lib; {
    homepage = "https://bitbucket.org/mahlon/shelldap/";
    description = "A handy shell-like interface for browsing LDAP servers and editing their content";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ tobiasBora ];
    platforms = platforms.linux;
  };
}
