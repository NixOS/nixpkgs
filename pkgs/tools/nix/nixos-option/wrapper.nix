{ lib
, fetchFromGitHub
, installShellFiles
, makeWrapper
, nixos-option
, runCommand
  # Set this to true to allow compatibility with Flakes. This is a hack until
  # nixos-option gain support to Flakes natively.
  # See: https://github.com/NixOS/nixpkgs/issues/97855
, withFlakeCompat ? false
  # Used when `withFlakeCompat = true`. Default value works fine if your NixOS
  # configuration is stored in `/etc/nixos`, however you may want to set this
  # to another location.
  # It is also possible to set this to `self` reference in your Flake, allowing
  # it to work regardless where you configuration is located.
, optionSrc ? "/etc/nixos"
}:

let
  flake-compat = fetchFromGitHub {
    owner = "edolstra";
    repo = "flake-compat";
    rev = "35bb57c0c8d8b62bbfd284272c928ceb64ddbde9";
    hash = "sha256-4gtG9iQuiKITOjNQQeQIpoIB6b16fm+504Ch3sNKLd8=";
  };
  prefix = ''(import ${flake-compat} { src = ${optionSrc}; }).defaultNix.nixosConfigurations.\$(hostname)'';
in
if withFlakeCompat then
  (runCommand "nixos-option"
  {
    buildInputs = [ makeWrapper installShellFiles ];

    passthru.unwrapped = nixos-option;
  } ''
    makeWrapper ${nixos-option}/bin/nixos-option $out/bin/nixos-option \
      --add-flags --config_expr \
      --add-flags "\"${prefix}.config\"" \
      --add-flags --options_expr \
      --add-flags "\"${prefix}.options\""

    installManPage ${./nixos-option.8}
  '')
else nixos-option
