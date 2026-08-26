{ fetchFromGitHub }:

rec {
  version = "4.1.15";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    tag = "v${version}";
    hash = "sha256-I+cgxOONq8LZWlpVaqXW+MmEKts/dQAr7Hs8uC6N8/w=";
  };
}
