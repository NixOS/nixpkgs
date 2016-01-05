with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "update-r-packages-shell";

  buildCommand = "exit 1";

  nativeBuildInputs = [ 
    (rWrapper.override {
      packages = with rPackages; [
        data_table
        parallel
      ];
    })
    wget
  ];
}
