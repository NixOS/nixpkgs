{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "unfurl";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "unfurl";
    rev = "v${version}";
    hash = "sha256-7aLe5d8ku5llfJ2xh8fT56vqj12/CJ1ez3Vte2PF8KQ=";
  };

  vendorHash = "sha256-Kpd916+jjGvw56N122Ej4CXVcv1/xr1THkjsrhkIy+U=";

  ldflags = [ "-s" "-w" ];

  # tests tries to download a list of tlds from the internet
  postPatch = ''
    echo com > /tmp/.tlds
  '';

  meta = with lib; {
    description = "Pull out bits of URLs provided on stdin";
    mainProgram = "unfurl";
    homepage = "https://github.com/tomnomnom/unfurl";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
