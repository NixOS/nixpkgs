{ lib, python2Packages, fetchurl, libxslt, docbook5_xsl, openssh
# version args
, src, version
}:

python2Packages.buildPythonApplication {
  name = "nixops-${version}";
  namePrefix = "";

  src = src;

  buildInputs = [ libxslt ];

  pythonPath = with python2Packages;
    [ prettytable
      boto
      boto3
      hetzner
      libcloud
      azure-storage
      azure-mgmt-compute
      azure-mgmt-network
      azure-mgmt-resource
      azure-mgmt-storage
      adal
      pysqlite  # Go back to builtin sqlite once Python 2.7.13 is released
      datadog
    ];

  doCheck = false;

  postInstall =
    ''
      make -C doc/manual install nixops.1 docbookxsl=${docbook5_xsl}/xml/xsl/docbook \
        docdir=$out/share/doc/nixops mandir=$out/share/man

      mkdir -p $out/share/nix/nixops
      cp -av "nix/"* $out/share/nix/nixops

      # Add openssh to nixops' PATH. On some platforms, e.g. CentOS and RHEL
      # the version of openssh is causing errors when have big networks (40+)
      wrapProgram $out/bin/nixops --prefix PATH : "${openssh}/bin"
    '';

  meta = {
    homepage = https://github.com/NixOS/nixops;
    description = "NixOS cloud provisioning and deployment tool";
    maintainers = [ lib.maintainers.eelco lib.maintainers.rob ];
    platforms = lib.platforms.unix;
  };
}
