{ callPackage, fetchgit, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "1.2.14";

    src = fetchgit {
      url = "git://git.gniibe.org/gnuk/gnuk.git";
      rev = "177ef67edfa2306c2a369a037362385c354083e1";
      sha256 = "16wa3xsaq4r8caw6c24hnv4j78bklacix4in2y66j35h68ggr3j1";
    };
  }
)
