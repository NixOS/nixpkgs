{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "env-lscolors";
  version = "unstable-2022-05-05"; # upstream don't do releases

  src = fetchFromGitHub {
    owner = "trapd00r";
    repo = "LS_COLORS";
    rev = "7271a7a8135c1e8a82584bfc9a8ebc227c5c6b2b";
    sha256 = "0gs2qmdxvvgs5ck2j8b6i8dqc5q91m8xrvc2ajvlhcr7in0n9iw5";
  };

  installPhase = ''
    mkdir -p $out/share/lscolors
    cp LS_COLORS $out/share/lscolors/LS_COLORS
    dircolors -b LS_COLORS > $out/share/lscolors/lscolors.sh
  '';

  meta = with lib; {
    description = "Coloring configuration for GNU ls for many filetypes";
    homepage = "https://github.com/trapd00r/LS_COLORS";
    license = licenses.artistic2;
    maintainers = with maintainers; [ kaction ];
    platforms = platforms.all;
  };
}
