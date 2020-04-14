{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lf";
  version = "14";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "r${version}";
    sha256 = "0kl9yrgph1i0jbxhlg3k0411436w80xw1s8dzd7v7h2raygkb4is";
  };

  modSha256 = "1c6c6qg8yrhdhqsnqj3jw3x2hi8vrhfm47cp9xlkfnjfrz3nk6jp";

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
    install -D --mode=444 lf.desktop $out/share/applications/lf.desktop
  '';

  meta = with lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    changelog = "https://github.com/gokcehan/lf/releases/tag/r${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
