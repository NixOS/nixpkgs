{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "0bw83l3s7yraxiwbwcm0nfqqhv2dkd208qz7nm89whzdjzf340gj";
  };

  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoSha256 = "11ywms0vgrm4ildsgl99agjimk5f3l56hlr5aa70kagxam4k6vmn";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.unix;
  };
}

