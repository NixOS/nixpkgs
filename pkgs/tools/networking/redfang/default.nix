{ lib, stdenv, fetchFromGitLab, fetchpatch, bluez }:

stdenv.mkDerivation rec {
  pname = "redfang";
  version = "2.5";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = pname;
    rev = "upstream/${version}";
    sha256 = "sha256-dF9QmBckyHAZ+JbLr0jTmp0eMu947unJqjrTMsJAfIE=";
  };

  patches = [
    # make install rule
    (fetchpatch {
      url = "https://gitlab.com/kalilinux/packages/redfang/-/merge_requests/1.diff";
      sha256 = "sha256-oxIrUAucxsBL4+u9zNNe2XXoAd088AEAHcRB/AN7B1M=";
    })
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  buildInputs = [ bluez ];

  meta = with lib; {
    description = "A small proof-of-concept application to find non discoverable bluetooth devices";
    homepage = "https://gitlab.com/kalilinux/packages/redfang";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
  };
}
