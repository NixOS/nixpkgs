### Chordbook-Package
{ nixpkgs ? import <nixpkgs>, lib }:
with (import <nixpkgs> { });

haskell.lib.buildStackProject {

  name = "Chordbook";

  src = fetchFromGitLab {
    owner = "bob-project";	
    repo = "Chordbook";
    rev = "1baf136ddc248011145c7709ffbed046f506e5fd";
    sha256 = "02xqfwnzqby1sjbxwx5hm4lx6l94pjd99fzazszfcc4hayk96bk7";
  };                                                                                              

  buildInputs = [ 
    postgresql100 
    zlib
  ];

  meta = with lib; {
    homepage = https://gitlab.com/bob-project/Chordbook;
    description = "a digital chordbook for memorizing chords";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rschardt ];
  };
}
