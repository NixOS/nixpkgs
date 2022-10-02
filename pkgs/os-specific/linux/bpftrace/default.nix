{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, pkg-config, flex, bison
, llvmPackages, elfutils
, libbfd, libbpf, libopcodes, bcc
, cereal, asciidoctor
, nixosTests
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.15.0";

  # Cherry-picked from merged PR, remove this hook on next update
  # https://github.com/iovisor/bpftrace/pull/2242
  # Cannot `fetchpatch` such pure renaming diff since
  # https://github.com/iovisor/bpftrace/commit/2df807dbae4037aa8bf0afc03f52fb3f6321c62a.patch
  # does not contain any diff in unified format but just this instead:
  #   ...
  #   man/man8/{bashreadline.8 => bashreadline.bt.8}     | 0
  #   ...
  #   35 files changed, 0 insertions(+), 0 deletions(-)
  #   rename man/man8/{bashreadline.8 => bashreadline.bt.8} (100%)
  #   ...
  # on witch `fetchpatch` fails with
  #   error: Normalized patch '/build/patch' is empty (while the fetched file was not)!
  #   Did you maybe fetch a HTML representation of a patch instead of a raw patch?
  postUnpack = ''
    rename .8 .bt.8 "$sourceRoot"/man/man8/*.8
  '';

  src = fetchFromGitHub {
    owner  = "iovisor";
    repo   = "bpftrace";
    rev    = "v${version}";
    sha256 = "sha256-9adZAKSn00W2yNwVDbVB1/O5Y+10c4EkVJGCHyd4Tgg=";
  };

  patches = [
    # Pull upstream fix for binutils-2.39:
    #   https://github.com/iovisor/bpftrace/pull/2328
    (fetchpatch {
      name = "binutils-2.39.patch";
      url = "https://github.com/iovisor/bpftrace/commit/3be6e708d514d3378a4fe985ab907643ecbc77ee.patch";
      sha256 = "sha256-WWEh8ViGw8053nEG/29KeKEHV5ossWPtL/AAV/l+pnY=";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  buildInputs = with llvmPackages;
    [ llvm libclang
      elfutils bcc
      libbpf libbfd libopcodes
      cereal asciidoctor
    ];

  nativeBuildInputs = [ cmake pkg-config flex bison llvmPackages.llvm.dev util-linux ];

  # tests aren't built, due to gtest shenanigans. see:
  #
  #     https://github.com/iovisor/bpftrace/issues/161#issuecomment-453606728
  #     https://github.com/iovisor/bpftrace/pull/363
  #
  cmakeFlags =
    [ "-DBUILD_TESTING=FALSE"
      "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    ];

  # nuke the example/reference output .txt files, for the included tools,
  # stuffed inside $out. we don't need them at all.
  # (see "Allow skipping examples" for a potential option
  #  https://github.com/iovisor/bpftrace/pull/2256)
  #
  # Pull BPF scripts into $PATH (next to their bcc program equivalents), but do
  # not move them to keep `${pkgs.bpftrace}/share/bpftrace/tools/...` working.
  # (remove `chmod` once a new release "Add executable permission to tools"
  #  https://github.com/iovisor/bpftrace/commit/77e524e6d276216ed6a6e1984cf204418db07c78)
  postInstall = ''
    rm -rf $out/share/bpftrace/tools/doc

    ln -s $out/share/bpftrace/tools/*.bt $out/bin/
    chmod +x $out/bin/*.bt
  '';

  outputs = [ "out" "man" ];

  passthru.tests = {
    bpf = nixosTests.bpf;
  };

  meta = with lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage    = "https://github.com/iovisor/bpftrace";
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice martinetd ];
  };
}
