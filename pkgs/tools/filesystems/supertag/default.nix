{ lib, rustPlatform, fetchFromGitHub
, clang, llvmPackages, pkg-config
, dbus, fuse, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "supertag";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "amoffat";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jzm7pn38hlr96n0z8gqfsfdbw48y0nnbsgjdq7hpgwmcgvgqdam";
  };

  cargoSha256 = "1mzmp1jcxgn2swp52r9y7k09fk0z67i1qafzkkzlfxxd10vfr70v";

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  nativeBuildInputs = [ clang pkg-config ];
  buildInputs = [ dbus fuse sqlite ];

  # The test are requiring extended permissions.
  doCheck = false;

  meta = with lib; {
    description = "A tag-based filesystem";
    longDescription = ''
      Supertag is a tag-based filesystem, written in Rust, for Linux and MacOS.
      It provides a tag-based view of your files by removing the hierarchy
      constraints typically imposed on files and folders. In other words, it
      allows you to think about your files not as objects stored in folders, but
      as objects that can be filtered by folders.
    '';
    homepage = "https://github.com/amoffat/supertag";
    license = licenses.agpl3Plus;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ oxzi ];
  };
}
