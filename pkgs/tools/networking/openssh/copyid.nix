{ runCommand, openssh }:

runCommand "ssh-copy-id-${openssh.version}" {
  meta = openssh.meta // {
    description = "Tool to copy SSH public keys to a remote machine";
    priority = (openssh.meta.priority or 0) - 1;
  };
} ''
  install -Dm 755 {${openssh},$out}/bin/ssh-copy-id
  install -Dm 644 {${openssh},$out}/share/man/man1/ssh-copy-id.1.gz
''
