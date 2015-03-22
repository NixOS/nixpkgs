{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-03-20";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "79a0056e137c9cc540eb9ff7327c85ac8d094e6c";
    sha256 = "0xj132x0q76h9anjh7km2blqnr19yx7szwifj02x5h6xa07vq6fd";
  };

  patches = [ ./const.patch ./install_prefix-git.patch ];
})
