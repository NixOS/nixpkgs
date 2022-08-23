{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, libtool
, zlib
, cunit
}:
stdenv.mkDerivation rec {
  pname = "dcap";
  version = "2.47.12";

  src = fetchFromGitHub {
    owner = "dCache";
    repo = "dcap";
    rev = version;
    sha256 = "sha256-pNLEN1YLQGMJNuv8n6bec3qONbwNOYbYDDvkwuP5AR4=";
  };

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ zlib ];

  preConfigure = ''
    patchShebangs bootstrap.sh
    ./bootstrap.sh
  '';

  doCheck = true;

  checkInputs = [ cunit ];

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "dCache access protocol client library";
    homepage = "https://github.com/dCache/dcap";
    changelog = "https://github.com/dCache/dcap/blob/master/ChangeLog";
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    mainProgram = "dccp";
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
