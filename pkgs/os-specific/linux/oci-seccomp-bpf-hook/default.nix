{ lib
, buildGoModule
, fetchFromGitHub
, go-md2man
, installShellFiles
, pkg-config
, bcc
, libseccomp
}:

buildGoModule rec {
  pname = "oci-seccomp-bpf-hook";
  version = "1.2.9";
  src = fetchFromGitHub {
    owner = "containers";
    repo = "oci-seccomp-bpf-hook";
    rev = "v${version}";
    sha256 = "sha256-KPO9xqLgPML6smoO7P50yP81b4iCvRFIR74ciUiva7o=";
  };
  vendorHash = null;

  outputs = [ "out" "man" ];
  nativeBuildInputs = [
    go-md2man
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    bcc
    libseccomp
  ];

  checkPhase = ''
    go test -v ./...
  '';

  buildPhase = ''
    make
  '';

  postBuild = ''
    substituteInPlace oci-seccomp-bpf-hook.json --replace HOOK_BIN_DIR "$out/bin"
  '';

  installPhase = ''
    install -Dm755 bin/* -t $out/bin
    install -Dm644 oci-seccomp-bpf-hook.json -t $out
    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    homepage = "https://github.com/containers/oci-seccomp-bpf-hook";
    description = ''
      OCI hook to trace syscalls and generate a seccomp profile
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
  };
}
