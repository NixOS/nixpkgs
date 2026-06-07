{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-jdnR9qlw0sN+2IXRuu5wFe9yNXbh3Tfx2XlT6aPw4Pg=";
    linux_arm64 = "sha256-xbfUm1SJjYzU9jIq52f2lNDPIZ6tN91G9LqLUOS4CjY=";
    darwin_x64 = "sha256-plEwXsDChoAhbkIDXk+rsW9baSKs7XzkOE9JMgnrIWA=";
    darwin_arm64 = "sha256-aIO03xEQkYcRtTYFO2MgGu2ZEMYs7XIJ2+gJ9Xq67vo=";
  };

  includeInPath = [ ccextractor ];
}
