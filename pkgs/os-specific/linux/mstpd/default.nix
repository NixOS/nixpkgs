{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mstpd";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1xkfydxljdnj49p5r3mirk4k146428b6imfc9bkfps9yjn64mkgb";
  };

  patches = [
    (fetchpatch {
      name = "fix-strncpy-gcc9.patch";
      url = "https://github.com/mstpd/mstpd/commit/d27d7e93485d881d8ff3a7f85309b545edbe1fc6.patch";
      sha256 = "19456daih8l3y6m9kphjr7pj7slrqzbj6yacnlgznpxyd8y4d86y";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--prefix=$(out)"
    "--sysconfdir=$(out)/etc"
    "--sbindir=$(out)/sbin"
    "--libexecdir=$(out)/lib"
  ];

  meta = with lib; {
    description = "Multiple Spanning Tree Protocol daemon";
    homepage = "https://github.com/mstpd/mstpd";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
