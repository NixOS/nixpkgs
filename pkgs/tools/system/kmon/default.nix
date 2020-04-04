{ stdenv, fetchFromGitHub, rustPlatform, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zsgyigr6k0zqhhv0icpvvfij7r7fj0l2f77i5zh1vyb89pni50h";
  };

  cargoSha256 = "15lj6ryll24xdmv8gil04prhcri2d3b1rxqjrwx70blfrlvvhxa8";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ libxcb ];

  meta = with stdenv.lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
