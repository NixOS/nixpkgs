{ lib, pythonPackages, fetchgit, libxslt, docbook5_xsl, openssh }:

let

  # Use this until the patches are upstreamed.
  # Warning: will be rebased at will
  libcloud = lib.overrideDerivation pythonPackages.libcloud ( args: {
    src = fetchgit {
      url = https://github.com/Phreedom/libcloud.git;
      rev = "784427f549829a00d551e3468184a708420ad1ec";
      sha256 = "fd0e092b39fa1fde6a8847e6dc69855d30c2dad9e95ee0373297658ff53edf8a";
    };

    preConfigure = "cp libcloud/test/secrets.py-dist libcloud/test/secrets.py";
  });

in

pythonPackages.buildPythonPackage rec {
  name = "nixops-1.3pre1484_a932a9e";
  namePrefix = "";

  src = fetchgit {
    url = https://github.com/NixOS/nixops;
    rev = "a932a9ecec15336a55f2aa2c2a20f08264adb837";
    sha256 = "010qqpa4yvsra1744afsaj9akqjxzla5p0i4zgan9306m8k3jnpk";
  };

  buildInputs = [ pythonPackages.nose pythonPackages.coverage ];

  propagatedBuildInputs =
    [ pythonPackages.prettytable
      pythonPackages.boto
      pythonPackages.hetzner
      libcloud
      pythonPackages.sqlite3
    ];

  doCheck = true;

  postInstall =
    ''
      # Backward compatibility symlink.
      ln -s nixops $out/bin/charon

      make -C doc/manual install \
        docdir=$out/share/doc/nixops mandir=$out/share/man

      mkdir -p $out/share/nix/nixops
      cp -av nix/* $out/share/nix/nixops

      # Add openssh to nixops' PATH. On some platforms, e.g. CentOS and RHEL
      # the version of openssh is causing errors when have big networks (40+)
      wrapProgram $out/bin/nixops --prefix PATH : "${openssh}/bin"
    ''; # */

  meta = {
    homepage = https://github.com/NixOS/nixops;
    description = "NixOS cloud provisioning and deployment tool";
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.unix;
  };
}
