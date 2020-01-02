{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, cryptsetup
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "unstable-2020-1-2";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = "e7049a281a63e3f72f83b720eb44ccb0c65ed4e1";
    sha256 = "007ay6y3hpha72b9dffr6if8164l5k26341ra83cq754jnh72s54";
  };

  cargoSha256 = "0393r7qglfqym1264ggr0kr9952wjc031gggs1rrqzl3rm3pmgsc";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cryptsetup ];

  meta = with stdenv.lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = [ maintainers.mmahut ];
  };
}

