{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.17";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-JymfNe7Xoa2Hh219GtBjlyaGK+Jn8XWqrTnkY8377Ro=";
  };
  vendorHash = "sha256-q38jSX7jZO3Y4gn7dxq4NYLEfCUWVcUwmNfqT52AU/M=";
  pnpmDepsHash = "sha256-jih+mFZKKOBUH0f2zzKN49VV6iUbMhVImFDWFYaZWWI=";
}
