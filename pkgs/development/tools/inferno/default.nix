{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "inferno";
  version = "0.10.6";

  # github version doesn't have a Cargo.lock
  src = fetchCrate {
    inherit pname version;
    sha256 = "1pn3ask36mv8byd62xhm8bjv59k12i1s533jgb5syml64w1cnn12";
  };

  cargoSha256 = "0w5w9pyv34x0iy9knr79491kb9bgbcagh6251pq72mv4pvx0axip";

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
