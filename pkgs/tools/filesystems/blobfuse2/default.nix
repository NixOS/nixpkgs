{ fetchFromGitHub, buildGoModule, fuse3, lib }:

let
  version = "2.0.0-preview.4";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-fuse";
    rev = "blobfuse2-${version}";
    sha256 = "sha256-4uKD3SK1AW/GA+rud2xV7gTPH6QLuN9FutZTsdEdvuA=";
  };
in
buildGoModule rec {
  pname = "blobfuse2";
  inherit version src;

  vendorSha256 = "sha256-ZGo+6ydpTFIUUX9V3sMbywGtmqo8CwVpwEsaK+PByTk=";

  buildInputs = [ fuse3 ];

  checkPhase = ''
    runHook preCheck

    # We do not set trimpath for tests, in case they reference test assets
    export GOFLAGS=''${GOFLAGS//-trimpath/}

    for pkg in $(getGoDirs test); do
      # should not be ran
      if [ $pkg == "." ]; then continue; fi
      # requires network
      if [ $pkg == "./cmd" ]; then continue; fi
      # fails with "Unable to open config file"
      if [ $pkg == "./component/azstorage" ]; then continue; fi
      # fails with an error
      if [ $pkg == "./test/accoutcleanup" ]; then continue; fi
      # we don't need benchmark
      if [ $pkg == "./test/benchmark_test" ]; then continue; fi
      # can't run e2e tests
      if [ $pkg == "./test/e2e_tests" ]; then continue; fi
      # fails with an error
      if [ $pkg == "./test/mount_test" ]; then continue; fi
      if [ $pkg == "./test/sdk_test" ]; then continue; fi
      # we don't need stress test
      if [ $pkg == "./test/stress_test" ]; then continue; fi
      # fails with an error
      if [ $pkg == "./tools/health-monitor/monitor/cpu_mem_profiler" ]; then continue; fi

      echo "Testing $pkg"
      buildGoDir test "$pkg"
    done

    runHook postCheck
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    cp $out/bin/azure-storage-fuse $out/bin/blobfuse2
  '';

  meta = with lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE (version 2)";
    license = licenses.mit;
    maintainers = with maintainers; [ GuillaumeDesforges ];
    platforms = platforms.linux;
  };
}
