{
  lib,
  clang,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:
buildGoModule rec {
  pname = "dae";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-A82JwjZTzYvRc0PY2FekRUwLszdCEHv6wcLYHvqwiWU=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-PCGv1DcOOP2LE5wGmnuB2t3aJP8nqJ/ChafVxeJnRIg=";

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  buildPhase = ''
    runHook preBuild

    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
    NOSTRIP=y \
    VERSION=${version} \
    OUTPUT=$out/bin/dae

    runHook postBuild
  '';

  # network required
  doCheck = false;

  postInstall = ''
    install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
    substituteInPlace $out/lib/systemd/system/dae.service \
      --replace /usr/bin/dae $out/bin/dae
  '';

  passthru.tests = {
    inherit (nixosTests) dae;
  };

  meta = with lib; {
    description = "Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      oluceps
      pokon548
    ];
    platforms = platforms.linux;
    mainProgram = "dae";
  };
}
