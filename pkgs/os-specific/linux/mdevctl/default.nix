{ lib
, rustPlatform
, fetchCrate
, docutils
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "mdevctl";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0X/3DWNDPOgSNNTqcj44sd7DNGFt+uGBjkc876dSgU8=";
  };

  cargoHash = "sha256-TmumQBWuH5fJOe2qzcDtEGbmCs2G9Gfl8mH7xifzRGc=";

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  postInstall = ''
    ln -s mdevctl $out/bin/lsmdev

    install -Dm444 60-mdevctl.rules -t $out/lib/udev/rules.d

    installManPage $releaseDir/build/mdevctl-*/out/mdevctl.8
    ln -s mdevctl.8 $out/share/man/man8/lsmdev.8

    installShellCompletion $releaseDir/build/mdevctl-*/out/{lsmdev,mdevctl}.bash
  '';

  meta = with lib; {
    homepage = "https://github.com/mdevctl/mdevctl";
    description = "A mediated device management utility for linux";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
