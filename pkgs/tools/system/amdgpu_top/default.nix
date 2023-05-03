{ lib, rustPlatform, fetchFromGitHub, libdrm }:

rustPlatform.buildRustPackage rec {
  pname = "amdgpu_top";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = pname;
    rev = "v${version}-stable";
    hash = "sha256-cdKUj0pUlXxMNx0jypuov4hX3CISTDaSQh+KFB5R8ys=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  buildInputs = [ libdrm ];

  meta = with lib; {
    description = "Tool to display AMDGPU usage";
    homepage = "https://github.com/Umio-Yasuno/amdgpu_top";
    changelog = "https://github.com/Umio-Yasuno/amdgpu_top/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ geri1701 ];
  };
}
