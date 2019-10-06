{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.17";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0bvlsa3ymhdl35bkv2v8lzkbjanyg7y474kbpbabmhwh5lvzgxlm";
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

