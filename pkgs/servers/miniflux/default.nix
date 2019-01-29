{ stdenv , buildGoPackage , fetchFromGitHub }:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.14";

  goPackagePath = "miniflux.app";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "miniflux";
    rev = version;
    sha256 = "1wd52zk7i07k0b5rlwqd4qszq42shdb4ss8871jqlf9zlbq85a0v";
  };

  goDeps = ./deps.nix;

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-X ${goPackagePath}/version.Version=${version}
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

