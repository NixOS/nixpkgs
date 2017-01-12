{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gdm-${version}";
  version = "1.4";

  goPackagePath = "github.com/sparrc/gdm";

  src = fetchFromGitHub {
    url = "https://github.com/sparrc/gdm";
    sha256 = "0kpqmbg144qcvd8k88j9yx9lrld85ray2viw161xajafk16plvld";
    rev = version;
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Minimalist dependency manager for Go written in Go.";
    homepage = https://github.com/sparrc/gdm;
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = [ maintainers.mic92 ];
  };
}
