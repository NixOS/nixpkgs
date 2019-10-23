{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.18";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0480f4481qf47l3l79f4gxhgfzzhfapjvl18kw9qjj3rzqn9xyj4";
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

