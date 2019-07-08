{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.0.16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "09fwhbcpp84l5lw4zizm46ssri6irzvjx2w7507a1xhp6iq73p2d";
  };

  modSha256 = "0060px0av7l9x4xgmkci9d8yl4lgxzqrikqagnz0f17a944p9xdr";

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

