{ stdenv, lib, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ht-rust";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "ht";
    rev = "v${version}";
    sha256 = "cr/iavCRdFYwVR6Iemm1hLKqd0OFG1iDmxpQ9fiwOmU=";
  };

  cargoSha256 = "uB23/9AjPwCwf9ljE8ai7zJQZqE0SoBPzRqqBOXa9QA=";

  buildInputs = [ ] ++ lib.optional stdenv.isDarwin Security;

  # Symlink to avoid conflict with pre-existing ht package
  postInstall = ''
    ln -s $out/bin/ht $out/bin/ht-rust
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/ht-rust --help > /dev/null
  '';

  meta = with lib; {
    description = "Yet another HTTPie clone in Rust";
    homepage = "https://github.com/ducaale/ht";
    license = licenses.mit;
    maintainers = [ maintainers.payas ];
  };
}
