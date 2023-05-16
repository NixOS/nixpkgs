{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
<<<<<<< HEAD
  version = "0.11.16";
=======
  version = "0.11.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hCrDvlC547ee/ZYj+7tnJTKGMPxams6/WJvvBsr7CvE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-J7P84aU/3/hvZlr06gpN98QXqRoe2Z6IQ91RbgB4Ohc=";

  # skip flaky tests
  checkFlags = [
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace"
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace_simple"
    "--skip=collapse::perf::tests::test_collapse_multi_perf"
    "--skip=collapse::perf::tests::test_collapse_multi_perf_simple"
=======
    hash = "sha256-fyTsB+1ftol3prNLydT/coLchip1vijmfLLt3/DnBbc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-XBah55xfbWjQrkupebZE2uiveFhh/R0BF1KEKkY5Hx8=";

  # skip flaky tests
  checkFlags = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--skip=flamegraph_base_symbol"
    "--skip=flamegraph_multiple_base_symbol"
  ];

  meta = with lib; {
    description = "A port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = licenses.cddl;
    maintainers = with maintainers; [ figsoda ];
  };
}
