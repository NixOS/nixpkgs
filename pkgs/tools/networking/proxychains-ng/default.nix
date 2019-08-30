{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "proxychains-ng";
  version = "4.14";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = "proxychains-ng";
    rev = "e895fb713ac1c1e92ee0795645f220573181c6fb";
    sha256 = "03wk2xpxwc7kwlq6z9jf9df1vlh6p0dn0kf826fh1k7nfaa8c4py";
  };
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/rofl0r/proxychains-ng;
    changelog = "https://github.com/rofl0r/proxychains-ng/tree/v${version}";
    license = licenses.gpl2;
    platforms = platforms.unix;
    description = "Proxifier";
  };
}
