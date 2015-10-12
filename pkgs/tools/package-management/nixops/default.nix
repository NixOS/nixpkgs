{ lib, pythonPackages, fetchurl, libxslt, docbook5_xsl, openssh }:

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.3";
  namePrefix = "";

  src = fetchurl {
    url = "http://nixos.org/releases/nixops/${name}/${name}.tar.bz2";
    sha256 = "d80b0fe3bb31bb84a8545f9ea804ec8137172c8df44f03326ed7639e5a4bad55";
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
