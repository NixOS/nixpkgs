{ lib, pythonPackages, fetchurl, libxslt, docbook5_xsl, openssh }:

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.3.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://nixos.org/releases/nixops/${name}/${name}.tar.bz2";
    sha256 = "04j8s0gg1aj3wmj1bs7dwscfmlzk2xpwfw9rk4xzxwxw1y0j64nd";
  };

  buildInputs = [ libxslt ];

  pythonPath =
    [ pythonPackages.prettytable
      pythonPackages.boto
      pythonPackages.sqlite3
      pythonPackages.hetzner
      pythonPackages.libcloud
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
