{ stdenv, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.21";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0yhzmfs35jfc7vq26r9c14v4lnv8sxj3pv23r2cx2rfx47b1zmk7";
  };

  goPackagePath = "miniflux.app";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-s -w -X miniflux.app/version.Version=${version}
  '';

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
    installManPage go/src/${goPackagePath}/miniflux.1
  '';

  meta = with stdenv.lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}

