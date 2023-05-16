{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "snabb";
<<<<<<< HEAD
  version = "2023.06";
=======
  version = "2023.04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "snabbco";
    repo = "snabb";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-MLEBT1UpyFiIGqI9W2bw2I2j4JanJ0MAV8nwcL/1QBM=";
=======
    sha256 = "sha256-6STKoDARQ6Ue/ckd3kdIH+ZKnQ4iozx4a070g2N+XMo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    mkdir -p $out/bin
    cp src/snabb $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/SnabbCo/snabbswitch";
    description = "Simple and fast packet networking toolkit";
    longDescription = ''
      Snabb Switch is a LuaJIT-based toolkit for writing high-speed
      packet networking code (such as routing, switching, firewalling,
      and so on). It includes both a scripting inteface for creating
      new applications and also some built-in applications that are
      ready to run.
      It is especially intended for ISPs and other network operators.
    '';
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = [ maintainers.lukego ];
  };
}
