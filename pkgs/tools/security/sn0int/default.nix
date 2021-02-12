{ lib, fetchFromGitHub, rustPlatform, libsodium, libseccomp, sqlite, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zjrbrkk7phv8s5qr0gj6fnssa31j3k3m8c55pdfmajh7ry7wwd1";
  };

  cargoSha256 = "0mzxhwknx844b1yjsf1jmvymhilppa2xyqp0s35awi5ca1jbrgn4";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsodium libseccomp sqlite ];

  # One of the dependencies (chrootable-https) tries to read "/etc/resolv.conf"
  # in "checkPhase", hence fails in sandbox of "nix".
  doCheck = false;

  meta = with lib; {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
