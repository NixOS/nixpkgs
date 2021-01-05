{ pkgs, system, lib, fetchFromGitHub }:

let
  package = import ./composition.nix {
    inherit pkgs system;
    noDev = true; # Disable development dependencies
  };

in package.override rec {
  name = "bookstack-${version}";
  version = "0.31.1";
  removeComposerArtifacts = true; # Remove composer configuration files

  src = fetchFromGitHub {
    owner = "bookstackapp";
    repo = "bookstack";
    rev = "v${version}";
    sha256 = "0inz3582r7qmha0apwrbqicmmg018rcs95by61963f11m4ywr7cl";
  };

  meta = with lib; {
    description = "A platform to create documentation/wiki content built with PHP & Laravel";
    longDescription = ''
      A platform for storing and organising information and documentation.
      Details for BookStack can be found on the official website at https://www.bookstackapp.com/.
    '';
    homepage = "https://www.bookstackapp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ ymarkus ];
    platforms = platforms.linux;
  };
}
