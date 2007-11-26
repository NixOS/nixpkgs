let {

  allPackages = import ./all-packages.nix;

  i686LinuxPkgs = {inherit (allPackages {system = "i686-linux";})
    aterm
    gcc
    nixUnstable
    pan
    subversion
    ;
  };

  x86_64LinuxPkgs = {inherit (allPackages {system = "x86_64-linux";})
    aterm
    gcc
    nixUnstable
    pan
    subversion
    ;    
  };
  
  powerpcLinuxPkgs = {inherit (allPackages {system = "powerpc-linux";})
    aterm
  ;};
  
  body = [
    i686LinuxPkgs
    x86_64LinuxPkgs
#   powerpcLinuxPkgs
  ];
}
