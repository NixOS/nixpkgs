{ rustPlatform
, lib
, fetchurl
, openssl
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "1.2.0";

  src = fetchurl {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    sha256 = "sha256-Tru9DsitRQLiO4Ln70J9LvkEqcj2i4A+eArBvIhd/ls=";
  };

  cargoSha256 = "0q3ibxnzw8gngvrgfkv4m64dr411c511xkvb6j9k63vhy9vwarz7";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl systemd ];

  meta = with lib; {
    changelog = "https://git.qyliss.net/pr-tracker/plain/NEWS?h=${version}";
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ qyliss sumnerevans ];
  };
}
