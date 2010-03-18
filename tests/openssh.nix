{pkgs, ...}:

{
  nodes = {
    server = 
      {pkgs, config, ...}:
      
      {
        services.openssh.enable = true;
      }
    ;
    client = 
      {pkgs, config, ...}:
      
      {
      }      
    ;
  };
  
  testScript =
  ''
    my $key=`${pkgs.openssh}/bin/ssh-keygen -t dsa -f key -N ""`;
    
    $server->mustSucceed("mkdir /root/.ssh");
    $server->mustSucceed("chmod 700 /root/.ssh");
    $server->copyFileFromHost("key.pub", "/root/.ssh/authorized_keys");
    
    $client->mustSucceed("mkdir /root/.ssh");
    $client->mustSucceed("chmod 700 /root/.ssh");
    $client->copyFileFromHost("key", "/root/.ssh/id_dsa");
    $client->mustSucceed("chmod 600 /root/.ssh/id_dsa");
    
    $client->mustSucceed("ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no server 'echo hello world'");
  '';
}
