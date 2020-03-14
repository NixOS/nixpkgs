{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "conftest";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "189as930fksyqk3z636gyqdym1bqm522mya7msfnhzpnh46k5jvd";
  };

  modSha256 = "0gm08lrlaxc7504mapjdm3c4mwlzybnqxfwkkh6fawzvmd9sqddr";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with stdenv.lib; {
    description = "Write tests against structured configuration data";
    homepage = "https://github.com/instrumenta/conftest";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
