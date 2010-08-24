# Test Nix's remote build feature.

{ pkgs, ... }:

let

  # The configuration of the build slaves.
  slave = 
    { config, pkgs, ... }:
    { services.openssh.enable = true;
      virtualisation.writableStore = true;
    };

  # Trivial Nix expression to build remotely.
  expr = config: nr: pkgs.writeText "expr.nix"
    ''
      let utils = builtins.storePath ${config.system.build.extraUtils}; in
      derivation {
        name = "hello-${toString nr}";
        system = "i686-linux";
        PATH = "''${utils}/bin";
        builder = "''${utils}/bin/sh";
        args = [ "-c" "echo Hello; mkdir $out; cat /proc/sys/kernel/hostname > $out/host; sleep 3" ];
      }
    '';

in

{

  nodes =
    { slave1 = slave;
      slave2 = slave;

      client =
        { config, pkgs, ... }:
        { nix.maxJobs = 0; # force remote building
          nix.distributedBuilds = true;
          nix.buildMachines =
            [ { hostName = "slave1";
                sshUser = "root";
                sshKey = "/root/.ssh/id_dsa";
                system = "i686-linux";
                maxJobs = 1;
              }
              { hostName = "slave2";
                sshUser = "root";
                sshKey = "/root/.ssh/id_dsa";
                system = "i686-linux";
                maxJobs = 1;
              }
            ];
          virtualisation.writableStore = true;
          virtualisation.pathsInNixDB = [ config.system.build.extraUtils ];
        };
    };

  testScript = { nodes }:
    ''
      startAll;

      # Create an SSH key on the client.
      my $key = `${pkgs.openssh}/bin/ssh-keygen -t dsa -f key -N ""`;
      $client->succeed("mkdir -m 700 /root/.ssh");
      $client->copyFileFromHost("key", "/root/.ssh/id_dsa");
      $client->succeed("chmod 600 /root/.ssh/id_dsa");

      # Install the SSH key on the slaves.
      foreach my $slave ($slave1, $slave2) {
          $slave->succeed("mkdir -m 700 /root/.ssh");
          $slave->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");
          $slave->waitForJob("sshd");
          $client->succeed("ssh -o StrictHostKeyChecking=no " . $slave->name() . " 'echo hello world'");
      }

      # Perform a build and check that it was performed on the slave.
      my $out = $client->succeed("nix-build ${expr nodes.client.config 1}");
      $slave1->succeed("test -e $out");

      # And a parallel build.
      my ($out1, $out2) = split /\s/,
          $client->succeed("nix-store -r \$(nix-instantiate ${expr nodes.client.config 2} ${expr nodes.client.config 3})");
      $slave1->succeed("test -e $out1 -o -e $out2");
      $slave2->succeed("test -e $out1 -o -e $out2");
    '';

}
