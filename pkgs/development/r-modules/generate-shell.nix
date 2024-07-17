with import ../../.. { };

stdenv.mkDerivation {
  name = "generate-r-packages-shell";

  buildCommand = "exit 1";

  buildInputs = [
    wget
    cacert
    nix
  ];

  nativeBuildInputs = [
    (rWrapper.override {
      packages = with rPackages; [
        data_table
        parallel
        BiocManager
      ];
    })
  ];
}
