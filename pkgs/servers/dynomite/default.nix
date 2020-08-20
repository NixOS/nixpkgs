{ fetchFromGitHub, stdenv, autoreconfHook, libressl, git }:
stdenv.mkDerivation rec {
  pname = "dynomite";
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "Scriptkiddi";
    repo = "dynomite";
    rev = "v${version}";
    sha256 = "1m2w7xfcapjx32265cnvysk4c03ns206bsg2l153vhb8r5lqn40c";
  };

  buildInputs = [ libressl ];
  nativeBuildInputs = [ autoreconfHook git ];
  NIX_CFLAGS_COMPILE = [
    "-Wformat"
  ];

  meta = with stdenv.lib; {
    description = "A generic dynamo implementation for different k-v storage engines";
    homepage = "https://github.com/Netflix/dynomite";
    platforms = platforms.linux;
    # checking build system type... config/config.guess: unable to guess system type
    broken = stdenv.hostPlatform.isAarch64;
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
