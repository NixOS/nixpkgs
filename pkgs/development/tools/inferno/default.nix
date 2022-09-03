{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.11.7";

  # github version doesn't have a Cargo.lock
  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-HZBCLgWC9yEo3lY7If18SILKZV3rwHv7FBVdumiTbJg=";
  };

  cargoSha256 = "sha256-upO+G9569NXFuc2vpxR6E4nxJqCjg+RMlxV7oKb7v1E=";

  # these tests depend on a patched version of flamegraph which is included in
  # the github repository as a submodule, but absent from the crates version
  checkFlags = [
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace"
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace_simple"
    "--skip=collapse::perf::tests::test_collapse_multi_perf"
    "--skip=collapse::perf::tests::test_collapse_multi_perf_simple"
    "--skip=collapse::perf::tests::test_multiple_skip_after"
    "--skip=collapse::perf::tests::test_one_skip_after"
  ];

  meta = with lib; {
    description = "A port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = licenses.cddl;
    maintainers = with maintainers; [ figsoda ];
  };
}
