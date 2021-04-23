{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "wlgreet";
  version = "2020-10-20";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = "4425d296b81550cce01f044fbd7ff083e37550f4";
    sha256 = "0n0lzg3y1z5s9s6kfkdj5q8w67bqpw08hqfccc5kz0ninzy9j0cc";
  };

  cargoSha256 = "01bfv2kzg2r9z75b8pq61n2ydc8l5zh69jdyjpj931l642f6kd5a";

  meta = with lib; {
    description = "Raw wayland greeter for greetd, to be run under sway or similar";
    homepage = "https://git.sr.ht/~kennylevinsen/wlgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
