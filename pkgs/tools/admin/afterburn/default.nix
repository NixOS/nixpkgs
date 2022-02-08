{ lib, openssl, pkg-config, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    rev = "v${version}";
    sha256 = "sha256-Uzkp4G72oarpBnhbgLoh//JW9kg/t2XpNbiZTNxMl/w=";
  };

  cargoSha256 = "sha256-92E76QwxeOLp9sfO066L97r2FO/9nQ4DaVyWJrL9L2M=";

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
