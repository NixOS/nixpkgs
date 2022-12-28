{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "uefi-run";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Richard-W";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fwzWdOinW/ECVI/65pPB1shxPdl2nZThAqlg8wlWg/g=";
  };

  cargoSha256 = "sha256-c+wzMzTkG0FpfQ1rZ8e9dn0ez12vmoecrtNeFk90sdQ=";

  meta = with lib; {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = licenses.mit;
    maintainers = [ maintainers.maddiethecafebabe ];
  };
}
