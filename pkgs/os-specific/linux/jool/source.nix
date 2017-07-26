{ fetchzip }:

rec {
  version = "3.5.3";
  src = fetchzip {
    url = "https://github.com/NICMx/releases/raw/master/Jool/Jool-${version}.zip";
    sha256 = "1dh8qcb3grjpsk7j5d8p5dncrh4fljkrfd9b8sxd2c3kirczckmp";
  };
}
