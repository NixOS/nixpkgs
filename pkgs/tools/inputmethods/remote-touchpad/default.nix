{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, libXi
, libXt
, libXtst
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2oHjx5RpuZmWcv954ZOrmHhOkQBfrDpEFqgiBFQfAuo=";
  };

  buildInputs = [ libX11 libXi libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorSha256 = "sha256-8w3muVJwDmFKY6AFKv/x6vS6jIyR7M/wlxzAvl5ROdE=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
