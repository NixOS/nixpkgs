{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.0.17";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0bvlsa3ymhdl35bkv2v8lzkbjanyg7y474kbpbabmhwh5lvzgxlm";
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

