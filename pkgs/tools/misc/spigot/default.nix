{ lib
, stdenv
, buildPackages
, fetchgit
, autoreconfHook
, gmp
, ncurses
, halibut
, perl
}:

stdenv.mkDerivation rec {
  pname = "spigot";
  version = "20210527";
  src = fetchgit {
    url = "https://git.tartarus.org/simon/spigot.git";
    rev = "9910e5bdc203bae6b7bbe1ed4a93f13755c1cae";
    sha256 = "sha256-bhUHz1b17MFishuBwt5eQGyZcrUIiUxPClM8MF/a5qs=";
  };

  nativeBuildInputs = [ autoreconfHook halibut perl ];

  configureFlags = [ "--with-gmp" ];

  buildInputs = [ gmp ncurses ];

  strictDeps = true;

  meta = with lib; {
    description = "A command-line exact real calculator";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with maintainers; [ mcbeth ];
  };
}
