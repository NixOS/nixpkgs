{ stdenv
, lib
, fetchFromGitHub
, flutter
, makeDesktopItem
, libvlc
, copyDesktopItems
}:

flutter.mkFlutterApp rec {
  pname = "convenient-test-manager";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "fzyzcjy";
    repo = "flutter_convenient_test";
    rev = "v${version}";
    sha256 = "sha256-f0+nATpBAd+3ELRq7dfKi9HCawgF3LAAs0UqYjnKCPw=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${placeholder "out"}/bin/convenient_test_manager";
    icon = "convenient_test_manager";
    desktopName = "Convenient Test Manager";
    genericName = "Flutter test runner";
    categories = [ "Development" ];
  };

  vendorHash = "sha256-iR/U2vQQqj95j1XkgW3/u7DQzwQrNmho9M4yLvefb4A=";

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [ libvlc ];

  sourceRoot = "source/packages/convenient_test_manager";
  meta = with lib; {
    description = "Companion app to the widely used Flutter convenient_test framework";
    homepage = "https://github.com/fzyzcjy/flutter_convenient_test";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gilice ];
  };
}
