{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bottomify";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "bottom-software-foundation";
    repo = "bottom-rs";
    rev = "3451cdadd7c4e64fe8e7f43e986a18628a741dec";
    sha256 = "wjrrzHYZLEFWiUut9c20cq3tDTfO/f+TDToIABBGIU8=";
    fetchSubmodules = true;
  };

  cargoSha256 = "8jPM0Ei2npzs3fYsVKeTZ1JxWfYVC1q5jfvAsGXK2UU=";

  cargoPatches = [ ./cargolock.patch ];

  meta = with lib; {
    description = "Fantastic (maybe) CLI for translating between bottom and human-readable text";
    homepage=  "https://github.com/bottom-software-foundation/bottom-rs";
    license = licenses.mit;
    maintainers = [ maintainers.bootstrap-prime ];
  };
}
