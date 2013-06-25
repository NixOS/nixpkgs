{ lib, pythonPackages, fetchurl, libxslt, docbook5_xsl }:

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://nixos.org/releases/nixops/${name}/${name}.tar.bz2";
    sha256 = "9ae2dfac8e1fa895aef81323b14a3398f03a1cbd8c86ea10b6fff7312e1fadbb";
  };

  buildInputs = [ libxslt ];

  pythonPath =
    [ pythonPackages.prettytable
      pythonPackages.boto
      pythonPackages.sqlite3
    ];

  doCheck = false;

  postInstall =
    ''
      make -C doc/manual install nixops.1 docbookxsl=${docbook5_xsl}/xml/xsl/docbook \
        docdir=$out/share/doc/nixops mandir=$out/share/man

      mkdir -p $out/share/nix/nixops
      cp -av nix/* $out/share/nix/nixops
    '';

  meta = {
    homepage = https://github.com/NixOS/nixops;
    description = "NixOS cloud provisioning and deployment tool";
    maintainers = [ lib.maintainers.eelco lib.maintainers.rob ];
    platforms = lib.platforms.linux;
  };
}
