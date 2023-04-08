{ pkgs, lib, fetchurl, perlPackages, rsync, installShellFiles, ... }:

perlPackages.buildPerlPackage rec {
  pname = "Rex";
  version = "1.13.4";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FE/FERKI/Rex-${version}.tar.gz";
    sha256 = "a86e9270159b41c9a8fce96f9ddc97c5caa68167ca4ed33e97908bfce17098cf";
  };
  buildInputs = with perlPackages; [
    FileShareDirInstall
    ParallelForkManager
    StringEscape
    TestDeep
    TestOutput
    TestUseAllModules

    rsync
  ];

  nativeBuildInputs = with perlPackages; [ installShellFiles ParallelForkManager ];

  propagatedBuildInputs = with perlPackages; [
    AWSSignature4
    DataValidateIP
    DevelCaller
    DigestHMAC
    FileLibMagic
    HashMerge
    HTTPMessage
    IOPty
    IOString
    JSONMaybeXS
    LWP
    NetOpenSSH
    NetSFTPForeign
    SortNaturally
    TermReadKey
    TextGlob
    URI
    XMLSimple
    YAML
  ];

  doCheck = false;

  outputs = [ "out" ];

  fixupPhase = ''
    for sh in bash zsh; do
      substituteInPlace ./share/rex-tab-completion.$sh \
        --replace 'perl' "${pkgs.perl.withPackages (ps: [ ps.YAML ])}/bin/perl"
    done
    installShellCompletion --name _rex --zsh ./share/rex-tab-completion.zsh
    installShellCompletion --name rex --bash ./share/rex-tab-completion.bash
  '';

  meta = {
    homepage = "https://www.rexify.org";
    description = "The friendly automation framework";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qbit ];
  };
}
