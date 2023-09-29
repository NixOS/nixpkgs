{ lib
, fetchFromGitHub
, perlPackages
}:

perlPackages.buildPerlPackage rec {
  pname = "shelldap";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "mahlonsmith";
    repo = "shelldap";
    rev = "refs/tags/v${version}";
    hash = "sha256-67ttAXzu9pfeqjfhMfLMb9vWCXTrE+iUDCbamqswaLg=";
  };

  buildInputs = with perlPackages; [
    AlgorithmDiff
    AuthenSASL
    IOSocketSSL
    perl
    perlldap
    TermReadLineGnu
    TermShell
    TieIxHash
    YAMLSyck
  ];

  prePatch = ''
    touch Makefile.PL
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin shelldap
    runHook preInstall
  '';

  # no make target 'test', not tests provided by source
  doCheck = false;

  outputs = [ "out" ];

  meta = with lib; {
    homepage = "https://github.com/mahlonsmith/shelldap/";
    description = "A handy shell-like interface for browsing LDAP servers and editing their content";
    changelog = "https://github.com/mahlonsmith/shelldap/blob/v${version}/CHANGELOG";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ clerie tobiasBora ];
    platforms = platforms.linux;
  };
}
