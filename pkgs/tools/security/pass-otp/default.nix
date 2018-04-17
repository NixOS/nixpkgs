{ stdenv, pass, fetchFromGitHub, oathToolkit }:
stdenv.mkDerivation rec {
  name = "pass-otp-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "v${version}";
    sha256 = "1cgj4zc8fq88n3h6c0vkv9i5al785mdprpgpbv5m22dz9p1wqvbb";
  };

  buildInputs = [ pass oathToolkit ];

  patchPhase = ''
    sed -i -e 's|OATH=\$(which oathtool)|OATH=${oathToolkit}/bin/oathtool|' otp.bash
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "A pass extension for managing one-time-password (OTP) tokens";
    homepage = https://github.com/tadfisher/pass-otp;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jwiegley tadfisher ];
    platforms = platforms.unix;
  };
}
