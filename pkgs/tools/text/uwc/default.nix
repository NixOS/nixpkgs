{ rustPlatform, lib, fetchFromGitLab }:

rustPlatform.buildRustPackage rec {
  pname = "uwc";
<<<<<<< HEAD
  version = "1.0.5";
=======
  version = "1.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "dead10ck";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-x2mijB1GkxdraFroG1+PiBzWKPjsaAeoDt0HFL2v93I=";
  };

  cargoHash = "sha256-0IvOaQaXfdEz5tlXh5gTbnZG9QZSWDVHGOqYq8aWOIc=";
=======
    sha256 = "1ywqq9hrrm3frvd2sswknxygjlxi195kcy7g7phwq63j7hkyrn50";
  };

  cargoSha256 = "04pslga3ff766cpb73n6ivzmqfa0hm19gcla8iyv6p59ddsajh3q";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  meta = with lib; {
    description = "Like wc, but unicode-aware, and with per-line mode";
    homepage = "https://gitlab.com/dead10ck/uwc";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
