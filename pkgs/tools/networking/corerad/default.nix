{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "corerad";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    hash = "sha256-vIKmE9Lq8We7BTMUHIgnOU370ZnNW7YG75WALWdG+4A=";
  };

  vendorHash = "sha256-dsqFleXpL8yAcdigqxJsk/Sxvp9OTqbGK3xDEiHkM8A=";

  # Since the tarball pulled from GitHub doesn't contain git tag information,
  # we fetch the expected tag's timestamp from a file in the root of the
  # repository.
  preBuild = ''
    ldflags+=" -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}"
    ldflags+=" -X github.com/mdlayher/corerad/internal/build.linkTimestamp=$(<.gittagtime)"
  '';

  passthru.tests = {
    inherit (nixosTests) corerad;
  };

  meta = with lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "Extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mdlayher
      jmbaur
    ];
    platforms = platforms.linux;
    mainProgram = "corerad";
  };
}
