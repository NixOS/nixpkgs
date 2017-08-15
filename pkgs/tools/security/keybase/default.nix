{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  # The latest version 'blessed' by upstream can be extracted from:
  #     https://aur.archlinux.org/packages/keybase-git/
  # `version` partially reuses `pkgver`; `nix-prefetch-git` provides the date.
  version = "1.0.27-20170726114412.8169d66";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    # `pkgver` in the PKGBUILD provides the short hash.
    rev    = "8169d666e2a4d920da7025170baccde336fce11d";
    sha256 = "1nnfyvbmn6cy0g4dy0ayg17jblxkyck0097f7bbmwbnrplaj2w6h";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ carlsverre np ];
  };
}
