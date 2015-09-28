{ lib, pythonPackages, fetchurl, libxslt, docbook5_xsl, openssh }:

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.3";
  namePrefix = "";

  src = fetchurl {
    url = "http://nixos.org/releases/nixops/${name}/${name}.tar.bz2";
    sha256 = "53a0ed75ceaa514dd46f670639df88390e79413ae015636d37e6cf430b40eaaf";
  };

  buildInputs = [ pythonPackages.nose pythonPackages.coverage ];

  propagatedBuildInputs =
    [ pythonPackages.prettytable
      pythonPackages.boto
      pythonPackages.hetzner
      pythonPackages.libcloud
      pythonPackages.sqlite3
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
