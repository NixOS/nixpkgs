{ lib
, fetchFromGitHub
, gcc
, gmp, mpfr, libmpc
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1iZvp30/V0bw9NBxiKNiDgOMYJkDsGhTGdBsAPggdEg=";
  };

  cargoSha256 = "sha256-fBWnMlOLgwrOBPS2GIfOUDHQHcMMaU5r9JZVMbA+W58=";

  # https://gitlab.com/tspiteri/gmp-mpfr-sys/-/issues/20
  nativeBuildInputs = [ gcc ];
  buildInputs = [ gmp mpfr libmpc ];

  outputs = [ "out" "lib" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  CARGO_FEATURE_USE_SYSTEM_LIBS = "1";

  meta = with lib; {
    homepage = "https://kalker.strct.net";
    changelog = "https://github.com/PaddiM8/kalker/releases/tag/v${version}";
    description = "A command line calculator";
    longDescription = ''
      A command line calculator that supports math-like syntax with user-defined
      variables, functions, derivation, integration, and complex numbers
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
