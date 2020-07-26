with import ../../.. {};

stdenv.mkDerivation {
  name = "generate-r-packages-shell";

  buildCommand = "exit 1";

  buildInputs = [ wget jq ];

  nativeBuildInputs = [
    (rWrapper.override {
      packages = with rPackages; [
        data_table
        parallel
      ];
    })
  ];
}
