{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mnemonicode-${version}";
  version = "2015-11-30";
  src = fetchFromGitHub {
    owner = "singpolyma";
    repo = "mnemonicode";
    rev = "1687fabdf48acf68d4186f219bc20bffe02e8ee0";
    sha256 = "0kp1jhhqfwfiqg9kx0mbyr4qh4yc4zg4szqk5fbf809nx2pvprm5";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp mnencode $out/bin
    cp mndecode $out/bin
  '';
  meta = with lib; {
    description = ''
      Routines which implement a method for encoding binary data into a sequence
      of words which can be spoken over the phone, for example, and converted
      back to data on the other side.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.cstrahan ];
  };
}
