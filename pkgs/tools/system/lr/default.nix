{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lr-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "0lwnd5whq5f0czhqgaj4y6myzw4wssk6bji4z3dck95c8rpvg05a";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.globin ];
  };
}
