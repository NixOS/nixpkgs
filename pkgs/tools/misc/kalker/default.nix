{ lib
, fetchFromGitHub
, gcc
, gmp, mpfr, libmpc
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NnX4+VmV4oZg/8Z3ZCWHGZ6dqDfvH30XErnrvKMxyls=";
  };

  cargoSha256 = "sha256-nSLbe3EhcLYylvyzOWuLIehBnD6mMofsNpFQVEybV8k=";

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
