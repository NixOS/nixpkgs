{ pkgs, ... }:

{
  nodes = {

    server =
      { config, pkgs, ... }:

      {
        services.openssh.enable = true;
      };

    client =
      { config, pkgs, ... }: { };

  };

  testScript = ''
    startAll;

    my $key=`${pkgs.openssh}/bin/ssh-keygen -t dsa -f key -N ""`;

    $server->waitForJob("sshd");

    $server->mustSucceed("mkdir -m 700 /root/.ssh");
    $server->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");

    $client->mustSucceed("mkdir -m 700 /root/.ssh");
    $client->copyFileFromHost("key", "/root/.ssh/id_dsa");
    $client->mustSucceed("chmod 600 /root/.ssh/id_dsa");

    $client->waitForJob("network-interfaces");
    $client->mustSucceed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'echo hello world' >&2");
  '';
}
