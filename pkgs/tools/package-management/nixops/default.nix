{ lib, python2Packages, libxslt, docbook_xsl_ns, openssh, cacert, nixopsAzurePackages ? []
, fetchurl, fetchpatch
}:

let
  version = "1.7";

in python2Packages.buildPythonApplication {
  pname = "nixops";
  inherit version;

  src = fetchurl {
    url = "https://nixos.org/releases/nixops/nixops-${version}/nixops-${version}.tar.bz2";
    sha256 = "091c0b5bca57d4aa20be20e826ec161efe3aec9c788fbbcf3806a734a517f0f3";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/NixOS/nixops/commit/fb6d4665e8efd858a215bbaaf079ec3f5ebc49b8.patch";
      sha256 = "1hbhykl811zsqlaj3y5m9d8lfsal6ps6n5p16ah6lqy2s18ap9d0";
    })
    ./optional-virtd.patch
  ];

  buildInputs = [ libxslt ];

  pythonPath = with python2Packages;
    [ prettytable
      boto
      boto3
      hetzner
      libcloud
      adal
      # Go back to sqlite once Python 2.7.13 is released
      pysqlite
      datadog
      digital-ocean
      typing
      ]
      ++ lib.optional (!libvirt.passthru.libvirt.meta.insecure or true) libvirt
      ++ nixopsAzurePackages;

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
    homepage = "https://github.com/NixOS/nixops";
    description = "NixOS cloud provisioning and deployment tool";
    maintainers = with lib.maintainers; [ aminechikhaoui eelco rob domenkozar ];
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3;
  };
}
