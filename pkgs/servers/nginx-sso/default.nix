{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  name = "nginx-sso-${version}";
  version = "0.15.1";
  rev = "v${version}";

  goPackagePath = "github.com/Luzifer/nginx-sso";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Luzifer";
    repo = "nginx-sso";
    sha256 = "0mm6yhm22wf32yl9wvl8fy9m5jjd491khyy4cl73fn381h3n5qi2";
  };

  postInstall = ''
    mkdir -p $bin/share
    cp -R $src/frontend $bin/share
  '';

  meta = with stdenv.lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = https://github.com/Luzifer/nginx-sso;
    license = licenses.asl20;
    maintainers = with maintainers; [ delroth ];
    platforms = platforms.unix;
  };
}
