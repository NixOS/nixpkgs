{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.10.7";

  # github version doesn't have a Cargo.lock
  src = fetchCrate {
    inherit pname version;
    sha256 = "0bzrwa87j56sv03frl0lp6izfxsldn0692g2vpwfndhrsm0gy8z9";
  };

  cargoSha256 = "1dvk1y1afqlmmqqdm91lg2wvny5q47yfjvmjzaryk2ic1s6g17b1";

  # these tests depend on a patched version of flamegraph which is included in
  # the github repository as a submodule, but absent from the crates version
  checkFlags = [
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace"
    "--skip=collapse::dtrace::tests::test_collapse_multi_dtrace_simple"
    "--skip=collapse::perf::tests::test_collapse_multi_perf"
    "--skip=collapse::perf::tests::test_collapse_multi_perf_simple"
  ];

  meta = with lib; {
    description = "A port of parts of the flamegraph toolkit to Rust";
    homepage = "https://github.com/jonhoo/inferno";
    changelog = "https://github.com/jonhoo/inferno/blob/v${version}/CHANGELOG.md";
    license = licenses.cddl;
    maintainers = with maintainers; [ figsoda ];
  };
}
