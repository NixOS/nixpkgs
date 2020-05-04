{ stdenv, fetchFromGitHub, oathToolkit }:

stdenv.mkDerivation rec {
  pname = "pass-otp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "v${version}";
    sha256 = "0cpqrf3939hcvwg7sd8055ghc8x964ilimlri16czzx188a9jx9v";
  };

  buildInputs = [ oathToolkit ];

  dontBuild = true;

  patchPhase = ''
    sed -i -e 's|OATH=\$(which oathtool)|OATH=${oathToolkit}/bin/oathtool|' otp.bash
  '';

  installFlags = [ "PREFIX=$(out)"
                   "BASHCOMPDIR=$(out)/share/bash-completion/completions"
                 ];

  meta = with stdenv.lib; {
    description = "A pass extension for managing one-time-password (OTP) tokens";
    homepage = "https://github.com/tadfisher/pass-otp";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jwiegley tadfisher toonn ];
    platforms = platforms.unix;
  };
}
