{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    rev = version;
    sha256 = "0y0gqb07girhz3r7gn9yrrysvhj5fapdafim0q8n7krk5y23hmh0";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "FileSystem Monitor utility";
    homepage = "https://github.com/nowsecure/fsmon";
    license = licenses.mit;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
