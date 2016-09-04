{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "yeshup-${builtins.substring 0 7 rev}";
  rev = "5461a8f957c686ccd0240be3f0fd8124d7381b08";

  src = fetchFromGitHub {
    owner = "RhysU";
    repo  = "yeshup";
    inherit rev;
    sha256 = "1wwbc158y46jsmdi1lp0m3dlbr9kvzvwxfvzj6646cpy9d6h21v9";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -v yeshup $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/RhysU/yeshup;
    platforms = platforms.linux;
    license = licenses.cc-by-sa-30; # From Stackoverflow answer
    maintainers = with maintainers; [ obadz ];
  };
}
