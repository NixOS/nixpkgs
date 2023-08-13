{ lib
, buildNpmPackage
, fetchFromGitHub
, installShellFiles
, testers
, triton
}:

buildNpmPackage rec {
  pname = "triton";
  version = "7.15.4";

  src = fetchFromGitHub {
    owner = "TritonDataCenter";
    repo = "node-triton";
    rev = version;
    hash = "sha256-RjYJT8Iw9JZzvd2d9zh2CS27qUx12nDi12k+YuTh7tk=";
  };

  npmDepsHash = "sha256-2ZTTgJ4LzmlfFoNNNPrrmna5pbREshdw5x9w5N7nasc=";

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd triton --bash <($out/bin/triton completion)
    # Strip timestamp from generated bash completion
    sed -i '/Bash completion generated.*/d' $out/share/bash-completion/completions/triton.bash
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = triton;
    };
  };

  meta = with lib; {
    description = "TritonDataCenter Client CLI and Node.js SDK";
    homepage = "https://github.com/TritonDataCenter/node-triton";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
