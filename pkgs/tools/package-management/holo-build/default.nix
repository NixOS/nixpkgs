{ lib, buildGoModule, fetchFromGitHub, installShellFiles, perl, file }:

buildGoModule rec {
  pname = "holo-build";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "holocm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lypbgf96bcc4m3968xa4il1zwprsdyc0pw6pl9mqq7djxabikd0";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'VERSION :=' 'VERSION ?='
    substituteInPlace src/holo-build.sh \
      --replace '/usr/lib/holo/holo-build' '${placeholder "out"}/lib/holo/holo-build'
  '';

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles perl ];

  subPackages = [ "src/holo-build" ];

  ldflags = [ "-s" "-w" "-X github.com/holocm/holo-build/src/holo-build/common.version=${version}" ];

  postBuild = ''
    make build/man/holo-build.8 VERSION=${version}
  '';

  nativeCheckInputs = [ file ];

  checkPhase = ''
    ln -s ../../go/bin/holo-build build/holo-build
    go build -ldflags "-s -w -X github.com/holocm/holo-build/src/holo-build/common.version=${version}" -o build/dump-package ./src/dump-package
    bash test/compiler/run_tests.sh
    bash test/interface/run_tests.sh
  '';

  postInstall = ''
    installManPage build/man/*
    installShellCompletion --bash --name holo-build util/autocomplete.bash
    installShellCompletion --zsh --name _holo-build util/autocomplete.zsh

    # install wrapper script
    mkdir -p $out/lib/holo
    mv $out/bin/holo-build $out/lib/holo/holo-build
    cp src/holo-build.sh $out/bin/holo-build
  '';

  meta = with lib; {
    description = "Cross-distribution system package compiler";
    homepage = "https://holocm.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
