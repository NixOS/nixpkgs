{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ruby
, which
}:

rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yM3bE79flvFSZvpkHXhhEh1MJrSSJzqZcX9aVRmz1ew=";
  };

  cargoHash = "sha256-qvx5zPEIwvh2AIFCGNbVMNIRFtVjSLR9+exbSeQ9oXI=";
  doCheck = true;

  # The current implementation of rbspy fails to detect the version of ruby
  # from nixpkgs during tests.
  preCheck = ''
    substituteInPlace src/core/process.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/sampler/mod.rs \
      --replace /usr/bin/which '${which}/bin/which'
  '';

  checkFlags = [
    "--skip=test_get_trace"
    "--skip=test_get_trace_when_process_has_exited"
    "--skip=test_sample_single_process"
    "--skip=test_sample_single_process_with_time_limit"
    "--skip=test_sample_subprocesses"
  ];

  nativeBuildInputs = [ ruby which ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://rbspy.github.io/";
    description = ''
      A Sampling CPU Profiler for Ruby.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
