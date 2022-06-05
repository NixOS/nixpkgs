{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "sha256-USHg1KXl0MOWifiVu+KdjvrbDlAh6T/ReKFKeIpVK0A=";
  };

  vendorSha256 = "sha256-O63QEo0/+m9cYktMg4+RloLuUfAlCG0eGkxpHPFg/Cw=";

  meta = with lib; {
    description = "Enrich `go test` outputs with text decorations";
    homepage = "https://github.com/kyoh86/richgo";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
