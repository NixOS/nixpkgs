{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "envsubst";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "a8m";
    repo = "envsubst";
    rev = "v${version}";
    sha256 = "0zkgjdlw3d5xh7g45bzxqspxr61ljdli8ng4a1k1gk0dls4sva8n";
  };

  vendorSha256 = null;

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} LICENSE *.md
  '';

  meta = with lib; {
    description = "Environment variables substitution for Go";
    homepage = "https://github.com/a8m/envsubst";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
  };
}
