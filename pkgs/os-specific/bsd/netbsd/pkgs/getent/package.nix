{ mkDerivation }:

mkDerivation {
  path = "usr.bin/getent";
  sha256 = "1qngywcmm0y7nl8h3n8brvkxq4jw63szbci3kc1q6a6ndhycbbvr";
  version = "9.2";
  patches = [ ./getent.patch ];
}
