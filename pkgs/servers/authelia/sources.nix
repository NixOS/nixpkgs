{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.12";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-lMAKvqKoNvMXvVD+diByiUz3a/PiO8n0BBsQLQfSa90=";
  };
  vendorHash = "sha256-Q7jWeMVBKU/maSk3EACTYOaacQz39M5wZ0CAvKus7p8=";
  pnpmDepsHash = "sha256-lSh+RF/Svr8BxnuMAA3ZLSu/MOipQiVEynM1901uGNM=";
}
