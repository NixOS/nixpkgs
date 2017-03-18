{ fetchzip }:

rec {
  version = "3.5.2";
  src = fetchzip {
    url = "https://github.com/NICMx/releases/raw/master/Jool/Jool-${version}.zip";
    sha256 = "0gmjdi50c9wfapikniy2i1cfhz124pp7q02a0vbwxw7f21llcv8x";
  };
}
