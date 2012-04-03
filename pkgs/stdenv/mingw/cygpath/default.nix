{stdenv}: path :

import (
  stdenv.mkDerivation {
    name = "cygpath";
    builder = ./builder.sh;
    inherit path;
  }
)
