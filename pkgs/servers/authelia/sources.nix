{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.15";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-o/gVJDahMBsczAMKt5kuA1SjtwASOd98aCiS7Tp32Dg=";
  };
  vendorHash = "sha256-iBQqBX+C/7/uAuzIFlNFo7oKzWn+CYADVWf3CDIr3aU=";
  pnpmDepsHash = "sha256-fWsn/NfLYwBTTKYKtY/M5Z+cxKWeBxkP9LvyhpAkiBc=";
}
