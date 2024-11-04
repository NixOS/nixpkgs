{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libusb1
, darwin
, blink1-tool
, testers
}:

stdenv.mkDerivation rec {
  pname = "blink1-tool";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "todbot";
    repo = "blink1-tool";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-gwfz67vza+XoZk+zG3zEo4hW3R1GFrw9FzCzmN1mPkM=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CFLAGS += -arch x86_64 -arch arm64" ""
  '';
  preInstall = ''
    mkdir -p $out/lib $out/bin
  '';

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp 51-blink1.rules $out/lib/udev/rules.d
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.AppKit;

  makeFlags = [
    "GIT_TAG=v${version}"
    "BLINK1_VERSION=${version}"
  ];

  hardeningDisable = [ "format" ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = blink1-tool;
      };
    };
  };

  meta = {
    description = "Command line client for the blink(1) notification light";
    homepage = "https://blink1.thingm.com/";
    license = with lib.licenses; [ cc-by-sa-40 ];
    maintainers = with lib.maintainers; [ cransom ];
    platforms = lib.platforms.unix;
    mainProgram = "blink1-tool";
  };
}
