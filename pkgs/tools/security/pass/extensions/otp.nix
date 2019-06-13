{ stdenv, fetchFromGitHub, oathToolkit }:

stdenv.mkDerivation rec {
  name = "pass-otp-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "v${version}";
    sha256 = "0m8x5dqwcr9jim530685nsq4zn941hhl7ridmmd63b204z141rwa";
  };

  buildInputs = [ oathToolkit ];

  dontBuild = true;

  patchPhase = ''
    sed -i -e 's|OATH=\$(which oathtool)|OATH=${oathToolkit}/bin/oathtool|' otp.bash
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A pass extension for managing one-time-password (OTP) tokens";
    homepage = https://github.com/tadfisher/pass-otp;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jwiegley tadfisher ];
    platforms = platforms.unix;
  };
}
