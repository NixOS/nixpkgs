{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    # prefix, because just "0.3.6' causes the download to silently fail:
    # $ curl -v https://github.com/blacknon/hwatch/archive/0.3.6.tar.gz
    # ...
    # < HTTP/2 300
    # ...
    # the given path has multiple possibilities: #<Git::Ref:0x00007fbb2e52bed0>, #<Git::Ref:0x00007fbb2e52ae40>
    rev = "refs/tags/${version}";
    sha256 = "sha256-uaAgA6DWwYVT9mQh55onW+qxIC2i9GVuimctTJpUgfA=";
  };

  cargoSha256 = "sha256-Xt3Z6ax3Y45KZhTYMBr/Rfx1o+ZAoPYj51SN5hnrXQM=";

  meta = with lib; {
    homepage = "https://github.com/blackmon/hwatch";
    description= "Modern alternative to the watch command";
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ hamburger1984 ];
    platforms = platforms.linux;
  };
}
