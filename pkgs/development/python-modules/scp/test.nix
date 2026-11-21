{
  pkgs,
  ...
}:
let
  scp-test-script = pkgs.python3Packages.buildPythonApplication {
    inherit (pkgs.python3Packages.scp) src version;

    pname = "scp-test";
    pyproject = false;

    dependencies = with pkgs.python3Packages; [
      scp
    ];

    # Add a shebang to test.py so that patchShebangs can replace it with the correct one
    postPatch = ''
      sed -i "1i #!/usr/bin/env python3" test.py
    '';

    installPhase = ''
      install -Dm755 "./test.py" "$out/bin/scp-test"
    '';
  };
in
{
  name = "Python SCP Library Test";

  nodes.machine = {
    environment.systemPackages = [ scp-test-script ];

    services.openssh.enable = true;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    machine.succeed("ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -P \"\"")
    machine.succeed("cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys")

    machine.succeed("${scp-test-script}/bin/scp-test")
  '';
}
