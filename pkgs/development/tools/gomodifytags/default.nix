{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "gomodifytags";
    rev = "v${version}";
    sha256 = "sha256-XVjSRW7FzXbGmGT+xH4tNg9PVXvgmhQXTIrYYZ346/M=";
  };

  vendorHash = "sha256-0eWrkOcaow+W2Daaw2rzugfS+jqhN6RE2iCdpui9aQg=";

  meta = {
    description = "Go tool to modify struct field tags";
    mainProgram = "gomodifytags";
    homepage = "https://github.com/fatih/gomodifytags";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.bsd3;
  };
}
