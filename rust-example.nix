with import <nixpkgs> { };

buildRustPackage {
  name = "filet-rs";
  src = fetchgit {
    url = "https://github.com/madjar/filet-rs.git";
    rev = "09c75cf58e160df792a0de8fbe279a3bc347cf4d";
    sha256 = "dbc75b683b6f9f7d9c771d69ff723a4c561556cb8a33f6ae6d516455bd0f8ae2";
  };
  sha256 = "0iggmhnsl9w1j9q81h1wwhvayy7cmfgz2v3kl8z2r91qi284plw5";
  buildInputs = [ SDL2 ];
}
