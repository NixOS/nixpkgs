{ stdenv
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "0340xp7q6f0clb7wmqpgllllwsixmsy37k1f5kj3hwvb730rz93x";
  };

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "0rp4f6xnwmvf3pv6h0qwsg01jrndf77yn67675ac39kxzmrzfy2f";

  meta = with stdenv.lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
