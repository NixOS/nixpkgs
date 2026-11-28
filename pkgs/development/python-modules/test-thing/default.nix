{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  flit-core,
  OVMF,
  coreutils,
  systemd,
  testers,
}:

buildPythonPackage (finalAttrs: {
  pname = "test-thing";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lis";
    repo = "test.thing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+m/2a0HEJtpPuYyHSeswSh7FnXLjEMbg6re4+bfd4Sk=";
  };

  build-system = [ flit-core ];

  postPatch = ''
    substituteInPlace testthing.py \
      --replace-fail \
        '"/usr/share/OVMF/OVMF_CODE.fd",' \
        '"${OVMF.fd}/FV/OVMF.fd",' \
      --replace-fail \
        '"/usr/share/ovmf/OVMF.fd",' \
        '"${OVMF.fd}/FV/OVMF.fd",' \
      --replace-fail \
        '"/usr/share/edk2/x64/OVMF.4m.fd",' \
        '"${OVMF.fd}/FV/OVMF.fd",' \
      --replace-fail \
        '"/usr/lib/systemd/systemd-ssh-proxy vsock-mux/{port} 22"' \
        '"${systemd}/lib/systemd/systemd-ssh-proxy vsock-mux/{port} 22"' \
      --replace-fail \
        'socket,id=vsock,reconnect=0,path=' \
        'socket,id=vsock,path=' \
      --replace-fail \
        '"KnownHostsCommand": "/bin/echo %H %t %K",' \
        '"KnownHostsCommand": "${coreutils}/bin/echo %H %t %K",'
  '';

  # The upstream test suite downloads a cloud image and needs networking, so it
  # cannot run in the Nix build sandbox.
  doCheck = false;

  pythonImportsCheck = [ "testthing" ];

  postInstall = ''
    mkdir -p $out/share/doc/test-thing
    cp doc/VirtualMachineAPI.md $out/share/doc/test-thing/
    cp -r workarounds $out/share/test-thing-workarounds
  '';

  # `tt` has no --version flag (upstream exposes __version__ only from Python).
  passthru.tests.cli = testers.runCommand {
    name = "test-thing-cli";
    nativeBuildInputs = [ finalAttrs.finalPackage ];
    script = ''
      tt --help

      testthing=$(python3 -c 'import testthing; print(testthing.__file__)')
      grep -qF '${OVMF.fd}/FV/OVMF.fd' "$testthing"
      grep -qF '${systemd}/lib/systemd/systemd-ssh-proxy' "$testthing"
      ! grep -qF '"/usr/share/OVMF' "$testthing"
      ! grep -qF '"/usr/lib/systemd/systemd-ssh-proxy' "$testthing"

      python3 -c 'import testthing; assert testthing.__version__ == "${finalAttrs.version}"'

      touch $out
    '';
  };

  meta = {
    description = "Simple modern virtual machine runner";
    longDescription = ''
      A single-file Python runner that boots stock cloud images and drives them
      from the outside over SSH via virtio-vsock, using systemd credentials
      passed through SMBIOS OEM strings. No cloud-init and no guest agent are required.

      The guest must satisfy `doc/VirtualMachineAPI.md` from the source tree.
    '';
    homepage = "https://codeberg.org/lis/test.thing";
    changelog = "https://codeberg.org/lis/test.thing/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.raitobezarius ];
    mainProgram = "tt";
  };
})
