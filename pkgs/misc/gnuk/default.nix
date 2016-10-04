{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.0.4";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "93867d0c8b90c485f9832c0047c3a2e17a029aca";
    sha256 = "0ah2gc772kdq7gdwpqwdmfh5nzbx2wgpk5ljnhwc4i3mrkafdiih";
  };
})
