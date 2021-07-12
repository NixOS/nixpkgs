{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "motion-unstable";
  version = "2018-04-09";
  rev = "218875ebe23806e7af82f3b5b14bb3355534f679";

  goPackagePath = "github.com/fatih/motion";
  excludedPackages = "testdata";

  src = fetchFromGitHub {
    inherit rev;

    owner = "fatih";
    repo = "motion";
    sha256 = "08lp61hmb77p0cknf71jp8lssplxad3ddyqjxh8x3cr0bmn9ykr9";
  };

  meta = with lib; {
    description = "Navigation and insight in Go";
    longDescription = ''
      Motion is a tool that was designed to work with editors. It is providing
      contextual information for a given offset(option) from a file or
      directory of files. Editors can use these informations to implement
      navigation, text editing, etc... that are specific to a Go source code.

      It's optimized and created to work with vim-go, but it's designed to work
      with any editor. It's currently work in progress and open to change.
    '';
    homepage = "https://github.com/fatih/motion";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
