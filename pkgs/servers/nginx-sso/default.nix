{ buildGoPackage, fetchFromGitHub, lib, nixosTests }:

buildGoPackage rec {
  pname = "nginx-sso";
  version = "0.25.0";
  rev = "v${version}";

  goPackagePath = "github.com/Luzifer/nginx-sso";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Luzifer";
    repo = "nginx-sso";
    sha256 = "0z5h92rpr1rcfk11ggsb9w4ipg93fcb9byll7vl4c0mfcqkpm2dr";
  };

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
