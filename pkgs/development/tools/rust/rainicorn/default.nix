{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rainicorn-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "RustDT";
    repo = "Rainicorn";
    rev = "0f8594079a7f302f4940cc4320f5e4f39f95cdc4";
    sha256 = "07vh4g120sx569wkzclq91blkkd7q7z582pl8vz0li1l9ij8md01";
  };

  depsSha256 = "1ckrf77s1glrqi0gvrv9wqmip4i97dk0arn0iz87jg4q2wfss85k";

  meta = with stdenv.lib; {
    description = "Rust IDEs.  parse-analysis";
    homepage = https://github.com/RustDT/Rainicorn;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
  };
}
