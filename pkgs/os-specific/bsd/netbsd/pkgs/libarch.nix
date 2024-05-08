{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libarch";
  version = "9.2";
  sha256 = "6ssenRhuSwp0Jn71ErT0PrEoCJ+cIYRztwdL4QTDZsQ=";
  meta.platforms = lib.platforms.netbsd;
}
