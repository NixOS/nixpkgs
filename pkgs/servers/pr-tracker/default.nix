{ rustPlatform
, lib
, fetchgit
, openssl
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "1.0.0";

  src = fetchgit {
    url = "https://git.qyliss.net/pr-tracker";
    rev = version;
    sha256 = "sha256-NHtY05Llrvfvcb3uyagLd6kaVW630TIP3IreFrY3wl0=";
  };

  cargoSha256 = "sha256-SgSASfIanADV31pVy+VIwozTLxq7P3oMDIiAAQ8s+k0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl systemd ];

  meta = with lib; {
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
