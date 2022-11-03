{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule {
  pname = "go-libp2p-daemon";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "libp2p";
    repo = "go-libp2p-daemon";
    rev = "bfa207ed34c27947f0828a4ae8d10bda62aa49a9";
    sha256 = "1f3gjkmpqngajjpijpjdmkmsjfm9bdgakb5r28fnc6w9dmfyj51x";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-avbDJb31hDt0XAKOHpL6UZFEeJ5NErCQ6bWamcyuQ3U=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/libp2p/go-libp2p-daemon";
    license = licenses.mit;
    maintainers = with maintainers; [ fare ];
  };
}
