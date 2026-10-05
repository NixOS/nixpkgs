{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libusbhid";

  outputs = [
    "out"
    "man"
    "debug"
  ];

}
