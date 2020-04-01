{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, perl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = version;
    sha256 = "1p4ddyqg1v27hf19n1ksmfvj5s6z2c8i13syb0anhlyzqy576hwb";
  };

  cargoSha256 = "0mdcj4almwziq1ph3imfdx41a96xq19sbjm7wsm9lxlzhvv256br";

  nativeBuildInputs = [ installShellFiles perl ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installManPage ${pname}.1
  '';

  meta = with lib; {
    description = "The fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Edu4rdSHL/findomain";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
