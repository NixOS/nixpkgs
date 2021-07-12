{ lib, openssl, pkg-config, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    rev = "v${version}";
    sha256 = "sha256-sdgAZuT8bIX4eWN7nLNNyclxazmCBr5kDFS6s6cRXVU=";
  };

  cargoSha256 = "sha256-IzcaaQjge2z49XwyFcPHX/AMjvrbcOLw0J1qBzHw7Is=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  patchPhase = ''
    substituteInPlace ./systemd/afterburn-checkin.service --replace /usr/bin $out/bin
    substituteInPlace ./systemd/afterburn-firstboot-checkin.service --replace /usr/bin $out/bin
    substituteInPlace ./systemd/afterburn-sshkeys@.service.in --replace /usr/bin $out/bin
    substituteInPlace ./systemd/afterburn.service --replace /usr/bin $out/bin
  '';

  postInstall = ''
    DEFAULT_INSTANCE=root PREFIX= DESTDIR=$out make install-units
  '';

  meta = with lib; {
    homepage = "https://github.com/coreos/ignition";
    description = "This is a small utility, typically used in conjunction with Ignition, which reads metadata from a given cloud-provider and applies it to the system.";
    license = licenses.asl20;
    maintainers = [ maintainers.arianvp ];
    platforms = [ "x86_64-linux" ];
  };
}
