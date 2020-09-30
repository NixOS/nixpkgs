{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = pname;
    rev = version;
    sha256 = "rDcJ5XF7L13MKZ8/J4sYD+UqC+HkZvxRtDkY9IVLH50=";
  };

  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

  cargoSha256 = "XeX6QM0a628mcaptNZkKAvDnGfW5tx+aWNBpMyjz44M=";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = licenses.mit;
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.unix;
  };
}

