{ writeShellApplication
, fetchFromGitHub
, nix
}:

let
  devour-flake = fetchFromGitHub {
    owner = "srid";
    repo = "devour-flake";
    rev = "v2";
    hash = "sha256-CZedJtbZlWAbv/b/aYgOEFd9vcTBn/oJNI3p29UitLk=";
  };
in
writeShellApplication {
  name = "devour-flake";
  runtimeInputs = [ nix ];
  text = ''
    FLAKE="$1"
    shift 1 || true

    nix build ${devour-flake}#default \
      "$@" \
      -L --no-link --print-out-paths \
      --override-input flake "$FLAKE" \
      | xargs cat
  '';
}
