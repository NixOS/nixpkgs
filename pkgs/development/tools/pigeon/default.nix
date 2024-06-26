{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pigeon";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mna";
    repo = "pigeon";
    rev = "v${version}";
    sha256 = "sha256-0Cp/OnFvVZj9UZgl3F5MCzemBaHI4smGWU46VQnhLOg=";
  };

  vendorHash = "sha256-JbBXRkxnB7LeeWdBLIQvyjvWo0zZ1EOuEUPXxHWiq+E=";

  proxyVendor = true;

  subPackages = [ "." ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/mna/pigeon";
    description = "PEG parser generator for Go";
    mainProgram = "pigeon";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ bsd3 ];
  };
}
