{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "container-diff";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4sk6DqScaNf0tMZQ6Hj40ZEklFTUFwAkN63v67nUFn8=";
  };

  vendorSha256 = null;

  preCheck = ''
    # Tests require being able to write to the home directory
    export HOME="$TMPDIR/home"
    mkdir "$HOME"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    dir="$GOPATH/bin"
    cp $dir/container-diff $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/GoogleContainerTools/container-diff";
    description = "A tool for analyzing and comparing container images";
    license = licenses.asl20;
  };
}
