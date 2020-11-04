{ stdenv
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
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "containers";
    repo = "oci-seccomp-bpf-hook";
    rev = "v${version}";
    sha256 = "143x4daixzhhhpli1l14r7dr7dn3q42w8dddr16jzhhwighsirqw";
  };
  vendorSha256 = null;
  doCheck = false;

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

  meta = with stdenv.lib; {
    homepage = "https://github.com/containers/oci-seccomp-bpf-hook";
    description = ''
      OCI hook to trace syscalls and generate a seccomp profile
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
