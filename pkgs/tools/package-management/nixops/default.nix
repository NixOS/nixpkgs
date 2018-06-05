{ lib, buildPythonApplication, fetchurl, libxslt, docbook5_xsl, openssh
, prettytable, boto, boto3, hetzner, libcloud, azure-storage, azure-mgmt-compute, azure-mgmt-network, azure-mgmt-resource, azure-mgmt-storage, adal, libvirt, pysqlite, datadog, digital-ocean
, nose, coverage
, cacert
, enableDoc ? false
}:

buildPythonApplication rec {
  pname = "nixops";
  version = "1.6";

  src = fetchurl {
    url = "http://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "0f8ql1a9maf9swl8q054b1haxqckdn78p2xgpwl7paxc98l67i7x";
  };

  postPatch = ''
    for i in scripts/nixops setup.py doc/manual/manual.xml; do
      substituteInPlace $i --subst-var-by version ${version}
    done
  '';


  buildInputs = lib.optionals enableDoc [ libxslt docbook5_xsl ];

  pythonPath = [
    prettytable
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
    ];

  checkInputs = [ nose coverage ];

  doCheck = true;

  # Needed by libcloud during tests
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  shellHook = ''
    export PYTHONPATH=$(pwd):$PYTHONPATH
    export PATH=$(pwd)/scripts:${openssh}/bin:$PATH
  '';

  postInstall = lib.optionalString enableDoc ''
    make -C doc/manual install nixops.1 docbookxsl=${docbook5_xsl}/xml/xsl/docbook \
      docdir=$out/share/doc/nixops mandir=$out/share/man
    ''
    + ''
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
  };
}
