{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "quich";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "Usbac";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n9c01q2v6g9wnmxp248yclhp8cxclnj0yyn1qrvjsn6srcpr22c";
  };

  doCheck = true;

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "The advanced terminal calculator";
    longDescription = ''
      Quich is a compact, fast, powerful and useful calculator for your terminal
      with numerous features, supporting Windows and Linux Systems,
      written in ANSI C.
    '';
    homepage = "https://github.com/Usbac/quich";
    license = licenses.mit;
    maintainers = [ maintainers.xdhampus ];
    platforms = platforms.all;
  };
}
