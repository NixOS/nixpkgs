{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cshatag";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ez8zGVX10A7xuggkh3n7w/qzda8f4t6EgSc9l6SPEZQ=";
  };

  vendorSha256 = "sha256-QTnwltsoyUbH4vob5go1KBrb9gwxaaPNW3S4sxVls3k=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    # Install man page
    install -D -m755 -t $out/share/man/man1/ cshatag.1
  '';

  meta = with lib; {
    description = "A tool to detect silent data corruption";
    homepage = "https://github.com/rfjakob/cshatag";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
