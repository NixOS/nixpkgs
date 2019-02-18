{ lib, python2Packages, libxslt, docbook_xsl_ns, openssh, cacert
# version args
, src, version
}:

python2Packages.buildPythonApplication {
  name = "nixops-${version}";
  inherit version src;

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
      # Go back to sqlite once Python 2.7.13 is released
      pysqlite
      datadog
      digital-ocean
      libvirt
      typing
    ];

  checkPhase =
  # Ensure, that there are no (python) import errors
  ''
    SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt \
    HOME=$(pwd) \
      $out/bin/nixops --version
  '';

  postInstall = ''
    make -C doc/manual install nixops.1 docbookxsl=${docbook_xsl_ns}/xml/xsl/docbook \
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
    maintainers = with lib.maintainers; [ eelco rob domenkozar ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3;
  };
}
