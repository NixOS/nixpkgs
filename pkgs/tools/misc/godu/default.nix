{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "godu";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "viktomas";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fp8iq4x0qiswksznnd6qh7c6g5pwglzz6ga11a7vgic0201wsvb";
  };

  patches = [ ./go-mod.patch ];

  vendorSha256 = "1zq7b0zn24cbrjssk4g03i90szp1ms7ila4khwcm7hp9n1py245s";

  meta = with lib; {
    description = "Utility helping to discover large files/folders";
    homepage = "https://github.com/viktomas/godu";
    license = licenses.mit;
    maintainers = with maintainers; [ rople380 ];
  };
}
