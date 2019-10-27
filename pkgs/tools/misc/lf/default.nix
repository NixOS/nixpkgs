{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lf";
  version = "13";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "r${version}";
    sha256 = "1ld3q75v8rvp169w5p85z1vznqs9bhck6bm2f6fykxx16hmpb6ga";
  };

  modSha256 = "14fvn8yjm9cnpsmzgxw2dypr3h8h36mxrbk7zma42w8rsp46jpz7";

  # TODO: Setting buildFlags probably isn't working properly. I've tried a few
  # variants, e.g.:
  # - buildFlags = [ "-ldflags" "\"-s" "-w"" ""-X 'main.gVersion=${version}'\"" ];
  # - buildFlags = [ "-ldflags" "\\\"-X" "${goPackagePath}/main.gVersion=${version}\\\"" ];
  # Override the build phase (to set buildFlags):
  buildPhase = ''
    runHook preBuild
    runHook renameImports
    go install -ldflags="-s -w -X main.gVersion=r${version}"
    runHook postBuild
  '';

  postInstall = ''
    install -D --mode=444 lf.1 $out/share/man/man1/lf.1
  '';

  meta = with lib; {
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
