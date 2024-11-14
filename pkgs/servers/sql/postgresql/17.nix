import ./generic.nix {
  version = "17.0";
  hash = "sha256-fidhMcD91rYliNutmzuyS4w0mNUAkyjbpZrxboGRCd4=";
  # TODO: Add dont-use-locale-a-on-musl.patch once Alpine Linux has PostgreSQL 17.
  # MR in: https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/72853
}
