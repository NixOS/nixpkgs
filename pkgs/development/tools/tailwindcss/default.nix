{ lib, fetchurl, system, stdenv, runCommand, tailwindcss-bin }:

let
  pname = "tailwindcss";
  version = "3.2.4";

  archs = {
    x86_64-linux = {
      archStr = "linux-x64";
      sha256 = "15hj95qdx7z3gdmhb3826h98296rk18j2yi0y0w55l8brdbyflnd";
    };
    aarch64-linux = {
      archStr = "linux-arm64";
      sha256 = "14icqfc5s3dalxa0pp481aj4i1nvcv0rnxhpv92k7mlfldrf80vk";
    };
    aarch64-darwin = {
      archStr = "macos-arm64";
      sha256 = "1p6gqpj718dfkgz6l6carrca65zlfyj8dayjnbdbh59mblqs6q86";
    };
    x86_64-darwin = {
      archStr = "macos-x64";
      sha256 = "02xc6q6pjkqc5vq6wby1sv3bnjjkjycg64khidccwx595dl95gzy";
    };
  };
  srcFor = urlpart: fetchurl {
    url = "https://github.com/tailwindlabs/tailwindcss/releases/download/v${version}/tailwindcss-${urlpart.archStr}";
    inherit (urlpart) sha256;
  };

  src = srcFor archs.${system} or (throw "tailwind has not been packaged for ${system} yet.");
in

stdenv.mkDerivation {
  inherit pname version src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/tailwindcss
    chmod 755 $out/bin/tailwindcss
  '';

  passthru.tests.helptext = runCommand "tailwindcss-test-helptext" { } ''
    ${tailwindcss-bin}/bin/tailwindcss --help > $out
  '';

  meta = with lib; {
    description = "Command-line tool for the CSS framework with composable CSS classes";
    homepage = "https://tailwindcss.com/blog/standalone-cli";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ tfc ];
    platforms = builtins.attrNames archs;
  };
}
