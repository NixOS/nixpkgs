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
  version = "20200101";
  src = fetchgit {
    url = "https://git.tartarus.org/simon/spigot.git";
    rev = "b1b0b202b3523b72f0638fb31fd49c47f4abb39c";
    sha256 = "0lh5v42aia1hvhsqzs515q0anrjc6c2s9bjklfaap5gz0cg59wbv";
  };

  nativeBuildInputs = [ autoreconfHook halibut perl ];

  configureFlags = [ "--with-gmp" ];

  buildInputs = [ gmp ncurses ];

  strictDeps = true;

  meta = with lib; {
    description = "A command-line exact real calculator";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/spigot/";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = with maintainers; [ mcbeth ];
  };
}
