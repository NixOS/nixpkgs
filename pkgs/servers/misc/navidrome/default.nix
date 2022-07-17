{ lib, stdenv, buildGoModule, fetchFromGitHub, ffmpeg, ffmpegSupport ? true,
  makeWrapper, pkg-config, taglib, taglib_extras, zlib, callPackage, nixosTests}:

with lib;

buildGoModule rec {
  pname = "navidrome";
  version = import ./version.nix;

  # Can't use -trimpath because tests require accurate working dir.
  allowGoReference = true;

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${version}";
    sha256 = import ./source-sha.nix;
  };

  vendorSha256 = import ./vendor-sha.nix;

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ taglib taglib_extras zlib ];

  ui = callPackage ./ui.nix { };

  preBuild = ''
    rm -rf ui/build
    cp -r ${ui}/libexec/navidrome-ui/deps/navidrome-ui/build ui/build
  '';

  postFixup = optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${makeBinPath [ ffmpeg ]}
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.navidrome = nixosTests.navidrome;
  };

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ aciceri ];
  };
}
