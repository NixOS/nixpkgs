{ lib, fetchFromGitHub, buildGoModule
, pkg-config, ffmpeg, gnutls
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.20";

  proxyVendor = true;
<<<<<<< HEAD
  vendorHash = "sha256-aRZoAEnRai8i5H08ReW8lEFlbmarYxU0lBRhR/Llw+M=";
=======
  vendorSha256 = "sha256-aRZoAEnRai8i5H08ReW8lEFlbmarYxU0lBRhR/Llw+M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "v${version}";
    sha256 = "sha256-cOxIL093Mi+g9Al/SQJ6vdaeBAXUN6ZGsSaVvEIiJpU=";
  };

  # livepeer_cli has a vendoring problem
  subPackages = [ "cmd/livepeer" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg gnutls ];

  meta = with lib; {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = "https://livepeer.org";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
  };
}
