{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gdm";
  version = "1.4";

  goPackagePath = "github.com/sparrc/gdm";

  src = fetchFromGitHub {
    owner = "sparrc";
    repo = "gdm";
    rev = version;
    sha256 = "0kpqmbg144qcvd8k88j9yx9lrld85ray2viw161xajafk16plvld";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Minimalist dependency manager for Go written in Go.";
    homepage = "https://github.com/sparrc/gdm";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = [ maintainers.mic92 ];
  };
}
