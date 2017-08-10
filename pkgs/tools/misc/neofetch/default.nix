{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  name = "neofetch-${version}";
  version = "3.2.0";
  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = version;
    sha256 = "1skkclvkqayqsbywja2fhv18l4rn9kg2da6bkip82zrwd713akl3";
  };

  # This patch is only needed so that Neofetch 3.2.0 can look for
  # configuration file, w3m directory (for fetching images) and ASCII
  # directory properly. It won't be needed in subsequent releases.
  patches = [
    (fetchpatch {
      name = "nixos.patch";
      url = "https://github.com/konimex/neofetch/releases/download/3.2.0/nixos.patch";
      sha256 = "096l1r5ll7gxqjv9fnxi7cs0iphl83yi3a9ldf7bfxavjaz2lkb9";
    })
  ];


  dontBuild = true;


  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
  ];

  meta = with stdenv.lib; {
    description = "A fast, highly customizable system info script";
    homepage = https://github.com/dylanaraps/neofetch;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
  };
}
