{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, flex, bison
, llvmPackages, elfutils
, libelf, libbfd, libbpf, libopcodes, bcc
, cereal, asciidoctor
, nixosTests
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.14.1";

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
    sha256 = "sha256-QDqHAEVM/XHCFMS0jMLdKJfDUOpkUqONOf8+Fbd5dCY=";
  };

  # libbpf 0.6.0 relies on typeof in bpf/btf.h to pick the right version of
  # btf_dump__new() but that's not valid c++.
  # see https://github.com/iovisor/bpftrace/issues/2068
  patches = [ ./btf-dump-new-0.6.0.patch ];

  buildInputs = with llvmPackages;
    [ llvm libclang
      elfutils libelf bcc
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
  postInstall = ''
    rm -rf $out/share/bpftrace/tools/doc
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
