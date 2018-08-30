{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "lf-${version}";
  version = "8";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "r${version}";
    sha256 = "0rmcac9wx9lldl57m1cim1adf2fqkva1yi4v6934jgccqhlqvk58";
  };

  goPackagePath = "github.com/gokcehan/lf";
  goDeps = ./deps.nix;

  # TODO: Setting buildFlags probably isn't working properly. I've tried a few
  # variants, e.g.:
  # - buildFlags = "-ldflags \"-s -w -X 'main.gVersion=${version}'\"";
  # - buildFlags = "-ldflags \\\"-X ${goPackagePath}/main.gVersion=${version}\\\"";

  # Override the build phase (to set buildFlags):
  buildPhase = ''
    runHook preBuild
    runHook renameImports
    cd go/src/${goPackagePath}
    go install -ldflags="-s -w -X main.gVersion=r${version}"
    runHook postBuild
  '';

  postInstall = ''
    install -D --mode=444 lf.1 $out/share/man/man1/lf.1
  '';

  meta = with stdenv.lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = https://godoc.org/github.com/gokcehan/lf;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
