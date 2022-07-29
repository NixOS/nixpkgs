{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "blink1";
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
      --replace "@git submodule update --init" "true"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  makeFlags = [
    "GIT_TAG=v${version}"
    "USBLIB_TYPE=HIDAPI"
    "HIDAPI_TYPE=LIBUSB"
  ];

  hardeningDisable = [ "format" ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Command line client for the blink(1) notification light";
    homepage = "https://blink1.thingm.com/";
    license = with licenses; [ cc-by-sa-40 ];
    maintainers = with maintainers; [ cransom ];
    platforms = platforms.linux;
  };
}
