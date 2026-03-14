{
  lib,
  buildGoModule,
  fetchFromGitHub,
  kernel,
  bpftools,
  bpf2go,
  clang,
  libbpf,
  nixosTests,
}:

buildGoModule rec {
  pname = "psc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "loresuso";
    repo = "psc";
    rev = "v${version}";
    hash = "sha256-D0Jy+2e7BjxZe3vFl0iR4a1fo/YOA1FfTyEusKjDraw=";
  };

  vendorHash = "sha256-fUdbCgek1msYm+VUj8DZQE/jnwlQ8jAz712h5RhJuy0=";

  nativeBuildInputs = [
    clang
    bpftools
    bpf2go
  ];

  # eBPF compilation doesn't support -fzero-call-used-regs
  hardeningDisable = [ "zerocallusedregs" ];

  postPatch = ''
    # Generate vmlinux.h from kernel BTF
    bpftool btf dump file ${kernel.dev}/vmlinux format c > bpf/vmlinux.h
  '';

  preBuild = ''
    # Generate eBPF Go bindings using bpf2go
    bpf2go -go-package main -cc clang -no-strip -target bpfel \
      -cflags "-O2 -g -Wall -I${libbpf}/include" tasks bpf/tasks.c
    bpf2go -go-package main -cc clang -no-strip -target bpfel \
      -cflags "-O2 -g -Wall -I${libbpf}/include" files bpf/files.c
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/loresuso/psc/cmd.Version=${version}"
    "-X=github.com/loresuso/psc/cmd.Commit=${src.rev}"
    "-X=github.com/loresuso/psc/cmd.BuildDate=1970-01-01T00:00:00Z"
  ];

  passthru.tests = {
    inherit (nixosTests) bpf docker podman;
  };

  meta = {
    description = "The ps utility, with an eBPF twist and container context";
    homepage = "https://github.com/loresuso/psc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
    mainProgram = "psc";
    platforms = lib.platforms.linux;
  };
}
