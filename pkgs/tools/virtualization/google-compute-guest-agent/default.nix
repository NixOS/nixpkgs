{ lib, fetchFromGitHub, buildGoModule, makeWrapper, google-compute-guest-configs }:

let
  version = "20211019.00";

in buildGoModule {
  inherit version;
  pname = "guest-agent";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-agent";
    rev = version;
    sha256 = "sha256-DHpv6RIXV3Rn/8fuGUWS6nzsEqgyY5+zozsundX9ByM=";
  };

  patches = [ ./0001-oslogin-add-disable-toggle-in-conf-file.patch ];

  vendorSha256 = "sha256-YcWKSiN715Z9lmNAQx+sHEgxWnhFhenCNXBS7gdMV4M=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/google_guest_agent \
        --prefix PATH ":" "${lib.makeBinPath [ google-compute-guest-configs ]}"
  '';

  meta = with lib; {
    description = "Guest Agent for Google Compute Engine";
    homepage = "https://github.com/GoogleCloudPlatform/guest-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ mrkkrp ];
    platforms = platforms.linux;
  };
}
