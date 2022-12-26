{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, libev
, openssl
}:
stdenv.mkDerivation {
  pname = "mbidled";
  version = "unstable-2022-10-30";

  src = fetchFromGitHub {
    owner = "zsugabubus";
    repo = "mbidled";
    rev = "b06152f015a470876b042e538804ebb1ac247c09";
    sha256 = "sha256-eHm10onJ7v6fhvJiGXZhuN3c9cj+NoVIW2XQb2fdmuA=";
  };

  preConfigure = ''
    export LIBRARY_PATH=${libev}/lib
  '';

  nativeBuildInputs = [
    meson ninja
  ];

  buildInputs = [
    libev openssl
  ];

  meta = with lib; {
    description = "run command on mailbox change";
    homepage = "https://github.com/zsugabubus/mbidled";
    license = licenses.unlicense;
    maintainers = with maintainers; [ laalsaas ];
    platforms = platforms.linux;
  };
}
