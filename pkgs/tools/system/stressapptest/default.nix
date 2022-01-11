{ lib
, stdenv
, fetchFromGitHub
, libaio
}:

stdenv.mkDerivation rec {
  pname = "stressapptest";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1qzj6h6adx042rb9aiz916jna269whibvj5ys4p5nwdp17fqh922";
  };

  buildInputs = [ libaio ];

  meta = with lib; {
    description = "Userspace memory and IO stress test tool";
    homepage = "https://github.com/stressapptest/stressapptest";
    license = with licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
