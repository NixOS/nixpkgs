{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prosody-filer";
  version = "unstable-2021-05-24";

  vendorSha256 = "05spkks77x88kc31c1zdg1cbf9ijymjs7qzmhg4c6lql5p2h5fbd";

  src = fetchFromGitHub {
    owner = "ThomasLeister";
    repo = "prosody-filer";
    rev = "c65edd199b47dc505366c85b3702230fda797cd6";
    sha256 = "0h6vp5flgy4wwmzhs6pf6qkk2j4ah8w919dwhfsq4wdpqs78kc0y";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ThomasLeister/prosody-filer";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.mit;
    platforms = platforms.linux;
    description = "A simple file server for handling XMPP http_upload requests";
 };
}
