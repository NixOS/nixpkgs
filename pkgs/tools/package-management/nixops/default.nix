{ lib, pythonPackages, fetchurl, libxslt, docbook5_xsl }:

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.0.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://nixos.org/releases/nixops/${name}/${name}.tar.bz2";
    sha256 = "c6dda2597ba0ab2f60c984d4715163c02940f20803619668d6c16eba8570a394";
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
      # Backward compatibility symlink.
      ln -s nixops $out/bin/charon

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
