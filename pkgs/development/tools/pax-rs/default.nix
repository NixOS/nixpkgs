{ stdenv, fetchFromGitHub, fetchurl, rustPlatform, runCommand } :
with rustPlatform;

buildRustPackage rec {
  name = "pax-rs-${version}";
  version = "0.4.0";

  meta = with stdenv.lib; {
    description = "The fastest JavaScript bundler in the galaxy.";
    longDescription = ''
      The fastest JavaScript bundler in the galaxy. Fully supports ECMAScript module syntax (import/export) in addition to CommonJS require(<string>).
    '';
    homepage = https://github.com/nathan/pax;
    license = licenses.mit;
    maintainers = [ maintainers.klntsky ];
    platforms = platforms.linux;
  };

  src =
    let
      source = fetchFromGitHub {
        owner = "nathan";
        repo = "pax";
        rev = "pax-v${version}";
        sha256 = "1l2xpgsms0bfc0i3l0hyw4dbp6d4qdxa9vxyp704p27vvn4ndhv2";
      };

      cargo-lock = fetchurl {
        url = "https://gist.github.com/klntsky/c7863424d7df0c379782015f6bb3b399/raw/1cf7481e33984fd1510dc77ed677606d08fa8eb6/Cargo.lock";
        sha256 = "0ff1b64b99cbca1cc2ceabcd2e4f7bc3411e3a2a9fbb9db2204d9240fe38ddeb";
      };
    in
    runCommand "pax-rs-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock} $out/Cargo.lock
    '';

  cargoSha256 = "0sdk090sp89vgwz5a71f481a5sk13kcqb29cx1dslfq59sp4j6y7";
}
