{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.11.18";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JP0n1sepH9kFOdrKTmt7Q79pe4GQInYKQH3xi2/G59s=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-YCa4WL2sgdITKfdfH3PGdiRHbSkE6JSJRHipaN00GwA=";

  # skip flaky tests
  checkFlags = [
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace"
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace_simple"
    "--skip=collapse::perf::tests::test_collapse_multi_perf"
    "--skip=collapse::perf::tests::test_collapse_multi_perf_simple"
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
