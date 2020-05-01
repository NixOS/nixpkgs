{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkgconfig, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "0pmh6x7rb0v1g087xgyicw9mm4ayppgh7vzvq3hs8vip2zvy7r56";
  };

  cargoSha256 = "00lh6nxc17dyl8z2l70gzc7l1vpn448lzi1c69wxxcqnk8y0ka9w";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl  ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

