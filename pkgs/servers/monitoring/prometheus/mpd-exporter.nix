{ stdenv
, rustPlatform
, fetchgit
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "prometheus-mpd-exporter";
  version = "0.1.0";

  src = fetchgit {
    url = "https://git.beyermatthi.as/prometheus-mpd-exporter";
    rev = "$v{version}";
    sha256 = "0nizmz29b64cywamfhfwwjbsfb3n9nb2dndl35li9z4v67lb5khi";
  };

  cargoSha256 = "0snrfcjawla9ra40x22w5zrr8xnsyhlyj21di8gp5wzf0yj1a9n1";

  nativeBuildInputs = [ pkg-config openssl ];

  meta = with stdenv.lib; {
    description = "Export mpd metrics to prometheus";
    homepage = "https://git.beyermatthi.as/prometheus-mpd-exporter";
    license = with licenses; [ gpl2.0 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}


