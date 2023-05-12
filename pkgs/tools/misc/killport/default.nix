{ lib
, rustPlatform
, fetchCrate
, llvmPackages
}:
rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ip7Ndy4i4P6n20COfSL/EtG1Y+xoab8Gox4gcNHH1/o=";
  };

  cargoSha256 = "sha256-M4riyvGueCQDKOj+lgYPm2lZ8UjCp1y/SyG692vZbS4=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = with lib; {
    description = "A command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = licenses.mit;
    maintainers = with maintainers; [ sno2wman ];
  };
}
