{ fetchzip }:

rec {
  version = "3.4.4";
  src = fetchzip {
    url = "https://github.com/NICMx/releases/raw/master/Jool/Jool-${version}.zip";
    sha256 = "1k5iyfzjdzl5q64234r806pf6b3qdflvjpw06pnwl0ycj05p5frr";
  };
}
