{
  lib,
  runCommand,
  openssh,
}:

runCommand "ssh-copy-id-${openssh.version}"
  {
    outputs = [
      "out"
      "man"
    ];
    meta = openssh.meta // {
      description = "Tool to copy SSH public keys to a remote machine";
      priority = (openssh.meta.priority or lib.meta.defaultPriority) - 1;
    };
  }
  ''
    install -Dm 755 {${openssh},$out}/bin/ssh-copy-id
    install -Dm 644 {${openssh.man},$man}/share/man/man1/ssh-copy-id.1.gz
  ''
