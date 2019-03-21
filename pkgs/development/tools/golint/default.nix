{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "lint-${version}";
  version = "20181026-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "c67002cb31c3a748b7688c27f20d8358b4193582";
  
  goPackagePath = "golang.org/x/lint";
  excludedPackages = "testdata";

  # we must allow references to the original `go` package, as golint uses
  # compiler go/build package to load the packages it's linting.
  allowGoReference = true;

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/lint";
    sha256 = "0gymbggskjmphqxqcx4s0vnlcz7mygbix0vhwcwv5r67c0bf6765";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://golang.org;
    description = "Linter for Go source code";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jhillyerd ];
    platforms = platforms.all;
  };
}
