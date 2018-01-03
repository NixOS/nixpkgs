{ stdenv, pass, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "pass-otp";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "f2feb3082324a91089782af9b7fbb71d34aa213d";
    sha256 = "0iklvcfgw1320dggdr02lq3bc7xvnd2934l1w9kkjpbsfmhs955c";
  };

  buildInputs = [ pass ];

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description = "A pass extension for managing one-time-password (OTP) tokens";
    homepage = https://github.com/tadfisher/pass-otp;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.unix;
  };
}
