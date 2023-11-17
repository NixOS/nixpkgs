{ lib
, buildNpmPackage
, fetchFromGitHub
, installShellFiles
, testers
, triton
}:

buildNpmPackage rec {
  pname = "triton";
  version = "7.16.0";

  src = fetchFromGitHub {
    owner = "TritonDataCenter";
    repo = "node-triton";
    rev = version;
    hash = "sha256-JjQAf1pbNraatWvrfys3ydqk3FPOoJ5XWJH/4qgfINk=";
  };

  npmDepsHash = "sha256-E5yJwLSNLkK3OfwJrm59C4qfrd2y3nw/45B68MVBqV8=";

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
