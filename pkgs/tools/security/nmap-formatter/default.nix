{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JqSsFEZmmVOnNza9xh+JrlWxE4XdA1GSX9yw2NIPYhQ=";
  };

  vendorHash = "sha256-MiBY4kWBZM2ZcW3SMqQ+7gKFnFt78wMI9S3OfCgth5g=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
