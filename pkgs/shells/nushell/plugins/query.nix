{ stdenv
, lib
, rustPlatform
, nushell
<<<<<<< HEAD
, IOKit
, CoreFoundation
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_query";
  version = "0.84.0";

  src = nushell.src;

  cargoHash = "sha256-8uAoiurQpI++duheNqwEDw/0CIPE1dHcgL48hKWqNUg=";
=======
, nix-update-script
, IOKit
, CoreFoundation
}:

let
  pname = "nushell_plugin_query";
in
rustPlatform.buildRustPackage {
  inherit pname;
  version = nushell.version;

  src = nushell.src;

  cargoHash = "sha256-BKeEAgvhHP01K/q8itwFfFIH8BAS9e1dat449i3M4ig=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit CoreFoundation ];

  cargoBuildFlags = [ "--package nu_plugin_query" ];

  # compilation fails with a missing symbol
  doCheck = false;

<<<<<<< HEAD
  passthru = {
    updateScript = nix-update-script { };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A Nushell plugin to query JSON, XML, and various web data";
    homepage = "https://github.com/nushell/nushell/tree/main/crates/nu_plugin_query";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}
