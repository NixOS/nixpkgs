{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "txtpbfmt";
  version = "unstable-2023-10-25";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "084445ff1adf0d8a27429bba65dbde5663f02d26";
    hash = "sha256-SoU1GON9avesty6FSZ+z6o2JHInUtwv+PVOzqCu+8L8=";
  };

  vendorHash = "sha256-IdD+R8plU4/e9fQaGSM5hJxyMECb6hED0Qg8afwHKbY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
