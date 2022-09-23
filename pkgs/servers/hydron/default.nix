{ lib, buildGoModule, fetchFromGitHub, pkg-config, ffmpeg }:

buildGoModule rec {
  pname = "hydron";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "bakape";
    repo = "hydron";
    rev = "v${version}";
    sha256 = "0c958dsw5pq9z8n1b9q9j8y6vgiqf6mmlsf77ncb7yrlilhbrz6s";
  };

  vendorSha256 = "0cc8ar8p7lgg6rj76vhfp6bzrxyn5yaqjwj8i1bn0zp6sj6zcfam";
  proxyVendor = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg ];

  meta = with lib; {
    homepage = "https://github.com/bakape/hydron";
    description = "High performance media tagger and organizer";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ Madouura ];
  };
}
