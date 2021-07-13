fixupOutputHooks+=('signDarwinBinariesIn $prefix')

# Uses signingUtils, see definition of autoSignDarwinBinariesHook in
# darwin-packages.nix

signDarwinBinariesIn() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    return 0
  fi

  if [ "${darwinDontCodeSign:-}" ]; then
    return 0
  fi

  while IFS= read -r -d $'\0' f; do
    signIfRequired "$f"
  done < <(find "$dir" -type f -print0)
}
