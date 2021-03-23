{ lib, fetchFromGitHub, buildGoModule
, pkg-config, ffmpeg, gnutls
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.14";

  runVend = true;
  vendorSha256 = "sha256-StkgU11VLEKg89kn3zPcdC8HBw9MmJrfDPGk1SUQO64=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "v${version}";
    sha256 = "sha256-GxgpGI1ymhbYhzCP2Bs5wJ5kq5rHHkClXcAsYlaQ/AM=";
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
