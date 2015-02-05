{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "a60c6a1b171faedc44354bd437d965e5e3bdc220";
  name = "gotags-${lib.strings.substring 0 7 rev}";

  goPackagePath = "github.com/jstemmer/gotags";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jstemmer";
    repo = "gotags";
    sha256 = "1drbypby0isdmkq44jmlv59k3jrwvq2jciaccxx2qc2nnx444fkq";
  };

  dontInstallSrc = true;

  meta = with lib; {
    description = "Ctags-compatible tag generator for Go";
    homepage = https://github.com/nsf/gotags;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
