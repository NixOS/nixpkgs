{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, ruby
, which
}:
rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-e6ZCRIJVKl3xbJym+h+ah/J4c+s7wf1laF7p63ubE4A=";
  };

  cargoHash = "sha256-yhZ0QM9vZxyFCjTShbV7+Rn8w4lkPW7E7zKhrK4qa1E=";
  doCheck = true;

  # The current implementation of rbspy fails to detect the version of ruby
  # from nixpkgs during tests.
  preCheck = ''
    substituteInPlace src/core/process.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/sampler/mod.rs \
      --replace /usr/bin/which '${which}/bin/which' \
      --replace 'fn test_sample_single_process_with_time_limit(' '#[ignore] fn test_sample_single_process_with_time_limit(' \
      --replace 'fn test_sample_single_process(' '#[ignore] fn test_sample_single_process(' \
      --replace 'fn test_sample_subprocesses(' '#[ignore] fn test_sample_subprocesses('
    substituteInPlace src/core/ruby_spy.rs \
      --replace 'fn test_get_trace(' '#[ignore] fn test_get_trace(' \
      --replace 'fn test_get_trace_when_process_has_exited(' '#[ignore] fn test_get_trace_when_process_has_exited('
  '';

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
