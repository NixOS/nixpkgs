{ stdenv
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "018qzbgmgm0f0d0c7i54nqqjbr4k5mzy1xfavi6hpifjll971wci";
  };

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "14l11rhi55nwy6h51idikx3agxvjf6fjkjh83l6bdxh3zb1gk8pc";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
