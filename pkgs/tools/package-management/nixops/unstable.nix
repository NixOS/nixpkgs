{ lib, pythonPackages, fetchgit, libxslt, docbook5_xsl, openssh }:

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.3pre-cefcd9ba";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/NixOS/nixops;
    rev = "9a05ebc332701247fa99fbf6d1215d48e08f3edd";
    sha256 = "17vxr51wpdd5dnasiaafga3a6ddhxyrwgr0yllczxj6bq0n5skp2";
  };

  buildInputs = [ /* libxslt */ pythonPackages.nose pythonPackages.coverage ];

  propagatedBuildInputs =
    [ pythonPackages.prettytable
      pythonPackages.boto
      pythonPackages.hetzner
      pythonPackages.libcloud
      pythonPackages.sqlite3
    ];

  doCheck = true;

  postInstall =
    ''
      # Backward compatibility symlink.
      ln -s nixops $out/bin/charon

      # Documentation build is currently broken. Re-try with newer version.
      : make -C doc/manual install nixops.1 docbookxsl=${docbook5_xsl}/xml/xsl/docbook \
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
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.unix;
  };
}
