{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "convimg";
<<<<<<< HEAD
  version = "9.2";
=======
  version = "9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-37nJyaUyC5aQ4h3sH+s8XOzyLh6zfzgIEDp+M6SERSg=";
=======
    sha256 = "sha256-lcd9IL/xV6O81/HqZW+nA2eZXUbwS8nJ1jmjqVs8BR0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convimg $out/bin/convimg
  '';

  meta = with lib; {
    description = "Image palette quantization";
    longDescription = ''
      This program is used to convert images to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convimg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
