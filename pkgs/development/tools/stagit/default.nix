{ lib, stdenv, libgit2, fetchgit }:

stdenv.mkDerivation rec {
  pname = "stagit";
  version = "0.9.4";

  src = fetchgit {
    url = "git://git.codemadness.org/stagit";
    rev = version;
    sha256 = "1n0f2pf4gmqnkx4kfn2c79zx2vk4xkg03h7wvdigijkkbhs7a3pm";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libgit2 ];

  meta = with lib; {
    description = "git static site generator";
    homepage = "https://git.codemadness.org/stagit/file/README.html";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
