{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "00hhgh6nrzg2blc6yl8rph5h5w7swlkbh0zgsj7xr0lkm10879pc";
    rev = "v${version}";
  };

  modSha256 = "0kgd8lwcdns3skvd4bj4z85mq6hkk79mb0zzwky0wqxni8f73s6w";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
