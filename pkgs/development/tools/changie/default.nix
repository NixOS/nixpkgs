{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.8.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-VzrSfigpkOvgywq0dHIXZS2If8qc8HCo51FzopKORwM=";
  };

  vendorSha256 = "sha256-+Q0vNMd8wFz+9bOPfqdPpN2brnUmIf46/9rUYsCTUrQ=";

  meta = with lib; {
    homepage = "https://changie.dev";
    description = "Automated changelog tool for preparing releases with lots of customization options";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

