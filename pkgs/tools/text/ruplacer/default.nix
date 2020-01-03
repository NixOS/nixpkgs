{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yj753d9wsnp4s5a71ph241jym5rfz3161a1v3qxfc4w23v86j1q";
  };

  cargoSha256 = "1lzw4x40j25khf68x5srj8i05c11ls5y7km206vxn19vsy9ah4k9";

  buildInputs = (stdenv.lib.optional stdenv.isDarwin Security);

  meta = with stdenv.lib; {
    description = "Find and replace text in source files";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
