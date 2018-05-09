{callPackage}:

{
  util-linux = callPackage ./util-linux { };

  net-tools = callPackage ./net-tools { };

  procps-ng = callPackage ./procps-ng { };

  quota = callPackage ../../tools/misc/linuxquota { };

  pam = callPackage ./pam { };

}
