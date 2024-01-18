{ lib, openssl, pkg-config, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.4.3";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    rev = "v${version}";
    sha256 = "sha256-IxAmamWJjM8DAEihH3lYgOLKOcSRvh48GSIX797Nhjo=";
  };

  cargoHash = "sha256-vQTxqAnnfjg4zFSOPLIcchRjqv0HJ3L2jBSNubpO9DM=";

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
    description = "A one-shot cloud provider agent";
    license = licenses.asl20;
    maintainers = [ maintainers.arianvp ];
    platforms = platforms.linux;
  };
}
