{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:
rustPlatform.buildRustPackage {
  pname = "rblake3sum";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "rustshop";
    repo = "rblake3sum";
    rev = "6a8e2576ccc05214eacb75b75a9d4cfdf272161c";
    hash = "sha256-UFk6SJVA58WXhH1CIuT48MEF19yPUe1HD+ekn4LDj8g=";
  };

  cargoHash = "sha256-SE/Zg/UEV/vhB/VDcn8Y70OUIoxbJBh6H2QgFMkWPc4=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A recursive blake3 digest (hash) of a file-system path";
    homepage = "https://github.com/rustshop/rblake3sum";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ dpc ];
    mainProgram = "rblake3sum";
  };
}
