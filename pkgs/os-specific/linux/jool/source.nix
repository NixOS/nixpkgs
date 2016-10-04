{ fetchzip }:

rec {
  version = "3.5.0";
  src = fetchzip {
    url = "https://github.com/NICMx/releases/raw/master/Jool/Jool-${version}.zip";
    sha256 = "06jp6gpfryn66q0z4w3gwkvfr17bcrjvys597nj49pxfiz4vczb2";
  };
}
