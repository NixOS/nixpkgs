{ buildGoPackage, fetchFromGitHub, stdenv }:

buildGoPackage rec {
  pname = "nginx-sso";
  version = "0.22.0";
  rev = "v${version}";

  goPackagePath = "github.com/Luzifer/nginx-sso";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Luzifer";
    repo = "nginx-sso";
    sha256 = "1kcyb7sbqna18yw3myi3c0imhh4hsa0h2k2y0bqfr2pqsnssz54a";
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
