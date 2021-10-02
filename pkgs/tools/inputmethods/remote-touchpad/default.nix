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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "09a252z69msy4wd5kazpca8dcn0a2djdw0vs663062fl977p73qs";
  };

  buildInputs = [ libX11 libXi libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorSha256 = "1pgj0m67g759mcs4s34h4pq3mc7gni643z5cp6ffq4rrn8mdi060";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
