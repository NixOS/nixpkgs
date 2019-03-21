{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.0.15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1k53dkmd41x5h81arb2fs5s9yb6sy6113nbbzls6dc179slfg9zj";
  };

  modSha256 = "1i3xzl6kkpl4v1229rhg61j1952qxzbhav7fb2hv85903rkz51x1";

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-X miniflux.app/version.Version=${version}
  '';

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
  '';

  meta = with stdenv.lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = https://miniflux.app/;
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}

