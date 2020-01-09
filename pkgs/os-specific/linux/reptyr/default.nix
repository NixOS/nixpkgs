{ stdenv, lib, fetchFromGitHub, fetchpatch, python2 }:

stdenv.mkDerivation rec {
  version = "0.7.0";
  pname = "reptyr";

  src = fetchFromGitHub {
    owner = "nelhage";
    repo = "reptyr";
    rev = "reptyr-${version}";
    sha256 = "1hnijfz1ab34j2h2cxc3f43rmbclyihgn9x9wxa7jqqgb2xm71hj";
  };

  patches = [
    # Fix tests hanging
    (fetchpatch {
      url = "https://github.com/nelhage/reptyr/commit/bca3070ac0f3888b5d37ee162505be81b3b496ff.patch";
      sha256 = "0w6rpv9k4a80q0ijzdq5hlpr37ncr284piqjv5agy8diniwlilab";
    })
  ];

  makeFlags = [ "PREFIX=" "DESTDIR=$(out)" ];

  checkInputs = [ (python2.withPackages (p: [ p.pexpect ])) ];
  doCheck = true;

  meta = {
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "i686-freebsd"
      "x86_64-freebsd"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7l-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.mit;
    description = "Reparent a running program to a new terminal";
    homepage = https://github.com/nelhage/reptyr;
  };
}
