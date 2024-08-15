{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.11.20";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+A27B50hRAQvk0QrcCP0QQe6zJkVUIX7qggL8kjJmQY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-XmxB18IQh2Bvbez6BowoV+P0qghmOcHpC0ZH4PgsIZo=";

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
    description = "Port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = licenses.cddl;
    maintainers = with maintainers; [ figsoda ];
  };
}
