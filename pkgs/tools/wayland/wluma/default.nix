{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rustPlatform
, vulkan-loader
, pkg-config
, udev
, v4l-utils
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-kUYh4RmD4zRI3ZNZWl2oWcO0Ze5czLBXUgPMl/cLW/I=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    v4l-utils
  ];

  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ vulkan-loader ]}"
  '';

  cargoSha256 = "sha256-oOIL18gij7DdvgNOuaHtuyFemNBUB85Ouh/sdhKas+s=";

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    license = licenses.isc;
    maintainers = with maintainers; [ yshym jmc-figueira ];
    platforms = platforms.linux;
  };
}
