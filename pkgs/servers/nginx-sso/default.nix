{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-Lpaqcxw1q609rYuEd1zrAKXE0GDEi72wl2eoFezvrV8=";
  };

  vendorHash = "sha256-XReXxugMfR2l2LMTvXpSJa7Z9BX7LytwYdYNijPtciE=";

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
    mainProgram = "nginx-sso";
  };
}
