{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "9b760fdb16f18eafbe0cd274527efd2bd89dfa78";
  name = "gocode-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/nsf/gocode";
  src = fetchFromGitHub {
    inherit rev;
    owner = "nsf";
    repo = "gocode";
    sha256 = "0d1wl0x8jkaav6lcfzs70cr6gy0p88cbk5n3p19l6d0h9xz464ax";
  };

  subPackages = [ "./" ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "An autocompletion daemon for the Go programming language";
    homepage = https://github.com/nsf/gocode;
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
