{ lib
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "secrets-extractor";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Xenios91";
    repo = "Secrets-Extractor";
    rev = "v${version}";
    hash = "sha256-cwEG0cXlyhrUSQAuZ/5KVqJtez13GvZghabsooXCM/U=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-KhAaBNSpFu7LAWiHCWD1OssexW9N96ArDb7Oo1AaiWI=";
=======
  vendorSha256 = "sha256-KhAaBNSpFu7LAWiHCWD1OssexW9N96ArDb7Oo1AaiWI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    libpcap
  ];

  meta = with lib; {
    description = "Tool to check packets for secrets";
    homepage = "https://github.com/Xenios91/Secrets-Extractor";
    # https://github.com/Xenios91/Secrets-Extractor/issues/1
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
  };
}
