{
  lib,
  stdenv,
  fetchFromGitHub,
  oath-toolkit,
}:

stdenv.mkDerivation rec {
  pname = "pass-otp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tadfisher";
    repo = "pass-otp";
    rev = "v${version}";
    sha256 = "0cpqrf3939hcvwg7sd8055ghc8x964ilimlri16czzx188a9jx9v";
  };

  buildInputs = [ oath-toolkit ];

  dontBuild = true;

  patchPhase = ''
    sed -i -e 's|OATH=\$(which oathtool)|OATH=${oath-toolkit}/bin/oathtool|' otp.bash
  '';

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
  ];

<<<<<<< HEAD
  meta = {
    description = "Pass extension for managing one-time-password (OTP) tokens";
    homepage = "https://github.com/tadfisher/pass-otp";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Pass extension for managing one-time-password (OTP) tokens";
    homepage = "https://github.com/tadfisher/pass-otp";
    license = licenses.gpl3;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      jwiegley
      tadfisher
      toonn
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
