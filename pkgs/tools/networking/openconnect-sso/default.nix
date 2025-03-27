{ lib
, openconnect
, python3
, python3Packages
, poetry2nix
, substituteAll
, qt5
}@attrs:

let
  src = builtins.fetchGit {
      url = "https://github.com/vlaci/openconnect-sso";
      ref = "master";
      rev = "4430cb09aefe15108e5f3b40b94ed792fbe9548b";
  };

  input = builtins.removeAttrs (attrs // { wrapQtAppsHook = qt5.wrapQtAppsHook; }) [ "qt5" ];
in
  import (src + /nix/openconnect-sso.nix) input

