{ stdenv
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "miniflux-${version}";
  version = "2.0.12";

  goPackagePath = "miniflux.app";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "miniflux";
    rev = "refs/tags/${version}";
    sha256 = "13d1dwcwig7b5phymgxqm227k5l3zzzvx997cywarbl953ji2y1d";
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
    description = "Miniflux is a minimalist and opinionated feed reader.";
    homepage = https://miniflux.app/;
    license = licenses.asl20;
    maintainers = with maintainers; [ benpye ];
  };
}

