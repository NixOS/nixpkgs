{
  pkgs,
  lib,
  fetchurl,
  fetchpatch,
  perlPackages,
  rsync,
  which,
  installShellFiles,
  ...
}:
perlPackages.buildPerlPackage rec {
  pname = "Rex";
  version = "1.14.3";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FE/FERKI/Rex-${version}.tar.gz";
    hash = "sha256-An0wQu+UC2dZDlmJ6W8irh5nunRIlcXdPbVpwFE3Alw=";
  };

  buildInputs = with perlPackages; [
    FileShareDirInstall
    ParallelForkManager
    StringEscape
    TestDeep
    TestOutput
    TestWarnings
    TestUseAllModules
    TestException
    SubOverride

    rsync
    which
  ];

  # These are part of a greater effort to add better support upstream:
  # https://github.com/RexOps/Rex/compare/master...nixos
  patches = [
    # Fix rex's ability to execute things on NixOS managed hosts
    (fetchpatch {
      url = "https://github.com/RexOps/Rex/commit/c71f3b255dac8f929abea46913798f132566af55.patch";
      hash = "sha256-S2tF3IZ96QrxDN3HfBk7RWDZcEwukQYAkSId51dATiU=";
    })
    # Fix explicit calls to /bin/mv and /bin/rm
    (fetchpatch {
      url = "https://github.com/RexOps/Rex/commit/2782e80bb9789d3afb42e08904c28a4366a58334.patch";
      hash = "sha256-htm39fF2tumG5b5E1ZBRX5n3vRaZZZzn2lfSN1omP8s=";
    })
    # Fix for PATH assumptions
    (fetchpatch {
      url = "https://github.com/RexOps/Rex/commit/ec72c8d1fdddf9116afdb21091100fe7cc20f41a.patch";
      hash = "sha256-a/Sns2f596dbAWbuIveNldc/V3MwR08/ocXVgx0Tbcw=";
    })
    # Fix explicit path in Sudo.pm
    (fetchpatch {
      url = "https://github.com/RexOps/Rex/commit/f0b312f42178e7e4271b5b010c00efb5cdba2970.patch";
      hash = "sha256-n/+huVCM8zpgx2LZgMB41PPIYgNhF6AK8+4FGPQH+FU=";
    })
  ];

  nativeBuildInputs = with perlPackages; [
    installShellFiles
    ParallelForkManager
  ];

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

  outputs = [ "out" ];

  postPatch = ''
    patchShebangs bin
  '';

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
