{ lib, openssl, pkg-config, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    rev = "v${version}";
    sha256 = "sha256-5dzgvoR6qGlVz0RJ1j9B4yna1aCbOczVLcU++GWNEL8=";
  };

  cargoSha256 = "sha256-cqipYIH/XHMe7ppsXPVnDfsUqXoIep7CHiOGEPbZK4M=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
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
