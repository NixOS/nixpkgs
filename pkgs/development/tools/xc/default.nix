{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.0.154";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GJBSPO0PffGdGAHofd1crEFXJi2xqgd8Vk2/g4ff+E4=";
  };

  vendorHash = "sha256-XDJdCh6P8ScSvxY55ExKgkgFQqmBaM9fMAjAioEQ0+s=";

  meta = with lib; {
    homepage = "https://xcfile.dev/";
    description = "Markdown defined task runner";
    license = licenses.mit;
    maintainers = with maintainers; [ joerdav ];
  };
}
