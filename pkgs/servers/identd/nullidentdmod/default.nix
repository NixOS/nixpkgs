{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  name = "nullidentdmod-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Acidhub";
    repo = "nullidentdmod";
    rev = "v${version}";
    sha256 = "1ahwm5pyidc6m07rh5ls2lc25kafrj233nnbcybprgl7bqdq1b0k";
  };

  installPhase = ''
    mkdir -p $out/bin

    install -Dm755 nullidentdmod $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Simple identd that just replies with a random string or customized userid";
    license = licenses.gpl2;
    homepage = http://acidhub.click/NullidentdMod;
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.linux; # Must be run by systemd
  };
}
