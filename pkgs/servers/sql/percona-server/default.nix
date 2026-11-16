self: {
  percona-server_8_4 = self.callPackage ./common.nix { } {
    version = "8.4.11-11";
    hash = "sha256-L7kOI1wlGD1zyXLLpIGjLqLZDO/KBmn+B4be/CrN+hg=";
  };
  percona-server = self.percona-server_8_4;
}
