{ lib, fetchFromGitHub, buildGoModule
, pkg-config, ffmpeg, gnutls
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.20";

  proxyVendor = true;
  vendorSha256 = "sha256-aRZoAEnRai8i5H08ReW8lEFlbmarYxU0lBRhR/Llw+M=";

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
