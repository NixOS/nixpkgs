{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "psw";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Wulfsta";
    repo = pname;
    rev = version;
    sha256 = "1nwmps3zw99lrz6k1j14w4rcm7yj8vhf4cs9wjfc3c1zfjibz9iz";
  };

  cargoSha256 = "0a6hhangbx62nsyrfzbxjv7cg5c9d8wh83f02ay72gkf48sqy75h";

  meta = with lib; {
    description = "A command line tool to write random bytes to stdout";
    homepage = "https://github.com/Wulfsta/psw";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ wulfsta ];
  };
}
