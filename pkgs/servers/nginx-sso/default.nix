{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    sha256 = "sha256-uYl6J2auAkboPpT6lRZzI70bCU9LvxfCdCyHfLNIsHw=";
  };

  vendorSha256 = null;

  patches = [ ./rune.patch ];

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/frontend $out/share
  '';

  passthru.tests = {
    inherit (nixosTests) nginx-sso;
  };

  meta = with lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = licenses.asl20;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.unix;
  };
}
