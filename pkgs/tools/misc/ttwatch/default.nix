{ lib, stdenv, fetchFromGitHub
, cmake, perl, pkg-config
, openssl, curl, libusb1, protobufc
, enableUnsafe ? false }:

stdenv.mkDerivation {
  pname = "ttwatch";
  version = "2020-06-24";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "260aff5869fd577d788d86b546399353d9ff72c1";
    sha256 = "0yd2hs9d03gfvwm1vywpg2qga6x5c74zrj665wf9aa8gmn96hv8r";
  };

  nativeBuildInputs = [ cmake perl pkg-config ];
  buildInputs = [ openssl curl libusb1 protobufc ];

  cmakeFlags = lib.optionals enableUnsafe [ "-Dunsafe=on" ];

  preFixup = ''
    chmod +x $out/bin/ttbin2mysports
  '';

  meta = with lib; {
    homepage = "https://github.com/ryanbinns/ttwatch";
    description = "Linux TomTom GPS Watch Utilities";
    maintainers = with maintainers; [ dotlambda ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
