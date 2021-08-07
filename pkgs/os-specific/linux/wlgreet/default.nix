{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "wlgreet";
  version = "0.3";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "0n0lzg3y1z5s9s6kfkdj5q8w67bqpw08hqfccc5kz0ninzy9j0cc";
  };

  cargoSha256 = "1lwy8xmkl9n3fj3wlf80wp728nn9p5rjnbgmm2cbpqxklcgbmxhm";

  meta = with lib; {
    description = "Raw wayland greeter for greetd, to be run under sway or similar";
    homepage = "https://git.sr.ht/~kennylevinsen/wlgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
