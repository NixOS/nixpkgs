{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  pname = "nginx-sso";
  version = "0.24.1";
  rev = "v${version}";

  goPackagePath = "github.com/Luzifer/nginx-sso";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Luzifer";
    repo = "nginx-sso";
    sha256 = "1wij0a5ban2l6ahfra4n4dji7i5ndkqk1mgrblwm2ski7bl8yszx";
  };

  postInstall = ''
    mkdir -p $bin/share
    cp -R $src/frontend $bin/share
  '';

  meta = with stdenv.lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = licenses.asl20;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.unix;
  };
}
