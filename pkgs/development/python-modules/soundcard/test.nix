{
  name = "Python Soundcard Library Test";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (pkgs.python3.withPackages (ps: [ ps.soundcard ])) ];

      services.pulseaudio.enable = true;
      services.pulseaudio.systemWide = true;

      virtualisation.qemu.options = [
        "-device virtio-sound-pci,audiodev=my_audiodev"
        "-audiodev wav,id=my_audiodev"
      ];
    };

  interactive.nodes.machine =
    { ... }:
    {
      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";
      users.extraUsers.root.initialPassword = "";
      users.extraUsers.root.hashedPassword = null;
      users.extraUsers.root.hashedPasswordFile = null;
      users.extraUsers.root.initialHashedPassword = null;
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
      ];
    };

  testScript =
    let
      script = builtins.toFile "import.py" ''
        import soundcard
      '';
    in
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("python ${script}")
    '';
}
