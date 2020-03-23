{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, libgit2 }:

buildGoPackage {
  pname = "blsd";
  version = "2017-07-27";

  goPackagePath = "github.com/junegunn/blsd";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "blsd";
    rev = "a2ac619821e502452abdeae9ebab45026893b9e8";
    sha256 = "0b0q6i4i28cjqgxqmwxbps22gp9rcd3jz562q5wvxrwlpbzlls2h";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libgit2 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/junegunn/blsd;
    description = "List directories in breadth-first order";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
    broken = true; # since 2020-02-08, libgit2 is incompatible upstream is dead.
  };
}
