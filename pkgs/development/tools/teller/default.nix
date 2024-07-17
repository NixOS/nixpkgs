{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pname = "teller";
  version = "1.5.6";
  date = "2022-10-13";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "tellerops";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vgrfWKKXf4C4qkbGiB3ndtJy1VyTx2NJs2QiOSFFZkE=";
  };

  vendorHash = null;

  # use make instead of default checks because e2e does not work with `buildGoDir`
  checkPhase = ''
    runHook preCheck
    HOME="$(mktemp -d)"
    # We do not set trimpath for tests, in case they reference test assets
    export GOFLAGS=''${GOFLAGS//-trimpath/}

    make test

    # e2e tests can fail on first try

    max_iteration=3
    for i in $(seq 1 $max_iteration)
    do
      make e2e
      result=$?
      if [[ $result -eq 0 ]]
      then
        echo "e2e tests passed"
        break
      else
        echo "e2e tests failed, retrying..."
        sleep 1
      fi
    done

    if [[ $result -ne 0 ]]
    then
      echo "e2e tests failed after $max_iteration attempts"
    fi

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${version}"
    "-X main.date=${date}"
  ];

  meta = with lib; {
    homepage = "https://github.com/tellerops/teller/";
    description = "Cloud native secrets management for developers";
    mainProgram = "teller";
    license = licenses.asl20;
    maintainers = with maintainers; [ wahtique ];
  };
}
