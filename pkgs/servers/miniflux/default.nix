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

  modSha256 = "0n5j4rns2w1klgrf5jz0bng9cih9aifjx55hhkf4dfj1x4wsxjdj";

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

