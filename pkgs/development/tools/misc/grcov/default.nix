{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "grcov";
<<<<<<< HEAD
  version = "0.8.19";
=======
  version = "0.8.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-1t+hzB9sSApLScCkjBnLk9i2dsoEwZmWCFukEOvHhZI=";
  };

  cargoHash = "sha256-4KzFbfUqnGmle2fwSaHMPIJHQFDq8H2Qzm4FdYdqpuM=";
=======
    sha256 = "sha256-IC5ROi4kwZLCX7/kFb7VgOzQtsj74hujQ5IrrFneFTA=";
  };

  cargoHash = "sha256-DcPidu3WFyVWBS4EVavxFhy9wwqP4rGmaALKnfxua2E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests do not find grcov path correctly
  checkFlags = let
    skipList = [
      "test_coveralls_service_job_id_is_not_sufficient"
      "test_coveralls_service_name_is_not_sufficient"
      "test_coveralls_works_with_just_service_name_and_job_id_args"
      "test_coveralls_works_with_just_token_arg"
      "test_integration"
      "test_integration_guess_single_file"
      "test_integration_zip_dir"
      "test_integration_zip_zip"
    ];
    skipFlag = test: "--skip " + test;
  in builtins.concatStringsSep " " (builtins.map skipFlag skipList);

  meta = with lib; {
    description =
      "Rust tool to collect and aggregate code coverage data for multiple source files";
    homepage = "https://github.com/mozilla/grcov";
    license = licenses.mpl20;
    maintainers = with maintainers; [ DieracDelta ];
  };
}
