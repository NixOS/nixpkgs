{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.19";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "121qy1af1qbc09c3yfwhpk6r3hwmh3jg6gjx8ygfv3hfrss9yfll";
  };

  goPackagePath = "miniflux.app";

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-X miniflux.app/version.Version=${version}
  '';

  postInstall = ''
    mv $bin/bin/miniflux.app $bin/bin/miniflux
  '';

  meta = with stdenv.lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = https://miniflux.app/;
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}

